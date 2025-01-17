unit ClipboardMonitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    LastClipboardText: string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Initialize the clipboard content tracking
  LastClipboardText := Clipboard.AsText;
  Timer1.Interval := 500; // Check every 500ms
  Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  CurrentClipboardText: string;
begin
  // Check the clipboard content
  CurrentClipboardText := Clipboard.AsText;
  if CurrentClipboardText <> LastClipboardText then
  begin
    // Clipboard content has changed
    Memo1.Lines.Add('Clipboard changed: ' + CurrentClipboardText);
    LastClipboardText := CurrentClipboardText;
  end;
end;

end.

