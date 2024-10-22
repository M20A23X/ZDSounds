// ------------------------------------------------------------------------------//
// //
// Модуль звукового управления                                             //
// (c) DimaGVRH, Dnepr city, 2019                                          //
// //
// ------------------------------------------------------------------------------//
unit SoundManager;

interface

type

// Init
procedure InitSoundManager(loco: String; axesAmt: Integer);

// Specific
procedure HandleSignals(const signal: byte; signalEntity: TSound; locoDir: String; id: string); overload;
procedure HandleSignals(const signal: byte; isTifon: Boolean = False); overload;

procedure Handle3SL2mSounds(speed: TValue<Double>);

procedure HandleTPSounds(frontTP: TValue<Integer>; backTP: TValue<Integer>);

procedure HandleMiscSounds(rb: TValue<byte>; rbs: TValue<byte>; km395: TValue<byte>; km254: TValue<Single>;
  epk: TValue<Boolean>; km1: TValue<Integer>; reostat: TValue<byte>; voltage: TValue<Single>;
  locoWithSndReversor: Boolean; locoSndReversorType: byte; reversor: TValue<Integer>; stochist: TValue<Single>;
  stochistDGR: TValue<Double>);

procedure HandleKMReversSounds(kmState: TValue<TKMStateIDEnum>; kmOP: TValue<Single>);

procedure HandlePneumaticSounds(km395: TValue<byte>; km254: TValue<Single>; tm: TValue<Single>; ur: TValue<Single>;
  nap: TValue<Single>; dt: TValue<Single>; tc: TValue<Single>);

procedure HandleBrakeSounds(tc: Double; dt: Double; speed: Double; EDTAmperage: Double);

procedure HandleTEDSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);

procedure HandleReduktorSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; speed: Double);

procedure HandleMVSounds(ramState: TValue<byte>; prefix: String = '');

procedure HandleMKSounds(ramState: TValue<Single>; prefix: String = '1'; isLoco: Boolean = False);

procedure HandleNatureSounds(rain: TValue<byte>; track: Integer; outsideLocoStatus: byte);

procedure HandlePRSSounds(var prevIdx: byte);

// procedure HandleMVPitch();

// Aux
function checkOnStation(track: Integer): Boolean;

var
  SAUTChannelZvonok: Cardinal;

  // Channels
  Sounds: TDictionary<String, TSound>;
  hodovaya: THodovaya;

  // Vstrech
  Vstrech: TVstrech;

implementation

uses Bass, UnitMain, SysUtils, ExtraUtils, RAMMemModule, bass_fx;

const
  DFF = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DCF = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  BSL = BASS_SAMPLE_LOOP;

  // Init

procedure InitSoundManager(loco: String; axesAmt: Integer);
begin
  Sounds := TDictionary<String, TSound>.Create();
  ReadEntities(Sounds, 'common');
  ReadEntities(Sounds, loco);

  // Our
  hodovaya.brake.getInit('brakes', 2);
  hodovaya.ezda.getInit('ezda');
  hodovaya.shum.getInit('shum');
  SetLength(hodovaya.perestuk.queue, axesAmt);
  hodovaya.perestuk.queueSize := 0;
  for var j := 0 to axesAmt - 1 do
    hodovaya.perestuk.queue[j].sound.getInit('perestuk', 8);

  // Vstrech
  Vstrech.Init();
end;

// Sounds
procedure TSound.getInit(id: string; channels: byte = 1; states: byte = 0; timers: byte = 0);
begin
  if Sounds.ContainsKey(id) then
  begin
    Sounds.TryGetValue(id, self);

    if self.channels = nil then
    begin
      self.id := id;

      SetLength(self.channels, channels);
      for var i := 0 to channels - 1 do
        self.channels[i].attrs.volume := self.entity.volume;

      if (self.states = nil) and (states <> 0) then
      begin
        SetLength(self.states, states);
        for var i := 0 to states - 1 do
          self.states[i] := False;
      end;

      if (self.timers = nil) and (timers <> 0) then
      begin
        SetLength(self.timers, timers);
        for var i := 0 to timers - 1 do
          self.timers[i] := 0;
      end;
    end;
  end;
end;

procedure TSound.restart(idx: byte; FileName: String; flags: byte = 0);
begin
  if (length(channels) > idx) and (FileName <> '') then
  begin
    self.free(idx);

    self.channels[idx].default := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DCF);
    self.channels[idx].tempo := BASS_FX_TempoCreate(self.channels[idx].default, BASS_FX_FREESOURCE);

    BASS_ChannelFlags(self.channels[idx].tempo, flags, flags);
    self.updateAttrs(idx);

    BASS_ChannelPlay(self.channels[idx].tempo, False);
  end;
end;

procedure TSound.pause(idx: byte);
begin
  if (length(channels) > idx) then
    BASS_ChannelPause(self.channels[idx].tempo);
end;

procedure TSound.resume(idx: byte);
begin
  if (length(channels) > idx) then
    BASS_ChannelPlay(self.channels[idx].tempo, False);
end;

procedure TSound.updateAttrs(idx: byte; check: Boolean = False);
begin
  if (check = False) or self.check(idx) then
  begin
    var
      panCoeff: Double := 0.8;
    var
      volumeCoeff: Double := 1;
    var
      zoomDist: Double := 0;

      // Camera fix
    var
      cameraEntity: TCoord;
    cameraEntity.x := camera.current.x;
    cameraEntity.y := camera.current.y;
    cameraEntity.z := camera.current.z;

    var
    camAngleZ := camera.current.aZ;

    if camera.current.x <= -1.35 then
      cameraEntity.x := 1.78 * (camera.current.x + 1.24)
    else if (-1.35 < camera.current.x) and (camera.current.x <= 1.35) then
      cameraEntity.x := -0.2
    else if camera.current.x > 1.35 then
    begin
      cameraEntity.x := camera.current.x;
      cameraEntity.x := -1 / (cameraEntity.x - 2.3) - 1.25;
    end;

    var
      soundEntity: TCoord;
    soundEntity.x := self.entity.coords.x;
    soundEntity.y := self.entity.coords.y;
    soundEntity.z := self.entity.coords.z;

    // Window-open-based volume
    if (self.entity.env <> camera.current.env) and (self.entity.env <> ENV_MASH) then
    begin
      if (WindowsOpenState.current[0] = False) and (WindowsOpenState.current[1] = False) then
        volumeCoeff := 0.6
      else if (WindowsOpenState.current[0] = False) or (WindowsOpenState.current[1] = False) then
        volumeCoeff := 0.8
    end;

    var
      cameraVector: TCoord;
    case camera.current.env of
      ENV_CAB:
        if (self.entity.env = ENV_LOCO) or (self.entity.env = ENV_COM) then
        begin
          // Window-open-based pan
          soundEntity.y := 6;
          soundEntity.x := 8.55 + Abs(self.entity.coords.y);
          if cameraEntity.x <= 0.5 then
            soundEntity.x := -8.55 - Abs(self.entity.coords.y);

          var
          panShiftSign := 0;
          var
          panShiftCoeff := 0;
          if WindowsOpenState.current[0] xor WindowsOpenState.current[1] then
          begin
            if WindowsOpenState.current[1] then
            begin
              soundEntity.x := -8.55 - Abs(self.entity.coords.y);
              panShiftSign := -1;
              panShiftCoeff := 1;
            end
            else if WindowsOpenState.current[0] then
            begin
              soundEntity.x := 8.55 + Abs(self.entity.coords.y);
              panShiftSign := 1;
              panShiftCoeff := 2;
            end;

            panCoeff := 0.3 + 0.7 * exp(-0.5 * power(panShiftSign * cameraEntity.x - panShiftCoeff, 2));
          end
          else
            panCoeff := 1 - exp(-2 * power(cameraEntity.x - 0.5, 2));
        end
        else if (self.entity.env = ENV_MASH) then
          volumeCoeff := 0.5;
      ENV_LOCO:
        begin
          zoomDist := camera.current.zoom;
          camAngleZ := camAngleZ - 15 * Pi / 180;
          cameraEntity.x := -zoomDist * sin(camAngleZ);
          cameraEntity.y := -zoomDist * cos(camAngleZ);
        end;
      ENV_COM:
        zoomDist := Sign(cameraVector.x) * camera.current.zoom + consist.length;
    end;

    cameraVector.x := sin(camAngleZ);
    cameraVector.y := cos(camAngleZ);

    var
      soundVector: TCoord;
    soundVector.x := cameraEntity.x - soundEntity.x;
    soundVector.y := cameraEntity.y - soundEntity.y;

    var
    soundVectorLen := Sqrt(power(soundVector.x, 2) + power(soundVector.y, 2));

    // Normalization
    soundVector.x := soundVector.x / soundVectorLen;
    soundVector.y := soundVector.y / soundVectorLen;

    // Pan
    var
    vectorMult := (cameraVector.x - soundVector.x) * -soundVector.y - (cameraVector.y - soundVector.y) * -soundVector.x;
    self.channels[idx].attrs.pan := panCoeff * vectorMult;

    // Volume
    var
    volumeArg := power(soundVectorLen + zoomDist, 2);
    var
    volume := volumeCoeff * self.channels[idx].attrs.volume *
      (0.01 * exp(-1E-7 * volumeArg) + 0.99 * exp(-1E-5 * volumeArg));
    if self.channels[idx].attrs.volume < 0 then
      self.channels[idx].attrs.volume := 0;

    BASS_ChannelSetAttribute(self.channels[idx].tempo, BASS_ATTRIB_VOL, self.channels[idx].attrs.volume);
    BASS_ChannelSetAttribute(self.channels[idx].tempo, BASS_ATTRIB_TEMPO, self.channels[idx].attrs.tempo);
    BASS_ChannelSetAttribute(self.channels[idx].tempo, BASS_ATTRIB_TEMPO_PITCH, self.channels[idx].attrs.pitch);
    BASS_ChannelSetAttribute(self.channels[idx].tempo, BASS_ATTRIB_PAN, self.channels[idx].attrs.pan);
  end;
end;

function TSound.check(idx: byte; isPlaying: Boolean = True): Boolean;
begin
  if length(channels) <> 0 then
  begin
    if isPlaying then
      Result := (BASS_ChannelIsActive(channels[idx].default) <> 0) or (BASS_ChannelIsActive(channels[idx].tempo) <> 0)
    else
      Result := (BASS_ChannelIsActive(channels[idx].default) = 0) and (BASS_ChannelIsActive(channels[idx].tempo) = 0);
  end;
end;

procedure TSound.update();
begin
  for var i := 0 to length(self.channels) - 1 do
  begin
    self.updateAttrs(i, True);
    Sounds.AddOrSetValue(self.id, self);
  end;
end;

procedure TSound.free(idx: byte);
begin
  if length(channels) <> 0 then
  begin
    BASS_ChannelStop(self.channels[idx].default);
    BASS_StreamFree(self.channels[idx].default);
    BASS_ChannelStop(self.channels[idx].tempo);
    BASS_StreamFree(self.channels[idx].tempo);
    Sounds.AddOrSetValue(self.id, self);
  end;
end;

// Specific

// Signals
procedure HandleSignals(const signal: byte; signalEntity: TSound; locoDir: String; id: string);

var
  knSignals: TSound;
  pathRoot: String;

begin
  pathRoot := 'TWS/Consist/' + locoDir + '/' + id + '-';

  knSignals.getInit('kn-signals');

  if signal = 1 then
  begin
    if signalEntity.states[0] = False then
    begin
      if locoDir = consist.loco then
        knSignals.restart(0, 'TWS/Consist/Common/kn-press.wav');
      signalEntity.states[0] := True;
      signalEntity.restart(0, pathRoot + 'start.wav');
    end
    else if signalEntity.check(0, False) then
      signalEntity.restart(0, pathRoot + 'loop.wav', BSL);
  end
  else if signalEntity.states[0] then
  begin
    if locoDir = consist.loco then
      knSignals.restart(0, 'TWS/Consist/Common/kn-release.wav');
    signalEntity.states[0] := False;
    signalEntity.restart(0, pathRoot + 'stop.wav');
  end;
end;

procedure HandleSignals(const signal: byte; isTifon: Boolean = False);
var
  signalEntity: TSound;
  id: String;
begin
  id := 'svistok';
  if isTifon = True then
    id := 'tifon';
  signalEntity.getInit(id, 1, 1);
  HandleSignals(signal, signalEntity, consist.loco, id);
end;

// 3SL2m
procedure Handle3SL2mSounds(speed: TValue<Double>);
var
  entity: TSound;
  soundFile: String;
begin
  entity.getInit('skorostemer', 5);

  if (GetAsyncKeyState(9) <> 0) and (prevKeyTAB = 0) then
  begin
    entity.restart(0, 'TWS/belt_pul.wav');
    prevKeyTAB := 1;
  end
  else if GetAsyncKeyState(9) = 0 then
  begin
    prevKeyTAB := 0;
    entity.free(0);
  end;

  // 3СЛ2м
  if entity.check(1, False) then
    entity.restart(1, 'TWS/Devices/3SL2M/clock.wav');

  soundFile := 'TWS/Devices/3SL2M/';

  if (speed.current <= 0) and entity.check(2) then
    entity.free(2)
  else if (speed.current > 1) and (speed.current <= 2) and ((speed.previous <= 1) or entity.check(2, False)) then
    entity.restart(2, soundFile + 'start.wav', BSL)
  else if (speed.current > 2) and ((speed.previous <= 2) or entity.check(2, False)) then
    entity.restart(2, soundFile + 'loop.wav', BSL);
end;

// TPs
procedure HandleTPSounds(frontTP: TValue<Integer>; backTP: TValue<Integer>);
var
  entity: TSound;
  soundFile: String;
begin
  if frontTP.current <> frontTP.previous then
  begin
    entity.getInit('tp-front');

    if (frontTP.current = 63) then
      soundFile := 'TWS/CHS7/TPUp.wav'
    else if (frontTP.current <> 63) and (frontTP.previous = 63) and (frontTP.previous <> 188) then
      soundFile := 'TWS/CHS7/TPDown.wav';

    entity.restart(0, soundFile);
  end;

  if backTP.current <> backTP.previous then
  begin
    entity.getInit('tp-back');

    if (backTP.current = 63) and (backTP.current <> backTP.previous) then
      soundFile := 'TWS/CHS7/TPUp.wav'
    else if (backTP.current <> 63) and (backTP.previous = 63) and (backTP.previous <> 188) then
      soundFile := 'TWS/CHS7/TPDown.wav';

    entity.restart(0, soundFile);
  end;
end;

// Clicks
procedure HandleMiscSounds(rb: TValue<byte>; rbs: TValue<byte>; km395: TValue<byte>; km254: TValue<Single>;
  epk: TValue<Boolean>; km1: TValue<Integer>; reostat: TValue<byte>; voltage: TValue<Single>;
  locoWithSndReversor: Boolean; locoSndReversorType: byte; reversor: TValue<Integer>; stochist: TValue<Single>;
  stochistDGR: TValue<Double>);
var
  soundFile: String;
  rbsEntity: TSound;
  epkEntity: TSound;
  rn1Entity: TSound;
  rn2Entity: TSound;
  stochist1Entity: TSound;
  stochist2Entity: TSound;
  reversKey: Char;
begin
  // RB-RBS 0
  if (rb.current <> rb.previous) or (rbs.current <> rbs.previous) then
  begin
    rbsEntity.getInit('kn-rb', 2);

    if rb.current = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if rb.current = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    rbsEntity.restart(0, soundFile);

    if rbs.current = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if rbs.current = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    rbsEntity.restart(1, soundFile);
  end;

  // ЭПК 1
  if epk.current <> epk.previous then
  begin
    epkEntity.getInit('kn-epk');
    epkEntity.restart(0, 'TWS/epk.wav');
  end;

  // РЕЛЕ НАПРЯЖЕНИЯ 2
  if (voltage.previous = 0) and (voltage.current <> 0) then
  begin
    rn1Entity.getInit('rn1');
    rn1Entity.getInit('rn2');
    rn1Entity.restart(0, 'TWS/CHS7/rn.wav');
    rn2Entity.restart(0, 'TWS/CHS7/rn.wav');
  end;

  // СТЕКЛОЧИСТИТЕЛЬ 3 4
  if stochist.current <> stochist.previous then
  begin
    stochist1Entity.getInit('stochist1', 2);
    stochist2Entity.getInit('stochist2', 2);

    if stochist.current = 4 then
    begin
      stochist1Entity.restart(0, 'TWS/stochist.wav', BSL);
      stochist2Entity.restart(0, 'TWS/stochist.wav', BSL);
    end
    else if stochist.current = 8 then
    begin
      stochist1Entity.restart(0, 'TWS/stochist2.wav', BSL);
      stochist2Entity.restart(0, 'TWS/stochist2.wav', BSL);
    end
    else
    begin
      stochist1Entity.free(0);
      stochist1Entity.free(1);
      stochist2Entity.free(0);
      stochist2Entity.free(1);
    end;
  end;

  if (stochist.current = 8) and ((stochistDGR.current > 120) and (stochistDGR.previous <= 120)) or
    ((stochistDGR.current < 55) and (stochistDGR.previous >= 55)) then
  begin
    stochist1Entity.restart(1, 'stochist_udar.wav');
    stochist2Entity.restart(1, 'stochist_udar.wav');
  end;
end;

procedure HandleKMReversSounds(kmState: TValue<TKMStateIDEnum>; kmOP: TValue<Single>);
var
  km: TSound;
  revers: TSound;
  soundFile: String;
begin
  if reversor.current <> 0 then
  begin
    // РЕВЕРСИВКА 0
    if locoWithSndReversor then
    begin
      if (locoSndReversorType = 1) and (km1.current = 0) and (reversor.current <> reversor.previous) or
        (locoSndReversorType = 0) and (reversor.current <> reversor.previous) then
      begin
        revers.getInit('revers', 1);
        revers.restart(0, 'TWS/CHS7/revers.wav');
      end;
    end;

    // ЭМЗ 1
    if (km1.previous = 0) and (km1.current > 0) or (km1.current = 0) and (km1.previous > 0) or
      (reostat.current + reostat.previous = 1) then
    begin
      km.getInit('km', 2);
      km.restart(0, 'TWS/Devices/21KR/EM_zashelka.wav');
    end;

    // KM 1
    if (kmOP.current > 0) or (kmOP.previous > 0) then
    begin
      if (kmOP.current <> kmOP.previous) then
      begin
        if (kmOP.current > 0) then
          soundFile := 'op+-.wav'
        else if (kmOP.current = 0) and (kmOP.previous > 0) then
          soundFile := 'op_vivod.wav';
      end;
      km.getInit('km', 2);
      km.restart(1, 'TWS/Devices/21KR/' + soundFile);
    end
    else if (kmState.current <> kmState.previous) then
    begin
      if (kmState.previous <> KM_AM) and (kmState.previous <> KM_AP) and
        ((kmState.current = KM_P) or (kmState.current = KM_M)) then
        soundFile := '0_+-.wav'
      else if (kmState.current = KM_AM) and (kmState.previous <> KM_AM) or (kmState.current = KM_AP) and
        (kmState.previous <> KM_AP) then
        soundFile := '0_+-A.wav'
      else if ((kmState.previous = KM_AM) or (kmState.previous = KM_AP)) then
        soundFile := '+-A_0.wav'
      else if (kmState.current = KM_N) and ((kmState.previous = KM_P) or (kmState.previous = KM_M)) then
        soundFile := '+-_0.wav';

      if soundFile <> '' then
      begin
        const
          isPrevKMKeyEQ = (kmState.previous = KM_M) or (kmState.previous = KM_AM);
        if isPrevKMKeyEQ and km.check(1, False) or (isPrevKMKeyEQ = False) then
        begin
          km.getInit('km', 2);
          km.restart(1, 'TWS/Devices/21KR/' + soundFile);
        end;
      end;
    end;
  end;
end;

// Pneumatics

// Zaryadka 1
procedure HandleZaryadkaSound(var entity: TSound; km395: byte; tm: TValue<Single>; nap: TValue<Single>);
var
  tmCoeff: Double;
  napCoeff: Double;
begin
  if IsCombinedOpened and (km395 = 1) then
  begin
    tmCoeff := 100 * Abs(tm.current - tm.previous);
    if tmCoeff <> 0 then
    begin
      napCoeff := 0.111 * nap.current;

      entity.channels[1].attrs.volume := 0.5 * napCoeff * ln(tmCoeff + 1);
      entity.channels[1].attrs.tempo := 100 * entity.channels[1].attrs.volume;
      entity.channels[1].attrs.pitch := 0.3 * entity.channels[1].attrs.volume;

      if entity.check(1, False) then
        entity.restart(1, 'TWS/395_zaryadka.wav', BSL);
    end;
  end
  else if entity.check(1) then
    entity.free(1);
end;

// Vipusk 2
procedure HandleVipuskSound(var entity: TSound; var timer: Integer; tm: TValue<Single>);
var
  tmCoeff: Double;
  timerCoeff: Double;
begin
  tmCoeff := tm.current - tm.previous;

  if tmCoeff < -0.005 then
  begin
    timer := 30;

    entity.channels[2].attrs.volume := ln(5 * Abs(tmCoeff) + 1);
    entity.channels[2].attrs.tempo := 100 * entity.channels[2].attrs.volume;
    entity.channels[2].attrs.pitch := 0.4 * entity.channels[2].attrs.volume;

    if entity.check(2, False) then
      entity.restart(2, 'TWS/395_vypusk.wav', BSL);
  end
  else if timer <= 10 then
  begin
    timerCoeff := 0.1 * timer;

    entity.channels[2].attrs.volume := entity.channels[2].attrs.volume * timerCoeff;
    entity.channels[2].attrs.tempo := entity.channels[2].attrs.tempo * timerCoeff;
    entity.channels[2].attrs.pitch := entity.channels[2].attrs.pitch * timerCoeff;

    if (timerCoeff <= 0) and entity.check(2) then
      entity.free(2);
  end;

  Dec(timer);
end;

procedure HandleVpuskSound(var entity: TSound; km395: byte; tm: Single; ur: TValue<Single>; nap: TValue<Single>);
var
  urCoeff: Double;
  tmCoeff: Double;
begin
  if IsCombinedOpened and (km395 >= 2) then
  begin
    urCoeff := ur.current - ur.previous;
    tmCoeff := 1;

    if urCoeff > 0 then
      urCoeff := 0;
    if tm < 5 then
      tmCoeff := exp(-4 * power(tm - 5, 2));

    entity.channels[3].attrs.volume := tmCoeff * exp(-power(20 * urCoeff, 2)) * 0.028 * nap.current *
      (exp(-0.05 * power(Abs(ur.current - tm) - 10, 2)) + 1);
    entity.channels[3].attrs.tempo := 5 * entity.channels[3].attrs.volume;

    if entity.check(3, False) then
      entity.restart(3, 'TWS/395_vpusk.wav', BSL);
  end
  else if entity.check(3) then
    entity.free(3);
end;

procedure HandleTormSound(var entity: TSound; km395: byte; ur: TValue<Single>);
var
  urCoeff: Double;
begin
  if km395 >= 5 then
  begin
    urCoeff := Abs(ur.current - ur.previous);
    if urCoeff <> 0 then
    begin
      entity.channels[4].attrs.volume := 10 * ln(urCoeff + 1);
      entity.channels[4].attrs.tempo := 5 * entity.channels[4].attrs.volume;

      if entity.check(4, False) then
        entity.restart(4, 'TWS/395_torm.wav', BSL);
    end;
  end
  else if entity.check(4) then
    entity.free(4);
end;

procedure HandleDTTCSounds(var entity: TSound; var timer: Integer; var fadeState: Boolean; cylinder: TValue<Single>;
  channelBaseIdx: Integer);
var
  BrakeDelta: Double;
  timerCoeff: Double;
begin
  BrakeDelta := 10 * Abs(cylinder.current - cylinder.previous);

  if (BrakeDelta > 0.05) and (timer >= 0) then
  begin
    if timer > 20 then
    begin
      fadeState := False;
      timerCoeff := 1;
    end
    else if fadeState = False then
      fadeState := True;

    if fadeState then
      timerCoeff := 0.05 * timer + 0.0001;

    entity.channels[channelBaseIdx].attrs.volume := ln(0.278 * cylinder.current * timerCoeff * BrakeDelta + 1);
    entity.channels[channelBaseIdx].attrs.tempo := 100 * entity.channels[channelBaseIdx].attrs.volume;
    entity.channels[channelBaseIdx].attrs.pitch := entity.channels[channelBaseIdx].attrs.volume - 1;

    entity.channels[channelBaseIdx + 1].attrs.volume :=
      0.35 * exp(-0.5 * power(cylinder.current * timerCoeff - 3.6, 2));
    entity.channels[channelBaseIdx + 1].attrs.tempo := 100 * entity.channels[channelBaseIdx + 1].attrs.volume;
    entity.channels[channelBaseIdx + 1].attrs.pitch := entity.channels[channelBaseIdx + 1].attrs.volume;

    if entity.check(channelBaseIdx, False) and entity.check(channelBaseIdx + 1, False) then
    begin
      entity.restart(channelBaseIdx, 'TWS/254_shipenie.wav', BSL);
      entity.restart(channelBaseIdx + 1, 'TWS/254_release.wav', BSL);
    end;
  end
  else if timer < 0 then
  begin
    timerCoeff := 0.05 * (timer + 20) + 0.0001;

    entity.channels[channelBaseIdx].attrs.volume := entity.channels[channelBaseIdx].attrs.volume * timerCoeff;
    entity.channels[channelBaseIdx].attrs.tempo := entity.channels[channelBaseIdx].attrs.tempo * timerCoeff;
    entity.channels[channelBaseIdx].attrs.pitch := entity.channels[channelBaseIdx].attrs.pitch * timerCoeff;

    entity.channels[channelBaseIdx + 1].attrs.volume := entity.channels[channelBaseIdx + 1].attrs.volume * timerCoeff;
    entity.channels[channelBaseIdx + 1].attrs.tempo := entity.channels[channelBaseIdx + 1].attrs.tempo * timerCoeff;
    entity.channels[channelBaseIdx + 1].attrs.pitch := entity.channels[channelBaseIdx + 1].attrs.pitch * timerCoeff;

    if (timer = -20) and entity.check(channelBaseIdx) then
    begin
      entity.free(channelBaseIdx);
      entity.free(channelBaseIdx + 1);
      timer := 0;
    end;
  end;

  if entity.check(channelBaseIdx) or entity.check(channelBaseIdx + 1) then
  begin
    if fadeState and (timer <= 22) then
      Inc(timer, 2)
    else if timer > 20 then
      fadeState := False;

    Dec(timer);
  end;
end;

procedure HandlePneumaticSounds(km395: TValue<byte>; km254: TValue<Single>; tm: TValue<Single>; ur: TValue<Single>;
  nap: TValue<Single>; dt: TValue<Single>; tc: TValue<Single>);
var
  km254Entity: TSound;
  km395Entity: TSound;
begin
  // 254 / 395
  km254Entity.getInit('km254', 3, 1, 1);
  km395Entity.getInit('km395', 7, 1, 2);

  if (km395.current <> km395.previous) and (km395.current <> 1) and (km395.current <> 6) then
    km254Entity.restart(0, 'TWS/stuk395.wav');
  if (km254.current <> km254.previous) and (km254.current <> -1) and (km254.previous <> -1) then
    km395Entity.restart(0, 'TWS/stuk254.wav');

  HandleZaryadkaSound(km395Entity, km395.current, tm, nap);
  HandleVipuskSound(km395Entity, km395Entity.timers[0], tm);
  HandleVpuskSound(km395Entity, km395.current, tm.current, ur, nap);

  if dt.current < dt.previous then
    HandleDTTCSounds(km395Entity, km395Entity.timers[1], km395Entity.states[0], dt, 5);

  HandleTormSound(km395Entity, km395.current, ur);
  HandleDTTCSounds(km254Entity, km254Entity.timers[0], km254Entity.states[0], tc, 1); // 254
end;

// Brakes
procedure HandleBrakeSounds(tc: Double; dt: Double; speed: Double; EDTAmperage: Double);
var
  dttc: Double;
begin
  if ((tc > 0) or (dt > 0)) and (speed > 0) then
  begin
    dttc := tc + dt;

    hodovaya.brake.channels[0].attrs.volume := hodovaya.brake.entity.volume * ln(2 * dttc / (speed + 1) + 1);
    hodovaya.brake.channels[0].attrs.tempo := speed * speed;

    if EDTAmperage <> 0 then
      hodovaya.brake.channels[0].attrs.volume := 0.75 * hodovaya.brake.channels[0].attrs.volume;

    if hodovaya.brake.check(0, False) then
      hodovaya.brake.restart(0, 'TWS/brake_slipp.wav', BSL);

    if speed <= 10 then
    begin
      hodovaya.brake.channels[1].attrs.volume := hodovaya.brake.entity.volume * 0.278 * dttc *
        (1 / ln(speed + 1.2) - 0.3);
      hodovaya.brake.channels[1].attrs.tempo := 50 / (hodovaya.brake.channels[0].attrs.tempo + 0.1);

      if hodovaya.brake.channels[1].attrs.volume > 0.75 then
        hodovaya.brake.channels[1].attrs.volume := 0.75
      else if hodovaya.brake.channels[1].attrs.volume < 0 then
        hodovaya.brake.channels[1].attrs.volume := 0;

      hodovaya.brake.channels[1].attrs := hodovaya.brake.channels[0].attrs;

      if hodovaya.brake.check(1, False) then
        hodovaya.brake.restart(1, 'TWS/brake_scr.wav', BSL);
    end
    else if hodovaya.brake.check(1) then
      hodovaya.brake.free(1);
  end
  else if ((tc <= 0) or (speed <= 0)) and hodovaya.brake.check(0) then
  begin
    hodovaya.brake.free(0);
    hodovaya.brake.free(1);
  end;
end;

// TEDs
procedure HandleTEDSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);
var
  ted1: TSound;
  ted2: TSound;
begin
  if (TEDAmperage > 0.001) or (EDTAmperage > 0.001) then
  begin
    ted1.getInit('ted1');
    ted2.getInit('ted2');

    if TEDAmperage <> 0 then
      ted1.channels[0].attrs.volume := TEDAmperage
    else if EDTAmperage <> 0 then
      ted1.channels[0].attrs.volume := EDTAmperage
    else
      ted1.channels[0].attrs.volume := 0.0;

    ted1.channels[0].attrs.volume := ln(0.25 * ted1.channels[0].attrs.volume / ultimateTEDAmperage + 1);
    ted1.channels[0].attrs.tempo := 10 * ted1.channels[0].attrs.volume - 20;
    ted1.channels[0].attrs.pitch := ted1.channels[0].attrs.volume;

    ted2.channels[0].attrs := ted1.channels[0].attrs;
    ted2.channels[0].attrs.tempo := ted1.channels[0].attrs.tempo + 20;

    if ted1.check(0, False) then
    begin
      ted1.restart(0, 'TWS/' + consist.loco + 'ted.wav', BSL);
      ted2.restart(0, 'TWS/' + consist.loco + 'ted.wav', BSL);
    end;
  end
  else if ted1.check(0) then
  begin
    ted1.getInit('ted1');
    ted2.getInit('ted2');
    ted1.free(0);
    ted2.free(0);
  end;
end;

// Reductors
procedure HandleReduktorSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; speed: Double);
var
  red1: TSound;
  red2: TSound;
begin
  if speed > 0 then
  begin
    red1.getInit('red1');
    red2.getInit('red2');

    red1.channels[0].attrs.volume := red1.entity.volume *
      ln(speed * (0.005 + power(TEDAmperage / ultimateTEDAmperage, 2)) + 1);
    red1.channels[0].attrs.tempo := 10 * red1.channels[0].attrs.volume - 20;
    red1.channels[0].attrs.pitch := 8 * ln(speed) - 30;

    red2.channels[0].attrs := red1.channels[0].attrs;
    red2.channels[0].attrs.volume := red2.entity.volume * red2.channels[0].attrs.volume;
    red2.channels[0].attrs.tempo := red1.channels[0].attrs.tempo + 20;

    if red1.check(0, False) then
    begin
      red1.restart(0, 'TWS/' + consist.loco + '/reduktor.wav', BSL);
      red2.restart(0, 'TWS/' + consist.loco + '/reduktor.wav', BSL);
    end;
  end
  else if red1.check(0) then
  begin
    red1.getInit('red1');
    red2.getInit('red2');
    red1.free(0);
    red2.free(0);
  end;
end;

// Ezda
procedure HandleEzda(var entity: THodovaya; loco: string; speed: Double);
begin
  if (speed >= 3) then
  begin
    entity.ezda.channels[0].attrs.volume := entity.ezda.entity.volume * 0.2 * ln(speed - 3);
    entity.ezda.channels[0].attrs.tempo := 10 * ln(speed + 1) - 30;
    entity.ezda.channels[0].attrs.pitch := 0.4 * ln(speed + 1) - 1;

    if entity.ezda.check(0, False) then
      entity.ezda.restart(0, 'TWS/consist/' + loco + '/ezda.wav', BSL);
  end
  else if entity.ezda.check(0) then
    entity.ezda.free(0);

  if speed >= 3 then
  begin
    entity.shum.channels[0].attrs.volume := entity.ezda.channels[0].attrs.volume;
    entity.shum.channels[0].attrs.tempo := entity.ezda.channels[0].attrs.tempo;
    entity.shum.channels[0].attrs.pitch := entity.ezda.channels[0].attrs.pitch;

    if entity.shum.check(0, False) then
      entity.shum.restart(0, 'TWS/consist/common/shum.wav', BSL);
  end
  else if entity.shum.check(0) then
    entity.shum.free(0);
end;

// Perestuk
procedure HandlePerestuk(var entity: THodovaya; speed: Double; track: TValue<Integer>; consist: TConsist;
  isStaticEntityY: Boolean = False; staticEntityY: Double = 0; ourOrdinateCurrent: Double = 0;
  ourOrdinatePrev: Double = 0);
begin
  if speed >= 3 then
  begin
    var
    queue := entity.perestuk.queue;

    // Timer
    for var j := 0 to entity.perestuk.queueSize - 1 do
    begin
      if queue[j].time > 0 then
        queue[j].time := queue[j].time - 30;
    end;

    // EntityY
    if ourOrdinateCurrent <> ourOrdinatePrev then
    begin
      for var h := 0 to entity.perestuk.queueSize - 1 do
        queue[h].sound.entity.coords.y := queue[h].sound.entity.coords.y + napravSign *
          (ourOrdinatePrev - ourOrdinateCurrent);
    end;

    // LCtrl + Numpad+ or RCtrl + Numpad-
    var
    isTrackChangeKeyPressed := (GetAsyncKeyState(162) + GetAsyncKeyState(163)) *
      (GetAsyncKeyState(107) + GetAsyncKeyState(109)) <> 0;

    // On joint
    if (Abs(track.previous - track.current) > 0) and (track.previous <> 0) and (isTrackChangeKeyPressed = False) and
      (entity.perestuk.queueSize < consist.axesAmt) then
    begin
      if isStaticEntityY then
        entity.perestuk.queue[entity.perestuk.queueSize].sound.entity.coords.y := staticEntityY;
      entity.perestuk.queue[entity.perestuk.queueSize].fileId := 1;
      Inc(entity.perestuk.queueSize);
    end;

    // Sound
    if entity.perestuk.queueSize > 0 then
    begin
      for var k := 0 to entity.perestuk.queueSize - 1 do
      begin
        const
          axisIdx = queue[k].axisIdx;
        var
        channels := queue[k].sound.channels;

        if axisIdx >= consist.axesAmt then
        begin
          queue[k].axisIdx := 0;
          queue[k].time := 0;
          Dec(entity.perestuk.queueSize);
        end
        else if queue[k].time <= 0 then
        begin
          // Sound attrs
          channels[0].attrs.volume := queue[k].sound.entity.volume * exp(-0.05 * power(speed - 10, 2)) *
            exp(-0.007 * power(speed - 30, 2));
          channels[0].attrs.tempo := 10 * ln(speed + 1) - 20;
          channels[0].attrs.pitch := 0.1 * channels[0].attrs.tempo;

          if channels[0].attrs.pitch > 55 then
            channels[0].attrs.pitch := 55;

          // Play
          var
          soundDir := 'common';
          if axisIdx < consist.locoUnit.axesAmount then
            soundDir := consist.loco;

          if soundDir = 'common' then
            for var i := 0 to length(queue[k].sound.channels) - 1 do
            begin
              if queue[k].sound.check(i, False) then
              begin
                queue[k].sound.restart(i, 'TWS/consist/' + soundDir + '/perestuk/stuk' + entity.perestuk.queue[k]
                  .fileId.ToString() + '.wav');
                break;
              end;
            end;

          // Axis distances
          var
            entityY: Double := 0;
          var
            axisDist: Double := 0;
          if axisIdx < consist.locoUnit.axesAmount - 1 then // Loco
          begin
            axisDist := consist.locoUnit.axes[axisIdx];

            if isStaticEntityY = False then
            begin
              entityY := 5.55;
              if axisIdx = 0 then
                queue[k].sound.entity.coords.y := entityY;
              for var m := 0 to axisIdx do
                entityY := entityY - 0.001 * consist.locoUnit.axes[m];
            end;
          end
          else if (axisIdx = consist.locoUnit.axesAmount - 1) and (consist.wagonUnit.axesAmount > 0) then // Loco-Wagon
          begin
            axisDist := consist.locoUnit.axes[consist.locoUnit.axesAmount - 1] + consist.wagonUnit.axes
              [consist.wagonUnit.axesAmount - 1];
            if isStaticEntityY = False then
              entityY := 5.55 - 0.001 *
                (consist.locoUnit.length + consist.wagonUnit.axes[consist.wagonUnit.axesAmount - 1]);
          end
          else if axisIdx > consist.locoUnit.axesAmount - 1 then // Wagons
          begin
            var
            wagonAxisIdx := (axisIdx - consist.locoUnit.axesAmount) Mod consist.wagonUnit.axesAmount;
            if wagonAxisIdx = 3 then
              axisDist := 2 * consist.wagonUnit.axes[consist.wagonUnit.axesAmount - 1]
            else
              axisDist := consist.wagonUnit.axes[wagonAxisIdx];

            if isStaticEntityY = False then
            begin
              entityY := 5.5 - 0.001 * (consist.locoUnit.length + consist.wagonUnit.length *
                Trunc((axisIdx - consist.locoUnit.axesAmount) / consist.wagonUnit.axesAmount));
              for var m := 0 to wagonAxisIdx do
                entityY := entityY - 0.001 * consist.wagonUnit.axes[m];
            end;
          end;

          // Misc
          if isStaticEntityY = False then
            queue[k].sound.entity.coords.y := entityY;

          Inc(entity.perestuk.queue[k].axisIdx);
          entity.perestuk.queue[k].time := Trunc(3.6 * axisDist / speed);
        end;
      end;
    end;
  end;
end;

// MV
procedure HandleMVSounds(ramState: TValue<byte>; prefix: String = '');
var
  mv1Mash: TSound;
  mv1: TSound;
  mv2: TSound;
  pathRoot: String;
begin
  if ramState.current <> ramState.previous then
  begin
    mv1Mash.getInit('mv' + prefix + '1-cab', 1, 1);
    mv1.getInit('mv' + prefix + '1');
    mv2.getInit('mv' + prefix + '2');

    pathRoot := 'TWS/' + consist.loco + 'mv' + prefix + '-';

    if ramState.current = 1 then
    begin
      if mv1Mash.states[0] = False then
      begin
        mv1Mash.states[0] := True;
        mv2.channels[0].attrs.tempo := 10;

        mv1Mash.restart(0, pathRoot + 'start.wav');
        mv1.restart(0, pathRoot + 'x-start.wav');
        mv2.restart(0, pathRoot + 'x-start.wav');
      end
      else if mv1Mash.check(0, False) then
      begin
        mv1Mash.restart(0, pathRoot + 'loop.wav');
        mv1.restart(0, pathRoot + 'x-loop.wav', BSL);
        mv2.restart(0, pathRoot + 'x-loop.wav', BSL);
      end;
    end
    else
    begin
      if mv1Mash.states[0] then
      begin
        mv1Mash.states[0] := False;
        mv1Mash.restart(0, pathRoot + 'stop.wav');
        mv1.restart(0, pathRoot + 'x-stop.wav');
        mv2.restart(0, pathRoot + 'x-stop.wav');
      end
      else if mv1Mash.check(0, False) then
      begin
        mv1Mash.free(0);
        mv1.free(0);
        mv2.free(0);
      end;
    end;
  end;
end;

// MK
procedure HandleMKSounds(ramState: TValue<Single>; prefix: String = '1'; isLoco: Boolean = False);
var
  mk: TSound;
  pathRoot: String;
begin
  if ramState.current <> ramState.previous then
  begin
    pathRoot := locoWorkDir + 'mk-';
    if isLoco then
      pathRoot := pathRoot + 'x-'
    else
      prefix := prefix + '-cab';

    mk.getInit('mk' + prefix, 1, 1);

    if ramState.current = 1 then
    begin
      if mk.states[0] = False then
      begin
        mk.states[0] := True;
        mk.restart(0, pathRoot + 'start.wav');
      end
      else if mk.check(0, False) then
        mk.restart(0, pathRoot + 'loop.wav', BSL);
    end
    else
    begin
      if mk.states[0] then
      begin
        mk.states[0] := False;
        mk.restart(0, pathRoot + 'stop.wav');
      end
      else if mk.check(0, False) then
        mk.free(0);
    end;
  end;
end;

//
// procedure HandleMVPitch();
// begin
// if LocoWithMVPitch then
// begin
// var
// deltaMVPitch := MVsPitchIncrementer * MainCycleFreq;
//
// if MVAttrs[A_PITCH] > MVsPitchDest then
// MVAttrs[A_PITCH] := MVAttrs[A_PITCH] - deltaMVPitch
// else if MVAttrs[A_PITCH] < MVsPitchDest then
// MVAttrs[A_PITCH] := MVAttrs[A_PITCH] + deltaMVPitch;
//
// SetChannelAttributes(MVsFX[0], MVAttrs);
// SetChannelAttributes(MVsFX[1], MVAttrs);
// SetChannelAttributes(MVsFX[2], MVAttrs);
// end;
//
// if LocoWithMVTDPitch then
// begin
// var
// deltaMVTDPitch := MVsTDPitchIncrementer * MainCycleFreq;
//
// if mvTDAttrs[A_PITCH] > MVsTDPitchDest then
// mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] - deltaMVTDPitch
// else if MVsTDPitch < MVsTDPitchDest then
// mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] + deltaMVTDPitch;
//
// SetChannelAttributes(MVsTDFX[0], mvTDAttrs);
// SetChannelAttributes(MVsTDFX[1], mvTDAttrs);
// SetChannelAttributes(MVsTDFX[2], mvTDAttrs);
// end;
// end;

// Misc
procedure HandleNatureSounds(rain: TValue<byte>; track: Integer; outsideLocoStatus: byte);
var
  nature: TSound;
  FileName: String;
begin
  if Winter = 0 then
  begin
    if rain.current >= 80 then
      rain.current := Trunc(0.0125 * rain.current)
    else if rain.current > 0 then
      rain.current := 1;

    if rain.current <> rain.previous then
    begin
      Case rain.current Of
        1:
          FileName := 'TWS/storm.wav';
        2:
          FileName := 'TWS/storm1.wav';
        3:
          FileName := 'TWS/storm2.wav';
      end;
      nature.getInit('nature');
      if (nature.check(0, False)) then
        nature.restart(0, FileName, BSL)
    end;

    if track = 0 then
      rain.current := 0;
    if rain.current = 0 then
      nature.free(0);
  end
  else if outsideLocoStatus <> 0 then
  begin
    nature.getInit('nature');
    if GetAsyncKeyState(37) + GetAsyncKeyState(39) <> 0 then
      nature.restart(0, 'TWS/snow_walk.wav', BSL)
    else if nature.check(0) then
      nature.free(0);
  end;
end;

procedure HandlePRSSounds(var prevIdx: byte);
var
  prs: TSound;
  idx: Integer;
  Country: Integer;
begin
  randomize;
  repeat
    idx := random(5);
  until (idx <> prevIdx) and (idx <> 0);
  prevIdx := idx;

  prs.getInit('prs', 1);
  prs.restart(0, 'TWS/PRS/UA_' + idx.ToString() + '.mp3');
end;

// Is on station check
function checkOnStation(track: Integer): Boolean;
var
  check: Boolean;
begin
  check := False;
  for var k := 0 to StationCount - 1 do
    if (stations[k].startTrack < track) and (track < stations[k].endTrack) then
    begin
      check := True;
      break;
    end;
  Result := check;
end;

end.
