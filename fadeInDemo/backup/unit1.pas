unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls ;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Opacity:Integer;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.TrackBar1Change(Sender: TObject);
begin
        Form1.AlphaBlendValue:=TrackBar1.Position;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:='Mastering Lazarus Components: Learn, Experiment, Create';
  Form1.Color:=clBlack;
  Opacity := 0;           // Start with zero opacity
  Timer1.Interval := 10;  // Set the interval for the timer (adjust as needed)
  Timer1.Enabled := True; // Start the timer to initiate the fade-in effect

  // Initialize trackbar properties
  TrackBar1.Min := 0;
  TrackBar1.Max := 255;
  TrackBar1.Position := 255; // Start with fully opaque

  // Initialize form properties
  AlphaBlend := True;       // Enable AlphaBlend

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //PlaySoundWithAplay('/home/aruna/wav/kongas.wav');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Opacity < 255 then
  begin
    Opacity := Opacity + 1; // Increase opacity gradually
    if Opacity > 255 then
      Opacity := 255; // Ensure opacity does not exceed 255
      AlphaBlendValue:=Opacity;
  end
  else
  begin
    Timer1.Enabled := False; // Stop the timer once opacity is fully faded in
  end;
end;
end.

