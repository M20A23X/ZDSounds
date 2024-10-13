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

    procedure ChangeVolume(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClockMainTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbWagPerestukClick(Sender: TObject);
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
    procedure timerPlayPerestukTimer(Sender: TObject);
    procedure cbNatureSoundsClick(Sender: TObject);
    procedure cbTEDsClick(Sender: TObject);
    procedure cbBrakingSoundsClick(Sender: TObject);
    procedure cbSAVPESoundsClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
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
    procedure cbEPL2TBlockClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
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
  CHS8__: chs8_; // Экземпляр ЧС8
  CHS4T__: chs4t_;
  CHS4KVR__: chs4kvr_;
  VL80T__: vl80t_;
  EP1M__: ep1m_;
  ES5K__: es5k_;

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
  WagsNum: Byte; // Кол-во вагонов в нашем составе
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
  LocoSectionsNum: Byte; // Количество секций на локомотиве
  LocoWithTED: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звук ТЭД-ов
  LocoWithReductor: Boolean;
  LocoWithDIZ: Boolean;
  LocoWithSndReversor: Boolean;
  LocoWithSndKM: Boolean;
  // Переменная для определения, есть-ли на данный локомотив звук щелчка котнроллера
  LocoWithSndKM_OP: Boolean;
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
  LocoReductorNamePrefiks: String;
  LocoDIZNamePrefiks: String;
  LocoSvistokF: String;
  LocoHornF: String;
  LocoWorkDir: String; // Рабочая директория локомотива
  VentStartF, XVentStartF: PChar;
  VentCycleF, XVentCycleF: PChar;
  VentStopF, XVentStopF: PChar;
  VentTDStartF, XVentTDStartF: PChar;
  VentTDCycleF, XVentTDCycleF: PChar;
  VentTDStopF, XVentTDStopF: PChar;

  // Переменные для клавиш клавиатуры //
  PrevKeyA, PrevKeyD: Byte; // Переменная для пред. нажатия клавиш <<A>> и <<D>>
  PrevKeyE, PrevKeyQ: Byte; // Переменная для пред. нажатия клавиш <<E>> и <<Q>>
  PrevKeyZ, PrevKeyLKM: Byte; // Переменная для пред. нажатия клавиш <<Z>> и <<LKM>>
  PrevKeyW, PrevKeyS: Byte; // Переменная для пред. нажатия клавиш <<W>> и <<S>>
  PrevKeyM, PrevKeyEPK: Byte; // Переменная для пред. нажатия клавиш <<M>> и <<N или SHIFT+N>>
  PrevKeyEPKS: Byte;
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
  KMPrevKey: String;
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
  KM_395, PrevKM_395: Byte; // Положение крана №395
  KM_294, PrevKM_294: Single; // Положение крана №254 (локомотивный)
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
  ReversorPos, PrevReversorPos: Integer; // Позиция реверсора [255(-1); 0; 1]
  Speed, PrevSpeed: Integer; // Скорость
  SpeedSmoothed: Double; // Скорость
  OgrSpeed, PrevOgrSpeed: WORD; // Ограничение скорости
  NextOgrSpeed, PrevNextOgrSpeed: Byte; // Следующее ограничение скорости (желтая точка на КЛУБ-е)
  NextOgrPeekStatus: Byte; // Статус для пиканья про снижение ограничения [0-нет снижения 1-в процессе]
  PrevPRS: Integer;
  BrakeCylinders, PrevBrkCyl: Single; // Давление в тормозных цилиндрах
  Svistok, PrevSvistok: Byte; // Данные про работу свистка
  Tifon, PrevTifon: Byte; // Данные про работу тифона
  KLUBOpen: Byte; // Переменная-флаг открыта-ли в игре клавиатура КЛУБ
  TrackTail: Integer; // Номер трэка хвоста нашего поезда
  VstrechStatusCounter: Integer;
  isVstrechDrive: Boolean;
  Ordinata, PrevOrdinata: Double;
  OrdinataEstimate, PrevOrdinataEstimate: Double;
  OutsideLocoStatus: WORD;
  GR, PrevGR: Double;
  TC, PrevTC: Double;
  VR242, PrevVR242: Single;

  DebugFile: TextFile;

  // ------------------------------------------------------------------------------- //
  // ================ ДАЛЕЕ - ПЕРЕМЕННЫЕ ДЛЯ ХРАНЕНИЯ ПУТИ К ЗВУКАМ ================ //
  // ------------------------------------------------------------------------------- //
  ChannelNum, Track, PrevTrack, ChannelNumTED: Integer;
  ChannelNumDiz: Byte; // Номер канала для звуков дизеля
  Ini: TIniFile; // Ini файл настроек
  LocoVolume, LocoVolume2: Integer; // Громкости дорожек перестука локомотива, нужны только для перехода
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
  TEDVlm: Extended; // Громкость ТЭД-ов
  TEDVolume, TEDVolume2: Single; // Громкости дорожек ТЭД-ов локомотива, нужны только для переходов
  PerehodTEDStep: Single; // Шаг инкремента-декремента громкости дорожек ТЭД-ов при переходе сэмплов
  AB_ZB_1, AB_ZB_2: Byte;
  PrevAB_ZB_1, PrevAB_ZB_2: Byte;
  PrevBoks_Stat, Boks_Stat: Byte;
  // ------------------------------------------------------ //
  // ******* ФЛАГИ ******* //
  SAVPENextMessage: Boolean = False;
  HeadTrainEndOfTrain: Boolean;
  isCameraInCabin: Boolean; // Флаг для понимания, в кабине-ли камера?
  isRefreshLocalData: Boolean; // флаг для перезагрузки в скрипт всех данных необходимых для работы
  shouldPlayPerestuk: Boolean;
  shouldUpdate3SL2M: Boolean;
  // Флаг для провоцирования звука перестука тележек локомотива в случайные промежутки времени
  PrevPerestukStation: Boolean; // Флаги для перестука локомотива на станции
  isPlayWag: Boolean; // Флаг для включения звука перестука вагонов
  SAUTOff: Boolean; // Фалг для воспроизведения финального звука выключения САУТ
  isConnectedMemory, PrevConMem: Boolean; // Флаг для определения: удалось ли подключиться к памяти?
  isGameOnPause: Boolean; // Флаг для состояния паузы игры (сворочивание)
  VstrZat: Boolean; // Флаг для велючения затухания звука встречного поезда
  isPlayRB: Boolean; // Флаг для воспроизведения нажатия на кнопки РБ и РБС
  PlayRESFlag: Boolean;
  PereezdZatuh: Boolean;
  isSpeedLimitRouteLoad: Boolean;
  StopVent: Boolean;
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
  PerehodTED: Boolean; // Флаг для включения перехода дорожек ТЭД-ов
  PerehodLoco: Boolean; // Флаг для включения перехода дорожек катания
  StartVentVU: Boolean;
  DizNow: Byte;
  // ****************************************** //
  GameScreen: HWND; // Дескриптор окна игры
  GameWindowName: String;
  wHandle: Integer;
  tHandle, ProcessID, pHandle: Cardinal;
  temp: Cardinal;
  KM_Pos_1, Prev_KM: Integer;
  KM_Pos_2, Prev_KM_2: Byte;
  Prev_Diz: Integer;
  Vstr_Speed: Integer;
  Prev_KM_OP, KM_OP: Single; // Фактическая позиция ОП и предыдущая позиция ОП
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
  TEDPitch, TEDPitchDest: Single;
  ReduktorPitch: Single;
  ReduktorVolume: Single;
  ReduktorVolumeDest: Single;

implementation

uses StrUtils, Variants;

{$R *.dfm}

const
  DEFAULT_FLAG = 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  LOOP_FLAG = BASS_SAMPLE_LOOP {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};
  DECODE_FLAG = BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF};

  // ------------------------------------------------------------------------------//
  // Нажатие на чекбокс перестука локомотива                    //
  // ------------------------------------------------------------------------------//
procedure TFormMain.cbLocPerestukClick(Sender: TObject);
// Нажатие на "Перестук локомотива"
begin
  if cbLocPerestuk.Checked = True then
  begin
    PrevSpeed := 0;
    ChannelNum := 0;
  end
  else
  begin
    BASS_ChannelStop(LocoChannel);
    BASS_StreamFree(LocoChannel);
    BASS_ChannelStop(LocoChannelPerestuk);
    BASS_StreamFree(LocoChannelPerestuk);
  end;
end;

// ------------------------------------------------------------------------------//
// Нажатие на чекбокс перестука вагонов                     //
// ------------------------------------------------------------------------------//
procedure TFormMain.cbWagPerestukClick(Sender: TObject);
begin
  if cbWagPerestuk.Checked = True then
  begin
    panelPasswagSounds.Enabled := True;
    WagF := '';
    FormMain.ClientHeight := FormMain.ClientHeight + panelPasswagSounds.Height;
  end
  else
  begin
    panelPasswagSounds.Enabled := False;
    WagF := '';
    BASS_ChannelStop(WagChannel);
    isPlayWag := False;
    FormMain.ClientHeight := FormMain.ClientHeight - panelPasswagSounds.Height;
  end;
end;

// ------------------------------------------------------------------------------//
// Нажатие на чекбокс "Звуки ТЭД-ов и дизеля"                  //
// ------------------------------------------------------------------------------//
procedure TFormMain.cbTEDsClick(Sender: TObject);
begin
  if cbTEDs.Checked = False then
  begin
    BASS_ChannelStop(TEDChannel);
    BASS_StreamFree(TEDChannel);
    BASS_ChannelStop(TEDChannel2);
    BASS_StreamFree(TEDChannel2);
    BASS_ChannelStop(DizChannel);
    BASS_StreamFree(DizChannel);
    BASS_ChannelStop(DizChannel2);
    BASS_StreamFree(DizChannel2);
  end
  else
  begin
    PrevTEDAmperage := 0;
    Prev_KM := 0;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обновления имени используемой САВП              //
// ------------------------------------------------------------------------------//
procedure TFormMain.UpdateInfoName();
begin
  if (cbSAUTSounds.Checked = False) and (cbSAVPESounds.Checked = False) and (cbUSAVPSounds.Checked = False) and
    (cbGSAUTSounds.Checked = False) then
    SAVPName := '';
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "САУТ"             //
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
    SAUTOFFF := 'TWS/SAVP/SAUT/Off.mp3';
    SAUTOff := True; // Проигруем звук выключения САУТ
    UpdateInfoName;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма для обработки нажатия на чекбокс "ПРС РЖД"            //
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
// Подпрограмма для обработки нажатия на чекбокс "УСАВПП"            //
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
    // SAUTOFFF:='TWS/SAVP/USAVP/575.mp3';SAUTOff:=True;
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
// Подпрограмма для обработки нажатия на чекбокс "Грузовой САУТ"        //
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
    // SAUTOFFF:='TWS/SAVP/USAVP/575.mp3'; SAUTOff:=True;
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
    SAUTOFFF := 'TWS/SAVP/SAUT/Off.mp3';
    SAUTOff := True; // Проигруем звук выключения САУТ
    UpdateInfoName;
  end;
end;

// ------------------------------------------------------------------------------//
// Подпрограмма Закрытие программы                        //
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
// Подпрограмма Открытие программы                        //
// ------------------------------------------------------------------------------//
procedure TFormMain.FormCreate(Sender: TObject);
begin
  // if CheckInstallation=False then Application.Terminate; // Проверка правильно-ли установлена программа
  BASS_Init(-1, 44100, 0, application.Handle, nil); // Инициализация BASS
  LoadTWSParams('TWS\settings_TWS.ini'); // Делаем загрузку параметров TWS

  CHS7__ := chs7_.Create;
  CHS8__ := chs8_.Create;
  CHS4T__ := chs4t_.Create;
  CHS4KVR__ := chs4kvr_.Create;
  VL80T__ := vl80t_.Create;
  EP1M__ := ep1m_.Create;
  ES5K__ := es5k_.Create;

  isGameOnPause := True;

  MainCycleFreq := ClockMain.Interval;

  SAVP.InitializeSAVP;

  SAUTOff := False; // Запрещаем проигрывание звука выключения САУТ
  isPlayPRS := True; // Запрещаем проигрывать поездную радиостанцию
  isPlayRain := True;
  isPlayCabinClicks := True;
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
// Подпрограмма для обработки нажатия на чекбокс "Ручной режим" САВПЭ      //
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
  isPlayPerestuk_OnStation := False;
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
// Подпрограмма, вызывается когда заканчивает играть сэмпл перестука на светоф. //
// ------------------------------------------------------------------------------//
procedure PlayPerestukIsEnd(vHandle, vStream, vData: Cardinal; vUser: Pointer); stdcall;
begin
  FormMain.timerPlayPerestuk.Enabled := True;
end;

// ------------------------------------------------------------------------------//
// Основной цикл                                 //
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
label
  Next1;
begin
  try
    // Проверка обновления статуса открытого симулятора
    if (isConnectedMemory <> PrevConMem) Or (LocoGlobal = '') then
    begin
      isRefreshLocalData := True;
      LocoGlobal := '';
      if isConnectedMemory = True then
        BASS_Start
      else
        Bass_Stop;
    end;

    if isGameOnPause = False then
    begin
      if isConnectedMemory = True then
        ReadVarsFromRAM();

      // БЛОК ПОЛУЧЕНИЯ ДАННЫХ С ФАЙЛА Settings.ini //
      if isRefreshLocalData = True then
      begin
        isSpeedLimitRouteLoad := False;

        try
          GetStartSettingParamsFromRAM();
        except
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
            ConsistLength := ConsistLength + 18 * LocoSectionsNum;
          end
          else
          begin
            if Freight = 1 then
            begin
              ConsistLength := 14 * WagsNum + 18 * LocoSectionsNum;
            end
            else
            begin
              ConsistLength := 25 * WagsNum + 18 * LocoSectionsNum;
            end;
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

          if LocoGlobal = '3154' then
            LocoGlobal := 'ED4M'
          else if LocoGlobal = '3159' then
            LocoGlobal := 'ED9M'
          else if LocoGlobal = '23152' then
            LocoGlobal := '2ES5K'
          else if LocoGlobal = '31714' then
            LocoGlobal := 'EP1m'
          else if LocoGlobal = '343' then
            LocoGlobal := 'CHS2K'
          else if LocoGlobal = '523' then
            LocoGlobal := 'CHS4'
          else if LocoGlobal = '621' then
            LocoGlobal := 'CHS4t'
          else if LocoGlobal = '524' then
            LocoGlobal := 'CHS4 KVR'
          else if LocoGlobal = '812' then
            LocoGlobal := 'CHS8'
          else if LocoGlobal = '822' then
            LocoGlobal := 'CHS7'
          else if LocoGlobal = '811' then
            LocoGlobal := 'VL11m'
          else if LocoGlobal = '882' then
            LocoGlobal := 'VL82m'
          else if LocoGlobal = '880' then
            LocoGlobal := 'VL80t'
          else if LocoGlobal = '885' then
            LocoGlobal := 'VL85'
          else if LocoGlobal = '201318' then
            LocoGlobal := 'TEM18dm'
          else if LocoGlobal = '2070' then
            LocoGlobal := 'TEP70'
          else if LocoGlobal = '2071' then
            LocoGlobal := 'TEP70bs'
          else if LocoGlobal = '21014' then
            LocoGlobal := '2TE10U'
          else if LocoGlobal = '1462' then
            LocoGlobal := 'M62';
          Loco := LocoGlobal;

          // RefreshMVPSType();

          InitializeStartParams(VersionID); // Обновляем адреса и данные по локомотивам

          // Сверяем локомотивы и приравниваем их звуки
          if Loco = 'ED9M' then
            Loco := 'ED4M';
          if Loco = 'M62' then
            Loco := '2TE10U';
          if Loco = 'CHS8' then
            Loco := 'CHS8';
          if Loco = 'CHS7' then
            Loco := 'CHS7';
          if Loco = 'CHS4' then
            Loco := 'CHS4T';
          if Loco = 'CHS4 KVR' then
            Loco := 'CHS4 KVR';
          if Loco = 'TEP70bs' then
            Loco := 'TEP70';

        except
        end;

        if scSAVPOverrideRouteEK = False then
          Load_TWS_SAVP_EK();

        // -/- Блок загрузки сэмплов, содержащих в имени границы -/- //
        if isRefreshLocalData = True then
        begin
          // (1) Загружаем данные по сэмплам перестука (1) //
          I := 0;
          PerestukBaseNumElem := 0;
          if FindFirst('TWS/' + Loco + '/*.mp3', faAnyFile, SR) = 0 then
            repeat
              try
                St := Copy(SR.Name, 1, Pos('-', SR.Name) - 1);
                Station1 := Copy(SR.Name, Length(St) + 2, Length(SR.Name));
                Station1 := StringReplace(Station1, '.mp3', '', [rfReplaceAll]);
                if Station1 = '~' then
                  Station1 := '10000';

                var
                isCorrect := True;
                for var k := 1 to St.Length do
                begin
                  if not(St[k] IN ['0' .. '9', '-']) then
                  begin
                    isCorrect := False;
                    Break;
                  end;
                end;

                if isCorrect then
                begin
                  PerestukBase[I] := StrToInt(St);
                  PerestukBase[I + 1] := StrToInt(Station1);
                  inc(I, 2);
                  inc(PerestukBaseNumElem);
                end;
              except
              end;
            until FindNext(SR) <> 0;
          FindClose(SR);

          // (2) Загружаем данные по сэмплам ТЭД-ов (2) //
          if LocoWithTED = True then
          begin
            I := 0;
            TEDBaseNumElem := 0;
            if FindFirst('TWS/' + LocoTEDNamePrefiks + '/*.mp3', faAnyFile, SR) = 0 then
              repeat
                try
                  Station2 := StringReplace(SR.Name, 'ted' + #32, '', [rfReplaceAll]);
                  St := Copy(Station2, 1, Pos('-', Station2) - 1);
                  Station1 := Copy(Station2, Length(St) + 2, Length(Station2));
                  Station1 := StringReplace(Station1, '.mp3', '', [rfReplaceAll]);
                  if Station1 = '~' then
                    Station1 := '10000';

                  var
                  isCorrect := True;
                  for var k := 1 to St.Length do
                  begin
                    if not(St[k] IN ['0' .. '9', '-']) then
                    begin
                      isCorrect := False;
                      Break;
                    end;
                  end;

                  if isCorrect then
                  begin
                    TEDBase[I] := StrToInt(St);
                    TEDBase[I + 1] := StrToInt(Station1);
                    inc(I, 2);
                    inc(TEDBaseNumElem);
                  end;

                except
                end;
              until FindNext(SR) <> 0;
            FindClose(SR);
          end;

          isRefreshLocalData := False;
        end;
      end;

      // Smoothed speed
      if (Abs(SpeedSmoothed - Speed) > 1.1) or (Speed = 0) then
        SpeedSmoothed := Speed;
      SpeedSmoothed := SpeedSmoothed + 0.0036 * Acceleretion * FormMain.ClockMain.Interval;

      // Tempo
      var
      tempo := 0.01 * SpeedSmoothed;

      isCameraInCabin := CameraInCabinCheck(CameraX, Camera);

      if NapravOrdinata = 'Tuda' then
        OrdinataEstimate := OrdinataEstimate + (Speed / 3600 * MainCycleFreq)
      else
        OrdinataEstimate := OrdinataEstimate - (Speed / 3600 * MainCycleFreq);

      // ************************************************ //
      // ********* БЛОК ОБРАБОТКИ ЗВУКОВ ТЭД-ов ********* //
      if cbTEDs.Checked = True then
      begin
        if LocoWithTED = True then
        begin
          // ------/------ ЧС и ВЛ ТЭД-ы ------/------ //
          if TEDNewSystem = False then
          begin
            J := 0;
            TedFound := False;
            for I := 0 to TEDBaseNumElem do
            begin
              if (TEDBase[J] <= Speed) and (TEDBase[J + 1] > Speed) then
              begin
                if TEDBase[J + 1] <> 10000 then
                  TEDF := PChar('TWS/' + LocoTEDNamePrefiks + '/ted ' + IntToStr(TEDBase[J]) + '-' +
                    IntToStr(TEDBase[J + 1]) + '.mp3');
                if TEDBase[J + 1] = 10000 then
                  TEDF := PChar('TWS/' + LocoTEDNamePrefiks + '/ted ' + IntToStr(TEDBase[J]) + '-~.mp3');
                TedNow := TEDBase[J];
                TedFound := True;
                Break;
              end;
              inc(J, 2);
            end;
            if TedFound = False then
            begin
              TEDF := PChar('');
              BASS_ChannelStop(TEDChannel);
              BASS_ChannelStop(TEDChannel2);
            end; // Если ничего не нашли - то тормозим воспроизведение дорожек ТЭД
            if PerehodTED = False then
            begin
              try
                if TEDAmperage <> 0 then
                  TEDVlm := TEDAmperage / (UltimateTEDAmperage / 140)
                else if EDTAmperage <> 0 then
                  TEDVlm := EDTAmperage / (UltimateTEDAmperage / 140)
                else
                  TEDVlm := 0.0;

                // Меняем громкость ТЭД-ов в зависимости от того какая выбрана камера
                if isCameraInCabin = True then
                  TEDVlm := TEDVlm / 130
                else
                  TEDVlm := TEDVlm / 100;
                PerehodTEDStep := 0.01;
              except
              end;
            end;
            // Делаем затухание
            if TEDAmperage + EDTAmperage = 0 then
            begin
              TEDF := PChar(' ');
              BASS_ChannelSetAttribute(TEDChannel, BASS_ATTRIB_VOL, 0);
              BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, 0);
            end;
          end
          else
          begin
            // Новая система прогрывания звуков ТЭД-ов
            TEDF := PChar('TWS/' + LocoTEDNamePrefiks + '/ted.mp3');
            if BASS_ChannelIsActive(TEDChannel_FX) = 0 then
            begin
              ChannelNumTED := 0;
              isPlayTED := False;
            end;
            // Задаём громкость звуков ТЭД
            if Speed > 0 then
            begin
              if LocoTEDNamePrefiks <> 'ED4m' then
              begin
                if TEDAmperage <> 0 then
                  TEDVlm := (TEDAmperage / (UltimateTEDAmperage * 0.75)) * (trcBarTedsVol.Position / 100)
                else if EDTAmperage <> 0 then
                  TEDVlm := (EDTAmperage / (UltimateTEDAmperage * 0.75)) * (trcBarTedsVol.Position / 100)
                else
                  TEDVlm := 0.0;
              end
              else
              begin
                if KME_ED <> 0 then
                begin
                  TEDVlm := (TEDPitch + 35) / 35;
                end
                else
                begin
                  if TEDVlm > 0 then
                    TEDVlm := TEDVlm - 0.05;
                end;
              end;
            end
            else
              TEDVlm := 0.0;

            if LocoTEDNamePrefiks = 'CHS' then
            begin
              TEDPitchDest := power(Speed * 2350, 0.3) - 35;
              // if LocoTEDNamePrefiks = 'EP_TED' then begin
              // TEDPitchDest := power(Speed * 2350, 0.3) - 35;
              ReduktorPitch := (power(Speed * 100, 0.3) - 30) * 2 + 30;
              ReduktorVolume := (3 - 0.02 * Speed) * power((TEDAmperage / (UltimateTEDAmperage * 0.8)), 2);

              BASS_ChannelSetAttribute(ReduktorChannel_FX, BASS_ATTRIB_VOL,
                0.01 * ReduktorVolume * trcBarTedsVol.Position);
              BASS_ChannelSetAttribute(ReduktorChannel_FX, BASS_ATTRIB_TEMPO_PITCH, ReduktorPitch);
            end;
            if BASS_ChannelIsActive(ReduktorChannel_FX) = 0 then
            begin
              ReduktorF := PChar('TWS/' + LocoReductorNamePrefiks + '/reduktor.mp3');
              isPlayReduktor := False;
            end;
            // end;
            // if LocoTEDNamePrefiks = 'VL_TED'  then begin
            // if Speed <= 65 then TEDPitchDest := power(Speed*18.8, 0.5) - 35;
            // if Speed >  65 then TEDPitchDest := (Speed - 65) / 8;
            // end;
            // if LocoTEDNamePrefiks = 'ED4m' then TEDPitchDest := power(Speed * 2350, 0.3) - 35;

            if TEDPitch > TEDPitchDest then
              TEDPitch := TEDPitch - 0.005 * MainCycleFreq;
            if TEDPitch < TEDPitchDest then
              TEDPitch := TEDPitch + 0.005 * MainCycleFreq;

            BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_TEMPO_PITCH, TEDPitch);
          end;
        end;
        // ------/------ ЧС и ВЛ ТЭД-ы [Конец блока] ------/------ //

        // -----/----- Звуки дизелей -----/----- //
        // if LocoWithDIZ=True then begin
        // // Условие проверки запуска дизеля
        // if (BV<>0) or ((diesel2<>0) and (LocoSectionsNum=2)) then begin
        // if PerehodDIZ = False then begin
        // if ((BV<>0) and (PrevBV=0)) or ((diesel2<>0) and (PrevDiesel2=0)) then Prev_Diz:=-1;	// Запуск дизеля
        // if (BV<>0) and (diesel2=0) then begin
        // if DizNow>KM_Pos_1 then Dec(DizNow);
        // if DizNow<KM_Pos_1 then Inc(DizNow);
        // end else begin
        // if diesel2<>0 then begin
        // if DizNow>KM_Pos_2 then Dec(DizNow);
        // if DizNow<KM_Pos_2 then Inc(DizNow);
        // end;
        // end;
        // dizF := PChar('TWS/'+LocoDIZNamePrefiks+'/diesel/x'+IntToStr(DizNow)+'.mp3');
        // // Условие запуска нового/первого звука дизеля
        // if (DizNow<>Prev_Diz) or
        // ((BV+diesel2<>0) and (BASS_ChannelIsActive(DizChannel)+BASS_ChannelIsActive(DizChannel2) = 0))
        // then begin
        // isPlayDiz:=False; Prev_Diz:=DizNow; TimerPerehodDizSwitch.Enabled:=True;
        // end;
        // end;
        // end;
        //
        // // Остановка звуков дизеля, если он заглушен в симуляторе
        // if BV+diesel2=0 then begin
        // if BASS_ChannelIsActive(TEDChannel_FX)<>0 then begin
        // BASS_ChannelStop(TEDChannel);  BASS_StreamFree(TEDChannel);
        // BASS_ChannelStop(TEDChannel_FX);  BASS_StreamFree(TEDChannel_FX);
        // end;
        // if BASS_ChannelIsActive(TEDChannel2)<>0 then begin
        // BASS_ChannelStop(TEDChannel2); BASS_StreamFree(TEDChannel2);
        // end;
        // if BASS_ChannelIsActive(DizChannel)<>0 then begin
        // BASS_ChannelStop(DizChannel);  BASS_StreamFree(DizChannel);
        // end;
        // if BASS_ChannelIsActive(DizChannel2)<>0 then begin
        // BASS_ChannelStop(DizChannel2); BASS_StreamFree(DizChannel2);
        // end;
        // end;
        // end;
        // -----/----- Конец блока звуков дизелей -----/----- //

        if TEDVlm > trcBarTedsVol.Position / 100 then
          TEDVlm := trcBarTedsVol.Position / 100;

        // Блок задачи громкости ТЭД-ам и дизелям
        if (PerehodTED = False) and (Camera <> 2) then
        begin
          if ChannelNumTED = 1 then
            BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVlm)
          else
            BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVlm);
        end
        else
        begin
          if Camera = 2 then
          begin
            BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, 0);
            BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, 0);
          end;
        end;

        if TedNow <> Prev_KM then
        begin
          isPlayTED := False;
          Prev_KM := TedNow;
        end;
      end;
      // ********************************************** //
      // БЛОК ЗВУКОВ ОКРУЖЕНИЯ //
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
                RainF := PChar('TWS/storm.mp3');
              2:
                RainF := PChar('TWS/storm1.mp3');
              3:
                RainF := PChar('TWS/storm2.mp3');
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
              WalkSoundF := PChar('TWS/snow_walk.mp3');
              isPlayWalkSound := True;
            end
            else
            begin
              if BASS_ChannelIsActive(WalkSoundChannel) <> 0 then
              begin
                BASS_ChannelStop(WalkSoundChannel);
                BASS_StreamFree(WalkSoundChannel);
              end;
            end;
          end;
        end;

        // Стеклоочистители, звуки
        if Stochist <> Prev_Stochist then
        begin
          if Stochist = 4 then
          begin
            StochistF := PChar('TWS/stochist.mp3');
            isPlayStochist := False
          end
          else
          begin
            if Stochist = 8 then
            begin
              StochistF := PChar('TWS/stochist2.mp3');
              isPlayStochist := False
            end
            else
            begin
              BASS_ChannelStop(Stochist_Channel);
              BASS_StreamFree(Stochist_Channel)
            end;
          end;
        end;
        // Если скорость стеклоочестителей 2-ая, то делаем звук удара об края стекла
        if Stochist = 8 then
        begin
          if ((StochistDGR > 120) and (Prev_StchstDGR <= 120)) or ((StochistDGR < 55) and (Prev_StchstDGR >= 55)) then
            isPlayStochistUdar := False;
        end;
      end;
      // ***************** //
      // БЛОК ЗВУКОВ ЩЕЛЧКОВ НА ЛОКОМОТИВАХ //
      if cbCabinClicks.Checked = True then
      begin
        // Щелчки кранов машиниста //
        if (KM_395 <> PrevKM_395) and (KM_395 <> 1) and (KM_395 <> 6) then
        begin
          CabinClicksF := PChar('TWS/stuk395.mp3');
          isPlayCabinClicks := False;
        end;
        if (KM_294 <> PrevKM_294) then
        begin
          if (KM_294 <> -1) and (PrevKM_294 <> -1) and (Loco <> 'ED4M') then
          begin
            CabinClicksF := PChar('TWS/stuk254.mp3');
            isPlayCabinClicks := False;
          end;
        end;
        PrevKM_395 := KM_395;
        PrevKM_294 := KM_294;

        // Щелчок ключа ЭПК //
        if (GetAsyncKeyState(78) <> 0) and (PrevKeyEPK = 0) then
          if (GetAsyncKeyState(16) <> 0) or (GetAsyncKeyState(16) = 0) then
          begin
            IMRZashelka := PChar('TWS/epk.mp3');
            isPlayIMRZachelka := False;
            PrevKeyEPK := 1;
          end;
        if GetAsyncKeyState(16) + GetAsyncKeyState(78) = 0 then
          PrevKeyEPK := 0;
        // БЛОК ЩЕЛЧКА КОНТРОЛЛЕРА //
        if LocoWithSndKM = True then
        begin
          if LocoSndReversorType = 1 then
            ReversorPos := 1;
          // Локомотивы на которых не удалось отследить положение реверсора
          if ReversorPos <> 0 then
          begin
            if KM_Pos_1 <> Prev_KMAbs then
            begin
              if LocoGlobal = 'M62' then
              begin
                CabinClicksF := PChar('TWS/M62/throttle.mp3');
                isPlayCabinClicks := False;
              end;
              if Loco = 'ED4M' then
              begin
                if (LocoNum < 160) and (LocoGlobal = 'ED4M') then
                  CabinClicksF := PChar('TWS/ED4m/stukKM.mp3')
                else
                  CabinClicksF := PChar('TWS/ED4m/CPPK_stukKM.mp3');
                try
                  if ((KM_Pos_1 - Prev_KMAbs) mod 256 = 0) Or (LocoGlobal = 'ED9M') then
                    isPlayCabinClicks := False;
                except
                end;
              end;
            end;
          end;

          if GetAsyncKeyState(65) = 0 then
            PrevKeyA := 0
          else if GetAsyncKeyState(68) = 0 then
            PrevKeyD := 0
          else if GetAsyncKeyState(69) = 0 then
            PrevKeyE := 0
          else if GetAsyncKeyState(81) = 0 then
            PrevKeyQ := 0;
        end;
        // БЛОК ЩЕЛЧКА РЕВЕРСИВКИ //
        if LocoWithSndReversor = True then
        begin
          if LocoSndReversorType = 1 then
          begin
            if KM_Pos_1 = 0 then
            begin
              if (PrevKeyW = 0) and (GetAsyncKeyState(87) <> 0) then
              begin
                CabinClicksF := RevPosF;
                isPlayCabinClicks := False;
                PrevKeyW := 1;
              end;

              if (PrevKeyS = 0) and (GetAsyncKeyState(83) <> 0) then
              begin
                CabinClicksF := RevPosF;
                isPlayCabinClicks := False;
                PrevKeyS := 1;
              end;
            end;

            if GetAsyncKeyState(83) = 0 then
              PrevKeyS := 0
            else if GetAsyncKeyState(87) = 0 then
              PrevKeyW := 0;
          end;

          if LocoSndReversorType = 0 then
            if ReversorPos <> PrevReversorPos then
            begin
              CabinClicksF := RevPosF;
              isPlayCabinClicks := False;
            end;
        end;
        // --- Включение прожектора(тумблер) --- //
        // if Highlights<>PrevHighLights then begin
        // if Loco = 'ED4M' then begin
        // LocoPowerEquipmentF := PChar('TWS/ED4m/vkl.mp3');
        // isPlayLocoPowerEquipment := False;
        // end;
        // if LocoGlobal = 'CHS2K' then begin
        // LocoPowerEquipmentF := PChar('sound/chs7/tumbler.mp3');
        // isPlayLocoPowerEquipment := False;
        // end;
        // end;
        // --- ЭПТ(тумблер) --- //
        // if EPT <> PrevEPT then begin
        // if Loco = 'ED4M' then begin
        // LocoPowerEquipmentF := PChar('TWS/ED4m/tumbler.mp3');
        // isPlayLocoPowerEquipment:=False;
        // end;
        // if LocoGlobal = 'CHS2K' then begin
        // LocoPowerEquipmentF := PChar('sound/chs7/tumbler.mp3');
        // isPlayLocoPowerEquipment := False;
        // end;
        // end;
        // ЗВУК ВКЛЮЧЕНИЯ БВ //
        // if Loco='ED4M' then begin
        // if (BV<>PrevBV) Or (FrontTP<>PrevFrontTP) then begin
        // LocoPowerEquipmentF := PChar('TWS/ED4m/tumbler.mp3');
        // isPlayLocoPowerEquipment:=False;
        // end;
        // // БЛОК ОТКРЫТИЯ РАЗОБЩИТЕЛЬНОГО КРАНА //
        // if PrevKeyKKR = 0 then begin
        // if GetAsyncKeyState(76) <> 0 then begin
        // IMRZashelka:=PChar('TWS/TM_Kran.mp3'); isPlayIMRZachelka:=False; PrevKeyKKR:=1;
        // end;
        // end else begin
        // if (GetAsyncKeyState(16)=0) and (GetAsyncKeyState(76)=0) then PrevKeyKKR:=0;
        // end;
        // end;
      end;
      // ***************** //
      // БЛОК ЗВУКОВ ПОДНЯТИЯ ОПУСКАНИЯ ТП //
      if cbTPSounds.Checked = True then
      begin
        if LocoWithSndTP = True then
        begin
          if Loco <> 'ED4M' then
          begin
            if (FrontTP = 63) and (FrontTP <> PrevFrontTP) then
            begin
              isPlayFTP := False;
              FTPF := PChar('TWS/TPUp.mp3');
            end;
            if (FrontTP <> 63) and (PrevFrontTP = 63) and (PrevFrontTP <> 188) then
            begin
              isPlayFTP := False;
              FTPF := PChar('TWS/TPDown.mp3');
            end;
            if (BackTP = 63) and (BackTP <> PrevBackTP) then
            begin
              isPlayBTP := False;
              BTPF := PChar('TWS/TPUp.mp3');
            end;
            if (BackTP <> 63) and (PrevBackTP = 63) and (PrevBackTP <> 188) then
            begin
              isPlayBTP := False;
              BTPF := PChar('TWS/TPDown.mp3');
            end;
            // end else begin
            // if FrontTP<>PrevFrontTP then begin
            // if FrontTP=1 then FTPF:=PChar('TWS/ED4m/TPUp.mp3');
            // if FrontTP=0 then FTPF:=PChar('TWS/ED4m/TPDown.mp3');
            // isPlayFTP:=False;
            // end;
          end;
        end;
      end;
      // ********************************* //
      // ИГРАЕМ ПЕРЕСТУК ЕСЛИ МЫ НА СТАНЦИИ //
      if cbLocPerestuk.Checked = True then
      begin
        if StationCount > 0 then
        begin
          isPlayPerestuk_OnStation := False;
          for I := 0 to StationCount - 1 do
          begin
            if (Track <= StationTrack1[I] + 10) and (Track >= StationTrack2[I] - 10) then
            begin
              isPlayPerestuk_OnStation := True;
              if PrevPerestukStation = False then
              begin
                PrevSpeed := 0;
                timerPlayPerestukTimer(FormMain);
              end;
            end;
          end;
        end;
      end;
      // ************************ //
      // БЛОК ЗВУКОВ КЛУБ и 3сл2м //
      if (isConnectedMemory = True) then
      begin
        if cbKLUBSounds.Checked = True then
        begin // КЛУБ
          // Нажатие РБ и РБС
          if RB <> PrevRB then
          begin
            if RB = 1 then
            begin
              RBF := PChar('TWS/KLUB_pick.mp3');
              isPlayRB := False;
            end;
            if RB = 0 then
            begin
              RBF := PChar('TWS/KLUB_pick.mp3');
              isPlayRB := False;
            end;
          end;

          if RBS <> PrevRBS then
          begin
            if RBS = 1 then
            begin
              RBF := PChar('TWS/KLUB_pick.mp3');
              isPlayRB := False;
            end;
            if RBS = 0 then
            begin
              RBF := PChar('TWS/KLUB_pick.mp3');
              isPlayRB := False;
            end;
          end;
          // Пиканья при ограничении
          if (OgrSpeed - Speed <= 3) and (isPlayOgrSpKlub = 0) and (OgrSpeed <> 0) and (Svetofor <> 0) then
            isPlayOgrSpKlub := 1;
          if ((OgrSpeed - Speed > 3) and (isPlayOgrSpKlub = -1)) or ((OgrSpeed = 0) and (isPlayOgrSpKlub = -1)) then
          begin
            BASS_ChannelStop(Ogr_Speed_KLUB);
            BASS_StreamFree(Ogr_Speed_KLUB);
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
            BASS_SampleStop(BeltPool_Channel);
            BASS_StreamFree(BeltPool_Channel);
          end;
          // Проверка бдительности
          if (PrevVCheck <> VCheck) and (VCheck = 1) then
            isPlayVcheck := False;

          if NextOgrPeekStatus = 0 then
          begin
            if PrevOgrSpeed > OgrSpeed then
            begin
              if NextOgrSpeed <> 0 then
              begin
                isPlayVcheck := False;
                NextOgrPeekStatus := 1;
              end;
            end;
          end;
          if NextOgrPeekStatus = 1 then
            if (NextOgrSpeed <> PrevNextOgrSpeed) or (NextOgrSpeed = 0) then
              NextOgrPeekStatus := 0;
          // end;
        end;

        // 3СЛ2м
        if cb3SL2mSounds.Checked then
        begin
          // Нажатие РБ и РБС
          if RB <> PrevRB then
          begin
            if RB = 1 then
            begin
              RBF := PChar('TWS/RB_MexDown.mp3');
              isPlayRB := False;
            end
            else if RB = 0 then
            begin
              RBF := PChar('TWS/RB_MexUp.mp3');
              isPlayRB := False;
            end;
          end;

          if RBS <> PrevRBS then
          begin
            if RBS = 1 then
            begin
              RBF := PChar('TWS/RB_MexDown.mp3');
              isPlayRB := False;
            end
            else if RBS = 0 then
            begin
              RBF := PChar('TWS/RB_MexUp.mp3');
              isPlayRB := False;
            end;
          end;

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
            BASS_SampleStop(BeltPool_Channel);
            BASS_StreamFree(BeltPool_Channel);
          end;

          // 3СЛ2м
          if (Speed <= 0) and (PrevSpeed_Fakt > 0) or (Speed > 1) and (PrevSpeed_Fakt = 1) or (Speed > 2) and
            (PrevSpeed_Fakt = 2) then
          begin
            var
            clockPath := 'TWS/Devices/3SL2M/';
            var
              clockVolume: Double := 0;

            if Speed <= 0 then
              clockPath := clockPath + 'clock.mp3'
            else if (Speed > 0) and (Speed <= 2) and (PrevSpeed_Fakt > 0) then
              clockPath := clockPath + 'start.mp3'
            else if Speed > 2 then
              clockPath := clockPath + 'loop.mp3';

            if Camera = 0 then
              clockVolume := 0.01 * trcBarLocoClicksVol.Position;

            BASS_ChannelStop(ClockChannel);
            BASS_StreamFree(ClockChannel);

            ClockChannel := BASS_StreamCreateFile(False, PChar(clockPath), 0, 0, LOOP_FLAG);
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
      // ********************** //
      // БЛОК ПРОИГРЫВАНИЯ УДАРА СЦЕПКИ НА МВПС //
      // if (Loco='ED4M') and (cbLocPerestuk.Checked=True) and (isUPU=False) then begin
      // if (Acceleretion>0) and (PrevAcceleretion=0) and (Speed<1) then begin
      // J:=Random(9);
      // TrogF := PChar('TWS/ED4m/Stuk-Trog/Stuk-Trog-I-'+IntToStr(J)+'.mp3');
      // isPlayTrog:=False;
      // end;
      // if (Speed=0) and (PrevSpeed_Fakt<>0) and (Acceleretion<=-0.6) then begin
      // TrogF := PChar('TWS/ED4m/prib.mp3');
      // isPlayTrog:=False;
      // end;
      // end;
      // ************************************** //
      // БЛОК МНОГОСТРАДАЛЬНОГО ВСТРЕЧНОГО ПОЕЗДА //
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
                VstrechF := PChar('TWS/Pass_vstrech.mp3')
              else
                VstrechF := PChar('TWS/Freight_vstrech.mp3');
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

      // СВИСТОК-ТИФОН //
      if (cbSignalsSounds.Checked = True) and (Track <> 0) then
      begin
        if Svistok <> 0 then
        begin
          if BASS_ChannelIsActive(SvistokCycleChannel) = 0 then
          begin
            var
            pathStart := LocoWorkDir;
            var
            pathLoop := LocoWorkDir;

            if isCameraInCabin = True then
            begin
              pathStart := pathStart + LocoSvistokF + '_start.mp3';
              pathLoop := pathLoop + LocoSvistokF + '_loop.mp3';
            end
            else
            begin
              pathStart := pathStart + 'x_' + LocoSvistokF + '_start.mp3';
              pathLoop := pathLoop + 'x_' + LocoSvistokF + '_loop.mp3';
            end;

            TWS_PlaySvistok(pathStart);
            TWS_PlaySvistokCycle(pathLoop);
          end;
        end
        else
        begin
          if BASS_ChannelIsActive(SvistokCycleChannel) <> 0 then
          begin
            var
            pathStop := LocoWorkDir;

            BASS_ChannelStop(SvistokCycleChannel);
            BASS_StreamFree(SvistokCycleChannel);

            if isCameraInCabin = True then
              pathStop := pathStop + LocoSvistokF + '_stop.mp3'
            else
              pathStop := pathStop + 'x_' + LocoSvistokF + '_stop.mp3';

            TWS_PlaySvistok(pathStop)
          end;
        end;

        if Tifon <> 0 then
        begin
          if BASS_ChannelIsActive(TifonCycleChannel) = 0 then
          begin
            var
            pathStart := LocoWorkDir;
            var
            pathLoop := LocoWorkDir;

            if isCameraInCabin = True then
            begin
              pathStart := pathStart + LocoHornF + '_start.mp3';
              pathLoop := pathLoop + LocoHornF + '_loop.mp3';
            end
            else
            begin
              pathStart := pathStart + 'x_' + LocoHornF + '_start.mp3';
              pathLoop := pathLoop + 'x_' + LocoHornF + '_loop.mp3';
            end;

            TWS_PlayTifon(pathStart);
            TWS_PlayTifonCycle(pathLoop);
          end;
        end
        else
        begin
          if BASS_ChannelIsActive(TifonCycleChannel) <> 0 then
          begin
            var
            pathStop := LocoWorkDir;

            BASS_ChannelStop(TifonCycleChannel);
            BASS_StreamFree(TifonCycleChannel);

            if isCameraInCabin = True then
              pathStop := pathStop + LocoHornF + '_stop.mp3'
            else
              pathStop := pathStop + 'x_' + LocoHornF + '_stop.mp3';

            TWS_PlayTifon(pathStop)
          end;
        end;
      end;

      // БЛОК ВСПОМ-МАШИН //
      if cbVspomMash.Checked = True then
      begin
        // Остаток времени для запуска вентиляторов ВУ
        if StopVent = False then
        begin
          if BASS_ChannelIsActive(Vent_Channel_FX) <> 0 then
          begin
            VentTimeLeft := BASS_ChannelBytes2Seconds(Vent_Channel_FX, BASS_ChannelGetLength(Vent_Channel_FX,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(Vent_Channel_FX, BASS_POS_BYTE));
            if (VentTimeLeft <= 0.2) and (BASS_ChannelIsActive(VentCycle_Channel_FX) = 0) then
              isPlayCycleVent := False;
          end;
          if BASS_ChannelIsActive(XVent_Channel_FX) <> 0 then
          begin
            XVentTimeLeft := BASS_ChannelBytes2Seconds(XVent_Channel_FX, BASS_ChannelGetLength(XVent_Channel_FX,
              BASS_POS_BYTE) - BASS_ChannelGetPosition(XVent_Channel_FX, BASS_POS_BYTE));
            if (XVentTimeLeft <= 0.2) and (BASS_ChannelIsActive(XVentCycle_Channel_FX) = 0) then
              isPlayCycleVentX := False;
          end;
        end;

        // -=- Остановка цикла работы вентиляторов при полной остановке работы вентиляторов -=- //
        if (StopVent = True) AND (LocoGlobal <> 'VL80t') AND (LocoGlobal <> 'EP1m') AND (LocoGlobal <> '2ES5K') then
        begin
          if BASS_ChannelIsActive(VentCycle_Channel_FX) <> 0 then
          begin
            VentTimeLeft := BASS_ChannelBytes2Seconds(Vent_Channel_FX, BASS_ChannelGetPosition(Vent_Channel_FX,
              BASS_POS_BYTE));
            if (VentTimeLeft >= 0.3) and (BASS_ChannelIsActive(VentCycle_Channel_FX) <> 0) then
            begin
              BASS_ChannelStop(VentCycle_Channel_FX);
              BASS_StreamFree(VentCycle_Channel_FX);
            end;
          end;
          if BASS_ChannelIsActive(XVentCycle_Channel_FX) <> 0 then
          begin
            XVentTimeLeft := BASS_ChannelBytes2Seconds(XVent_Channel_FX, BASS_ChannelGetPosition(XVent_Channel_FX,
              BASS_POS_BYTE));
            if (XVentTimeLeft >= 0.3) and (BASS_ChannelIsActive(XVentCycle_Channel_FX) <> 0) then
            begin
              BASS_ChannelStop(XVentCycle_Channel_FX);
              BASS_StreamFree(XVentCycle_Channel_FX);
            end;
          end;
        end;
        // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= //

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

        // -=- Остановка цикла работы вентиляторов при полной остановке работы вентиляторов -=- //
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
        // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= //

        if (LocoGlobal = 'CHS7') Or (LocoGlobal = 'CHS8') Or (LocoGlobal = 'CHS4t') then
        begin
          // Вентиляторы ПТР на ЧС7
          if VentTDVol > 0.01 * trcBarVspomMahVol.Position then
            VentTDVol := 0.01 * trcBarVspomMahVol.Position
          else if VentTDVol < 0 then
            VentTDVol := 0;
          // Задаём громкость звуков работы вентиляторов (ПТР) //
          if (isCameraInCabin = True) and (Camera = 0) then
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
        // if Loco='ED4M' then begin
        // if BV+FrontTP+Compressor>2 then Compressor:=1 else Compressor:=0;
        // end;
        // Звуки запуска компрессора
        if Compressor <> Prev_Compressor then
        begin
          if Compressor <> 0 then
          begin
            // if LocoGlobal='CHS2K' then begin CompressorF:=PChar('TWS/CHS2K/mk-start.mp3'); CompressorCycleF:=PChar('TWS/CHS2K/mk-loop.mp3'); end;
            // if LocoGlobal='VL11m' then begin
            // CompressorF:=PChar('TWS/VL11m/MK-start.mp3'); CompressorCycleF:=PChar('TWS/VL11m/MK-loop.mp3');
            // XCompressorF:=PChar('TWS/VL11m/x_MK-start.mp3'); XCompressorCycleF:=PChar('TWS/VL11m/x_MK-loop.mp3');
            // end;
            isPlayCompressor := False;
            isPlayXCompressor := False;
          end;
          // Звуки остановки компрессора
          if Compressor = 0 then
          begin
            // if LocoGlobal='CHS2K' then begin CompressorF:=PChar('TWS/CHS2K/mk-stop.mp3'); end;
            // if LocoGlobal='VL11m' then begin
            // CompressorF:=PChar('TWS/VL11m/MK-stop.mp3');
            // XCompressorF:=PChar('TWS/VL11m/x_MK-stop.mp3');
            // end;
            CompressorCycleF := PChar('');
            XCompressorCycleF := PChar('');
            isPlayCompressor := False;
            isPlayXCompressor := False;
          end;
        end;
        // **************** //
        // БЛОК ВЕНТИЛЯТОРОВ //
        // ВЕНТИЛЯТОРЫ ДЛЯ ВСЕХ ЭЛ-ВОЗОВ, КРОМЕ ЧС4, ВЛ80т, ЭП1м И 2ЭС5К
        if (LocoGlobal <> 'CHS4 KVR') and (LocoGlobal <> 'VL80t') and (LocoGlobal <> 'EP1m') and (LocoGlobal <> '2ES5K')
        then
        begin
          if (Vent <> 0) and (Prev_Vent = 0) then
          begin
            if (LocoGlobal = 'CHS7') Or (LocoGlobal = 'CHS2K') then
            begin
              if (BASS_ChannelIsActive(Vent_Channel_FX) <> 0) and (StopVent = True) then
              begin
                BASS_ChannelStop(Vent_Channel_FX);
                BASS_StreamFree(Vent_Channel_FX);
                BASS_ChannelStop(XVent_Channel_FX);
                BASS_StreamFree(XVent_Channel_FX);
                isPlayCycleVent := False;
                isPlayCycleVentX := False;
              end;
              if Vent = 255 then
                VentPitchDest := 5
              else
                VentPitchDest := 0;
            end;
            StopVent := False;
            isPlayVent := False;
            isPlayVentX := False;
          end;
          if ((Vent = 0) and (Prev_Vent <> 0) and (LocoGlobal <> 'CHS4 KVR')) then
          begin
            StopVent := True;
            isPlayVent := False;
            isPlayVentX := False;
          end;
        end;
        if (LocoGlobal <> 'EP1m') and (LocoGlobal <> 'VL80t') then
        begin
          VentVolume := 100;
          CycleVentVolume := 100;
        end;
        // Перерегулирование тональности вентиляторов
        TWS_MVPitchRegulation();
      end;

      // ТРЕНИЕ КОЛОДОК ПРИ ТОРМОЖЕНИИ //
      if cbBrakingSounds.Checked = True then
      begin
        if (BrakeCylinders > 0) and (Speed > 0) then
        begin
          var
          volume := 0.001 * BrakeCylinders * trcBarLocoPerestukVol.Position / SpeedSmoothed;

          if volume > 0.5 then
            volume := 0.5;

          if isCameraInCabin then
          begin
            volume := 0.25 * volume;
            if EDTAmperage <> 0 then
              volume := 0.25 * volume;
          end
          else
          begin
            if EDTAmperage <> 0 then
              volume := 0.125 * volume;
          end;
          var
          pitch := volume * 1.1;

          if (BASS_ChannelIsActive(BrakeChannel) = 0) and (BASS_ChannelIsActive(BrakeChannelFX) = 0) then
          begin
            BASS_ChannelStop(BrakeChannel);
            BASS_StreamFree(BrakeChannel);

            BrakeChannel := BASS_StreamCreateFile(False, PChar('TWS/brake_slipp.mp3'), 0, 0, DECODE_FLAG);
            BrakeChannelFX := BASS_FX_TempoCreate(BrakeChannel, BASS_FX_FREESOURCE);

            BASS_ChannelFlags(BrakeChannelFX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
            BASS_ChannelSetAttribute(BrakeChannelFX, BASS_ATTRIB_VOL, volume);
            BASS_ChannelSetAttribute(BrakeChannelFX, BASS_ATTRIB_TEMPO_PITCH, pitch);

            BASS_ChannelPlay(BrakeChannelFX, True);
          end
          else
          begin
            BASS_ChannelSetAttribute(BrakeChannelFX, BASS_ATTRIB_VOL, volume);
            BASS_ChannelSetAttribute(BrakeChannelFX, BASS_ATTRIB_TEMPO_PITCH, pitch);
          end
        end
        else if (BrakeCylinders <= 0) or (Speed <= 0) then
        begin
          BASS_ChannelStop(BrakeChannel);
          BASS_StreamFree(BrakeChannel);
          BASS_ChannelStop(BrakeChannelFX);
          BASS_StreamFree(BrakeChannelFX);
        end
      end;

      // Проверяем менялись-ли показания камеры?
      if (Camera <> PrevCamera) or (CameraX <> PrevCameraX) then
        VolumeMaster_RefreshVolume();

      // ШУМ ЕЗДЫ
      if cbLocPerestuk.Checked = True then
      begin
        if (SpeedSmoothed <= 0) and (BASS_ChannelIsActive(LocoChannel) <> 0) then
          BASS_ChannelStop(LocoChannel)
        else if SpeedSmoothed > 0 then
        begin
          if BASS_ChannelIsActive(LocoChannel) = 0 then
          begin
            BASS_ChannelStop(LocoChannel);
            BASS_StreamFree(LocoChannel);

            var
            channel := BASS_StreamCreateFile(False, PChar('TWS/' + Loco + '/0-140.mp3'), 0, 0, DECODE_FLAG);
            var
            channelFX := BASS_FX_TempoCreate(channel, BASS_FX_FREESOURCE);

            BASS_ChannelFlags(channelFX, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);

            BASS_ChannelPlay(channelFX, True);

            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO_PITCH, tempo);
            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO_PITCH, tempo);
            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO, tempo);
            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO, tempo);
            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, tempo);
            BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, tempo);

            LocoChannel := channelFX;

            if ChannelNum = 0 then
              ChannelNum := 1
            else
              ChannelNum := 0;
            if (Camera = 0) Or (Camera = 1) then
              LocoVolume := FormMain.trcBarLocoPerestukVol.Position;

            // if Camera = 2 then
            // begin
            // if Loco<>'ED4M' then LocoVolume:=0 else LocoVolume := FormMain.trcBarLocoPerestukVol.Position;
            // end;

            LocoVolume2 := 0;
            PerehodLoco := True; // Установки для перехода
          end;

          if PrevSpeed_Fakt < 3 then
            timerPlayPerestuk.Enabled := True;

          BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO_PITCH, tempo);
          BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_TEMPO, tempo);
          BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, tempo);
        end;

        // === ПЕРЕСТУК НА СВЕТОФОРАХ === //
        if ((SvetoforDist <= Speed / 1.8 + 4) and (Prev_SvetoforDist > Speed / 1.8 + 4)) Or (shouldPlayPerestuk = True)
        then
        begin
          shouldPlayPerestuk := False;
          if BASS_ChannelIsActive(LocoChannelPerestuk) = 0 then
          begin
            var
            path := 'TWS/' + Loco + '/Perestuk/';

            if (Speed in [3 .. 5]) then
              path := path + '3-5';
            if (Speed in [6 .. 10]) then
              path := path + '5-10';
            if (Speed in [11 .. 20]) then
              path := path + '10-20';
            if (Speed in [21 .. 30]) then
              path := path + '20-30';
            if (Speed in [31 .. 40]) then
              path := path + '30-40';
            if (Speed in [41 .. 50]) then
              path := path + '40-50';
            if (Speed in [51 .. 60]) then
              path := path + '50-60';
            if (Speed in [61 .. 70]) then
              path := path + '60-70';
            if (Speed in [71 .. 80]) then
              path := path + '70-80';
            if (Speed in [81 .. 90]) then
              path := path + '80-90';
            if (Speed in [91 .. 100]) then
              path := path + '90-100';
            if (Speed in [101 .. 110]) then
              path := path + '100-110';
            if (Speed in [111 .. 120]) then
              path := path + '110-120';
            if (Speed in [121 .. 130]) then
              path := path + '120-130';
            if (Speed > 130) then
              path := path + '130-140';

            LocoPerestukF := PChar(path + '.mp3');
            PrevSpeed := Speed;
          end;
        end;

        try
          BASS_ChannelStop(LocoChannelPerestuk);
          BASS_StreamFree(LocoChannelPerestuk);

          var
          channel := BASS_StreamCreateFile(False, LocoPerestukF, 0, 0, DECODE_FLAG);
          LocoChannelPerestuk := BASS_FX_TempoCreate(channel, BASS_FX_FREESOURCE);

          BASS_ChannelPlay(LocoChannelPerestuk, True);

          BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_TEMPO_PITCH, tempo);
          BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_TEMPO, tempo);
          BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, tempo);

          if (Camera <> 2) or (Loco = 'ED4M') then
            BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, trcBarLocoPerestukVol.Position / 100)
          else
            BASS_ChannelSetAttribute(LocoChannelPerestuk, BASS_ATTRIB_VOL, 0);

          BASS_ChannelSetSync(LocoChannelPerestuk, BASS_SYNC_END, 0, @PlayPerestukIsEnd, nil);
        except
        end;
      end;

      // Блок проверки изменений скорости локомотива для перестука грузовых вагонов
      if (cbWagPerestuk.Checked = True) and (CoupleStat <> 0) then
      begin
        // if RadioButton2.Checked = True then begin
        // if (Acceleretion>0.03) and (Speed>0) and (PrevSpeed_Fakt=0) then begin
        // TrogF := PChar('TWS/Freight/departure.mp3');
        // isPlayTrog:=False;
        // end;
        // if (Speed in [4..10]) and (StrComp(WagF, PChar('TWS/Freight/4-10.mp3')) <> 0) then begin
        // WagF:=PChar('TWS/Freight/4-10.mp3'); isPlayWag:=False; end;
        // if (Speed in [11..20])and (StrComp(WagF, PChar('TWS/Freight/10-20.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/10-20.mp3'); isPlayWag:=False;end;
        // if (Speed in [21..30]) and(StrComp(WagF, PChar('TWS/Freight/20-30.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/20-30.mp3'); isPlayWag:=False;end;
        // if (Speed in [31..40]) and(StrComp(WagF, PChar('TWS/Freight/30-40.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/30-40.mp3'); isPlayWag:=False;end;
        // if (Speed in [41..50]) and(StrComp(WagF, PChar('TWS/Freight/40-50.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/40-50.mp3'); isPlayWag:=False;end;
        // if (Speed in [51..60]) and(StrComp(WagF, PChar('TWS/Freight/50-60.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/50-60.mp3'); isPlayWag:=False;end;
        // if (Speed in [61..70]) and(StrComp(WagF, PChar('TWS/Freight/60-70.mp3')) <> 0)then begin
        // WagF:=PChar('TWS/Freight/60-70.mp3'); isPlayWag:=False;end;
        // if (Speed > 70) and (StrComp(WagF, PChar('TWS/Freight/70-80.mp3')) <> 0) then begin
        // WagF:=PChar('TWS/Freight/70-80.mp3'); isPlayWag:=False;end;
        //
        // if Speed<1 then begin WagF:=''; BASS_ChannelStop(WagChannel); end;
        // end;

        // Блок проверки изменений скорости локомотива для перестука пассажирских вагонов
        if RadioButton1.Checked = True then
        begin
          if (Speed in [5 .. 10]) and (StrComp(WagF, PChar('TWS/Pass/5-10.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/5-10.mp3');
            isPlayWag := False;
          end;
          if (Speed in [11 .. 15]) and (StrComp(WagF, PChar('TWS/Pass/10-15.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/10-15.mp3');
            isPlayWag := False;
          end;
          if (Speed in [16 .. 20]) and (StrComp(WagF, PChar('TWS/Pass/15-20.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/15-20.mp3');
            isPlayWag := False;
          end;
          if (Speed in [21 .. 30]) and (StrComp(WagF, PChar('TWS/Pass/20-30.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/20-30.mp3');
            isPlayWag := False;
          end;
          if (Speed in [31 .. 40]) and (StrComp(WagF, PChar('TWS/Pass/30-40.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/30-40.mp3');
            isPlayWag := False;
          end;
          if (Speed in [41 .. 50]) and (StrComp(WagF, PChar('TWS/Pass/40-50.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/40-50.mp3');
            isPlayWag := False;
          end;
          if (Speed in [51 .. 60]) and (StrComp(WagF, PChar('TWS/Pass/50-60.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/50-60.mp3');
            isPlayWag := False;
          end;
          if (Speed in [61 .. 70]) and (StrComp(WagF, PChar('TWS/Pass/60-70.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/60-70.mp3');
            isPlayWag := False;
          end;
          if (Speed in [71 .. 80]) and (StrComp(WagF, PChar('TWS/Pass/70-80.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/70-80.mp3');
            isPlayWag := False;
          end;
          if (Speed in [81 .. 90]) and (StrComp(WagF, PChar('TWS/Pass/80-90.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/80-90.mp3');
            isPlayWag := False;
          end;
          if (Speed in [91 .. 100]) and (StrComp(WagF, PChar('TWS/Pass/90-100.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/90-100.mp3');
            isPlayWag := False;
          end;
          if (Speed in [101 .. 120]) and (StrComp(WagF, PChar('TWS/Pass/100-120.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/100-120.mp3');
            isPlayWag := False;
          end;
          if (Speed > 120) and (StrComp(WagF, PChar('TWS/Pass/120-140.mp3')) <> 0) then
          begin
            WagF := PChar('TWS/Pass/120-140.mp3');
            isPlayWag := False;
          end;

          if Speed < 5 then
          begin
            WagF := '';
            BASS_ChannelStop(WagChannel);
            BASS_StreamFree(WagChannel);
          end;
        end;
      end;

      // --- Обращение к модулю САВП, делаем "проход" --- //
      if LocoGlobal = 'CHS7' then
        CHS7__.step()
      else if LocoGlobal = 'CHS8' then
        CHS8__.step()
      else if LocoGlobal = 'CHS4t' then
        CHS4T__.step()
      else if LocoGlobal = 'CHS4 KVR' then
        CHS4KVR__.step()
      else if LocoGlobal = 'VL80t' then
        VL80T__.step()
      else if LocoGlobal = 'EP1m' then
        EP1M__.step()
      else if LocoGlobal = '2ES5K' then
        ES5K__.step();

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
      // Prev_KM_OP_Deg := KM_OP_Deg;
      Prev_KM_OP := KM_OP;
      PrevPerestukStation := isPlayPerestuk_OnStation;
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
      PrevBrkCyl := BrakeCylinders;
      PrevVoltage := Voltage;
      Prev_KMAbs := KM_Pos_1;
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
      PrevSvistok := Svistok;
      PrevTifon := Tifon;
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
      svistokVolume := 5 / (WagsNum + LocoSectionsNum) * svistokVolume;
    BASS_ChannelSetAttribute(SvistokCycleChannel, BASS_ATTRIB_VOL, svistokVolume);
  end;
end;

procedure TFormMain.TWS_PlaySvistok(FileName: String);
begin
  try
    BASS_ChannelStop(SvistokChannel);
    BASS_StreamFree(SvistokChannel);
    SvistokChannel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DEFAULT_FLAG);
    BASS_ChannelPlay(SvistokChannel, True);
    var
    svistokVolume := 0.01 * FormMain.trcBarSignalsVol.Position;
    if Camera = 2 then
      svistokVolume := 5 / (WagsNum + LocoSectionsNum) * svistokVolume;
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
    BASS_ChannelStop(SvistokCycleChannel);
    BASS_StreamFree(SvistokCycleChannel);
    SvistokCycleChannel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, LOOP_FLAG);
    BASS_ChannelPlay(SvistokCycleChannel, True);
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
      tifonVolume := 5 / (WagsNum + LocoSectionsNum) * tifonVolume;
    BASS_ChannelSetAttribute(TifonCycleChannel, BASS_ATTRIB_VOL, tifonVolume)
  end;
end;

procedure TFormMain.TWS_PlayTifon(FileName: String);
begin
  try
    BASS_ChannelStop(TifonChannel);
    BASS_StreamFree(TifonChannel);
    TifonChannel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, DEFAULT_FLAG);
    BASS_ChannelPlay(TifonChannel, True);
    var
    tifonVolume := 0.01 * FormMain.trcBarSignalsVol.Position;
    if Camera = 2 then
      tifonVolume := 5 / (WagsNum + LocoSectionsNum) * tifonVolume;
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
    BASS_ChannelStop(TifonCycleChannel);
    BASS_StreamFree(TifonCycleChannel);
    TifonCycleChannel := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, LOOP_FLAG);
    BASS_ChannelPlay(TifonCycleChannel, True);
    BASS_ChannelSetAttribute(TifonCycleChannel, BASS_ATTRIB_VOL, 0);
    BASS_ChannelStop(Tifon);
    BASS_StreamFree(Tifon);
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
  // BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, 0.01 * LocoVolume);
  // BASS_ChannelSetAttribute(LocoChannel, BASS_ATTRIB_VOL, 0.01 * LocoVolume2);
  // Dec(LocoVolume);
  // inc(LocoVolume2);
  //
  // if LocoVolume <= 0 then
  // begin
  // BASS_ChannelStop(LocoChannel);
  // BASS_StreamFree(LocoChannel);
  // end;
  //
  // PerehodLoco := False;
  // end;
  // ******************************************** //
  // ПЕРЕХОД МЕЖДУ ДОРОЖКАМИ ТЕД-ов //
  if PerehodTED = True then
  begin
    if TEDVolume > TEDVlm then
      TEDVolume := TEDVlm
    else if TEDVolume < 0 then
      TEDVolume := 0;
    if TEDVolume2 > TEDVlm then
      TEDVolume2 := TEDVlm
    else if TEDVolume2 < 0 then
      TEDVolume2 := 0;
    if ChannelNumTED = 0 then
    begin
      try
        BASS_ChannelGetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVolume);
      except
        TEDVolume := 0;
      end;
      try
        BASS_ChannelGetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVolume2);
      except
        TEDVolume2 := TEDVlm;
      end;
      if TEDVolume > 0 then
        TEDVolume := TEDVolume - PerehodTEDStep;
      if TEDVolume2 < TEDVlm then
        TEDVolume2 := TEDVolume2 + PerehodTEDStep * 2;
      BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVolume);
      BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVolume2);
      if (TEDVolume <= 0) and (TEDVolume2 >= TEDVlm) then
      begin
        PerehodTED := False;
        BASS_ChannelStop(TEDChannel);
        BASS_StreamFree(TEDChannel);
        BASS_ChannelStop(TEDChannel_FX);
        BASS_StreamFree(TEDChannel_FX);
      end;
    end;
    if ChannelNumTED = 1 then
    begin
      try
        BASS_ChannelGetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVolume);
      except
        TEDVolume := 0;
      end;
      try
        BASS_ChannelGetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVolume2);
      except
        TEDVolume2 := TEDVlm;
      end;
      if TEDVolume > 0 then
        TEDVolume := TEDVolume - PerehodTEDStep;
      if TEDVolume2 < TEDVlm then
        TEDVolume2 := TEDVolume2 + PerehodTEDStep * 2;
      BASS_ChannelSetAttribute(TEDChannel2, BASS_ATTRIB_VOL, TEDVolume);
      BASS_ChannelSetAttribute(TEDChannel_FX, BASS_ATTRIB_VOL, TEDVolume2);
      if (TEDVolume <= 0) and (TEDVolume2 >= TEDVlm) then
      begin
        PerehodTED := False;
        BASS_ChannelStop(TEDChannel2);
        BASS_StreamFree(TEDChannel2);
      end;
    end;
  end;
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
  if StartVentVU = True then
  begin
    BASS_ChannelGetAttribute(VentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
    if VentVolume < 0.01 * trcBarVspomMahVol.Position then
    begin
      VentVolume := VentVolume + 0.01;
      BASS_ChannelSetAttribute(VentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
      BASS_ChannelSetAttribute(XVentCycle_Channel, BASS_ATTRIB_VOL, VentVolume);
    end
    else
    begin
      StartVentVU := False;
    end;
  end;
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
  // **************************** //
  With CHS8__ do
  begin
    if isStartUnipuls = True then
    begin
      BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0.01 * UnipulsFaktVol);
      inc(UnipulsFaktVol);
      if UnipulsFaktVol = UnipulsTargetVol then
        isStartUnipuls := False;
    end;
    if isStopUnipuls = True then
    begin
      BASS_ChannelSetAttribute(Unipuls_Channel[UnipulsChanNum], BASS_ATTRIB_VOL, 0.01 * UnipulsFaktVol);
      Dec(UnipulsFaktVol);
      if UnipulsFaktVol = UnipulsTargetVol then
      begin
        isStopUnipuls := False;
        BASS_ChannelStop(Unipuls_Channel[UnipulsChanNum]);
        BASS_StreamFree(Unipuls_Channel[UnipulsChanNum]);
        UnipulsFaktPos := 0;
        UnipulsTargetPos := 0;
      end;
    end;
  end;
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
  // Если мы на станции, то интервал радиостанции - меньше
  if (isPlayPerestuk_OnStation = True) then
    timerPRSswitcher.Interval := 180000
  else
  begin
    Randomize;
    Randomize;
    timerPRSswitcher.Interval := 350000 + Random(150000);
  end;
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

  if isConnectedMemory = True then
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
  begin
    InitializeStartParams(I);
  end;

  VersionID := I;
end;

/// ///////////////////////////////////////////////////////////////////////////////////
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

procedure TFormMain.timerPlayPerestukTimer(Sender: TObject);
begin
  if Speed >= 3 then
  begin
    if (BASS_ChannelIsActive(LocoChannelPerestuk) = 0) then
    begin
      shouldPlayPerestuk := True;
      timerPlayPerestuk.Enabled := False;
    end;
    Randomize;
    Randomize;
    Randomize;
    if isPlayPerestuk_OnStation = True then
    begin
      timerPlayPerestuk.Interval := 10000;
    end
    else
    begin
      timerPlayPerestuk.Interval := 35000 + Random(Speed * 40);
    end;
  end;
end;

// === Нажатие на чекбокс "Звук трения колодок при торможении" === //
procedure TFormMain.cbBrakingSoundsClick(Sender: TObject);
begin
  if cbBrakingSounds.Checked = False then
  begin
    BASS_ChannelStop(BrakeChannel);
    BASS_StreamFree(BrakeChannel);
  end
  else
    BrakeCylinders := 0.0;
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

// ------------------------------------------------------------------------------//
// Нажатие на чекбокс блок ЭПЛ2т (информатор УЗ)                 //
// ------------------------------------------------------------------------------//
procedure TFormMain.cbEPL2TBlockClick(Sender: TObject);
var
  SR: TSearchRec;
begin
  // if cbEPL2TBlock.Checked=True then begin
  // cbSAVPESounds.Checked := False;cbSAUTSounds.Checked:=False;cbUSAVPSounds.Checked:=False;cbGSAUTSounds.Checked:=False;
  //
  // groupBoxLocoSndCheckboxes.Left:=groupBoxLocoSndCheckboxes.Left+groupBoxSOVIDescription.Width;
  // groupBoxSAVPCheckboxes.Left:=groupBoxSAVPCheckboxes.Left+groupBoxSOVIDescription.Width;
  // groupBoxPRSCheckboxes.Left:=groupBoxPRSCheckboxes.Left+groupBoxSOVIDescription.Width;
  // lblSimulatorVersionLaunched.Left:=lblSimulatorVersionLaunched.Left+groupBoxSOVIDescription.Width;
  // Label5.Left:=Label5.Left+groupBoxSOVIDescription.Width;
  // panelPasswagSounds.Left:=panelPasswagSounds.Left+groupBoxSOVIDescription.Width;
  // groupBoxSOVIDescription.Visible:=True;
  // FormMain.ClientWidth:=FormMain.ClientWidth+groupBoxSOVIDescription.Width;
  //
  // isSpeedLimitRouteLoad:=False;
  // SAVPName := 'EPL2T';
  //
  // if FindFirst('TWS/SOVI_INFORMATOR/Info/*.*',faAnyFile,sr)=0 then
  // repeat
  // if (sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then
  // ComboBox3.Items.Add(SR.Name);
  // until Findnext(sr)<>0;
  // FindClose(sr);
  // ComboBox3.ItemIndex:=0;
  // ComboBox3Change(cbEPL2TBlock);
  //
  // //Load_TWS_SAVP_EK();
  // end else begin
  // groupBoxLocoSndCheckboxes.Left:=groupBoxLocoSndCheckboxes.Left-groupBoxSOVIDescription.Width;
  // groupBoxSAVPCheckboxes.Left:=groupBoxSAVPCheckboxes.Left-groupBoxSOVIDescription.Width;
  // groupBoxPRSCheckboxes.Left:=groupBoxPRSCheckboxes.Left-groupBoxSOVIDescription.Width;
  // lblSimulatorVersionLaunched.Left:=lblSimulatorVersionLaunched.Left-groupBoxSOVIDescription.Width;
  // Label5.Left:=Label5.Left-groupBoxSOVIDescription.Width;
  // panelPasswagSounds.Left:=panelPasswagSounds.Left-groupBoxSOVIDescription.Width;
  // groupBoxSOVIDescription.Visible:=False;
  // FormMain.ClientWidth:=FormMain.ClientWidth-groupBoxSOVIDescription.Width;
  //
  // BASS_ChannelStop(SAUTChannelObjects); BASS_StreamFree(SAUTChannelObjects);
  // BASS_ChannelStop(SAUTChannelObjects2); BASS_StreamFree(SAUTChannelObjects2);
  // BASS_ChannelStop(SAUTChannelZvonok); BASS_StreamFree(SAUTChannelZvonok);
  // UpdateInfoName;
  // end;
end;

// ------------------------------------------------------------------------------//
// Нажатие на чекбокс САВПЭ                           //
// ------------------------------------------------------------------------------//
procedure TFormMain.cbSAVPESoundsClick(Sender: TObject);
var
  SR: TSearchRec;
begin
  // if cbSAVPESounds.Checked=True then begin
  // RefreshMVPSType();
  //
  // SAVPName := 'SAVPE';
  // cbSAUTSounds.Checked:=False;
  // cbGSAUTSounds.Checked:=False;
  // cbUSAVPSounds.Checked:=False;
  // cbEPL2TBlock.Checked:=False;
  // SAUTOFFF:='TWS/INFO/USAVP_podskazka.mp3';
  // isSpeedLimitRouteLoad:=False;SAUTOff:=True;
  //
  // groupBoxLocoSndCheckboxes.Left:=groupBoxLocoSndCheckboxes.Left+groupBoxSAVPEbox.Width;
  // groupBoxSAVPCheckboxes.Left:=groupBoxSAVPCheckboxes.Left+groupBoxSAVPEbox.Width;
  // groupBoxPRSCheckboxes.Left:=groupBoxPRSCheckboxes.Left+groupBoxSAVPEbox.Width;
  // lblSimulatorVersionLaunched.Left:=lblSimulatorVersionLaunched.Left+groupBoxSAVPEbox.Width;
  // Label5.Left:=Label5.Left+groupBoxSAVPEbox.Width;
  // panelPasswagSounds.Left:=panelPasswagSounds.Left+groupBoxSAVPEbox.Width;
  // groupBoxSAVPEbox.Visible := True;
  // FormMain.ClientWidth:=FormMain.ClientWidth+groupBoxSAVPEbox.Width;
  //
  // if FindFirst('TWS/SAVPE_INFORMATOR/Info/*.*',faAnyFile,sr)=0 then
  // repeat
  // if (sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then
  // ComboBox1.Items.Add(SR.Name);
  // until Findnext(sr)<>0;
  // FindClose(sr);
  // end;
  // ComboBox1.ItemIndex:=0;
  // ComboBox1Change(cbSAVPESounds);
  //
  // if cbSAVPESounds.Checked=False then begin
  // SAVPEEnabled := False;
  //
  // BASS_ChannelStop(SAUTChannelObjects); BASS_StreamFree(SAUTChannelObjects);
  // BASS_ChannelStop(SAUTChannelZvonok); BASS_StreamFree(SAUTChannelZvonok);
  // BASS_ChannelStop(SAVPE_INFO_Channel); BASS_StreamFree(SAVPE_INFO_Channel);
  // BASS_ChannelStop(SAVPE_Peek_Channel); BASS_StreamFree(SAVPE_Peek_Channel);
  //
  // groupBoxSAVPEbox.Visible := False;
  // groupBoxLocoSndCheckboxes.Left:=groupBoxLocoSndCheckboxes.Left-groupBoxSAVPEbox.Width;
  // groupBoxSAVPCheckboxes.Left:=groupBoxSAVPCheckboxes.Left-groupBoxSAVPEbox.Width;
  // groupBoxPRSCheckboxes.Left:=groupBoxPRSCheckboxes.Left-groupBoxSAVPEbox.Width;
  // lblSimulatorVersionLaunched.Left:=lblSimulatorVersionLaunched.Left-groupBoxSAVPEbox.Width;
  // Label5.Left:=Label5.Left-groupBoxSAVPEbox.Width;
  // panelPasswagSounds.Left:=panelPasswagSounds.Left-groupBoxSAVPEbox.Width;
  // FormMain.ClientWidth:=FormMain.ClientWidth-groupBoxSAVPEbox.Width;
  // UpdateInfoName;
  // end;
end;

procedure TFormMain.ComboBox3Change(Sender: TObject);
var
  SR: TSearchRec;
  TempSc: TStringList;
begin
  // ComboBox4.Items.Clear;
  // TempSc := TStringList.Create;
  // if FindFirst('TWS/SOVI_INFORMATOR/Info/'+ComboBox3.Items[ComboBox3.ItemIndex]+'/*.TWS',faAnyFile,sr)=0 then
  // repeat
  // if (sr.Attr <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then begin
  // ComboBox4.Items.Add(SR.Name)
  // end;
  // until Findnext(sr)<>0;
  // FindClose(sr);
end;

procedure TFormMain.ComboBox4Change(Sender: TObject);
begin
  // LoadSOVI_EK('TWS/SOVI_INFORMATOR/Info/'+ComboBox3.Items[ComboBox3.ItemIndex]+'/'+ComboBox4.Items[ComboBox4.ItemIndex]);
end;

procedure TFormMain.ComboBox1Change(Sender: TObject);
var
  SR: TSearchRec;
  TempSc: TStringList;
  PrevIndx, PrevParIndx: Integer;
begin
  // PrevIndx := ComboBox2.ItemIndex;
  // PrevParIndx := ComboBox1.ItemIndex;
  // ComboBox2.Items.Clear;
  // ComboBox2.Items.Add(Utf8ToAnsi('< Без ЭК >'));
  // ComboBox2.Sorted := True;
  // TempSc := TStringList.Create;
  // if FindFirst('TWS/SAVPE_INFORMATOR/Info/'+ComboBox1.Items[ComboBox1.ItemIndex]+'/*.TWS',faAnyFile,sr)=0 then
  // repeat
  // if (sr.Attr <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then begin
  // if (Pos('sc_', SR.Name))=0 then
  // ComboBox2.Items.Add(SR.Name) else
  // TempSc.Add(Sr.Name);
  // end;
  // until Findnext(sr)<>0;
  // FindClose(sr);
  // ComboBox2.Sorted:=False;
  // ComboBox2.Items.AddStrings(TempSc);
  //
  // try
  // if (ComboBox1.ItemIndex = PrevParIndx) and (PrevIndx>=0) then
  // ComboBox2.ItemIndex := PrevIndx
  // else
  // ComboBox2.ItemIndex := 0;
  // except end;
  // ComboBox2Change(ComboBox1);
end;

// === Нажатие на чекбокс "Звуки вспомогательных машин" === //
procedure TFormMain.cbVspomMashClick(Sender: TObject);
begin
  if cbVspomMash.Checked = False then
  begin
    BASS_ChannelStop(Unipuls_Channel[0]);
    BASS_StreamFree(Unipuls_Channel[0]);
    BASS_ChannelStop(Unipuls_Channel[1]);
    BASS_StreamFree(Unipuls_Channel[1]);
    With CHS8__ do
    begin
      UnipulsFaktVol := 0;
      UnipulsTargetVol := 0;
      UnipulsTargetPos := 0;
      UnipulsFaktPos := 0;
    end;
    timerPerehodUnipulsSwitch.Enabled := False;

    BASS_ChannelStop(Compressor_Channel);
    BASS_StreamFree(Compressor_Channel);
    BASS_ChannelStop(Vent_Channel);
    BASS_StreamFree(Vent_Channel);
    BASS_ChannelStop(VentCycle_Channel);
    BASS_StreamFree(VentCycle_Channel);
    BASS_ChannelStop(VentTD_Channel);
    BASS_StreamFree(VentTD_Channel);
    BASS_ChannelStop(VentCycleTD_Channel);
    BASS_StreamFree(VentCycleTD_Channel);
    BASS_ChannelStop(XVent_Channel);
    BASS_StreamFree(XVent_Channel);
    BASS_ChannelStop(XVentCycle_Channel);
    BASS_StreamFree(XVentCycle_Channel);
    BASS_ChannelStop(XVentTD_Channel);
    BASS_StreamFree(XVentTD_Channel);
    BASS_ChannelStop(XVentCycleTD_Channel);
    BASS_StreamFree(XVentCycleTD_Channel);
  end;
end;

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
    BASS_ChannelStop(SvistokChannel);
    BASS_StreamFree(SvistokChannel);
    BASS_ChannelStop(SvistokCycleChannel);
    BASS_StreamFree(SvistokCycleChannel);
    BASS_ChannelStop(TifonChannel);
    BASS_StreamFree(TifonChannel);
    BASS_ChannelStop(TifonCycleChannel);
    BASS_StreamFree(TifonCycleChannel);
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
