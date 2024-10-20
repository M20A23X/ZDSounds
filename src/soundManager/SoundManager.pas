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
  TKMStateEnum = (KM_AP = 2, KM_P = 1, KM_N = 0, KM_M = 255, KM_AM = 254);

  TChannelIDEnum = (C_FILE, C_FX);
  TChannelFX = array [TChannelIDEnum] of Cardinal;
  TSoundAttrIDEnum = (A_VOLUME, A_TEMPO, A_PITCH);
  TSoundAttrs = array [TSoundAttrIDEnum] of Double;

  TPerestukStackAttrEnum = (P_AXIS_IDX, P_TIME, P_ID);
  TPerestukStack = array of array [TPerestukStackAttrEnum] of Integer;
  TSignals = array [0 .. 1, 0 .. 1] of Cardinal;

  TPneumaticIDEnum = (PN_ZAR, PN_VP, PN_VIP, PN_TORM, PN_DT, PN_TC);
  TPneumaticsFX = array [TPneumaticIDEnum] of array [0 .. 1] of TChannelFX;
  TPneumaticsAttrs = array [TPneumaticIDEnum] of array [0 .. 1] of TSoundAttrs;
  TPneumaticsAux<T> = array [TPneumaticIDEnum] of T;

  TValueID = (V_CUR, V_PRV);
  TValue<T> = array [TValueID] of T;

procedure SoundManagerTick();

procedure RefreshVolume();

// Check
function CheckChannel(channels: Cardinal; isInv: Boolean = True): Boolean;
overload
function CheckChannel(channels: TChannelFX; isInv: Boolean = True): Boolean;
overload

// Play
procedure RestartChannel(var channel: Cardinal; FileName: String; flags: Integer = 0);
overload
procedure RestartChannel(var channels: TChannelFX; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
overload
procedure PlaySound(var channels: array of Cardinal; FileName: String; flags: Integer = 0);

// Attrs
procedure SetChannelAttributes(var channels: Cardinal; const attrs: TSoundAttrs);
overload
procedure SetChannelAttributes(var channels: TChannelFX; const attrs: TSoundAttrs);
overload

// Free
procedure FreeChannel(var channels: Cardinal);
overload
procedure FreeChannel(var channels: TChannelFX);
overload

// Specific

// Signals
procedure HandleSignal(signalIdx: Integer; const signals: array of Byte; var channels: TSignals; dir: String;
  var state: array of Boolean);

// KLUB-3SL2m
procedure HandleKLUBSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal;
  ogrSpeed: TValue<WORD>; nextOgrSpeed: TValue<Byte>; var nextOgrPeekStatus: Byte; Speed: Double;
  svetofor: TValue<Byte>; var prevKeyTAB: Byte; klubOpen: Byte);

procedure Handle3SL2mSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal;
  rb: TValue<Byte>; rbs: TValue<Byte>; Speed: TValue<Double>);

// TP
procedure HandleTPSounds(var channels: array of Cardinal; locoWithSndTP: Boolean; frontTP: TValue<Integer>;
  backTP: TValue<Integer>);

// Clicks
procedure HandleClickSounds(var channels: array of Cardinal; var miscChannels: array of Cardinal; km395: TValue<Byte>;
  km294: TValue<Single>; epk: TValue<Boolean>; km1: TValue<Integer>; reostat: TValue<Byte>; voltage: TValue<Single>;
  locoWithSndReversor: Boolean; locoSndReversorType: Byte; reversor: TValue<Integer>; stochist: TValue<Single>;
  stochistDGR: TValue<Double>);

procedure HandleKMSounds(var channels: array of Cardinal; kmState: TValue<TKMStateEnum>; kmOP: TValue<Single>);

// Pneumatics-Brakes
procedure HandlePneumaticSounds(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs;
  var fadeTimers: TPneumaticsAux<Integer>; var fadeInStates: TPneumaticsAux<Boolean>; km395: Byte; tm: TValue<Single>;
  ur: TValue<Single>; nap: TValue<Single>; dt: TValue<Single>; tc: TValue<Single>);

procedure HandleBrakeSounds(var brakeChannel: TChannelFX; var brakeAttrs: TSoundAttrs; var brakeScrChannel: TChannelFX;
  var brakeScrAttrs: TSoundAttrs; tc: Double; Speed: Double; EDTAmperage: Double);

// TEDs
procedure HandleTEDSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);

// Reductors
procedure HandleReductorSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; Speed: Double);

// Ezda-Perestuk
procedure HandleEzda(var ezdaChannel: TChannelFX; var ezdaAttrs: TSoundAttrs; var shumChannel: TChannelFX;
  var shumAttrs: TSoundAttrs; Speed: Double);

procedure HandlePerestuk(var channels: array of TChannelFX; var soundStack: TPerestukStack; var stackSize: Integer;
  Speed: Double; track: TValue<Integer>; axesAmount: Integer; axesDistancesWagon: array of Integer;
  axesDistancesLoco: array of Integer; axesLocoAmount: Integer);

// Vstrech
procedure HandleVstrech(vstrechStatus: TValue<Byte>; track: Integer; vstrTrack: TValue<WORD>; MP: Byte;
  vstrSpeed: Single; wagNumVstr: Integer; vstrechaDlina: Integer; TrackVstrechi: Integer);

// MV-MK
procedure HandleMVSounds(ramState: Byte; var state: Boolean; var channels: array of TChannelFX; soundAttrs: TSoundAttrs;
  locoWorkDir: String; prefix: String = '');

procedure HandleMKSounds(ramState: array of Single; var state: array of Boolean; var channels: array of TChannelFX;
  soundAttrs: TSoundAttrs; locoWorkDir: String);

procedure HandleMVPitch(var mvChannels: array of TChannelFX; var soundAttrs: TSoundAttrs;
  var mvTDChannels: array of TChannelFX; var mvTDAttrs: TSoundAttrs);

// Nature
procedure HandleMiscSounds(var channels: array of Cardinal; rain: TValue<Byte>; track: Integer;
  outsideLocoStatus: Byte);

// PRS
procedure HandlePRSSounds(var channels: array of Cardinal; isRZDChecked: Boolean; isUZChecked: Boolean);

var
  SAUTChannelObjects: Cardinal; // Канал для звуков САУТ объекты (1)
  SAUTChannelObjects2: Cardinal; // Канал для звуков САУТ объекты (2)
  SAUTChannelZvonok: Cardinal; // Канал для звуков САУТ звонок на переезде
  PRSChannel: Cardinal; // Канал для звуков ПРС
  DizChannel, DizChannel2: Cardinal; // Канал для звуков Дизелей на тепловозах
  Vstrech: Cardinal; // Канал для звука встречного поезда
  PickKLUBChannel: Cardinal; // Канал для звука нажатия на кнопки КЛУБ-а
  LocoPowerEquipment: Cardinal; // Канал для звука силового оборудования локомотива(БВ, ФР, Жалюзи)
  Unipuls_Channel: array [0 .. 1] of Cardinal;
  SAVPE_Peek_Channel: Cardinal;
  SAVPE_INFO_Channel: Cardinal;
  SAVPE_ZVONOK: Cardinal;

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

  // Reductor
  reduktorChannelsFX: array [0 .. 1] of TChannelFX;
  ReduktorAttrs: TSoundAttrs = (0, 0, 0);

  // TEDs
  TEDChannelsFX: array [0 .. 1] of TChannelFX;
  TEDAttrs: TSoundAttrs = (0, 0, 0);

  // MV-MK
  MVChannelsState: Boolean;
  MVChannelsFX: array [0 .. 2] of TChannelFX;
  MVAttrs: TSoundAttrs = (1, 0, 0);

  MVTDChannelsState: Boolean;
  MVTDChannelsFX: array [0 .. 2] of TChannelFX;
  mvTDAttrs: TSoundAttrs = (1, 0, 0);

  MKChannelsState: array [0 .. 1] of Boolean;
  MKChannelsFX: array [0 .. 2] of TChannelFX;
  MKAttrs: TSoundAttrs = (1, 0, 0);

  // Ezda
  EzdaChannelFX: TChannelFX;
  ezdaAttrs: TSoundAttrs = (0, 0, 0);

  // Shum
  ShumChannelFX: TChannelFX;
  shumAttrs: TSoundAttrs = (0, 0, 0);

  // Perestuk
  PerestukChannelFX: array of TChannelFX;
  PerestukAttrs: TSoundAttrs = (0, 0, 0);
  PerestukStack: TPerestukStack;
  PerestukStackSize: Integer;

  // Brake slipp + scr
  BrakeChannelFX: TChannelFX;
  brakeAttrs: TSoundAttrs = (0, 0, 0);
  BrakeScrChannelFX: TChannelFX;
  brakeScrAttrs: TSoundAttrs = (0, 0, 0);

  // Brake 254
  PneumaticChannelsFX: TPneumaticsFX;
  PneumaticChannelsAttrs: TPneumaticsAttrs = (((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)),
    ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)), ((0, 0, 0), (0, 0, 0)));
  PneumaticTimers: TPneumaticsAux<Integer>;
  PneumaticFadeInState: TPneumaticsAux<Boolean>;

  TCTimer: Integer;
  IsTCFadeIn: Boolean;

  // TP
  TPChannel: array [0 .. 1] of Cardinal;

  // Common sounds
  ChannelsDefault: array [0 .. 3] of Cardinal; // Short sounds
  ChannelsMisc: array [0 .. 2] of Cardinal; // Loop sounds

  // 3SL2m
  skorostemerChannel: array [0 .. 2] of Cardinal;

implementation

uses Bass, UnitMain, SysUtils, Windows, ExtraUtils, bass_fx;

const
  DEFAULT_FLAG = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DECODE_FLAG = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};

  // Check
function CheckChannel(channels: Cardinal; isInv: Boolean = True): Boolean;
begin
  if isInv then
    Result := BASS_ChannelIsActive(channels) <> 0
  else
    Result := BASS_ChannelIsActive(channels) = 0
end;

function CheckChannel(channels: TChannelFX; isInv: Boolean = True): Boolean;
begin
  if isInv then
    Result := (BASS_ChannelIsActive(channels[C_FILE]) <> 0) or (BASS_ChannelIsActive(channels[C_FX]) <> 0)
  else
    Result := (BASS_ChannelIsActive(channels[C_FILE]) = 0) and (BASS_ChannelIsActive(channels[C_FX]) = 0);
end;

// Play
procedure RestartChannel(var channel: Cardinal; FileName: String; flags: Integer = 0);
begin
  FreeChannel(channel);
  channel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, flags or DEFAULT_FLAG);
  BASS_ChannelPlay(channel, False);
end;

procedure RestartChannel(var channels: TChannelFX; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
begin
  FreeChannel(channels);

  channels[C_FILE] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DECODE_FLAG);
  channels[C_FX] := BASS_FX_TempoCreate(channels[C_FILE], BASS_FX_FREESOURCE);

  BASS_ChannelFlags(channels[C_FX], flags, flags);
  SetChannelAttributes(channels, attrs);

  BASS_ChannelPlay(channels[C_FX], False);
end;

procedure PlaySound(var channels: array of Cardinal; FileName: String; flags: Integer = 0);
begin
  if FileName <> '' then
    for var l := 0 to Length(channels) - 1 do
      if CheckChannel(channels[l], False) then
      begin
        RestartChannel(channels[l], FileName, flags);
        break;
      end;
end;

// Attr
procedure SetChannelAttributes(var channels: TChannelFX; const attrs: TSoundAttrs);
begin
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_VOL, attrs[A_VOLUME]);
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_TEMPO, attrs[A_TEMPO]);
  BASS_ChannelSetAttribute(channels[C_FX], BASS_ATTRIB_TEMPO_PITCH, attrs[A_PITCH]);
end;

procedure SetChannelAttributes(var channels: Cardinal; const attrs: TSoundAttrs);
begin
  BASS_ChannelSetAttribute(channels, BASS_ATTRIB_VOL, attrs[A_VOLUME]);
  BASS_ChannelSetAttribute(channels, BASS_ATTRIB_TEMPO_PITCH, attrs[A_PITCH]);
end;

// Free
procedure FreeChannel(var channels: Cardinal);
begin
  BASS_ChannelStop(channels);
  BASS_StreamFree(channels);
end;

procedure FreeChannel(var channels: TChannelFX);
begin
  BASS_ChannelStop(channels[C_FILE]);
  BASS_StreamFree(channels[C_FILE]);
  BASS_ChannelStop(channels[C_FX]);
  BASS_StreamFree(channels[C_FX]);
end;


// Specific

// Signals

procedure HandleSignal(signalIdx: Integer; const signals: array of Byte; var channels: TSignals; dir: String;
  var state: array of Boolean);
var
  signalType: String;
begin
  signalType := 'svistok';
  if signalIdx = 1 then
    signalType := 'tifon';

  if signals[signalIdx] = 1 then
  begin
    if state[signalIdx] = False then
    begin
      RestartChannel(channels[signalIdx][0], locoWorkDir + signalType + '_start.wav');
      RestartChannel(channels[signalIdx][1], locoWorkDir + 'x_' + signalType + '_start.wav');
      state[signalIdx] := True;
    end
    else if CheckChannel(channels[signalIdx][0], False) or CheckChannel(channels[0][1], False) then
    begin
      RestartChannel(channels[signalIdx][0], locoWorkDir + signalType + '_loop.wav', BASS_SAMPLE_LOOP);
      RestartChannel(channels[signalIdx][1], locoWorkDir + 'x_' + signalType + '_loop.wav', BASS_SAMPLE_LOOP);
    end;
  end
  else if state[signalIdx] then
  begin
    RestartChannel(channels[signalIdx][0], locoWorkDir + signalType + '_stop.wav');
    RestartChannel(channels[signalIdx][1], locoWorkDir + 'x_' + signalType + '_stop.wav');
    state[signalIdx] := False;
  end;
end;

// KLUB-3SL2m
procedure HandleKLUBSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal;
  ogrSpeed: TValue<WORD>; nextOgrSpeed: TValue<Byte>; var nextOgrPeekStatus: Byte; Speed: Double;
  svetofor: TValue<Byte>; var prevKeyTAB: Byte; klubOpen: Byte);
begin
  // Нажатие РБ и РБС
  if (rb[V_CUR] <> rb[V_PRV]) or (rbs[V_CUR] <> rbs[V_PRV]) then
    PlaySound(channels, 'TWS/KLUB_pick.wav');

  // Пиканья при ограничении
  if (ogrSpeed[V_CUR] - Speed <= 3) and (ogrSpeed[V_CUR] <> 0) and (svetofor[V_CUR] <> 0) then
    PlaySound(channels, 'TWS/KLUB_pick.wav');
  if (ogrSpeed[V_CUR] - Speed > 3) or (ogrSpeed[V_CUR] = 0) then
    PlaySound(channels, 'TWS/KLUB_pick.wav');

  if (GetAsyncKeyState(9) <> 0) and (prevKeyTAB = 0) then
  begin
    RestartChannel(skorostemerChannel[2], 'TWS/belt_pul.wav', BASS_SAMPLE_LOOP);
    prevKeyTAB := 1;
  end
  else if GetAsyncKeyState(9) = 0 then
  begin
    prevKeyTAB := 0;
    FreeChannel(skorostemerChannel[2]);
  end;

  // Svetofor change
  if svetofor[V_CUR] <> svetofor[V_PRV] then
    PlaySound(channels, 'TWS/KLUB_beep.wav');

  // Проверка бдительности
  if (VCheck[V_CUR] <> VCheck[V_PRV]) and (VCheck[V_CUR] = 1) then
    PlaySound(channels, 'TWS/KLUB_beep.wav');

  if nextOgrPeekStatus = 0 then
  begin
    if ogrSpeed[V_PRV] > ogrSpeed[V_CUR] then
    begin
      if nextOgrSpeed[V_CUR] <> 0 then
      begin
        PlaySound(channels, 'TWS/KLUB_beep.wav');
        nextOgrPeekStatus := 1;
      end;
    end;
  end;

  if (klubOpen = 1) and (prevKeyLKM = 0) and (GetAsyncKeyState(1) <> 0) then
  begin
    PlaySound(channels, 'TWS/KLUB_pick.wav');
    prevKeyLKM := 1;
  end
  else if GetAsyncKeyState(1) = 0 then
    prevKeyLKM := 0;

  if nextOgrPeekStatus = 1 then
    if (nextOgrSpeed[V_CUR] <> nextOgrSpeed[V_PRV]) or (nextOgrSpeed[V_CUR] = 0) then
      nextOgrPeekStatus := 0;
end;

procedure Handle3SL2mSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal;
  rb: TValue<Byte>; rbs: TValue<Byte>; Speed: TValue<Double>);
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

    RestartChannel(channels[0], soundFile);

    if rbs[V_CUR] = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if rbs[V_CUR] = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    RestartChannel(channels[1], soundFile);
  end;

  // Звук протяжки ленты по нажатию кл. <TAB>
  if (GetAsyncKeyState(9) <> 0) and (prevKeyTAB = 0) then
  begin
    RestartChannel(skorostemerChannel[2], 'TWS/belt_pul.wav', BASS_SAMPLE_LOOP);
    prevKeyTAB := 1;
  end
  else if GetAsyncKeyState(9) = 0 then
  begin
    prevKeyTAB := 0;
    FreeChannel(skorostemerChannel[2]);
  end;

  // 3СЛ2м
  if CheckChannel(skorostemerChannel[0], False) then
    RestartChannel(skorostemerChannel[0], 'TWS/Devices/3SL2M/clock.wav', BASS_SAMPLE_LOOP);

  soundFile := 'TWS/Devices/3SL2M/';

  if (Speed[V_CUR] <= 0) and CheckChannel(skorostemerChannel[1]) then
    FreeChannel(skorostemerChannel[1])
  else if (Speed[V_CUR] > 1) and (Speed[V_CUR] <= 3) and
    ((Speed[V_PRV] <= 1) or CheckChannel(skorostemerChannel[1], False)) then
    RestartChannel(skorostemerChannel[1], soundFile + 'start.wav', BASS_SAMPLE_LOOP)
  else if (Speed[V_CUR] > 3) and ((Speed[V_PRV] <= 3) or CheckChannel(skorostemerChannel[1], False)) then
    RestartChannel(skorostemerChannel[1], soundFile + 'loop.wav', BASS_SAMPLE_LOOP);
end;

// TPs
procedure HandleTPSounds(var channels: array of Cardinal; locoWithSndTP: Boolean; frontTP: TValue<Integer>;
  backTP: TValue<Integer>);
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

    PlaySound(channels, soundFile);

    // ЗАДНИЙ
    if (backTP[V_CUR] = 63) and (backTP[V_CUR] <> backTP[V_PRV]) then
      soundFile := 'TWS/TPUp.wav'
    else if (backTP[V_CUR] <> 63) and (backTP[V_PRV] = 63) and (backTP[V_PRV] <> 188) then
      soundFile := 'TWS/TPDown.wav';

    PlaySound(channels, soundFile);
  end;
end;

// Clicks
procedure HandleClickSounds(var channels: array of Cardinal; var miscChannels: array of Cardinal; km395: TValue<Byte>;
  km294: TValue<Single>; epk: TValue<Boolean>; km1: TValue<Integer>; reostat: TValue<Byte>; voltage: TValue<Single>;
  locoWithSndReversor: Boolean; locoSndReversorType: Byte; reversor: TValue<Integer>; stochist: TValue<Single>;
  stochistDGR: TValue<Double>);
var
  soundFile: String;
  reversKey: Char;
begin
  // 254 / 395
  if (km395[V_CUR] <> km395[V_PRV]) and (km395[V_CUR] <> 1) and (km395[V_CUR] <> 6) then
    PlaySound(channels, 'TWS/stuk395.wav');

  if (km294[V_CUR] <> km294[V_PRV]) and (km294[V_CUR] <> -1) and (km294[V_PRV] <> -1) then
    PlaySound(channels, 'TWS/stuk254.wav');

  // ЭПК
  if epk[V_CUR] <> epk[V_PRV] then
    PlaySound(channels, 'TWS/epk.wav');

  // ЭМЗ
  if (km1[V_PRV] = 0) and (km1[V_CUR] > 0) or (km1[V_CUR] = 0) and (km1[V_PRV] > 0) or
    (reostat[V_CUR] + reostat[V_PRV] = 1) then
    PlaySound(channels, 'TWS/Devices/21KR/EM_zashelka.wav');

  // РЕЛЕ НАПРЯЖЕНИЯ
  if (voltage[V_PRV] = 0) and (voltage[V_CUR] <> 0) then
    PlaySound(channels, 'TWS/CHS7/rn.wav');

  // РЕВЕРСИВКА
  if locoWithSndReversor then
  begin
    if (locoSndReversorType = 1) and (km1[V_CUR] = 0) and (reversor[V_CUR] <> reversor[V_PRV]) or
      (locoSndReversorType = 0) and (reversor[V_CUR] <> reversor[V_PRV]) then
      PlaySound(channels, 'TWS/CHS7/revers.wav');
  end;

  // СТЕКЛОЧИСТИТЕЛЬ
  if stochist[V_CUR] <> stochist[V_PRV] then
  begin
    if stochist[V_CUR] = 4 then
      RestartChannel(miscChannels[2], 'TWS/stochist.wav', BASS_SAMPLE_LOOP)
    else if stochist[V_CUR] = 8 then
      RestartChannel(miscChannels[2], 'TWS/stochist2.wav', BASS_SAMPLE_LOOP)
    else
      FreeChannel(miscChannels[2]);
  end;

  if (stochist[V_CUR] = 8) and ((stochistDGR[V_CUR] > 120) and (stochistDGR[V_PRV] <= 120)) or
    ((stochistDGR[V_CUR] < 55) and (stochistDGR[V_PRV] >= 55)) then
    PlaySound(channels, 'stochist_udar.wav');

end;

procedure HandleKMSounds(var channels: array of Cardinal; kmState: TValue<TKMStateEnum>; kmOP: TValue<Single>);
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

    PlaySound(channels, 'TWS/Devices/21KR/' + soundFile)
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
      for var l := 0 to Length(channels) - 1 do
        if isPrevKMKeyEQ and CheckChannel(channels[l], False) or (isPrevKMKeyEQ = False) then
        begin
          RestartChannel(channels[l], 'TWS/Devices/21KR/' + soundFile);
          break;
        end;
    end;
  end;
end;

// Pneumatics-Brakes

procedure HandleZaryadkaSound(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs; km395: Byte;
  tm: TValue<Single>; nap: TValue<Single>);
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

      soundAttrs[PN_ZAR][0][A_VOLUME] := 0.5 * napCoeff * Ln(tmCoeff + 1);
      soundAttrs[PN_ZAR][0][A_TEMPO] := 100 * soundAttrs[PN_ZAR][0][A_VOLUME];
      soundAttrs[PN_ZAR][0][A_PITCH] := 0.3 * soundAttrs[PN_ZAR][0][A_VOLUME];

      if CheckChannel(channels[PN_ZAR][0], False) then
        RestartChannel(channels[PN_ZAR][0], 'TWS/395_zaryadka.wav', soundAttrs[PN_ZAR][1], BASS_SAMPLE_LOOP);
      SetChannelAttributes(channels[PN_ZAR][0], soundAttrs[PN_ZAR][0]);
    end;
  end
  else
    FreeChannel(channels[PN_ZAR][0]);
end;

procedure HandleVipuskSound(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs;
  var fadeTimers: TPneumaticsAux<Integer>; tm: TValue<Single>);
var
  tmCoeff: Double;
  timerCoeff: Double;
begin
  tmCoeff := tm[V_CUR] - tm[V_PRV];

  if tmCoeff < -0.005 then
  begin
    fadeTimers[PN_VIP] := 30;
    soundAttrs[PN_VIP][0][A_VOLUME] := Ln(5 * Abs(tmCoeff) + 1);
    soundAttrs[PN_VIP][0][A_TEMPO] := 100 * soundAttrs[PN_ZAR][0][A_VOLUME];
    soundAttrs[PN_VIP][0][A_PITCH] := 0.4 * soundAttrs[PN_VIP][0][A_VOLUME];

    if CheckChannel(channels[PN_VIP][0], False) then
      RestartChannel(channels[PN_VIP][0], 'TWS/395_vypusk.wav', soundAttrs[PN_VIP][0], BASS_SAMPLE_LOOP);
    SetChannelAttributes(channels[PN_VIP][0], soundAttrs[PN_VIP][0]);
  end
  else if fadeTimers[PN_VIP] <= 10 then
  begin
    timerCoeff := 0.1 * fadeTimers[PN_VIP];
    soundAttrs[PN_VIP][0][A_VOLUME] := soundAttrs[PN_VIP][0][A_VOLUME] * timerCoeff;
    soundAttrs[PN_VIP][0][A_TEMPO] := soundAttrs[PN_VIP][0][A_TEMPO] * timerCoeff;
    soundAttrs[PN_VIP][0][A_PITCH] := soundAttrs[PN_VIP][0][A_PITCH] * timerCoeff;

    if fadeTimers[PN_VIP] <= 0 then
      FreeChannel(channels[PN_VIP][0]);
  end;

  Dec(fadeTimers[PN_VIP]);
end;

procedure HandleVpuskSound(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs; km395: Byte;
  tm: TValue<Single>; ur: TValue<Single>; nap: TValue<Single>);
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

    soundAttrs[PN_VP][0][A_VOLUME] := tmCoeff * Exp(-power(20 * urCoeff, 2)) * 0.028 * nap[V_CUR] *
      (Exp(-0.05 * power(Abs(ur[V_CUR] - tm[V_CUR]) - 10, 2)) + 1);
    soundAttrs[PN_VP][0][A_TEMPO] := 5 * soundAttrs[PN_VP][0][A_VOLUME];

    if CheckChannel(channels[PN_VP][0], False) then
      RestartChannel(channels[PN_VP][0], 'TWS/395_vpusk.wav', soundAttrs[PN_VP][0], BASS_SAMPLE_LOOP);
    SetChannelAttributes(channels[PN_VP][0], soundAttrs[PN_VP][0]);
  end
  else
    FreeChannel(channels[PN_VP][0]);
end;

procedure HandleTormSound(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs; km395: Byte;
  ur: TValue<Single>);
var
  urCoeff: Double;
begin
  if km395 >= 5 then
  begin
    urCoeff := Abs(ur[V_CUR] - ur[V_PRV]);
    if urCoeff <> 0 then
    begin
      soundAttrs[PN_TORM][0][A_VOLUME] := 10 * Ln(urCoeff + 1);
      soundAttrs[PN_TORM][0][A_TEMPO] := 5 * soundAttrs[PN_TORM][0][A_VOLUME];

      if CheckChannel(channels[PN_TORM][0], False) then
        RestartChannel(channels[PN_TORM][0], 'TWS/395_torm.wav', soundAttrs[PN_TORM][0], BASS_SAMPLE_LOOP);
      SetChannelAttributes(channels[PN_TORM][0], soundAttrs[PN_TORM][0]);
    end;
  end
  else
    FreeChannel(channels[PN_TORM][0]);
end;

procedure HandleDTTCSounds(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs;
  var fadeTimers: TPneumaticsAux<Integer>; var fadeInStates: TPneumaticsAux<Boolean>; pID: TPneumaticIDEnum;
  cylinder: TValue<Single>);
var
  brakeDelta: Double;
  timerCoeff: Double;
begin
  brakeDelta := 10 * Abs(cylinder[V_CUR] - cylinder[V_PRV]);
  if (brakeDelta > 0.05) and (fadeTimers[pID] >= 0) then
  begin
    if fadeTimers[pID] > 20 then
    begin
      fadeInStates[pID] := False;
      timerCoeff := 1;
    end
    else if fadeInStates[pID] = False then
      fadeInStates[pID] := True;

    if fadeInStates[pID] then
      timerCoeff := 0.05 * fadeTimers[pID] + 0.0001;

    soundAttrs[pID][0][A_VOLUME] := Ln(0.278 * cylinder[V_CUR] * timerCoeff * brakeDelta + 1);
    soundAttrs[pID][0][A_TEMPO] := 100 * soundAttrs[pID][0][A_VOLUME];
    soundAttrs[pID][0][A_PITCH] := soundAttrs[pID][1][A_VOLUME] - 1;

    soundAttrs[pID][1][A_VOLUME] := 0.35 * Exp(-0.5 * power(cylinder[V_CUR] * timerCoeff - 3.6, 2));
    soundAttrs[pID][1][A_TEMPO] := 100 * soundAttrs[pID][1][A_VOLUME];
    soundAttrs[pID][1][A_PITCH] := soundAttrs[pID][1][A_PITCH];

    if CheckChannel(channels[pID][0], False) and CheckChannel(channels[pID][1], False) then
    begin
      RestartChannel(channels[pID][0], 'TWS/254_shipenie.wav', soundAttrs[pID][0], BASS_SAMPLE_LOOP);
      RestartChannel(channels[pID][1], 'TWS/254_release.wav', soundAttrs[pID][1], BASS_SAMPLE_LOOP);
    end;

  end
  else if (fadeTimers[pID] < 0) then
  begin
    timerCoeff := 0.05 * (fadeTimers[pID] + 20) + 0.0001;

    soundAttrs[pID][0][A_VOLUME] := soundAttrs[pID][0][A_VOLUME] * timerCoeff;
    soundAttrs[pID][0][A_TEMPO] := soundAttrs[pID][0][A_TEMPO] * timerCoeff;
    soundAttrs[pID][0][A_PITCH] := soundAttrs[pID][0][A_PITCH] * timerCoeff;
    soundAttrs[pID][1][A_VOLUME] := soundAttrs[pID][1][A_VOLUME] * timerCoeff;
    soundAttrs[pID][1][A_TEMPO] := soundAttrs[pID][1][A_TEMPO] * timerCoeff;
    soundAttrs[pID][1][A_PITCH] := soundAttrs[pID][1][A_PITCH] * timerCoeff;

    if fadeTimers[pID] = -20 then
    begin
      FreeChannel(channels[pID][0]);
      FreeChannel(channels[pID][1]);
      fadeTimers[pID] := 0;
    end;
  end;

  if CheckChannel(channels[pID][0]) or CheckChannel(channels[pID][1]) then
  begin
    SetChannelAttributes(channels[pID][0], soundAttrs[pID][0]);
    SetChannelAttributes(channels[pID][1], soundAttrs[pID][1]);

    if fadeInStates[pID] and (fadeTimers[pID] <= 22) then
      Inc(fadeTimers[pID], 2)
    else if fadeTimers[pID] > 20 then
      fadeInStates[pID] := False;

    Dec(fadeTimers[pID]);
  end;
end;

procedure HandlePneumaticSounds(var channels: TPneumaticsFX; var soundAttrs: TPneumaticsAttrs;
  var fadeTimers: TPneumaticsAux<Integer>; var fadeInStates: TPneumaticsAux<Boolean>; km395: Byte; tm: TValue<Single>;
  ur: TValue<Single>; nap: TValue<Single>; dt: TValue<Single>; tc: TValue<Single>);
begin
  HandleZaryadkaSound(channels, soundAttrs, km395, tm, nap);
  HandleVipuskSound(channels, soundAttrs, fadeTimers, tm);
  HandleVpuskSound(channels, soundAttrs, km395, tm, ur, nap);

  if dt[V_CUR] < dt[V_PRV] then
    HandleDTTCSounds(channels, soundAttrs, fadeTimers, fadeInStates, PN_DT, dt);

  HandleTormSound(channels, soundAttrs, km395, ur);
  HandleDTTCSounds(channels, soundAttrs, fadeTimers, fadeInStates, PN_TC, tc);
end;

procedure HandleBrakeSounds(var brakeChannel: TChannelFX; var brakeAttrs: TSoundAttrs; var brakeScrChannel: TChannelFX;
  var brakeScrAttrs: TSoundAttrs; tc: Double; Speed: Double; EDTAmperage: Double);
begin
  if (tc > 0) and (Speed > 0) then
  begin
    brakeAttrs[A_VOLUME] := 2 * Ln(2 * tc / Speed + 1);
    brakeAttrs[A_TEMPO] := Speed * Speed;

    if brakeAttrs[A_VOLUME] > 0.1 then
      brakeAttrs[A_VOLUME] := 0.1;

    if EDTAmperage <> 0 then
      brakeAttrs[A_VOLUME] := 0.125 * brakeAttrs[A_VOLUME];
    brakeAttrs[A_TEMPO] := brakeAttrs[A_VOLUME] / Ln(Speed + 1);

    if CheckChannel(brakeChannel, False) then
      RestartChannel(brakeChannel, 'TWS/brake_slipp.wav', brakeAttrs, BASS_SAMPLE_LOOP);
    SetChannelAttributes(brakeChannel, brakeAttrs);

    if Speed <= 6 then
    begin
      brakeScrAttrs[A_VOLUME] := 0.0278 * tc * (1 / Ln(Speed + 1.1) - 0.55);
      brakeScrAttrs[A_TEMPO] := 50 / (brakeAttrs[A_TEMPO] + 0.1);
      if brakeScrAttrs[A_VOLUME] > 0.75 then
        brakeScrAttrs[A_VOLUME] := 0.75
      else if brakeScrAttrs[A_VOLUME] < 0 then
        brakeScrAttrs[A_VOLUME] := 0;

      if CheckChannel(brakeScrChannel, False) then
        RestartChannel(brakeScrChannel, 'TWS/brake_scr.wav', brakeScrAttrs, BASS_SAMPLE_LOOP);
      SetChannelAttributes(brakeScrChannel, brakeScrAttrs);
    end
    else
      FreeChannel(brakeScrChannel);
  end
  else if ((tc <= 0) or (Speed <= 0)) and (CheckChannel(brakeChannel) or CheckChannel(brakeScrChannel)) then
  begin
    FreeChannel(brakeChannel);
    FreeChannel(brakeScrChannel);
  end;
end;

// TEDs
procedure HandleTEDSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKM1: Integer);
begin
  if TEDAmperage <> 0 then
    soundAttrs[A_VOLUME] := TEDAmperage
  else if EDTAmperage <> 0 then
    soundAttrs[A_VOLUME] := EDTAmperage
  else
    soundAttrs[A_VOLUME] := 0.0;
  soundAttrs[A_VOLUME] := Ln(0.25 * soundAttrs[A_VOLUME] / ultimateTEDAmperage + 1);

  if (TEDAmperage <> 0) or (EDTAmperage <> 0) then
  begin
    if CheckChannel(channels[0], False) and CheckChannel(channels[1], False) then
    begin
      RestartChannel(channels[0], soundFile, soundAttrs, BASS_SAMPLE_LOOP);
      RestartChannel(channels[1], soundFile, soundAttrs, BASS_SAMPLE_LOOP);
    end;

    SetChannelAttributes(channels[0], soundAttrs);
    SetChannelAttributes(channels[1], soundAttrs);
  end
  else
  begin
    FreeChannel(channels[0]);
    FreeChannel(channels[1]);
  end;
end;

// Reductors
procedure HandleReductorSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; Speed: Double);
begin
  if Speed > 0 then
  begin
    ReduktorAttrs[A_VOLUME] := Ln(Speed * (0.005 + power(TEDAmperage / ultimateTEDAmperage, 2)) + 1);
    ReduktorAttrs[A_PITCH] := 6 * Ln(Speed) - 20;

    if CheckChannel(channels[0], False) or CheckChannel(channels[1], False) or CheckChannel(channels[2], False) then
    begin
      RestartChannel(channels[0], soundFile, soundAttrs, BASS_SAMPLE_LOOP);
      RestartChannel(channels[1], soundFile, soundAttrs, BASS_SAMPLE_LOOP);
    end;

    SetChannelAttributes(channels[0], soundAttrs);
    SetChannelAttributes(channels[1], soundAttrs);
  end
  else
  begin
    FreeChannel(channels[0]);
    FreeChannel(channels[1]);
  end;
end;

// Ezda-Perestuk
procedure HandleEzda(var ezdaChannel: TChannelFX; var ezdaAttrs: TSoundAttrs; var shumChannel: TChannelFX;
  var shumAttrs: TSoundAttrs; Speed: Double);
var
  lnSpeed: Double;
begin
  lnSpeed := Ln(Speed + 1);

  if (Speed >= 5) then
  begin
    ezdaAttrs[A_VOLUME] := 0.005 * Speed * Ln(Speed - 4);
    ezdaAttrs[A_TEMPO] := 10 * lnSpeed;
    ezdaAttrs[A_PITCH] := lnSpeed;

    if CheckChannel(ezdaChannel, False) then
      RestartChannel(ezdaChannel, 'TWS/' + Loco + '/ezda.wav', ezdaAttrs, BASS_SAMPLE_LOOP);
    SetChannelAttributes(ezdaChannel, ezdaAttrs);
  end
  else if CheckChannel(ezdaChannel) then
    FreeChannel(ezdaChannel);

  if Speed >= 3 then
  begin
    shumAttrs[A_VOLUME] := 0.01 * Speed * Ln(Speed - 2);
    shumAttrs[A_TEMPO] := 10 * lnSpeed;
    shumAttrs[A_PITCH] := 0.1 * lnSpeed;

    if CheckChannel(shumChannel, False) then
      RestartChannel(shumChannel, 'TWS/shum.wav', shumAttrs, BASS_SAMPLE_LOOP);
    SetChannelAttributes(shumChannel, shumAttrs);
  end
  else if CheckChannel(shumChannel) then
    FreeChannel(shumChannel);
end;

procedure HandlePerestuk(var channels: array of TChannelFX; var soundStack: TPerestukStack; var stackSize: Integer;
  Speed: Double; track: TValue<Integer>; axesAmount: Integer; axesDistancesWagon: array of Integer;
  axesDistancesLoco: array of Integer; axesLocoAmount: Integer);
begin
  // Timer
  for var k := 0 to stackSize - 1 do
    if soundStack[k][P_TIME] > 0 then
      soundStack[k][P_TIME] := soundStack[k][P_TIME] - 30;

  // LCtrl + Numpad+ or RCtrl + Numpad-
  const
    isTrackChangeKeyPressed = (GetAsyncKeyState(162) + GetAsyncKeyState(163)) *
      (GetAsyncKeyState(107) + GetAsyncKeyState(109)) = 0;

    // On joint
  if (Abs(track[V_PRV] - track[V_CUR]) > 0) and isTrackChangeKeyPressed and (stackSize < Length(soundStack)) then
  begin
    soundStack[stackSize][P_ID] := Round(random() * 2 + 1);
    Inc(stackSize);
  end;

  // Sound
  if (Speed >= 3) and (stackSize > 0) then
  begin
    for var k := 0 to stackSize - 1 do
    begin
      const
        axisIdx = soundStack[k][P_AXIS_IDX];

      if axisIdx >= axesAmount then
      begin
        soundStack[k][P_AXIS_IDX] := 0;
        soundStack[k][P_TIME] := 0;
        Dec(stackSize);
      end
      else if soundStack[k][P_TIME] <= 0 then
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
        if axisIdx < axesLocoAmount - 1 then
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

        if stackSize >= Length(channels) then
          stackSize := stackSize;

        // Play
        if PerestukAttrs[A_VOLUME] > 0.0001 then
        begin
          for var l := 0 to Length(channels) - 1 do
          begin
            if CheckChannel(channels[l], False) then
            begin
              var
              stukId := soundStack[k][P_ID];
              if (axisIdx Mod 4 < 2) then
                stukId := stukId Mod 3 + 1;

              RestartChannel(channels[l], 'TWS/stuk' + stukId.ToString() + '.wav', PerestukAttrs);
              break;
            end;
          end;
        end;

        Inc(soundStack[k][P_AXIS_IDX]);
        soundStack[k][P_TIME] := Trunc(3.6 * nextAxisDistance / Speed);
      end;
    end;
  end;
end;

// Vstrech
procedure HandleVstrech(vstrechStatus: TValue<Byte>; track: Integer; vstrTrack: TValue<WORD>; MP: Byte;
  vstrSpeed: Single; wagNumVstr: Integer; vstrechaDlina: Integer; TrackVstrechi: Integer);
var
  I: Double;
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
        Vstrech := BASS_StreamCreateFile(False, VstrechF, 0, 0, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Vstrech, True);
        isPlayVstrech := True;

        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);

        I := 22050 + Speed[V_CUR] * 300;
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_FREQ, I);
      end;
    end;

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
procedure HandleMVSounds(ramState: Byte; var state: Boolean; var channels: array of TChannelFX; soundAttrs: TSoundAttrs;
  locoWorkDir: String; prefix: String = '');
var
  pathRoot: String;
  xPathRoot: String;
begin
  pathRoot := locoWorkDir + 'mv' + prefix + '-';
  xPathRoot := locoWorkDir + 'x_mv' + prefix + '-';

  if ramState = 1 then
  begin
    if state = False then
    begin
      RestartChannel(channels[0], pathRoot + 'start.wav', soundAttrs);
      RestartChannel(channels[1], xPathRoot + 'start.wav', soundAttrs);

      soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
      RestartChannel(channels[2], xPathRoot + 'start.wav', soundAttrs);
      state := True;
    end
    else if CheckChannel(channels[0], False) and CheckChannel(channels[1], False) and CheckChannel(channels[2], False)
    then
    begin
      RestartChannel(channels[0], pathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);
      RestartChannel(channels[1], xPathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);

      // soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
      RestartChannel(channels[2], xPathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);
    end;
  end
  else if state then
  begin
    RestartChannel(channels[0], pathRoot + 'stop.wav', soundAttrs);
    RestartChannel(channels[1], xPathRoot + 'stop.wav', soundAttrs);

    soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
    RestartChannel(channels[2], xPathRoot + 'stop.wav', soundAttrs);
    state := False;
  end;

end;

procedure HandleMKSounds(ramState: array of Single; var state: array of Boolean; var channels: array of TChannelFX;
  soundAttrs: TSoundAttrs; locoWorkDir: String);
var
  pathRoot: String;
  xPathRoot: String;
begin
  pathRoot := locoWorkDir + 'mk-';
  xPathRoot := locoWorkDir + 'x_mk-';

  if ramState[0] = 1 then
  begin
    if state[0] = False then
    begin
      RestartChannel(channels[0], pathRoot + 'start.wav', soundAttrs);
      RestartChannel(channels[1], xPathRoot + 'start.wav', soundAttrs);
      state[0] := True;
    end
    else if CheckChannel(channels[0], False) or CheckChannel(channels[1], False) then
    begin
      RestartChannel(channels[0], pathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);
      RestartChannel(channels[1], xPathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);
    end;
  end
  else if state[0] then
  begin
    RestartChannel(channels[0], pathRoot + 'stop.wav', soundAttrs);
    RestartChannel(channels[1], xPathRoot + 'stop.wav', soundAttrs);
    state[0] := False;
  end;

  if ramState[1] = 1 then
  begin
    if state[1] = False then
    begin
      soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
      RestartChannel(channels[2], xPathRoot + 'start.wav', soundAttrs);
      state[1] := True;
    end
    else if CheckChannel(channels[2], False) then
    begin
      soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
      RestartChannel(channels[2], xPathRoot + 'loop.wav', soundAttrs, BASS_SAMPLE_LOOP);
    end;
  end
  else if state[1] then
  begin
    soundAttrs[A_TEMPO] := soundAttrs[A_TEMPO] + 10;
    RestartChannel(channels[2], xPathRoot + 'stop.wav', soundAttrs);
    state[1] := False;
  end;
end;

procedure HandleMVPitch(var mvChannels: array of TChannelFX; var soundAttrs: TSoundAttrs;
  var mvTDChannels: array of TChannelFX; var mvTDAttrs: TSoundAttrs);
begin
  if LocoWithMVPitch then
  begin
    var
    deltaMVPitch := VentPitchIncrementer * MainCycleFreq;

    if soundAttrs[A_PITCH] > VentPitchDest then
      soundAttrs[A_PITCH] := soundAttrs[A_PITCH] - deltaMVPitch
    else if soundAttrs[A_PITCH] < VentPitchDest then
      soundAttrs[A_PITCH] := soundAttrs[A_PITCH] + deltaMVPitch;

    SetChannelAttributes(mvChannels[0], soundAttrs);
    SetChannelAttributes(mvChannels[1], soundAttrs);
    SetChannelAttributes(mvChannels[2], soundAttrs);
  end;

  if LocoWithMVTDPitch then
  begin
    var
    deltaMVTDPitch := VentTDPitchIncrementer * MainCycleFreq;

    if mvTDAttrs[A_PITCH] > VentTDPitchDest then
      mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] - deltaMVTDPitch
    else if VentTDPitch < VentTDPitchDest then
      mvTDAttrs[A_PITCH] := mvTDAttrs[A_PITCH] + deltaMVTDPitch;

    SetChannelAttributes(mvTDChannels[0], mvTDAttrs);
    SetChannelAttributes(mvTDChannels[1], mvTDAttrs);
    SetChannelAttributes(mvTDChannels[2], mvTDAttrs);
  end;
end;

procedure HandleMiscSounds(var channels: array of Cardinal; rain: TValue<Byte>; track: Integer;
  outsideLocoStatus: Byte);
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
      if (CheckChannel(channels[0], False)) then
        RestartChannel(channels[0], FileName, BASS_SAMPLE_LOOP)
    end;

    if track = 0 then
      rain[V_CUR] := 0;
    if rain[V_CUR] = 0 then
      FreeChannel(channels[0])
  end
  else if outsideLocoStatus <> 0 then
  begin
    if GetAsyncKeyState(37) + GetAsyncKeyState(39) <> 0 then
      RestartChannel(channels[0], 'TWS/snow_walk.wav', BASS_SAMPLE_LOOP)
    else if CheckChannel(channels[0]) then
      FreeChannel(channels[0]);
  end;
end;

procedure HandlePRSSounds(var channels: array of Cardinal; isRZDChecked: Boolean; isUZChecked: Boolean);
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

    PlaySound(channels, PRSF);
  end;
end;

/// //////////////////////////////////////////////////////////////////////

// Refresh Volume
procedure RefreshVolume();
begin
  With FormMain do
  begin
    // -/- ВИД: КАБИНА; ПОЛОЖЕНИЕЖ ВНУТРИ КАБИНЫ -/- //
    if Camera[V_CUR] = 0 then
    begin
      if isCameraInCabin = True then
      begin
        // Шум езды (в ст. вар. перестук) [1]
        // BASS_ChannelSetAttribute(ezdaChannel[C_FX], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // Шум езды (в ст. вар. перестук) [2]
        // BASS_ChannelSetAttribute(channels[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // if cbExtIntSounds.Checked = False then
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, 0)
        // else
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 60);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 100);
        // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        // BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 0.5);
        BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, trcBarSAVPVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, trcBarSAVPVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        // BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        // BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        // BASS_ChannelSetAttribute(TEDChannelFX, BASS_ATTRIB_VOL, TEDVlm * 0.85);
        // BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm * 0.85);
        // if BV[V_CUR] <> 0 then
        // begin
        // Case ChannelNumDiz Of
        // 1:
        // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
        // 0:
        // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
        // end;
        // end
        // else
        // begin
        // Case ChannelNumDiz Of
        // 1:
        // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 300);
        // 0:
        // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 300);
        // end;
        // end;
        // Задаём громкость наружных вентиляторов 0
        if LocoWithExtMVSound = True then
        begin
          // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        end;
        // Задаем громкость компрессоров снаружи 0
        // if Loco = 'ED4M' then
        // begin
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 250);
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 250);
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 250);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 250);
        // end
        // else
        // begin
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
        // (VentVolume / 125) * (trcBarVspomMahVol.Position / 100));
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
        // (CycleVentVolume / 125) * (trcBarVspomMahVol.Position / 100));
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // end;
      end
      else
      begin
        // -/- ВИД: КАБИНА; ПОЛОЖЕНИЕЖ СНАРУЖИ КАБИНЫ -/- //
        // BASS_ChannelSetAttribute(ezdaChannel[0], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // BASS_ChannelSetAttribute(channels[0], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 200);
        // BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        // Делаем внешние звуки МВ
        if LocoWithExtMVSound = True then
        begin
          // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        end
        else
        begin
          // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          // if Loco <> 'ED4M' then
          // begin
          // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
          // (VentVolume / 70) * (trcBarVspomMahVol.Position / 100));
          // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
          // (CycleVentVolume / 70) * (trcBarVspomMahVol.Position / 100));
          // end
          // else
          // begin
          // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
          // trcBarVspomMahVol.Position / 100);
          // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
          // trcBarVspomMahVol.Position / 100);
          // end;
          // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        end;
        // // Делаем внешние звуки МК
        // if LocoWithExtMKSound = True then
        // begin
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // end
        // else
        // begin
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // end;
        // BASS_ChannelSetAttribute(TEDChannelFX, BASS_ATTRIB_VOL, TEDVlm);
        // BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm);
        // if BV <> 0 then
        // begin
        // Case ChannelNumDiz Of
        // 1:
        // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
        // 0:
        // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
        // end;
        // end
        // else
        // begin
        // Case ChannelNumDiz Of
        // 1:
        // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 180);
        // 0:
        // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 180);
        // end;
        // end;
        // BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 200);
        // BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
        // BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
      end;
    end;
    // -/- ВИД: НА ЛОКОМОТИВ -/- //
    if (Camera[V_CUR] = 1) then
    begin
      // BASS_ChannelSetAttribute(ezdaChannel[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(shumChannel[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(channels[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);
      BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(TEDChannelFX, BASS_ATTRIB_VOL, TEDVlm);
      // BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm);
      // if ChannelNumDiz = 1 then
      // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
      // if ChannelNumDiz = 0 then
      // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
      // BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
      // BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      // -/- МВ -/- //
      if LocoWithExtMVSound = True then
      begin
        // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
      end
      else
      begin
        // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // if Loco <> 'ED4M' then
        // begin
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
        // (VentVolume / 70) * (trcBarVspomMahVol.Position / 100));
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
        // (CycleVentVolume / 70) * (trcBarVspomMahVol.Position / 100));
        // end
        // else
        // begin
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 100);
        // end;
        // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      end;
      // -/- МК -/- //
      if LocoWithExtMKSound = True then
      begin
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      end
      else
      begin
        // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      end;
      // BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, 0);
    end;
    // -/- ВИД: ХВОСТ -/- //
    if Camera[V_CUR] = 2 then
    begin
      // BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
      // if Loco = 'ED4M' then
      // begin
      // BASS_ChannelSetAttribute(ezdaChannel[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(ezdaChannel[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(channels[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // end
      // else
      // begin
      // BASS_ChannelSetAttribute(ezdaChannel[1], BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(channels[1], BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      // end;
      // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);
      BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(TEDChannelFX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, 0);
      // if ChannelNumDiz = 1 then
      // BASS_ChannelSlideAttribute(DizChannel, BASS_ATTRIB_VOL, 0, 1);
      // if ChannelNumDiz = 0 then
      // BASS_ChannelSlideAttribute(DizChannel2, BASS_ATTRIB_VOL, 0, 1);
      // BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, 0);
    end;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма прохода звукового менеджера (сравнение нужно-ли что-то воспр.?) //
// ------------------------------------------------------------------------------//
procedure SoundManagerTick();
var
  I: Integer;
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
          SAUTChannelObjects := BASS_StreamCreateFile(False, SAUTF, 0, 0, DEFAULT_FLAG);
        end
        else
        begin
          SAUTChannelObjects := BASS_StreamCreateFile(True, ResPotok.Memory, 0, ResPotok.Size, DEFAULT_FLAG);
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
          SAUTChannelObjects2 := BASS_StreamCreateFile(False, SAUTF, 0, 0, DEFAULT_FLAG);
        end
        else
        begin
          SAUTChannelObjects2 := BASS_StreamCreateFile(True, ResPotok.Memory, 0, ResPotok.Size, DEFAULT_FLAG);
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
        SAUTChannelZvonok := BASS_StreamCreateFile(False, SAUTF, 0, 0, BASS_SAMPLE_LOOP);
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
