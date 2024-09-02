unit sine;

interface

uses
  uos_flat,
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  ExtCtrls,
  ComCtrls,
  StdCtrls;

type

  { Sine Wave }

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Trackbar1: TTrackBar;
    Trackbar2: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure initsound();
    procedure Trackbar1Change(Sender: TObject);
  private
    { Private declarations }
    FOffset: integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PlayerIndex1, inindex1: integer;

implementation

{$R *.lfm}

procedure TForm1.initsound();
var
  ordir, opath, PA_FileName: string;
  res: integer;
begin
  ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));

{$IFDEF Windows}
    {$if defined(cpu64)}
   PA_FileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
    {$else}
   PA_FileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
    {$endif}
{$ENDIF}

 {$if defined(CPUAMD64) and  defined(linux) }
   PA_FileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
 {$ENDIF}

 {$if defined(cpu86) and defined(linux)}
   PA_FileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
 {$ENDIF}

 {$if defined(linux) and defined(cpuarm)}
   PA_FileName := ordir + 'lib/Linux/arm_raspberrypi/libportaudio-arm.so';
 {$ENDIF}

 {$if defined(linux) and defined(cpuaarch64)}
 PA_FileName := ordir + 'lib/Linux/aarch64_raspberrypi/libportaudio_aarch64.so';
 {$ENDIF}

{$IFDEF freebsd}
   {$if defined(cpu64)}
   PA_FileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
   {$else}
   PA_FileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
   {$endif}
 {$ENDIF}

{$IFDEF Darwin}
 {$IFDEF CPU32}
   opath := ordir;
   opath := copy(opath, 1, Pos('/UOS', opath) - 1);
   PA_FileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
   {$ENDIF}

  {$IFDEF CPU64}
   opath := ordir;
   opath := copy(opath, 1, Pos('/UOS', opath) - 1);
   PA_FileName := opath + '/lib/Mac/64bit/LibPortaudio-64.dylib';
   {$ENDIF}
{$ENDIF}

  form1.Caption := ' init';
  // Load the libraries (here only portaudio is needed)
  // function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName, FaadFileName, opusfilefilename:: PChar) : LongInt;

  res := uos_LoadLib(PChar(PA_FileName), nil, nil, nil, nil, nil);

  if res = 0 then
  begin

    //// Create the player.
    //// PlayerIndex : from 0 to what your computer can do !
    //// If PlayerIndex exists already, it will be overwriten...

    PlayerIndex1 := 0;
    inindex1     := -1;

    if uos_CreatePlayer(PlayerIndex1) then

      inindex1 :=
        uos_AddFromSynth(PlayerIndex1, -1, -1, -1, -1, -1, -1, -1, 0, -1, -1, 0, -1, -1, -1);

  { function uos_AddFromSynth(PlayerIndex: cint32; Channels: integer; WaveTypeL, WaveTypeR: integer;
                          FrequencyL, FrequencyR: float; VolumeL, VolumeR: float;
                          duration : cint32; NbHarmonics: cint32; EvenHarmonics: cint32;
                          OutputIndex: cint32;  SampleFormat: cint32 ;
                          SampleRate: cint32 ; FramesCount : cint32): cint32;

// Add a input from Synthesizer with custom parameters
// Channels: default: -1 (2) (1 = mono, 2 = stereo)
// WaveTypeL: default: -1 (0) (0 = sine-wave 1 = square-wave, used for mono and stereo)
// WaveTypeR: default: -1 (0) (0 = sine-wave 1 = square-wave, used for stereo, ignored for mono)
// FrequencyL: default: -1 (440 htz) (Left frequency, used for mono)
// FrequencyR: default: -1 (440 htz) (Right frequency, used for stereo, ignored for mono)
// VolumeL: default: -1 (= 1) (from 0 to 1) => volume left
// VolumeR: default: -1 (= 1) (from 0 to 1) => volume rigth (ignored for mono)
// Duration: default:  -1 (= 1000)  => duration in msec (0 = endless)
// NbHarmonics: default:  -1 (= 0) Number of Harmonics
// EvenHarmonics: default: -1 (= 0) (0 = all harmonics, 1 = Only even harmonics)
// OutputIndex: Output index of used output
           // -1: all output, -2: no output, other cint32 refer to
           // a existing OutputIndex
           // (if multi-output then OutName = name of each output separeted by ';')
// SampleFormat: default : -1 (0: Float32) (0: Float32, 1:Int32, 2:Int16)
// SampleRate: delault : -1 (44100)
// FramesCount: -1 default : 1024
//  result:  Input Index in array  -1 = error
}

    {$if defined(cpuarm) or defined(cpuaarch64)}  // need a lower latency
     if uos_AddIntoDevOut(PlayerIndex1,-1,0.3,-1,-1, 0,-1,-1) > - 1 then
      {$else}
    if uos_AddIntoDevOut(PlayerIndex1, -1, -1, -1, -1, 0, -1, -1) > -1 then
      {$endif}
      //// add a Output into device with custom parameters
      //////////// PlayerIndex : Index of a existing Player
      //  result : -1 nothing created, otherwise Output Index in array

      /////// everything is ready, here we are, lets play it...
      Trackbar1Change(nil);
      uos_Play(PlayerIndex1);

  end;

end;

procedure TForm1.Trackbar1Change(Sender: TObject);
begin
  uos_InputSetSynth(PlayerIndex1, inindex1, -1, -1, Trackbar2.Position * 100, Trackbar2.Position * 100,
    Trackbar1.Position / 200, Trackbar1.Position / 200, -1, 0, -1, True);

   {
       procedure InputSetSynth(InputIndex: cint32; WaveTypeL, WaveTypeR: integer;
       FrequencyL, FrequencyR: float; VolumeL, VolumeR: float; duration: cint32;
       NbHarmonic: cint32; EvenHarmonics: cint32; Enable: boolean);
// InputIndex: one existing input index
// WaveTypeL: do not change: -1 (0 = sine-wave 1 = square-wave, used for mono and stereo)
// WaveTypeR: do not change: -1 (0 = sine-wave 1 = square-wave, used for stereo, ignored for mono)
// FrequencyL: do not change: -1 (Left frequency, used for mono)
// FrequencyR: do not change: -1 (440 htz) (Right frequency, used for stereo, ignored for mono)
// VolumeL: do not change: -1 (= 1) (from 0 to 1) => volume left
// VolumeR: do not change: -1 (from 0 to 1) => volume rigth (ignored for mono)
// Duration: in msec (-1 = do not change)
// NbHarmonic: Number of Harmonics (-1 not change)
// EvenHarmonics: default: -1 (= 0) (0 = all harmonics, 1 = Only even harmonics)
// Enable: true or false ;
}

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FOffset        := 0;
  Timer1.Enabled := True; // Start the timer when the form is created
  application.ProcessMessages;
  initsound();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  x, y: integer;
  waveWidth, waveHeight: integer;
  Bitmap: TBitmap;
  Amplitude: integer;
  Frequency: integer;
begin
  waveWidth  := Image1.Width;
  waveHeight := Image1.Height;

  Amplitude := Trackbar1.Position;
  Frequency := Trackbar2.Position;

  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(waveWidth, waveHeight);
    Bitmap.Canvas.Brush.Color := clWhite;
    Bitmap.Canvas.FillRect(0, 0, waveWidth, waveHeight);

    Bitmap.Canvas.Pen.Color := clBlack;
    Bitmap.Canvas.Pen.Width := 14;

    // Draw the sine wave
    for x := 0 to waveWidth - 1 do
    begin
      y := Round(waveHeight div 2 + Amplitude * Sin((x + FOffset) * Frequency * Pi / 180));
      Bitmap.Canvas.Pixels[x, y] := Bitmap.Canvas.Pen.Color;
    end;

    Image1.Picture.Bitmap.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;

  // Update the offset to move the sine wave
  FOffset := (FOffset + 5) mod 360;
end;

end.

