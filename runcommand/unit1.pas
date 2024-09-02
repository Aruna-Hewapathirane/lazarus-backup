unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  outstr:String;
begin
//  RunCommand('lsblk', ['-S', '-J'], outstr);
//  RunCommand('lsblk', ['-S'], outstr);
//    RunCommand('dmesg', [], outstr);
    RunCommand('hostnamectl', [], outstr);
    writeln(outstr);
    Memo1.Lines.Add(outstr);
end;

end.


