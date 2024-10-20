// ------------------------------------------------------------------------------//
// //
// Модуль для работы с ОЗУ           //
// (c) DimaGVRH, Dnepr city, 2019    //
// //
// ------------------------------------------------------------------------------//
unit RAMMemModule;

interface

procedure GetStartSettingParamsFromRAM();
procedure InitializeStartParams(VersionID: Integer);
procedure InitializeLoco(LocoGlobal: String);
function ReadKeyFromMemoryString(readAddr: PByte; Key: String; SearchRadius: Integer): String;
function ReadStringFromMemory(readAddr: PByte; Len: Byte): String;
procedure ReadVarsFromRAM();
procedure ReadDataMemoryCHS7();

var
  ADDR_ZDS_EXE_LABEL: PByte;
  ADDR_Speed, ADDR_Svetofor, ADDR_Track, ADDR_KLUB_OPEN, ADDR_TRACK_TAIL, ADDR_COUPLE_STATUS, ADDR_RB, ADDR_RBS,
    ADDR_KM_STATE, ADDR_KMOP, ADDR_KM1, ADDR_REVERSOR, ADDR_KM2, ADDR_395, ADDR_254, ADDR_ACCLRT, ADDR_VSTR_TRACK,
    ADDR_VSTR_NW, ADDR_SVETOFOR_DISTANCE, ADDR_VIGILANCE_CHECK, ADDR_SPEED_VSTRECHA, ADDR_VSTRECH_STATUS, ADDR_OGRANICH,
    ADDR_NEXT_OGRANICH, ADDR_CAMERA, ADDR_CAMERA_X, ADDR_AMPERAGE1, ADDR_AMPERAGE2, ADDR_AMPERAGE3, ADDR_AMPERAGE4,
    ADDR_BOKSOVANIE, ADDR_ABZ1, ADDR_ABZ2, ADDR_RAIN, ADDR_STOCHIST, ADDR_STCHSTDGR, ADDR_CHS7_COMPRESSOR,
    ADDR_CHS7_COMPRESSOR_2, ADDR_CHS7_VENT, ADDR_CHS7_VOLTAGE, ADDR_CHS7_BV, ADDR_CHS7_REVERSOR, ADDR_CHS7_FTP,
    ADDR_CHS7_BTP, ADDR_CHS7_ZHALUZI, ADDR_HIGHLIGHTS, ADDR_EDT_AMPERAGE, ADDR_PNEUMATIC_TM, ADDR_PNEUMATIC_UR,
    ADDR_PNEUMATIC_NAP, ADDR_PNEUMATIC_DT, ADDR_PNEUMATIC_TC, ADDR_COMBINED, ADDR_EPT, ADDR_EPK, ADDR_SVISTOK,
    ADDR_TIFON, ADDR_VSTRECHA_WAGON_DLINA, ADDR_VSTRECHA_WAG_ORDINATA, ADDR_SETTINGS_INI_POINTER, ADDR_ORDINATA,
    ADDR_OUTSIDE_LOCO_STATUS: Pointer;

implementation

uses UnitMain, Windows, SysUtils, SoundManager, Math, UnitSettings;

var
  ProcReadDataMemoryAddr: ProcReadDataMemoryType;

  // RAM Pointer
function ReadPointer(Addr: Pointer): PByte;
var
  tempAddr: PByte;
  b: Byte;
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
function ReadStringFromMemory(readAddr: PByte; Len: Byte): String;
var
  i: Byte;
  readByte: Byte;
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
  readByte: Byte;
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
      WagonsAmount := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'WagonsAmount', 6666));
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
      MP := StrToInt(ReadKeyFromMemoryString(addr_settings_ini, 'MultiPlayer', 6666));
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

// RAM CHS7
procedure ReadDataMemoryCHS7();
begin
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_FTP, @FrontTP, 1, temp);
  except
  end; // Передний ТП
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_BTP, @BackTP, 1, temp);
  except
  end; // Задний ТП
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_REVERSOR, @Reversor[V_CUR], 1, temp);
  except
  end; // Реверсор
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR, @Compressors[0], 4, temp);
  except
  end; // Компрессор
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR_2, @Compressors[1], 4, temp);
  except
  end; // Компрессор 2
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_VOLTAGE, @Voltage, 4, temp);
  except
  end; // Напряжение на эл-возе
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_BV, @BV, 1, temp);
  except
  end; // БВ
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_VENT, @MVs, 1, temp);
  except
  end; // Вентилятор (положение тумблера)
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_ZHALUZI, @Zhaluzi, 1, temp);
  except
  end; // Жалюзи
  if ((BV[V_CUR] = 0) Or (Voltage[V_CUR] < 1.5)) and (MVs <> 0) then
    MVs := 0;
end;

// RAM common
procedure ReadVarsFromRAM;
var
  wVstrDl: double;
  wVstrSpeed: Single; // [м/c]   \
  wKMPos1: Single;
  addr_waglength: PDouble;
  i: Integer;
begin
  With FormMain do
  begin
    // Получаем адрес процесса ZDSimulator
    UnitMain.tHandle := GetWindowThreadProcessId(wHandle, @ProcessID);
    UnitMain.pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);

    // --- Задаем указатель на длину первого вагона встречки --- //
    addr_waglength := ADDR_VSTRECHA_WAGON_DLINA;
    VstrechaDlina := 0;

    // ----- Читаем основные(общие) переменные ZDSimulator ----- //
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Track, @Track[V_CUR], 4, temp);
    except
    end; // Получаем номер трэка
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_TRACK_TAIL, @TrackTail, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Speed, @Speed[V_CUR], 8, temp);
    except
    end; // Получаем скорость 32CB38
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Svetofor, @Svetofor[V_CUR], 1, temp);
    except
    end; // Получаем показания светофора
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM1, @wKMPos1, 4, temp);
    except
    end; // Получаем позиции 1-ой секции
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM2, @KM2[V_CUR], 1, temp);
    except
    end; // Получаем позиции 2-ой секции
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM_STATE, @KMState[V_CUR], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KMOP, @KMOP[V_CUR], 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_395, @KM395[V_CUR], 1, temp);
    except
    end; // Получаем позицию 394(395) крана
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_254, @KM294[V_CUR], 4, temp);
    except
    end; // Получаем позицию лок. крана
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTR_NW, @WagNumVstr, 1, temp);
    except
    end; // Получаем количество вагонов встречки
    // try ReadProcessMemory(UnitMain.pHandle, ADDR_VSTR_TRACK, @wTrVstr, 2, temp);  except end;  // Получаем трэк встречки
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KLUB_OPEN, @KLUBOpen, 1, temp);
    except
    end; // Получаем байт открытия клавиатуры КЛУБ-а
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ACCLRT, @Acceleretion, 8, temp);
    except
    end; // Получаем ускорение
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTRECHA_WAG_ORDINATA, @VstrTrack, 2, temp);
    except
    end; // Получаем ускорение
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OGRANICH, @OgrSpeed, 2, temp);
    except
    end; // Получаем ограничение скорости с КЛУБ-а
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_NEXT_OGRANICH, @NextOgrSpeed, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_SVETOFOR_DISTANCE, @SvetoforDist, 2, temp);
    except
    end; // Получаем расстояние до свотофора
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RAIN, @Rain, 1, temp);
    except
    end; // Получаем интенсивность дождя
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA, @Camera, 1, temp);
    except
    end; // Получаем положение камеры
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VIGILANCE_CHECK, @VCheck, 1, temp);
    except
    end; // Получаем состояние проверки бдительности
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_SPEED_VSTRECHA, @wVstrSpeed, 4, temp);
    except
    end; // Получаем состояние проверки бдительности
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_CAMERA_X, @CameraX, 2, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_AMPERAGE1, @TEDAmperage, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EDT_AMPERAGE, @EDTAmperage, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_TM, @PneumaticTM[V_CUR], 4, temp);
    except
    end;
    try
      var
      addrUR := ReadPointer(ADDR_PNEUMATIC_UR) + 32;
      ReadProcessMemory(UnitMain.pHandle, addrUR, @PneumaticUR[V_CUR], 4, temp);
    except
    end;
    try
      var
      addrNAP := ReadPointer(ADDR_PNEUMATIC_NAP) + 240;
      ReadProcessMemory(UnitMain.pHandle, addrNAP, @PneumaticNAP[V_CUR], 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_DT, @PneumaticDT[V_CUR], 4, temp);
    except
    end;
    try
      var
      prevTC := PneumaticTC[V_PRV];
      ReadProcessMemory(UnitMain.pHandle, ADDR_PNEUMATIC_TC, @PneumaticTC[V_CUR], 4, temp);
      PneumaticTC[V_CUR] := 0.1 * PneumaticTC[V_CUR];
      PneumaticTC[V_PRV] := prevTC;
    except
    end;
    try
      var
      addrCombined := ReadPointer(ADDR_COMBINED) + 48;
      ReadProcessMemory(UnitMain.pHandle, addrCombined, @IsCombinedOpened, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RB, @RB, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_RBS, @RBS, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_STOCHIST, @Stochist, 4, temp);
      Stochist[V_CUR] := ABS(Stochist[V_CUR]);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_STCHSTDGR, @StochistDGR, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_BOKSOVANIE, @Boks[V_CUR], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ABZ1, @ABZ1[V_CUR], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ABZ2, @ABZ2[V_CUR], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_COUPLE_STATUS, @CoupleStat, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_HIGHLIGHTS, @HighLights, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_SVISTOK, @Signals[0], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_TIFON, @Signals[1], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTRECH_STATUS, @VstrechStatus, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EPT, @EPT, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_EPK, @EPK[V_CUR], 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_ORDINATA, @Ordinata, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OUTSIDE_LOCO_STATUS, @OutsideLocoStatus, 2, temp);
    except
    end;

    if Ordinata[V_CUR] <> Ordinata[V_PRV] then
      OrdinataEstimate := Ordinata;

    try
      if VersionID >= 1 then
      begin
        try
          KM1[V_CUR] := Trunc(wKMPos1);
        except
        end;
      end
      else
      begin
        if (LocoGlobal <> 'M62') and (LocoGlobal <> 'TEP70bs') then
          if (wKMPos1 >= 0) and (wKMPos1 < 1000) then
            KM1[V_CUR] := Trunc(wKMPos1 + 0.25)
          else
            KM1[V_CUR] := 0;
      end;
    except
    end;

    // --- Вычисляем длину встречного поеда в метрах ---- //
    try
      ReadProcessMemory(UnitMain.pHandle, addr_waglength, @wVstrDl, 8, temp);

      if wVstrDl > 0 then
      begin
        VstrechaDlina := VstrechaDlina + Trunc(wVstrDl);
        Inc(addr_waglength, 18);
        for i := 1 to WagNumVstr do
        begin
          try
            ReadProcessMemory(UnitMain.pHandle, addr_waglength, @wVstrDl, 8, temp); // Получаем длину встречки в цикле
            VstrechaDlina := VstrechaDlina + Trunc(wVstrDl);
            Inc(addr_waglength, 18);
          except
          end;
        end;
      end;
    except
    end;

    // --- Вычисляем приблизительную длину трека в м. --- //
    if CoupleStat[V_CUR] = 1 then
    begin
      try
        TrackLength := ConsistLength / (ABS(Track[V_CUR] - TrackTail));
      except
        TrackLength := 100;
      end;
    end
    else
    begin
      TrackLength := 100;
    end;

    // ------ Читаем переменные локомотива из ОЗУ ------- //
    if LocoGlobal <> '' then
      try
        ProcReadDataMemoryAddr();
      except
      end;

    // --- Перевод локальных переменных в глобальные ---- //
    try
      if (wVstrSpeed >= 0) and (wVstrSpeed < 500) then
        VstrSpeed := Trunc(4 * wVstrSpeed)
      else
        VstrSpeed := 0;
    except
    end;

    try
      CloseHandle(UnitMain.pHandle);
    except
    end;
  end;
end;

// RAM Initial Params
procedure InitializeStartParams(VersionID: Integer);
begin
  With FormMain do
  begin
    if VersionID = 0 then
    begin
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
      ADDR_CAMERA_X := ptr($007499EE);
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
      ADDR_CHS7_COMPRESSOR := ptr($091D48C8);
      ADDR_CHS7_COMPRESSOR_2 := ptr($091D5BA2);
      ADDR_CHS7_FTP := ptr($091D5BAF);
      ADDR_CHS7_BTP := ptr($091D5BB3);
      ADDR_STOCHIST := ptr($007497CC);
      ADDR_STCHSTDGR := ptr($007497BC);
      ADDR_RAIN := ptr($00803D56);
      ADDR_ABZ1 := ptr($091106D7);
      ADDR_ABZ2 := ptr($09110887);
      ADDR_VSTRECHA_WAG_ORDINATA := ptr($09005FE4);
      ADDR_KM2 := ptr($091D5AA9);
      ADDR_VSTR_NW := ptr($09005FE0);
      ADDR_VSTRECHA_WAGON_DLINA := ptr($090043D0);
      ADDR_BOKSOVANIE := ptr($0538C29C);
      ADDR_SPEED_VSTRECHA := ptr($00791FB8);
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
      ADDR_VSTRECH_STATUS := ptr($090043F8);
      ADDR_SETTINGS_INI_POINTER := ptr($00803F48);
      ADDR_ORDINATA := ptr($00803F50);
      ADDR_OUTSIDE_LOCO_STATUS := ptr($00749865);
    end;
  end;
end;

// Initialize loco
procedure InitializeLoco(LocoGlobal: String);
begin
  if LocoGlobal = '822' then
    Loco := 'CHS7';

  // -/- ЧС7 (CHS7) -/- //
  if Loco = 'CHS7' then
  begin
    LocoWorkDir := 'TWS/CHS7/';
    UltimateTEDAmperage := 800;
    LocoSectionsAmount := 2;
    LocoPowerVoltage := 3;
    LocoWithTED := True;
    LocoWithReductor := True;
    LocoWithDIZ := False;
    LocoWithSndReversor := True;
    LocoWithSndKM := True;
    LocoWithSndKMOP := True;
    LocoWithSndTP := True;
    LocoWithExtMVSound := True;
    LocoWithExtMKSound := True;
    LocoWithMVPitch := True;
    LocoWithMVTDPitch := True;
    TEDFile := PChar('TWS/CHS/ted.wav');
    ReduktorFile := PChar('TWS/CHS/reduktor.wav');
    VentTDPitchIncrementer := 0;
    VentPitchIncrementer := 0.001;
    LocoTEDNamePrefiks := 'CHS';

    LocoDIZNamePrefiks := '';
    RevPosF := PChar('TWS/revers-CHS.wav');

    LocoSndReversorType := 0;
    @ProcReadDataMemoryAddr := @ReadDataMemoryCHS7;
  end;
end;

end.
