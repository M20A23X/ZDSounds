﻿// ------------------------------------------------------------------------------//
// //
// Модуль звукового управления                                             //
// (c) DimaGVRH, Dnepr city, 2019                                          //
// //
// ------------------------------------------------------------------------------//
unit SoundManager;

interface

uses Classes;

procedure SoundManagerTick();
procedure TWS_MVPitchRegulation();
procedure TWS_PlayDrivingNoise(FileName: PChar);
// procedure TWS_PlayLDOOR(FileName: PChar);
// procedure TWS_PlayRDOOR(FileName: PChar);
procedure TWS_PlayUnipuls(FileName: PChar; Loop: Boolean);
procedure VolumeMaster_RefreshVolume;
procedure DecodeResAndPlay(FileName: String; var FlagName: Boolean; var PCharName: PChar; var ChannelName: Cardinal;
  var ResPotok: TMemoryStream; var PlayResFlag: Boolean); external 'dg2020.dll';
function GetChannelRemaindPlayTime2Sec(var chan: Cardinal): Double;

var
  LocoChannel: Cardinal; // Каналы перестука тележек локомотива (Шум)
  LocoChannelPerestuk: Cardinal; // Канал для перестука
  WagChannel: Cardinal; // Канал перестука тележек состава
  SAUTChannelObjects: Cardinal; // Канал для звуков САУТ объекты (1)
  SAUTChannelObjects2: Cardinal; // Канал для звуков САУТ объекты (2)
  SAUTChannelZvonok: Cardinal; // Канал для звуков САУТ звонок на переезде
  PRSChannel: Cardinal; // Канал для звуков ПРС
  TEDChannel, TEDChannel2: Cardinal; // Канал для звуков ТЭД-ов
  TEDChannel_FX: Cardinal; // Канал для звука ТЭД (эффект тональности)
  DizChannel, DizChannel2: Cardinal; // Канал для звуков Дизелей на тепловозах
  CabinClicks: Cardinal; // Канал для щелчков в кабине (395;254;контроллер;реверсор)
  Vstrech: Cardinal; // Канал для звука встречного поезда
  StukTrog: Cardinal; // Канал для удара сцепки при трограньи на Электричке
  IMRZachelka: Cardinal; // Канал для звука щелчка ЭМ-защелки №304 на Чехах (кроме ЧС2к)
  RB_Channel: Cardinal; // Канал для кнопки РБ
  PickKLUBChannel: Cardinal; // Канал для звука нажатия на кнопки КЛУБ-а
  KLUB_BEEP: Cardinal; // Канал для пиканья КЛУБ-а при смене показаний светофора
  Ogr_Speed_KLUB: Cardinal; // Канал для пиканья КЛУБ-а при приближении к ограничениею
  LocoPowerEquipment: Cardinal; // Канал для звука силового оборудования локомотива(БВ, ФР, Жалюзи)
  FrontTP_Channel, BackTP_Channel: Cardinal; // Каналы для звуков поднятия (опускания) токоприёмника
  Rain_Channel: Cardinal; // Канал для проигрывания дорожки звука дождя
  Vigilance_Check_Channel: Cardinal; // Канал для писка проверки бдительности
  Unipuls_Channel: array [0 .. 1] of Cardinal;
  Compressor_Channel: Cardinal;
  CompressorCycleChannel: Cardinal;
  XCompressor_Channel: Cardinal;
  XCompressorCycleChannel: Cardinal;
  Vent_Channel: Cardinal;
  VentCycle_Channel: Cardinal;
  VentTD_Channel: Cardinal;
  VentCycleTD_Channel: Cardinal;
  XVent_Channel: Cardinal;
  XVentCycle_Channel: Cardinal;
  XVentTD_Channel: Cardinal;
  XVentCycleTD_Channel: Cardinal;
  BrakeChannel: Cardinal;
  BrakeChannelFX: Cardinal;
  Brake254_Channel: array [0 .. 1] of Cardinal;
  Brake254_Channel_FX: array [0 .. 1] of Cardinal;
  BeltPool_Channel: Cardinal;
  ClockChannel: Cardinal;
  Stochist_Channel: Cardinal; // Канал ддя звука дворников
  StochistUdar_Channel: Cardinal; // Канал для звука о край стекла дворников
  SAVPE_Peek_Channel: Cardinal;
  SAVPE_INFO_Channel: Cardinal;
  SAVPE_ZVONOK: Cardinal;
  SvistokChannel: Cardinal;
  SvistokCycleChannel: Cardinal;
  TifonChannel: Cardinal;
  TifonCycleChannel: Cardinal;
  LDOORChannel: Cardinal;
  RDOORChannel: Cardinal;
  WalkSoundChannel: Cardinal;
  VentTD_Channel_FX: Cardinal;
  VentCycleTD_Channel_FX: Cardinal;
  XVentTD_Channel_FX: Cardinal;
  XVentCycleTD_Channel_FX: Cardinal;
  Vent_Channel_FX: Cardinal;
  VentCycle_Channel_FX: Cardinal;
  XVent_Channel_FX: Cardinal;
  XVentCycle_Channel_FX: Cardinal;
  NatureChannel: Cardinal;
  NatureChannel_FX: Cardinal;
  ReduktorChannel: Cardinal;
  ReduktorChannel_FX: Cardinal;
  VR242Channel: Cardinal;
  VR242Channel_FX: Cardinal; // ИТОГО ДОРОЖЕК В СКРИПТЕ: 54
  LocoPerestukF: PChar; // Файл звука перестука тележек локомотива
  CabinClicksF: PChar; // Кабинные щелчки (395;254;контроллер;реверсор)
  RevPosF: PChar;
  LocoFTemp: PChar;
  WagF: PChar;
  dizF: PChar; // Файлы дизелей
  VIPF: PChar; // Файлы ВИП (ЭП1м и 2ЭС5к)
  StukKMF: PChar; // Файл звука щелчка котроллера при переключении позициций
  SAUTF: PChar;
  SAUTOFFF: PChar;
  PRSF: PChar;
  TEDF, PrevTEDF: PChar;
  RBF: PChar;
  FTPF, BTPF: PChar;
  IMRZashelka: PChar;
  RainF: PChar;
  VstrechF: PChar;
  CompressorF: PChar = ' ';
  CompressorCycleF: PChar;
  XCompressorF: PChar = ' ';
  XCompressorCycleF: PChar;
  VentF, VentTDF: PChar;
  LocoPowerEquipmentF: PChar; // Силовое оборудование локомотива(БВ, ФР)
  VentCycleF: PChar;
  XVentF, XVentTDF: PChar;
  XVentCycleF: PChar;
  VentCycleTDF, XVentCycleTDF: PChar;
  BrakeF: PChar;
  SAVPEInfoF: PChar;
  TrogF: PChar; // Удар сцепки на МВПС
  StochistF: PChar; // Файл звука дворников
  WalkSoundF: PChar;
  NatureF: PChar;
  ReduktorF: PChar;
  Brake254F: PChar;
  CycleBrake254F: PChar;
  VR242F: PChar;
  isPlaySAUTObjects: Boolean; // Флаг для воспроизведения режима автоведения САУТ
  isPlaySAUTZvonok: Boolean;
  isPlayRain: Boolean;
  isPlayVcheck: Boolean;
  isPlayCompressor: Boolean;
  isPlayCompressorCycle: Boolean;
  isPlayXCompressor: Boolean;
  isPlayXCompressorCycle: Boolean;
  isPlayVent: Boolean = True;
  isPlayCycleVent: Boolean = True;
  isPlayVentTD: Boolean = True;
  isPlayCycleVentTD: Boolean = True;
  isPlayVentX: Boolean = True; // Флаг для воспроизведения звуков вентиляторов (внешних)
  isPlayCycleVentX: Boolean = True; // Флаг для воспроизведения звуков вентиляторов (внешних)
  isPlayVentTDX: Boolean = True; // Флаг для воспроизведения звуков вентиляторов (внешних)
  isPlayCycleVentTDX: Boolean = True; // Флаг для воспроизведения звуков вентиляторов (внешних)
  isPlaySAVPEPeek: Boolean;
  isPlaySAVPEInfo: Boolean;
  isPlaySAVPEZvonok: Boolean; // Флаг для воспроизведения звука трения колодок при торможении
  isPlayStochist: Boolean; // Флаг для воспроизведения звука дворников
  isPlayStochistUdar: Boolean; // Флаг для воспроизведения звука удара о край стекла удара дворников
  isPlayBeltPool: Boolean;
  isPlayOgrSpKlub: Integer;
  isPlayFTP: Boolean;
  isPlayBTP: Boolean;
  isPlayVstrech: Boolean;
  isPlayLocoPowerEquipment: Boolean; // Флаг для воспроизведения звуков силового оборудования локомотива(БВ, ФР)
  isPlayCabinClicks: Boolean; // Флаг для воспроизведения кабинных щелчков(395;254;контроллер;реверсор)
  isPlayIMRZachelka: Boolean; // Флаг для воспроизведения звков щелчка ЭМ-защелки реверсивки
  isPlayPRS: Boolean; // Флаг для воспроизведения поездной радиосвязи
  isPlayTED: Boolean; // Флаг для воспроизведения звуков ТЭД
  isPlayVIP: Boolean; // Флаг для воспроизведения звуков ВИП (ЭП1м и 2ЭС5к)
  isPlayDiz: Boolean; // Флаг для воспроизведения звуков дизелей на тепловозах
  isPlayPerestuk_OnStation: Boolean; // Флаг перестука локомотива на станции
  // Флаг перестука тележек локомотива на светофорах и на перегоне в случайные промежутки времени
  isPlayPerestuk: Boolean;
  isPlayWalkSound: Boolean;
  isPlayNature: Boolean;
  isPlayReduktor: Boolean = True;
  isPlayBrake254: Boolean = True;
  isPlayCycleBrake254: Boolean = True;
  isPlayVR242: Boolean = True;

implementation

uses Bass, UnitMain, SysUtils, Windows, ExtraUtils, bass_fx;

const
  DEFAULT_FLAG = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  LOOP_FLAG = BASS_SAMPLE_LOOP {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DECODE_FLAG = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};

  // ------------------------------------------------------------------------------//
  // Подпрограмма, вызывается когда заканчивает играть информатор САВПЭ      //
  // ------------------------------------------------------------------------------//
procedure PlaySAVPEINFOIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  SAVPENextMessage := True;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма, вызывается когда заканчивает играть сэмпл компрессоров     //
// ------------------------------------------------------------------------------//
procedure PlayCompressorIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  if BASS_ChannelIsActive(CompressorCycleChannel) = 0 then
    isPlayCompressorCycle := False;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма, вызывается когда заканчивает играть сэмпл компрессоров снаружи //
// ------------------------------------------------------------------------------//
procedure PlayXCompressorIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  if BASS_ChannelIsActive(XCompressorCycleChannel) = 0 then
    isPlayXCompressorCycle := False;
end;

// ------------------------------------------------------------------------------
//
// ------------------------------------------------------------------------------
function GetChannelRemaindPlayTime2Sec(var chan: Cardinal): Double;
begin
  Result := BASS_ChannelBytes2Seconds(chan, BASS_ChannelGetLength(chan, BASS_POS_BYTE) - BASS_ChannelGetPosition(chan,
    BASS_POS_BYTE));
end;

procedure TWS_MVPitchRegulation();
begin
  // Если локомотив с регулируемой тональностью МВ то делаем перерегулирование //
  if LocoWithMVPitch = True then
  begin
    if VentPitch > VentPitchDest then
      VentPitch := VentPitch - VentPitchIncrementer * MainCycleFreq;
    if VentPitch < VentPitchDest then
      VentPitch := VentPitch + VentPitchIncrementer * MainCycleFreq;
    // Задаём тональность звуков работы вентиляторов ВУ //
    BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentPitch);
    BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentPitch);
    BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentPitch);
    BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentPitch);
  end;
  // Если локомотив с регулируемой тональностью МВ ТД то делаем перерегулирование //
  if LocoWithMVTDPitch = True then
  begin
    if VentTDPitch > VentTDPitchDest then
      VentTDPitch := VentTDPitch - VentTDPitchIncrementer * MainCycleFreq;
    if VentTDPitch < VentTDPitchDest then
      VentTDPitch := VentTDPitch + VentTDPitchIncrementer * MainCycleFreq;
    // Задаём тональность звуков работы вентиляторов (ПТР) //
    BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentTDPitch);
    BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentTDPitch);
    BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentTDPitch);
    BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_TEMPO_PITCH, VentTDPitch);
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для воспроизведения дорожки шума езды (в ст. вар. перестуки)  //
// ------------------------------------------------------------------------------//
procedure TWS_PlayDrivingNoise(FileName: PChar);
begin
  try

  except
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для воспроизведения звука закрытия/открытия левого ряда дверей //
// ------------------------------------------------------------------------------//
// procedure TWS_PlayLDOOR(FileName: PChar);
// begin
// try BASS_ChannelStop(LDOORChannel); BASS_StreamFree(LDOORChannel);
// LDOORChannel:=BASS_StreamCreateFile(FALSE, FileName, 0, 0, 0{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
// BASS_ChannelPlay(LDOORChannel, TRUE);
// With FormMain do begin
// if Camera=0 then BASS_ChannelSetAttribute(LDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/120);
// if Camera=1 then BASS_ChannelSetAttribute(LDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/100);
// if Camera=2 then BASS_ChannelSetAttribute(LDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/100);
// end;
// except end;
// end;

// ------------------------------------------------------------------------------//
// Подпрограмма для воспроизведения звука закрытия/открытия правого ряда дверей //
// ------------------------------------------------------------------------------//
// procedure TWS_PlayRDOOR(FileName: PChar);
// begin
// try BASS_ChannelStop(RDOORChannel); BASS_StreamFree(RDOORChannel);
// RDOORChannel:=BASS_StreamCreateFile(FALSE, FileName, 0, 0, 0{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
// BASS_ChannelPlay(RDOORChannel, TRUE);
// With FormMain do begin
// if Camera=0 then BASS_ChannelSetAttribute(RDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/120);
// if Camera=1 then BASS_ChannelSetAttribute(RDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/100);
// if Camera=2 then BASS_ChannelSetAttribute(RDOORChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position/100);
// end;
// except end;
// end;

// ------------------------------------------------------------------------------//
// Подпрограмма для воспроизведения звуков Унипульса               //
// ------------------------------------------------------------------------------//
procedure TWS_PlayUnipuls(FileName: PChar; Loop: Boolean);
begin
  With CHS8__ do
  begin
    try
      BASS_ChannelStop(Unipuls_Channel[UnipulsChanNum]);
      BASS_StreamFree(Unipuls_Channel[UnipulsChanNum]);
      if Loop = True then
        Unipuls_Channel[UnipulsChanNum] := BASS_StreamCreateFile(False, FileName, 0, 0, LOOP_FLAG);
      if Loop = False then
        Unipuls_Channel[UnipulsChanNum] := BASS_StreamCreateFile(False, FileName, 0, 0, DEFAULT_FLAG);
      BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0);
      BASS_ChannelPlay(Unipuls_Channel[UnipulsChanNum], False);
      if Camera <> 2 then
        UnipulsVol1 := FormMain.trcBarVspomMahVol.Position
      else
        UnipulsVol1 := 0;
      if Camera = 2 then
        UnipulsVol1 := 0;
      if UnipulsChanNum = 0 then
      begin
        BASS_ChannelSlideAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, UnipulsVol1 / 100, 500);
        BASS_ChannelSlideAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, 0, 1000);
      end
      else
      begin
        BASS_ChannelSlideAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, UnipulsVol1 / 100, 500);
        BASS_ChannelSlideAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, 0, 1000);
      end;
      if UnipulsChanNum = 0 then
        UnipulsChanNum := 1
      else
        UnipulsChanNum := 0;
      FormMain.TimerPerehodUnipulsSwitch.Enabled := True;
    except
    end;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для задания громкости всем звукам                //
// ------------------------------------------------------------------------------//
procedure VolumeMaster_RefreshVolume;
begin
  With FormMain do
  begin
    // -/- ВИД: КАБИНА; ПОЛОЖЕНИЕЖ ВНУТРИ КАБИНЫ -/- //
    if Camera = 0 then
    begin
      if isCameraInCabin = True then
      begin
        // Шум езды (в ст. вар. перестук) [1]
        BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // Шум езды (в ст. вар. перестук) [2]
        BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        if cbExtIntSounds.Checked = False then
          BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, 0)
        else
          BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 60);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 100);
        BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 0.5);
        BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, trcBarSAVPVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, trcBarSAVPVol.Position / 100);
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
        BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        if ChannelNumTED = 1 then
          BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVlm * 0.85);
        if ChannelNumTED = 0 then
          BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm * 0.85);
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
          BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
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
        BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
          (VentVolume / 125) * (trcBarVspomMahVol.Position / 100));
        BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
          (CycleVentVolume / 125) * (trcBarVspomMahVol.Position / 100));
        BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // end;
      end
      else
      begin
        // -/- ВИД: КАБИНА; ПОЛОЖЕНИЕЖ СНАРУЖИ КАБИНЫ -/- //
        BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 200);
        BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        // Делаем внешние звуки МВ
        if LocoWithExtMVSound = True then
        begin
          BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        end
        else
        begin
          BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          // if Loco <> 'ED4M' then
          // begin
          BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
            (VentVolume / 70) * (trcBarVspomMahVol.Position / 100));
          BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
            (CycleVentVolume / 70) * (trcBarVspomMahVol.Position / 100));
          // end
          // else
          // begin
          // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
          // trcBarVspomMahVol.Position / 100);
          // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
          // trcBarVspomMahVol.Position / 100);
          // end;
          BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        end;
        // Делаем внешние звуки МК
        if LocoWithExtMKSound = True then
        begin
          BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        end
        else
        begin
          BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        end;
        if ChannelNumTED = 1 then
          BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVlm);
        if ChannelNumTED = 0 then
          BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm);
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
        BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 200);
        BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
        BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
      end;
    end;
    // -/- ВИД: НА ЛОКОМОТИВ -/- //
    if (Camera = 1) then
    begin
      BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);
      BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      if ChannelNumTED = 1 then
        BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVlm);
      if ChannelNumTED = 0 then
        BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm);
      if ChannelNumDiz = 1 then
        BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
      if ChannelNumDiz = 0 then
        BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, trcBarDieselVol.Position / 100);
      BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
      BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      // -/- МВ -/- //
      if LocoWithExtMVSound = True then
      begin
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
      end
      else
      begin
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        // if Loco <> 'ED4M' then
        // begin
        BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
          (VentVolume / 70) * (trcBarVspomMahVol.Position / 100));
        BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
          (CycleVentVolume / 70) * (trcBarVspomMahVol.Position / 100));
        // end
        // else
        // begin
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL,
        // trcBarVspomMahVol.Position / 100);
        // end;
        BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      end;
      // -/- МК -/- //
      if LocoWithExtMKSound = True then
      begin
        BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      end
      else
      begin
        BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      end;
      BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, 0);
    end;
    // -/- ВИД: ХВОСТ -/- //
    if Camera = 2 then
    begin
      BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
      // if Loco = 'ED4M' then
      // begin
      // BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // end
      // else
      // begin
      BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      // end;
      BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 1);
      BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelObjects2, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[0], BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Unipuls_Channel[1], BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, 0);
      if ChannelNumDiz = 1 then
        BASS_ChannelSlideAttribute(DizChannel, BASS_ATTRIB_VOL, 0, 1);
      if ChannelNumDiz = 0 then
        BASS_ChannelSlideAttribute(DizChannel2, BASS_ATTRIB_VOL, 0, 1);
      BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, 0);
    end;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма прохода звукового менеджера (сравнение нужно-ли что-то воспр.?) //
// ------------------------------------------------------------------------------//
procedure SoundManagerTick();
var
  NumPRS, Country: Integer; // Код страны и код звука ПРС
  I: Integer;
begin
  With FormMain do
  begin
    // === ПЕРЕСТУК ВАГОНОВ === //
    if IsPLayWag = False then
    begin
      try
        BASS_ChannelStop(WagChannel);
        BASS_StreamFree(WagChannel);
        WagChannel := BASS_StreamCreateFile(False, WagF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(WagChannel, True);
        IsPLayWag := True;
        if isCameraInCabin = False then
          BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100)
        else if cbExtIntSounds.Checked = True then
          BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100)
        else
          BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, 0);
      except
      end;
    end;
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
        SAUTChannelZvonok := BASS_StreamCreateFile(False, SAUTF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(SAUTChannelZvonok, True);
        isPlaySAUTZvonok := False;
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_FREQ, 44100);
      except
      end;
    end;
    // === УДАР СЦЕПКИ НА МВПС === //
    // if isPlayTrog = False then
    // begin
    // try
    // BASS_ChannelStop(StukTrog);
    // BASS_StreamFree(StukTrog);
    // StukTrog := BASS_StreamCreateFile(False, TrogF, 0, 0, DEFAULT_FLAG);
    // BASS_ChannelPlay(StukTrog, True);
    // isPlayTrog := True;
    // if (isCameraInCabin = False) Or (Loco = 'ED4M') then
    // BASS_ChannelSetAttribute(StukTrog, BASS_ATTRIB_VOL, 0.01 * trcBarLocoPerestukVol.Position)
    // else
    // BASS_ChannelSetAttribute(StukTrog, BASS_ATTRIB_VOL, 0)
    // except
    // end;
    // end;
    // === ПРС === //
    if isPlayPRS = False then
    begin
      Randomize;
      if (cbPRS_RZD.Checked = True) and (cbPRS_UZ.Checked = False) then
      begin
        repeat
          NumPRS := Random(43);
        until (NumPRS <> PrevPrs) and (NumPRS <> 0);
        PRSF := PChar('TWS/PRS/RU_' + IntToStr(NumPRS) + '.mp3');
        PrevPrs := NumPRS;
      end;

      if (cbPRS_UZ.Checked = True) and (cbPRS_RZD.Checked = False) then
      begin
        repeat
          NumPRS := Random(5);
        until (NumPRS <> PrevPrs) and (NumPRS <> 0);
        PRSF := PChar('TWS/PRS/UA_' + IntToStr(NumPRS) + '.mp3');
        PrevPrs := NumPRS;
      end;

      if (cbPRS_UZ.Checked = True) and (cbPRS_RZD.Checked = True) then
      begin
        Randomize;
        repeat
          Country := 1 + Random(2);
        until (Country <> 0);
        if Country = 1 then
        begin
          Randomize;
          repeat
            NumPRS := Random(43);
          until (NumPRS <> PrevPrs) and (NumPRS <> 0);
          PRSF := PChar('TWS/PRS/RU_' + IntToStr(NumPRS) + '.mp3');
          PrevPrs := NumPRS;
        end
        else
        begin
          Randomize;
          repeat
            NumPRS := Random(5);
          until (NumPRS <> PrevPrs) and (NumPRS <> 0);
          PRSF := PChar('TWS/PRS/UA_' + IntToStr(NumPRS) + '.mp3');
          PrevPrs := NumPRS;
        end;
      end;

      try
        BASS_ChannelStop(PRSChannel);
        BASS_StreamFree(PRSChannel);
        PRSChannel := BASS_StreamCreateFile(False, PRSF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(PRSChannel, True);
        isPlayPRS := True;
        if isCameraInCabin = True then
          BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0.01 * trcBarPRSVol.Position)
        else
          BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      except
      end;
    end;
    // === Кабинные щелчки(395;254;контроллер;реверсор) === //
    if isPlayCabinClicks = False then
    begin
      try
        BASS_ChannelStop(CabinClicks);
        BASS_StreamFree(CabinClicks);
        CabinClicks := BASS_StreamCreateFile(False, CabinClicksF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(CabinClicks, True);
        isPlayCabinClicks := True;
        if Camera = 0 then
          BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0.01 * trcBarLocoClicksVol.Position)
        else
          BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      except
      end;
    end;
    // === ПРОВЕРКА БДИТЕЛЬНОСТИ === //
    if isPlayVcheck = False then
    begin
      try
        BASS_ChannelStop(Vigilance_Check_Channel);
        BASS_StreamFree(Vigilance_Check_Channel);
        Vigilance_Check_Channel := BASS_StreamCreateFile(False, PChar('TWS/KLUB_beep.wav'), 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(Vigilance_Check_Channel, True);
        isPlayVcheck := True;
        BASS_ChannelSetAttribute(Vigilance_Check_Channel, BASS_ATTRIB_VOL, 0.01 * trcBarLocoClicksVol.Position);
      except
      end;
    end;
    // === ТЭД [1] === //
    if (ChannelNumTED = 0) and (isPlayTED = False) then
    begin
      try
        BASS_ChannelStop(TEDChannel);
        BASS_StreamFree(TEDChannel);
        BASS_ChannelStop(TEDChannel_FX);
        BASS_StreamFree(TEDChannel_FX);
        TEDChannel := BASS_StreamCreateFile(False, TEDF, 0, 0, DECODE_FLAG or BASS_UNICODE);
        TEDChannel_FX := BASS_FX_TempoCreate(TEDChannel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(TEDChannel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelPlay(TEDChannel_FX, False);
        isPlayTED := True;
        ChannelNumTED := 1;
        if UnitMain.TEDNewSystem = False then
        begin
          PerehodTED := True;
          TEDVolume := TEDVlm;
          TEDVolume2 := 0;
        end;
      except
      end;
    end;
    // === ТЭД [2] === //
    if (ChannelNumTED = 1) and (isPlayTED = False) then
    begin
      try
        BASS_ChannelStop(TEDChannel2);
        BASS_StreamFree(TEDChannel2);
        TEDChannel2 := BASS_StreamCreateFile(False, TEDF, 0, 0, LOOP_FLAG);
        BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, 0);
        BASS_ChannelPlay(TEDChannel2, True);
        isPlayTED := True;
        ChannelNumTED := 0;
        PerehodTED := True;
        TEDVolume := TEDVlm;
        TEDVolume2 := 0;
      except
      end;
    end;
    // === РЕДУКТОР === //
    if isPlayReduktor = False then
    begin
      try
        BASS_ChannelStop(ReduktorChannel);
        BASS_StreamFree(ReduktorChannel);
        BASS_ChannelStop(ReduktorChannel_FX);
        BASS_StreamFree(ReduktorChannel_FX);
        ReduktorChannel := BASS_StreamCreateFile(False, ReduktorF, 0, 0, DECODE_FLAG);
        ReduktorChannel_FX := BASS_FX_TempoCreate(ReduktorChannel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(ReduktorChannel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelSetAttribute(ReduktorChannel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelPlay(ReduktorChannel_FX, False);
        isPlayReduktor := True;
      except
      end;
    end;
    // === ДИЗЕЛЬ [1] === //
    // if (isPlayDiz=False) and (ChannelNumDiz=0) then begin
    // try
    // BASS_ChannelStop(DizChannel);
    // BASS_StreamFree(DizChannel);
    // DizChannel := BASS_StreamCreateFile(FALSE, dizF, 0, 0, LOOP_FLAG);
    // BASS_ChannelSetAttribute(DizChannel, BASS_ATTRIB_VOL, 0);
    // BASS_ChannelPlay(DizChannel, True);
    // isPlayDiz:=True;
    // ChannelNumDiz:=1;
    // if Camera <> 2 then begin
    // if (BV <> 0) Or (Camera = 1) then
    // DizVolume := trcBarDieselVol.Position/100
    // else
    // DizVolume:=trcBarDieselVol.Position/300;
    // DIZVlm:=DizVolume;
    // DizVolume2:=0;
    // PerehodDIZ:=True;
    // end else begin
    // DIZVlm:=DizVolume; DizVolume:=0; DizVolume2:=0; PerehodDIZ:=True;
    // end;
    // except end;
    // end;
    // === ДИЗЕЛЬ [2] === //
    // if (isPlayDiz=False) and (ChannelNumDiz=1) then begin
    // try
    // BASS_ChannelStop(DizChannel2); BASS_StreamFree(DizChannel2);
    // DizChannel2 := BASS_StreamCreateFile(FALSE, dizF, 0, 0, LOOP_FLAG);
    // BASS_ChannelSetAttribute(DizChannel2, BASS_ATTRIB_VOL, 0);
    // BASS_ChannelPlay(DizChannel2, True); isPlayDiz:=True; ChannelNumDiz:=0;
    // if Camera <> 2 then begin
    // if (BV <> 0) Or (Camera = 1) then
    // DizVolume := trcBarDieselVol.Position/100
    // else
    // DizVolume := trcBarDieselVol.Position/300;
    // DIZVlm:=DizVolume; DizVolume2:=0; PerehodDIZ:=True;
    // end else begin
    // DIZVlm:=DizVolume; DizVolume:=0; DizVolume2:=0; PerehodDIZ:=True;
    // end;
    // except end;
    // end;
    // === ВСТРЕЧНЫЙ ПОЕЗД === //
    if isPlayVstrech = False then
    begin
      try
        BASS_ChannelStop(Vstrech);
        BASS_StreamFree(Vstrech);
        Vstrech := BASS_StreamCreateFile(False, VstrechF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(Vstrech, True);
        isPlayVstrech := True;

        var
          vstrechVolume: Double := 0.01 * trcBarNatureVol.Position;
        if isCameraInCabin = False then
          vstrechVolume := trcBarNatureVol.Position / 175;
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, vstrechVolume);

        I := 22050 + Speed * 300;
        BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_FREQ, I);
      except
      end;
    end;
    // === ЗАЩЕЛКА/ЭПК/РЭЛЮХИ/РАЗОБЩИТЕЛЬНЫЙ КРАН === //
    if isPlayIMRZachelka = False then
    begin
      try
        BASS_ChannelStop(IMRZachelka);
        BASS_StreamFree(IMRZachelka);
        IMRZachelka := BASS_StreamCreateFile(False, IMRZashelka, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(IMRZachelka, True);
        isPlayIMRZachelka := True;

        var
          emVolume: Double := 0.01 * trcBarLocoClicksVol.Position;
        if Camera <> 0 then
          emVolume := 0;
        BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, emVolume);
      except
      end;
    end;
    // === САВПЭ нажатие кнопки === //
    // if isPlaySAVPEPeek=False then begin
    // try
    // BASS_ChannelStop(SAVPE_Peek_Channel);
    // BASS_StreamFree(SAVPE_Peek_Channel);
    // SAVPE_Peek_Channel := BASS_StreamCreateFile(FALSE, PChar('TWS/SAVPE_INFORMATOR/ob_pip.wav'), 0, 0, DEFAULT_FLAG);
    // BASS_ChannelPlay(SAVPE_Peek_Channel, True);
    // isPlaySAVPEPeek:=True;
    // BASS_ChannelSetAttribute(SAVPE_Peek_Channel, BASS_ATTRIB_VOL, trcBarSAVPVol.Position/100);
    // except end;
    // end;
    // === САВПЭ звонок === //
    // if isPlaySAVPEZvonok=False then begin
    // try
    // BASS_ChannelStop(SAVPE_ZVONOK); BASS_StreamFree(SAVPE_ZVONOK);
    // SAVPE_ZVONOK := BASS_StreamCreateFile(FALSE, PChar('TWS/SAVPE_INFORMATOR/zvonok.wav'), 0, 0, DEFAULT_FLAG);
    // BASS_ChannelPlay(SAVPE_ZVONOK, True); isPlaySAVPEZvonok:=True;
    // BASS_ChannelSetAttribute(SAVPE_ZVONOK, BASS_ATTRIB_VOL, trcBarSAVPVol.Position/100);
    // except end;
    // end;
    // === САВПЭ информатор === //
    // if isPlaySAVPEInfo=False then begin
    // try
    // BASS_ChannelStop(SAVPE_INFO_Channel); BASS_MusicFree(SAVPE_INFO_Channel);
    // if PlayRESFlag=False then
    // SAVPE_INFO_Channel := BASS_StreamCreateFile(FALSE, SAVPEInfoF, 0, 0, DEFAULT_FLAG)
    // else
    // SAVPE_INFO_Channel := BASS_StreamCreateFile(TRUE, ResPotok.Memory, 0, ResPotok.Size, 0);
    // BASS_ChannelPlay(SAVPE_INFO_Channel, False);
    // BASS_ChannelSetSync(SAVPE_INFO_Channel, BASS_SYNC_END, 0, @PlaySAVPEInfoIsEnd, nil);
    // isPlaySAVPEInfo:=True; PlayRESFlag := False;
    // BASS_ChannelSetAttribute(SAVPE_INFO_Channel, BASS_ATTRIB_VOL, trcBarSAVPVol.Position/100);
    // except end;
    // end;
    // === КНОПКА РБ === //
    if isPlayRB = False then
    begin
      try
        BASS_ChannelStop(RB_Channel);
        BASS_StreamFree(RB_Channel);
        RB_Channel := BASS_StreamCreateFile(False, RBF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(RB_Channel, True);
        isPlayRB := True;

        var
          rbVolume: Double := 0.01 * trcBarLocoClicksVol.Position;
        if Camera <> 0 then
          rbVolume := 0;
        BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, rbVolume);
      except
      end;
    end;
    // === ПЕРЕДНИЙ ТП === //
    if isPlayFTP = False then
    begin
      try
        BASS_ChannelStop(FrontTP_Channel);
        BASS_StreamFree(FrontTP_Channel);
        FrontTP_Channel := BASS_StreamCreateFile(False, FTPF, 0, 0, DEFAULT_FLAG);
        isPlayFTP := True;
        BASS_ChannelPlay(FrontTP_Channel, True);
        BASS_ChannelSetAttribute(FrontTP_Channel, BASS_ATTRIB_VOL, 0.01 * trcBarVspomMahVol.Position);
      except
      end;
    end;
    // === ЗАДНИЙ ТП === //
    if isPlayBTP = False then
    begin
      try
        BASS_ChannelStop(BackTP_Channel);
        BASS_StreamFree(BackTP_Channel);
        BackTP_Channel := BASS_StreamCreateFile(False, BTPF, 0, 0, DEFAULT_FLAG);
        isPlayBTP := True;
        BASS_ChannelPlay(BackTP_Channel, True);
        BASS_ChannelSetAttribute(BackTP_Channel, BASS_ATTRIB_VOL, 0.005 * trcBarVspomMahVol.Position);
      except
      end;
    end;
    // === МК === //
    if isPlayCompressor = False then
    begin
      try
        BASS_ChannelStop(Compressor_Channel);
        BASS_StreamFree(Compressor_Channel);
        BASS_ChannelRemoveSync(Compressor_Channel, BASS_SYNC_END);
        Compressor_Channel := BASS_StreamCreateFile(False, CompressorF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(Compressor_Channel, True);
        isPlayCompressor := True;
        Inc(CameraX);
        BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelStop(CompressorCycleChannel);
        BASS_StreamFree(CompressorCycleChannel);
        if AnsiCompareStr(CompressorCycleF, '') <> 0 then
          BASS_ChannelSetSync(Compressor_Channel, BASS_SYNC_END, 0, @PlayCompressorIsEnd, nil);
      except
      end;
    end;
    // === МК [ВНЕШНИЙ] === //
    if (isPlayXCompressor = False) then
    begin
      try
        BASS_ChannelStop(XCompressor_Channel);
        BASS_StreamFree(XCompressor_Channel);
        BASS_ChannelRemoveSync(XCompressor_Channel, BASS_SYNC_END);
        XCompressor_Channel := BASS_StreamCreateFile(False, XCompressorF, 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(XCompressor_Channel, True);
        isPlayXCompressor := True;
        Inc(CameraX);
        BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelStop(XCompressorCycleChannel);
        BASS_StreamFree(XCompressorCycleChannel);
        if AnsiCompareStr(XCompressorCycleF, '') <> 0 then
          BASS_ChannelSetSync(XCompressor_Channel, BASS_SYNC_END, 0, @PlayXCompressorIsEnd, nil)
      except
      end;
    end;
    // === МК [ЦИКЛ] === //
    if isPlayCompressorCycle = False then
    begin
      try
        BASS_ChannelStop(CompressorCycleChannel);
        BASS_StreamFree(CompressorCycleChannel);
        CompressorCycleChannel := BASS_StreamCreateFile(False, CompressorCycleF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(CompressorCycleChannel, True);
        isPlayCompressorCycle := True;
        Inc(CameraX);
        BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        CompressorCycleF := PChar('');
      except
      end;
    end;
    // === МК [ЦИКЛ] [ВНЕШНИЙ] === //
    if (isPlayXCompressorCycle = False) and (AnsiCompareText(XCompressorCycleF, '') <> 0) then
    begin
      try
        BASS_ChannelStop(XCompressorCycleChannel);
        BASS_StreamFree(XCompressorCycleChannel);
        XCompressorCycleChannel := BASS_StreamCreateFile(False, XCompressorCycleF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(XCompressorCycleChannel, True);
        isPlayXCompressorCycle := True;
        Inc(CameraX);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        XCompressorCycleF := PChar('');
      except
      end;
    end;
    // === МВ === //
    if isPlayVent = False then
    begin
      try
        BASS_ChannelStop(Vent_Channel);
        BASS_StreamFree(Vent_Channel);
        BASS_ChannelStop(Vent_Channel_FX);
        BASS_StreamFree(Vent_Channel_FX);
        if StopVent = False then
          Vent_Channel := BASS_StreamCreateFile(False, VentStartF, 0, 0, DECODE_FLAG)
        else
          Vent_Channel := BASS_StreamCreateFile(False, VentStopF, 0, 0, DECODE_FLAG);
        Vent_Channel_FX := BASS_FX_TempoCreate(Vent_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelPlay(Vent_Channel_FX, False);
        BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayVent := True;
        Inc(CameraX);

        // if (LocoGlobal='VL80t') Or (LocoGlobal='EP1m') Or (LocoGlobal='2ES5K') then begin
        // if (Vent=0) and (Vent2=0) and (Vent3=0) and (Vent4=0) then begin
        // BASS_ChannelStop(VentCycle_Channel); BASS_StreamFree(VentCycle_Channel);
        // BASS_ChannelStop(VentCycle_Channel_FX); BASS_StreamFree(VentCycle_Channel_FX);
        // end;
        // end;
      except
      end;
    end;
    // === МВ [ВНЕШНИЙ] === //
    if isPlayVentX = False then
    begin
      try
        BASS_ChannelStop(XVent_Channel);
        BASS_StreamFree(XVent_Channel);
        BASS_ChannelStop(XVent_Channel_FX);
        BASS_StreamFree(XVent_Channel_FX);
        if StopVent = False then
          XVent_Channel := BASS_StreamCreateFile(False, XVentStartF, 0, 0, DECODE_FLAG)
        else
          XVent_Channel := BASS_StreamCreateFile(False, XVentStopF, 0, 0, DECODE_FLAG);
        XVent_Channel_FX := BASS_FX_TempoCreate(XVent_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelPlay(XVent_Channel_FX, False);
        BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayVentX := True;
        BASS_ChannelPlay(XVent_Channel, True);
        Inc(CameraX);
      except
      end;
    end;
    // === МВ [ЦИКЛ] === //
    if isPlayCycleVent = False then
    begin
      try
        BASS_ChannelStop(VentCycle_Channel);
        BASS_StreamFree(VentCycle_Channel);
        BASS_ChannelStop(VentCycle_Channel_FX);
        BASS_StreamFree(VentCycle_Channel_FX);
        VentCycle_Channel := BASS_StreamCreateFile(False, VentCycleF, 0, 0, DECODE_FLAG);
        VentCycle_Channel_FX := BASS_FX_TempoCreate(VentCycle_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(VentCycle_Channel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(VentCycle_Channel_FX, False);
        BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayCycleVent := True;
        Inc(CameraX);
        BASS_ChannelStop(Vent_Channel);
        BASS_StreamFree(Vent_Channel);
        BASS_ChannelStop(Vent_Channel_FX);
        BASS_StreamFree(Vent_Channel_FX);
      except
      end;
    end;
    // === МВ [ЦИКЛ] [ВНЕШНИЙ] === //
    if (isPlayCycleVentX = False) then
    begin
      try
        BASS_ChannelStop(XVentCycle_Channel);
        BASS_StreamFree(XVentCycle_Channel);
        BASS_ChannelStop(XVentCycle_Channel_FX);
        BASS_StreamFree(XVentCycle_Channel_FX);
        XVentCycle_Channel := BASS_StreamCreateFile(False, XVentCycleF, 0, 0, DECODE_FLAG);
        XVentCycle_Channel_FX := BASS_FX_TempoCreate(XVentCycle_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(XVentCycle_Channel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(XVentCycle_Channel_FX, False);
        BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayCycleVentX := True;
        Inc(CameraX);
        BASS_ChannelStop(XVent_Channel);
        BASS_StreamFree(XVent_Channel);
        BASS_ChannelStop(XVent_Channel_FX);
        BASS_StreamFree(XVent_Channel_FX);
      except
      end;
    end;
    // === МВ ТД === //
    if isPlayVentTD = False then
    begin
      try
        BASS_ChannelStop(VentTD_Channel);
        BASS_StreamFree(VentTD_Channel);
        BASS_ChannelStop(VentTD_Channel_FX);
        BASS_StreamFree(VentTD_Channel_FX);
        VentTD_Channel := BASS_StreamCreateFile(False, VentTDF, 0, 0, DECODE_FLAG);
        VentTD_Channel_FX := BASS_FX_TempoCreate(VentTD_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelPlay(VentTD_Channel_FX, False);
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayVentTD := True;
        Inc(CameraX);
      except
      end;
    end;
    // === МВ ТД [ВНЕШНИЙ] === //
    if isPlayVentTDX = False then
    begin
      try
        BASS_ChannelStop(XVentTD_Channel);
        BASS_StreamFree(XVentTD_Channel);
        BASS_ChannelStop(XVentTD_Channel_FX);
        BASS_StreamFree(XVentTD_Channel_FX);
        XVentTD_Channel := BASS_StreamCreateFile(False, XVentTDF, 0, 0, DECODE_FLAG);
        XVentTD_Channel_FX := BASS_FX_TempoCreate(XVentTD_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelPlay(XVentTD_Channel_FX, False);
        BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayVentTDX := True;
        Inc(CameraX);
      except
      end;
    end;
    // === МВ ТД [ЦИКЛ] === //
    if isPlayCycleVentTD = False then
    begin
      try
        BASS_ChannelStop(VentCycleTD_Channel);
        BASS_StreamFree(VentCycleTD_Channel);
        BASS_ChannelStop(VentCycleTD_Channel_FX);
        BASS_StreamFree(VentCycleTD_Channel_FX);
        VentCycleTD_Channel := BASS_StreamCreateFile(False, VentCycleTDF, 0, 0, DECODE_FLAG);
        VentCycleTD_Channel_FX := BASS_FX_TempoCreate(VentCycleTD_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(VentCycleTD_Channel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(VentCycleTD_Channel_FX, False);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayCycleVentTD := True;
        Inc(CameraX);
      except
      end;
    end;
    // МВ ТД [ЦИКЛ] [ВНЕШНИЙ] === //
    if isPlayCycleVentTDX = False then
    begin
      try
        BASS_ChannelStop(XVentCycleTD_Channel);
        BASS_StreamFree(XVentCycleTD_Channel);
        BASS_ChannelStop(XVentCycleTD_Channel_FX);
        BASS_StreamFree(XVentCycleTD_Channel_FX);
        XVentCycleTD_Channel := BASS_StreamCreateFile(False, XVentCycleTDF, 0, 0, DECODE_FLAG);
        XVentCycleTD_Channel_FX := BASS_FX_TempoCreate(XVentCycleTD_Channel, BASS_FX_FREESOURCE);
        BASS_ChannelFlags(XVentCycleTD_Channel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(XVentCycleTD_Channel_FX, False);
        BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        isPlayCycleVentTDX := True;
        Inc(CameraX);
      except
      end;
    end;
    if isPlayBrake254 = False then
    begin
      try
        BASS_ChannelStop(Brake254_Channel[0]);
        BASS_StreamFree(Brake254_Channel[0]);
        BASS_ChannelStop(Brake254_Channel_FX[0]);
        BASS_StreamFree(Brake254_Channel_FX[0]);
        BASS_ChannelStop(Brake254_Channel[1]);
        BASS_StreamFree(Brake254_Channel[1]);
        BASS_ChannelStop(Brake254_Channel_FX[1]);
        BASS_StreamFree(Brake254_Channel_FX[1]);
        Brake254_Channel[0] := BASS_StreamCreateFile(False, Brake254F, 0, 0, DECODE_FLAG);
        Brake254_Channel_FX[0] := BASS_FX_TempoCreate(Brake254_Channel[0], BASS_FX_FREESOURCE);
        // BASS_ChannelFlags(VentCycleTD_Channel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Brake254_Channel_FX[0], False);
        BASS_ChannelSetAttribute(Brake254_Channel_FX[0], BASS_ATTRIB_VOL, 0.3);
        isPlayBrake254 := True;
        Inc(CameraX);
      except
      end;
    end;
    if isPlayCycleBrake254 = False then
    begin
      try
        BASS_ChannelStop(Brake254_Channel[1]);
        BASS_StreamFree(Brake254_Channel[1]);
        BASS_ChannelStop(Brake254_Channel_FX[1]);
        BASS_StreamFree(Brake254_Channel_FX[1]);
        Brake254_Channel[1] := BASS_StreamCreateFile(False, CycleBrake254F, 0, 0, DECODE_FLAG);
        Brake254_Channel_FX[1] := BASS_FX_TempoCreate(Brake254_Channel[1], BASS_FX_FREESOURCE);
        BASS_ChannelFlags(Brake254_Channel_FX[1], BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Brake254_Channel_FX[1], False);
        BASS_ChannelSetAttribute(Brake254_Channel_FX[1], BASS_ATTRIB_VOL, 0.3);
        isPlayCycleBrake254 := True;
        Inc(CameraX);
        BASS_ChannelStop(Brake254_Channel[0]);
        BASS_StreamFree(Brake254_Channel[0]);
        BASS_ChannelStop(Brake254_Channel_FX[0]);
        BASS_StreamFree(Brake254_Channel_FX[0]);
      except
      end;
    end;
    // === ДОЖДЬ === //
    if isPlayRain = False then
    begin
      try
        BASS_ChannelStop(Rain_Channel);
        BASS_StreamFree(Rain_Channel);
        Rain_Channel := BASS_StreamCreateFile(False, RainF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(Rain_Channel, True);
        isPlayRain := True;
        BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, 0.01 * trcBarNatureVol.Position);
      except
      end;
    end;
    // === ХОДЬБА ПО СНЕГУ === //
    if (isPlayWalkSound = True) and (BASS_ChannelIsActive(WalkSoundChannel) = 0) then
    begin
      // BASS_ChannelStop(WalkSoundChannel); BASS_StreamFree(WalkSoundChannel);
      WalkSoundChannel := BASS_StreamCreateFile(False, WalkSoundF, 0, 0, LOOP_FLAG);
      BASS_ChannelSetAttribute(WalkSoundChannel, BASS_ATTRIB_VOL, 0.01 * trcBarNatureVol.Position);
      BASS_ChannelPlay(WalkSoundChannel, True);
      isPlayWalkSound := False;
    end;
    // === ПРОТЯЖКА ЛЕНТЫ === //
    if isPlayBeltPool = False then
    begin
      try
        BASS_ChannelStop(BeltPool_Channel);
        BASS_StreamFree(BeltPool_Channel);
        BeltPool_Channel := BASS_StreamCreateFile(False, PChar('TWS/belt_pul.wav'), 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(BeltPool_Channel, True);
        isPlayBeltPool := True;
        BASS_ChannelSetAttribute(BeltPool_Channel, BASS_ATTRIB_VOL, 0.01 * trcBarLocoClicksVol.Position);
      except
      end;
    end;
    // === ЗВУКИ ОКРУЖЕНИЯ === //
    if isPlayNature = True then
    begin
      BASS_ChannelStop(NatureChannel);
      BASS_StreamFree(NatureChannel);
      BASS_ChannelStop(NatureChannel_FX);
      BASS_StreamFree(NatureChannel_FX);
      NatureChannel := BASS_StreamCreateFile(False, NatureF, 0, 0, DECODE_FLAG);
      NatureChannel_FX := BASS_FX_TempoCreate(NatureChannel, BASS_FX_FREESOURCE);
      BASS_ChannelFlags(NatureChannel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(NatureChannel_FX, False);
      BASS_ChannelSetAttribute(NatureChannel_FX, BASS_ATTRIB_VOL, 0);
      isPlayNature := False;
    end;
    // === === //
    if isPlayVR242 = False then
    begin
      BASS_ChannelStop(VR242Channel);
      BASS_StreamFree(VR242Channel);
      BASS_ChannelStop(VR242Channel_FX);
      BASS_StreamFree(VR242Channel_FX);
      VR242Channel := BASS_StreamCreateFile(False, VR242F, 0, 0, DECODE_FLAG);
      VR242Channel_FX := BASS_FX_TempoCreate(VR242Channel, BASS_FX_FREESOURCE);
      // BASS_ChannelFlags(NatureChannel_FX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(VR242Channel_FX, False);
      BASS_ChannelSetAttribute(VR242Channel_FX, BASS_ATTRIB_VOL, 0);
      isPlayVR242 := True;
    end;

    // === ДВОРНИКИ === //
    if isPlayStochist = False then
    begin
      try
        BASS_ChannelStop(Stochist_Channel);
        BASS_StreamFree(Stochist_Channel);
        Stochist_Channel := BASS_StreamCreateFile(False, StochistF, 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(Stochist_Channel, True);
        isPlayStochist := True;
        var
          stochistVolume: Double := 0;
        if Camera = 0 then
          stochistVolume := 0.01 * trcBarVspomMahVol.Position;
        BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, stochistVolume);
      except
      end;
    end;
    // === УДАР ДВОРНИКА === //
    if isPlayStochistUdar = False then
    begin
      try
        BASS_ChannelStop(StochistUdar_Channel);
        BASS_StreamFree(StochistUdar_Channel);
        StochistUdar_Channel := BASS_StreamCreateFile(False, PChar('TWS/stochist_udar.wav'), 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(StochistUdar_Channel, True);
        isPlayStochistUdar := True;
        var
          stochistVolume: Double := 0;
        if Camera = 0 then
          stochistVolume := 0.01 * trcBarVspomMahVol.Position;
        BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, stochistVolume);
      except
      end;
    end;
    // === КЛАВИАТУРА КЛУБ-у === //
    if ((cbKLUBSounds.Checked = True) and (KLUBOpen = 1) and (prevKeyLKM = 0) and (getasynckeystate(1) <> 0)) then
    begin
      try
        BASS_ChannelStop(PickKLUBChannel);
        BASS_StreamFree(PickKLUBChannel);
        PickKLUBChannel := BASS_StreamCreateFile(False, PChar('TWS/KLUB_pick.wav'), 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(PickKLUBChannel, True);
        var
          klubVolume: Double := 0;
        if Camera = 0 then
          klubVolume := 0.01 * trcBarLocoClicksVol.Position;
        BASS_ChannelSetAttribute(PickKLUBChannel, BASS_ATTRIB_VOL, klubVolume);
        prevKeyLKM := 1;
      except
      end;
    end;
    if getasynckeystate(1) = 0 then
      prevKeyLKM := 0;
    // === КЛУБ-у смена показания светофора === //
    if (cbKLUBSounds.Checked = True) and (Svetofor <> PrevSvetofor) then
    begin
      try
        BASS_ChannelStop(KLUB_BEEP);
        BASS_StreamFree(KLUB_BEEP);
        KLUB_BEEP := BASS_StreamCreateFile(False, PChar('TWS/KLUB_beep.wav'), 0, 0, DEFAULT_FLAG);
        BASS_ChannelPlay(KLUB_BEEP, True);
        BASS_ChannelSetAttribute(KLUB_BEEP, BASS_ATTRIB_VOL, 0.01 * trcBarLocoClicksVol.Position);
      except
      end;
    end;
    // === КЛУБ-у езда по ограничению ===
    if (cbKLUBSounds.Checked = True) and (isPlayOgrSpKlub = 1) then
    begin
      try
        BASS_ChannelStop(Ogr_Speed_KLUB);
        BASS_StreamFree(Ogr_Speed_KLUB);
        isPlayOgrSpKlub := -1;
        Ogr_Speed_KLUB := BASS_StreamCreateFile(False, PChar('TWS/KLUB_pick.wav'), 0, 0, LOOP_FLAG);
        BASS_ChannelPlay(Ogr_Speed_KLUB, True);
        BASS_ChannelSetAttribute(Ogr_Speed_KLUB, BASS_ATTRIB_VOL, 0.01 * trcBarLocoClicksVol.Position);
      except
      end;
    end;
    // === СИЛОВОЕ ОБОРУДОВАНИЕ ЛОКОМОТИВА(БВ, ФР) === //
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
    // Функция проигрывания дорожки "САУТ выключен"
    // if (SAUTOff=True) and (BASS_IsStarted = True) then begin
    // try
    // BASS_ChannelStop(SAUTChannelObjects);
    // BASS_StreamFree(SAUTChannelObjects);
    // BASS_ChannelStop(SAUTChannelZvonok);
    // BASS_StreamFree(SAUTChannelZvonok);
    // SAUTChannelObjects := BASS_StreamCreateFile(FALSE, SAUTOFFF, 0, 0, DEFAULT_FLAG);
    // BASS_ChannelPlay(SAUTChannelObjects, True);
    // BASS_ChannelSetAttribute(SAUTChannelObjects, BASS_ATTRIB_VOL, 0.01 * trcBarSAVPVol.Position);
    // SAUTOff:=False;
    // except
    // end;
  end;
end;

end.
