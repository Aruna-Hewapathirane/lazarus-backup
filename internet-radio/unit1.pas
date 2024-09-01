unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Process;

type
  { Streaming Internet Radio }

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Image1: TImage;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Process1: TProcess;
    //  ProcessID: Cardinal; // undocumented??
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure ListBox1Enter(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1SelectionChange(Sender: TObject; User: Boolean);
  private
    Expanded: Boolean; // To keep track of the height change direction
  public

  end;

var
  Form1: TForm1;
  RadioStations: array of array of String;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

  Process1 := TProcess.Create(Self);

  SetLength(RadioStations, 3, 2);

  // Fill the array : Station Name then URL
  RadioStations[0, 0] := 'Heart Beat FM';
  RadioStations[0, 1] := 'http://cast5.magicstreams.gr:8010/stream';
  RadioStations[1, 0] := 'Deep House Romania';
  RadioStations[1, 1] := 'https://streaming-01.xtservers.com:7000/stream';
  RadioStations[2, 0] := 'Hiru FM';
  RadioStations[2, 1] := 'https://radio.lotustechnologieslk.net:2020/stream/hirufmgarden';

  Expanded := True;
  Button4.Enabled := False;
  Button5.Enabled := False;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Process1.Running then
    Process1.Terminate(0);
end;


procedure TForm1.ListBox1Enter(Sender: TObject);
var
  url: String;
begin

  Button4.Enabled := True; // Enable STOP
  Button5.Enabled := True; // Enable STOP

  url := RadioStations[Listbox1.ItemIndex, 1];
  writeln(url);

  if Process1.Running then    //stop play if running
    Process1.Terminate(0);


  Memo1.Lines.Add('Process started: ');

  // Configure TProcess to run the aplay or mpv command
  Process1.Executable := 'mpv';
  Process1.Parameters.Clear;
  Process1.Parameters.Add(url); // Replace with the path to your WAV file
  //Process1.Options := [poWaitOnExit]; //Wait for the process to finish before continuing
  Process1.ShowWindow := swoHide; //hide window

  try
    begin
      Process1.Execute;

      // We should have a PID now? Display the PID
      Memo1.Lines.Add('process ID:' + IntToStr(Process1.ProcessID)); // Does not work :-(
    end;

    begin
      if Process1.Running then // Does not work :-(
      begin
        Memo1.Lines.Add('Process Running ');
      end;
    end;

  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TForm1.ListBox1KeyPress(Sender: TObject; var Key: Char);
var
  url: String;
begin
  url := RadioStations[Listbox1.ItemIndex, 1];
  writeln(url);

  {$IFDEF Windows}
  ExecuteProcess('cmd.exe', ['/c', 'mpv ' + url]);
  {$ELSE}
  ExecuteProcess('/bin/sh', ['-c', 'mpv ' + url + ' &']);
  {$ENDIF}



{   if Process1.Running then
       begin
        writeln('process running detected');
        Process1.Terminate(0); // Send a terminate signal to the process
        Process1.WaitOnExit;
       end;
 }

{
  // Configure TProcess to run the mpv command
  Process1.Executable := 'mpv';
  Process1.Parameters.Clear;
  Process1.Parameters.Add(url);

  try
    Process1.Execute;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;}
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: Boolean);
begin
  writeln(ListBox1.ItemIndex);
  writeln(RadioStations[Listbox1.ItemIndex, 1]);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to High(RadioStations) do
  begin
    //    ListBox1.Items.Add('Station: ' + RadioStations[i, 0] + ' | URL: ' + RadioStations[i, 1]);
    ListBox1.Items.Add(RadioStations[i, 0]);
  end;

  Memo1.Lines.Add('Stations Loaded Succesfully');
  Button1.Enabled := False;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //  url:=RadioStations[Listbox1.ItemIndex,1] ;
  // writeln(url);

  if Process1.Running then    //stop play if running
    Process1.Terminate(0);

  // Configure TProcess to run the aplay command
  Process1.Executable := 'mpv';
  Process1.Parameters.Clear;
  //  Process1.Parameters.Add('https://radio.lotustechnologieslk.net:2020/stream/hirufmgarden'); // Replace with the path to your WAV file
  Process1.Parameters.Add('http://cast5.magicstreams.gr:8010/stream'); // Replace with the path to your WAV file

  //Process1.Options := [poWaitOnExit]; //Wait for the process to finish before continuing
  Process1.ShowWindow := swoHide; //hide window

  try
    begin
      Process1.Execute;
      Memo1.Lines.Add('hard coded url activated');
      Memo1.Lines.Add(BoolToStr(Process1.Active));
      Memo1.Lines.Add('why?');
    end;

  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  //Process1.Destroy;
  //Memo1.Lines.Add('In Process Free:');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  {$IFDEF Windows}
  ExecuteProcess('cmd.exe', ['/c', 'taskkill /IM "mpv.exe"']);
  {$ELSE}
  ExecuteProcess('/bin/sh', ['-c', 'pkill mpv']);
  {$ENDIF}
  Memo1.Clear;
  Button4.Enabled := False;
  Button5.Enabled := False;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Process1.Terminate(0);
  Memo1.Lines.Add('Process Terminated');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin

  //showmessage(Booltostr(Expanded));
  // Toggle the direction for the next click
  Expanded := not Expanded;

  writeln(Form1.Height);
  writeln(booltostr(expanded));

  if Expanded then
  begin
    // Decrease the form's height by 20 pixels, but not below a minimum height of 100 pixels
    if Form1.Height = 183 then
      Form1.Height := 519;
    Button6.Caption := 'Close Info'; // Update button caption
  end
  else
  begin
    // Increase the form's height by 20 pixels
    Form1.Height := 183;
    Button6.Caption := 'Info'; // Update button caption
  end;

end;

{
procedure TForm1.Button1Click(Sender: TObject);
begin
  ExecuteProcess('/bin/sh', ['-c', 'mpv ' + 'http://cast5.magicstreams.gr:8010/stream' + ' &']);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    ExecuteProcess('/bin/sh', ['-c', 'pkill mpv']);
end;
 }




end.
