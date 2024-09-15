unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, RegExpr;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Process1: TProcess;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  OriginalString: string;
  s:string;
  result: Boolean;
  Parts: TStringList;
  i: Integer;
  check:TStringArray;
begin

//result:=RunCommand('/bin/bash',['-c','find /home/aruna/lazarus 3 -name "*.*" -type f | rev | cut -d. -f1 | rev  |  sort | uniq --count | sort -n'],s);
//result:=RunCommand('/bin/bash',['-c','ls -1alh /boot/vm*.*'],s);
//result:=RunCommand('/bin/bash',['-c','dmesg'],s);
//result:=RunCommand('/bin/bash',['-c','lsblk'],s);
//result:=RunCommand('/bin/bash',['-c','lscpu'],s);
//result:=RunCommand('/bin/bash',['-c','lsblk -J'],s);

//sudo sh -c

result:=RunCommand('/bin/bash', ['-c', 'echo 1 | sudo tee /sys/class/leds/input18::scrolllock/brightness'], s);


check := S.Split(' ');

for I := Low(check) to High(check) do
  if check[I] = '' then
        WriteLn('Element ', I, ' is empty.')
      else
        WriteLn('Element ', I, ' is: ', check[I]);

//writeln(check);

writeln(result);
writeln(s);
OriginalString:=s;

//showmessage(originalstring);
Memo1.Lines.Add(s);
// Create and configure TStringList
 Parts := TStringList.Create;
 try
   Parts.Delimiter := ' '; // Set the delimiter
   Parts.StrictDelimiter := True; // Ensure only the delimiter is used
   Parts.DelimitedText := OriginalString; // Split the text
// Split string using regular expression that matches comma, space, or tab
//  TRegEx.Split(OriginalString, '[,\s\t]+');

   // Output each part
   for i := 0 to Parts.Count - 1 do
     begin
     Writeln(Parts[i]); // Outputs: apple, banana, cherry
//     Writeln('split'); // Outputs: apple, banana, cherry
     end
 finally
   Parts.Free;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  result:Boolean;
  s:string;
begin
  result:=RunCommand('/bin/bash', ['-c', 'echo 0 | sudo tee /sys/class/leds/input18::scrolllock/brightness'], s);
end;

end.









