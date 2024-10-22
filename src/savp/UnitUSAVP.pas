unit UnitUSAVP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SAVP;

type
  TFormUSAVP = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUSAVP: TFormUSAVP;
  PrevKeyNum1: Byte;

implementation

uses UnitMain;

{$R *.dfm}

procedure TFormUSAVP.Timer1Timer(Sender: TObject);
begin
  // USAVPEnabled := FormUSAVP.Showing;

  // if USAVPEnabled = True then begin
  Label1.Font.Color := clGreen;
  Label1.Caption := 'СИСТЕМА АКТИВНА!';
  // end else begin
  // Label1.Font.Color := clRed;
  // Label1.Caption := 'СИСТЕМА НЕ АКТИВНА В СИМУЛЯТОРЕ НАЖМИТЕ "NUM1"';
  // end;

  PrevKeyNum1 := GetAsyncKeyState(97);
end;

end.
