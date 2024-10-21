// ------------------------------------------------------------------------------//
// //
// Модуль звукового управления                                             //
// (c) DimaGVRH, Dnepr city, 2019                                          //
// //
// ------------------------------------------------------------------------------//
unit SoundManager;

interface

uses Classes, Math;

type
  TCameraEnum = (CAM_CAB, CAM_LOCO, CAM_COM);
  TKMStateEnum = (KM_AP = 2, KM_P = 1, KM_N = 0, KM_M = 255, KM_AM = 254);

  TChannelIDEnum = (C_FILE, C_FX, C_CAM);
  TFX = array [TChannelIDEnum] of Cardinal;
  TSoundAttrIDEnum = (A_VOLUME, A_TEMPO, A_PITCH);
  TSoundAttrs = array [TSoundAttrIDEnum] of Double;

  TPerestukStackAttrEnum = (P_AXIS_IDX, P_TIME, P_ID);
  TPerestukStack = array of array [TPerestukStackAttrEnum] of Integer;
  TSignals = array [0 .. 1, 0 .. 1] of TFX;

  TPneumaticIDEnum = (PN_ZAR, PN_VP, PN_VIP, PN_TORM, PN_DT, PN_TC);
  TPneumaticsFX = array [TPneumaticIDEnum] of array [0 .. 1] of TFX;
  TPneumaticsAttrs = array [TPneumaticIDEnum] of array [0 .. 1] of TSoundAttrs;
  TPneumaticsAux<T> = array [TPneumaticIDEnum] of T;

  TValueID = (V_CUR, V_PRV);
  TValue<T> = array [TValueID] of T;

procedure SoundManagerTick();

// Play
procedure PlaySound(FileName: String; soundEnv: TCameraEnum; flags: Integer = 0);

// Check
function CheckChannel(channels: TFX; isInv: Boolean = True): Boolean;

// Update
procedure UpdateChannel(var FX: TFX); overload;
procedure UpdateChannel(var FX: TFX; const attrs: TSoundAttrs); overload;
procedure UpdateChannel(var FXs: array of TFX); overload;

// Free
procedure FreeChannel(var channels: TFX);

// Specific

procedure HandleSignals(signalIdx: Integer; const signals: array of Byte);

procedure HandleKLUBSounds(ogrSpeed: TValue<WORD>; nextOgrSpeed: TValue<Byte>; var nextOgrPeekStatus: Byte;
  Speed: Double; svetofor: TValue<Byte>; var prevKeyTAB: Byte; klubOpen: Byte);

procedure Handle3SL2mSounds(rb: TValue<Byte>; rbs: TValue<Byte>; Speed: TValue<Double>);

procedure HandleTPSounds(locoWithSndTP: Boolean; frontTP: TValue<Integer>; backTP: TValue<Integer>);

procedure HandleClickSounds(km395: TValue<Byte>; km294: TValue<Single>; epk: TValue<Boolean>; km1: TValue<Integer>;
  reostat: TValue<Byte>; voltage: TValue<Single>; locoWithSndReversor: Boolean; locoSndReversorType: Byte;
  reversor: TValue<Integer>; stochist: TValue<Single>; stochistDGR: TValue<Double>);

procedure HandleKMSounds(kmState: TValue<TKMStateEnum>; kmOP: TValue<Single>);

procedure HandlePneumaticSounds(km395: Byte; tm: TValue<Single>; ur: TValue<Single>; nap: TValue<Single>;
  dt: TValue<Single>; tc: TValue<Single>);

procedure HandleBrakeSounds(tc: Double; dt: Double; Speed: Double; EDTAmperage: Double);

procedure HandleTEDSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);

procedure HandleReduktorSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; Speed: Double);

procedure HandleEzda(Speed: Double);

procedure HandlePerestuk(Speed: Double; track: TValue<Integer>; axesAmount: Integer;
  axesDistancesWagon: array of Integer; axesDistancesLoco: array of Integer; axesLocoAmount: Integer);

procedure HandleVstrech(vstrechStatus: TValue<Byte>; track: Integer; vstrTrack: TValue<WORD>; MP: Byte;
  vstrSpeed: Single; wagNumVstr: Integer; vstrechaDlina: Integer; TrackVstrechi: Integer);

procedure HandleMVSounds(ramState: Byte; var state: Boolean; prefix: String = '');
procedure HandleMKSounds(ramState: array of Single);

procedure HandleMVPitch();

procedure HandleMiscSounds(rain: TValue<Byte>; track: Integer; outsideLocoStatus: Byte);

procedure HandlePRSSounds(isRZDChecked: Boolean; isUZChecked: Boolean);

var
  SAUTChannelObjects: Cardinal; // Канал для звуков САУТ объекты (1)
  SAUTChannelObjects2: Cardinal; // Канал для звуков САУТ объекты (2)
  SAUTChannelZvonok: Cardinal;

  PRSChannel: Cardinal; // Канал для звуков ПРС
  Vstrech: Cardinal; // Канал для звука встречного поезда

  // Files
  RevPosF: PChar;
  TEDFile: PChar;
  ReduktorFile: PChar;
  LocoFTemp: PChar;
  WagF: PChar;
  dizF: PChar; // Файлы дизелей
  VIPF: PChar; // Файлы ВИП (ЭП1м и 2ЭС5к)
  SAUTF: PChar;
  SAUTOFFF: PChar;
  PRSF: PChar;
  RBF: PChar;
  IMRZashelka: PChar;
  VstrechF: PChar;
  VentTDF: PChar;
  LocoPowerEquipmentF: PChar; // Силовое оборудование локомотива(БВ, ФР)
  XVentTDF: PChar;
  BrakeF: PChar;
  SAVPEInfoF: PChar;
  TrogF: PChar; // Удар сцепки на МВПС
  WalkSoundF: PChar;
  NatureF: PChar;
  ReduktorF: PChar;
  Brake254F: PChar;
  CycleBrake254F: PChar;
  VR242F: PChar;

  // Flags
  isPlaySAUTObjects: Boolean; // Флаг для воспроизведения режима автоведения САУТ
  isPlaySAUTZvonok: Boolean;
  isPlaySAVPEPeek: Boolean;
  isPlaySAVPEInfo: Boolean;
  isPlaySAVPEZvonok: Boolean; // Флаг для воспроизведения звука трения колодок при торможении
  isPlayVstrech: Boolean;

  // Signals-Tifon
  SignalChannels: TSignals;
  SignalStates: array [0 .. 1] of Boolean;

  // Reduktor
  ReduktorsFX: array [0 .. 1] of TFX;
  ReduktorAttrs: TSoundAttrs = (0, 0, 0);

  // TEDs
  TEDsFX: array [0 .. 1] of TFX;
  TEDAttrs: TSoundAttrs = (0, 0, 0);

  // MV-MK
  MVChannelsState: Boolean;
  MVsFX: array [0 .. 2] of TFX;
  MVAttrs: TSoundAttrs = (1, 0, 0);

  MVTDChannelsState: Boolean;
  MVsTDFX: array [0 .. 2] of TFX;
  mvTDAttrs: TSoundAttrs = (1, 0, 0);

  MKChannelsState: array [0 .. 1] of Boolean;
  MKsFX: array [0 .. 2] of TFX;
  MKAttrs: TSoundAttrs = (1, 0, 0);

  // Ezda-Shum
  EzdaFX: TFX;
  EzdaAttrs: TSoundAttrs = (0, 0, 0);
  ShumFX: TFX;
  ShumAttrs: TSoundAttrs = (0, 0, 0);

  // Perestuk
  PerestukFX: array of TFX;
  PerestukAttrs: TSoundAttrs = (0, 0, 0);
  PerestukStack: TPerestukStack;
  PerestukStackSize: Integer;

  // Brake slipp + scr
  BrakeFX: TFX;
  BrakeAttrs: TSoundAttrs = (0, 0, 0);
  BrakeScrFX: TFX;
  BrakeScrAttrs: TSoundAttrs = (0, 0, 0);

  // Brake 254
  PneumaticFX: TPneumaticsFX;
  PneumaticAttrs: TPneumaticsAttrs = (((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)),
    ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)));
  PneumaticTimers: TPneumaticsAux<Integer>;
  PneumaticFadeStates: TPneumaticsAux<Boolean>;

  TCTimer: Integer;
  IsTCFadeIn: Boolean;

  // Common sounds
  ChannelsDefault: array [0 .. 3] of TFX; // Short sounds
  ChannelsMisc: array [0 .. 2] of TFX; // Loop sounds

  // 3SL2m
  skorostemerChannel: array [0 .. 2] of TFX;

implementation

uses Bass, UnitMain, SysUtils, Windows, ExtraUtils, bass_fx;

const
  DFF = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DCF = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  BSL = BASS_SAMPLE_LOOP;

  // Check
function CheckChannel(channels: TFX; isInv: Boolean = True): Boolean;
begin
  if isInv then
    Result := (BASS_ChannelIsActive(channels[C_FILE]) <> 0) or (BASS_ChannelIsActive(channels[C_FX]) <> 0)
  else
    Result := (BASS_ChannelIsActive(channels[C_FILE]) = 0) and (BASS_ChannelIsActive(channels[C_FX]) = 0);
end;

// Free
procedure FreeChannel(var channels: TFX);
begin
  BASS_ChannelStop(channels[C_FILE]);
  BASS_StreamFree(channels[C_FILE]);
  BASS_ChannelStop(channels[C_FX]);
  BASS_StreamFree(channels[C_FX]);
end;

// Attr
procedure AdjustVolumeHelper(soundEnv: TCameraEnum; var attrsAdjusted: TSoundAttrs); overload;
begin
  attrsAdjusted[A_VOLUME] := -1;
  if (camera[V_CUR] = 0) and (soundEnv = CAM_LOCO) then
    attrsAdjusted[A_VOLUME] := 0.25
  else if (camera[V_CUR] = 1) and (soundEnv = CAM_CAB) then
    attrsAdjusted[A_VOLUME] := 0.25
  else if (camera[V_CUR] = 2) then
    attrsAdjusted[A_VOLUME] := 0;
end;

procedure AdjustVolumeHelper(soundEnv: TCameraEnum; const attrs: TSoundAttrs; var attrsAdjusted: TSoundAttrs); overload;
begin
  attrsAdjusted[A_VOLUME] := attrs[A_VOLUME];
  attrsAdjusted[A_TEMPO] := attrs[A_TEMPO];
  attrsAdjusted[A_PITCH] := attrs[A_PITCH];

  if (camera[V_CUR] = 0) and (soundEnv = CAM_LOCO) then
    attrsAdjusted[A_VOLUME] := 0.25 * attrs[A_VOLUME]
  else if (camera[V_CUR] = 1) and (soundEnv = CAM_CAB) then
    attrsAdjusted[A_VOLUME] := 0.25 * attrs[A_VOLUME]
  else if (camera[V_CUR] = 2) then
  begin
    if (soundEnv = CAM_CAB) then
      attrsAdjusted[A_VOLUME] := 0
    else if (soundEnv = CAM_LOCO) then
      attrsAdjusted[A_VOLUME] := attrs[A_VOLUME] * (1 - 0.2 * Log10(LocoSectionsAmount * ConsistLength));
  end;
end;

procedure SetChannelAttributes(var channels: TFX; const attrs: TSoundAttrs); overload;
var
  attrsAdjusted: TSoundAttrs;
begin
  AdjustVolumeHelper(TCameraEnum(channels[C_CAM]), attrs, attrsAdjusted);

  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_VOL, attrsAdjusted[A_VOLUME]);
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_TEMPO, attrsAdjusted[A_TEMPO]);
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_TEMPO_PITCH, attrsAdjusted[A_PITCH]);
end;

procedure SetChannelAttributes(var channels: TFX); overload;
var
  attrsAdjusted: TSoundAttrs;
begin
  AdjustVolumeHelper(TCameraEnum(channels[C_CAM]), attrsAdjusted);
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_VOL, attrsAdjusted[A_VOLUME]);
end;

// Update

procedure UpdateChannel(var FXs: array of TFX); overload;
begin
  if (camera[V_CUR] <> camera[V_PRV]) then
    for var i := 0 to Length(FXs) - 1 do
      if CheckChannel(FXs[i]) then
        SetChannelAttributes(FXs[i]);
end;

procedure UpdateChannel(var FX: TFX); overload;
begin
  if (camera[V_CUR] <> camera[V_PRV]) and CheckChannel(FX) then
    SetChannelAttributes(FX);
end;

procedure UpdateChannel(var FX: TFX; const attrs: TSoundAttrs); overload;
begin
  if (camera[V_CUR] <> camera[V_PRV]) and CheckChannel(FX) then
    SetChannelAttributes(FX, attrs);
end;

// Play

procedure RestartChannel(var FX: TFX; FileName: String; soundEnv: TCameraEnum; flags: Integer = 0); overload;
begin
  FreeChannel(FX);

  FX[C_FILE] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DCF);
  FX[C_FX] := BASS_FX_TempoCreate(FX[C_FILE], BASS_FX_FREESOURCE);

  BASS_ChannelFlags(FX[C_FX], flags, flags);
  SetChannelAttributes(FX);

  BASS_ChannelPlay(FX[C_FX], False);
end;

procedure RestartChannel(var FX: TFX; const attrs: TSoundAttrs; FileName: String; soundEnv: TCameraEnum;
  flags: Integer = 0); overload;
begin
  FX[C_CAM] := Cardinal(soundEnv);
  FreeChannel(FX);

  FX[C_FILE] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DCF);
  FX[C_FX] := BASS_FX_TempoCreate(FX[C_FILE], BASS_FX_FREESOURCE);

  BASS_ChannelFlags(FX[C_FX], flags, flags);
  SetChannelAttributes(FX, attrs);

  BASS_ChannelPlay(FX[C_FX], False);
end;

procedure PlaySound(FileName: String; soundEnv: TCameraEnum; flags: Integer = 0);
begin
  if FileName <> '' then
    for var l := 0 to Length(ChannelsDefault) - 1 do
      if CheckChannel(ChannelsDefault[l], False) then
      begin
        RestartChannel(ChannelsDefault[l], FileName, soundEnv, flags);
        break;
      end;
end;



// Specific

// Signals
procedure HandleSignals(signalIdx: Integer; const signals: array of Byte);
var
  signalType: String;
  pathRoot: String;
begin

  signalType := 'svistok';
  if signalIdx = 1 then
    signalType := 'tifon';

  pathRoot := locoWorkDir + signalType + '-';

  if signals[signalIdx] = 1 then
  begin
    if SignalStates[signalIdx] = False then
    begin
      RestartChannel(SignalChannels[signalIdx][0], pathRoot + 'start.wav', CAM_CAB);
      RestartChannel(SignalChannels[signalIdx][1], pathRoot + 'x-start.wav', CAM_LOCO);
      SignalStates[signalIdx] := True;
    end
    else if CheckChannel(SignalChannels[signalIdx][0], False) and CheckChannel(SignalChannels[signalIdx][1], False) then
    begin
      RestartChannel(SignalChannels[signalIdx][0], pathRoot + 'loop.wav', CAM_CAB, BSL);
      RestartChannel(SignalChannels[signalIdx][1], pathRoot + 'x-loop.wav', CAM_LOCO, BSL);
    end;
  end
  else if SignalStates[signalIdx] then
  begin
    RestartChannel(SignalChannels[signalIdx][0], pathRoot + 'stop.wav', CAM_CAB);
    RestartChannel(SignalChannels[signalIdx][1], pathRoot + 'x-stop.wav', CAM_LOCO);
    SignalStates[signalIdx] := False;
  end;

  UpdateChannel(SignalChannels[signalIdx]);
end;

// KLUB-3SL2m
procedure HandleKLUBSounds(ogrSpeed: TValue<WORD>; nextOgrSpeed: TValue<Byte>; var nextOgrPeekStatus: Byte;
  Speed: Double; svetofor: TValue<Byte>; var prevKeyTAB: Byte; klubOpen: Byte);
begin
  // Нажатие РБ и РБС
  if (rb[V_CUR] <> rb[V_PRV]) or (rbs[V_CUR] <> rbs[V_PRV]) then
    PlaySound('TWS/KLUB_pick.wav', CAM_CAB);

  // Пиканья при ограничении
  if (ogrSpeed[V_CUR] - Speed <= 3) and (ogrSpeed[V_CUR] <> 0) and (svetofor[V_CUR] <> 0) then
    PlaySound('TWS/KLUB_pick.wav', CAM_CAB);
  if (ogrSpeed[V_CUR] - Speed > 3) or (ogrSpeed[V_CUR] = 0) then
    PlaySound('TWS/KLUB_pick.wav', CAM_CAB);

  if (GetAsyncKeyState(9) <> 0) and (prevKeyTAB = 0) then
  begin
    RestartChannel(skorostemerChannel[2], 'TWS/belt_pul.wav', CAM_CAB, BSL);
    prevKeyTAB := 1;
  end
  else if GetAsyncKeyState(9) = 0 then
  begin
    prevKeyTAB := 0;
    FreeChannel(skorostemerChannel[2]);
  end;

  // Svetofor change
  if svetofor[V_CUR] <> svetofor[V_PRV] then
    PlaySound('TWS/KLUB_beep.wav', CAM_CAB);

  // Проверка бдительности
  if (VCheck[V_CUR] <> VCheck[V_PRV]) and (VCheck[V_CUR] = 1) then
    PlaySound('TWS/KLUB_beep.wav', CAM_CAB);

  if nextOgrPeekStatus = 0 then
  begin
    if ogrSpeed[V_PRV] > ogrSpeed[V_CUR] then
    begin
      if nextOgrSpeed[V_CUR] <> 0 then
      begin
        PlaySound('TWS/KLUB_beep.wav', CAM_CAB);
        nextOgrPeekStatus := 1;
      end;
    end;
  end;

  if (klubOpen = 1) and (prevKeyLKM = 0) and (GetAsyncKeyState(1) <> 0) then
  begin
    PlaySound('TWS/KLUB_pick.wav', CAM_CAB);
    prevKeyLKM := 1;
  end
  else if GetAsyncKeyState(1) = 0 then
    prevKeyLKM := 0;

  if nextOgrPeekStatus = 1 then
    if (nextOgrSpeed[V_CUR] <> nextOgrSpeed[V_PRV]) or (nextOgrSpeed[V_CUR] = 0) then
      nextOgrPeekStatus := 0;
end;

procedure Handle3SL2mSounds(rb: TValue<Byte>; rbs: TValue<Byte>; Speed: TValue<Double>);
var
  soundFile: String;
begin
  // RB-RBS
  if (rb[V_CUR] <> rb[V_PRV]) or (rbs[V_CUR] <> rbs[V_PRV]) then
  begin
    if rb[V_CUR] = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if rb[V_CUR] = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    PlaySound(soundFile, CAM_CAB);

    if rbs[V_CUR] = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if rbs[V_CUR] = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    PlaySound(soundFile, CAM_CAB);
  end;

  // Звук протяжки ленты по нажатию кл. <TAB>
  if (GetAsyncKeyState(9) <> 0) and (prevKeyTAB = 0) then
  begin
    RestartChannel(skorostemerChannel[2], 'TWS/belt_pul.wav', CAM_CAB, BSL);
    prevKeyTAB := 1;
  end
  else if GetAsyncKeyState(9) = 0 then
  begin
    prevKeyTAB := 0;
    FreeChannel(skorostemerChannel[2]);
  end;

  // 3СЛ2м
  if CheckChannel(skorostemerChannel[0], False) then
    RestartChannel(skorostemerChannel[0], 'TWS/Devices/3SL2M/clock.wav', CAM_CAB, BSL);

  soundFile := 'TWS/Devices/3SL2M/';

  if (Speed[V_CUR] <= 0) and CheckChannel(skorostemerChannel[1]) then
    FreeChannel(skorostemerChannel[1])
  else if (Speed[V_CUR] > 1) and (Speed[V_CUR] <= 3) and
    ((Speed[V_PRV] <= 1) or CheckChannel(skorostemerChannel[1], False)) then
    RestartChannel(skorostemerChannel[1], soundFile + 'start.wav', CAM_CAB, BSL)
  else if (Speed[V_CUR] > 3) and ((Speed[V_PRV] <= 3) or CheckChannel(skorostemerChannel[1], False)) then
    RestartChannel(skorostemerChannel[1], soundFile + 'loop.wav', CAM_CAB, BSL);

  UpdateChannel(skorostemerChannel);
end;

// TPs
procedure HandleTPSounds(locoWithSndTP: Boolean; frontTP: TValue<Integer>; backTP: TValue<Integer>);
var
  soundFile: String;
begin
  if locoWithSndTP then
  begin
    // ПЕРЕДНИЙ
    if (frontTP[V_CUR] = 63) and (frontTP[V_CUR] <> frontTP[V_PRV]) then
      soundFile := 'TWS/TPUp.wav'
    else if (frontTP[V_CUR] <> 63) and (frontTP[V_PRV] = 63) and (frontTP[V_PRV] <> 188) then
      soundFile := 'TWS/TPDown.wav';

    PlaySound(soundFile, CAM_LOCO);

    // ЗАДНИЙ
    if (backTP[V_CUR] = 63) and (backTP[V_CUR] <> backTP[V_PRV]) then
      soundFile := 'TWS/TPUp.wav'
    else if (backTP[V_CUR] <> 63) and (backTP[V_PRV] = 63) and (backTP[V_PRV] <> 188) then
      soundFile := 'TWS/TPDown.wav';

    PlaySound(soundFile, CAM_LOCO);
  end;
end;

// Clicks
procedure HandleClickSounds(km395: TValue<Byte>; km294: TValue<Single>; epk: TValue<Boolean>; km1: TValue<Integer>;
  reostat: TValue<Byte>; voltage: TValue<Single>; locoWithSndReversor: Boolean; locoSndReversorType: Byte;
  reversor: TValue<Integer>; stochist: TValue<Single>; stochistDGR: TValue<Double>);
var
  soundFile: String;
  reversKey: Char;
begin
  // 254 / 395
  if (km395[V_CUR] <> km395[V_PRV]) and (km395[V_CUR] <> 1) and (km395[V_CUR] <> 6) then
    PlaySound('TWS/stuk395.wav', CAM_CAB);

  if (km294[V_CUR] <> km294[V_PRV]) and (km294[V_CUR] <> -1) and (km294[V_PRV] <> -1) then
    PlaySound('TWS/stuk254.wav', CAM_CAB);

  // ЭПК
  if epk[V_CUR] <> epk[V_PRV] then
    PlaySound('TWS/epk.wav', CAM_CAB);

  // ЭМЗ
  if (km1[V_PRV] = 0) and (km1[V_CUR] > 0) or (km1[V_CUR] = 0) and (km1[V_PRV] > 0) or
    (reostat[V_CUR] + reostat[V_PRV] = 1) then
    PlaySound('TWS/Devices/21KR/EM_zashelka.wav', CAM_CAB);

  // РЕЛЕ НАПРЯЖЕНИЯ
  if (voltage[V_PRV] = 0) and (voltage[V_CUR] <> 0) then
    PlaySound('TWS/CHS7/rn.wav', CAM_LOCO);

  // РЕВЕРСИВКА
  if locoWithSndReversor then
  begin
    if (locoSndReversorType = 1) and (km1[V_CUR] = 0) and (reversor[V_CUR] <> reversor[V_PRV]) or
      (locoSndReversorType = 0) and (reversor[V_CUR] <> reversor[V_PRV]) then
      PlaySound('TWS/CHS7/revers.wav', CAM_CAB);
  end;

  // СТЕКЛОЧИСТИТЕЛЬ
  if stochist[V_CUR] <> stochist[V_PRV] then
  begin
    if stochist[V_CUR] = 4 then
      RestartChannel(ChannelsMisc[2], 'TWS/stochist.wav', CAM_CAB, BSL)
    else if stochist[V_CUR] = 8 then
      RestartChannel(ChannelsMisc[2], 'TWS/stochist2.wav', CAM_CAB, BSL)
    else
      FreeChannel(ChannelsMisc[2]);
  end;

  if (stochist[V_CUR] = 8) and ((stochistDGR[V_CUR] > 120) and (stochistDGR[V_PRV] <= 120)) or
    ((stochistDGR[V_CUR] < 55) and (stochistDGR[V_PRV] >= 55)) then
    PlaySound('stochist_udar.wav', CAM_LOCO);
end;

procedure HandleKMSounds(kmState: TValue<TKMStateEnum>; kmOP: TValue<Single>);
var
  soundFile: String;
begin
  if (kmOP[V_CUR] > 0) or (kmOP[V_PRV] > 0) then
  begin
    if (kmOP[V_CUR] <> kmOP[V_PRV]) then
    begin
      if (kmOP[V_CUR] > 0) then
        soundFile := 'op+-.wav'
      else if (kmOP[V_CUR] = 0) and (kmOP[V_PRV] > 0) then
        soundFile := 'op_vivod.wav';
    end;

    PlaySound('TWS/Devices/21KR/' + soundFile, CAM_CAB)
  end
  else if (kmState[V_CUR] <> kmState[V_PRV]) then
  begin
    if (kmState[V_PRV] <> KM_AM) and (kmState[V_PRV] <> KM_AP) and ((kmState[V_CUR] = KM_P) or (kmState[V_CUR] = KM_M))
    then
      soundFile := '0_+-.wav'
    else if (kmState[V_CUR] = KM_AM) and (kmState[V_PRV] <> KM_AM) or (kmState[V_CUR] = KM_AP) and
      (kmState[V_PRV] <> KM_AP) then
      soundFile := '0_+-A.wav'
    else if ((kmState[V_PRV] = KM_AM) or (kmState[V_PRV] = KM_AP)) and (kmState[V_CUR] <> kmState[V_PRV]) then
      soundFile := '+-A_0.wav'
    else if (kmState[V_CUR] = KM_N) and ((kmState[V_PRV] = KM_P) or (kmState[V_PRV] = KM_M)) then
      soundFile := '+-_0.wav';

    if soundFile <> '' then
    begin
      const
        isPrevKMKeyEQ = (kmState[V_PRV] = KM_M) or (kmState[V_PRV] = KM_AM);
      for var l := 0 to Length(ChannelsDefault) - 1 do
        if isPrevKMKeyEQ and CheckChannel(ChannelsDefault[l], False) or (isPrevKMKeyEQ = False) then
        begin
          RestartChannel(ChannelsDefault[l], 'TWS/Devices/21KR/' + soundFile, CAM_CAB);
          break;
        end;
    end;
  end;
end;

// Pneumatics-Brakes

procedure HandleZaryadkaSound(km395: Byte; tm: TValue<Single>; nap: TValue<Single>);
var
  tmCoeff: Double;
  napCoeff: Double;
begin
  if IsCombinedOpened and (km395 = 1) then
  begin
    tmCoeff := 100 * Abs(tm[V_CUR] - tm[V_PRV]);
    if tmCoeff <> 0 then
    begin
      napCoeff := 0.111 * nap[V_CUR];

      PneumaticAttrs[PN_ZAR][0][A_VOLUME] := 0.5 * napCoeff * Ln(tmCoeff + 1);
      PneumaticAttrs[PN_ZAR][0][A_TEMPO] := 100 * PneumaticAttrs[PN_ZAR][0][A_VOLUME];
      PneumaticAttrs[PN_ZAR][0][A_PITCH] := 0.3 * PneumaticAttrs[PN_ZAR][0][A_VOLUME];

      if CheckChannel(PneumaticFX[PN_ZAR][0], False) then
        RestartChannel(PneumaticFX[PN_ZAR][0], PneumaticAttrs[PN_ZAR][0], 'TWS/395_zaryadka.wav', CAM_CAB, BSL);
      SetChannelAttributes(PneumaticFX[PN_ZAR][0], PneumaticAttrs[PN_ZAR][0]);
    end;
  end
  else
    FreeChannel(PneumaticFX[PN_ZAR][0]);

  UpdateChannel(PneumaticFX[PN_ZAR]);
end;

procedure HandleVipuskSound(tm: TValue<Single>);
var
  tmCoeff: Double;
  timerCoeff: Double;
begin
  tmCoeff := tm[V_CUR] - tm[V_PRV];

  if tmCoeff < -0.005 then
  begin
    PneumaticTimers[PN_VIP] := 30;

    PneumaticAttrs[PN_VIP][0][A_VOLUME] := Ln(5 * Abs(tmCoeff) + 1);
    PneumaticAttrs[PN_VIP][0][A_TEMPO] := 100 * PneumaticAttrs[PN_VIP][0][A_VOLUME];
    PneumaticAttrs[PN_VIP][0][A_PITCH] := 0.4 * PneumaticAttrs[PN_VIP][0][A_VOLUME];

    if CheckChannel(PneumaticFX[PN_VIP][0], False) then
      RestartChannel(PneumaticFX[PN_VIP][0], PneumaticAttrs[PN_VIP][0], 'TWS/395_vypusk.wav', CAM_CAB, BSL);
    SetChannelAttributes(PneumaticFX[PN_VIP][0], PneumaticAttrs[PN_VIP][0]);
  end
  else if PneumaticTimers[PN_VIP] <= 10 then
  begin
    timerCoeff := 0.1 * PneumaticTimers[PN_VIP];

    PneumaticAttrs[PN_VIP][0][A_VOLUME] := PneumaticAttrs[PN_VIP][0][A_VOLUME] * timerCoeff;
    PneumaticAttrs[PN_VIP][0][A_TEMPO] := PneumaticAttrs[PN_VIP][0][A_TEMPO] * timerCoeff;
    PneumaticAttrs[PN_VIP][0][A_PITCH] := PneumaticAttrs[PN_VIP][0][A_PITCH] * timerCoeff;

    if PneumaticTimers[PN_VIP] <= 0 then
      FreeChannel(PneumaticFX[PN_VIP][0]);
  end;

  UpdateChannel(PneumaticFX[PN_VIP]);
  Dec(PneumaticTimers[PN_VIP]);
end;

procedure HandleVpuskSound(km395: Byte; tm: TValue<Single>; ur: TValue<Single>; nap: TValue<Single>);
var
  urCoeff: Double;
  tmCoeff: Double;
begin
  if IsCombinedOpened and (km395 >= 2) then
  begin
    urCoeff := ur[V_CUR] - ur[V_PRV];
    tmCoeff := 1;

    if urCoeff > 0 then
      urCoeff := 0;
    if tm[V_CUR] < 5 then
      tmCoeff := Exp(-4 * power(tm[V_CUR] - 5, 2));

    PneumaticAttrs[PN_VP][0][A_VOLUME] := tmCoeff * Exp(-power(20 * urCoeff, 2)) * 0.028 * nap[V_CUR] *
      (Exp(-0.05 * power(Abs(ur[V_CUR] - tm[V_CUR]) - 10, 2)) + 1);
    PneumaticAttrs[PN_VP][0][A_TEMPO] := 5 * PneumaticAttrs[PN_VP][0][A_VOLUME];

    if CheckChannel(PneumaticFX[PN_VP][0], False) then
      RestartChannel(PneumaticFX[PN_VP][0], PneumaticAttrs[PN_VP][0], 'TWS/395_vpusk.wav', CAM_CAB, BSL);
    SetChannelAttributes(PneumaticFX[PN_VP][0], PneumaticAttrs[PN_VP][0]);
  end
  else
    FreeChannel(PneumaticFX[PN_VP][0]);

  UpdateChannel(PneumaticFX[PN_VP]);
end;

procedure HandleTormSound(km395: Byte; ur: TValue<Single>);
var
  urCoeff: Double;
begin
  if km395 >= 5 then
  begin
    urCoeff := Abs(ur[V_CUR] - ur[V_PRV]);
    if urCoeff <> 0 then
    begin
      PneumaticAttrs[PN_TORM][0][A_VOLUME] := 10 * Ln(urCoeff + 1);
      PneumaticAttrs[PN_TORM][0][A_TEMPO] := 5 * PneumaticAttrs[PN_TORM][0][A_VOLUME];

      if CheckChannel(PneumaticFX[PN_TORM][0], False) then
        RestartChannel(PneumaticFX[PN_TORM][0], PneumaticAttrs[PN_TORM][0], 'TWS/395_torm.wav', CAM_CAB, BSL);
      SetChannelAttributes(PneumaticFX[PN_TORM][0], PneumaticAttrs[PN_TORM][0]);
    end;
  end
  else
    FreeChannel(PneumaticFX[PN_TORM][0]);

  UpdateChannel(PneumaticFX[PN_TORM]);
end;

procedure HandleDTTCSounds(pID: TPneumaticIDEnum; cylinder: TValue<Single>);
var
  brakeDelta: Double;
  timerCoeff: Double;
begin
  brakeDelta := 10 * Abs(cylinder[V_CUR] - cylinder[V_PRV]);

  if (brakeDelta > 0.05) and (PneumaticTimers[pID] >= 0) then
  begin
    if PneumaticTimers[pID] > 20 then
    begin
      PneumaticFadeStates[pID] := False;
      timerCoeff := 1;
    end
    else if PneumaticFadeStates[pID] = False then
      PneumaticFadeStates[pID] := True;

    if PneumaticFadeStates[pID] then
      timerCoeff := 0.05 * PneumaticTimers[pID] + 0.0001;

    PneumaticAttrs[pID][0][A_VOLUME] := Ln(0.278 * cylinder[V_CUR] * timerCoeff * brakeDelta + 1);
    PneumaticAttrs[pID][0][A_TEMPO] := 100 * PneumaticAttrs[pID][0][A_VOLUME];
    PneumaticAttrs[pID][0][A_PITCH] := PneumaticAttrs[pID][0][A_VOLUME] - 1;

    PneumaticAttrs[pID][1][A_VOLUME] := 0.35 * Exp(-0.5 * power(cylinder[V_CUR] * timerCoeff - 3.6, 2));
    PneumaticAttrs[pID][1][A_TEMPO] := 100 * PneumaticAttrs[pID][1][A_VOLUME];
    PneumaticAttrs[pID][1][A_PITCH] := PneumaticAttrs[pID][1][A_PITCH];

    if CheckChannel(PneumaticFX[pID][0], False) and CheckChannel(PneumaticFX[pID][1], False) then
    begin
      RestartChannel(PneumaticFX[pID][0], PneumaticAttrs[pID][0], 'TWS/254_shipenie.wav', CAM_CAB, BSL);
      RestartChannel(PneumaticFX[pID][1], PneumaticAttrs[pID][1], 'TWS/254_release.wav', CAM_CAB, BSL);
    end;
  end
  else if (PneumaticTimers[pID] < 0) then
  begin
    timerCoeff := 0.05 * (PneumaticTimers[pID] + 20) + 0.0001;

    PneumaticAttrs[pID][0][A_VOLUME] := PneumaticAttrs[pID][0][A_VOLUME] * timerCoeff;
    PneumaticAttrs[pID][0][A_TEMPO] := PneumaticAttrs[pID][0][A_TEMPO] * timerCoeff;
    PneumaticAttrs[pID][0][A_PITCH] := PneumaticAttrs[pID][0][A_PITCH] * timerCoeff;
    PneumaticAttrs[pID][1][A_VOLUME] := PneumaticAttrs[pID][1][A_VOLUME] * timerCoeff;
    PneumaticAttrs[pID][1][A_TEMPO] := PneumaticAttrs[pID][1][A_TEMPO] * timerCoeff;
    PneumaticAttrs[pID][1][A_PITCH] := PneumaticAttrs[pID][1][A_PITCH] * timerCoeff;

    if PneumaticTimers[pID] = -20 then
    begin
      FreeChannel(PneumaticFX[pID][0]);
      FreeChannel(PneumaticFX[pID][1]);
      PneumaticTimers[pID] := 0;
    end;
  end;

  if CheckChannel(PneumaticFX[pID][0]) or CheckChannel(PneumaticFX[pID][1]) then
  begin
    SetChannelAttributes(PneumaticFX[pID][0], PneumaticAttrs[pID][0]);
    SetChannelAttributes(PneumaticFX[pID][1], PneumaticAttrs[pID][1]);

    if PneumaticFadeStates[pID] and (PneumaticTimers[pID] <= 22) then
      Inc(PneumaticTimers[pID], 2)
    else if PneumaticTimers[pID] > 20 then
      PneumaticFadeStates[pID] := False;

    Dec(PneumaticTimers[pID]);
  end;

  UpdateChannel(PneumaticFX[pID]);
end;

procedure HandlePneumaticSounds(km395: Byte; tm: TValue<Single>; ur: TValue<Single>; nap: TValue<Single>;
  dt: TValue<Single>; tc: TValue<Single>);
begin
  HandleZaryadkaSound(km395, tm, nap);
  HandleVipuskSound(tm);
  HandleVpuskSound(km395, tm, ur, nap);

  if dt[V_CUR] < dt[V_PRV] then
    HandleDTTCSounds(PN_DT, dt);

  HandleTormSound(km395, ur);
  HandleDTTCSounds(PN_TC, tc);
end;

procedure HandleBrakeSounds(tc: Double; dt: Double; Speed: Double; EDTAmperage: Double);
begin
  if ((tc > 0) or (dt > 0)) and (Speed > 0) then
  begin
    const
      dttc = tc + dt;

    BrakeAttrs[A_VOLUME] := 2 * Ln(2 * dttc / Speed + 1);
    BrakeAttrs[A_TEMPO] := Speed * Speed;

    if BrakeAttrs[A_VOLUME] > 0.1 then
      BrakeAttrs[A_VOLUME] := 0.1;

    if EDTAmperage <> 0 then
      BrakeAttrs[A_VOLUME] := 0.125 * BrakeAttrs[A_VOLUME];
    BrakeAttrs[A_TEMPO] := BrakeAttrs[A_VOLUME] / Ln(Speed + 1);

    if CheckChannel(BrakeFX, False) then
      RestartChannel(BrakeFX, BrakeAttrs, 'TWS/brake_slipp.wav', CAM_LOCO, BSL);

    if Speed <= 6 then
    begin
      BrakeScrAttrs[A_VOLUME] := 0.0278 * dttc * (1 / Ln(Speed + 1.1) - 0.55);
      BrakeScrAttrs[A_TEMPO] := 50 / (BrakeAttrs[A_TEMPO] + 0.1);
      if BrakeScrAttrs[A_VOLUME] > 0.75 then
        BrakeScrAttrs[A_VOLUME] := 0.75
      else if BrakeScrAttrs[A_VOLUME] < 0 then
        BrakeScrAttrs[A_VOLUME] := 0;

      if CheckChannel(BrakeScrFX, False) then
        RestartChannel(BrakeScrFX, BrakeScrAttrs, 'TWS/brake_scr.wav', CAM_LOCO, BSL);
    end
    else
      FreeChannel(BrakeScrFX);

    SetChannelAttributes(BrakeFX, BrakeAttrs);
    SetChannelAttributes(BrakeScrFX, BrakeScrAttrs);
  end
  else if ((tc <= 0) or (Speed <= 0)) and (CheckChannel(BrakeFX) or CheckChannel(BrakeScrFX)) then
  begin
    FreeChannel(BrakeFX);
    FreeChannel(BrakeScrFX);
  end;

  UpdateChannel(BrakeFX);
  UpdateChannel(BrakeScrFX);
end;

// TEDs
procedure HandleTEDSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);
begin
  if TEDAmperage <> 0 then
    TEDAttrs[A_VOLUME] := TEDAmperage
  else if EDTAmperage <> 0 then
    TEDAttrs[A_VOLUME] := EDTAmperage
  else
    TEDAttrs[A_VOLUME] := 0.0;
  TEDAttrs[A_VOLUME] := Ln(0.25 * TEDAttrs[A_VOLUME] / ultimateTEDAmperage + 1);

  if (TEDAmperage <> 0) or (EDTAmperage <> 0) then
  begin
    if CheckChannel(TEDsFX[0], False) and CheckChannel(TEDsFX[1], False) then
    begin
      RestartChannel(TEDsFX[0], TEDAttrs, locoWorkDir + TEDFile, CAM_LOCO, BSL);
      RestartChannel(TEDsFX[1], TEDAttrs, locoWorkDir + TEDFile, CAM_LOCO, BSL);
    end;
    SetChannelAttributes(TEDsFX[0], TEDAttrs);
    SetChannelAttributes(TEDsFX[1], TEDAttrs);
  end
  else
  begin
    FreeChannel(TEDsFX[0]);
    FreeChannel(TEDsFX[1]);
  end;

  UpdateChannel(TEDsFX[0], TEDAttrs);
  UpdateChannel(TEDsFX[1], TEDAttrs);
end;

// Reductors
procedure HandleReduktorSounds(TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; Speed: Double);
var
  reduktor2attrs: TSoundAttrs;
begin
  if Speed > 0 then
  begin
    ReduktorAttrs[A_VOLUME] := Ln(Speed * (0.005 + power(TEDAmperage / ultimateTEDAmperage, 2)) + 1);
    ReduktorAttrs[A_PITCH] := 6 * Ln(Speed) - 20;

    reduktor2attrs[A_TEMPO] := ReduktorAttrs[A_TEMPO] + 20;

    if CheckChannel(ReduktorsFX[0], False) and CheckChannel(ReduktorsFX[1], False) then
    begin
      RestartChannel(ReduktorsFX[0], ReduktorAttrs, locoWorkDir + ReduktorFile, CAM_LOCO, BSL);
      RestartChannel(ReduktorsFX[1], ReduktorAttrs, locoWorkDir + ReduktorFile, CAM_LOCO, BSL);
    end;
    SetChannelAttributes(ReduktorsFX[0], ReduktorAttrs);
    SetChannelAttributes(ReduktorsFX[1], ReduktorAttrs);
  end
  else
  begin
    FreeChannel(ReduktorsFX[0]);
    FreeChannel(ReduktorsFX[1]);
  end;

  UpdateChannel(ReduktorsFX[0], ReduktorAttrs);
  UpdateChannel(ReduktorsFX[1], ReduktorAttrs);
end;

// Ezda-Perestuk
procedure HandleEzda(Speed: Double);
var
  lnSpeed: Double;
begin
  lnSpeed := Ln(Speed + 1);

  if (Speed >= 5) then
  begin
    EzdaAttrs[A_VOLUME] := 0.005 * Speed * Ln(Speed - 4);
    EzdaAttrs[A_TEMPO] := 10 * lnSpeed;
    EzdaAttrs[A_PITCH] := lnSpeed;

    if CheckChannel(EzdaFX, False) then
      RestartChannel(EzdaFX, EzdaAttrs, 'TWS/' + Loco + '/ezda.wav', CAM_LOCO, BSL);
    SetChannelAttributes(EzdaFX, EzdaAttrs);
  end
  else if CheckChannel(EzdaFX) then
    FreeChannel(EzdaFX);

  if Speed >= 3 then
  begin
    ShumAttrs[A_VOLUME] := 0.01 * Speed * Ln(Speed - 2);
    ShumAttrs[A_TEMPO] := 10 * lnSpeed;
    ShumAttrs[A_PITCH] := 0.1 * lnSpeed;

    if CheckChannel(ShumFX, False) then
      RestartChannel(ShumFX, ShumAttrs, 'TWS/shum.wav', CAM_LOCO, BSL);
    SetChannelAttributes(ShumFX, ShumAttrs);
  end
  else if CheckChannel(ShumFX) then
    FreeChannel(ShumFX);

  UpdateChannel(EzdaFX, EzdaAttrs);
  UpdateChannel(ShumFX, ShumAttrs);
end;

procedure HandlePerestuk(Speed: Double; track: TValue<Integer>; axesAmount: Integer;
  axesDistancesWagon: array of Integer; axesDistancesLoco: array of Integer; axesLocoAmount: Integer);
var
  isTrackChangeKeyPressed: Boolean;
begin
  // Timer
  for var k := 0 to PerestukStackSize - 1 do
    if PerestukStack[k][P_TIME] > 0 then
      PerestukStack[k][P_TIME] := PerestukStack[k][P_TIME] - 30;

  // LCtrl + Numpad+ or RCtrl + Numpad-
  isTrackChangeKeyPressed := (GetAsyncKeyState(162) + GetAsyncKeyState(163)) *
    (GetAsyncKeyState(107) + GetAsyncKeyState(109)) <> 0;

  // On joint
  if (Abs(track[V_PRV] - track[V_CUR]) > 0) and isTrackChangeKeyPressed and (PerestukStackSize < Length(PerestukStack))
  then
  begin
    PerestukStack[PerestukStackSize][P_ID] := Round(random() * 2 + 1);
    Inc(PerestukStackSize);
  end;

  // Sound
  if (Speed >= 3) and (PerestukStackSize > 0) then
  begin
    for var k := 0 to PerestukStackSize - 1 do
    begin
      const
        axisIdx = PerestukStack[k][P_AXIS_IDX];

      if axisIdx >= axesAmount then
      begin
        PerestukStack[k][P_AXIS_IDX] := 0;
        PerestukStack[k][P_TIME] := 0;
        Dec(PerestukStackSize);
      end
      else if PerestukStack[k][P_TIME] <= 0 then
      begin
        randomize();
        const
          singlerandom = random();
        randomize();

        PerestukAttrs[A_VOLUME] := 3 * Exp(-0.0005 * power(Speed - 60, 2)) - 0.6;
        PerestukAttrs[A_TEMPO] := 5 * (Exp(0.05 * Speed) - 1) + 5 * (singlerandom - 0.5);
        PerestukAttrs[A_PITCH] := Exp(0.02 * (Speed - 30)) - 0.4 + singlerandom - 0.5;

        // Zatuhanie
        PerestukAttrs[A_VOLUME] := PerestukAttrs[A_VOLUME] * Exp(-0.05 * axisIdx * axisIdx);
        // Echo
        PerestukAttrs[A_PITCH] := PerestukAttrs[A_PITCH] * (singlerandom + 0.5) *
          Exp(-0.005 * Speed * axisIdx * axisIdx);

        if PerestukAttrs[A_PITCH] > 55 then
          PerestukAttrs[A_PITCH] := 55;

        var
          nextAxisDistance: Integer;
        if axisIdx = 0 then
          nextAxisDistance := axesDistancesLoco[0]
        else if axisIdx < axesLocoAmount - 1 then
        begin
          PerestukAttrs[A_VOLUME] := 0.5 * (singlerandom + 1) * PerestukAttrs[A_VOLUME];
          PerestukAttrs[A_PITCH] := 0.25 * (singlerandom + 1) * PerestukAttrs[A_PITCH];
          nextAxisDistance := axesDistancesLoco[axisIdx];
        end
        else if axisIdx = axesLocoAmount - 1 then
          nextAxisDistance := axesDistancesWagon[0] + axesDistancesLoco[axesLocoAmount - 1]
        else if axisIdx > axesLocoAmount - 1 then
        begin
          var
          wagonAxisIdx := (axisIdx - axesLocoAmount + 1) Mod Length(axesDistancesWagon);

          if wagonAxisIdx = 0 then
            nextAxisDistance := 2 * axesDistancesWagon[0]
          else
            nextAxisDistance := axesDistancesWagon[wagonAxisIdx];
        end;

        // Play

        if (PerestukAttrs[A_VOLUME] > 0.0001) and (axisIdx <> 0) then
        begin
          for var l := 0 to Length(PerestukFX) - 1 do
          begin
            if CheckChannel(PerestukFX[l], False) then
            begin
              var
              stukId := PerestukStack[k][P_ID];
              if (axisIdx Mod 4 < 2) then
                stukId := stukId Mod 3 + 1;

              RestartChannel(PerestukFX[l], PerestukAttrs, 'TWS/stuk' + stukId.ToString() + '.wav', CAM_COM);
              break;
            end;
          end;
        end;

        Inc(PerestukStack[k][P_AXIS_IDX]);
        PerestukStack[k][P_TIME] := Trunc(3.6 * nextAxisDistance / Speed);
      end;
    end;
  end;
end;

// Vstrech
procedure HandleVstrech(vstrechStatus: TValue<Byte>; track: Integer; vstrTrack: TValue<WORD>; MP: Byte;
  vstrSpeed: Single; wagNumVstr: Integer; vstrechaDlina: Integer; TrackVstrechi: Integer);
var
  i: Double;
begin
  try
    if vstrechStatus[V_CUR] <> vstrechStatus[V_PRV] then
    begin
      isVstrechDrive := True;
      VstrechStatusCounter := 0;
    end;
    var
    isCondition := track - vstrTrack[V_CUR] > Trunc(wagNumVstr * vstrechaDlina / wagNumVstr / TrackLength);
    if isVstrechDrive = True then
    begin
      if (isCondition) then
        isVstrechDrive := False;
      if vstrechStatus[V_CUR] = vstrechStatus[V_PRV] then
        Inc(VstrechStatusCounter);
      if VstrechStatusCounter >= 40 then
        isVstrechDrive := False;
    end;
    if (Naprav = 'Tuda') and (vstrTrack[V_PRV] < vstrTrack[V_CUR]) Or (Naprav = 'Obratno') and
      (vstrTrack[V_PRV] > vstrTrack[V_CUR]) then
      HeadTrainEndOfTrain := False;
    if (BASS_ChannelIsActive(Vstrech) = 0) and (isVstrechDrive = True) and (HeadTrainEndOfTrain = False) then
    begin
      var
      isNearby := (track >= vstrTrack[V_CUR]) and (Naprav = 'Tuda') and (MP <> 1) or (track <= vstrTrack[V_CUR]) and
        (Naprav = 'Obratno') and (MP <> 1) or (track >= vstrTrack[V_CUR]) and (Naprav = 'Tuda') and (MP = 1) and
        (vstrSpeed > 40) or (track <= vstrTrack[V_CUR]) and (Naprav = 'Obratno') and (MP = 1) and (vstrSpeed > 40);
      if isNearby then
      begin
        TrackVstrechi := track;
        if wagNumVstr <= 23 then
          VstrechF := PChar('TWS/Pass_vstrech.wav')
        else
          VstrechF := PChar('TWS/Freight_vstrech.wav');

        BASS_ChannelStop(Vstrech);
        BASS_StreamFree(Vstrech);
        Vstrech := BASS_StreamCreateFile(False, VstrechF, 0, 0, BSL);
        BASS_ChannelPlay(Vstrech, True);
        isPlayVstrech := True;

        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);

        i := 22050 + Speed[V_CUR] * 300;
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_FREQ, i);
      end;
    end;

    // TODO

    if BASS_ChannelIsActive(Vstrech) <> 0 then
    begin
      if VstrZat = False then
      begin
        if isCondition and (Naprav = 'Tuda') Or (isVstrechDrive = False) then
        begin
          VstrZat := True;
          VstrVolume := 100;
          HeadTrainEndOfTrain := True;
        end
        else if isCondition and (Naprav = 'Obratno') Or (isVstrechDrive = False) then
        begin
          VstrZat := True;
          VstrVolume := 100;
          HeadTrainEndOfTrain := True;
        end;
        if (MP = 1) and (vstrSpeed <= 40) then
        begin
          VstrZat := True;
          VstrVolume := 100;
          HeadTrainEndOfTrain := True;
        end;
      end;
    end;
  except
  end;
end;

// MV-MK
procedure HandleMVSounds(ramState: Byte; var state: Boolean; prefix: String = '');
var
  pathRoot: String;
begin
  pathRoot := locoWorkDir + 'mv' + prefix + '-';

  if ramState = 1 then
  begin
    if state = False then
    begin
      RestartChannel(MVsFX[0], MVAttrs, pathRoot + 'start.wav', CAM_CAB);
      RestartChannel(MVsFX[1], MVAttrs, pathRoot + 'x-start.wav', CAM_LOCO);

      MVAttrs[A_TEMPO] := MVAttrs[A_TEMPO] + 10;
      RestartChannel(MVsFX[2], pathRoot + 'start.wav', CAM_LOCO);
      state := True;
    end
    else if CheckChannel(MVsFX[0], False) and CheckChannel(MVsFX[1], False) and CheckChannel(MVsFX[2], False) then
    begin
      RestartChannel(MVsFX[0], MVAttrs, pathRoot + 'loop.wav', CAM_CAB, BSL);
      RestartChannel(MVsFX[1], MVAttrs, pathRoot + 'loop.wav', CAM_LOCO, BSL);

      MVAttrs[A_TEMPO] := MVAttrs[A_TEMPO] + 10;
      RestartChannel(MVsFX[2], MVAttrs, pathRoot + 'loop.wav', CAM_LOCO, BSL);
    end;
  end
  else
  begin
    if state then
    begin
      RestartChannel(MVsFX[0], MVAttrs, pathRoot + 'stop.wav', CAM_CAB);
      RestartChannel(MVsFX[1], MVAttrs, pathRoot + 'stop.wav', CAM_LOCO);

      MVAttrs[A_TEMPO] := MVAttrs[A_TEMPO] + 10;
      RestartChannel(MVsFX[2], MVAttrs, pathRoot + 'stop.wav', CAM_LOCO);
      state := False;
    end
    else if CheckChannel(MVsFX[0]) or CheckChannel(MVsFX[1]) or CheckChannel(MVsFX[2]) then
    begin
      FreeChannel(MVsFX[0]);
      FreeChannel(MVsFX[1]);
      FreeChannel(MVsFX[2]);
    end;
  end;

  UpdateChannel(MVsFX[0], MVAttrs);
  UpdateChannel(MVsFX[1], MVAttrs);
  UpdateChannel(MVsFX[2], MVAttrs);
end;

procedure HandleMKSounds(ramState: array of Single);
var
  pathRoot: String;
begin
  pathRoot := locoWorkDir + 'mk-';

  if ramState[0] = 1 then
  begin
    if MKChannelsState[0] = False then
    begin
      RestartChannel(MKsFX[0], MKAttrs, pathRoot + 'start.wav', CAM_CAB);
      RestartChannel(MKsFX[1], MKAttrs, pathRoot + 'x-start.wav', CAM_LOCO);
      MKChannelsState[0] := True;
    end
    else if CheckChannel(MKsFX[0], False) and CheckChannel(MKsFX[1], False) then
    begin
      RestartChannel(MKsFX[0], MKAttrs, pathRoot + 'loop.wav', CAM_CAB, BSL);
      RestartChannel(MKsFX[1], MKAttrs, pathRoot + 'x-loop.wav', CAM_LOCO, BSL);
    end;
  end
  else
  begin
    if MKChannelsState[0] then
    begin
      RestartChannel(MKsFX[0], MKAttrs, pathRoot + 'stop.wav', CAM_CAB);
      RestartChannel(MKsFX[1], MKAttrs, pathRoot + 'x-stop.wav', CAM_LOCO);
      MKChannelsState[0] := False;
    end
    else if CheckChannel(MKsFX[0]) or CheckChannel(MKsFX[1]) then
    begin
      FreeChannel(MKsFX[0]);
      FreeChannel(MKsFX[1]);
    end;
  end;

  if ramState[1] = 1 then
  begin
    if MKChannelsState[1] = False then
    begin
      MKAttrs[A_TEMPO] := MKAttrs[A_TEMPO] + 10;
      RestartChannel(MKsFX[2], MKAttrs, pathRoot + 'x-start.wav', CAM_CAB);
      MKChannelsState[1] := True;
    end
    else if CheckChannel(MKsFX[2], False) then
    begin
      MKAttrs[A_TEMPO] := MKAttrs[A_TEMPO] + 10;
      RestartChannel(MKsFX[2], MKAttrs, pathRoot + 'x-loop.wav', CAM_LOCO, BSL);
    end;
  end
  else
  begin
    if MKChannelsState[1] then
    begin
      MKAttrs[A_TEMPO] := MKAttrs[A_TEMPO] + 10;
      RestartChannel(MKsFX[2], MKAttrs, pathRoot + 'x-stop.wav', CAM_LOCO);
      MKChannelsState[1] := False;
    end
    else if CheckChannel(MKsFX[2]) then
      FreeChannel(MKsFX[2]);
  end;

  UpdateChannel(MKsFX[0], MVAttrs);
  UpdateChannel(MKsFX[1], MVAttrs);
  UpdateChannel(MKsFX[2], MVAttrs);
end;

procedure HandleMVPitch();
begin
  if LocoWithMVPitch then
  begin
    var
    deltaMVPitch := VentPitchIncrementer * MainCycleFreq;

    if MVAttrs[A_PITCH] > VentPitchDest then
      MVAttrs[A_PITCH] := MVAttrs[A_PITCH] - deltaMVPitch
    else if MVAttrs[A_PITCH] < VentPitchDest then
      MVAttrs[A_PITCH] := MVAttrs[A_PITCH] + deltaMVPitch;

    SetChannelAttributes(MVsFX[0], MVAttrs);
    SetChannelAttributes(MVsFX[1], MVAttrs);
    SetChannelAttributes(MVsFX[2], MVAttrs);
  end;

  if LocoWithMVTDPitch then
  begin
    var
    deltaMVTDPitch := VentTDPitchIncrementer * MainCycleFreq;

    if mvTDAttrs[A_PITCH] > VentTDPitchDest then
      mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] - deltaMVTDPitch
    else if VentTDPitch < VentTDPitchDest then
      mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] + deltaMVTDPitch;

    SetChannelAttributes(MVsTDFX[0], mvTDAttrs);
    SetChannelAttributes(MVsTDFX[1], mvTDAttrs);
    SetChannelAttributes(MVsTDFX[2], mvTDAttrs);
  end;
end;

// Misc
procedure HandleMiscSounds(rain: TValue<Byte>; track: Integer; outsideLocoStatus: Byte);
var
  FileName: String;
begin
  if Winter = 0 then
  begin
    if rain[V_CUR] >= 80 then
      rain[V_CUR] := Trunc(0.0125 * rain[V_CUR])
    else if rain[V_CUR] > 0 then
      rain[V_CUR] := 1;

    if rain[V_CUR] <> rain[V_PRV] then
    begin
      Case rain[V_CUR] Of
        1:
          FileName := 'TWS/storm.wav';
        2:
          FileName := 'TWS/storm1.wav';
        3:
          FileName := 'TWS/storm2.wav';
      end;
      if (CheckChannel(ChannelsMisc[0], False)) then
        RestartChannel(ChannelsMisc[0], FileName, CAM_LOCO, BSL)
    end;

    if track = 0 then
      rain[V_CUR] := 0;
    if rain[V_CUR] = 0 then
      FreeChannel(ChannelsMisc[0])
  end
  else if outsideLocoStatus <> 0 then
  begin
    if GetAsyncKeyState(37) + GetAsyncKeyState(39) <> 0 then
      RestartChannel(ChannelsMisc[0], 'TWS/snow_walk.wav', CAM_LOCO, BSL)
    else if CheckChannel(ChannelsMisc[0]) then
      FreeChannel(ChannelsMisc[0]);
  end;

  for var l := 0 to Length(ChannelsDefault) - 1 do
    SetChannelAttributes(ChannelsDefault[l], MVAttrs);
end;

procedure HandlePRSSounds(isRZDChecked: Boolean; isUZChecked: Boolean);
var
  NumPRS, Country: Integer;
begin
  if isRZDChecked or isUZChecked then
  begin
    randomize;
    if isRZDChecked and (isRZDChecked = False) then
    begin
      repeat
        NumPRS := random(43);
      until (NumPRS <> PrevPRS) and (NumPRS <> 0);
      PRSF := PChar('TWS/PRS/RU_' + IntToStr(NumPRS) + '.mp3');
      PrevPRS := NumPRS;
    end
    else if isRZDChecked and (isRZDChecked = False) then
    begin
      repeat
        NumPRS := random(5);
      until (NumPRS <> PrevPRS) and (NumPRS <> 0);
      PRSF := PChar('TWS/PRS/UA_' + IntToStr(NumPRS) + '.mp3');
      PrevPRS := NumPRS;
    end
    else if isRZDChecked and isRZDChecked then
    begin
      randomize;
      repeat
        Country := 1 + random(2);
      until (Country <> 0);
      if Country = 1 then
      begin
        randomize;
        repeat
          NumPRS := random(43);
        until (NumPRS <> PrevPRS) and (NumPRS <> 0);
        PRSF := PChar('TWS/PRS/RU_' + IntToStr(NumPRS) + '.mp3');
        PrevPRS := NumPRS;
      end
      else
      begin
        randomize;
        repeat
          NumPRS := random(5);
        until (NumPRS <> PrevPRS) and (NumPRS <> 0);
        PRSF := PChar('TWS/PRS/UA_' + IntToStr(NumPRS) + '.mp3');
        PrevPRS := NumPRS;
      end;
    end;

    PlaySound(PRSF, CAM_CAB);
  end;
end;

/// //////////////////////////////////////////////////////////////////////

// Misc
procedure SoundManagerTick();
var
  i: Integer;
begin
  With FormMain do
  begin
    // === САУТ Объекты [1] === //
    if (isPlaySAUTObjects = False) and (BASS_ChannelIsActive(SAUTChannelObjects) = 0) then
    begin
      try
        BASS_ChannelStop(SAUTChannelObjects);
        BASS_StreamFree(SAUTChannelObjects);
        if PlayResFlag = False then
        begin
          SAUTChannelObjects := BASS_StreamCreateFile(False, SAUTF, 0, 0, DFF);
        end
        else
        begin
          SAUTChannelObjects := BASS_StreamCreateFile(True, ResPotok.Memory, 0, ResPotok.Size, DFF);
        end;
        BASS_ChannelPlay(SAUTChannelObjects, True);
        isPlaySAUTObjects := True;
        PlayResFlag := False;
        if isCameraInCabin = True then
          BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, trcBarSAVPVol.Position / 100)
        else
          BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0);
      except
      end;
    end;
    // === САУТ Объекты [2] === //
    if (isPlaySAUTObjects = False) and (BASS_ChannelIsActive(SAUTChannelObjects) <> 0) then
    begin
      try
        BASS_ChannelStop(SAUTChannelObjects2);
        BASS_StreamFree(SAUTChannelObjects2);
        if PlayResFlag = False then
        begin
          SAUTChannelObjects2 := BASS_StreamCreateFile(False, SAUTF, 0, 0, DFF);
        end
        else
        begin
          SAUTChannelObjects2 := BASS_StreamCreateFile(True, ResPotok.Memory, 0, ResPotok.Size, DFF);
        end;
        BASS_ChannelPlay(SAUTChannelObjects2, True);
        isPlaySAUTObjects := True;
        PlayResFlag := False;
        if isCameraInCabin = True then
          BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0.01 * trcBarSAVPVol.Position)
        else
          BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0);
      except
      end;
    end;
    // === ЗВОНОК ИЗ ЭК === //
    if isPlaySAUTZvonok = True then
    begin
      try
        BASS_ChannelStop(SAUTChannelZvonok);
        BASS_StreamFree(SAUTChannelZvonok);
        SAUTChannelZvonok := BASS_StreamCreateFile(False, SAUTF, 0, 0, BSL);
        BASS_ChannelPlay(SAUTChannelZvonok, True);
        isPlaySAUTZvonok := False;
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_FREQ, 44100);
      except
      end;
    end;
  end;
end;

end.
