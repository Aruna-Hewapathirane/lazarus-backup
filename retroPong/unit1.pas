unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    lblGameOver: TLabel;
    Restart: TLabel;
    tmrGame: TTimer;
    YoutubeURL: TLabel;
    lblScore: TLabel;
    Paddle: TShape;
    Ball: TShape;
    procedure Button1Click(Sender: TObject);
    procedure ControlPaddle(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PaddleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure RestartClick(Sender: TObject);
    procedure RestartMouseEnter(Sender: TObject);
    procedure RestartMouseLeave(Sender: TObject);
    procedure tmrGameTimer(Sender: TObject);
  private
    procedure InitGame;
    procedure UpdateScore;
    procedure GameOver;
    procedure PlaySound(const FileName: string);

  public

  end;

var
  Form1: TForm1;
  Score:Integer;
  SpeedX,SpeedY:Integer;

implementation

{$R *.lfm}

{ TForm1 }


// Controls paddle Movemnet when mouse cursor is on FORM
procedure TForm1.ControlPaddle(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Paddle.Left:=X- Paddle.Width div 2;
  Paddle.Top:=ClientHeight-Paddle.Height-2;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  PlaySound('/home/aruna/lazarus/retroPong/Sound-Assets/Kawai-K5000W-Ding(1).wav')
    PlaySound('Sound-Assets/Kawai-K5000W-Ding(1).wav')
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     DoubleBuffered:=True; //prevents lag (??)
     InitGame;
end;

// Controls paddle Movemnet when mouse cursor is on PADDLE
procedure TForm1.PaddleMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     ControlPaddle(Sender,Shift, X+Paddle.Left,Y+Paddle.Top)
end;

procedure TForm1.RestartClick(Sender: TObject);
begin
       InitGame;
end;

procedure TForm1.RestartMouseEnter(Sender: TObject);
begin
       Restart.Font.Style:=[fsBold];
       Restart.Font.Size:=28;
end;

procedure TForm1.RestartMouseLeave(Sender: TObject);
begin
  Restart.Font.Style:=[];
  Restart.Font.Size:=18;
end;

procedure TForm1.tmrGameTimer(Sender: TObject);
begin
  Ball.Left:=Ball.Left+SpeedX;
  Ball.Top:=Ball.Top+SpeedY;

  if (Ball.Top<=0) then SpeedY:=-SpeedY; // Hit Top Boundary so reverse direction
  if(Ball.Left <=0 ) or (Ball.Left+Ball.Width >=ClientWidth) then SpeedX:=-SpeedX; //check if left wall hit or right wall hit

  if(Ball.Left+Ball.Width >= Paddle.Left) and
    (Ball.Left <=Paddle.Left+Paddle.Width) and
    (Ball.Top+Ball.Height >= Paddle.Top) then
  begin
    SpeedY:=-SpeedY;
    UpdateScore;
  end;

  If (Ball.Top+Ball.Height > ClientHeight) then GameOver;

end;

procedure TForm1.InitGame;
begin
     Score:=0;
     SpeedX:=3;
     SpeedY:=3;

     Ball.Left:=10;
     Ball.Top:=10;

     lblGameOver.Visible:=False;
     Restart.Visible:=False;
     YoutubeURL.Visible:=False; // Original Youtube Tutorial Link

     tmrGame.Enabled:=True;
     tmrGame.Interval:=16;
     UpdateScore;
end;

// Try using direct call to UpdateScore
// unit1.pas(89,3) Error: Identifier not found "lblScore"
// then use TForm1.UpdateScore
procedure TForm1.UpdateScore;
begin
//  Score:=Score+1;
  Inc(Score,10);
  PlaySound('Sound-Assets/Kawai-K5000W-Ding(1).wav');
  lblScore.Caption:= 'Score:   ' + IntToStr(Score);
end;

procedure TForm1.GameOver;
begin
  tmrGame.Enabled:=False;
  lblGameOver.Visible := True;
  Restart.Visible:=True;
  YoutubeURL.Visible  := True; // Original Youtube Tutorial Link
  PlaySound('Sound-Assets/gameover.wav');
end;


procedure TForm1.PlaySound(const FileName: string);
var
  ProcessPlayer: TProcess;
begin
  ProcessPlayer := TProcess.Create(nil);
  try
    ProcessPlayer.Executable := 'aplay';
    ProcessPlayer.Parameters.Add(FileName);
    ProcessPlayer.Options := [];
    ProcessPlayer.Execute;
  finally
    ProcessPlayer.Free;
  end;
end;




end.

