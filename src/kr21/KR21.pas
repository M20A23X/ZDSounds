unit KR21;

interface

type
  kr21_ = class(TObject)
  private
    soundDir: String;

    // Переменные для контроллера KR21
    prevKeyA: Byte;
    prevKeyD: Byte;
    prevKeyQ: Byte;
    prevKeyE: Byte;
    KMPrevKey: String;
  protected

  public
    procedure step();

  published

    constructor Create;

  end;

implementation

uses UnitMain, soundManager, Windows, SysUtils;

// ----------------------------------------------------
// Конструктор 21KR
// ----------------------------------------------------
constructor kr21_.Create;
begin
  soundDir := 'TWS\Devices\21KR\';
end;

// ----------------------------------------------------
// Цикл 21KR
// ----------------------------------------------------
procedure kr21_.step();
begin
  if KM_OP + getasynckeystate(16) = 0 then
  begin
    // -/- A -/- //
    if (getasynckeystate(65) <> 0) and (prevKeyA = 0) then
    begin
      if KMPrevKey <> 'E' then
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '0_+.wav'))
      else
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '-A_0.wav'));
      soundManager.isPlayCabinClicks := False;
      prevKeyA := 1;
    end // -/- A [РћРўРџ] -/- //
    else if (getasynckeystate(65) = 0) and (prevKeyA <> 0) then
    begin
      if KMPrevKey <> 'E' then
      begin
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '+_0.wav'));
        soundManager.isPlayCabinClicks := False;
      end;
      KMPrevKey := 'A';
    end // -/- D -/- //
    else if (getasynckeystate(68) <> 0) and (prevKeyD = 0) then
    begin
      if KMPrevKey <> 'E' then
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '0_-.wav'))
      else
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '-A_0.wav'));
      soundManager.isPlayCabinClicks := False;
      prevKeyD := 1;
    end // -/- D [РћРўРџ] -/- //
    else if (getasynckeystate(68) = 0) and (prevKeyD <> 0) then
    begin
      if KMPrevKey <> 'E' then
      begin
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '-_0.wav'));
        soundManager.isPlayCabinClicks := False;
      end;
      KMPrevKey := 'D';
    end // -/- E -/- //
    else if (getasynckeystate(69) <> 0) and (prevKeyE = 0) then
    begin
      if KMPrevKey <> 'E' then
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '0_-A.wav'));
      soundManager.isPlayCabinClicks := False;
      prevKeyE := 1;
      KMPrevKey := 'E';
    end // -/- Q -/- //
    else if (getasynckeystate(81) <> 0) and (prevKeyQ = 0) then
    begin
      if KMPrevKey <> 'E' then
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '0_+A.wav'))
      else
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '-A_0.wav'));
      soundManager.isPlayCabinClicks := False;
      prevKeyQ := 1;
    end // -/- Q [РћРўРџ] -/- //
    else if (getasynckeystate(81) = 0) and (prevKeyQ <> 0) then
    begin
      if KMPrevKey <> 'E' then
      begin
        soundManager.CabinClicksF := StrNew(PChar(soundDir + '+A_0.wav'));
        soundManager.isPlayCabinClicks := False;
      end;
      KMPrevKey := 'Q';
    end;
  end;
  if KM_OP > Prev_KM_OP then
  begin
    if Prev_KM_OP > 0 then
      soundManager.CabinClicksF := StrNew(PChar(soundDir + 'op+.wav'))
    else
      soundManager.CabinClicksF := StrNew(PChar(soundDir + 'vvod_op.wav'));
    soundManager.isPlayCabinClicks := False;
  end;
  if KM_OP < Prev_KM_OP then
  begin
    if KM_OP > 0 then
      soundManager.CabinClicksF := StrNew(PChar(soundDir + 'op-.wav'))
    else
      soundManager.CabinClicksF := StrNew(PChar(soundDir + 'vivod_op.wav'));
    soundManager.isPlayCabinClicks := False;
  end;
  if getasynckeystate(65) = 0 then
    prevKeyA := 0;
  if getasynckeystate(68) = 0 then
    prevKeyD := 0;
  if getasynckeystate(69) = 0 then
    prevKeyE := 0;
  if getasynckeystate(81) = 0 then
    prevKeyQ := 0;
end;

end.
