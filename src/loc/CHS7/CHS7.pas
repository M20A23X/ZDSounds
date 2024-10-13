﻿unit CHS7;

interface

uses KR21;

type
  chs7_ = class(TObject)
  private
    soundDir: String;

    kr21__: kr21_;

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

  kr21__ := kr21_.Create();
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
    kr21__.step();
    U_relay_step();
    em_latch_step();
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.em_latch_step();
begin
  if ((Prev_KMAbs = 0) and (KM_Pos_1 > 0)) or
    ((KM_Pos_1 = 0) and (Prev_KMAbs > 0)) then
  begin
    IMRZashelka := PChar('TWS/EM_zashelka.mp3');
    isPlayIMRZachelka := False;
  end;
  if PrevReostat + Reostat = 1 then
  begin
    IMRZashelka := PChar('TWS/EM_zashelka.mp3');
    isPlayIMRZachelka := False;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.vent_PTR_step();
var
  I: Integer;
begin
  VentTDVol := power((TEDAmperage / UltimateTEDAmperage * 1.2), 0.5) *
    (FormMain.trcBarVspomMahVol.Position / 100);
  VentTDPitch := -7 + TEDAmperage * 10 / UltimateTEDAmperage;

  if (KM_Pos_1 <> Prev_KMAbs) Or (BV <> PrevBV) Or (Voltage <> PrevVoltage) then
  begin
    I := BASS_ChannelIsActive(VentTD_Channel) + BASS_ChannelIsActive
      (VentCycleTD_Channel);
    if ((I = 0) Or (StopVentTD = True)) and (BV <> 0) and (Voltage <> 0) then
    begin
      if (KM_Pos_1 in [1 .. 17]) Or (KM_Pos_1 in [21 .. 35]) Or
        (KM_Pos_1 in [39 .. 53]) then
      begin
        VentTDF := StrNew(PChar(soundDir + 'mvPTR_start.mp3'));
        VentCycleTDF := StrNew(PChar(soundDir + 'mvPTR_loop.mp3'));
        XVentTDF := StrNew(PChar(soundDir + 'x_mvPTR_start.mp3'));
        XVentCycleTDF := StrNew(PChar(soundDir + 'x_mvPTR_loop.mp3'));
        isPlayVentTD := False;
        isPlayVentTDX := False;
        StopVentTD := False;
      end;
    end;
    if (I <> 0) and (StopVentTD = False) then
    begin
      if (KM_Pos_1 = 0) Or (KM_Pos_1 in [18 .. 20]) Or (KM_Pos_1 in [36 .. 38])
        Or (KM_Pos_1 in [54 .. 56]) Or ((BV = 0) and (PrevBV <> 0)) Or
        ((Voltage = 0) and (PrevVoltage <> 0)) then
      begin
        VentTDF := StrNew(PChar(soundDir + 'mvPTR_stop.mp3'));
        VentCycleTDF := PChar('');
        XVentTDF := StrNew(PChar(soundDir + 'x_mvPTR_stop.mp3'));
        XVentCycleTDF := PChar('');
        isPlayVentTD := False;
        isPlayVentTDX := False;
        StopVentTD := True;
      end;
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
    LocoPowerEquipmentF := StrNew(PChar(soundDir + 'bv_on.mp3'));
    isPlayLocoPowerEquipment := False;
  end;
  if (BV = 0) and (PrevBV <> 0) then
  begin
    LocoPowerEquipmentF := StrNew(PChar(soundDir + 'bv_off.mp3'));
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
      LocoPowerEquipmentF := StrNew(PChar(soundDir + 'zhalusi_on.mp3'));
    end
    else
    begin
      if (Camera <> 2) or (CoupleStat = 0) then
      begin
        LocoPowerEquipmentF := StrNew(PChar(soundDir + 'x_zhalusi_on.mp3'));
      end;
    end;
    isPlayLocoPowerEquipment := False;
  end;
  // Жалюзи на ЧС7 (закрытие)
  if (Zhaluzi = 0) and (PrevZhaluzi <> 0) then
  begin
    if isCameraInCabin = True then
    begin
      LocoPowerEquipmentF := StrNew(PChar(soundDir + 'zhalusi_off.mp3'));
    end
    else
    begin
      if (Camera <> 2) or (CoupleStat = 0) then
      begin
        LocoPowerEquipmentF := StrNew(PChar(soundDir + 'x_zhalusi_off.mp3'));
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
  // Реле напряжения
  if (PrevVoltage = 0) and (Voltage <> 0) then
  begin
    IMRZashelka := StrNew(PChar(soundDir + 'rn.mp3'));
    isPlayIMRZachelka := False;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.mk_step();
begin
  if AnsiCompareStr(CompressorCycleF, '') <> 0 then
  begin
    if (GetChannelRemaindPlayTime2Sec(Compressor_Channel) <= 0.8) and
      (BASS_ChannelIsActive(CompressorCycleChannel) = 0) then
      isPlayCompressorCycle := False;
  end;
  if AnsiCompareStr(XCompressorCycleF, '') <> 0 then
  begin
    if (GetChannelRemaindPlayTime2Sec(XCompressor_Channel) <= 0.8) and
      (BASS_ChannelIsActive(XCompressorCycleChannel) = 0) then
      isPlayXCompressorCycle := False;
  end;

  if Compressor <> Prev_Compressor then
  begin
    if Compressor <> 0 then
    begin
      CompressorF := StrNew(PChar(soundDir + 'mk-start.mp3'));
      CompressorCycleF := StrNew(PChar(soundDir + 'mk-loop.mp3'));
      XCompressorF := StrNew(PChar(soundDir + 'x_mk-start.mp3'));
      XCompressorCycleF := StrNew(PChar(soundDir + 'x_mk-loop.mp3'));
      isPlayCompressor := False;
      isPlayXCompressor := False;
    end
    else
    begin
      CompressorF := StrNew(PChar(soundDir + 'mk-stop.mp3'));
      XCompressorF := StrNew(PChar(soundDir + 'x_mk-stop.mp3'));
      CompressorCycleF := PChar('');
      XCompressorCycleF := PChar('');
      isPlayCompressor := False;
      isPlayXCompressor := False;
    end;
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs7_.vent_step();
begin;
end;

end.
