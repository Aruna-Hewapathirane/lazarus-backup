unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Memo1 : TMemo;
    SpinEdit1 : TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

{ TForm1 }

uses Unit2 {$ifdef LINUX}, mvxwindow{$endif};    // this demo makes sense only with Linux



procedure TForm1.FormShow(Sender: TObject);
begin
    Form2.Left := 200;
    Form2.Caption := 'Move Me';
    Form2.show;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    if MvXWinWorkSpace('Move Me', SpinEdit1.Value) then
         Memo1.Append('Seems to have worked.')
    else Memo1.Append(MvXWinError);
end;

end.


