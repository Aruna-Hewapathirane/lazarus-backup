unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Process1: TProcess;
    procedure Button1Click(Sender: TObject);
  private
    procedure PlaySoundWithAplay(const FileName: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

//procedure TForm2.Button1Click(Sender: TObject);
//begin
//  PlaySoundWithAplay('/home/aruna/wav/kongas.wav');
//end;

procedure TForm1.PlaySoundWithAplay(const FileName: string);
var
  Process: TProcess;
begin
//      showmessage('??');
  Process := TProcess.Create(nil);
  try
    Process.Executable := 'aplay';
    Process.Parameters.Add(FileName);
    Process.Options := [poNoConsole];
    Process.Execute;

  finally
    Process.Free;
  end;
end;

end.

