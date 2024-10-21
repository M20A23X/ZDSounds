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
  if FormMain.cbVspomMash.Checked then
  begin
    bv_step();
    zhaluzi_step();
    vent_PTR_step();
    mk_step();
  end;

  if FormMain.cbCabinClicks.Checked then
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
  mvTDAttrs[A_VOLUME] := power((TEDAmperage[V_CUR] / UltimateTEDAmperage * 1.2), 0.5) *
    (FormMain.trcBarVspomMahVol.Position / 100);
  mvTDAttrs[A_PITCH] := -7 + TEDAmperage[V_CUR] * 10 / UltimateTEDAmperage;

  if CheckChannel(MVsTDFX[0], False) and (BV[V_CUR] <> 0) and (Voltage[V_CUR] <> 0) then
  begin
    if (KM1[V_CUR] in [1 .. 17]) Or (KM1[V_CUR] in [21 .. 35]) Or (KM1[V_CUR] in [39 .. 53]) then
      MVsTD := 1;
  end;
  if CheckChannel(MVsTDFX[0]) and ((KM1[V_CUR] = 0) Or (BV[V_CUR] = 0) Or (Voltage[V_CUR] = 0)) then
    MVsTD := 0;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.bv_step();
var
  soundFile: String;
begin
  if (BV[V_CUR] <> 0) and (BV[V_PRV] = 0) then
    soundFile := soundDir + 'bv_on.wav'
  else if (BV[V_CUR] = 0) and (BV[V_PRV] <> 0) then
    soundFile := soundDir + 'bv_off.wav';

  PlaySound(soundFile, CAM_LOCO);
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.zhaluzi_step();
var
  soundFile: String;
  camState: TCameraEnum;
begin
  if (Zhaluzi[V_CUR] <> 0) and (Zhaluzi[V_PRV] = 0) then
  begin
    if isCameraInCabin then
      soundFile := soundDir + 'zhalusi_on.wav'
    else if (Camera[V_CUR] <> 2) or (CoupleStat[V_CUR] = 0) then
      soundFile := soundDir + 'x_zhalusi_on.wav';
  end
  else if (Zhaluzi[V_CUR] = 0) and (Zhaluzi[V_PRV] <> 0) then
  begin
    if isCameraInCabin then
      soundFile := soundDir + 'zhalusi_off.wav'
    else if (Camera[V_CUR] <> 2) or (CoupleStat[V_CUR] = 0) then
      soundFile := soundDir + 'x_zhalusi_off.wav';
  end;

  camState := CAM_CAB;
  if isCameraInCabin = False then
    camState := CAM_LOCO;
  PlaySound(soundFile, camState);
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
