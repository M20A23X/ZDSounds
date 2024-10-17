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

implementation

uses UnitMain, Windows, SysUtils, SoundManager, Math, UnitSettings;

var
  ProcReadDataMemoryAddr: ProcReadDataMemoryType;

  ADDR_Speed, ADDR_Svetofor: Pointer;
  ADDR_Track, ADDR_KLUB_OPEN: Pointer;
  ADDR_TRACK_TAIL: Pointer;
  ADDR_COUPLE_STATUS: Pointer;
  ADDR_RB, ADDR_RBS: Pointer;
  ADDR_KM_POS, ADDR_OP_POS, ADDR_REVERSOR: Pointer;
  ADDR_KMPos2: Pointer;
  ADDR_395, ADDR_254, ADDR_ACCLRT: Pointer;
  ADDR_VSTR_TRACK, ADDR_VSTR_NW: Pointer;
  ADDR_SVETOFOR_DISTANCE: Pointer;
  ADDR_TP_ED4M, ADDR_TP_ED9M: Pointer;
  ADDR_BV_ED4M, ADDR_BV_ED9M: Pointer;
  ADDR_KME_ED4M, ADDR_KME_ED9M: Pointer;
  ADDR_VIGILANCE_CHECK: Pointer; // Адрес состояния проверки бдительности (нужно для КЛУБ-а)
  ADDR_SPEED_VSTRECHA: Pointer; // Адрес скорости встречки в МП
  ADDR_VSTRECH_STATUS: Pointer;
  ADDR_OGRANICH: Pointer;
  ADDR_NEXT_OGRANICH: Pointer;
  ADDR_CAMERA: Pointer;
  ADDR_CAMERA_X: Pointer; // Адрес значения положения головы по оси Х в кабине машиниста
  ADDR_AMPERAGE1: Pointer; // Адрес значения ТЭД ток 1
  ADDR_AMPERAGE2: Pointer; // Адрес значения ТЭД ток 2
  ADDR_AMPERAGE3: Pointer; // Адрес значения ТЭД ток 3
  ADDR_AMPERAGE4: Pointer; // Адрес значения ТЭД ток 4
  ADDR_BOKSOVANIE: Pointer;
  ADDR_AB_ZB_1: Pointer;
  ADDR_AB_ZB_2: Pointer;
  ADDR_RAIN: Pointer;
  ADDR_STOCHIST: Pointer; // Адрес состояния дворников
  ADDR_STCHSTDGR: Pointer; // Адрес для угла поворота дворников
  ADDR_CHS7_COMPRESSOR: Pointer; // Адрес состояния компрессоров на ЧС7
  ADDR_CHS7_COMPRESSOR_STATE: Pointer;
  ADDR_CHS7_COMPRESSOR_2: Pointer;
  ADDR_CHS7_VENT: Pointer; // Адрес состояния вентиляторов на ЧС7 (Тумблер, положение)
  ADDR_CHS7_VOLTAGE: Pointer; // Адрес напряжения на ЧС7
  ADDR_CHS7_BV: Pointer; // Адрес состояния БВ на ЧС7
  ADDR_CHS7_REVERSOR: Pointer;
  ADDR_CHS7_FTP: Pointer;
  ADDR_CHS7_BTP: Pointer;
  ADDR_CHS7_ZHALUZI: Pointer;
  ADDR_CHS8_FTP: Pointer;
  ADDR_CHS8_BTP: Pointer;
  ADDR_CHS8_REOSTAT: Pointer;
  ADDR_CHS8_VENT_VOLUME: Pointer;
  ADDR_CHS8_VENT_VOLUME_INCREMENTER: Pointer;
  ADDR_CHS8_COMPRESSOR: Pointer; // Адрес состояния компрессоров на ЧС8
  ADDR_CHS8_GV_1: Pointer;
  ADDR_CHS8_GV_2: Pointer;
  ADDR_CHS4T_VENT: Pointer; // Адрес состояния вентиляторов на ЧС4т
  ADDR_CHS4T_COMPRESSOR: Pointer;
  ADDR_CHS4T_FTP: Pointer;
  ADDR_CHS4T_BTP: Pointer;
  ADDR_CHS4KVR_FTP: Pointer;
  ADDR_CHS4KVR_BTP: Pointer;
  ADDR_CHS4KVR_REVERSOR: Pointer;
  ADDR_CHS2K_COMPRESSOR: Pointer;
  ADDR_CHS2K_BV: Pointer;
  ADDR_CHS2K_VENT: Pointer;
  ADDR_CHS2K_FTP: Pointer;
  ADDR_CHS2K_BTP: Pointer;
  ADDR_EP1M_COMPRESSOR: Pointer;
  ADDR_EP1M_FTP: Pointer;
  ADDR_EP1M_BTP: Pointer;
  ADDR_KVR_VENTS: Pointer;
  ADDR_ED4M_COMPRESSOR: Pointer;
  ADDR_ED4M_REVERSOR: Pointer;
  ADDR_HIGHLIGHTS: Pointer;
  ADDR_ED9M_COMPRESSOR: Pointer;
  ADDR_ED9M_REVERS: Pointer;
  ADDR_EDT_AMPERAGE: Pointer; // Адрес значения тока ЭДТ (ЧС8)
  ADDR_NM: Pointer; // Адрес значения показания Напорной Магистрали
  ADDR_BRAKE_CYLINDERS: Pointer; // Адрес значения давления в Тормозных Цилиндрах
  ADDR_2TE10U_DIESEL1: Pointer; // Адрес состояния дизеля на 2ТЭ10У
  ADDR_2TE10U_DIESEL2: Pointer; // Адрес состояния дизеля на 2ТЭ10У
  ADDR_TEP70_RPM: Pointer; // Адрес числа оборотов в минуту дизеля на ТЭП70
  ADDR_TEP70BS_RPM: Pointer;
  ADDR_TEP70BS_KMPOS: Pointer;
  ADDR_M62_RPM_1: Pointer; // Адрес числа оборотов в минуту для дизеля на М62
  ADDR_M62_RPM_2: Pointer; // Адрес числа оборотов в минуту для дизеля на М62
  ADDR_M62_KMPOS_1: Pointer;
  ADDR_M62_KMPOS_2: Pointer;
  ADDR_EPT: Pointer;
  ADDR_VL11M_FTP, ADDR_VL11M_BTP: Pointer;
  ADDR_VL11M_COMPRESSOR: Pointer;
  ADDR_VL80TVent1: Pointer;
  ADDR_VL80TVent2: Pointer;
  ADDR_VL80TVent3: Pointer;
  ADDR_VL80TVent4: Pointer;
  ADDR_VL80TComp: Pointer;
  ADDR_VL80TFazan: Pointer;
  ADDR_VL82_COMPRESSOR: Pointer;
  ADDR_VL85_FTP, ADDR_VL85_BTP: Pointer;
  ADDR_2ES5K_FTP, ADDR_2ES5K_BTP: Pointer;
  ADDR_LDOORED4M: Pointer;
  ADDR_RDOORED4M: Pointer;
  ADDR_SVISTOK: Pointer;
  ADDR_TIFON: Pointer;
  ADDR_VSTRECHA_WAGON_DLINA: PDouble;
  ADDR_VSTRECHA_WAG_ORDINATA: PDouble;
  ADDR_SETTINGS_INI_POINTER: Pointer;
  ADDR_ED4M_KONTROLLER: Pointer;
  ADDR_ED9M_KONTROLLER: Pointer;
  ADDR_VL11m_VENT: Pointer;
  ADDR_ORDINATA: Pointer;
  ADDR_OUTSIDE_LOCO_STATUS: Pointer;
  ADDR_2ES5K_BV: Pointer;
  ADDR_CHS8_UNIPULS_AVARIA: Pointer;
  ADDR_PNEVM_SIGNAL: Pointer;
  ADDR_PNEVM: PByte;
  ADDR_VR242: Pointer;

  CHS8VentVolumePrev: Single;
  CHS8VentTempCounter: Byte;

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

procedure FindPnevm();
begin
  ADDR_PNEVM := ReadPointer(ADDR_PNEVM_SIGNAL);
  Inc(ADDR_PNEVM, 48);
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
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_REVERSOR, @ReversorPos, 1, temp);
  except
  end; // Реверсор
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR, @Compressors[0], 4, temp);
  except
  end; // Компрессор
  try
    var
      tempC: Byte;
    var
      tempC1: Byte;
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR_STATE, @tempC1, 1, temp);
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_COMPRESSOR_2, @tempC, 1, temp);

    if (tempC = 2) and (BV <> 0) and ((BackTP <> 0) or (FrontTP <> 0)) or (tempC = 1) and (tempC1 = 1) and
      (Compressors[0] = 1) then
      Compressors[1] := 1
    else
      Compressors[1] := 0;
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
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_VENT, @MVsState, 1, temp);
  except
  end; // Вентилятор (положение тумблера)
  try
    ReadProcessMemory(UnitMain.pHandle, ADDR_CHS7_ZHALUZI, @Zhaluzi, 1, temp);
  except
  end; // Жалюзи
  if ((BV = 0) Or (Voltage < 1.5)) and (MVsState <> 0) then
    MVsState := 0;
end;

// RAM common
procedure ReadVarsFromRAM;
var
  wSpeed: double;
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
    Vstrecha_dlina := 0;

    FindPnevm();

    // ----- Читаем основные(общие) переменные ZDSimulator ----- //
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Track, @Track, 4, temp);
    except
    end; // Получаем номер трэка
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_TRACK_TAIL, @TrackTail, 4, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Speed, @wSpeed, 8, temp);
    except
    end; // Получаем скорость 32CB38
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_Svetofor, @Svetofor, 1, temp);
    except
    end; // Получаем показания светофора
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KM_POS, @wKMPos1, 4, temp);
    except
    end; // Получаем позиции 1-ой секции
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_KMPos2, @KMPos2, 1, temp);
    except
    end; // Получаем позиции 2-ой секции
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OP_POS, @KMOP, 4, temp);
    except
    end; // Получаем позицию шунтов
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_395, @KM395, 1, temp);
    except
    end; // Получаем позицию 394(395) крана
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_254, @KM294, 4, temp);
    except
    end; // Получаем позицию лок. крана
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_VSTR_NW, @WagNum_Vstr, 1, temp);
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
      ReadProcessMemory(UnitMain.pHandle, ADDR_BRAKE_CYLINDERS, @BrakeCylinders, 4, temp);
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
      Stochist := ABS(Stochist);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_STCHSTDGR, @StochistDGR, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_BOKSOVANIE, @Boks_Stat, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_AB_ZB_1, @AB_ZB_1, 1, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_AB_ZB_2, @AB_ZB_2, 1, temp);
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
      ReadProcessMemory(UnitMain.pHandle, ADDR_ORDINATA, @Ordinata, 8, temp);
    except
    end;
    try
      ReadProcessMemory(UnitMain.pHandle, ADDR_OUTSIDE_LOCO_STATUS, @OutsideLocoStatus, 2, temp);
    except
    end;

    if Ordinata <> PrevOrdinata then
      OrdinataEstimate := Ordinata;

    try
      if VersionID >= 1 then
      begin
        try
          KMPos1 := Trunc(wKMPos1);
        except
        end;
      end
      else
      begin
        if (LocoGlobal <> 'M62') and (LocoGlobal <> 'TEP70bs') then
          if (wKMPos1 >= 0) and (wKMPos1 < 1000) then
            KMPos1 := Trunc(wKMPos1 + 0.25)
          else
            KMPos1 := 0;
      end;
    except
    end;

    // --- Вычисляем длину встречного поеда в метрах ---- //
    try
      ReadProcessMemory(UnitMain.pHandle, addr_waglength, @wVstrDl, 8, temp);
      // Получаем длину первого вагона
      Vstrecha_dlina := Vstrecha_dlina + Trunc(wVstrDl);
      Inc(addr_waglength, 18);
      for i := 1 to WagNum_Vstr do
      begin
        try
          ReadProcessMemory(UnitMain.pHandle, addr_waglength, @wVstrDl, 8, temp); // Получаем длину встречки в цикле
          Vstrecha_dlina := Vstrecha_dlina + Trunc(wVstrDl);
          Inc(addr_waglength, 18);
        except
        end;
      end;
    except
    end;

    // --- Вычисляем приблизительную длину трека в м. --- //
    if CoupleStat = 1 then
    begin
      try
        TrackLength := ConsistLength / (ABS(Track - TrackTail));
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
      if (wSpeed >= 0) and (wSpeed < 500) then
        Speed := Trunc(wSpeed)
      else
        Speed := 0;
    except
    end;
    try
      if (wVstrSpeed >= 0) and (wVstrSpeed < 500) then
        Vstr_Speed := Trunc(4 * wVstrSpeed)
      else
        Vstr_Speed := 0;
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
      ADDR_KM_POS := ptr($0911072C);
      ADDR_OP_POS := ptr($0911081C);
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
      ADDR_BRAKE_CYLINDERS := ptr($0538C268);
      ADDR_CHS7_VOLTAGE := ptr($091106B8);
      ADDR_CHS7_VENT := ptr($091D5BA0);
      ADDR_CHS7_COMPRESSOR := ptr($091D48C8);
      ADDR_CHS7_COMPRESSOR_STATE := ptr($091D5BA1);
      ADDR_CHS7_COMPRESSOR_2 := ptr($091D5BA2);
      ADDR_CHS7_FTP := ptr($091D5BAF);
      ADDR_CHS7_BTP := ptr($091D5BB3);
      ADDR_STOCHIST := ptr($007497CC);
      ADDR_STCHSTDGR := ptr($007497BC);
      ADDR_RAIN := ptr($00803D56);
      ADDR_CHS8_FTP := ptr($09110707);
      ADDR_CHS8_BTP := ptr($091108B7);
      ADDR_KVR_VENTS := ptr($091D48BD);
      ADDR_CHS4KVR_BTP := ptr($0911070F);
      ADDR_CHS4KVR_FTP := ptr($09110707);
      ADDR_VL80TComp := ptr($091D48B8);
      ADDR_CHS4KVR_REVERSOR := ptr($0538BFD7);
      ADDR_CHS8_REOSTAT := ptr($0538BFD8);
      ADDR_AB_ZB_1 := ptr($091106D7);
      ADDR_VL80TFazan := ptr($091D48D3);
      ADDR_VL80TVent1 := ptr($091D506C);
      ADDR_AB_ZB_2 := ptr($09110887);
      ADDR_VL80TVent2 := ptr($091D5074);
      ADDR_VL80TVent3 := ptr($091D507C);
      ADDR_BV_ED4M := ptr($091D5B06);
      ADDR_VSTRECHA_WAG_ORDINATA := ptr($09005FE4);
      ADDR_TEP70BS_RPM := ptr($091D5C9A);
      ADDR_BV_ED9M := ptr($091D5B16);
      ADDR_VL80TVent4 := ptr($091D5084);
      ADDR_TEP70BS_KMPOS := ptr($091D5C7D);
      ADDR_TP_ED4M := ptr($091D5B07);
      ADDR_TP_ED9M := ptr($091D5B17);
      ADDR_CHS8_COMPRESSOR := ptr($091D48DC);
      ADDR_VL85_FTP := ptr($091D5C47);
      ADDR_ED4M_COMPRESSOR := ptr($091D48C6);
      ADDR_ED9M_COMPRESSOR := ADDR_ED4M_COMPRESSOR;
      ADDR_CHS4T_FTP := ptr($09110707);
      ADDR_ED4M_REVERSOR := ptr($0538BFD6);
      ADDR_ED9M_REVERS := ADDR_ED4M_REVERSOR;
      ADDR_CHS4T_BTP := ptr($0911070F);
      ADDR_VL85_BTP := ptr($091D5C4B);
      ADDR_TEP70_RPM := ptr($091D5BDC);
      ADDR_CHS2K_FTP := ptr($091D5BEF);
      ADDR_CHS2K_COMPRESSOR := ptr($091D48C8);
      ADDR_CHS4T_VENT := ptr($091D48BB);
      ADDR_CHS2K_BTP := ptr($091D5BF3);
      ADDR_EP1M_COMPRESSOR := ptr($091D48B8);
      ADDR_2ES5K_FTP := ptr($091D5B5F);
      ADDR_EP1M_FTP := ptr($091D5C17);
      ADDR_2ES5K_BTP := ptr($091D5B63);
      ADDR_KMPos2 := ptr($091D5AA9);
      ADDR_EP1M_BTP := ptr($091D5C1B);
      ADDR_2TE10U_DIESEL2 := ptr($091D5AB0);
      ADDR_M62_RPM_1 := ptr($091D5A00);
      ADDR_VL11M_FTP := ptr($091D5C2F);
      ADDR_2TE10U_DIESEL1 := ptr($091D5AAC);
      ADDR_M62_RPM_2 := ptr($091D5A24);
      ADDR_VL11M_BTP := ptr($091D5C33);
      ADDR_M62_KMPOS_1 := ptr($091D5A14);
      ADDR_M62_KMPOS_2 := ADDR_M62_KMPOS_1;
      ADDR_VSTR_NW := ptr($09005FE0);
      ADDR_VSTRECHA_WAGON_DLINA := ptr($090043D0);
      ADDR_BOKSOVANIE := ptr($0538C29C);
      ADDR_LDOORED4M := ptr($090043B0);
      ADDR_VL11M_COMPRESSOR := ptr($091D48C8);
      ADDR_SPEED_VSTRECHA := ptr($00791FB8);
      ADDR_RDOORED4M := ptr($090043B1);
      ADDR_EDT_AMPERAGE := ptr($0538C274);
      ADDR_CHS7_ZHALUZI := ptr($091D5BA7);
      ADDR_EPT := ptr($09007C59);
      ADDR_COUPLE_STATUS := ptr($00749788);
      ADDR_CHS2K_VENT := ptr($091D5BE3);
      ADDR_CHS2K_BV := ptr($091D5BE2);
      ADDR_HIGHLIGHTS := ptr($09007C7A);
      ADDR_TRACK_TAIL := ptr($09008054);
      ADDR_SVISTOK := ptr($007499D8);
      ADDR_TIFON := ptr($007499DC);
      ADDR_NEXT_OGRANICH := ptr($00749880);
      ADDR_ED9M_KONTROLLER := ptr($091D5B15);
      ADDR_VSTRECH_STATUS := ptr($090043F8);
      ADDR_SETTINGS_INI_POINTER := ptr($00803F48);
      ADDR_ED4M_KONTROLLER := ptr($091D5B04);
      ADDR_VL11m_VENT := ptr($091D5C25);
      ADDR_ORDINATA := ptr($00803F50);
      ADDR_OUTSIDE_LOCO_STATUS := ptr($00749865);
      ADDR_CHS8_VENT_VOLUME := ptr($091D48BC);
      ADDR_CHS8_VENT_VOLUME_INCREMENTER := ptr($091D48CC);
      ADDR_2ES5K_BV := ptr($091D48CC);
      ADDR_CHS8_UNIPULS_AVARIA := ptr($091D5024);
      ADDR_CHS8_GV_1 := ptr($09007FB4);
      ADDR_VR242 := ptr($0911080C);
      ADDR_PNEVM_SIGNAL := ptr($0538D8D4);
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
