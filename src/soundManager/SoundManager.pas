// ------------------------------------------------------------------------------//
// //
// Модуль звукового управления                                             //
// (c) DimaGVRH, Dnepr city, 2019                                          //
// //
// ------------------------------------------------------------------------------//
unit SoundManager;

interface

uses Classes;

type
  TSoundAttrIdx = (VOLUME, TEMPO, PITCH);
  TSoundAttrs = array [TSoundAttrIdx] of Double;

  TChannelIdx = (C_FILE, C_FX);
  TChannelFX = array [TChannelIdx] of Cardinal;

procedure SoundManagerTick();
procedure TWS_MVPitchRegulation();

procedure TWS_PlayUnipuls(FileName: PChar; Loop: Boolean);
procedure VolumeMaster_RefreshVolume;

procedure DecodeResAndPlay(FileName: String; var FlagName: Boolean; var PCharName: PChar; var ChannelName: Cardinal;
  var ResPotok: TMemoryStream; var PlayResFlag: Boolean); external 'dg2020.dll';
function GetChannelRemaindPlayTime2Sec(var chan: Cardinal): Double;

function checkChannel(channel: Cardinal; isInv: Boolean = True): Boolean;
overload
function checkChannel(channel: TChannelFX; isInv: Boolean = True): Boolean;
overload

procedure restartChannel(var channel: Cardinal; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
overload
procedure restartChannel(var channel: TChannelFX; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
overload

procedure setChannelAttributes(var channel: Cardinal; const attrs: TSoundAttrs);
overload
procedure setChannelAttributes(var channel: TChannelFX; const attrs: TSoundAttrs);
overload

procedure freeChannel(var channel: Cardinal);
overload
procedure freeChannel(var channel: TChannelFX);
overload

var
  SAUTChannelObjects: Cardinal; // Канал для звуков САУТ объекты (1)
  SAUTChannelObjects2: Cardinal; // Канал для звуков САУТ объекты (2)
  SAUTChannelZvonok: Cardinal; // Канал для звуков САУТ звонок на переезде
  PRSChannel: Cardinal; // Канал для звуков ПРС
  DizChannel, DizChannel2: Cardinal; // Канал для звуков Дизелей на тепловозах
  Vstrech: Cardinal; // Канал для звука встречного поезда
  StukTrog: Cardinal; // Канал для удара сцепки при трограньи на Электричке
  IMRZachelka: Cardinal; // Канал для звука щелчка ЭМ-защелки №304 на Чехах (кроме ЧС2к)
  RB_Channel: Cardinal; // Канал для кнопки РБ
  PickKLUBChannel: Cardinal; // Канал для звука нажатия на кнопки КЛУБ-а
  KLUB_BEEP: Cardinal; // Канал для пиканья КЛУБ-а при смене показаний светофора
  Ogr_Speed_KLUB: Cardinal; // Канал для пиканья КЛУБ-а при приближении к ограничениею
  LocoPowerEquipment: Cardinal; // Канал для звука силового оборудования локомотива(БВ, ФР, Жалюзи)
  Rain_Channel: Cardinal; // Канал для проигрывания дорожки звука дождя
  Vigilance_Check_Channel: Cardinal; // Канал для писка проверки бдительности
  Unipuls_Channel: array [0 .. 1] of Cardinal;
  Compressor_Channel: Cardinal;
  CompressorCycleChannel: Cardinal;
  XCompressor_Channel: Cardinal;
  XCompressorCycleChannel: Cardinal;
  VentTD_Channel: Cardinal;
  VentCycleTD_Channel: Cardinal;
  XVentTD_Channel: Cardinal;
  XVentCycleTD_Channel: Cardinal;
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
  NatureChannel: Cardinal;
  RevPosF: PChar;
  NatureChannel_FX: Cardinal;
  VR242Channel: Cardinal;
  VR242Channel_FX: Cardinal; // ИТОГО ДОРОЖЕК В СКРИПТЕ: 54
  LocoFTemp: PChar;
  WagF: PChar;
  dizF: PChar; // Файлы дизелей
  VIPF: PChar; // Файлы ВИП (ЭП1м и 2ЭС5к)
  StukKMF: PChar; // Файл звука щелчка котроллера при переключении позициций
  SAUTF: PChar;
  SAUTOFFF: PChar;
  PRSF: PChar;
  RBF: PChar;
  IMRZashelka: PChar;
  RainF: PChar;
  VstrechF: PChar;
  CompressorF: PChar = ' ';
  CompressorCycleF: PChar;
  XCompressorF: PChar = ' ';
  XCompressorCycleF: PChar;
  VentTDF: PChar;
  LocoPowerEquipmentF: PChar; // Силовое оборудование локомотива(БВ, ФР)
  XVentTDF: PChar;
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
  isPlayCompressor: Boolean;
  isPlayCompressorCycle: Boolean;
  isPlayXCompressor: Boolean;
  isPlayXCompressorCycle: Boolean;
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
  isPlayVstrech: Boolean;
  isPlayLocoPowerEquipment: Boolean; // Флаг для воспроизведения звуков силового оборудования локомотива(БВ, ФР)
  isPlayPRS: Boolean; // Флаг для воспроизведения поездной радиосвязи
  isPlayVIP: Boolean; // Флаг для воспроизведения звуков ВИП (ЭП1м и 2ЭС5к)
  isPlayDiz: Boolean; // Флаг для воспроизведения звуков дизелей на тепловозах
  isPlayPerestuk: Boolean;
  isPlayWalkSound: Boolean;
  isPlayNature: Boolean;
  isPlayVR242: Boolean = True;

implementation

uses Bass, UnitMain, SysUtils, Windows, ExtraUtils, bass_fx;

const
  DEFAULT_FLAG = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
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
    if VentAttrs[PITCH] > VentPitchDest then
      VentAttrs[PITCH] := VentAttrs[PITCH] - VentPitchIncrementer * MainCycleFreq;
    if VentPitch < VentPitchDest then
      VentAttrs[PITCH] := VentAttrs[PITCH] + VentPitchIncrementer * MainCycleFreq;

    // Задаём тональность звуков работы вентиляторов ВУ
    setChannelAttributes(VentChannelFX[0], VentAttrs);
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

function checkChannel(channel: Cardinal; isInv: Boolean = True): Boolean;
begin
  if isInv then
    Result := BASS_ChannelIsActive(channel) <> 0
  else
    Result := BASS_ChannelIsActive(channel) = 0
end;

function checkChannel(channel: TChannelFX; isInv: Boolean = True): Boolean;
begin
  if isInv then
    Result := (BASS_ChannelIsActive(channel[C_FILE]) <> 0) or (BASS_ChannelIsActive(channel[C_FX]) <> 0)
  else
    Result := (BASS_ChannelIsActive(channel[C_FILE]) = 0) and (BASS_ChannelIsActive(channel[C_FX]) = 0);
end;

procedure setChannelAttributes(var channel: TChannelFX; const attrs: TSoundAttrs);
begin
  BASS_ChannelSetAttribute(channel[C_FX], BASS_ATTRIB_VOL, attrs[VOLUME]);
  BASS_ChannelSetAttribute(channel[C_FX], BASS_ATTRIB_TEMPO, attrs[TEMPO]);
  BASS_ChannelSetAttribute(channel[C_FX], BASS_ATTRIB_TEMPO_PITCH, attrs[PITCH]);
end;

procedure setChannelAttributes(var channel: Cardinal; const attrs: TSoundAttrs);
begin
  BASS_ChannelSetAttribute(channel, BASS_ATTRIB_VOL, attrs[VOLUME]);
  BASS_ChannelSetAttribute(channel, BASS_ATTRIB_TEMPO_PITCH, attrs[PITCH]);
end;

procedure freeChannel(var channel: Cardinal);
begin
  BASS_ChannelStop(channel);
  BASS_StreamFree(channel);
end;

procedure freeChannel(var channel: TChannelFX);
begin
  BASS_ChannelStop(channel[C_FILE]);
  BASS_StreamFree(channel[C_FILE]);
  BASS_ChannelStop(channel[C_FX]);
  BASS_StreamFree(channel[C_FX]);
end;

procedure restartChannel(var channel: Cardinal; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
begin
  freeChannel(channel);
  channel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, flags or DEFAULT_FLAG);
  setChannelAttributes(channel, attrs);
  BASS_ChannelPlay(channel, False);
end;

procedure restartChannel(var channel: TChannelFX; FileName: String; const attrs: TSoundAttrs; flags: Integer = 0);
begin
  freeChannel(channel);

  channel[C_FILE] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DECODE_FLAG);
  channel[C_FX] := BASS_FX_TempoCreate(channel[C_FILE], BASS_FX_FREESOURCE);

  BASS_ChannelFlags(channel[C_FX], flags, flags);
  setChannelAttributes(channel, attrs);

  BASS_ChannelPlay(channel[C_FX], False);
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
        // BASS_ChannelSetAttribute(EzdaChannelFX[C_FX], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // Шум езды (в ст. вар. перестук) [2]
        // BASS_ChannelSetAttribute(PerestukChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // if cbExtIntSounds.Checked = False then
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, 0)
        // else
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 60);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 100);
        // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 100);
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
        BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 125);
        BASS_ChannelSetAttribute(XCompressor_Channel, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        // end;
      end
      else
      begin
        // -/- ВИД: КАБИНА; ПОЛОЖЕНИЕЖ СНАРУЖИ КАБИНЫ -/- //
        // BASS_ChannelSetAttribute(EzdaChannelFX[0], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // BASS_ChannelSetAttribute(PerestukChannelFX[0], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
        // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
        BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, trcBarPRSVol.Position / 200);
        BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
        // Делаем внешние звуки МВ
        if LocoWithExtMVSound = True then
        begin
          BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
          BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        end
        else
        begin
          BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
          BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
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
          BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
          // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
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
        BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, trcBarLocoClicksVol.Position / 200);
        BASS_ChannelSetAttribute(Stochist_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
        BASS_ChannelSetAttribute(StochistUdar_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 200);
      end;
    end;
    // -/- ВИД: НА ЛОКОМОТИВ -/- //
    if (Camera = 1) then
    begin
      // BASS_ChannelSetAttribute(EzdaChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(ShumChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(PerestukChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
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
      BASS_ChannelSetAttribute(Rain_Channel, BASS_ATTRIB_VOL, trcBarNatureVol.Position / 100);
      BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      // -/- МВ -/- //
      if LocoWithExtMVSound = True then
      begin
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
        BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
      end
      else
      begin
        BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
        BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
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
        BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
        // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
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
      // BASS_ChannelSetAttribute(EzdaChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(EzdaChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(PerestukChannelFX[1], BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100);
      // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, trcBarVspomMahVol.Position / 100);
      // end
      // else
      // begin
      // BASS_ChannelSetAttribute(EzdaChannelFX[1], BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(PerestukChannelFX[1], BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(Vent_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(VentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(Compressor_Channel, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(CompressorCycleChannel, BASS_ATTRIB_VOL, 0);
      // end;
      // BASS_ChannelSetAttribute(WagChannel, BASS_ATTRIB_VOL, trcBarWagsVol.Position / 100);
      BASS_ChannelSetAttribute(PRSChannel, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(CabinClicks, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, 0);
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
      BASS_ChannelSetAttribute(IMRZachelka, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVent_Channel_FX, BASS_ATTRIB_VOL, 0);
      // BASS_ChannelSetAttribute(XVentCycle_Channel_FX, BASS_ATTRIB_VOL, 0);
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


    // === ВСТРЕЧНЫЙ ПОЕЗД === //
    if isPlayVstrech = False then
    begin
      try
        BASS_ChannelStop(Vstrech);
        BASS_StreamFree(Vstrech);
        Vstrech := BASS_StreamCreateFile(False, VstrechF, 0, 0, BASS_SAMPLE_LOOP);
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
        CompressorCycleChannel := BASS_StreamCreateFile(False, CompressorCycleF, 0, 0, BASS_SAMPLE_LOOP);
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
        XCompressorCycleChannel := BASS_StreamCreateFile(False, XCompressorCycleF, 0, 0, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(XCompressorCycleChannel, True);
        isPlayXCompressorCycle := True;
        Inc(CameraX);
        BASS_ChannelSetAttribute(XCompressorCycleChannel, BASS_ATTRIB_VOL, 0);
        XCompressorCycleF := PChar('');
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
    // === ДОЖДЬ === //
    if isPlayRain = False then
    begin
      try
        BASS_ChannelStop(Rain_Channel);
        BASS_StreamFree(Rain_Channel);
        Rain_Channel := BASS_StreamCreateFile(False, RainF, 0, 0, BASS_SAMPLE_LOOP);
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
      WalkSoundChannel := BASS_StreamCreateFile(False, WalkSoundF, 0, 0, BASS_SAMPLE_LOOP);
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
        BeltPool_Channel := BASS_StreamCreateFile(False, PChar('TWS/belt_pul.mp3'), 0, 0, BASS_SAMPLE_LOOP);
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
        Stochist_Channel := BASS_StreamCreateFile(False, StochistF, 0, 0, BASS_SAMPLE_LOOP);
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
        StochistUdar_Channel := BASS_StreamCreateFile(False, PChar('TWS/stochist_udar.mp3'), 0, 0, DEFAULT_FLAG);
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
        PickKLUBChannel := BASS_StreamCreateFile(False, PChar('TWS/KLUB_pick.mp3'), 0, 0, DEFAULT_FLAG);
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
        KLUB_BEEP := BASS_StreamCreateFile(False, PChar('TWS/KLUB_beep.mp3'), 0, 0, DEFAULT_FLAG);
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
        Ogr_Speed_KLUB := BASS_StreamCreateFile(False, PChar('TWS/KLUB_pick.mp3'), 0, 0, BASS_SAMPLE_LOOP);
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
