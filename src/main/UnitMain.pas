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
    timerSoundSlider: TTimer;
    timerPRSswitcher: TTimer;
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
  Svetofor: TValue<Byte>; // Показания светофора (код сигнала)
  SvetoforDist: TValue<WORD>; // Расстояние до свотофора

  // Misc
  CoupleStat: TValue<Byte>;
  Rain: TValue<Byte>; // Переменные интенсивности дождя

  // Camera
  Camera: TValue<Byte>; // Переменные для определения типа камеры
  CameraX: TValue<WORD>; // Переменные для определения положения головы в кабине

  // Loco
  RB: TValue<Byte>;
  RBS: TValue<Byte>;
  EPT: TValue<Byte>;
  BV: TValue<Byte>;
  Voltage: TValue<Single>;
  Zhaluzi: TValue<Byte>;
  Stochist: TValue<Single>;
  StochistDGR: TValue<Double>;
  VCheck: TValue<Byte>;
  Highlights: TValue<Byte>;
  PickKLUB: TValue<Integer>;
  Reostat: TValue<Byte>;
  Compressors: array [0 .. 1] of Single;
  EPK: TValue<Boolean>;
  KM395: TValue<Byte>;
  KM294: TValue<Single>;
  PneumaticTM: TValue<Single>;
  PneumaticUR: TValue<Single>;
  PneumaticNAP: TValue<Single>;
  PneumaticDT: TValue<Single>;
  PneumaticTC: TValue<Single>;
  IsCombinedOpened: Boolean;

  Reversor: TValue<Integer>;
  KMState: TValue<TKMStateEnum>;
  KM1: TValue<Integer>;
  KM2: TValue<Byte>;
  KMOP: TValue<Single>;

  Signals: array [0 .. 1] of Byte; // Svistok-Tifon

  MVs: Byte; // Состояние Вентиляторов [1]
  MVsTD: Byte; // Состояние Вентиляторов [1]
  VentTDPitch: Single = -20; // Вентиляторы ТД (ПТР) тональность
  VentTDPitchDest: Single = -20; // Желаемая тональность вентов ТД (ПТР) для плавного увеличения/уменьшения
  VentTDPitchIncrementer: Single; // Инкрементер тональности для МВ ТД
  VentTDVolDest: Single = 0;
  VentPitchDest: Single;
  VentPitchIncrementer: Single; // Инкрементер тональности для МВ
  AxesDistancesLoco: array of Integer = [3200, 4700, 3200, 5820, 3200, 4700, 3200, 3010];
  AxesDistancesWagon: array of Integer = [2570, 2400, 15600, 2400];
  AxesLocoAmount: Integer;
  AxesAmount: Integer;

  // TP
  FrontTP: TValue<Integer>; // Состояние заднего ТП
  BackTP: TValue<Integer>; // Состояние заднего ТП

  // Vstrech
  VstrTrack: TValue<WORD>; // Переменные ординаты встречки
  TrackVstrechi: Integer; // Трэк на котором произошла встреча нашего состава с встречным
  VstrechStatusCounter: Integer;
  VstrechStatus: TValue<Byte>;
  VstrechaDlina: Integer;
  isVstrechDrive: Boolean;

  // SVT
  Acceleretion: TValue<Double>; // Ускорение м/(с^2)
  Speed: TValue<Double>; // Скорость
  OgrSpeed: TValue<WORD>; // Ограничение скорости
  NextOgrSpeed: TValue<Byte>; // Следующее ограничение скорости (желтая точка на КЛУБ-е)
  NextOgrPeekStatus: Byte; // Статус для пиканья про снижение ограничения [0-нет снижения 1-в процессе]
  Ordinata: TValue<Double>;
  OrdinataEstimate: TValue<Double>;
  OutsideLocoStatus: WORD;

  // Klub
  PrevPRS: Integer;
  KLUBOpen: Byte; // Переменная-флаг открыта-ли в игре клавиатура КЛУБ
  TrackTail: Integer; // Номер трэка хвоста нашего поезда

  // Debug
  DebugFile: TextFile;

  // Sounds
  Track: TValue<Integer>;
  Ini: TIniFile; // Ini файл настроек
  EDTAmperage: TValue<Single>;
  VstrVolume: Integer;
  TEDAmperage: TValue<Single>;
  UltimateTEDAmperage: Integer; // Предельный ток нагрузки на ТЭД-ы
  WagNumVstr: Byte;
  ABZ1, ABZ2: TValue<Byte>;
  Boks: TValue<Byte>;

  // Flags
  SAVPENextMessage: Boolean = False;
  HeadTrainEndOfTrain: Boolean;
  isCameraInCabin: Boolean; // Флаг для понимания, в кабине-ли камера?
  isRefreshLocalData: Boolean; // флаг для перезагрузки в скрипт всех данных необходимых для работы
  SAUTOff: Boolean; // Фалг для воспроизведения финального звука выключения САУТ
  ConnectedMemory: TValue<Boolean>; // Флаг для определения: удалось ли подключиться к памяти?
  isGameOnPause: Boolean; // Флаг для состояния паузы игры (сворочивание)
  VstrZat: Boolean; // Флаг для велючения затухания звука встречного поезда
  PlayRESFlag: Boolean;
  PereezdZatuh: Boolean;
  isSpeedLimitRouteLoad: Boolean;
  isNatureNowPlay: array [0 .. 4] of Boolean; // Флаг для понимания играет-ли текущая дорожка природы
  NatureOrd1: array [0 .. 4] of Integer; // Ордината начала играния дорожки природы
  NatureOrd2: array [0 .. 4] of Integer; // Ордината конца играния дорожки природы
  NatureKoefZatuh: array [0 .. 4] of Integer; // Длина затухания

  // Game
  GameScreen: HWND; // Дескриптор окна игры
  GameWindowName: String;
  wHandle: Integer;
  tHandle, ProcessID, pHandle: Cardinal;
  temp: Cardinal;

  VstrSpeed: Integer;
  ZvonokVolume: Single; // Громкость звонка на переезде
  ZvonokVolumeDest: Single;
  ZvonokFreq: Double; // Частота дискретизации звука звонка на переезде

  VentSingleVolume: Single;
  VentSingleVolumeIncrementer: Extended;

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
    // DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:=; SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'SAUT';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    freeChannel(SAUTChannelObjects);
    freeChannel(SAUTChannelObjects2);
    freeChannel(SAUTChannelZvonok);
    // SAUTOFFF := 'TWS/SAVP/SAUT/Off.wav';
    // SAUTOff := True; // Проигруем звук выключения САУТ
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
    // DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:='TWS/SAVP/USAVP/575.wav';SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'USAVPP';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    FormUSAVP.Close;
    freeChannel(SAUTChannelObjects);
    freeChannel(SAUTChannelObjects2);
    freeChannel(SAUTChannelZvonok);
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
    // DecodeResAndPlay('TWS/SAVP/USAVP/575.res', isPlaySAVPEInfo, SAVPEInfoF, SAVPE_INFO_Channel, ResPotok, PlayRESFlag);
    // SAUTOFFF:='TWS/SAVP/USAVP/575.wav'; SAUTOff:=True;
    isSpeedLimitRouteLoad := False;
    SAVPName := 'SAUT_G';
    Load_TWS_SAVP_EK();
  end
  else
  begin
    freeChannel(SAUTChannelObjects);
    freeChannel(SAUTChannelObjects2);
    freeChannel(SAUTChannelZvonok);
    // SAUTOFFF := 'TWS/SAVP/SAUT/Off.wav';
    // SAUTOff := True; // Проигруем звук выключения САУТ
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
  if cbBrakingSounds.Checked = False then
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
  end;
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
  Speed[V_PRV] := 0;

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
begin
  try
    // Проверка обновления статуса открытого симулятора
    if (ConnectedMemory[V_CUR] <> ConnectedMemory[V_PRV]) Or (LocoGlobal = '') then
    begin
      isRefreshLocalData := True;

      if ConnectedMemory[V_CUR] then
        BASS_Start
      else
        Bass_Stop;
    end;

    if isGameOnPause = False then
    begin
      if ConnectedMemory[V_CUR] then
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
        if (StationTrack1[k] < Track[V_CUR]) and (Track[V_CUR] < StationTrack2[k]) then
          IsOnStation := True;

      // Smoothed speed
      // Speed := Speed + 0.0055 * Acceleretion[V_CUR] * FormMain.ClockMain.Interval;
      // if (Abs(Speed - Speed[V_CUR]) > 1) or (Speed[V_CUR] = 0) and (Acceleretion[V_CUR] = 0) then
      // Speed := Speed[V_CUR];

      // isCameraInCabin := CameraInCabinCheck(CameraX, Camera);

      var
      delta := 0.000278 * Speed[V_CUR] * MainCycleFreq;
      if NapravOrdinata = 'Tuda' then
        OrdinataEstimate[V_CUR] := OrdinataEstimate[V_CUR] + delta
      else
        OrdinataEstimate[V_CUR] := OrdinataEstimate[V_CUR] - delta;

      // Проверяем менялись-ли показания камеры?
      if (Camera[V_CUR] <> Camera[V_PRV]) or (CameraX[V_CUR] <> CameraX[V_PRV]) then
        RefreshVolume();

      // TEDs-Reductor
      if cbTEDs.Checked and LocoWithTED then
      begin
        HandleTEDSounds(TEDChannelsFX, TEDAttrs, LocoWorkDir + TEDFile, TEDAmperage[V_CUR], UltimateTEDAmperage,
          EDTAmperage[V_CUR], KM1[V_CUR]);
        HandleReductorSounds(ReduktorChannelsFX, ReduktorAttrs, LocoWorkDir + ReduktorFile, TEDAmperage[V_CUR],
          UltimateTEDAmperage, EDTAmperage[V_CUR], Speed[V_CUR]);
      end;

      // БЛОК ЗВУКОВ ОКРУЖЕНИЯ
      if cbNatureSounds.Checked then
        HandleMiscSounds(ChannelsMisc, Rain, Track[V_CUR], OutsideLocoStatus);

      // KLUB-3SL2m
      if cbCabinClicks.Checked then
      begin
        if cbKLUBSounds.Checked then
          HandleKLUBSounds(ChannelsDefault, SkorostemerChannel, OgrSpeed, NextOgrSpeed, NextOgrPeekStatus, Speed[V_CUR],
            Svetofor, PrevKeyTAB, KLUBOpen)
        else if cb3SL2mSounds.Checked then
          Handle3SL2mSounds(ChannelsDefault, SkorostemerChannel, RB, RBS, Speed);
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
        HandleMKSounds(Compressors, MVChannelsState, MKChannelsFX, MKAttrs, LocoWorkDir);

        HandleMVSounds(MVs, MVChannelsState, MVChannelsFX, MVAttrs, LocoWorkDir);
        HandleMVSounds(MVsTD, MVTDChannelsState, MVTDChannelsFX, MVAttrs, LocoWorkDir, 'TD');

        HandleMVPitch(MVChannelsFX, MVAttrs, MVTDChannelsFX, MVTDAttrs);
      end;

      // ТП
      if cbTPSounds.Checked then
        HandleTPSounds(ChannelsDefault, LocoWithSndTP, FrontTP, BackTP);

      // ЩЕЛЧКИ
      if cbCabinClicks.Checked then
      begin
        HandleClickSounds(ChannelsDefault, ChannelsMisc, KM395, KM294, EPK, KM1, Reostat, Voltage, LocoWithSndReversor,
          LocoSndReversorType, Reversor, Stochist, StochistDGR);
        if LocoWithSndKM and (Reversor[V_CUR] <> 0) and (Reversor[V_PRV] <> 0) then
          HandleKMSounds(ChannelsDefault, KMState, KMOP);
      end;

      // 254 / 395
      if True then // TODO
        HandlePneumaticSounds(PneumaticChannelsFX, PneumaticChannelsAttrs, PneumaticTimers, PneumaticFadeInState,
          KM395[V_CUR], PneumaticTM, PneumaticUR, PneumaticNAP, PneumaticDT, PneumaticTC);

      // ТРЕНИЕ КОЛОДОК ПРИ ТОРМОЖЕНИИ
      if cbBrakingSounds.Checked then
        HandleBrakeSounds(BrakeChannelFX, BrakeAttrs, BrakeScrChannelFX, BrakeScrAttrs, PneumaticTC[V_CUR],
          Speed[V_CUR], EDTAmperage[V_CUR]);

      // ЕЗДА
      if cbLocPerestuk.Checked then
      begin
        HandleEzda(EzdaChannelFX, EzdaAttrs, ShumChannelFX, ShumAttrs, Speed[V_CUR]);
        HandlePerestuk(PerestukChannelFX, PerestukStack, PerestukStackSize, Speed[V_CUR], Track, AxesAmount,
          AxesDistancesWagon, AxesDistancesLoco, AxesLocoAmount);
      end;

      // БЛОК МНОГОСТРАДАЛЬНОГО ВСТРЕЧНОГО ПОЕЗДА
      if (cbHeadTrainSound.Checked) and (VstrTrack[V_CUR] <> 0) then
        HandleVstrech(VstrechStatus, Track[V_CUR], VstrTrack, MP, VstrSpeed, WagNumVstr, VstrechaDlina, TrackVstrechi);

      SAVPTick();
      SoundManagerTick();

      ConnectedMemory[V_PRV] := ConnectedMemory[V_CUR];

      if Ordinata[V_PRV] < Ordinata[V_CUR] then
        NapravOrdinata := 'Tuda'
      else if Ordinata[V_PRV] > Ordinata[V_CUR] then
        NapravOrdinata := 'Obratno';

      Speed[V_PRV] := Speed[V_CUR];
      OgrSpeed[V_PRV] := OgrSpeed[V_CUR];
      NextOgrSpeed[V_PRV] := NextOgrSpeed[V_CUR];
      Acceleretion[V_PRV] := Acceleretion[V_CUR];
      Ordinata[V_PRV] := Ordinata[V_CUR];

      KM395[V_PRV] := KM395[V_CUR];
      KM294[V_PRV] := KM294[V_CUR];
      KM1[V_PRV] := KM1[V_CUR];
      KM2[V_PRV] := KM2[V_CUR];
      KMOP[V_PRV] := KMOP[V_CUR];
      KMState[V_PRV] := KMState[V_CUR];
      FrontTP[V_PRV] := FrontTP[V_CUR];
      BackTP[V_PRV] := BackTP[V_CUR];
      BV[V_PRV] := BV[V_CUR];
      Reostat[V_PRV] := Reostat[V_CUR];
      Reversor[V_PRV] := Reversor[V_CUR];
      TEDAmperage[V_PRV] := TEDAmperage[V_CUR];
      EDTAmperage[V_PRV] := EDTAmperage[V_CUR];
      PneumaticTM[V_PRV] := PneumaticTM[V_CUR];
      PneumaticUR[V_PRV] := PneumaticUR[V_CUR];
      PneumaticDT[V_PRV] := PneumaticDT[V_CUR];
      PneumaticTC[V_PRV] := PneumaticTC[V_CUR];
      EPK[V_PRV] := EPK[V_CUR];
      Voltage[V_PRV] := Voltage[V_CUR];
      VCheck[V_PRV] := VCheck[V_CUR];
      Stochist[V_PRV] := Stochist[V_CUR];
      StochistDGR[V_PRV] := StochistDGR[V_CUR];
      ABZ1[V_PRV] := ABZ1[V_CUR];
      ABZ2[V_PRV] := ABZ2[V_CUR];
      EPT[V_PRV] := EPT[V_CUR];
      Zhaluzi[V_PRV] := Zhaluzi[V_CUR];
      Highlights[V_PRV] := Highlights[V_CUR];
      RB[V_PRV] := RB[V_CUR];
      RBS[V_PRV] := RBS[V_CUR];
      Boks[V_PRV] := Boks[V_CUR];

      CoupleStat[V_PRV] := CoupleStat[V_CUR];

      Track[V_PRV] := Track[V_CUR];
      Svetofor[V_PRV] := Svetofor[V_CUR];
      SvetoforDist[V_PRV] := SvetoforDist[V_CUR];

      Rain[V_PRV] := Rain[V_CUR];
      VstrechStatus[V_PRV] := VstrechStatus[V_CUR];
      VstrTrack[V_PRV] := VstrTrack[V_CUR];

      Camera[V_PRV] := Camera[V_CUR];
      CameraX[V_PRV] := CameraX[V_CUR];
    end;
  except
    // НИЧЕГО
  end;
end;

// End of main cycle ///////////////////////////////////////////////////////////////////

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
  // if VCheck[V_CUR] <> 0 then
  // DecodeResAndPlay('TWS/SAVP/USAVP/567.res', isPlaySAUTObjects, SAUTF, SAUTChannelObjects, ResPotok, PlayRESFlag);
end;

// ZDSimulator check timer
procedure TFormMain.timerSearchSimulatorWindowTimer(Sender: TObject);
var
  I: Integer;
begin
  ConnectedMemory[V_CUR] := FindTask('Launcher.exe'); // Проверка запущен-ли симулятор?

  if ConnectedMemory[V_CUR] then
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
        ConnectedMemory[V_CUR] := True;
        Label5.Caption := GameWindowName;
        break;
      end
      else
      begin
        wHandle := FindWindow(nil, PChar(GameWindowName));
        if wHandle = 0 then
        begin
          isGameOnPause := True;
          ConnectedMemory[V_CUR] := False;
          Label5.Caption := 'Симулятор не запущен';
        end
        else
        begin
          tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
          pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
          isGameOnPause := False;
          CloseHandle(pHandle);
          ConnectedMemory[V_CUR] := True;
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
