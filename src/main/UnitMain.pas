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
  Windows, Messages, SysUtils, Graphics, Forms, Dialogs, StdCtrls, ComCtrls, Menus, IdBaseComponent, IdCoder,
  IdCoder3to4, IdCoderMIME, ExtCtrls, Controls, Classes, Bass, inifiles, UnitAuthors, TlHelp32, ShellApi, Grids,
  ValEdit, jpeg, UnitSAVPEHelp, Math, UnitUSAVP, EncdDecd, SAVP, Ram, ExtraUtils,
  SoundManager, bass_fx, UnitSOVIHelp, CHS8, CHS4KVR, CHS7, CHS4T, VL80T, ES5K, EP1M;

type
  TFormMain = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo8: TMemo;
    ClockMain: TTimer;
    timerSoundSlider: TTimer;
    timerPRSswitcher: TTimer;
    timerVigilanceUSAVPDelay: TTimer;
    timerPerehodUnipulsSwitch: TTimer;
    timerSearchSimulatorWindow: TTimer;
    IdDecoderMIME1: TIdDecoderMIME;
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

    procedure timerVigilanceUSAVPDelayTimer(Sender: TObject);
    procedure ClockMainTimer(Sender: TObject);
    procedure timerSearchSimulatorWindowTimer(Sender: TObject);
    procedure timerPRSswitcherTimer(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function CheckInstallation(): Boolean;

  private
  public
  end;

type
  ProcReadDataMemoryType = procedure() of object;

var
  // Game
  GameScreen: HWND;
  GameWindowName: String;
  wHandle: Integer;
  tHandle, ProcessID, pHandle: Cardinal;
  temp: Cardinal;

  FormMain: TFormMain;
  MainCycleFreq: Integer;
  ResPotok: TMemoryStream;
  VersionID: Byte;

  // Flags
  ConnectedMemory: TValue<Boolean>;
  isGameOnPause: TValue<Boolean>;

  // settings.ini
  Ini: TIniFile;
  Route: String;
  Freight: Byte;
  ConName: String;
  SceneryName: String;
  LocoNum: Integer;
  Winter: Byte;
  LocoGlobal: String;
  LocoWorkDir: String;

  // start_kilometers.dat
  Stations: TArray<TStation>;
  StationCount: Byte = 0;
  IsOnStation: Boolean;

  // SVT
  Acceleretion: TValue<Double>;
  SpeedFakt: Double;
  Speed: TValue<Double>;
  Ordinate: TValue<Double>;
  OutsideLocoStatus: WORD;
  Track: TValue<Integer>;
  TrackTail: Integer;
  Naprav: String;
  NapravOrdinata: String;
  NapravSign: short = 1;

  // Misc
  Svetofor: TValue<Byte>;
  SvetoforDist: TValue<WORD>;
  ZvonVolume: Extended;
  ZvonTrack: Integer;
  ZvonokVolume: Single;
  ZvonokVolumeDest: Single;
  ZvonokFreq: Double;
  Rain: TValue<Byte>;
  Camera: TValue<TCamera>;

  // Loco
  CHS7__: chs7_;
  PrevPRSIdx: Byte;

  CoupleStat: TValue<Byte>;
  WindowsOpenState: TValue < array [0 .. 1] of Boolean >;

  TEDAmperage: TValue<Single>;
  EDTAmperage: TValue<Single>;
  UltimateTEDAmperage: Integer;
  ABZ1, ABZ2: TValue<Byte>;
  Voltage: TValue<Single>;

  RB: TValue<Byte>;
  RBS: TValue<Byte>;
  EPT: TValue<Byte>;
  BV: TValue<Byte>;
  Zhalusi: TValue<Byte>;
  Stochist: TValue<Single>;
  StochistDGR: TValue<Double>;
  VCheck: TValue<Byte>;
  Highlights: TValue<Byte>;
  PickKLUB: TValue<Integer>;
  Reostat: TValue<Byte>;
  EPK: TValue<Boolean>;
  Boks: TValue<Byte>;

  KM395: TValue<Byte>;
  KM254: TValue<Single>;
  PneumaticTM: TValue<Single>;
  PneumaticUR: TValue<Single>;
  PneumaticNAP: TValue<Single>;
  PneumaticDT: TValue<Single>;
  PneumaticTC: TValue<Single>;
  IsCombinedOpened: Boolean;

  LocoWithSndReversor: Boolean;
  LocoSndReversorType: Byte;
  Reversor: TValue<Integer>;
  KMState: TValue<TKMStateIDEnum>;
  KM1: TValue<Integer>;
  KM2: TValue<Byte>;
  KMOP: TValue<Single>;

  svistok: Byte;
  tifon: Byte;

  MVs: TValue<Byte>;
  MVsTD: TValue<Byte>;
  MKs: array [0 .. 1] of TValue<Single>;
  MVsTDPitch: Single = -20;
  MVsTDPitchDest: Single = -20;
  MVsTDPitchIncrementer: Single;
  MVsTDVolDest: Single = 0;
  MVsPitchDest: Single;
  MVsPitchIncrementer: Single;

  FrontTP: TValue<Integer>;
  BackTP: TValue<Integer>;

  VentSingleVolume: Single;
  VentSingleVolumeIncrementer: Extended;

  // Consist
  Consist: TConsist;
  PassWagonUnit: TConsistUnit;
  FreightWagonUnit: TConsistUnit;

  // Klub
  KLUBOpen: Byte;
  PrevKeyLKM: Byte;
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
  OgrSpeed: TValue<WORD>;
  NextOgrSpeed: TValue<Byte>;
  NextOgrPeekStatus: Byte;

implementation

uses StrUtils, Variants;

{$R *.dfm}
/// /////////////////////////////////////////////////////////////////////////////////

// Refresh local data
procedure RefreshLocalData(Memo1: TMemo);
begin
  Speed.current := 0;

  try
    InitializeStartParams(VersionID);
    GetStartSettingParamsFromRAM();
    InitializeConsist(Memo1, LocoGlobal, LocoWorkDir, Consist, PassWagonUnit, FreightWagonUnit);

    if Route <> '' then
    begin
      if SceneryName <> '<No>' then
        ReadVstrech(Route, SceneryName);
      ReadStations(Route, Stations, StationCount);
    end;

    if Naprav = '2' then
      NapravSign := -1;

    InitSoundManager(Consist.Loco, Consist.AxesAmt);
  except
  end;

  if scSAVPOverrideRouteEK = False then
    Load_TWS_SAVP_EK();
end;

procedure UpdateValues();
var
  OrdinateDelta: Double;
begin
  if Consist.Loco = 'CHS7' then
    CHS7__.step();

  // Station
  IsOnStation := checkOnStation(Track.current);

  // Smoothed speed
  Speed.current := Speed.current + 0.0055 * Acceleretion.current * FormMain.ClockMain.Interval;
  if (Abs(SpeedFakt - Speed.current) > 1) or (SpeedFakt = 0) and (Acceleretion.current = 0) then
    Speed.current := SpeedFakt;

  // Ordinate
  if Ordinate.previous < Ordinate.current then
    NapravOrdinata := 'Tuda'
  else if Ordinate.previous > Ordinate.current then
    NapravOrdinata := 'Obratno';

  OrdinateDelta := 0.000278 * Speed.current * MainCycleFreq;
  if NapravOrdinata = 'Obratno' then
    OrdinateDelta := -OrdinateDelta;
  Ordinate.current := Ordinate.current + OrdinateDelta;

  // Widnows
  if (GetAsyncKeyState(55) <> 0) and (GetAsyncKeyState(16) <> 0) then
    WindowsOpenState.current[0] := True
  else if (GetAsyncKeyState(55) <> 0) then
    WindowsOpenState.current[0] := False;

  if (GetAsyncKeyState(56) <> 0) and (GetAsyncKeyState(16) <> 0) then
    WindowsOpenState.current[1] := True
  else if (GetAsyncKeyState(56) <> 0) then
    WindowsOpenState.current[1] := False;

  // Prev-values
  Speed.previous := Speed.current;
  OgrSpeed.previous := OgrSpeed.current;
  NextOgrSpeed.previous := NextOgrSpeed.current;
  Acceleretion.previous := Acceleretion.current;
  Ordinate.previous := Ordinate.current;

  KM395.previous := KM395.current;
  KM254.previous := KM254.current;
  KM1.previous := KM1.current;
  KM2.previous := KM2.current;
  KMOP.previous := KMOP.current;
  KMState.previous := KMState.current;
  FrontTP.previous := FrontTP.current;
  BackTP.previous := BackTP.current;
  BV.previous := BV.current;
  Reostat.previous := Reostat.current;
  Reversor.previous := Reversor.current;
  TEDAmperage.previous := TEDAmperage.current;
  EDTAmperage.previous := EDTAmperage.current;
  PneumaticTM.previous := PneumaticTM.current;
  PneumaticUR.previous := PneumaticUR.current;
  PneumaticDT.previous := PneumaticDT.current;
  PneumaticTC.previous := PneumaticTC.current;
  EPK.previous := EPK.current;
  Voltage.previous := Voltage.current;
  VCheck.previous := VCheck.current;
  Stochist.previous := Stochist.current;
  StochistDGR.previous := StochistDGR.current;
  ABZ1.previous := ABZ1.current;
  ABZ2.previous := ABZ2.current;
  EPT.previous := EPT.current;
  Zhalusi.previous := Zhalusi.current;
  Highlights.previous := Highlights.current;
  RB.previous := RB.current;
  RBS.previous := RBS.current;
  Boks.previous := Boks.current;
  MVs.previous := MVs.current;
  MVsTD.previous := MVsTD.current;
  MKs[0].previous := MKs[0].current;
  MKs[1].previous := MKs[1].current;

  CoupleStat.previous := CoupleStat.current;

  Track.previous := Track.current;
  Svetofor.previous := Svetofor.current;
  SvetoforDist.previous := SvetoforDist.current;

  Rain.previous := Rain.current;
  Vstrech.Track.previous := Vstrech.Track.current;
  WindowsOpenState.previous := WindowsOpenState.current;

  Camera.previous := Camera.current;
end;


// Main cycle ////////////////////////////////////////////////////////////////////////

procedure TFormMain.ClockMainTimer(Sender: TObject);
begin
  try
    if (ConnectedMemory.current <> ConnectedMemory.previous) Or (LocoGlobal = '') then
    begin
      if ConnectedMemory.current then
      begin
        RefreshLocalData(Memo1);
        BASS_Start;
      end
      else
        Bass_Stop;
    end;

    if isGameOnPause.current <> isGameOnPause.previous then
    begin
      if Sounds <> nil then
        for var entry in Sounds do
          if entry.Key <> '' then
            for var i := 0 to length(entry.Value.channels) do
            begin
              if isGameOnPause.current then
                // entry.Value.pause(i)
              else
                entry.Value.resume(i);
            end;
    end
    else if isGameOnPause.current = False then
    begin
      if ConnectedMemory.current then
        ReadVarsFromRAM();

      // HandleTEDSounds(TEDAmperage.current, UltimateTEDAmperage, EDTAmperage.current, KM1.current);
      // HandleReduktorSounds(TEDAmperage.current, UltimateTEDAmperage, EDTAmperage.current, Speed.current);
      // HandleNatureSounds(Rain, Track.current, OutsideLocoStatus);
      // HandleMiscSounds(RB, RBS, KM395, KM254, EPK, KM1, Reostat, Voltage, LocoWithSndReversor, LocoSndReversorType,
      // Reversor, Stochist, StochistDGR);
      // Handle3SL2mSounds(Speed);
      // HandleSignals(svistok);
      // HandleSignals(tifon, True);
      // HandleMKSounds(MKs[0]);
      // HandleMKSounds(MKs[0], '1', True);
      // HandleMKSounds(MKs[1], '2', True);
      // HandleMVSounds(MVs);
      // HandleMVSounds(MVsTD, 'TD');
      // HandleTPSounds(FrontTP, BackTP);
      // HandleKMReversSounds(KMState, KMOP);
      // HandlePneumaticSounds(KM395, KM254, PneumaticTM, PneumaticUR, PneumaticNAP, PneumaticDT, PneumaticTC);
      // HandleBrakeSounds(PneumaticTC.current, PneumaticDT.current, Speed.current, EDTAmperage.current);
      // HandleEzda(Speed.current);
      // HandlePerestuk(Hodovaya, Speed.current, Track, Consist);
      // HandleMVPitch();
      Vstrech.Handle(NapravSign, Ordinate, Track.current, Ordinate.current, Consist.length, Speed.current,
        FreightWagonUnit, PassWagonUnit);

      // SAVPTick();

      UpdateValues();
    end;

    ConnectedMemory.previous := ConnectedMemory.current;
    isGameOnPause.previous := isGameOnPause.current;
  except
  end;
end;

// End of main cycle ///////////////////////////////////////////////////////////////////
// Aux

// Close app
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Bass_Stop();
    Bass_Free();
  except
  end;
end;

// Open app
procedure TFormMain.FormCreate(Sender: TObject);
begin
  BASS_Init(-1, 44100, 0, application.Handle, nil);
  CHS7__ := chs7_.Create;
  isGameOnPause.current := True;
  MainCycleFreq := ClockMain.Interval;
  SAVP.InitializeSAVP;
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

// Timers

// PRS
procedure TFormMain.timerPRSswitcherTimer(Sender: TObject);
begin
  if isGameOnPause.current = False then
  begin
    if IsOnStation then
      timerPRSswitcher.Interval := 180000
    else
    begin
      randomize;
      randomize;
      timerPRSswitcher.Interval := 350000 + random(150000);
    end;
    HandlePRSSounds(PrevPRSIdx);
  end;
end;

// Vigilance
procedure TFormMain.timerVigilanceUSAVPDelayTimer(Sender: TObject);
begin
  timerVigilanceUSAVPDelay.Enabled := False;
end;

// ZDSimulator check timer
procedure TFormMain.timerSearchSimulatorWindowTimer(Sender: TObject);
var
  i: Integer;
begin
  ConnectedMemory.current := FindTask('Launcher.exe'); // Проверка запущен-ли симулятор?

  if ConnectedMemory.current then
  begin
    for i := 0 to 2 do
    begin
      if i = 0 then
        GameWindowName := 'ZDSimulator55.008';
      if i = 1 then
        GameWindowName := 'ZDSimulator54.006';
      if i = 2 then
        GameWindowName := 'viewer';
      wHandle := FindWindow(nil, PChar(GameWindowName + ' [Paused]'));
      if wHandle <> 0 then
      begin
        isGameOnPause.current := True;
        ConnectedMemory.current := True;
        Break;
      end
      else
      begin
        wHandle := FindWindow(nil, PChar(GameWindowName));
        if wHandle = 0 then
        begin
          isGameOnPause.current := True;
          ConnectedMemory.current := False;
        end
        else
        begin
          tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
          pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
          isGameOnPause.current := False;
          CloseHandle(pHandle);
          ConnectedMemory.current := True;
          if i = 2 then
            ClockMain.Enabled := False;
          Break;
        end;
      end;
      CloseHandle(wHandle);
    end;
  end
  else
    isGameOnPause.current := True;

  if i <> VersionID then
    InitializeStartParams(i);

  VersionID := i;
end;

end.
