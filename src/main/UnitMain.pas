(* +-------------------------------------------------------------------+
  /                  TTTTTT   W       W    SSSSS                      /|
  /                     T     W       W    S                          / |
  /                     T       W  W  W    SSSSS                      /  |
  /                     T         WW WW        S                      /   |
  /                     T          W  W    SSSSS                      /    |
  +-------------------------------------------------------------------+     |
  |                                                                   |     |
  |    Brief:      TWS (Train Wagon Sound)                            |     |
  |    Copyright:  Dmitry Govorukha a.k.a DimaGVRH                    |     |
  |    Author:     Dmitry Govorukha a.k.a DimaGVRH                    |     |
  |                                                                   |     +
  |    UKRAINE, DNEPR CITY, 2017-2020 (C)                             |    /
  |                                                                   |   /
  |    zdsimulator.com.ua                                             |  /
  |    forum.zdsimulator.com.ua                                       | /
  |                                                                   |/
  +-------------------------------------------------------------------+
*)
unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Graphics, Forms, Dialogs, StdCtrls, ComCtrls,
  Menus, IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME, ExtCtrls,
  Controls, Classes, Bass, inifiles, UnitAuthors, TlHelp32, ShellApi, Grids,
  ValEdit, jpeg, UnitSAVPEHelp, UnitSettings, UnitDebug, Math, UnitUSAVP,
  EncdDecd, SAVP, RAMMemModule, FileManager, ExtraUtils, SoundManager, Debug,
  bass_fx, UnitSOVIHelp, CHS8, CHS4KVR, CHS7, CHS4T, VL80T,
  ES5K, EP1M;

type

  TFormMain = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    btnSOVIHelp: TButton;
    btnSAVPEHelp: TButton;
    ClockMain: TTimer;
    timer3SL2m_3Sec: TTimer;
    timerSoundSlider: TTimer;
    timerPRSswitcher: TTimer;
    timerPlayPerestuk: TTimer;
    timerDoorCloseDelay: TTimer;
    timerPerehodDizSwitch: TTimer;
    timerVigilanceUSAVPDelay: TTimer;
    timerPerehodUnipulsSwitch: TTimer;
    timerSearchSimulatorWindow: TTimer;
    trcBarPRSVol: TTrackBar;
    trcBarWagsVol: TTrackBar;
    trcBarSAVPVol: TTrackBar;
    trcBarTedsVol: TTrackBar;
    trcBarNatureVol: TTrackBar;
    trcBarDieselVol: TTrackBar;
    trcBarSignalsVol: TTrackBar;
    trcBarVspomMahVol: TTrackBar;
    trcBarLocoClicksVol: TTrackBar;
    trcBarLocoPerestukVol: TTrackBar;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    cbTEDs: TCheckBox;
    cbPRS_UZ: TCheckBox;
    cbPRS_RZD: TCheckBox;
    cbTPSounds: TCheckBox;
    cbVspomMash: TCheckBox;
    cbEPL2TBlock: TCheckBox;
    cbKLUBSounds: TCheckBox;
    cbSAUTSounds: TCheckBox;
    cbLocPerestuk: TCheckBox;
    cbWagPerestuk: TCheckBox;
    cb3SL2mSounds: TCheckBox;
    cbCabinClicks: TCheckBox;
    cbUSAVPSounds: TCheckBox;
    cbSAVPESounds: TCheckBox;
    cbGSAUTSounds: TCheckBox;
    cbExtIntSounds: TCheckBox;
    cbNatureSounds: TCheckBox;
    cbBrakingSounds: TCheckBox;
    cbSignalsSounds: TCheckBox;
    cbHeadTrainSound: TCheckBox;
    cbSAVPE_Marketing: TCheckBox;
    Label5: TLabel;
    Label46: TLabel;
    Label50: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label124: TLabel;
    lblPRSVolume: TLabel;
    lblSAVPvolume: TLabel;
    lblHornVolume: TLabel;
    lblTEDsVolume: TLabel;
    lblVspomVolume: TLabel;
    lblDieselVolume: TLabel;
    lblClicksVolume: TLabel;
    lblSOVIselectEK: TLabel;
    lblPasswagVolume: TLabel;
    lblSOVIrouteSelect: TLabel;
    lblSAVPECommertion: TLabel;
    lblLocoTappingVolume: TLabel;
    lblSAVPE_selectRoute: TLabel;
    lblSOVImessagesCounter: TLabel;
    lblSAVPE_StationsCounter: TLabel;
    lblSimulatorVersionLaunched: TLabel;
    panelPasswagSounds: TPanel;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    groupBoxSAVPEbox: TGroupBox;
    groupBoxPRSCheckboxes: TGroupBox;
    groupBoxSAVPE_HandMode: TGroupBox;
    groupBoxSAVPCheckboxes: TGroupBox;
    groupBoxSOVIDescription: TGroupBox;
    groupBoxSpeedometerType: TGroupBox;
    groupBoxLocoSndCheckboxes: TGroupBox;
    groupBoxSOVI_EKdescription: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RB_HandEKMode: TRadioButton;
    RB_AutoEKMode: TRadioButton;
    Image1: TImage;
    Image2: TImage;
    IdDecoderMIME1: TIdDecoderMIME;
    Edit1: TEdit;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    ReadME1: TMenuItem;
    Label1: TLabel;

    procedure timerVigilanceUSAVPDelayTimer(Sender: TObject);
    procedure ClockMainTimer(Sender: TObject);
    procedure timerSoundSliderTimer(Sender: TObject);
    procedure timerSearchSimulatorWindowTimer(Sender: TObject);
    procedure timerPRSswitcherTimer(Sender: TObject);
    procedure timerPerehodUnipulsSwitchTimer(Sender: TObject);

    procedure ChangeVolume(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function CheckInstallation(): Boolean;
    procedure UpdateInfoName();

    procedure cbLocPerestukClick(Sender: TObject);
    procedure cbSAUTSoundsClick(Sender: TObject);
    procedure cbPRS_RZDClick(Sender: TObject);
    procedure cbUSAVPSoundsClick(Sender: TObject);
    procedure cbGSAUTSoundsClick(Sender: TObject);
    procedure cbKLUBSoundsClick(Sender: TObject);
    procedure cb3SL2mSoundsClick(Sender: TObject);
    procedure cbHeadTrainSoundClick(Sender: TObject);
    procedure cbNatureSoundsClick(Sender: TObject);
    procedure cbBrakingSoundsClick(Sender: TObject);
    procedure cbTEDsClick(Sender: TObject);
    procedure cbVspomMashClick(Sender: TObject);
    procedure cbSignalsSoundsClick(Sender: TObject);
    procedure RB_HandEKModeClick(Sender: TObject);

    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ReadME1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure btnSAVPEHelpClick(Sender: TObject);
    procedure btnSOVIHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  // ************************ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ******************************
type
  ProcReadDataMemoryType = procedure() of object;
  // Прцедурный тип, для того чтобы получать информацию из ОЗУ для нужного локомотива

var
  FormMain: TFormMain; // Главная форма программы
  MainCycleFreq: Integer; // Частота работы программы [ms]
  ResPotok: TMemoryStream; // Поток данных для RES-декодера
  VersionID: Byte; // ID версии симулятора (определяется автоматически)

  Log_: log; // Лог программы (ОТКЛЮЧЕН)

  CHS7__: chs7_;
  // CHS8__: chs8_; // Экземпляр ЧС8
  // CHS4T__: chs4t_;
  // CHS4KVR__: chs4kvr_;
  // VL80T__: vl80t_;
  // EP1M__: ep1m_;
  // ES5K__: es5k_;

  // settings.ini
  Route: String; // Переменная для хранения имени маршрута
  Naprav: String; // Переменная для хранения направления движения (Tuda && Obratno)
  NapravOrdinata: String; // Переменная для хранения направления движения (для ординат)
  Freight: Byte; // Переменная для типа поезда (1 - грузовой; 0 - пассажирский)
  MP: Byte; // Переменная для того чтобы понять одинчка или МП
  Winter: Byte; // Переменная-флаг зима в игре, или нет [0, 1]
  ConsistLength: Single; // Длинна нашего состава в метрах
  WagonsAmount: Byte; // Кол-во вагонов в нашем составе
  ConName: String; // Имя файла состава, или имя используемых вагонов
  TrackLength: Single; // Длина одного трэка в метрах
  SceneryName: String; // Имя текущего сценария
  LocoNum: Integer; // Номер перекраски локомотива
  LocoPowerVoltage: Integer; // -3/~25kV

  // start_kilometers.dat
  StationTrack1: array [0 .. 75] Of Integer; // 1-ая граница станции
  StationTrack2: array [0 .. 75] Of Integer; // 2-ая граница станции
  StationCount: Byte = 0; // Общее количество станций
  IsOnStation: Boolean;

  // Loco
  Loco, LocoGlobal: String; // Переменная для хранения имени локомотива
  LocoSectionsAmount: Byte; // Количество секций на локомотиве
  LocoWithTED: Boolean; // Переменная для определения, есть-ли на данный локомотив звук ТЭД-ов
  LocoWithReductor: Boolean;
  LocoWithDIZ: Boolean;
  LocoWithSndReversor: Boolean;
  LocoWithSndKM: Boolean; // Переменная для определения, есть-ли на данный локомотив звук щелчка котнроллера
  LocoWithSndKMOP: Boolean; // Переменная для определения, есть-ли на данный локомотив звук постановки ОП
  LocoWithSndTP: Boolean; // Переменная для определения, есть-ли на данный локомотив звуки ТП
  LocoWithExtMVSound: Boolean; // Переменная для определения, есть-ли на данный локомотив внешние звуки МВ
  LocoWithExtMKSound: Boolean; // Переменная для определения, есть-ли на данный локомотив внешние звуки МК
  LocoWithMVPitch: Boolean;
  LocoWithMVTDPitch: Boolean;
  LocoSndReversorType: Byte;
  // Тип звуков реверсора на локомотиве (0 - читаем состояние с памяти, 1 - по нажатию соответствующих клавиш
  LocoTEDNamePrefiks: String;
  LocoDIZNamePrefiks: String;
  LocoWorkDir: String; // Рабочая директория локомотива
  VentVolume: Byte; // Громкость работы вентиляторов (ВЛ80т)
  CycleVentVolume: Byte; // Громкость цикла работы вентиляторов (ВЛ80т)
  Vstrecha_dlina: Integer; // Длинна встречки (в метрах)
  PrevSpeed_Fakt: Integer; // Фактическая предыдущая скорость
  PrevKMAbs: Integer; // Фактическая предыдущая позиция

  // Keys
  PrevKeyLKM: Byte; // LKM
  PrevKeyTAB, PrevKeyKKR: Byte;
  PrevKeyNum0: Integer;
  PrevKeyNum1: Integer;
  PrevKeyNum2: Integer;
  PrevKeyNum3: Integer;
  PrevKeyNum4: Integer;
  PrevKeyNum5: Integer;
  PrevKeyNum6: Integer;
  PrevKeyNum7: Integer;
  PrevKeyNum8: Integer;
  PrevKeyNum9: Integer;
  PrevKeyNumPoint: Integer;
  PrevKeyNumZvezda: Integer;

  // GR
  GRIncrementer: Byte;
  GRIncrementer2: Byte;

  // Decode
  sDecodeString: String;

  // Misc
  ZvonVolume: Extended;
  ZvonTrack: Integer; // Переменные для звонка переезда


  // RAM

  // Svetofor
  Svetofor, PrevSvetofor: Byte; // Показания светофора (код сигнала)
  SvetoforDist, Prev_SvetoforDist: WORD; // Расстояние до свотофора

  // Misc
  CoupleStat, PrevCoupleStat: Byte;
  Rain, PrevRain: Byte; // Переменные интенсивности дождя

  // Camera
  Camera, PrevCamera: Byte; // Переменные для определения типа камеры
  CameraX, PrevCameraX: WORD; // Переменные для определения положения головы в кабине

  // Loco
  RB, PrevRB: Byte; // Переменные для РБ (ПИКУРОВ)
  RBS, PrevRBS: Byte; // Переменные для РБC (ПИКУРОВ)
  EPT, PrevEPT: Byte; // Переменная состояния ЭПТ (для тумблера ЭД-шэк)
  BV, PrevBV: Byte; // БВ, ЭД4(9)м, ЧС7 чтобы сделать щелчок тумблера и вентиляторы на ЧС7
  Voltage, PrevVoltage: Single; // Напряжение на электровозе ЧС7
  Zhaluzi, PrevZhaluzi: Byte; // Состояние жалюзей [ЧС7]
  Stochist, PrevStochist: Single; // Состояние дворников
  StochistDGR, Prev_StchstDGR: Double; // Угол поворота дворников
  VCheck, PrevVCheck: Byte; // Состояние проверки бдительности, для звука пиканья на КЛУБ-У
  Highlights, PrevHighLights: Byte; // Состояние прожекторов
  PickKLUB, PrevPickKLUB: Integer;
  Reostat, PrevReostat: Byte; // Переменная включения ЭДТ на ЧС8, для звука защелки
  Compressors: array [0 .. 1] of Single;
  KM395, PrevKM395: Byte; // 254 / 395
  KM294, PrevKM294: Single;
  TC, PrevTC: Double;
  BrakeCylinders, PrevBrakeCylinders: Single;
  ReversorPos, PrevReversorPos: Integer; // КМ-Revers
  KMPos1, PrevKMPos1: Integer;
  KMPos2, PrevKMPos2: Byte;
  PrevKMOP, KMOP: Byte;
  Signals: array [0 .. 1] of Byte; // Signals-Tifon
  MVsState: Byte; // Состояние Вентиляторов [1]
  MVsTDState: Byte; // Состояние Вентиляторов [1]
  VentTDPitch: Single = -20; // Вентиляторы ТД (ПТР) тональность
  VentTDPitchDest: Single = -20; // Желаемая тональность вентов ТД (ПТР) для плавного увеличения/уменьшения
  VentTDPitchIncrementer: Single; // Инкрементер тональности для МВ ТД
  VentTDVolDest: Single = 0;
  VentPitchDest: Single;
  VentPitchIncrementer: Single; // Инкрементер тональности для МВ

  // TP
  FrontTP, PrevFrontTP: Integer; // Состояние заднего ТП
  BackTP, PrevBackTP: Integer; // Состояние заднего ТП

  // Vstrech
  VstrTrack, PrevVstrTrack: WORD; // Переменные ординаты встречки
  Track_Vstrechi: Integer; // Трэк на котором произошла встреча нашего состава с встречным
  VstrechStatusCounter: Integer;
  VstrechStatus, PrevVstrechStatus: Byte;
  isVstrechDrive: Boolean;

  // SVT
  Acceleretion, PrevAcceleretion: Double; // Ускорение м/(с^2)
  Speed, PrevSpeed: Integer; // Скорость
  OgrSpeed, PrevOgrSpeed: WORD; // Ограничение скорости
  NextOgrSpeed, PrevNextOgrSpeed: Byte; // Следующее ограничение скорости (желтая точка на КЛУБ-е)
  NextOgrPeekStatus: Byte; // Статус для пиканья про снижение ограничения [0-нет снижения 1-в процессе]
  Ordinata, PrevOrdinata: Double;
  OrdinataEstimate, PrevOrdinataEstimate: Double;
  OutsideLocoStatus: WORD;
  GR, PrevGR: Double;
  VR242, PrevVR242: Single;

  // Klub
  PrevPRS: Integer;
  KLUBOpen: Byte; // Переменная-флаг открыта-ли в игре клавиатура КЛУБ
  TrackTail: Integer; // Номер трэка хвоста нашего поезда

  // Debug
  DebugFile: TextFile;

  // Sounds
  Track, PrevTrack: Integer;
  ChannelNumDiz: Byte; // Номер канала для звуков дизеля
  Ini: TIniFile; // Ini файл настроек
  DizVolume, DizVolume2: Single; // Громкость дорожки дизеля, нужно для разделения звуков на внешние и внутренние
  PerehodDIZ: Boolean;
  EDTAmperage, PrevEDTAmperage: Single;
  VstrVolume: Integer;
  TEDAmperage, PrevTEDAmperage: Single;
  UltimateTEDAmperage: Integer; // Предельный ток нагрузки на ТЭД-ы
  TrackVstrechi: Integer; // Номер трэка где встретились состав игрока со встречкой
  WagNum_Vstr: Byte;
  AB_ZB_1, AB_ZB_2: Byte;
  PrevAB_ZB_1, PrevAB_ZB_2: Byte;
  PrevBoks_Stat, Boks_Stat: Byte;

  // Flags
  SAVPENextMessage: Boolean = False;
  HeadTrainEndOfTrain: Boolean;
  isCameraInCabin: Boolean; // Флаг для понимания, в кабине-ли камера?
  isRefreshLocalData: Boolean; // флаг для перезагрузки в скрипт всех данных необходимых для работы
  SAUTOff: Boolean; // Фалг для воспроизведения финального звука выключения САУТ
  isConnectedMemory, PrevConMem: Boolean; // Флаг для определения: удалось ли подключиться к памяти?
  isGameOnPause: Boolean; // Флаг для состояния паузы игры (сворочивание)
  VstrZat: Boolean; // Флаг для велючения затухания звука встречного поезда
  PlayRESFlag: Boolean;
  PereezdZatuh: Boolean;
  isSpeedLimitRouteLoad: Boolean;
  isNatureNowPlay: array [0 .. 4] of Boolean; // Флаг для понимания играет-ли текущая дорожка природы
  NatureOrd1: array [0 .. 4] of Integer; // Ордината начала играния дорожки природы
  NatureOrd2: array [0 .. 4] of Integer; // Ордината конца играния дорожки природы
  NatureKoefZatuh: array [0 .. 4] of Integer; // Длина затухания
  Brake_Counter: Integer;
  Prev_KME: Integer;
  PerestukBase: Array [0 .. 100] of Integer;
  PerestukBaseNumElem: Integer;
  TEDBase: Array [0 .. 600] of Integer;
  TEDBaseNumElem: Integer;
  VIPBase: Array [0 .. 600] of Integer; // Данные о границах дорожек для ВИП (ЭП1м и 2ЭС5к)
  VIPBaseNumElem: Integer; // Количество дорожек ВИП (ЭП1м и 2ЭС5к)
  TedFound: Boolean;
  isPlayTrog: Boolean; // Удар сцепки на МВПС
  TedNow: Integer;

  // Game
  GameScreen: HWND; // Дескриптор окна игры
  GameWindowName: String;
  wHandle: Integer;
  tHandle, ProcessID, pHandle: Cardinal;
  temp: Cardinal;

  Prev_Diz: Integer;
  Vstr_Speed: Integer;
  ZvonokVolume: Single; // Громкость звонка на переезде
  ZvonokVolumeDest: Single;
  ZvonokFreq: Integer; // Частота дискретизации звука звонка на переезде
  PereezdZone: Boolean; // Флаг - поезд в зоне (30м) переезда

  VentSingleVolume: Single;
  VentSingleVolumeIncrementer: Extended;

  // KM-Revers
  PrevKMKey: Char;
  PrevReversKey: Char;

  // ЭПК
  PrevEPKKey: Byte;

implementation

uses StrUtils, Variants;

{$R *.dfm}
/// FORM /////////////////////////////////////////////////////////////////////////////

// Perestuk
procedure TFormMain.cbLocPerestukClick(Sender: TObject);
begin
  if cbLocPerestuk.Checked = False then
  else
  begin
    freeChannel(EzdaChannelFX);
    freeChannel(ShumChannelFX);

    for var k := 0 to Length(PerestukChannelFX) - 1 do
      freeChannel(PerestukChannelFX[k]);
    SetLength(PerestukChannelFX, 0);
    Finalize(PerestukChannelFX);
  end;
end;

// TEDs
procedure TFormMain.cbTEDsClick(Sender: TObject);
begin
  if cbTEDs.Checked = False then
  begin
    freeChannel(TEDChannelsFX[0]);
    freeChannel(TEDChannelsFX[1]);
  end
  else
  begin
    PrevTEDAmperage := 0;
    PrevKMPos1 := 0;
  end;
end;

// SAUT
procedure TFormMain.cbSAUTSoundsClick(Sender: TObject);
begin
  if cbSAUTSounds.Checked = True then
  begin
    cbSAVPESounds.Checked := False;
    cbUSAVPSounds.Checked := False;
    cbGSAUTSounds.Checked := False;
    cbEPL2TBlock.Checked := False;
    DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:=; SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'SAUT';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    BASS_ChannelStop(SAUTChannelObjects);
    BASS_StreamFree(SAUTChannelObjects);
    BASS_ChannelStop(SAUTChannelObjects2);
    BASS_StreamFree(SAUTChannelObjects2);
    BASS_ChannelStop(SAUTChannelZvonok);
    BASS_StreamFree(SAUTChannelZvonok);
    SAUTOFFF := 'TWS/SAVP/SAUT/Off.wav';
    SAUTOff := True; // Проигруем звук выключения САУТ
    UpdateInfoName;
  end;
end;

// PRS
procedure TFormMain.cbPRS_RZDClick(Sender: TObject);
begin
  if (cbPRS_RZD.Checked = False) and (cbPRS_UZ.Checked = False) then
  begin
    freeChannel(PRSChannel);
    timerPRSswitcher.Enabled := False;
  end;
  if cbPRS_RZD.Checked or cbPRS_UZ.Checked then
    timerPRSswitcher.Enabled := True;

  timerPRSswitcher.Interval := 1;
end;

// USAVPP
procedure TFormMain.cbUSAVPSoundsClick(Sender: TObject);
begin
  if cbUSAVPSounds.Checked = True then
  begin
    cbSAUTSounds.Checked := False;
    cbGSAUTSounds.Checked := False;
    cbSAVPESounds.Checked := False;
    cbEPL2TBlock.Checked := False;
    DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:='TWS/SAVP/USAVP/575.wav';SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'USAVPP';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    FormUSAVP.Close;
    BASS_ChannelStop(SAUTChannelObjects);
    BASS_StreamFree(SAUTChannelObjects);
    BASS_ChannelStop(SAUTChannelObjects2);
    BASS_StreamFree(SAUTChannelObjects2);
    BASS_ChannelStop(SAUTChannelZvonok);
    BASS_StreamFree(SAUTChannelZvonok);
    UpdateInfoName;
  end;
end;

// Freight SAUT
procedure TFormMain.cbGSAUTSoundsClick(Sender: TObject);
begin
  if cbGSAUTSounds.Checked = True then
  begin
    cbSAVPESounds.Checked := False;
    cbSAUTSounds.Checked := False;
    cbUSAVPSounds.Checked := False;
    cbEPL2TBlock.Checked := False;
    DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:='TWS/SAVP/USAVP/575.wav'; SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'SAUT_G';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    BASS_ChannelStop(SAUTChannelObjects);
    BASS_StreamFree(SAUTChannelObjects);
    BASS_ChannelStop(SAUTChannelObjects2);
    BASS_StreamFree(SAUTChannelObjects2);
    BASS_ChannelStop(SAUTChannelZvonok);
    BASS_StreamFree(SAUTChannelZvonok);
    SAUTOFFF := 'TWS/SAVP/SAUT/Off.wav';
    SAUTOff := True; // Проигруем звук выключения САУТ
    UpdateInfoName;
  end;
end;

// KLUB
procedure TFormMain.cbKLUBSoundsClick(Sender: TObject);
begin
  if cbKLUBSounds.Checked = True then
    cb3SL2mSounds.Checked := False
end;

// 3SL2m
procedure TFormMain.cb3SL2mSoundsClick(Sender: TObject);
begin
  if cb3SL2mSounds.Checked = True then
    cbKLUBSounds.Checked := False
  else
  begin
    freeChannel(SkorostemerChannel[0]);
    freeChannel(SkorostemerChannel[1]);
  end;
end;

// Vstrech
procedure TFormMain.cbHeadTrainSoundClick(Sender: TObject);
begin
  if cbHeadTrainSound.Checked = False then
  begin
    BASS_ChannelStop(Vstrech);
    BASS_StreamFree(Vstrech);
  end;
end;

// Brake slipp + scr
procedure TFormMain.cbBrakingSoundsClick(Sender: TObject);
begin
  if cbBrakingSounds.Checked then
    BrakeCylinders := 0.0
  else
  begin
    freeChannel(BrakeChannelFX);
    freeChannel(BrakeScrChannelFX);
  end;
end;

// Nature
procedure TFormMain.cbNatureSoundsClick(Sender: TObject);
begin
  if cbNatureSounds.Checked = False then
  begin
    freeChannel(ChannelsMisc[0]);
    freeChannel(ChannelsMisc[1]);
    freeChannel(ChannelsMisc[2]);
  end
  else
    PrevRain := 0;
end;

// Aux machines
procedure TFormMain.cbVspomMashClick(Sender: TObject);
begin
  if cbVspomMash.Checked = False then
  begin
    freeChannel(Unipuls_Channel[0]);
    freeChannel(Unipuls_Channel[1]);

    // With CHS8__ do
    // begin
    // UnipulsFaktVol := 0;
    // UnipulsTargetVol := 0;
    // UnipulsTargetPos := 0;
    // UnipulsFaktPos := 0;
    // end;
    timerPerehodUnipulsSwitch.Enabled := False;

    freeChannel(MKChannelsFX[0]);
    freeChannel(MKChannelsFX[1]);
    freeChannel(MKChannelsFX[2]);

    freeChannel(MVChannelsFX[0]);
    freeChannel(MVChannelsFX[1]);
    freeChannel(MVChannelsFX[2]);

    freeChannel(MVTDChannelsFX[0]);
    freeChannel(MVTDChannelsFX[1]);
    freeChannel(MVTDChannelsFX[2]);
  end;
end;

// Signals
procedure TFormMain.cbSignalsSoundsClick(Sender: TObject);
begin
  if cbSignalsSounds.Checked = False then
  begin
    freeChannel(SignalChannels[0][0]);
    freeChannel(SignalChannels[0][1]);
    freeChannel(SignalChannels[1][0]);
    freeChannel(SignalChannels[1][1]);
  end;
end;

// SAVPE manual mode
procedure TFormMain.RB_HandEKModeClick(Sender: TObject);
begin
  WagF := '';
  cbSAVPE_Marketing.Enabled := False;
  GroupBox5.Enabled := False;
  Edit1.Enabled := False;
  Edit1.Color := clInactiveCaption;
  // ComboBox2Change(FormMain);
end;

// SAVP update
procedure TFormMain.UpdateInfoName();
begin
  if (cbSAUTSounds.Checked = False) and (cbSAVPESounds.Checked = False) and (cbUSAVPSounds.Checked = False) and
    (cbGSAUTSounds.Checked = False) then
    SAVPName := '';
end;

// Volume
procedure TFormMain.ChangeVolume(Sender: TObject);
begin
  RefreshVolume();
end;

/// /////////////////////////////////////////////////////////////////////////////////

// Close app
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Log_.DebugFreeLog();
  try
    SaveTWSParams('TWS\settings_TWS.ini');
  except
  end; // Автосохранение всех параметров
  try
    Bass_Stop(); // Останавливаем проигрывание
    Bass_Free; // Освобождаем ресурсы используемые Bass
  except
  end;
end;

// Open app
procedure TFormMain.FormCreate(Sender: TObject);
begin
  BASS_Init(-1, 44100, 0, application.Handle, nil); // Инициализация BASS
  LoadTWSParams('TWS\settings_TWS.ini'); // Делаем загрузку параметров TWS

  CHS7__ := chs7_.Create;
  // CHS8__ := chs8_.Create;
  // CHS4T__ := chs4t_.Create;
  // CHS4KVR__ := chs4kvr_.Create;
  // VL80T__ := vl80t_.Create;
  // EP1M__ := ep1m_.Create;
  // ES5K__ := es5k_.Create;

  isGameOnPause := True;

  MainCycleFreq := ClockMain.Interval;

  SAVP.InitializeSAVP;

  SAUTOff := False; // Запрещаем проигрывание звука выключения САУТ
  isSpeedLimitRouteLoad := False;
  isRefreshLocalData := True; // При запуске обновляем все данные нужные для функционирования программы

  Log_.DebugLogStart(Self);
  Log_.DebugWriteErrorToErrorList('TWS started');
end;

// Installation check
function TFormMain.CheckInstallation(): Boolean;
begin
  if FileExists('Launcher.exe') = False then
  begin
    if FileExists('ZLauncher.exe') = False then
    begin
      MessageDLG('Ошибка программа установлена не правильно! Установите програму в корень ZDSimulator!', mterror,
        mbOKCancel, 0);
      Result := False;
    end
    else
      Result := True;
  end
  else
    Result := True;
end;

// FindTask
function FindTask(ExeFileName: string): Boolean;
var
  FSnapshotHandle: HWND;
  ContinueLoop: BOOL;
  FProcessEntry32: TProcessEntry32;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or
      (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      Result := True;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// Camera
function CameraInCabinCheck(CameraX: Integer; Camera: Byte): Boolean;
begin
  if Camera = 0 then
    Result := (CameraX <= 49130) and (CameraX >= 32000) or (CameraX < 16384) or (CameraX = 0);
end;

// start_kilometers.dat
procedure GetStationsBordersFromFile(FileName: String);
var
  Str: String;
  FileText: TextFile;
  FileLinesList: TStringList;
  StationsList: TStringList;
  I: Integer;
  c: String;
begin
  AssignFile(FileText, FileName);
  Reset(FileText);
  while not Eof(FileText) do
  begin
    Readln(FileText, c);
    Str := Str + c + #13;
  end;
  CloseFile(FileText);

  FileLinesList := ExtractWord(Str, #13);
  StationCount := FileLinesList.Count;

  for I := 0 to StationCount - 1 do
  begin
    StationsList := ExtractWord(FileLinesList[I], ' ');
    if StationsList.Count >= 3 then
    begin
      try
        StationTrack1[I] := StrToInt(StationsList[2]);
        StationTrack2[I] := StrToInt(StationsList[1]);
      except
      end;
    end;
  end;

  StationsList.Free();
  FileLinesList.Free();
end;

// Refresh local data
procedure RefreshLocalData(isPerestukChecked: Boolean; Memo1: TMemo);
var
  St: String;
  Sl: TStringList;
begin
  isSpeedLimitRouteLoad := False;
  PrevSpeed := 0;

  try
    InitializeStartParams(VersionID);
    GetStartSettingParamsFromRAM();
    InitializeLoco(LocoGlobal);
  except
  end;

  if isPerestukChecked then
  begin
    AxesLocoAmount := Length(AxesDistancesLoco);
    AxesAmount := AxesLocoAmount + WagonsAmount * Length(AxesDistancesWagon);

    SetLength(PerestukChannelFX, Round(0.4 * AxesAmount));
    SetLength(PerestukStack, Round(0.4 * AxesAmount));
  end;

  // --- Грузим локальную ЭК из сценария --- //
  // if SceneryName <> '' then begin
  // try GetLocalEKFromScenery('routes/' + Route + '/scenaries/' + SceneryName); except end;
  // end;

  try
    if Route <> '' then
      GetStationsBordersFromFile('routes/' + Route + '/start_kilometers.dat');
  except
  end;

  try
    ConsistLength := 0;
    if Pos('.con', ConName) > 0 then
    begin
      Memo1.Lines.LoadFromFile('data\consists\' + ConName);
      Sl := TStringList.Create;
      for var I := 0 to Memo1.Lines.Count - 1 do
      begin
        try
          St := Memo1.Lines[I];
          if St[1] <> ';' then
          begin
            ExtractStrings([#9], [' '], PChar(St), Sl);
            ConsistLength := ConsistLength + StrToFloat(Sl[2]);
          end;
        except
        end;
      end;
      Sl.Free;
      ConsistLength := ConsistLength + 18 * LocoSectionsAmount;
    end
    else
    begin
      if Freight = 1 then
        ConsistLength := 14 * WagonsAmount + 18 * LocoSectionsAmount
      else
        ConsistLength := 25 * WagonsAmount + 18 * LocoSectionsAmount;
    end;

    // Автовыбор типа вагонов для их перестука
    if Naprav = '1' then
      Naprav := 'Tuda'
    else
      Naprav := 'Obratno';
  except
  end;

  if scSAVPOverrideRouteEK = False then
    Load_TWS_SAVP_EK();

  if isRefreshLocalData then
    isRefreshLocalData := False;
end;

// Main cycle ////////////////////////////////////////////////////////////////////////

procedure TFormMain.ClockMainTimer(Sender: TObject);
var
  SpeedSmoothed: Double;
begin
  try
    // Проверка обновления статуса открытого симулятора
    if (isConnectedMemory <> PrevConMem) Or (LocoGlobal = '') then
    begin
      isRefreshLocalData := True;

      if isConnectedMemory then
        BASS_Start
      else
        Bass_Stop;
    end;

    if isGameOnPause = False then
    begin
      if isConnectedMemory then
        ReadVarsFromRAM();
      if isRefreshLocalData then
      begin
        RefreshLocalData(cbLocPerestuk.Checked, Memo1);

        if Freight = 1 then
          RadioButton2.Checked := True
        else
          RadioButton1.Checked := True;

        RefreshVolume();
      end;

      if Loco = 'CHS7' then
        CHS7__.step();

      IsOnStation := False;
      for var k := 0 to StationCount - 1 do
        if (StationTrack1[k] < Track) and (Track < StationTrack2[k]) then
          IsOnStation := True;

      // Smoothed speed
      SpeedSmoothed := SpeedSmoothed + 0.0055 * Acceleretion * FormMain.ClockMain.Interval;
      if (Abs(SpeedSmoothed - Speed) > 1) or (Speed = 0) and (Acceleretion = 0) then
        SpeedSmoothed := Speed;

      // isCameraInCabin := CameraInCabinCheck(CameraX, Camera);

      var
      delta := 0.000278 * Speed * MainCycleFreq;
      if NapravOrdinata = 'Tuda' then
        OrdinataEstimate := OrdinataEstimate + delta
      else
        OrdinataEstimate := OrdinataEstimate - delta;

      // Проверяем менялись-ли показания камеры?
      if (Camera <> PrevCamera) or (CameraX <> PrevCameraX) then
        RefreshVolume();

      // ТЭДы
      if cbTEDs.Checked and LocoWithTED then
      begin
        HandleTEDSounds(TEDChannelsFX, TEDAttrs, LocoWorkDir + TEDFile, TEDAmperage, UltimateTEDAmperage, EDTAmperage,
          PrevKMPos1, TedNow);
        HandleReductorSounds(ReduktorChannelsFX, ReduktorAttrs, LocoWorkDir + ReduktorFile, TEDAmperage,
          UltimateTEDAmperage, EDTAmperage, SpeedSmoothed);
      end;

      // БЛОК ЗВУКОВ ОКРУЖЕНИЯ
      if cbNatureSounds.Checked then
        HandleMiscSounds(ChannelsMisc, Rain, PrevRain, Track, OutsideLocoStatus);

      // KLUB-3SL2m
      if cbCabinClicks.Checked then
      begin
        if cbKLUBSounds.Checked then
          HandleKLUBSounds(ChannelsDefault, SkorostemerChannel, OgrSpeed, PrevOgrSpeed, NextOgrSpeed, PrevNextOgrSpeed,
            NextOgrPeekStatus, SpeedSmoothed, Svetofor, PrevSvetofor, PrevKeyTAB, KLUBOpen)
        else if cb3SL2mSounds.Checked then
          Handle3SL2mSounds(ChannelsDefault, SkorostemerChannel)
      end;

      // СВИСТОК-ТИФОН
      if cbSignalsSounds.Checked then
      begin
        HandleSignal(0, Signals, SignalChannels, LocoWorkDir, SignalStates);
        HandleSignal(1, Signals, SignalChannels, LocoWorkDir, SignalStates);
      end;

      // ВСПОМ-МАШИНЫ
      if cbVspomMash.Checked then
      begin
        HandleMKSounds(Compressors, MKChannelsState, MKChannelsFX, MKAttrs, LocoWorkDir);

        HandleMVSounds(MVsState, MVChannelsState, MVChannelsFX, MVAttrs, LocoWorkDir);
        HandleMVSounds(MVsTDState, MVTDChannelsState, MVTDChannelsFX, MVAttrs, LocoWorkDir, 'TD');

        HandleMVPitch(MVChannelsFX, MVAttrs, MVTDChannelsFX, MVTDAttrs);
      end;

      // ТП
      if cbTPSounds.Checked then
        HandleTPSounds(ChannelsDefault, LocoWithSndTP, FrontTP, PrevFrontTP, BackTP, PrevBackTP);

      // ЩЕЛЧКИ
      if cbCabinClicks.Checked then
      begin
        HandleClickSounds(ChannelsDefault, ChannelsMisc, KM395, PrevKM395, KM294, PrevKM294, PrevEPKKey, PrevKMAbs,
          KMPos1, Reostat, PrevReostat, Voltage, PrevVoltage, LocoWithSndReversor, LocoSndReversorType, ReversorPos,
          PrevReversKey, Stochist, PrevStochist);
        if LocoWithSndKM and (ReversorPos <> 0) and (PrevReversorPos <> 0) then
          HandleKMSounds(ChannelsDefault, KMOP, PrevKMOP, PrevKMKey);
      end;

      // 254 / 395
      if True then // TODO
        HandleBrakeKMSounds(Brake254ChannelFX, Brake254Attrs, Brake254Timer, BrakeCylinders, PrevBrakeCylinders,
          isBrake254FadeIn);

      // ТРЕНИЕ КОЛОДОК ПРИ ТОРМОЖЕНИИ
      if cbBrakingSounds.Checked then
        HandleBrakeSounds(BrakeChannelFX, BrakeAttrs, BrakeScrChannelFX, BrakeScrAttrs, BrakeCylinders, SpeedSmoothed,
          EDTAmperage);

      // ЕЗДА
      if cbLocPerestuk.Checked then
      begin
        HandleEzda(SpeedSmoothed, EzdaChannelFX, EzdaAttrs, ShumChannelFX, ShumAttrs);
        HandlePerestuk(PerestukChannelFX, PerestukStack, PerestukStackSize, SpeedSmoothed, PrevTrack, Track, AxesAmount,
          AxesDistancesWagon, AxesDistancesLoco, AxesLocoAmount);
      end;

      // БЛОК МНОГОСТРАДАЛЬНОГО ВСТРЕЧНОГО ПОЕЗДА
      if (cbHeadTrainSound.Checked = True) and (VstrTrack <> 0) then
        HandleVstrech();

      SAVPTick();
      SoundManagerTick();

      PrevKM395 := KM395;
      PrevKM294 := KM294;
      PrevSpeed := Speed;
      PrevOgrSpeed := OgrSpeed;
      PrevNextOgrSpeed := NextOgrSpeed;
      PrevAcceleretion := Acceleretion;
      PrevCoupleStat := CoupleStat;
      PrevTrack := Track;
      PrevSvetofor := Svetofor;
      PrevFrontTP := FrontTP;
      PrevBackTP := BackTP;
      PrevBV := BV;
      PrevReostat := Reostat;
      Prev_SvetoforDist := SvetoforDist;
      PrevReversorPos := ReversorPos;
      PrevKMOP := KMOP;
      PrevRain := Rain;
      PrevVstrechStatus := VstrechStatus;
      PrevCamera := Camera;
      PrevSpeed_Fakt := Speed;
      PrevVCheck := VCheck;
      PrevCameraX := CameraX;
      PrevTEDAmperage := TEDAmperage;
      PrevEDTAmperage := EDTAmperage;
      PrevBrakeCylinders := BrakeCylinders;
      PrevVoltage := Voltage;
      PrevKMAbs := KMPos1;
      PrevStochist := Stochist;
      Prev_StchstDGR := StochistDGR;
      PrevAB_ZB_1 := AB_ZB_1;
      PrevAB_ZB_2 := AB_ZB_2;
      PrevBoks_Stat := Boks_Stat;
      PrevEPT := EPT;
      PrevZhaluzi := Zhaluzi;
      PrevHighLights := Highlights;
      PrevVstrTrack := VstrTrack;
      PrevRB := RB;
      PrevRBS := RBS;
      PrevOrdinata := Ordinata;
      PrevTC := TC;
      PrevVR242 := VR242;
      PrevReversorPos := ReversorPos;

      if PrevOrdinata < Ordinata then
        NapravOrdinata := 'Tuda'
      else if PrevOrdinata > Ordinata then
        NapravOrdinata := 'Obratno';

      PrevConMem := isConnectedMemory;
    end;
  except
    // НИЧЕГО
  end;
end;

procedure TFormMain.timerSoundSliderTimer(Sender: TObject);
var
  VentVolume: Single;
begin
  // ЗАТУХАНИЕ ЗВУКА ВСТРЕЧНОГО ПОЕЗДА
  if VstrZat = True then
  begin
    VstrVolume := VstrVolume - 3;
    if VstrVolume <= 0 then
    begin
      VstrVolume := 0;
      VstrZat := False;
      BASS_ChannelStop(Vstrech);
      BASS_StreamFree(Vstrech);
    end;
    BASS_ChannelSetAttribute(Vstrech, BASS_ATTRIB_VOL, 0.01 * VstrVolume);
  end;

  // ЗАТУХАНИЕ ЗВОНКА НА ПЕРЕЕЗДЕ
  if PereezdZatuh = True then
  begin
    ZvonVolume := ZvonVolume - 0.5;
    if ZvonVolume <= 0 then
    begin
      ZvonVolume := 0;
      PereezdZatuh := False;
      BASS_ChannelStop(SAUTChannelZvonok);
      BASS_StreamFree(SAUTChannelZvonok);
    end;
    BASS_ChannelSetAttribute(SAUTChannelZvonok, BASS_ATTRIB_VOL, 0.01 * ZvonVolume);
  end;

  // With CHS8__ do
  // begin
  // if isStartUnipuls = True then
  // begin
  // BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0.01 * UnipulsFaktVol);
  // inc(UnipulsFaktVol);
  // if UnipulsFaktVol = UnipulsTargetVol then
  // isStartUnipuls := False;
  // end;
  // if isStopUnipuls = True then
  // begin
  // BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0.01 * UnipulsFaktVol);
  // Dec(UnipulsFaktVol);
  // if UnipulsFaktVol = UnipulsTargetVol then
  // begin
  // isStopUnipuls := False;
  // BASS_ChannelStop(Unipuls_Channel[UnipulsChanNum]);
  // BASS_StreamFree(Unipuls_Channel[UnipulsChanNum]);
  // UnipulsFaktPos := 0;
  // UnipulsTargetPos := 0;
  // end;
  // end;
  // end;
  // Переход между дорожками Унипульса
  (* if UnipulsPerehod=True then begin
    if UnipulsChanNum=0 then begin
    UnipulsVol1:=UnipulsVol1-10; UnipulsVol2:=UnipulsVol2+10;
    if UnipulsVol1<0 then begin UnipulsVol1:=0; UnipulsVol2:=TrackBar8.Position; end;
    BASS_ChannelSetAttribute(Unipuls_Channel1, BASS_ATTRIB_VOL, UnipulsVol1/100);
    BASS_ChannelSetAttribute(Unipuls_Channel2, BASS_ATTRIB_VOL, UnipulsVol2/100);
    if UnipulsVol1=0 then begin UnipulsPerehod:=False; BASS_ChannelStop(Unipuls_Channel1); BASS_StreamFree(Unipuls_Channel1); end;
    end;
    if UnipulsChanNum=1 then begin
    UnipulsVol1:=UnipulsVol1-10; UnipulsVol2:=UnipulsVol2+10;
    if UnipulsVol1<0 then begin UnipulsVol1:=0; UnipulsVol2:=TrackBar8.Position; end;
    BASS_ChannelSetAttribute(Unipuls_Channel2, BASS_ATTRIB_VOL, UnipulsVol1/100);
    BASS_ChannelSetAttribute(Unipuls_Channel1, BASS_ATTRIB_VOL, UnipulsVol2/100);
    if UnipulsVol1=0 then begin UnipulsPerehod:=False; BASS_ChannelStop(Unipuls_Channel2); BASS_StreamFree(Unipuls_Channel2); end;
    end;
    end; *)
end;

// PRS
procedure TFormMain.timerPRSswitcherTimer(Sender: TObject);
begin
  if IsOnStation then
    timerPRSswitcher.Interval := 180000
  else
  begin
    randomize;
    randomize;
    timerPRSswitcher.Interval := 350000 + random(150000);
  end;

  HandlePRSSounds(ChannelsMisc, cbPRS_RZD.Checked, cbPRS_UZ.Checked);
end;

// Vigilance
procedure TFormMain.timerVigilanceUSAVPDelayTimer(Sender: TObject);
begin
  timerVigilanceUSAVPDelay.Enabled := False;
  if VCheck <> 0 then
    DecodeResAndPlay('TWS/SAVP/USAVP/567.res', isPlaySAUTObjects, SAUTF, SAUTChannelObjects, ResPotok, PlayRESFlag);
end;

// ZDSimulator check timer
procedure TFormMain.timerSearchSimulatorWindowTimer(Sender: TObject);
var
  I: Integer;
begin
  isConnectedMemory := FindTask('Launcher.exe'); // Проверка запущен-ли симулятор?

  if isConnectedMemory then
  begin
    for I := 0 to 2 do
    begin
      if I = 0 then
        GameWindowName := 'ZDSimulator55.008';
      if I = 1 then
        GameWindowName := 'ZDSimulator54.006';
      if I = 2 then
        GameWindowName := 'viewer';
      wHandle := FindWindow(nil, PChar(GameWindowName + ' [Paused]'));
      if wHandle <> 0 then
      begin
        isGameOnPause := True;
        isConnectedMemory := True;
        Label5.Caption := GameWindowName;
        break;
      end
      else
      begin
        wHandle := FindWindow(nil, PChar(GameWindowName));
        if wHandle = 0 then
        begin
          isGameOnPause := True;
          isConnectedMemory := False;
          Label5.Caption := 'Симулятор не запущен';
        end
        else
        begin
          tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
          pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
          isGameOnPause := False;
          CloseHandle(pHandle);
          isConnectedMemory := True;
          Label5.Caption := GameWindowName;
          if I = 2 then
            ClockMain.Enabled := False;
          break;
        end;
      end;
      CloseHandle(wHandle);
    end;
  end
  else
    isGameOnPause := True;

  if I <> VersionID then
    InitializeStartParams(I);

  VersionID := I;
end;

/// ///////////////////////////////////////////////////////////////////////////////////

procedure TFormMain.timerPerehodUnipulsSwitchTimer(Sender: TObject);
begin
  timerPerehodUnipulsSwitch.Enabled := False;
end;

// SAVPE MVPS
procedure TFormMain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0' .. '9'] + [#8] then
  begin
    // nothing
  end
  else
    Key := #0;
end;

procedure TFormMain.Edit1Change(Sender: TObject);
begin
  try
    if StrToInt(Edit1.Text) > 255 then
      Edit1.Text := IntToStr(255);
  except
  end;
end;

// BATs
procedure TFormMain.Button3Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'explore', PChar(ExtractFilePath(application.ExeName) + 'TWS/БАТНИКИ/'), nil, nil,
    SW_SHOWNORMAL);
end;

// Open BATs
procedure TFormMain.N5Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'explore', PChar(ExtractFilePath(application.ExeName) + 'TWS/BAT_FILES/'), nil, nil,
    SW_SHOWNORMAL);
end;

// Open README
procedure TFormMain.ReadME1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(ExtractFilePath(application.ExeName) + 'TWS/ReadME.doc'), nil, nil, SW_SHOWNORMAL);
end;

// Save settings
procedure TFormMain.N3Click(Sender: TObject);
var
  saveDialog: TSaveDialog; // Переменная диалога сохранения
  Res: Integer;
begin
  saveDialog := TSaveDialog.Create(Self);

  // Give the dialog a title
  saveDialog.Title := 'Save your text or word file';
  saveDialog.InitialDir := 'TWS\saves\';
  saveDialog.Filter := 'Ini files|*.ini';
  saveDialog.DefaultExt := 'ini';
  saveDialog.FilterIndex := 0;

  if saveDialog.Execute then
  begin
    // Если файл с указанным именем уже существует.
    if FileExists(saveDialog.FileName) then
    begin
      Res := MessageDLG('Файл с именем:' + #10 + '"' + saveDialog.FileName + '"' + #10 +
        'Уже существует. Перезаписать?', mtConfirmation, [mbYes, mbNo], 0);
      if Res = mrYes then
        SaveTWSParams(saveDialog.FileName);
    end
    else
      SaveTWSParams(saveDialog.FileName);
  end;

  saveDialog.Free;
end;

// TWS settings.ini
procedure TFormMain.N4Click(Sender: TObject);
var
  openDialog: TOpenDialog; // Переменная OpenDialog
begin
  openDialog := TOpenDialog.Create(Self);
  openDialog.InitialDir := 'TWS\saves\';
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'Ini files|*.ini';
  openDialog.FilterIndex := 0;

  if openDialog.Execute then
    LoadTWSParams(openDialog.FileName);

  openDialog.Free;
end;

// Authors
procedure TFormMain.N6Click(Sender: TObject);
begin
  FormAuthors.Show();
end;

// Settings
procedure TFormMain.N9Click(Sender: TObject);
begin
  FormSettings.Show();
end;

// Debug
procedure TFormMain.N10Click(Sender: TObject);
begin
  FormDebug.Show();
end;

// SAVPE help
procedure TFormMain.btnSAVPEHelpClick(Sender: TObject);
begin
  FormSAVPEHelp.Show;
end;

// SOVI help
procedure TFormMain.btnSOVIHelpClick(Sender: TObject);
begin
  FormSOVIHelp.ShowModal();
end;

end.
