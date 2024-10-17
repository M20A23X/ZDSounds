unit CHS7;

interface

type
  chs7_ = class(TObject)
  private
    soundDir: String;

    procedure vent_PTR_step();
    procedure bv_step();
    procedure zhaluzi_step();
    procedure U_relay_step();
    procedure mk_step();
    procedure vent_step();
    procedure em_latch_step();
  protected

  public

    procedure step();

  published

    constructor Create;

  end;

implementation

uses UnitMain, soundManager, SysUtils, Bass, Math;

// ----------------------------------------------------
//
// ----------------------------------------------------
constructor chs7_.Create;
begin
  soundDir := 'TWS\CHS7\';
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.step();
begin
  if FormMain.cbVspomMash.Checked = True then
  begin
    bv_step();
    zhaluzi_step();
    vent_PTR_step();
    mk_step();
  end;

  if FormMain.cbCabinClicks.Checked = True then
  begin
    U_relay_step();
    em_latch_step();
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.em_latch_step();
begin
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.vent_PTR_step();

begin
  mvTDAttrs[A_VOLUME] := power((TEDAmperage / UltimateTEDAmperage * 1.2), 0.5) *
    (FormMain.trcBarVspomMahVol.Position / 100);
  mvTDAttrs[A_PITCH] := -7 + TEDAmperage * 10 / UltimateTEDAmperage;

  if (KMPos1 <> PrevKMAbs) Or (BV <> PrevBV) Or (Voltage <> PrevVoltage) then
  begin
    if CheckChannel(MVTDChannelsFX[0], False) and (BV <> 0) and (Voltage <> 0) then
    begin
      if (KMPos1 in [1 .. 17]) Or (KMPos1 in [21 .. 35]) Or (KMPos1 in [39 .. 53]) then
        MVsTDState := 1;
    end;
    if CheckChannel(MVTDChannelsFX[0]) then
    begin
      if (KMPos1 = 0) Or (KMPos1 in [18 .. 20]) Or (KMPos1 in [36 .. 38]) Or (KMPos1 in [54 .. 56]) Or (BV = 0) and
        (PrevBV <> 0) Or (Voltage = 0) and (PrevVoltage <> 0) then
        MVsTDState := 0;
    end;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.bv_step();
begin
  // БВ на ЧС7
  if (BV <> 0) and (PrevBV = 0) then
  begin
    LocoPowerEquipmentF := StrNew(PChar(soundDir + 'bv_on.wav'));
    isPlayLocoPowerEquipment := False;
  end;
  if (BV = 0) and (PrevBV <> 0) then
  begin
    LocoPowerEquipmentF := StrNew(PChar(soundDir + 'bv_off.wav'));
    isPlayLocoPowerEquipment := False;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.zhaluzi_step();
begin
  // Жалюзи на ЧС7 (открытие)
  if (Zhaluzi <> 0) and (PrevZhaluzi = 0) then
  begin
    if isCameraInCabin = True then
    begin
      LocoPowerEquipmentF := StrNew(PChar(soundDir + 'zhalusi_on.wav'));
    end
    else
    begin
      if (Camera <> 2) or (CoupleStat = 0) then
      begin
        LocoPowerEquipmentF := StrNew(PChar(soundDir + 'x_zhalusi_on.wav'));
      end;
    end;
    isPlayLocoPowerEquipment := False;
  end;
  // Жалюзи на ЧС7 (закрытие)
  if (Zhaluzi = 0) and (PrevZhaluzi <> 0) then
  begin
    if isCameraInCabin = True then
    begin
      LocoPowerEquipmentF := StrNew(PChar(soundDir + 'zhalusi_off.wav'));
    end
    else
    begin
      if (Camera <> 2) or (CoupleStat = 0) then
      begin
        LocoPowerEquipmentF := StrNew(PChar(soundDir + 'x_zhalusi_off.wav'));
      end;
    end;
    isPlayLocoPowerEquipment := False;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.U_relay_step();
begin
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.mk_step();
begin
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.vent_step();
begin;
end;

end.
