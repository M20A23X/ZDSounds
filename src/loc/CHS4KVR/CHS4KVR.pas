unit CHS4KVR;

interface

uses VR242;

type
  chs4kvr_ = class(TObject)
  private
    soundDir: String;

    GRIncrementer: Byte;

    vr242__: vr242_;

    faktGR: Double;

    procedure vent_step();
    procedure mk_step();
    procedure em_latch_step();
  protected

  public

    procedure step();

  published

    constructor Create;

  end;

implementation

uses UnitMain, soundManager, Bass, SysUtils;

// ----------------------------------------------------
//
// ----------------------------------------------------
constructor chs4kvr_.Create;
begin
  soundDir := 'TWS\CHS4KVR\';
  vr242__ := vr242_.Create();
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs4kvr_.step();
begin
  if FormMain.cbVspomMash.Checked = True then
  begin
    vent_step();
    mk_step();
    vr242__.step();
  end;

  if FormMain.cbCabinClicks.Checked = True then
    em_latch_step();
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs4kvr_.em_latch_step();
begin
  if ((Prev_KMAbs = 0) and (KMPos1 > 0)) or ((KMPos1 = 0) and (Prev_KMAbs > 0)) then
  begin
    IMRZashelka := PChar('TWS/EM_zashelka.wav');
  end;
  if PrevReostat + Reostat = 1 then
  begin
    IMRZashelka := PChar('TWS/EM_zashelka.wav');
  end;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs4kvr_.mk_step();
begin
  Inc(GRIncrementer2);
  if GRIncrementer2 > 10 then
  begin
    faktGR := GR;
    GRIncrementer2 := 0;

    if faktGR > PrevGR then
    begin
      Compressor := 1;
    end
    else
    begin
      Compressor := 0;
    end;
  end;

  if AnsiCompareStr(CompressorCycleF, '') <> 0 then
  begin
    if (GetChannelRemaindPlayTime2Sec(Compressor_Channel) <= 0.8) and (BASS_ChannelIsActive(CompressorCycleChannel) = 0)
    then
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
      CompressorF := StrNew(PChar(soundDir + 'mk_start.wav'));
      CompressorCycleF := StrNew(PChar(soundDir + 'mk_loop.wav'));
      XCompressorF := StrNew(PChar(soundDir + 'x_mk_start.wav'));
      XCompressorCycleF := StrNew(PChar(soundDir + 'x_mk_loop.wav'));
      isPlayCompressor := False;
      isPlayXCompressor := False;
    end
    else
    begin
      CompressorF := StrNew(PChar(soundDir + 'mk_stop.wav'));
      XCompressorF := StrNew(PChar(soundDir + 'x_mk_stop.wav'));
      CompressorCycleF := PChar('');
      XCompressorCycleF := PChar('');
      isPlayCompressor := False;
      isPlayXCompressor := False;
    end;
  end;

  PrevGR := faktGR;
end;

// ----------------------------------------------------
//
// ----------------------------------------------------
procedure chs4kvr_.vent_step();
begin
  if (Vent <> Prev_Vent) and (Vent = Prev_VentLocal) then
  begin
    VentTDVol := FormMain.trcBarVspomMahVol.Position / 100;
    if (Vent = 4113039) and (Prev_Vent = 0) then
    begin // Р—Р°РїСѓСЃРє Р’РЈ
      VentPitchDest := 0;
    end;
    if (Vent = 4126146) and (Prev_Vent = 0) then
    begin // Р—Р°РїСѓСЃРє Р’РЈ Рё РўР” (2-Р°СЏ РїРѕР·РёС†РёСЏ)
      VentPitchDest := -1.5;
      VentTDF := StrNew(PChar(soundDir + 'ventTD-start.wav'));
      VentCycleTDF := StrNew(PChar(soundDir + 'ventTD.wav'));
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-start.wav'));
      XVentCycleTDF := StrNew(PChar(soundDir + 'x_ventTD.wav'));
      isPlayVentTD := False; // Р—РІСѓРє РІ РєР°Р±РёРЅРµ
      isPlayVentTDX := False;
    end;
    if (Vent = 4050124) and (Prev_Vent = 0) then
    begin // Р—Р°РїСѓСЃРє РўР” (1->2 РїРѕР·РёС†РёСЏ)
      VentTDF := StrNew(PChar(soundDir + 'ventTD-start.wav'));
      VentCycleTDF := StrNew(PChar(soundDir + 'ventTD.wav'));
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-start.wav'));
      XVentCycleTDF := StrNew(PChar(soundDir + 'x_ventTD.wav'));
      isPlayVentTD := False; // Р—РІСѓРє РІ РєР°Р±РёРЅРµ
      isPlayVentTDX := False;
      if KMPos1 >= 2 then
        VentPitchDest := -1.5
      else
        VentPitchDest := 0;
    end;
    if Vent = 0 then
    begin // Р’Р«РљР›
      // if (BASS_ChannelIsActive(Vent_Channel_FX) <> 0) or (BASS_ChannelIsActive(VentCycle_Channel_FX) <> 0) then
      // begin
      // StopVent := True;
      // isPlayVent := False;
      // isPlayVentX := False;
      // VentPitchDest := 0;
      // end;
      if (BASS_ChannelIsActive(VentTD_Channel) <> 0) or (BASS_ChannelIsActive(VentCycleTD_Channel) <> 0) then
      begin
        VentTDF := StrNew(PChar(soundDir + 'ventTD-stop.wav'));
        VentCycleTDF := PChar('');
        isPlayVentTD := False; // Р—РІСѓРє РІ РєР°Р±РёРЅРµ
        XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-stop.wav'));
        XVentCycleTDF := PChar('');
        isPlayVentTDX := False;
      end;
    end;
    if (Vent = 4113039) and (Prev_Vent = 4126146) then
    begin // РћСЃС‚Р°РЅРѕРІРєР° РўР”
      VentTDF := StrNew(PChar(soundDir + 'ventTD-stop.wav'));
      VentCycleTDF := PChar('');
      isPlayVentTD := False; // Р—РІСѓРє РІ РєР°Р±РёРЅРµ
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-stop.wav'));
      XVentCycleTDF := PChar('');
      isPlayVentTDX := False;
    end;
    if (Vent = 4113039) and (Prev_Vent = 4050124) then
    begin // Р—Р°РїСѓСЃРє Р’РЈ, РѕСЃС‚Р°РЅРѕРІРєР° РўР”
      VentPitchDest := 0;
      VentTDF := StrNew(PChar(soundDir + 'ventTD-stop.wav'));
      VentCycleTDF := PChar('');
      isPlayVentTD := False;
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-stop.wav'));
      XVentCycleTDF := PChar('');
      isPlayVentTDX := False;
    end;
    if (Vent = 4126146) and (Prev_Vent = 4113039) then
    begin // Р—Р°РїСѓСЃРє РўР”, РїРѕСЃР»Рµ Р·Р°РїСѓСЃРєР° Р’РЈ
      VentTDF := StrNew(PChar(soundDir + 'ventTD-start.wav'));
      VentCycleTDF := StrNew(PChar(soundDir + 'ventTD.wav'));
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-start.wav'));
      XVentCycleTDF := StrNew(PChar(soundDir + 'x_ventTD.wav'));
      isPlayVentTD := False;
      isPlayVentTDX := False;
      VentPitchDest := -1.5;
    end;
    if (Vent = 4126146) and (Prev_Vent = 4050124) then
    begin // Р—Р°РїСѓСЃРє Р’РЈ (2-Р°СЏ РїРѕР·РёС†РёСЏ)
      VentPitchDest := -1.5;
    end;
    if (Vent = 4050124) and (Prev_Vent = 4113039) then
    begin // РћСЃС‚Р°РЅРѕРІРєР° Р’РЈ, Р·Р°РїСѓСЃРє РўР”
      VentPitchDest := 0;
      VentTDF := StrNew(PChar(soundDir + 'ventTD-start.wav'));
      VentCycleTDF := StrNew(PChar(soundDir + 'ventTD.wav'));
      XVentTDF := StrNew(PChar(soundDir + 'x_ventTD-start.wav'));
      XVentCycleTDF := StrNew(PChar(soundDir + 'x_ventTD.wav'));
      isPlayVentTD := False;
      isPlayVentTDX := False;
    end;
    if (Vent = 4050124) and (Prev_Vent = 4126146) then
    begin // РћСЃС‚Р°РЅРѕРІРєР° Р’РЈ
      VentPitchDest := 0;
    end;
  end;
end;

end.
