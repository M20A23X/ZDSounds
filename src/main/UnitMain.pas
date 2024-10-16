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
  TPerestukStackAttr = (AXIS_IDX, TIME, P_ID);

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

    procedure ChangeVolume(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClockMainTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timerSoundSliderTimer(Sender: TObject);
    procedure cbLocPerestukClick(Sender: TObject);
    procedure RB_HandEKModeClick(Sender: TObject);
    procedure cbSAUTSoundsClick(Sender: TObject);
    procedure cbPRS_RZDClick(Sender: TObject);
    procedure timerPRSswitcherTimer(Sender: TObject);
    procedure cbUSAVPSoundsClick(Sender: TObject);
    procedure cbGSAUTSoundsClick(Sender: TObject);
    procedure timerSearchSimulatorWindowTimer(Sender: TObject);
    procedure cbKLUBSoundsClick(Sender: TObject);
    procedure cb3SL2mSoundsClick(Sender: TObject);
    procedure cbHeadTrainSoundClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbNatureSoundsClick(Sender: TObject);
    procedure cbTEDsClick(Sender: TObject);
    procedure cbBrakingSoundsClick(Sender: TObject);
    procedure btnSAVPEHelpClick(Sender: TObject);
    procedure cbVspomMashClick(Sender: TObject);
    procedure timerPerehodUnipulsSwitchTimer(Sender: TObject);
    procedure timerPerehodDizSwitchTimer(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure timerDoorCloseDelayTimer(Sender: TObject);
    procedure RB_AutoEKModeClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    function CheckInstallation(): Boolean;
    procedure UpdateInfoName();
    procedure TWS_PlaySvistok(FileName: String);
    procedure TWS_PlaySvistokCycle(FileName: String);
    procedure TWS_PlayTifon(FileName: String);
    procedure TWS_PlayTifonCycle(FileName: String);
    procedure N5Click(Sender: TObject);
    procedure ReadME1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure cbSignalsSoundsClick(Sender: TObject);
    procedure trcBarSignalsVolChange(Sender: TObject);
    procedure timerVigilanceUSAVPDelayTimer(Sender: TObject);
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

  // ДАННЫЕ ПОЛУЧАЕМЫЕ С ФАЛЙА settings.ini (С 2.6 из ОЗУ) //
  Route: String; // Переменная для хранения имени маршрута
  Naprav: String;
  // Переменная для хранения направления движения (Tuda && Obratno)
  NapravOrdinata: String;
  // Переменная для хранения направления движения (для ординат)
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
  // ----------------------------------------------------- //

  // Границы станций из файла start_kilometers.dat //
  StationTrack1: array [0 .. 75] Of Integer; // 1-ая граница станции
  StationTrack2: array [0 .. 75] Of Integer; // 2-ая граница станции
  StationCount: Byte = 0; // Общее количество станций
  // --------------------------------------------- //

  Loco, LocoGlobal: String; // Переменная для хранения имени локомотива
  LocoSectionsAmount: Byte; // Количество секций на локомотиве
  LocoWithTED: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звук ТЭД-ов
  LocoWithReductor: Boolean;
  LocoWithDIZ: Boolean;
  LocoWithSndReversor: Boolean;
  LocoWithSndKM: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звук щелчка котнроллера
  LocoWithSndKMOP: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звук постановки ОП
  LocoWithSndTP: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звуки ТП
  LocoWithExtMVSound: Boolean;
  // Переменная для определения, есть-ли на данный локомотив внешние звуки МВ
  LocoWithExtMKSound: Boolean;
  // Переменная для определения, есть-ли на данный локомотив внешние звуки МК
  LocoWithMVPitch: Boolean;
  LocoWithMVTDPitch: Boolean;
  LocoSndReversorType: Byte;
  // Тип звуков реверсора на локомотиве (0 - читаем состояние с памяти, 1 - по нажатию соответствующих клавиш
  LocoTEDNamePrefiks: String;
  LocoDIZNamePrefiks: String;
  LocoSvistokF: String;
  LocoHornF: String;
  LocoWorkDir: String; // Рабочая директория локомотива
  VentTDStartF, XVentTDStartF: PChar;
  VentTDCycleF, XVentTDCycleF: PChar;
  VentTDStopF, XVentTDStopF: PChar;

  // Переменные для клавиш клавиатуры //
  PrevKeyA, PrevKeyD: Byte; // Переменная для пред. нажатия клавиш <<A>> и <<D>>
  PrevKeyE, PrevKeyQ: Byte; // Переменная для пред. нажатия клавиш <<E>> и <<Q>>
  PrevKeyZ, PrevKeyLKM: Byte; // Переменная для пред. нажатия клавиш <<Z>> и <<LKM>>
  PrevKeyM: Byte; // Переменная для пред. нажатия клавиш <<M>> и <<N или SHIFT+N>>
  PrevEPKKeyS: Byte;
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
  // ********************************* //

  GRIncrementer: Byte;
  GRIncrementer2: Byte;

  sDecodeString: String;

  CycleVentVolume: Byte; // Громкость цикла работы вентиляторов (ВЛ80т)
  VentVolume: Byte; // Громкость работы вентиляторов (ВЛ80т)
  ZvonVolume: Extended;
  ZvonTrack: Integer; // Переменные для звонка переезда
  Vstrecha_dlina: Integer; // Длинна встречки (в метрах)
  PrevSpeed_Fakt: Integer; // Фактическая предыдущая скорость
  Prev_KMAbs: Integer; // Фактическая предыдущая позиция
  Prev_VentLocal: Integer; // Для ЧС4 квр

  // ----------------------------------------------------------------------- //
  // === ДАЛЕЕ - ПЕРЕМЕННЫЕ ДЛЯ ХРАНЕНИЯ ДАННЫХ КОТОРЫЕ ПОЛУЧАЮТСЯ С ОЗУ === //
  // ----------------------------------------------------------------------- //
  Svetofor, PrevSvetofor: Byte; // Показания светофора (код сигнала)
  CoupleStat, PrevCoupleStat: Byte;
  Highlights, PrevHighLights: Byte; // Состояние прожекторов
  VstrechStatus, PrevVstrechStatus: Byte;
  PickKLUB, PrevPickKLUB: Integer;
  Reostat, PrevReostat: Byte; // Переменная включения ЭДТ на ЧС8, для звука защелки
  Fazan, PrevFazan: Byte; // Фазорасщепитель для ВЛ80т
  Rain, PrevRain: Byte; // Переменные интенсивности дождя
  Camera, PrevCamera: Byte; // Переменные для определения типа камеры
  RB, PrevRB: Byte; // Переменные для РБ (ПИКУРОВ)
  RBS, PrevRBS: Byte; // Переменные для РБC (ПИКУРОВ)
  EPT, PrevEPT: Byte; // Переменная состояния ЭПТ (для тумблера ЭД-шэк)
  BV, PrevBV: Byte; // БВ, ЭД4(9)м, ЧС7 чтобы сделать щелчок тумблера и вентиляторы на ЧС7
  Voltage, PrevVoltage: Single; // Напряжение на электровозе ЧС7
  CameraX, PrevCameraX: WORD; // Переменные для определения положения головы в кабине
  KME_ED, PrevKME_ED: Integer;
  Zhaluzi, PrevZhaluzi: Byte; // Состояние жалюзей [ЧС7]
  Compressor, Prev_Compressor: Single; // Состояние компрессоров
  Stochist, Prev_Stochist: Single; // Состояние дворников
  StochistDGR, Prev_StchstDGR: Double; // Угол поворота дворников
  Vent, Prev_Vent: Integer; // Состояние Вентиляторов [1]
  Vent2, Prev_Vent2: Single; // Состояние Вентиляторов [2] (ВЛ80т, ЭП1м)
  Vent3, Prev_Vent3: Single; // Состояние Вентиляторов [3] (ВЛ80т, ЭП1м)
  Vent4, Prev_Vent4: Single; // Состояние Вентиляторов [4] (ВЛ80т)
  VCheck, PrevVCheck: Byte; // Состояние проверки бдительности, для звука пиканья на КЛУБ-У
  SvetoforDist, Prev_SvetoforDist: WORD; // Расстояние до свотофора
  FrontTP, PrevFrontTP: Integer; // Состояние переднего ТП
  BackTP, PrevBackTP: Integer; // Состояние заднего ТП
  LDOOR, PrevLDOOR: Byte;
  RDOOR, PrevRDOOR: Byte;
  diesel2, PrevDiesel2: Single; // Состояное дизеля второй секции
  VstrTrack, PrevVstrTrack: WORD; // Переменные ординаты встречки
  Track_Vstrechi: Integer; // Трэк на котором произошла встреча нашего состава с встречным
  Acceleretion, PrevAcceleretion: Double; // Ускорение м/(с^2)
  Speed, PrevSpeed: Integer; // Скорость
  OgrSpeed, PrevOgrSpeed: WORD; // Ограничение скорости
  NextOgrSpeed, PrevNextOgrSpeed: Byte; // Следующее ограничение скорости (желтая точка на КЛУБ-е)
  NextOgrPeekStatus: Byte; // Статус для пиканья про снижение ограничения [0-нет снижения 1-в процессе]
  PrevPRS: Integer;
  KLUBOpen: Byte; // Переменная-флаг открыта-ли в игре клавиатура КЛУБ
  TrackTail: Integer; // Номер трэка хвоста нашего поезда
  VstrechStatusCounter: Integer;
  isVstrechDrive: Boolean;
  Ordinata, PrevOrdinata: Double;
  OrdinataEstimate, PrevOrdinataEstimate: Double;
  OutsideLocoStatus: WORD;
  GR, PrevGR: Double;
  VR242, PrevVR242: Single;

  // 254 / 395
  KM_395, PrevKM_395: Byte;
  KM_294, PrevKM_294: Single;

  TC, PrevTC: Double;
  BrakeCylinders, PrevBrakeCylinders: Single;
  BrakeDelta: Double;

  DebugFile: TextFile;

  // КМ-Revers
  ReversorPos, PrevReversorPos: Integer;
  KMPos1, PrevKMPos1: Integer;
  KMPos2, PrevKMPos2: Byte;
  PrevKMOP, KMOP: Single;

  // ------------------------------------------------------------------------------- //
  // ================ ДАЛЕЕ - ПЕРЕМЕННЫЕ ДЛЯ ХРАНЕНИЯ ПУТИ К ЗВУКАМ ================ //
  // ------------------------------------------------------------------------------- //
  Track, PrevTrack: Integer;
  ChannelNumDiz: Byte; // Номер канала для звуков дизеля
  Ini: TIniFile; // Ini файл настроек
  DizVolume, DizVolume2: Single; // Громкость дорожки дизеля, нужно для разделения звуков на внешние и внутренние
  PerehodDIZ: Boolean;
  DIZVlm: Single;
  PerehodDIZStep: Single;
  EDTAmperage, PrevEDTAmperage: Single;
  VstrVolume: Integer;
  TEDAmperage, PrevTEDAmperage: Single;
  UltimateTEDAmperage: Integer; // Предельный ток нагрузки на ТЭД-ы
  TrackVstrechi: Integer; // Номер трэка где встретились состав игрока со встречкой
  WagNum_Vstr: Byte;
  AB_ZB_1, AB_ZB_2: Byte;
  PrevAB_ZB_1, PrevAB_ZB_2: Byte;
  PrevBoks_Stat, Boks_Stat: Byte;
  // ------------------------------------------------------ //
  // ******* ФЛАГИ ******* //
  SAVPENextMessage: Boolean = False;
  HeadTrainEndOfTrain: Boolean;
  isCameraInCabin: Boolean; // Флаг для понимания, в кабине-ли камера?
  isRefreshLocalData: Boolean; // флаг для перезагрузки в скрипт всех данных необходимых для работы
  // Флаг для провоцирования звука перестука тележек локомотива в случайные промежутки времени
  SAUTOff: Boolean; // Фалг для воспроизведения финального звука выключения САУТ
  isConnectedMemory, PrevConMem: Boolean; // Флаг для определения: удалось ли подключиться к памяти?
  isGameOnPause: Boolean; // Флаг для состояния паузы игры (сворочивание)
  VstrZat: Boolean; // Флаг для велючения затухания звука встречного поезда
  PlayRESFlag: Boolean;
  PereezdZatuh: Boolean;
  isSpeedLimitRouteLoad: Boolean;
  StopVentTD: Boolean;
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
  StartVentVU: Boolean;
  DizNow: Byte;
  // ****************************************** //
  GameScreen: HWND; // Дескриптор окна игры
  GameWindowName: String;
  wHandle: Integer;
  tHandle, ProcessID, pHandle: Cardinal;
  temp: Cardinal;
  Prev_Diz: Integer;
  Vstr_Speed: Integer;
  VentTDPitch: Single = -20; // Вентиляторы ТД (ПТР) тональность
  VentTDPitchDest: Single = -20; // Желаемая тональность вентов ТД (ПТР) для плавного увеличения/уменьшения
  VentTDPitchIncrementer: Single; // Инкрементер тональности для МВ ТД
  VentTDVol: Single = 0; // Вентиляторы ТД (ПТР) громкость
  VentTDVolDest: Single = 0;
  VentPitch: Single = 0;
  VentPitchDest: Single;
  VentPitchIncrementer: Single; // Инкрементер тональности для МВ
  ZvonokVolume: Single; // Громкость звонка на переезде
  ZvonokVolumeDest: Single;
  ZvonokFreq: Integer; // Частота дискретизации звука звонка на переезде
  PereezdZone: Boolean; // Флаг - поезд в зоне (30м) переезда

  TEDNewSystem: Boolean = True;
  CHS4tVentNewSystemOnAllLocos: Boolean = False;
  VentSingleVolume: Single;
  VentSingleVolumeIncrementer: Extended;

  // Svistok
  Svistok: Byte;
  Tifon: Byte;

  SoundAttrsDefault: TSoundAttrs = (0, 0, 0);

  // Reductor
  ReduktorFile: PChar;
  reduktorChannelFX: TChannelFX;
  ReduktorAttrs: TSoundAttrs = (0, 0, 0);

  // TEDs
  TEDFile: PChar;
  TEDChannelsFX: array [0 .. 1] of TChannelFX;
  TEDAttrs: TSoundAttrs = (0, 0, 0);

  // Fans
  VentPTRChannelFX: array [0 .. 1] of TChannelFX;
  VentPTRAttrs: TSoundAttrs = (0, 0, 0);

  VentChannelFX: array [0 .. 1] of TChannelFX;
  VentAttrs: TSoundAttrs = (0, 0, 0);
  XVentAttrs: TSoundAttrs = (0, 0, 0);

  // Ezda
  EzdaChannelFX: TChannelFX;
  EzdaAttrs: TSoundAttrs = (0, 0, 0);

  // Shum
  ShumChannelFX: TChannelFX;
  ShumAttrs: TSoundAttrs = (0, 0, 0);

  // Perestuk
  PerestukChannelFX: array of TChannelFX;
  PerestukAttrs: TSoundAttrs = (0, 0, 0);
  PerestukStack: array of array [TPerestukStackAttr] of Integer;
  PerestukStackSize: Integer;
  AxesDistancesLoco: array of Integer = [3200, 4700, 3200, 5820, 3200, 4700, 3200, 3010];
  AxesDistancesWagon: array of Integer = [2570, 2400, 15600, 2400];
  AxesLocoAmount: Integer;
  AxesAmount: Integer;

  // Brake slipp + scr
  BrakeChannelFX: TChannelFX;
  BrakeAttrs: TSoundAttrs = (0, 0, 0);
  BrakeScrChannelFX: TChannelFX;
  BrakeScrAttrs: TSoundAttrs = (0, 0, 0);

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

  // Cab clicks
  CabinClicksChannel: Cardinal;
  ClickAttrs: TSoundAttrs = (0, 0, 0);

  // KM-Revers
  KMKey: Char;
  PrevKMKey: Char;
  ReversKey: Char;
  PrevReversKey: Char;

  // ЭПК
  PrevEPKKey: Byte;

implementation

uses StrUtils, Variants;

{$R *.dfm}

const
  DEFAULT_FLAG = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DECODE_FLAG = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};

  /// /////////////////////////////////////////////////////////////////////////////

  // ------------------------------------------------------------------------------//
  // Нажатие на чекбокс перестука локомотива                                       //
  // ------------------------------------------------------------------------------//
procedure TFormMain.cbLocPerestukClick(Sender: TObject);
// Нажатие на "Перестук локомотива"
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

// ------------------------------------------------------------------------------//
// Нажатие на чекбокс "Звуки ТЭД-ов и дизеля"                                    //
// ------------------------------------------------------------------------------//
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

// ------------------------------------------------------------------------------//
// Подпрограмма для обновления имени используемой САВП                           //
// ------------------------------------------------------------------------------//
procedure TFormMain.UpdateInfoName();
begin
  if (cbSAUTSounds.Checked = False) and (cbSAVPESounds.Checked = False) and (cbUSAVPSounds.Checked = False) and
    (cbGSAUTSounds.Checked = False) then
    SAVPName := '';
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "САУТ"                          //
// ------------------------------------------------------------------------------//
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

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "ПРС РЖД"                       //
// ------------------------------------------------------------------------------//
procedure TFormMain.cbPRS_RZDClick(Sender: TObject);
begin
  if (cbPRS_RZD.Checked = False) and (cbPRS_UZ.Checked = False) then
  begin
    BASS_ChannelStop(PRSChannel);
    BASS_StreamFree(PRSChannel);
    timerPRSswitcher.Enabled := False;
  end;
  if (cbPRS_RZD.Checked = True) or (cbPRS_UZ.Checked = True) then
    timerPRSswitcher.Enabled := True;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "УСАВПП"                        //
// ------------------------------------------------------------------------------//
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

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "Грузовой САУТ"                 //
// ------------------------------------------------------------------------------//
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

// === Нажатие на чекбокс "Звук КЛУБ-у" === //
procedure TFormMain.cbKLUBSoundsClick(Sender: TObject);
begin
  if cbKLUBSounds.Checked = True then
  begin
    cb3SL2mSounds.Checked := False
  end
  else
  begin
    BASS_ChannelStop(Ogr_Speed_KLUB);
    BASS_StreamFree(Ogr_Speed_KLUB);
    isPlayOgrSpKlub := 0;
  end;
end;

// === Нажатие на чекбокс "Звуки 3СЛ2м" === //
procedure TFormMain.cb3SL2mSoundsClick(Sender: TObject);
begin
  if cb3SL2mSounds.Checked = True then
    cbKLUBSounds.Checked := False
  else
  begin
    BASS_ChannelStop(ClockChannel);
    BASS_StreamFree(ClockChannel);
  end;
end;

// === Нажатие на чекбокс "Звук встречного поезда" === //
procedure TFormMain.cbHeadTrainSoundClick(Sender: TObject);
begin
  if cbHeadTrainSound.Checked = False then
  begin
    BASS_ChannelStop(Vstrech);
    BASS_StreamFree(Vstrech);
  end;
end;

procedure TFormMain.Button3Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'explore', PChar(ExtractFilePath(application.ExeName) + 'TWS/БАТНИКИ/'), nil, nil,
    SW_SHOWNORMAL);
end;

// === Нажатие на чекбокс "Звук трения колодок при торможении" === //
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

// === Нажатие на чекбокс "Звуки окружения" ===
procedure TFormMain.cbNatureSoundsClick(Sender: TObject);
begin
  if cbNatureSounds.Checked = False then
  begin
    BASS_ChannelStop(Rain_Channel);
    BASS_StreamFree(Rain_Channel);
    BASS_ChannelStop(Stochist_Channel);
    BASS_StreamFree(Stochist_Channel);
    BASS_ChannelStop(StochistUdar_Channel);
    BASS_StreamFree(StochistUdar_Channel);
  end
  else
  begin
    PrevRain := 0;
  end;
end;

// === Нажатие на чекбокс "Звуки вспомогательных машин" === //
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

    freeChannel(Compressor_Channel);
    freeChannel(VentChannelFX[0]);
    freeChannel(VentChannelFX[1]);
    freeChannel(VentTD_Channel);
    freeChannel(VentCycleTD_Channel);
    freeChannel(XVentTD_Channel);
    freeChannel(XVentCycleTD_Channel);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////////

// ------------------------------------------------------------------------------//
// Подпрограмма Закрытие программы                                               //
// ------------------------------------------------------------------------------//
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

// ------------------------------------------------------------------------------//
// Подпрограмма Открытие программы                                               //
// ------------------------------------------------------------------------------//
procedure TFormMain.FormCreate(Sender: TObject);
begin
  // if CheckInstallation=False then Application.Terminate; // Проверка правильно-ли установлена программа
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
  isPlayPRS := True; // Запрещаем проигрывать поездную радиостанцию
  isPlayRain := True;
  isSpeedLimitRouteLoad := False;
  isPlayCompressorCycle := True;
  isRefreshLocalData := True;
  // При запуске обновляем все данные нужные для функционирования программы
  isPlaySAVPEZvonok := True;
  isPlayStochist := True;
  isPlayBeltPool := True;

  Log_.DebugLogStart(Self);
  Log_.DebugWriteErrorToErrorList('TWS started');

  PerehodDIZStep := 0.01;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "Ручной режим" САВПЭ            //
// ------------------------------------------------------------------------------//
procedure TFormMain.RB_HandEKModeClick(Sender: TObject);
begin
  WagF := '';
  cbSAVPE_Marketing.Enabled := False;
  GroupBox5.Enabled := False;
  Edit1.Enabled := False;
  Edit1.Color := clInactiveCaption;
  ComboBox2Change(FormMain);
end;

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

function GetFileCount(Dir: string): Integer;
var
  fs: TSearchRec;
  pics: Integer;
begin
  pics := 0;
  if FindFirst(Dir + '/*.res', faAnyFile, fs) = 0 then
    repeat
      inc(pics);
    until FindNext(fs) <> 0;
  FindClose(fs);

  Result := pics - 1;
end;

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

procedure PlayMemoryStreamFromFile(SoundFileName: String; var ChannelName: Cardinal;
  var MemoryStreamName: TMemoryStream; StopChannel: Boolean);
var
  fs: TFileStream;
begin
  if StopChannel = True then
  begin
    BASS_ChannelStop(ChannelName);
    BASS_StreamFree(ChannelName);
  end;
  try
    MemoryStreamName.Free;
  except
  end;
  MemoryStreamName := TMemoryStream.Create;
  fs := TFileStream.Create(SoundFileName, fmShareDenyNone);
  MemoryStreamName.LoadFromStream(fs);
  fs.Free;
  MemoryStreamName.Free;
end;

function CameraInCabinCheck(CameraX: Integer; Camera: Byte): Boolean;
begin
  Result := False;
  if Camera = 0 then
    if ((CameraX <= 49130) and (CameraX >= 32000)) or (CameraX < 16384) or (CameraX = 0) then
      Result := True;
end;

// === Процедура для получения границ станций из файла start_kilometers === //
procedure GetStationsBordersFromFile(FileName: String);
var
  fs: TFileStream;
  FileText: String;
  FileLinesList: TStringList;
  StationsList: TStringList;
  I: Integer;
begin
  fs := TFileStream.Create(FileName, fmShareDenyNone);
  FileText := GetStringFromFileStream(fs);
  fs.Free();
  FileLinesList := ExtractWord(FileText, #13);
  StationCount := FileLinesList.Count;
  for I := 0 to StationCount - 1 do
  begin
    StationsList := ExtractWord(FileLinesList[I], ' ');
    if StationsList.Count >= 3 then
    begin
      try
        StationTrack1[I] := StrToInt(StationsList[1]);
        StationTrack2[I] := StrToInt(StationsList[2]);
      except
      end;
    end;
  end;
  StationsList.Free();
  FileLinesList.Free();
end;

// ------------------------------------------------------------------------------//
// Основной цикл                                                                 //
// ------------------------------------------------------------------------------//
procedure TFormMain.ClockMainTimer(Sender: TObject);
var
  St: String;
  sl: TStringList;
  I, J: Integer;
  Station1, Station2: String;
  SR: TSearchRec;
  VentTimeLeft: Single;
  XVentTimeLeft: Single;
  VentTDTimeLeft: Single;
  XVentTDTimeLeft: Single;
  CompTimeLeft: Single;
  XCompTimeLeft: Single;
  brake254TimerCoeff: Double;
  rbFile: String;
  SpeedSmoothed: Double;
label
  Next1;
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

      // ПОЛУЧЕНИЕ ДАННЫХ С Settings.ini
      if isRefreshLocalData then
      begin
        isSpeedLimitRouteLoad := False;
        PrevSpeed := 0;

        try
          InitializeStartParams(VersionID);
          GetStartSettingParamsFromRAM();
          InitializeLoco(LocoGlobal);
        except
        end;

        if cbLocPerestuk.Checked then
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
            sl := TStringList.Create;
            for I := 0 to Memo1.Lines.Count - 1 do
            begin
              try
                St := Memo1.Lines[I];
                if St[1] <> ';' then
                begin
                  ExtractStrings([#9], [' '], PChar(St), sl);
                  ConsistLength := ConsistLength + StrToFloat(sl[2]);
                end;
              except
              end;
            end;
            sl.Free;
            ConsistLength := ConsistLength + 18 * LocoSectionsAmount;
          end
          else
          begin
            if Freight = 1 then
              ConsistLength := 14 * WagonsAmount + 18 * LocoSectionsAmount
            else
              ConsistLength := 25 * WagonsAmount + 18 * LocoSectionsAmount;
          end;

          if Freight = 1 then
            RadioButton2.Checked := True
          else
            RadioButton1.Checked := True;
          // Автовыбор типа вагонов для их перестука
          if Naprav = '1' then
            Naprav := 'Tuda'
          else
            Naprav := 'Obratno';

          // RefreshMVPSType();

          // Сверяем локомотивы и приравниваем их звуки
          // if Loco = 'ED9M' then
          // Loco := 'ED4M'
          // else if Loco = 'M62' then
          // Loco := '2TE10U'
          // else if Loco = 'CHS4' then
          // Loco := 'CHS4T'
          // else if Loco = 'TEP70bs' then
          // Loco := 'TEP70';
        except
        end;

        if scSAVPOverrideRouteEK = False then
          Load_TWS_SAVP_EK();

        if isRefreshLocalData then
          isRefreshLocalData := False;
      end;

      // Smoothed speed
      SpeedSmoothed := SpeedSmoothed + 0.0055 * Acceleretion * FormMain.ClockMain.Interval;
      if (Abs(SpeedSmoothed - Speed) > 1) or (Speed = 0) and (Acceleretion = 0) then
        SpeedSmoothed := Speed;

      // lnSpeed
      var
      lnSpeed := Ln(SpeedSmoothed + 1);

      isCameraInCabin := CameraInCabinCheck(CameraX, Camera);

      if NapravOrdinata = 'Tuda' then
        OrdinataEstimate := OrdinataEstimate + (Speed / 3600 * MainCycleFreq)
      else
        OrdinataEstimate := OrdinataEstimate - (Speed / 3600 * MainCycleFreq);

      // ТЭДы
      if cbTEDs.Checked and LocoWithTED then
      begin
        if TEDAmperage <> 0 then
          TEDAttrs[VOLUME] := TEDAmperage
        else if EDTAmperage <> 0 then
          TEDAttrs[VOLUME] := EDTAmperage
        else
          TEDAttrs[VOLUME] := 0.0;
        TEDAttrs[VOLUME] := Ln(0.25 * TEDAttrs[VOLUME] / UltimateTEDAmperage + 1) * 0.01 * trcBarTedsVol.Position;

        if (TEDAmperage <> 0) or (EDTAmperage <> 0) then
        begin
          if checkChannel(TEDChannelsFX[0], False) and checkChannel(TEDChannelsFX[1], False) then
          begin
            restartChannel(TEDChannelsFX[0], TEDFile, TEDAttrs, BASS_SAMPLE_LOOP);
            restartChannel(TEDChannelsFX[1], TEDFile, TEDAttrs, BASS_SAMPLE_LOOP);
          end;

          // if TEDAttrs[PITCH] > TEDPitchDest then
          // TEDAttrs[PITCH] := TEDAttrs[PITCH] - 0.005 * MainCycleFreq;
          // if TEDAttrs[PITCH] < TEDPitchDest then
          // TEDAttrs[PITCH] := TEDAttrs[PITCH] + 0.005 * MainCycleFreq;

          setChannelAttributes(TEDChannelsFX[0], TEDAttrs);
          setChannelAttributes(TEDChannelsFX[1], TEDAttrs);
        end
        else
        begin
          freeChannel(TEDChannelsFX[0]);
          freeChannel(TEDChannelsFX[1]);
        end;

        if SpeedSmoothed > 0 then
        begin
          ReduktorAttrs[VOLUME] := 0.01 * trcBarTedsVol.Position *
            Ln(SpeedSmoothed * (0.005 + power(TEDAmperage / UltimateTEDAmperage, 2)) + 1);
          ReduktorAttrs[PITCH] := 6 * Ln(SpeedSmoothed) - 20;

          if checkChannel(reduktorChannelFX, False) then
            restartChannel(reduktorChannelFX, ReduktorFile, ReduktorAttrs, BASS_SAMPLE_LOOP);
          setChannelAttributes(reduktorChannelFX, ReduktorAttrs);
        end
        else
          freeChannel(reduktorChannelFX);

        if TedNow <> PrevKMPos1 then
          PrevKMPos1 := TedNow;
      end;

      // БЛОК ЗВУКОВ ОКРУЖЕНИЯ
      if cbNatureSounds.Checked = True then
      begin
        if Winter = 0 then
        begin
          if Rain >= 80 then
            Rain := Trunc(Rain / 80)
          else if Rain > 0 then
            Rain := 1;
          if Rain <> PrevRain then
          begin
            Case Rain Of
              1:
                RainF := PChar('TWS/storm.wav');
              2:
                RainF := PChar('TWS/storm1.wav');
              3:
                RainF := PChar('TWS/storm2.wav');
            end;
            isPlayRain := False;
          end;
          if Track = 0 then
            Rain := 0;
          if Rain = 0 then
          begin
            BASS_ChannelStop(Rain_Channel);
            BASS_StreamFree(Rain_Channel);
          end;
        end
        else
        begin
          if OutsideLocoStatus <> 0 then
          begin
            if GetAsyncKeyState(37) + GetAsyncKeyState(39) <> 0 then
            begin
              WalkSoundF := PChar('TWS/snow_walk.wav');
              isPlayWalkSound := True;
            end
            else
            begin
              if BASS_ChannelIsActive(WalkSoundChannel) <> 0 then
                freeChannel(WalkSoundChannel);
            end;
          end;
        end;

        // Стеклоочистители, звуки
        if Stochist <> Prev_Stochist then
        begin
          if Stochist = 4 then
          begin
            StochistF := PChar('TWS/stochist.wav');
            isPlayStochist := False
          end
          else
          begin
            if Stochist = 8 then
            begin
              StochistF := PChar('TWS/stochist2.wav');
              isPlayStochist := False
            end
            else
              freeChannel(Stochist_Channel);
          end;
        end;
        // Если скорость стеклоочестителей 2-ая, то делаем звук удара об края стекла
        if (Stochist = 8) and ((StochistDGR > 120) and (Prev_StchstDGR <= 120)) or
          ((StochistDGR < 55) and (Prev_StchstDGR >= 55)) then
          isPlayStochistUdar := False;
      end;

      // КЛУБ-3СЛ2М
      if isConnectedMemory then
      begin
        // КЛУБ
        if cbKLUBSounds.Checked then
        begin
          // Нажатие РБ и РБС
          if (RB <> PrevRB) or (RBS <> PrevRBS) then
            restartChannel(RB_Channel, PChar('TWS/KLUB_pick.wav'), SoundAttrsDefault);

          // Пиканья при ограничении
          if (OgrSpeed - Speed <= 3) and (isPlayOgrSpKlub = 0) and (OgrSpeed <> 0) and (Svetofor <> 0) then
            isPlayOgrSpKlub := 1;
          if ((OgrSpeed - Speed > 3) and (isPlayOgrSpKlub = -1)) or ((OgrSpeed = 0) and (isPlayOgrSpKlub = -1)) then
          begin
            freeChannel(Ogr_Speed_KLUB);
            isPlayOgrSpKlub := 0;
          end;
          if ((GetAsyncKeyState(9) <> 0) and (PrevKeyTAB = 0)) then
          begin
            isPlayBeltPool := False;
            PrevKeyTAB := 1;
          end;
          if GetAsyncKeyState(9) = 0 then
          begin
            PrevKeyTAB := 0;
            freeChannel(BeltPool_Channel);
          end;

          // Проверка бдительности
          if (PrevVCheck <> VCheck) and (VCheck = 1) then
          begin
            SoundAttrsDefault[VOLUME] := 0.01 * trcBarLocoClicksVol.Position;
            restartChannel(Vigilance_Check_Channel, PChar('TWS/KLUB_beep.mp3'), SoundAttrsDefault, DEFAULT_FLAG);
          end;

          if NextOgrPeekStatus = 0 then
          begin
            if PrevOgrSpeed > OgrSpeed then
            begin
              if NextOgrSpeed <> 0 then
              begin
                SoundAttrsDefault[VOLUME] := 0.01 * trcBarLocoClicksVol.Position;
                restartChannel(Vigilance_Check_Channel, PChar('TWS/KLUB_beep.mp3'), SoundAttrsDefault, DEFAULT_FLAG);
                NextOgrPeekStatus := 1;
              end;
            end;
          end;
          if NextOgrPeekStatus = 1 then
            if (NextOgrSpeed <> PrevNextOgrSpeed) or (NextOgrSpeed = 0) then
              NextOgrPeekStatus := 0;
        end;

        // 3СЛ2м
        if cb3SL2mSounds.Checked then
        begin
          if RB <> PrevRB then
          begin
            if RB = 1 then
              rbFile := 'TWS/RB_MexDown.wav'
            else if RB = 0 then
              rbFile := 'TWS/RB_MexUp.wav';
          end;

          if RBS <> PrevRBS then
          begin
            if RBS = 1 then
              rbFile := 'TWS/RB_MexDown.wav'
            else if RBS = 0 then
              rbFile := 'TWS/RB_MexUp.wav';
          end;

          if rbFile <> '' then
            restartChannel(RB_Channel, PChar(rbFile), SoundAttrsDefault);

          // Звук протяжки ленты по нажатию кл. <TAB>
          if GetAsyncKeyState(9) <> 0 then
          begin
            if (PrevKeyTAB = 0) and (GetAsyncKeyState(56) = 0) then
            begin
              isPlayBeltPool := False;
              PrevKeyTAB := 1;
            end;
          end
          else
          begin
            PrevKeyTAB := 0;
            freeChannel(BeltPool_Channel);
          end;

          // 3СЛ2м
          if (Speed <= 0) and (PrevSpeed_Fakt > 0) or (Speed > 1) and (PrevSpeed_Fakt = 1) or (Speed > 2) and
            (PrevSpeed_Fakt = 2) or (BASS_ChannelIsActive(ClockChannel) = 0) then
          begin
            var
            clockPath := 'TWS/Devices/3SL2M/';
            var
              clockVolume: Double := 0;

            if Speed <= 0 then
              clockPath := clockPath + 'clock.wav'
            else if (Speed > 0) and (Speed <= 2) and (PrevSpeed_Fakt > 0) then
              clockPath := clockPath + 'start.wav'
            else if Speed > 2 then
              clockPath := clockPath + 'loop.wav';

            if Camera = 0 then
              clockVolume := 0.01 * trcBarLocoClicksVol.Position;

            BASS_ChannelStop(ClockChannel);
            BASS_StreamFree(ClockChannel);

            ClockChannel := BASS_StreamCreateFile(False, PChar(clockPath), 0, 0, BASS_SAMPLE_LOOP);
            BASS_ChannelSetAttribute(ClockChannel, BASS_ATTRIB_VOL, clockVolume);

            BASS_ChannelPlay(ClockChannel, True);
          end;

          if (PrevConMem = True) and (isConnectedMemory = False) then
          begin
            BASS_ChannelStop(ClockChannel);
            BASS_StreamFree(ClockChannel);
          end;
        end;
      end;

      // БЛОК МНОГОСТРАДАЛЬНОГО ВСТРЕЧНОГО ПОЕЗДА
      if (cbHeadTrainSound.Checked = True) and (VstrTrack <> 0) then
      begin
        try
          if VstrechStatus <> PrevVstrechStatus then
          begin
            isVstrechDrive := True;
            VstrechStatusCounter := 0;
          end;
          var
          isCondition := Track - VstrTrack > Trunc(WagNum_Vstr * Vstrecha_dlina / WagNum_Vstr / TrackLength);
          if isVstrechDrive = True then
          begin
            if (isCondition) then
              isVstrechDrive := False;
            if VstrechStatus = PrevVstrechStatus then
              inc(VstrechStatusCounter);
            if VstrechStatusCounter >= 40 then
              isVstrechDrive := False;
          end;
          if (Naprav = 'Tuda') and (PrevVstrTrack < VstrTrack) Or (Naprav = 'Obratno') and (PrevVstrTrack > VstrTrack)
          then
            HeadTrainEndOfTrain := False;
          if (BASS_ChannelIsActive(Vstrech) = 0) and (isVstrechDrive = True) and (HeadTrainEndOfTrain = False) then
          begin
            var
            isNearby := (Track >= VstrTrack) and (Naprav = 'Tuda') and (MP <> 1) or (Track <= VstrTrack) and
              (Naprav = 'Obratno') and (MP <> 1) or (Track >= VstrTrack) and (Naprav = 'Tuda') and (MP = 1) and
              (Vstr_Speed > 40) or (Track <= VstrTrack) and (Naprav = 'Obratno') and (MP = 1) and (Vstr_Speed > 40);
            if isNearby then
            begin
              isPlayVstrech := False;
              Track_Vstrechi := Track;
              if WagNum_Vstr <= 23 then
                VstrechF := PChar('TWS/Pass_vstrech.wav')
              else
                VstrechF := PChar('TWS/Freight_vstrech.wav');
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

      // СВИСТОК-ТИФОН
      if cbSignalsSounds.Checked then
      begin
        if Svistok = 1 then
        begin
          if checkChannel(SvistokCycleChannel, False) then
          begin
            var
            pathStart := LocoWorkDir;
            var
            pathLoop := LocoWorkDir;

            if isCameraInCabin = True then
            begin
              pathStart := pathStart + LocoSvistokF + '_start.wav';
              pathLoop := pathLoop + LocoSvistokF + '_loop.wav';
            end
            else
            begin
              pathStart := pathStart + 'x_' + LocoSvistokF + '_start.wav';
              pathLoop := pathLoop + 'x_' + LocoSvistokF + '_loop.wav';
            end;

            TWS_PlaySvistok(pathStart);
            TWS_PlaySvistokCycle(pathLoop);
          end;
        end
        else if checkChannel(SvistokCycleChannel) then
        begin
          var
          pathStop := LocoWorkDir;

          BASS_ChannelStop(SvistokCycleChannel);
          BASS_StreamFree(SvistokCycleChannel);

          if isCameraInCabin = True then
            pathStop := pathStop + LocoSvistokF + '_stop.wav'
          else
            pathStop := pathStop + 'x_' + LocoSvistokF + '_stop.wav';

          TWS_PlaySvistok(pathStop)
        end;

        if Tifon = 1 then
        begin
          if BASS_ChannelIsActive(TifonCycleChannel) = 0 then
          begin
            var
            pathStart := LocoWorkDir;
            var
            pathLoop := LocoWorkDir;

            if isCameraInCabin = True then
            begin
              pathStart := pathStart + LocoHornF + '_start.wav';
              pathLoop := pathLoop + LocoHornF + '_loop.wav';
            end
            else
            begin
              pathStart := pathStart + 'x_' + LocoHornF + '_start.wav';
              pathLoop := pathLoop + 'x_' + LocoHornF + '_loop.wav';
            end;

            TWS_PlayTifon(pathStart);
            TWS_PlayTifonCycle(pathLoop);
          end;
        end
        else if BASS_ChannelIsActive(TifonCycleChannel) <> 0 then
        begin
          var
          pathStop := LocoWorkDir;

          freeChannel(TifonCycleChannel);

          if isCameraInCabin = True then
            pathStop := pathStop + LocoHornF + '_stop.wav'
          else
            pathStop := pathStop + 'x_' + LocoHornF + '_stop.wav';

          TWS_PlayTifon(pathStop)
        end;
      end;

      // ВСПОМ-МАШИНЫ
      if cbVspomMash.Checked then
      begin
        // Остаток времени для запуска вентиляторов ТД
        if AnsiCompareText(VentCycleTDF, '') <> 0 then
        begin
          try
            VentTDTimeLeft := BASS_ChannelBytes2Seconds(VentTD_Channel_FX, BASS_ChannelGetLength(VentTD_Channel_FX,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(VentTD_Channel_FX, BASS_POS_BYTE));
          except
          end;
          if (VentTDTimeLeft <= 0.8) and (BASS_ChannelIsActive(VentCycleTD_Channel_FX) = 0) then
            isPlayCycleVentTD := False;
        end;
        if AnsiCompareText(XVentCycleTDF, '') <> 0 then
        begin
          try
            XVentTDTimeLeft := BASS_ChannelBytes2Seconds(XVentTD_Channel_FX, BASS_ChannelGetLength(XVentTD_Channel_FX,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(XVentTD_Channel_FX, BASS_POS_BYTE));
          except
          end;
          if (XVentTDTimeLeft <= 0.8) and (BASS_ChannelIsActive(XVentCycleTD_Channel_FX) = 0) then
            isPlayCycleVentTDX := False;
        end;

        // Остановка цикла работы вентиляторов при полной остановке работы вентиляторов
        if (AnsiCompareText(VentCycleTDF, '') = 0) and (LocoGlobal <> 'VL80t') then
        begin
          try
            VentTDTimeLeft := BASS_ChannelBytes2Seconds(VentTD_Channel_FX, BASS_ChannelGetPosition(VentTD_Channel_FX,
              BASS_POS_BYTE));
          except
          end;
          if (VentTDTimeLeft >= 0.3) and (BASS_ChannelIsActive(VentCycleTD_Channel_FX) <> 0) then
          begin
            BASS_ChannelStop(VentCycleTD_Channel_FX);
            BASS_StreamFree(VentCycleTD_Channel_FX);
          end;
        end;
        if (AnsiCompareText(XVentCycleTDF, '') = 0) and (LocoGlobal <> 'VL80t') then
        begin
          try
            XVentTDTimeLeft := BASS_ChannelBytes2Seconds(XVentTD_Channel_FX, BASS_ChannelGetPosition(XVentTD_Channel_FX,
              BASS_POS_BYTE));
          except
          end;
          if (XVentTDTimeLeft >= 0.3) and (BASS_ChannelIsActive(XVentCycleTD_Channel_FX) <> 0) then
          begin
            BASS_ChannelStop(XVentCycleTD_Channel_FX);
            BASS_StreamFree(XVentCycleTD_Channel_FX);
          end;
        end;

        if (LocoGlobal = 'CHS7') Or (LocoGlobal = 'CHS8') Or (LocoGlobal = 'CHS4t') then
        begin
          VentPTRAttrs[VOLUME] := 0.01 * trcBarVspomMahVol.Position;

          // Задаём громкость звуков работы вентиляторов (ПТР) //
          if isCameraInCabin and (Camera = 0) then
          begin
            BASS_ChannelSetAttribute(VentTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
            BASS_ChannelSetAttribute(VentCycleTD_Channel_FX, BASS_ATTRIB_VOL, VentTDVol);
            BASS_ChannelSetAttribute(XVentTD_Channel_FX, BASS_ATTRIB_VOL, 0);
            BASS_ChannelSetAttribute(XVentCycleTD_Channel_FX, BASS_ATTRIB_VOL, 0);
          end
          else
          begin
            BASS_ChannelSetAttribute(VentTD_Channel, BASS_ATTRIB_VOL, 0);
            BASS_ChannelSetAttribute(VentCycleTD_Channel, BASS_ATTRIB_VOL, 0);
            BASS_ChannelSetAttribute(XVentTD_Channel, BASS_ATTRIB_VOL, VentTDVol);
            BASS_ChannelSetAttribute(XVentCycleTD_Channel, BASS_ATTRIB_VOL, VentTDVol);
          end;
        end;

        if AnsiCompareStr(CompressorCycleF, '') <> 0 then
        begin
          try
            CompTimeLeft := BASS_ChannelBytes2Seconds(Compressor_Channel, BASS_ChannelGetLength(Compressor_Channel,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(Compressor_Channel, BASS_POS_BYTE));
          except
          end;
          if (CompTimeLeft <= 0.8) and (BASS_ChannelIsActive(CompressorCycleChannel) = 0) then
            isPlayCompressorCycle := False;
        end;
        if AnsiCompareStr(XCompressorCycleF, '') <> 0 then
        begin
          try
            XCompTimeLeft := BASS_ChannelBytes2Seconds(XCompressor_Channel, BASS_ChannelGetLength(XCompressor_Channel,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(XCompressor_Channel, BASS_POS_BYTE));
          except
          end;
          if (XCompTimeLeft <= 0.8) and (BASS_ChannelIsActive(XCompressorCycleChannel) = 0) then
            isPlayXCompressorCycle := False;
        end;

        // Звуки запуска компрессора
        if Compressor <> Prev_Compressor then
        begin
          if Compressor <> 0 then
          begin
            isPlayCompressor := False;
            isPlayXCompressor := False;
          end;
          // Звуки остановки компрессора
          if Compressor = 0 then
          begin
            CompressorCycleF := PChar('');
            XCompressorCycleF := PChar('');
            isPlayCompressor := False;
            isPlayXCompressor := False;
          end;
        end;

        var
          ventFile: String;
        if (Vent = 1) and checkChannel(VentChannelFX[0], False) then
        begin
          ventFile := LocoWorkDir + 'mv-start.wav';
          VentAttrs[VOLUME] := 0;
          restartChannel(VentChannelFX[0], ventFile, VentAttrs);
        end
        else if (Vent = 0) and checkChannel(VentChannelFX[0]) then
        begin
          ventFile := LocoWorkDir + 'mv-stop.wav';
          restartChannel(VentChannelFX[0], ventFile, VentAttrs);
        end
        else if (Vent = 1) and checkChannel(VentChannelFX[0], False) and (ventFile = LocoWorkDir + 'mv-start.wav') then
        begin
          ventFile := LocoWorkDir + 'mv-loop.wav';
          restartChannel(VentChannelFX[0], ventFile, VentAttrs, BASS_SAMPLE_LOOP);
          restartChannel(VentChannelFX[1], 'x_' + ventFile, XVentAttrs, BASS_SAMPLE_LOOP);
        end;

        // TWS_MVPitchRegulation();
      end;

      // ТП
      if cbTPSounds.Checked then
      begin
        if LocoWithSndTP then
        begin
          var
            frontTPFile: String;
          var
            backTPFile: String;

            // ПЕРЕДНИЙ
          if (FrontTP = 63) and (FrontTP <> PrevFrontTP) then
            frontTPFile := 'TWS/TPUp.wav'
          else if (FrontTP <> 63) and (PrevFrontTP = 63) and (PrevFrontTP <> 188) then
            frontTPFile := 'TWS/TPDown.wav';

          if frontTPFile <> '' then
          begin
            restartChannel(TPChannel[0], frontTPFile, SoundAttrsDefault);
            BASS_ChannelSetAttribute(TPChannel[0], BASS_ATTRIB_VOL, 0.01 * trcBarVspomMahVol.Position);
          end;

          // ЗАДНИЙ
          if (BackTP = 63) and (BackTP <> PrevBackTP) then
            backTPFile := 'TWS/TPUp.wav'
          else if (BackTP <> 63) and (PrevBackTP = 63) and (PrevBackTP <> 188) then
            backTPFile := 'TWS/TPDown.wav';

          if backTPFile <> '' then
          begin
            restartChannel(TPChannel[1], backTPFile, SoundAttrsDefault);
            BASS_ChannelSetAttribute(TPChannel[1], BASS_ATTRIB_VOL, 0.003 * trcBarVspomMahVol.Position);
          end;
        end;
      end;

      // ЩЕЛЧКИ
      if cbCabinClicks.Checked then
      begin
        var
        clickFile := '';
        ClickAttrs[VOLUME] := 0.01 * trcBarLocoClicksVol.Position;

        // 254 / 395
        if (KM_395 <> PrevKM_395) and (KM_395 <> 1) and (KM_395 <> 6) then
          clickFile := 'TWS/stuk395.wav';
        if (KM_294 <> PrevKM_294) and (KM_294 <> -1) and (PrevKM_294 <> -1) then
          clickFile := 'TWS/stuk254.wav';

        PrevKM_395 := KM_395;
        PrevKM_294 := KM_294;

        // ЭПК
        var
          EPKKey: Byte;
        if GetAsyncKeyState(78) <> 0 then
          if GetAsyncKeyState(16) <> 0 then
            EPKKey := 2
          else
            EPKKey := 1;
        if (PrevEPKKey <> EPKKey) and (EPKKey <> 0) then
        begin
          clickFile := 'TWS/epk.wav';
          PrevEPKKey := EPKKey;
        end;

        var
          rbVolume: Double := 0.01 * trcBarLocoClicksVol.Position;
        if Camera <> 0 then
          rbVolume := 0;
        BASS_ChannelSetAttribute(RB_Channel, BASS_ATTRIB_VOL, rbVolume);

        // ЭМЗ
        if ((Prev_KMAbs = 0) and (KMPos1 > 0)) or ((KMPos1 = 0) and (Prev_KMAbs > 0)) or (PrevReostat + Reostat = 1)
        then
          clickFile := 'TWS/Devices/21KR/EM_zashelka.wav';

        // РЕЛЕ НАПРЯЖЕНИЯ
        if (PrevVoltage = 0) and (Voltage <> 0) then
          clickFile := 'TWS/CHS7/rn.wav';

        // РЕВЕРСИВКА
        if LocoWithSndReversor then
        begin
          if GetAsyncKeyState(87) <> 0 then
            ReversKey := 'W'
          else if GetAsyncKeyState(83) <> 0 then
            ReversKey := 'S';
          if (LocoSndReversorType = 1) and (KMPos1 = 0) and (ReversKey <> PrevReversKey) then
            clickFile := RevPosF
          else if (LocoSndReversorType = 0) and (ReversorPos <> PrevReversorPos) then
            clickFile := RevPosF;
          PrevReversKey := ReversKey;
        end;

        // Sound
        if clickFile <> '' then
          restartChannel(CabinClicksChannel, PChar(clickFile), ClickAttrs);

        // КМ
        if LocoWithSndKM and (ReversorPos <> 0) and (PrevReversorPos <> 0) then
        begin
          if (KMOP > 0) or (PrevKMOP > 0) or (GetAsyncKeyState(16) <> 0) then
          begin
            if (KMOP <> PrevKMOP) then
            begin
              if (KMOP > 0) then
                clickFile := 'op+-.wav'
              else if (KMOP = 0) and (PrevKMOP > 0) then
                clickFile := 'op_vivod.wav';
            end;

            if clickFile <> '' then
              restartChannel(CabinClicksChannel, PChar('TWS/Devices/21KR/' + clickFile), ClickAttrs);
          end
          else if KMPos1 <> PrevKMPos1 then

          begin
            KMKey := ' ';

            if GetAsyncKeyState(69) <> 0 then
              KMKey := 'E'
            else if GetAsyncKeyState(81) <> 0 then
              KMKey := 'Q'
            else
              KMKey := ' ';

            if (KMKey <> 'E') and (KMKey <> 'Q') then
            begin
              if GetAsyncKeyState(65) <> 0 then
                KMKey := 'A'
              else if (GetAsyncKeyState(68) <> 0) then
                KMKey := 'D';
            end;

            if KMKey <> PrevKMKey then
            begin
              if (KMKey = 'A') and (PrevKMKey <> 'A') or (KMKey = 'D') and (PrevKMKey <> 'D') and (PrevKMKey <> 'E')
              then
                clickFile := '0_+-.wav'
              else if (KMKey = 'E') and (PrevKMKey <> 'E') or (KMKey = 'Q') and (PrevKMKey <> 'Q') then
                clickFile := '0_+-A.wav'
              else if (PrevKMKey = 'E') and (KMKey <> ' ') or (PrevKMKey = 'Q') then
              begin
                clickFile := '+-A_0.wav';
                PrevKMKey := KMKey;
              end
              else if (KMKey = ' ') and ((PrevKMKey = 'A') or (PrevKMKey = 'D')) then
                clickFile := '+-_0.wav';

              if (PrevKMKey <> 'E') then
                PrevKMKey := KMKey;
            end;

            if clickFile <> '' then
            begin
              const
                isPrevKMKeyEQ = (PrevKMKey = 'E') or (PrevKMKey = 'Q');
              if isPrevKMKeyEQ and checkChannel(CabinClicksChannel, False) or (isPrevKMKeyEQ = False) then
                restartChannel(CabinClicksChannel, PChar('TWS/Devices/21KR/' + clickFile), ClickAttrs);
            end;
          end;
        end;
      end;

      // 254 / 395
      BrakeDelta := Abs(BrakeCylinders - PrevBrakeCylinders);
      if BrakeDelta > 0 then
      begin
        if Brake254Timer > 20 then
        begin
          isBrake254FadeIn := False;
          brake254TimerCoeff := 1;
        end
        else if isBrake254FadeIn = False then
          isBrake254FadeIn := True;

        if isBrake254FadeIn then
          brake254TimerCoeff := 0.05 * Brake254Timer + 0.0001;

        Brake254Attrs[0][VOLUME] := Ln(0.0278 * BrakeCylinders * brake254TimerCoeff * BrakeDelta + 1);
        Brake254Attrs[1][VOLUME] := 0.5 * Exp(-0.005 * power(BrakeCylinders * brake254TimerCoeff - 36, 2));
        Brake254Attrs[0][PITCH] := Brake254Attrs[0][VOLUME] - 1;
        Brake254Attrs[1][PITCH] := Brake254Attrs[0][PITCH];

        if checkChannel(Brake254ChannelFX[0], False) and checkChannel(Brake254ChannelFX[1], False) then
        begin
          restartChannel(Brake254ChannelFX[0], 'TWS/254_shipenie.wav', Brake254Attrs[0], BASS_SAMPLE_LOOP);
          restartChannel(Brake254ChannelFX[1], 'TWS/254_release.wav', Brake254Attrs[1], BASS_SAMPLE_LOOP);
        end;
      end
      else if (Brake254Timer < 0) then
      begin
        brake254TimerCoeff := 0.05 * (Brake254Timer + 20) + 0.0001;

        Brake254Attrs[0][VOLUME] := Brake254Attrs[0][VOLUME] * brake254TimerCoeff;
        Brake254Attrs[1][VOLUME] := Brake254Attrs[1][VOLUME] * brake254TimerCoeff;
        Brake254Attrs[0][PITCH] := Brake254Attrs[0][PITCH] * brake254TimerCoeff;
        Brake254Attrs[1][PITCH] := Brake254Attrs[1][PITCH] * brake254TimerCoeff;

        if Brake254Timer = -20 then
        begin
          freeChannel(Brake254ChannelFX[0]);
          freeChannel(Brake254ChannelFX[1]);
          Brake254Timer := 0;
        end;
      end;

      if checkChannel(Brake254ChannelFX[0]) or checkChannel(Brake254ChannelFX[1]) then
      begin
        setChannelAttributes(Brake254ChannelFX[0], Brake254Attrs[0]);
        setChannelAttributes(Brake254ChannelFX[1], Brake254Attrs[1]);

        if isBrake254FadeIn and (Brake254Timer <= 22) then
          Brake254Timer := Brake254Timer + 2
        else if Brake254Timer > 20 then
          isBrake254FadeIn := False;

        Brake254Timer := Brake254Timer - 1;
      end;

      // ТРЕНИЕ КОЛОДОК ПРИ ТОРМОЖЕНИИ
      if cbBrakingSounds.Checked then
      begin
        if (BrakeCylinders > 0) and (SpeedSmoothed > 0) then
        begin
          BrakeAttrs[VOLUME] := 2 * Ln(2 * BrakeCylinders / SpeedSmoothed + 1);
          BrakeAttrs[TEMPO] := SpeedSmoothed * SpeedSmoothed;

          if BrakeAttrs[VOLUME] > 0.1 then
            BrakeAttrs[VOLUME] := 0.1;

          if isCameraInCabin then
          begin
            BrakeAttrs[VOLUME] := 0.25 * BrakeAttrs[VOLUME];
            if EDTAmperage <> 0 then
              BrakeAttrs[VOLUME] := 0.25 * BrakeAttrs[VOLUME];
          end
          else if EDTAmperage <> 0 then
            BrakeAttrs[VOLUME] := 0.125 * BrakeAttrs[VOLUME];
          BrakeAttrs[TEMPO] := BrakeAttrs[VOLUME] / Ln(SpeedSmoothed + 1);

          if checkChannel(BrakeChannelFX, False) then
            restartChannel(BrakeChannelFX, 'TWS/brake_slipp.wav', BrakeAttrs, BASS_SAMPLE_LOOP);
          setChannelAttributes(BrakeScrChannelFX, BrakeAttrs);

          if SpeedSmoothed <= 3 then
          begin
            BrakeScrAttrs[VOLUME] := 1 / Ln(SpeedSmoothed + 1.1) - 0.7;
            BrakeScrAttrs[TEMPO] := 50 / (BrakeAttrs[TEMPO] + 0.1);
            if BrakeScrAttrs[VOLUME] > 0.75 then
              BrakeScrAttrs[VOLUME] := 0.75;

            if checkChannel(BrakeScrChannelFX, False) then
              restartChannel(BrakeScrChannelFX, 'TWS/brake_scr.wav', BrakeScrAttrs, BASS_SAMPLE_LOOP);
            setChannelAttributes(BrakeScrChannelFX, BrakeScrAttrs);
          end
          else
            freeChannel(BrakeScrChannelFX);
        end
        else if (BrakeCylinders <= 0) or (Speed <= 0) then
        begin
          freeChannel(BrakeChannelFX);
          freeChannel(BrakeScrChannelFX);
        end;
      end;

      // ЕЗДА
      if cbLocPerestuk.Checked then
      begin
        if (SpeedSmoothed >= 5) then
        begin
          EzdaAttrs[VOLUME] := 0.00005 * trcBarLocoPerestukVol.Position * SpeedSmoothed * Ln(SpeedSmoothed - 4);
          EzdaAttrs[TEMPO] := 10 * lnSpeed;
          EzdaAttrs[PITCH] := lnSpeed;

          if checkChannel(EzdaChannelFX, False) then
            restartChannel(EzdaChannelFX, 'TWS/' + Loco + '/ezda.wav', EzdaAttrs, BASS_SAMPLE_LOOP);
          setChannelAttributes(EzdaChannelFX, EzdaAttrs);
        end
        else if checkChannel(EzdaChannelFX) then
          freeChannel(EzdaChannelFX);

        if SpeedSmoothed >= 3 then
        begin
          ShumAttrs[VOLUME] := 0.0001 * trcBarLocoPerestukVol.Position * SpeedSmoothed * Ln(SpeedSmoothed - 2);
          ShumAttrs[TEMPO] := 10 * lnSpeed;
          ShumAttrs[PITCH] := 0.1 * lnSpeed;

          if checkChannel(ShumChannelFX, False) then
            restartChannel(ShumChannelFX, 'TWS/shum.wav', ShumAttrs, BASS_SAMPLE_LOOP);
          setChannelAttributes(ShumChannelFX, ShumAttrs);
        end
        else if checkChannel(ShumChannelFX) then
          freeChannel(ShumChannelFX);

        // ПЕРЕСТУК НА ТРЕКАХ
        // Timer
        for var k := 0 to PerestukStackSize - 1 do
          if PerestukStack[k][TIME] > 0 then
            PerestukStack[k][TIME] := PerestukStack[k][TIME] - 30;

        // LCtrl + Numpad+ or RCtrl + Numpad-
        const
          trackChangeKeyState = (GetAsyncKeyState(162) + GetAsyncKeyState(163)) *
            (GetAsyncKeyState(107) + GetAsyncKeyState(109)) = 0;

          // On joint
        if (Abs(PrevTrack - Track) > 0) and trackChangeKeyState and (PerestukStackSize < Length(PerestukStack)) then
        begin
          PerestukStack[PerestukStackSize][P_ID] := Round(random() * 2 + 1);
          inc(PerestukStackSize);
        end;

        // Sound
        if (SpeedSmoothed >= 3) and (PerestukStackSize > 0) then
        begin
          for var k := 0 to PerestukStackSize - 1 do
          begin
            const
              axisIdx = PerestukStack[k][AXIS_IDX];

            if axisIdx >= AxesAmount then
            begin
              PerestukStack[k][AXIS_IDX] := 0;
              PerestukStack[k][TIME] := 0;
              Dec(PerestukStackSize);
            end
            else if PerestukStack[k][TIME] <= 0 then
            begin
              randomize();
              var
              singlerandom := random();
              randomize();

              PerestukAttrs[VOLUME] := 0.01 * trcBarLocoPerestukVol.Position * 3 *
                Exp(-0.0005 * power(SpeedSmoothed - 60, 2)) - 0.6;
              PerestukAttrs[TEMPO] := 5 * (Exp(0.05 * SpeedSmoothed) - 1) + 5 * (singlerandom - 0.5);
              PerestukAttrs[PITCH] := Exp(0.02 * (SpeedSmoothed - 30)) - 0.4 + singlerandom - 0.5;

              // Zatuhanie
              PerestukAttrs[VOLUME] := PerestukAttrs[VOLUME] * Exp(-0.05 * axisIdx * axisIdx);
              // Echo
              PerestukAttrs[PITCH] := PerestukAttrs[PITCH] * (singlerandom + 0.5) *
                Exp(-0.005 * SpeedSmoothed * axisIdx * axisIdx);

              if PerestukAttrs[PITCH] > 55 then
                PerestukAttrs[PITCH] := 55;

              var
                nextAxisDistance: Integer;
              if axisIdx < AxesLocoAmount - 1 then
              begin
                PerestukAttrs[VOLUME] := 0.5 * (singlerandom + 1) * PerestukAttrs[VOLUME];
                PerestukAttrs[PITCH] := 0.25 * (singlerandom + 1) * PerestukAttrs[PITCH];
                nextAxisDistance := AxesDistancesLoco[axisIdx];
              end
              else if axisIdx = AxesLocoAmount - 1 then
                nextAxisDistance := AxesDistancesWagon[0] + AxesDistancesLoco[AxesLocoAmount - 1]
              else if axisIdx > AxesLocoAmount - 1 then
              begin
                var
                wagonAxisIdx := (axisIdx - AxesLocoAmount + 1) Mod Length(AxesDistancesWagon);

                if wagonAxisIdx = 0 then
                  nextAxisDistance := 2 * AxesDistancesWagon[0]
                else
                  nextAxisDistance := AxesDistancesWagon[wagonAxisIdx];
              end;

              if PerestukStackSize >= Length(PerestukChannelFX) then
                PerestukStackSize := PerestukStackSize;

              // Play
              if PerestukAttrs[VOLUME] > 0.0001 then
              begin
                for var l := 0 to Length(PerestukChannelFX) - 1 do
                begin
                  if checkChannel(PerestukChannelFX[l], False) then
                  begin
                    var
                    stukId := PerestukStack[k][P_ID];
                    if (axisIdx Mod 4 < 2) then
                      stukId := stukId Mod 3 + 1;

                    restartChannel(PerestukChannelFX[l], 'TWS/stuk' + stukId.ToString() + '.wav', PerestukAttrs);
                    Break;
                  end;
                end;
              end;

              inc(PerestukStack[k][AXIS_IDX]);
              PerestukStack[k][TIME] := Trunc(3.6 * nextAxisDistance / SpeedSmoothed);
            end;
          end;
        end;
      end;

      // Проверяем менялись-ли показания камеры?
      if (Camera <> PrevCamera) or (CameraX <> PrevCameraX) then
        VolumeMaster_RefreshVolume();

      // --- Обращение к модулю САВП, делаем "проход" --- //
      if Loco = 'CHS7' then
        CHS7__.step();
      // else if Loco = 'CHS8' then
      // CHS8__.step()
      // else if Loco = 'CHS4t' then
      // CHS4T__.step()
      // else if Loco = 'CHS4 KVR' then
      // CHS4KVR__.step()
      // else if Loco = 'VL80t' then
      // VL80T__.step()
      // else if Loco = 'EP1m' then
      // EP1M__.step()
      // else if Loco = '2ES5K' then
      // ES5K__.step();

      SAVPTick();

      SoundManagerTick();

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
      PrevDiesel2 := diesel2;
      PrevReostat := Reostat;
      Prev_SvetoforDist := SvetoforDist;
      PrevReversorPos := ReversorPos;
      PrevFazan := Fazan;
      PrevKMOP := KMOP;
      PrevRain := Rain;
      PrevVstrechStatus := VstrechStatus;
      PrevCamera := Camera;
      PrevSpeed_Fakt := Speed;
      PrevKME_ED := KME_ED;
      PrevVCheck := VCheck;
      PrevCameraX := CameraX;
      PrevTEDAmperage := TEDAmperage;
      PrevEDTAmperage := EDTAmperage;
      Prev_Compressor := Compressor;
      PrevBrakeCylinders := BrakeCylinders;
      PrevVoltage := Voltage;
      Prev_KMAbs := KMPos1;
      Prev_Stochist := Stochist;
      Prev_StchstDGR := StochistDGR;
      PrevAB_ZB_1 := AB_ZB_1;
      PrevAB_ZB_2 := AB_ZB_2;
      PrevBoks_Stat := Boks_Stat;
      PrevEPT := EPT;
      PrevRDOOR := RDOOR;
      PrevLDOOR := LDOOR;
      PrevZhaluzi := Zhaluzi;
      PrevHighLights := Highlights;
      PrevVstrTrack := VstrTrack;
      if LocoGlobal <> 'CHS4 KVR' then
        Prev_Vent := Vent
      else
      begin
        // if (Vent=0) or (Vent=143) or (Vent=194) or (Vent=204) then begin
        if (Vent = 0) or (Vent = 4113039) or (Vent = 4126146) or (Vent = 4050124) then
        begin
          if (Prev_VentLocal = Vent) then
            Prev_Vent := Vent;
        end;
        Prev_VentLocal := Vent;
      end;
      Prev_Vent2 := Vent2;
      Prev_Vent3 := Vent3;
      Prev_Vent4 := Vent4;
      PrevRB := RB;
      PrevRBS := RBS;
      if PrevOrdinata < Ordinata then
        NapravOrdinata := 'Tuda'
      else if PrevOrdinata > Ordinata then
        NapravOrdinata := 'Obratno';
      PrevOrdinata := Ordinata;
      PrevTC := TC;
      // PrevGR := GR;
      PrevVR242 := VR242;

      PrevConMem := isConnectedMemory;
    end;

  except
    // НИЧЕГО
  end;
end;

procedure PlaySvistokIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  if BASS_ChannelIsActive(SvistokCycleChannel) <> 0 then
  begin
    var
    svistokVolume := 0.01 * FormMain.trcBarSignalsVol.Position;

    if Camera = 2 then
      svistokVolume := 5 / (WagonsAmount + LocoSectionsAmount) * svistokVolume;
    BASS_ChannelSetAttribute(SvistokCycleChannel, BASS_ATTRIB_VOL, svistokVolume);
  end;
end;

procedure TFormMain.TWS_PlaySvistok(FileName: String);
begin
  try
    freeChannel(SvistokCycleChannel);
    restartChannel(SvistokCycleChannel, PChar(FileName), SoundAttrsDefault);

    var
    svistokVolume := 0.01 * FormMain.trcBarSignalsVol.Position;

    if Camera = 2 then
      svistokVolume := 5 / (WagonsAmount + LocoSectionsAmount) * svistokVolume;

    BASS_ChannelSetAttribute(SvistokChannel, BASS_ATTRIB_VOL, svistokVolume);
    BASS_ChannelSetSync(SvistokChannel, BASS_SYNC_POS, BASS_ChannelSeconds2Bytes(SvistokChannel,
      BASS_ChannelBytes2Seconds(SvistokChannel, BASS_ChannelGetLength(SvistokChannel, BASS_POS_BYTE)) - 0.05),
      @PlaySvistokIsEnd, nil);
  except
  end;
end;

procedure TFormMain.TWS_PlaySvistokCycle(FileName: String);
begin
  try
    freeChannel(SvistokCycleChannel);
    restartChannel(SvistokCycleChannel, PChar(FileName), SoundAttrsDefault, BASS_SAMPLE_LOOP);
    BASS_ChannelSetAttribute(SvistokCycleChannel, BASS_ATTRIB_VOL, 0);
  except
  end;
end;

procedure PlayTifonIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  if BASS_ChannelIsActive(TifonCycleChannel) <> 0 then
  begin
    var
    tifonVolume := 0.01 * FormMain.trcBarSignalsVol.Position;

    if Camera = 2 then
      tifonVolume := 5 / (WagonsAmount + LocoSectionsAmount) * tifonVolume;
    BASS_ChannelSetAttribute(TifonCycleChannel, BASS_ATTRIB_VOL, tifonVolume)
  end;
end;

procedure TFormMain.TWS_PlayTifon(FileName: String);
begin
  try
    freeChannel(TifonChannel);
    restartChannel(TifonChannel, PChar(FileName), SoundAttrsDefault);

    var
    tifonVolume := 0.01 * FormMain.trcBarSignalsVol.Position;

    if Camera = 2 then
      tifonVolume := 5 / (WagonsAmount + LocoSectionsAmount) * tifonVolume;

    BASS_ChannelSetAttribute(TifonChannel, BASS_ATTRIB_VOL, tifonVolume);
    BASS_ChannelSetSync(TifonChannel, BASS_SYNC_POS, BASS_ChannelSeconds2Bytes(TifonChannel,
      BASS_ChannelBytes2Seconds(TifonChannel, BASS_ChannelGetLength(TifonChannel, BASS_POS_BYTE)) - 0.05),
      @PlayTifonIsEnd, nil);
  except
  end;
end;

procedure TFormMain.TWS_PlayTifonCycle(FileName: String);
begin
  try
    freeChannel(TifonCycleChannel);
    TifonCycleChannel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, BASS_SAMPLE_LOOP);
    BASS_ChannelPlay(TifonCycleChannel, True);
    BASS_ChannelSetAttribute(TifonCycleChannel, BASS_ATTRIB_VOL, 0);
  except
  end;
end;

// ***************************************************************************************************************** //

procedure TFormMain.timerSoundSliderTimer(Sender: TObject);
var
  VentVolume: Single;
begin
  // ПЕРЕХОД МЕЖДУ ДОРОЖКАМИ ПЕРЕСТУКА ЛОКОМОТИВА //
  // if PerehodLoco = True then
  // begin
  // BASS_ChannelSetAttribute(EzdaChannelFXFX, BASS_ATTRIB_VOL, 0.01 * LocoVolume);
  // BASS_ChannelSetAttribute(EzdaChannelFXFX, BASS_ATTRIB_VOL, 0.01 * LocoVolume2);
  // Dec(LocoVolume);
  // inc(LocoVolume2);
  //
  // if LocoVolume <= 0 then
  // begin
  // BASS_ChannelStop(EzdaChannelFXFX);
  // BASS_StreamFree(EzdaChannelFXFX);
  // end;
  //
  // PerehodLoco := False;
  // end;
  // ******************************************** //
  // ******************************* //
  // ПЕРЕХОД МЕЖДУ ДОРОЖКАМИ ДИЗЕЛЕЙ //
  // if PerehodDIZ=True then begin
  // if DIZVolume>DIZVlm then DIZVolume:=DIZVlm;
  // if DIZVolume2>DIZVlm then DIZVolume2:=DIZVlm;
  // if DIZVolume<0 then DIZVolume:=0;
  // if DIZVolume2<0 then DIZVolume2:=0;
  // if ChannelNumDIZ=0 then begin
  // try BASS_ChannelGetAttribute(DIZChannel , BASS_ATTRIB_VOL, DIZVolume ); except DIZVolume:=0; end;
  // try BASS_ChannelGetAttribute(DizChannel2, BASS_ATTRIB_VOL, DIZVolume2); except DIZVolume2:=DIZVlm; end;
  // if DIZVolume  > 0      then DIZVolume  := DIZVolume  - PerehodDIZStep;
  // if DIZVolume2 < DIZVlm then DIZVolume2 := DIZVolume2 + PerehodDIZStep*2;
  // BASS_ChannelSetAttribute(DIZChannel, BASS_ATTRIB_VOL, DIZVolume);
  // BASS_ChannelSetAttribute(DIZChannel2, BASS_ATTRIB_VOL, DIZVolume2);
  // if (DIZVolume<=0) and (DIZVolume2>=DIZVlm) then begin PerehodDIZ:=False; BASS_ChannelStop(DIZChannel); BASS_StreamFree(DIZChannel); end;
  // end;
  // if ChannelNumDIZ=1 then begin
  // try BASS_ChannelGetAttribute(DIZChannel2 , BASS_ATTRIB_VOL, DIZVolume ); except DIZVolume:=0; end;
  // try BASS_ChannelGetAttribute(DIZChannel, BASS_ATTRIB_VOL, DIZVolume2); except DIZVolume2:=DIZVlm; end;
  // if DIZVolume  > 0      then DIZVolume  := DIZVolume  - PerehodDIZStep;
  // if DIZVolume2 < DIZVlm then DIZVolume2 := DIZVolume2 + PerehodDIZStep*2;
  // BASS_ChannelSetAttribute(DIZChannel2, BASS_ATTRIB_VOL, DIZVolume );
  // BASS_ChannelSetAttribute(DIZChannel , BASS_ATTRIB_VOL, DIZVolume2);
  // if (DIZVolume<=0) and (DIZVolume2>=DIZVlm) then begin PerehodDIZ:=False; BASS_ChannelStop(DIZChannel2); BASS_StreamFree(DIZChannel2); end;
  // end;
  // end;
  // ******************************* //
  // ЗАТУХАНИЕ ЗВУКА ВСТРЕЧНОГО ПОЕЗДА //
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

  // if StartVentVU then
  // begin
  // BASS_ChannelGetAttribute(VentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
  // if VentVolume < 0.01 * trcBarVspomMahVol.Position then
  // begin
  // VentVolume := VentVolume + 0.01;
  // BASS_ChannelSetAttribute(VentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
  // BASS_ChannelSetAttribute(XVentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
  // end
  // else
  // begin
  // StartVentVU := False;
  // end;
  // end;
  // ********************************* //
  // ЗАТУХАНИЕ ЗВОНКА НА ПЕРЕЕЗДЕ //
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

procedure TFormMain.timerPRSswitcherTimer(Sender: TObject);
begin
  if (cbPRS_RZD.Checked = True) or (cbPRS_UZ.Checked = True) then
    isPlayPRS := False;
  // TODO
  // Если мы на станции, то интервал радиостанции - меньше
  // if (isPlayPerestuk_OnStation = True) then
  timerPRSswitcher.Interval := 180000;
  // else
  // begin
  randomize;
  randomize;
  timerPRSswitcher.Interval := 350000 + random(150000);
  // end;
end;

// Смена громкости звуков при измене показаний любого TrackBar
procedure TFormMain.ChangeVolume(Sender: TObject);
begin
  VolumeMaster_RefreshVolume();
end;

// Таймер проверки запущеного симулятора ZDSimulator
procedure TFormMain.timerSearchSimulatorWindowTimer(Sender: TObject);
var
  I: Integer;
begin
  isConnectedMemory := FindTask('Launcher.exe');
  // Проверка запущен-ли симулятор?

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
        Break;
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
          // if I = 0 then ADDR_ZDS_EXE_LABEL:=ptr($00172C28);
          // if ReadStringFromMemory(ADDR_ZDS_EXE_LABEL,17)='DGLEngine Launcher' then
          isGameOnPause := False;
          // else
          // isGameOnPause     := True;
          CloseHandle(pHandle);
          isConnectedMemory := True;
          Label5.Caption := GameWindowName;
          if I = 2 then
          begin
            ClockMain.Enabled := False;
          end;
          Break;
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

procedure TFormMain.timerPerehodDizSwitchTimer(Sender: TObject);
begin
  timerPerehodDizSwitch.Enabled := False;
end;

// -=-=-=-=-=-=- БЛОК ВЫБОРА ПОЛЬЗОВАТЕЛЕМ ЭК САВПЭ -=-=-=-=-=-=- //
procedure TFormMain.ComboBox2Change(Sender: TObject);
begin
  // LoadSAVPE_EK('TWS/SAVPE_INFORMATOR/Info/' + ComboBox1.Items[ComboBox1.ItemIndex] + '/' +
  // ComboBox2.Items[ComboBox2.ItemIndex]);
end;

procedure TFormMain.timerDoorCloseDelayTimer(Sender: TObject);
begin
  // SAVPE_DoorCloseTimerTick();
end;

// Включение Автоматического режима работы САВПЭ на МВПС
procedure TFormMain.RB_AutoEKModeClick(Sender: TObject);
begin
  // cbSAVPE_Marketing.Enabled := True;	// Включаем галочку "проигрывать маркетинговые объявления"
  // GroupBox5.Enabled := True;	// Включаем блок настройки задержки объявления закрытия дверей
  // Edit1.Enabled := True;
  // Edit1.Color := clWindow;
  // ComboBox2Change(FormMain);
end;

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

// Метод: открытие папки с батниками
// ------------------------------------------
// На вход: ничего
// Примечания: нет
procedure TFormMain.N5Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'explore', PChar(ExtractFilePath(application.ExeName) + 'TWS/BAT_FILES/'), nil, nil,
    SW_SHOWNORMAL);
end;

// Метод: открытие файла ReadME
// ------------------------------------------
// На вход: ничего
// Примечания: нет
procedure TFormMain.ReadME1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(ExtractFilePath(application.ExeName) + 'TWS/ReadME.doc'), nil, nil, SW_SHOWNORMAL);
end;

// Метод: сохранение настроек в файл
// ------------------------------------------
// На вход: ничего
// Примечания: нет
procedure TFormMain.N3Click(Sender: TObject);
var
  saveDialog: TSaveDialog;
  // Переменная диалога сохранения
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

// Метод: загрузка настроек TWS из файла
// ------------------------------------------
// На вход: ничего
// Примечания: нет
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

// Метод: Открытие окна "АВТОРЫ"
// ------------------------------------------
// На вход: ничего
// Примечания: нет
procedure TFormMain.N6Click(Sender: TObject);
begin
  FormAuthors.Show();
end;

procedure TFormMain.N9Click(Sender: TObject);
begin
  FormSettings.Show();
end;

procedure TFormMain.N10Click(Sender: TObject);
begin
  FormDebug.Show();
end;

procedure TFormMain.btnSAVPEHelpClick(Sender: TObject);
begin
  FormSAVPEHelp.Show;
end;

procedure TFormMain.cbSignalsSoundsClick(Sender: TObject);
begin
  if cbSignalsSounds.Checked = False then
  begin
    freeChannel(SvistokChannel);
    freeChannel(SvistokCycleChannel);
    freeChannel(TifonChannel);
    freeChannel(TifonCycleChannel);
  end;
end;

procedure TFormMain.trcBarSignalsVolChange(Sender: TObject);
begin
  VolumeMaster_RefreshVolume();
end;

procedure TFormMain.timerVigilanceUSAVPDelayTimer(Sender: TObject);
begin
  timerVigilanceUSAVPDelay.Enabled := False;
  if VCheck <> 0 then
    DecodeResAndPlay('TWS/SAVP/USAVP/567.res', isPlaySAUTObjects, SAUTF, SAUTChannelObjects, ResPotok, PlayRESFlag);
end;

procedure TFormMain.btnSOVIHelpClick(Sender: TObject);
begin
  FormSOVIHelp.ShowModal();
end;

end.
