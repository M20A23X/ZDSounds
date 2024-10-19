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
  TSoundAttrIdx = (A_VOLUME, A_TEMPO, A_PITCH);
  TPerestukStackAttr = (P_AXIS_IDX, P_TIME, P_ID);
  TChannelIdx = (C_FILE, C_FX);

  TPerestukStack = array of array [TPerestukStackAttr] of Integer;
  TSoundAttrs = array [TSoundAttrIdx] of Double;
  TChannelFX = array [TChannelIdx] of Cardinal;
  TSignals = array [0 .. 1, 0 .. 1] of Cardinal;

procedure SoundManagerTick();

procedure RefreshVolume();
procedure TWS_PlayUnipuls(FileName: PChar; Loop: Boolean);
procedure DecodeResAndPlay(FileName: String; var FlagName: Boolean; var PCharName: PChar; var ChannelName: Cardinal;
  var ResPotok: TMemoryStream; var PlayResFlag: Boolean); external 'dg2020.dll';

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
  ogrSpeed: Integer; prevOgrSpeed: Byte; nextOgrSpeed: Byte; prevNextOgrSpeed: Integer; var nextOgrPeekStatus: Byte;
  Speed: Double; svetofor: Byte; prevSvetofor: Byte; var prevKeyTAB: Byte; klubOpen: Byte);

procedure Handle3SL2mSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal);

// TP
procedure HandleTPSounds(var channels: array of Cardinal; locoWithSndTP: Boolean; frontTP: Single; prevFrontTP: Single;
  backTP: Single; prevBackTP: Single);

// Clicks
procedure HandleClickSounds(var channels: array of Cardinal; var miscChannels: array of Cardinal; km395: Byte;
  prevKm395: Byte; km294: Single; prevKM294: Single; var prevEPKKey: Byte; prevKMAbs: Integer; kmPos1: Integer;
  reostat: Integer; prevReostat: Integer; voltage: Double; prevVoltage: Double; locoWithSndReversor: Boolean;
  locoSndReversorType: Byte; reversorPos: Integer; var prevReversKey: Char; stochist: Single; prevStochist: Single);

procedure HandleKMSounds(var channels: array of Cardinal; KMOP: Byte; prevKMOP: Byte; var prevKMKey: Char);

// Brake
procedure HandleBrakeKMSounds(var channels: array of TChannelFX; var soundAttrs: array of TSoundAttrs;
  var fadeTimer: Integer; brakeCylinders: Double; prevBrakeCylinders: Double; var isBrake254FadeIn: Boolean);

procedure HandleBrakeSounds(var brakeChannel: TChannelFX; var brakeAttrs: TSoundAttrs; var brakeScrChannel: TChannelFX;
  var brakeScrAttrs: TSoundAttrs; brakeCylinders: Double; Speed: Double; EDTAmperage: Double);

// TEDs
procedure HandleTEDSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKMPos1: Integer; tedNow: Integer);

// Reductors
procedure HandleReductorSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; Speed: Double);

// Ezda-Perestuk
procedure HandleEzda(Speed: Double; var ezdaChannel: TChannelFX; var ezdaAttrs: TSoundAttrs;
  var shumChannel: TChannelFX; var shumAttrs: TSoundAttrs);

procedure HandlePerestuk(var channels: array of TChannelFX; var soundStack: TPerestukStack; var stackSize: Integer;
  Speed: Double; prevTrack: Integer; track: Integer; axesAmount: Integer; axesDistancesWagon: array of Integer;
  axesDistancesLoco: array of Integer; axesLocoAmount: Integer);

// Vstrech
procedure HandleVstrech();

// MV-MK
procedure HandleMVSounds(ramState: Byte; var state: Boolean; var channels: array of TChannelFX; soundAttrs: TSoundAttrs;
  locoWorkDir: String; prefix: String = '');

procedure HandleMKSounds(ramState: array of Single; var state: array of Boolean; var channels: array of TChannelFX;
  soundAttrs: TSoundAttrs; locoWorkDir: String);

procedure HandleMVPitch(var mvChannels: array of TChannelFX; var soundAttrs: TSoundAttrs;
  var mvTDChannels: array of TChannelFX; var mvTDAttrs: TSoundAttrs);

// Nature
procedure HandleMiscSounds(var channels: array of Cardinal; rain: Byte; prevRain: Byte; track: Integer;
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
  isPlayLocoPowerEquipment: Boolean; // Флаг для воспроизведения звуков силового оборудования локомотива(БВ, ФР)

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
  axesDistancesLoco: array of Integer = [3200, 4700, 3200, 5820, 3200, 4700, 3200, 3010];
  axesDistancesWagon: array of Integer = [2570, 2400, 15600, 2400];
  axesLocoAmount: Integer;
  axesAmount: Integer;

  // Brake slipp + scr
  BrakeChannelFX: TChannelFX;
  brakeAttrs: TSoundAttrs = (0, 0, 0);
  BrakeScrChannelFX: TChannelFX;
  brakeScrAttrs: TSoundAttrs = (0, 0, 0);

  // Brake 254
  Brake254ChannelFX: array [0 .. 1] of TChannelFX;
  Brake254Attrs: array [0 .. 1] of TSoundAttrs = (
    (
      0,
      0,
      0
    ),
    (
      0,
      0,
      0
    )
  );
  Brake254Timer: Integer;
  isBrake254FadeIn: Boolean;

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

  // Savpe informator
procedure PlaySAVPEINFOIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  SAVPENextMessage := True;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для воспроизведения звуков Унипульса               //
// ------------------------------------------------------------------------------//
procedure TWS_PlayUnipuls(FileName: PChar; Loop: Boolean);
begin
  // With CHS8__ do
  // begin
  // try
  // BASS_ChannelStop(Unipuls_Channel[UnipulsChanNum]);
  // BASS_StreamFree(Unipuls_Channel[UnipulsChanNum]);
  // if Loop = True then
  // Unipuls_Channel[UnipulsChanNum] := BASS_StreamCreateFile(False, FileName, 0, 0, LOOP_FLAG);
  // if Loop = False then
  // Unipuls_Channel[UnipulsChanNum] := BASS_StreamCreateFile(False, FileName, 0, 0, DEFAULT_FLAG);
  // BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0);
  // BASS_ChannelPlay(Unipuls_Channel[UnipulsChanNum], False);
  // if Camera <> 2 then
  // UnipulsVol1 := FormMain.trcBarVspomMahVol.Position
  // else
  // UnipulsVol1 := 0;
  // if Camera = 2 then
  // UnipulsVol1 := 0;
  // if UnipulsChanNum = 0 then
  // begin
  // BASS_ChannelSlideAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, UnipulsVol1 / 100, 500);
  // BASS_ChannelSlideAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, 0, 1000);
  // end
  // else
  // begin
  // BASS_ChannelSlideAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, UnipulsVol1 / 100, 500);
  // BASS_ChannelSlideAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, 0, 1000);
  // end;
  // if UnipulsChanNum = 0 then
  // UnipulsChanNum := 1
  // else
  // UnipulsChanNum := 0;
  // FormMain.TimerPerehodUnipulsSwitch.Enabled := True;
  // except
  // end;
  // end;
end;

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
  ogrSpeed: Integer; prevOgrSpeed: Byte; nextOgrSpeed: Byte; prevNextOgrSpeed: Integer; var nextOgrPeekStatus: Byte;
  Speed: Double; svetofor: Byte; prevSvetofor: Byte; var prevKeyTAB: Byte; klubOpen: Byte);
begin
  // Нажатие РБ и РБС
  if (RB <> PrevRB) or (RBS <> PrevRBS) then
    PlaySound(channels, 'TWS/KLUB_pick.wav');

  // Пиканья при ограничении
  if (ogrSpeed - Speed <= 3) and (ogrSpeed <> 0) and (svetofor <> 0) then
    PlaySound(channels, 'TWS/KLUB_pick.wav');
  if (ogrSpeed - Speed > 3) or (ogrSpeed = 0) then
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
  if svetofor <> prevSvetofor then
    PlaySound(channels, 'TWS/KLUB_beep.wav');

  // Проверка бдительности
  if (PrevVCheck <> VCheck) and (VCheck = 1) then
    PlaySound(channels, 'TWS/KLUB_beep.wav');

  if nextOgrPeekStatus = 0 then
  begin
    if prevOgrSpeed > ogrSpeed then
    begin
      if nextOgrSpeed <> 0 then
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
    if (nextOgrSpeed <> prevNextOgrSpeed) or (nextOgrSpeed = 0) then
      nextOgrPeekStatus := 0;
end;

procedure Handle3SL2mSounds(var channels: array of Cardinal; var skorostemerChannel: array of Cardinal);
var
  soundFile: String;
begin
  // RB-RBS
  if (RB <> PrevRB) or (RBS <> PrevRBS) then
  begin
    if RB = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if RB = 0 then
      soundFile := 'TWS/RB_MexUp.wav';

    RestartChannel(channels[0], soundFile);

    if RBS = 1 then
      soundFile := 'TWS/RB_MexDown.wav'
    else if RBS = 0 then
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

  if (Speed <= 0) and CheckChannel(skorostemerChannel[1]) or (Speed > 0) and CheckChannel(skorostemerChannel[1], False)
  then
  begin
    soundFile := 'TWS/Devices/3SL2M/';

    if (Speed <= 0) and CheckChannel(skorostemerChannel[1]) then
      FreeChannel(skorostemerChannel[1])
    else if (Speed > 0) and (Speed <= 2) and (PrevSpeed_Fakt > 0) then
      RestartChannel(skorostemerChannel[1], soundFile + 'start.wav', BASS_SAMPLE_LOOP)
    else if Speed > 2 then
      RestartChannel(skorostemerChannel[1], soundFile + 'loop.wav', BASS_SAMPLE_LOOP);
  end;
end;

// TPs
procedure HandleTPSounds(var channels: array of Cardinal; locoWithSndTP: Boolean; frontTP: Single; prevFrontTP: Single;
  backTP: Single; prevBackTP: Single);
var
  soundFile: String;
begin
  if locoWithSndTP then
  begin
    // ПЕРЕДНИЙ
    if (frontTP = 63) and (frontTP <> prevFrontTP) then
      soundFile := 'TWS/TPUp.wav'
    else if (frontTP <> 63) and (prevFrontTP = 63) and (prevFrontTP <> 188) then
      soundFile := 'TWS/TPDown.wav';

    PlaySound(channels, soundFile);

    // ЗАДНИЙ
    if (backTP = 63) and (backTP <> prevBackTP) then
      soundFile := 'TWS/TPUp.wav'
    else if (backTP <> 63) and (prevBackTP = 63) and (prevBackTP <> 188) then
      soundFile := 'TWS/TPDown.wav';

    PlaySound(channels, soundFile);
  end;
end;

// Clicks
procedure HandleClickSounds(var channels: array of Cardinal; var miscChannels: array of Cardinal; km395: Byte;
  prevKm395: Byte; km294: Single; prevKM294: Single; var prevEPKKey: Byte; prevKMAbs: Integer; kmPos1: Integer;
  reostat: Integer; prevReostat: Integer; voltage: Double; prevVoltage: Double; locoWithSndReversor: Boolean;
  locoSndReversorType: Byte; reversorPos: Integer; var prevReversKey: Char; stochist: Single; prevStochist: Single);
var
  soundFile: String;
  reversKey: Char;
  epkKey: Byte;
begin
  // 254 / 395
  if (km395 <> prevKm395) and (km395 <> 1) and (km395 <> 6) then
    PlaySound(channels, 'TWS/stuk395.wav');

  if (km294 <> prevKM294) and (km294 <> -1) and (prevKM294 <> -1) then
    PlaySound(channels, 'TWS/stuk254.wav');

  // ЭПК
  if GetAsyncKeyState(78) <> 0 then
    if GetAsyncKeyState(16) <> 0 then
      epkKey := 2
    else
      epkKey := 1;
  if (prevEPKKey <> epkKey) and (epkKey <> 0) then
  begin
    PlaySound(channels, 'TWS/epk.wav');
    prevEPKKey := epkKey;
  end;

  // ЭМЗ
  if (prevKMAbs = 0) and (kmPos1 > 0) or ((kmPos1 = 0) and (prevKMAbs > 0)) or (prevReostat + reostat = 1) then
    PlaySound(channels, 'TWS/Devices/21KR/EM_zashelka.wav');

  // РЕЛЕ НАПРЯЖЕНИЯ
  if (prevVoltage = 0) and (voltage <> 0) then
    PlaySound(channels, 'TWS/CHS7/rn.wav');

  // РЕВЕРСИВКА
  if locoWithSndReversor then
  begin
    if GetAsyncKeyState(87) <> 0 then
      reversKey := 'W'
    else if GetAsyncKeyState(83) <> 0 then
      reversKey := 'S';
    if (locoSndReversorType = 1) and (kmPos1 = 0) and (reversKey <> prevReversKey) then
      soundFile := RevPosF
    else if (locoSndReversorType = 0) and (reversorPos <> prevReversorPos) then
      soundFile := RevPosF;

    prevReversKey := reversKey;
    PlaySound(channels, soundFile);
  end;

  if stochist <> prevStochist then
  begin
    if stochist = 4 then
      RestartChannel(miscChannels[2], 'TWS/stochist.wav', BASS_SAMPLE_LOOP)
    else if stochist = 8 then
      RestartChannel(miscChannels[2], 'TWS/stochist2.wav', BASS_SAMPLE_LOOP)
    else
      FreeChannel(miscChannels[2]);
  end;

  // Если скорость стеклоочестителей 2-ая, то делаем звук удара об края стекла
  if (stochist = 8) and ((StochistDGR > 120) and (Prev_StchstDGR <= 120)) or
    ((StochistDGR < 55) and (Prev_StchstDGR >= 55)) then
    PlaySound(channels, 'stochist_udar.wav');

end;

procedure HandleKMSounds(var channels: array of Cardinal; KMOP: Byte; prevKMOP: Byte; var prevKMKey: Char);
var
  soundFile: String;
  kmKey: Char;
begin
  if GetAsyncKeyState(69) <> 0 then
    kmKey := 'E'
  else if GetAsyncKeyState(81) <> 0 then
    kmKey := 'Q'
  else
    kmKey := ' ';

  if (kmKey <> 'E') and (kmKey <> 'Q') then
  begin
    if GetAsyncKeyState(65) <> 0 then
      kmKey := 'A'
    else if (GetAsyncKeyState(68) <> 0) then
      kmKey := 'D';
  end;

  if (KMOP > 0) or (prevKMOP > 0) or (GetAsyncKeyState(16) <> 0) then
  begin
    if (KMOP <> prevKMOP) then
    begin
      if (KMOP > 0) then
        soundFile := 'op+-.wav'
      else if (KMOP = 0) and (prevKMOP > 0) then
        soundFile := 'op_vivod.wav';
    end;

    PlaySound(channels, 'TWS/Devices/21KR/' + soundFile)
  end
  else if kmKey <> prevKMKey then
  begin

    if (kmKey = 'A') and (prevKMKey <> 'A') or (kmKey = 'D') and (prevKMKey <> 'D') and (prevKMKey <> 'E') then
      soundFile := '0_+-.wav'
    else if (kmKey = 'E') and (prevKMKey <> 'E') or (kmKey = 'Q') and (prevKMKey <> 'Q') then
      soundFile := '0_+-A.wav'
    else if (prevKMKey = 'E') and (kmKey <> ' ') or (prevKMKey = 'Q') then
    begin
      soundFile := '+-A_0.wav';
      prevKMKey := kmKey;
    end
    else if (kmKey = ' ') and ((prevKMKey = 'A') or (prevKMKey = 'D')) then
      soundFile := '+-_0.wav';

    if (kmKey <> 'E') and (prevKMKey = 'E') then
      prevKMKey := kmKey
    else if (prevKMKey <> 'E') then
      prevKMKey := kmKey;

    if soundFile <> '' then
    begin
      const
        isPrevKMKeyEQ = (prevKMKey = 'E') or (prevKMKey = 'Q');
      for var l := 0 to Length(channels) - 1 do
        if isPrevKMKeyEQ and CheckChannel(channels[l], False) or (isPrevKMKeyEQ = False) then
        begin
          RestartChannel(channels[l], 'TWS/Devices/21KR/' + soundFile);
          break;
        end;
    end;
  end;
end;

// Brake
procedure HandleBrakeKMSounds(var channels: array of TChannelFX; var soundAttrs: array of TSoundAttrs;
  var fadeTimer: Integer; brakeCylinders: Double; prevBrakeCylinders: Double; var isBrake254FadeIn: Boolean);
var
  brakeDelta: Double;
  timerCoeff: Double;
begin
  brakeDelta := Abs(brakeCylinders - prevBrakeCylinders);
  if brakeDelta > 0.05 then
  begin
    if fadeTimer > 20 then
    begin
      isBrake254FadeIn := False;
      timerCoeff := 1;
    end
    else if isBrake254FadeIn = False then
      isBrake254FadeIn := True;

    if isBrake254FadeIn then
      timerCoeff := 0.05 * fadeTimer + 0.0001;

    soundAttrs[0][A_VOLUME] := Ln(0.0278 * brakeCylinders * timerCoeff * brakeDelta + 1);
    soundAttrs[1][A_VOLUME] := 0.5 * Exp(-0.005 * power(brakeCylinders * timerCoeff - 36, 2));
    soundAttrs[0][A_PITCH] := soundAttrs[0][A_VOLUME] - 1;
    soundAttrs[1][A_PITCH] := soundAttrs[0][A_PITCH];

    if CheckChannel(channels[0], False) and CheckChannel(channels[1], False) then
    begin
      RestartChannel(channels[0], 'TWS/254_shipenie.wav', soundAttrs[0], BASS_SAMPLE_LOOP);
      RestartChannel(channels[1], 'TWS/254_release.wav', soundAttrs[1], BASS_SAMPLE_LOOP);
    end;
  end
  else if (fadeTimer < 0) then
  begin
    timerCoeff := 0.05 * (fadeTimer + 20) + 0.0001;

    soundAttrs[0][A_VOLUME] := soundAttrs[0][A_VOLUME] * timerCoeff;
    soundAttrs[1][A_VOLUME] := soundAttrs[1][A_VOLUME] * timerCoeff;
    soundAttrs[0][A_PITCH] := soundAttrs[0][A_PITCH] * timerCoeff;
    soundAttrs[1][A_PITCH] := soundAttrs[1][A_PITCH] * timerCoeff;

    if fadeTimer = -20 then
    begin
      FreeChannel(channels[0]);
      FreeChannel(channels[1]);
      fadeTimer := 0;
    end;
  end;

  if CheckChannel(channels[0]) or CheckChannel(channels[1]) then
  begin
    SetChannelAttributes(channels[0], soundAttrs[0]);
    SetChannelAttributes(channels[1], soundAttrs[1]);

    if isBrake254FadeIn and (fadeTimer <= 22) then
      fadeTimer := fadeTimer + 2
    else if fadeTimer > 20 then
      isBrake254FadeIn := False;

    fadeTimer := fadeTimer - 1;
  end;
end;

procedure HandleBrakeSounds(var brakeChannel: TChannelFX; var brakeAttrs: TSoundAttrs; var brakeScrChannel: TChannelFX;
  var brakeScrAttrs: TSoundAttrs; brakeCylinders: Double; Speed: Double; EDTAmperage: Double);
begin
  if (brakeCylinders > 0) and (Speed > 0) then
  begin
    brakeAttrs[A_VOLUME] := 2 * Ln(2 * brakeCylinders / Speed + 1);
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
      brakeScrAttrs[A_VOLUME] := 0.0278 * brakeCylinders * (1 / Ln(Speed + 1.1) - 0.55);
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
  else if ((brakeCylinders <= 0) or (Speed <= 0)) and (CheckChannel(brakeChannel) or CheckChannel(brakeScrChannel)) then
  begin
    FreeChannel(brakeChannel);
    FreeChannel(brakeScrChannel);
  end;
end;

// TEDs
procedure HandleTEDSounds(var channels: array of TChannelFX; var soundAttrs: TSoundAttrs; soundFile: String;
  TEDAmperage: Double; ultimateTEDAmperage: Double; EDTAmperage: Double; prevKMPos1: Integer; tedNow: Integer);
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

  if tedNow <> prevKMPos1 then
    prevKMPos1 := tedNow;
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
procedure HandleEzda(Speed: Double; var ezdaChannel: TChannelFX; var ezdaAttrs: TSoundAttrs;
  var shumChannel: TChannelFX; var shumAttrs: TSoundAttrs);
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
  Speed: Double; prevTrack: Integer; track: Integer; axesAmount: Integer; axesDistancesWagon: array of Integer;
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
  if (Abs(prevTrack - track) > 0) and isTrackChangeKeyPressed and (stackSize < Length(soundStack)) then
  begin
    soundStack[stackSize][P_ID] := Round(random() * 2 + 1);
    inc(stackSize);
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

        inc(soundStack[k][P_AXIS_IDX]);
        soundStack[k][P_TIME] := Trunc(3.6 * nextAxisDistance / Speed);
      end;
    end;
  end;
end;

// Vstrech
procedure HandleVstrech();
var
  I: Double;
begin
  try
    if VstrechStatus <> PrevVstrechStatus then
    begin
      isVstrechDrive := True;
      VstrechStatusCounter := 0;
    end;
    var
    isCondition := track - VstrTrack > Trunc(WagNum_Vstr * Vstrecha_dlina / WagNum_Vstr / TrackLength);
    if isVstrechDrive = True then
    begin
      if (isCondition) then
        isVstrechDrive := False;
      if VstrechStatus = PrevVstrechStatus then
        inc(VstrechStatusCounter);
      if VstrechStatusCounter >= 40 then
        isVstrechDrive := False;
    end;
    if (Naprav = 'Tuda') and (PrevVstrTrack < VstrTrack) Or (Naprav = 'Obratno') and (PrevVstrTrack > VstrTrack) then
      HeadTrainEndOfTrain := False;
    if (BASS_ChannelIsActive(Vstrech) = 0) and (isVstrechDrive = True) and (HeadTrainEndOfTrain = False) then
    begin
      var
      isNearby := (track >= VstrTrack) and (Naprav = 'Tuda') and (MP <> 1) or (track <= VstrTrack) and
        (Naprav = 'Obratno') and (MP <> 1) or (track >= VstrTrack) and (Naprav = 'Tuda') and (MP = 1) and
        (Vstr_Speed > 40) or (track <= VstrTrack) and (Naprav = 'Obratno') and (MP = 1) and (Vstr_Speed > 40);
      if isNearby then
      begin
        Track_Vstrechi := track;
        if WagNum_Vstr <= 23 then
          VstrechF := PChar('TWS/Pass_vstrech.wav')
        else
          VstrechF := PChar('TWS/Freight_vstrech.wav');

        BASS_ChannelStop(Vstrech);
        BASS_StreamFree(Vstrech);
        Vstrech := BASS_StreamCreateFile(False, VstrechF, 0, 0, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Vstrech, True);
        isPlayVstrech := True;

        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);

        I := 22050 + Speed * 300;
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
        if (MP = 1) and (Vstr_Speed <= 40) then
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

procedure HandleMiscSounds(var channels: array of Cardinal; rain: Byte; prevRain: Byte; track: Integer;
  outsideLocoStatus: Byte);
var
  FileName: String;
begin
  if Winter = 0 then
  begin
    if rain >= 80 then
      rain := Trunc(0.0125 * rain)
    else if rain > 0 then
      rain := 1;

    if rain <> prevRain then
    begin
      Case rain Of
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
      rain := 0;
    if rain = 0 then
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
    if Camera = 0 then
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
        if BV <> 0 then
        begin
          Case ChannelNumDiz Of
            1:
              BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
            0:
              BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
          end;
        end
        else
        begin
          Case ChannelNumDiz Of
            1:
              BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 300);
            0:
              BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 300);
          end;
        end;
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
        if BV <> 0 then
        begin
          Case ChannelNumDiz Of
            1:
              BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
            0:
              BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
          end;
        end
        else
        begin
          Case ChannelNumDiz Of
            1:
              BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 180);
            0:
              BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 180);
          end;
        end;
        // BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 200);
        // BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
        // BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
      end;
    end;
    // -/- ВИД: НА ЛОКОМОТИВ -/- //
    if (Camera = 1) then
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
      if ChannelNumDiz = 1 then
        BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
      if ChannelNumDiz = 0 then
        BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
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
    if Camera = 2 then
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
      if ChannelNumDiz = 1 then
        BASS_ChannelSlideAttribute(DizChannel, BASS_ATTRIB_VOL, 0, 1);
      if ChannelNumDiz = 0 then
        BASS_ChannelSlideAttribute(DizChannel2, BASS_ATTRIB_VOL, 0, 1);
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

    // BV, FR
    if isPlayLocoPowerEquipment = False then
    begin
      try
        BASS_ChannelStop(LocoPowerEquipment);
        BASS_StreamFree(LocoPowerEquipment);
        isPlayLocoPowerEquipment := True;
        LocoPowerEquipment := BASS_StreamCreateFile(False, LocoPowerEquipmentF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(LocoPowerEquipment, True);
        BASS_ChannelSetAttribute(LocoPowerEquipment, BASS_ATTRIB_VOL, 0.01 * trcBarVspomMahVol.Position);
      except
      end;
    end;
  end;
end;

end.
