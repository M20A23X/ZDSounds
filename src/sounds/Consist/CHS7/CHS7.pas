unit CHS7;

interface

type
  chs7_ = class(TObject)
  private
    procedure vent_PTR_step();
    procedure bv_step();
    procedure zhalusi_step();
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
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.step();
begin
  bv_step();
  zhalusi_step();
  vent_PTR_step();
  mk_step();
  U_relay_step();
  em_latch_step();
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
var
  mv1Mash: TSound;
  mv1: TSound;
  mv2: TSound;
begin
  if mvstd.current <> mvstd.previous then
  begin
    mv1Mash.getInit('mvTD1-cab');
    mv1.getInit('mvTD1');
    mv2.getInit('mvTD2');

    mv1Mash.channels[0].attrs.volume := power((TEDAmperage.current / UltimateTEDAmperage * 1.2), 0.5);
    mv1Mash.channels[0].attrs.pitch := -7 + TEDAmperage.current * 10 / UltimateTEDAmperage;

    if mv1Mash.check(0, False) and (BV.current <> 0) and (Voltage.current <> 0) then
    begin
      if (KM1.current in [1 .. 17]) Or (KM1.current in [21 .. 35]) Or (KM1.current in [39 .. 53]) then
        mvstd.current := 1;
    end;
    if mv1Mash.check(0) and ((KM1.current = 0) Or (BV.current = 0) Or (Voltage.current = 0)) then
      mvstd.current := 0;

    mv1.channels[0].attrs := mv1Mash.channels[0].attrs;
    mv2.channels[0].attrs := mv1Mash.channels[0].attrs;
  end;
end;

// BV
procedure chs7_.bv_step();
var
  soundFile: String;
  entity: TSound;
begin
  if BV.current <> BV.previous then
  begin
    entity.getInit('bv');

    if (BV.current <> 0) and (BV.previous = 0) then
      soundFile := 'TWS/' + consist.Loco + '/' + 'bv_on.wav'
    else if (BV.current = 0) and (BV.previous <> 0) then
      soundFile := 'TWS/' + consist.Loco + '/' + 'bv_off.wav';

    entity.restart(0, soundFile);
  end;
end;

// zhalusi
procedure chs7_.zhalusi_step();
var
  zhalusi1Cab: TSound;
  zhalusi1: TSound;
  zhalusi2: TSound;
begin
  if zhalusi.current <> zhalusi.previous then
  begin
    zhalusi1Cab.getInit('zhalusi1-cab');
    zhalusi1.getInit('zhalusi1');
    zhalusi2.getInit('zhalusi2');

    if (zhalusi.current <> 0) and (zhalusi.previous = 0) then
    begin
      zhalusi1Cab.restart(0, 'TWzhalusi_on.wav');
      zhalusi1.restart(0, 'x_zhalusi_on.wav');
      zhalusi2.restart(0, 'x_zhalusi_on.wav');
    end
    else if (zhalusi.current = 0) and (zhalusi.previous <> 0) then
    begin
      zhalusi1Cab.restart(0, 'zhalusi_off.wav');
      zhalusi1.restart(0, 'x_zhalusi_off.wav');
      zhalusi2.restart(0, 'x_zhalusi_off.wav');
    end;
  end;
end;

procedure chs7_.U_relay_step();
begin
end;

procedure chs7_.mk_step();
begin
end;

procedure chs7_.vent_step();
begin;
end;

end.
