// ------------------------------------------------------------------------------//
// //
// Модуль для работы с ОЗУ           //
// (c) DimaGVRH, Dnepr city, 2019    //
// //
// ------------------------------------------------------------------------------//
unit Ram;

interface

uses Types, StdCtrls, SoundManager, Generics.Collections;

// RAM
procedure GetStartSettingParamsFromRAM();

procedure ReadVarsFromRAM();

procedure ReadDataMemoryCHS7();

// Misc
function ReadKeyFromMemoryString(readAddr: PByte; Key: String; SearchRadius: Integer): String;

function ReadStringFromMemory(readAddr: PByte; Len: byte): String;

// Init
procedure InitializeStartParams(VersionID: Integer);

procedure InitializeConsist(Memo1: TMemo; LocoGlobal: String; var locoWorkDir: String; var consist: TConsist;
  var passWagonUnit: TConsistUnit; var freightWagonUnit: TConsistUnit);

function ReadOrdinateByTrack(Route: String; naprav: string; Track: Integer): Integer;
function ReadConsistUnit(dir: String; var consistUnit: TConsistUnit; isLoco: Boolean = True): byte;
procedure ReadVstrech(Route: String; SceneryName: String);
procedure ReadEntities(var Sounds: TDictionary<string, TSound>; dir: String);
procedure ReadStations(Route: String; var stations: TArray<TStation>; var stationsCount: byte);

var
  ADDR_ZDS_EXE_LABEL: PByte;
  // Vstrech
  ADDR_VSTRECH_WAGON_DLINA, ADDR_VSTRECH_LOCO, ADDR_VSTRECH_TRACK: Pointer;
  ADDR_Speed, ADDR_Svetofor, ADDR_Track, ADDR_KLUB_OPEN, ADDR_TRACK_TAIL, ADDR_COUPLE_STATUS, ADDR_RB, ADDR_RBS,
    ADDR_KM_STATE, ADDR_KMOP, ADDR_KM1, ADDR_REVERSOR, ADDR_KM2, ADDR_395, ADDR_254, ADDR_ACCLRT, ADDR_VSTR_TRACK,
    ADDR_VSTR_NW, ADDR_SVETOFOR_DISTANCE, ADDR_VIGILANCE_CHECK, ADDR_OGRANICH, ADDR_NEXT_OGRANICH, ADDR_AMPERAGE1,
    ADDR_AMPERAGE2, ADDR_AMPERAGE3, ADDR_AMPERAGE4, ADDR_BOKSOVANIE, ADDR_ABZ1, ADDR_ABZ2, ADDR_RAIN, ADDR_STOCHIST,
    ADDR_STCHSTDGR, ADDR_CHS7_COMPRESSOR_1, ADDR_CHS7_COMPRESSOR_2_M, ADDR_CHS7_COMPRESSORS_MM, ADDR_CHS7_COMPRESSORS_S,
    ADDR_CHS7_VENT, ADDR_CHS7_VOLTAGE, ADDR_CHS7_BV, ADDR_CHS7_REVERSOR, ADDR_CHS7_FTP, ADDR_CHS7_BTP,
    ADDR_CHS7_ZHALUZI, ADDR_HIGHLIGHTS, ADDR_EDT_AMPERAGE, ADDR_PNEUMATIC_TM, ADDR_PNEUMATIC_UR, ADDR_PNEUMATIC_NAP,
    ADDR_PNEUMATIC_DT, ADDR_PNEUMATIC_TC, ADDR_COMBINED, ADDR_EPT, ADDR_EPK, ADDR_SVISTOK, ADDR_TIFON,
    ADDR_SETTINGS_INI_POINTER, ADDR_ORDINATA, ADDR_OUTSIDE_LOCO_STATUS, ADDR_CAMERA, ADDR_CAMERA_X, ADDR_CAMERA_Y,
    ADDR_CAMERA_Z, ADDR_CAMERA_ANG_Z, ADDR_CAMERA_ANG_X, ADDR_CAMERA_ZOOM: Pointer;

implementation

uses UnitMain, Windows, SysUtils, Math, Classes, ExtraUtils;

var
  ProcReadDataMemoryAddr: ProcReadDataMemoryType;

  // RAM Pointer
function ReadPointer(Addr: Pointer): PByte;
var
  tempAddr: PByte;
  b: byte;
  i: Integer;
  str: String;
begin
  tempAddr := Addr;
  Inc(tempAddr, 3);
  for i := 4 downto 1 do
  begin
    ReadProcessMemory(UnitMain.pHandle, tempAddr, @b, 1, temp);
    str := str + IntToHex(b, 2);
    Dec(tempAddr);
  end;
  Result := ptr(StrToInt('$' + str));
end;

// RAM String fixed
function ReadStringFromMemory(readAddr: PByte; Len: byte): String;
var
  i: byte;
  readByte: byte;
  resStr: String;
  str: String;
begin
  for i := 0 to Len do
  begin
    ReadProcessMemory(UnitMain.pHandle, readAddr, @readByte, 1, temp);
    SetString(str, PAnsiChar(@readByte), 1);
    resStr := resStr + str;
    Inc(readAddr);
  end;
  Result := resStr;
end;

// RAM String to symbol
function ReadKeyFromMemoryString(readAddr: PByte; Key: String; SearchRadius: Integer): String;
var
  strKey: String;
  retStr, str: String;
  readByte: byte;
  keyFound, firstDataByte: Boolean;
  i: Integer;
begin
  keyFound := False;
  firstDataByte := False;
  i := 0;
  while True do
  begin
    if i > SearchRadius then
      Break;

    ReadProcessMemory(UnitMain.pHandle, readAddr, @readByte, 1, temp);

    if readByte <> 0 then
    begin
      SetString(str, PAnsiChar(@readByte), 1);
      if firstDataByte = False then
        strKey := strKey + str
      else
        firstDataByte := False;
    end
    else
    begin
      if strKey <> '' then
      begin
        if keyFound = False then
        begin
          if Pos(Key, strKey) <> 0 then
          begin
            keyFound := True;
            firstDataByte := True;
            strKey := '';
          end
          else
          begin
            strKey := '';
          end;
        end
        else
        begin
          retStr := strKey;
          Break;
        end;
      end;
    end;

    Inc(readAddr);
    Inc(i);
  end;
  Result := retStr;
end;

// RAM settings.ini
procedure GetStartSettingParamsFromRAM();
var
  addr_settings_ini: PByte;
begin
  With FormMain do
  begin
    // Получаем адрес процесса ZDSimulator
    UnitMain.tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
    UnitMain.pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);

    addr_settings_ini := ReadPointer(ADDR_SETTINGS_INI_POINTER);

    if addr_settings_ini <> nil then
    begin
      consist.wagonsAmount := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'WagonsAmount', 6666));
      LocoGlobal := ReadKeyFromMemoryString(addr_settings_ini, 'LocomotiveType', 6666);
      naprav := ReadKeyFromMemoryString(addr_settings_ini, 'Route', 6666);
      try
        Route := ReadKeyFromMemoryString(addr_settings_ini, 'RoutePath', 6666);
      except
        Route := 'error';
      end;
      try
        LocoNum := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'LocNum', 6666));
      except
        LocoNum := -1;
      end;
      try
        ConName := ReadKeyFromMemoryString(addr_settings_ini, 'WagsName', 6666);
      except
        ConName := 'error';
      end;
      Winter := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'Winter', 6666));
      Freight := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'Freight', 6666));
      try
        SceneryName := ReadKeyFromMemoryString(addr_settings_ini, 'SceneryName', 6666);
      except
        SceneryName := 'error';
      end;
    end;

    try
      CloseHandle(UnitMain.pHandle);
    except
    end;
  end;
end;

// RAM chs7
procedure ReadDataMemoryCHS7();
begin
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_FTP, @FrontTP.current, 1, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_BTP, @BackTP.current, 1, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_REVERSOR, @Reversor.current, 1, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR_1, @MKs[0].current, 4, temp);
  except
  end;
  try
    var
      MK2Mode: byte;
    var
      MKsStart: Integer;
    var
      mksMM: Short;
    var
    mksMMAddr := ReadPointer(ADDR_CHS7_COMPRESSORS_MM) + 224;

    ReadProcessMemory(UnitMain.pHandle, mksMMAddr, @mksMM, 2, temp);
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR_2_M, @MK2Mode, 1, temp);
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSORS_S, @MKsStart, 4, temp);

    MKs[1].current := byte((MKsStart >= 16777216) and (MK2Mode >= 1) or (MK2Mode = 2) and (mksMM <> 0));
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_VOLTAGE, @Voltage.current, 4, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_BV, @BV.current, 1, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_VENT, @MVs.current, 1, temp);
  except
  end;
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_ZHALUZI, @Zhalusi.current, 1, temp);
  except
  end;
  if ((BV.current = 0) Or (Voltage.current < 1.5)) and (MVs.current <> 0) then
    MVs.current := 0;
end;

// RAM common
procedure ReadVarsFromRAM;
var
  wKMPos1: Single;
  vstrechOrdinate: Int64;
begin
  With FormMain do
  begin
    // Получаем адрес процесса ZDSimulator
    UnitMain.tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
    UnitMain.pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);

    // Vstrech
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTR_NW, @vstrech.consist.wagonsAmount, 4, temp);
    except
    end;
    try
      vstrech.consist.loco := ReadStringFromMemory(ADDR_VSTRECH_LOCO, 6);
      if vstrech.consist.loco.StartsWith('vl11m') then
        vstrech.consist.loco := 'vl11m';
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTRECH_TRACK, @vstrech.Track, 2, temp);
    except
    end;
    try
      var
        wagonLength: Double;
      var
        wagonLengthAddr: PDouble := ADDR_VSTRECH_WAGON_DLINA;

      ReadProcessMemory(UnitMain.pHandle, wagonLengthAddr, @wagonLength, 8, temp);
      vstrech.consist.wagonUnit.length := Trunc(wagonLength);

      if (wagonLength > 1) and (wagonLength < 50) then
      begin
        vstrech.consist.length := Trunc(wagonLength);
        Inc(wagonLengthAddr, 18);
        for var i := 0 to vstrech.consist.wagonsAmount - 1 do
        begin
          try
            ReadProcessMemory(UnitMain.pHandle, wagonLengthAddr, @wagonLength, 8, temp);
            vstrech.consist.length := vstrech.consist.length + Trunc(wagonLength);
            Inc(wagonLengthAddr, 18);
          except
          end;
        end;
        vstrech.consist.length := vstrech.consist.length;
      end;
    except
    end;

    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Track, @Track.current, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_TRACK_TAIL, @TrackTail, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Speed, @SpeedFakt, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Svetofor, @Svetofor.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM1, @wKMPos1, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM2, @KM2.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM_STATE, @KMState.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KMOP, @KMOP.current, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_395, @KM395.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_254, @KM254.current, 4, temp);
    except
    end;
    // try ReadProcessMemory(UnitMain.pHandle, ADDR_VSTR_TRACK, @wTrVstr, 2, temp);  except end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KLUB_OPEN, @KLUBOpen, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ACCLRT, @Acceleretion.current, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OGRANICH, @OgrSpeed.current, 2, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_NEXT_OGRANICH, @NextOgrSpeed.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_SVETOFOR_DISTANCE, @SvetoforDist.current, 2, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RAIN, @Rain.current, 1, temp);
    except
    end;
    try
      var
        camTemp: byte;
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA, @camTemp, 1, temp);
      Camera.current.env := TEnvEnum(camTemp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VIGILANCE_CHECK, @VCheck.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_X, @Camera.current.x, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_Y, @Camera.current.y, 4, temp);
    except
    end;
    try
      var
        camZ: Double;
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_Z, @camZ, 8, temp);
      Camera.current.z := camZ;
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_ANG_Z, @Camera.current.aZ, 4, temp);
      Camera.current.aZ := 0.0056 * Pi * Camera.current.aZ;
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_ANG_X, @Camera.current.aX, 4, temp);
      Camera.current.aX := 0.0056 * Pi * Camera.current.aX;
    except
    end;
    try
      var
        camZoom: byte;
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_ZOOM, @camZoom, 4, temp);
      Camera.current.zoom := camZoom;
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_AMPERAGE1, @TEDAmperage.current, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EDT_AMPERAGE, @EDTAmperage.current, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_TM, @PneumaticTM.current, 4, temp);
    except
    end;
    try
      var
      addrUR := ReadPointer(ADDR_PNEUMATIC_UR) + 32;
      ReadProcessMemory(UnitMain.pHandle, addrUR, @PneumaticUR.current, 4, temp);
    except
    end;
    try
      var
      addrNAP := ReadPointer(ADDR_PNEUMATIC_NAP) + 240;
      ReadProcessMemory(UnitMain.pHandle, addrNAP, @PneumaticNAP.current, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_DT, @PneumaticDT.current, 4, temp);
    except
    end;
    try
      var
      prevTC := PneumaticTC.previous;
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_TC, @PneumaticTC.current, 4, temp);
      PneumaticTC.current := 0.1 * PneumaticTC.current;
      PneumaticTC.previous := prevTC;
    except
    end;
    try
      var
      addrCombined := ReadPointer(ADDR_COMBINED) + 48;
      ReadProcessMemory(UnitMain.pHandle, addrCombined, @IsCombinedOpened, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RB, @RB.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RBS, @RBS.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_STOCHIST, @Stochist.current, 4, temp);
      Stochist.current := ABS(Stochist.current);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_STCHSTDGR, @StochistDGR.current, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_BOKSOVANIE, @Boks.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ABZ1, @ABZ1.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ABZ2, @ABZ2.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_COUPLE_STATUS, @CoupleStat.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_HIGHLIGHTS, @HighLights.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_SVISTOK, @svistok, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_TIFON, @tifon, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EPT, @EPT.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EPK, @EPK.current, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ORDINATA, @Ordinate.current, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OUTSIDE_LOCO_STATUS, @OutsideLocoStatus, 2, temp);
    except
    end;

    try
      if VersionID >= 1 then
      begin
        try
          KM1.current := Trunc(wKMPos1);
        except
        end;
      end
      else
      begin
        if (LocoGlobal <> 'M62') and (LocoGlobal <> 'TEP70bs') then
          if (wKMPos1 >= 0) and (wKMPos1 < 1000) then
            KM1.current := Trunc(wKMPos1 + 0.25)
          else
            KM1.current := 0;
      end;
    except
    end;

    // Vars
    if LocoGlobal <> '' then
    begin
      try
        ProcReadDataMemoryAddr();
      except
      end;
    end;
  end;

  try
    CloseHandle(UnitMain.pHandle);
  except
  end;
end;

// RAM Initial Params
procedure InitializeStartParams(VersionID: Integer);
begin
  With FormMain do
  begin
    if VersionID = 0 then
    begin
      // Vstrech
      ADDR_VSTR_NW := ptr($09005FE0);
      ADDR_VSTRECH_WAGON_DLINA := ptr($090043D0);
      ADDR_VSTRECH_LOCO := ptr($090043D9);
      ADDR_VSTRECH_TRACK := ptr($09005FE4);

      ADDR_BOKSOVANIE := ptr($0538C29C);
      ADDR_254 := ptr($007499E4);
      ADDR_395 := ptr($090043A0);
      ADDR_Speed := ptr($00749958);
      ADDR_ACCLRT := ptr($007498B8);
      ADDR_Track := ptr($00749A0C);
      ADDR_KM1 := ptr($0911072C);
      ADDR_KM_STATE := ptr($91D5B9C);
      ADDR_KMOP := ptr($0911081C);
      ADDR_Svetofor := ptr($09007ECC);
      ADDR_AMPERAGE1 := ptr($0538BFDC);
      ADDR_KLUB_OPEN := ptr($0538D915);
      ADDR_CAMERA := ptr($09008024);
      ADDR_CAMERA_X := ptr($007499EC);
      ADDR_CAMERA_Y := ptr($0900802C);
      ADDR_CAMERA_Z := ptr($007499F8);
      ADDR_CAMERA_ANG_Z := ptr($09004398);
      ADDR_CAMERA_ANG_X := ptr($0900439C);
      ADDR_CAMERA_ZOOM := ptr($00749764);
      ADDR_RB := ptr($00749914);
      ADDR_CHS7_REVERSOR := ptr($0538BFD6);
      ADDR_RBS := ptr($00749910);
      ADDR_OGRANICH := ptr($0074987C);
      ADDR_SVETOFOR_DISTANCE := ptr($09007EB8);
      ADDR_VIGILANCE_CHECK := ptr($007499D0);
      ADDR_CHS7_BV := ptr($091D5B9E);
      ADDR_PNEUMATIC_TM := ptr($09110738);
      ADDR_PNEUMATIC_UR := ptr($09110D78);
      ADDR_PNEUMATIC_NAP := ptr($09110D60);
      ADDR_PNEUMATIC_DT := ptr($091107B0);
      ADDR_PNEUMATIC_TC := ptr($0538C268);
      ADDR_COMBINED := ptr($00792348);
      ADDR_CHS7_VOLTAGE := ptr($091106B8);
      ADDR_CHS7_VENT := ptr($091D5BA0);
      ADDR_CHS7_COMPRESSOR_1 := ptr($091D48C8);
      ADDR_CHS7_COMPRESSOR_2_M := ptr($091D5BA2);
      ADDR_CHS7_COMPRESSORS_MM := ptr($0074818C);
      ADDR_CHS7_COMPRESSORS_S := ptr($091D5BA0);
      ADDR_CHS7_FTP := ptr($091D5BAF);
      ADDR_CHS7_BTP := ptr($091D5BB3);
      ADDR_STOCHIST := ptr($007497CC);
      ADDR_STCHSTDGR := ptr($007497BC);
      ADDR_RAIN := ptr($00803D56);
      ADDR_ABZ1 := ptr($091106D7);
      ADDR_ABZ2 := ptr($09110887);
      ADDR_KM2 := ptr($091D5AA9);
      ADDR_EDT_AMPERAGE := ptr($0538C274);
      ADDR_CHS7_ZHALUZI := ptr($091D5BA7);
      ADDR_EPT := ptr($09007C59);
      ADDR_EPK := ptr($0074986C);
      ADDR_COUPLE_STATUS := ptr($00749788);
      ADDR_HIGHLIGHTS := ptr($09007C7A);
      ADDR_TRACK_TAIL := ptr($09008054);
      ADDR_SVISTOK := ptr($007499D8);
      ADDR_TIFON := ptr($007499DC);
      ADDR_NEXT_OGRANICH := ptr($00749880);
      ADDR_SETTINGS_INI_POINTER := ptr($00803F48);
      ADDR_ORDINATA := ptr($00803F50);
      ADDR_OUTSIDE_LOCO_STATUS := ptr($00749865);
    end;
  end;
end;

// Files

// Vstrech
procedure ReadVstrech(Route: String; SceneryName: String);
var
  fileName: String;
  fileText: TextFile;
  line: String;
  tempList: TStringList;
  loco: String;
begin
  fileName := 'routes/' + Route + '/scenaries/' + SceneryName;

  vstrech.speeds := TQueue<Single>.Create();

  AssignFile(fileText, fileName);
  Reset(fileText);
  while not Eof(fileText) do
  begin
    Readln(fileText, line);
    if line = '[oncoming traffic]' then
    begin
      while line <> '[static]' do
      begin
        Readln(fileText, line);
        tempList := extractWord(line, #9);
        if tempList[0].length = 4 then
          vstrech.speeds.Enqueue(StrToFloat(tempList[3]));
      end;
    end;
  end;
  CloseFile(fileText);
end;

// Stations
function ReadOrdinateByTrack(Route: String; naprav: string; Track: Integer): Integer;
var
  fileName: String;
  fileText: TextFile;
  tempList: TStringList;
  line: String;
  Ordinate: String;
begin
  fileName := 'routes/' + Route + '/route' + naprav + '.trk';

  AssignFile(fileText, fileName);
  Reset(fileText);

  while not Eof(fileText) do
  begin
    Readln(fileText, line);
    tempList := extractWord(line, #44);
    if StrToInt(tempList[7]) = Track then
    begin
      Ordinate := tempList[10];
      setlength(Ordinate, length(Ordinate) - 1);
      Break;
    end;
  end;

  CloseFile(fileText);
  Result := StrToInt(Ordinate);
end;

// Stations
procedure ReadStations(Route: String; var stations: TArray<TStation>; var stationsCount: byte);
var
  fileName: String;
  fileText: TextFile;
  stationsList: TStringList;
  tempList: TStringList;
  line: String;
  str: string;
  i: Integer;
begin
  fileName := 'routes/' + Route + '/start_kilometers.dat';

  AssignFile(fileText, fileName);
  Reset(fileText);

  while not Eof(fileText) do
  begin
    Readln(fileText, line);
    if line <> #13 then
      str := str + line.Trim() + #13;
  end;
  CloseFile(fileText);

  stationsList := extractWord(str, #13);
  setlength(stations, stationsList.Count);

  for i := 0 to stationsList.Count - 2 do
  begin
    tempList := extractWord(stationsList[i], ' ');
    if tempList.Count >= 3 then
    begin
      try
        stations[i].startTrack := StrToInt(tempList[1]);
        stations[i].endTrack := StrToInt(tempList[2]);
      except
      end;
    end;
  end;
  stationsCount := i;
end;

// entities.dat # name x-y-z env volume
procedure ReadEntities(var Sounds: TDictionary<string, TSound>; dir: String);
var
  fileName: string;
  fileText: TextFile;
  entityList: TStringList;
  tempList: TStringList;
  str: String;
  line: string;
  tempSound: TSound;
begin
  fileName := 'TWS/consist/' + dir + '/entity/entities.dat';

  AssignFile(fileText, fileName);
  Reset(fileText);
  while not Eof(fileText) do
  begin
    Readln(fileText, line);
    if line <> #13 then
      str := str + line.Trim() + #13;
  end;
  CloseFile(fileText);

  entityList := extractWord(str, #13);
  for var i := 0 to entityList.Count - 2 do
  begin
    tempList := extractWord(entityList[i], ' ');
    if tempList.Count = 6 then
    begin
      tempSound.id := tempList[0];
      tempSound.entity.coords.x := StrToFloat(tempList[1]);
      tempSound.entity.coords.y := StrToFloat(tempList[2]);
      tempSound.entity.coords.z := StrToFloat(tempList[3]);
      tempSound.entity.env := TEnvEnum(StrToInt(tempList[4]));
      tempSound.entity.volume := StrToFloat(tempList[5]);

      if tempSound.entity.coords.x <= -1.35 then
        tempSound.entity.coords.x := 1.78 * (tempSound.entity.coords.x + 1.24)
      else if (-1.35 < tempSound.entity.coords.x) and (tempSound.entity.coords.x <= 1.35) then
        tempSound.entity.coords.x := -0.2
      else if tempSound.entity.coords.x > 1.35 then
      begin
        tempSound.entity.coords.x := tempSound.entity.coords.x;
        tempSound.entity.coords.x := -1 / (tempSound.entity.coords.x - 2.3) - 1.25;
      end;

      Sounds.AddOrSetValue(tempList[0], tempSound);
    end;
  end;

  tempList.free();
  entityList.free();
end;

// Axes
function ReadConsistUnit(dir: String; var consistUnit: TConsistUnit; isLoco: Boolean = True): byte;
var
  fileName: String;
  fileText: TextFile;
  line: String;
  tempList: TStringList;
  sectionsAmt: byte;
begin
  if dir <> '' then
  begin
    fileName := 'TWS/consist/' + dir + '/entity/axes.dat';

    AssignFile(fileText, fileName);
    Reset(fileText);
    Readln(fileText, line);
    CloseFile(fileText);

    tempList := extractWord(line, ' ');
    if tempList.Count > 0 then
    begin
      consistUnit.axesAmount := tempList.Count - byte(isLoco);
      setlength(consistUnit.axes, consistUnit.axesAmount);

      if isLoco then
        sectionsAmt := StrToInt(tempList[0]);

      for var i := byte(isLoco) to tempList.Count - 1 do
      begin
        consistUnit.axes[i - byte(isLoco)] := StrToInt(tempList[i]);
        consistUnit.length := consistUnit.length + consistUnit.axes[i - byte(isLoco)];
      end;
      consistUnit.length := consistUnit.length + consistUnit.axes[consistUnit.axesAmount - 1];
    end;

    Result := sectionsAmt;
  end;
end;

// Consist
procedure InitializeConsist(Memo1: TMemo; LocoGlobal: String; var locoWorkDir: String; var consist: TConsist;
  var passWagonUnit: TConsistUnit; var freightWagonUnit: TConsistUnit);
var
  wagonLength: Integer;
  axesWagonAmount: Integer;
begin
  if LocoGlobal = '822' then
    consist.loco := 'chs7';

  locoWorkDir := 'TWS/consist/' + consist.loco + '/';

  if consist.loco = 'chs7' then
  begin
    UltimateTEDAmperage := 800;
    MVsPitchIncrementer := 0.001;
    @ProcReadDataMemoryAddr := @ReadDataMemoryCHS7;
  end;

  if consist.loco <> '' then
    consist.sectionsAmt := ReadConsistUnit(consist.loco, consist.locoUnit);
  ReadConsistUnit('passenger', passWagonUnit, False);
  ReadConsistUnit('freight', freightWagonUnit, False);

  axesWagonAmount := 0;
  wagonLength := 0;
  if consist.type_ = CON_PASS then
  begin
    wagonLength := passWagonUnit.length;
    axesWagonAmount := passWagonUnit.axesAmount;
  end
  else if consist.type_ = CON_FREIGHT then
  begin
    wagonLength := freightWagonUnit.length;
    axesWagonAmount := freightWagonUnit.axesAmount;
  end;

  consist.axesAmt := consist.locoUnit.axesAmount + consist.wagonsAmount * axesWagonAmount;
  consist.length := wagonLength * consist.wagonsAmount + consist.locoUnit.length;
end;

end.
