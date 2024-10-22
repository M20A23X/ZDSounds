program TWS;

uses
  Forms,
  UnitMain in 'src\main\UnitMain.pas' {FormMain},
  UnitAuthors in 'src\main\UnitAuthors.pas' {FormAuthors},
  UnitSAVPEHelp in 'src\savp\UnitSAVPEHelp.pas' {FormSAVPEHelp},
  UnitUSAVP in 'src\savp\UnitUSAVP.pas' {FormUSAVP},
  SAVP in 'src\savp\SAVP.pas',
  ExtraUtils in 'src\extra\ExtraUtils.pas',
  SoundManager in 'src\soundManager\SoundManager.pas',
  UnitSOVIHelp in 'src\savp\UnitSOVIHelp.pas' {FormSOVIHelp},
  BASS in 'src\bass\BASS.pas',
  bass_fx in 'src\bass\bass_fx.pas',
  Ram in 'src\ram\Ram.pas',
  Types in 'src\types\Types.pas';

{$R *.res}

begin
  Application.Initialize;
  // Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
