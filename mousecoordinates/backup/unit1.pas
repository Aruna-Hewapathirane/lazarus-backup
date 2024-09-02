unit Unit1;

interface

uses
  Classes, Controls, Forms, StdCtrls, Graphics, SysUtils,Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    procedure PopulateCursorList;
  public
  end;

var
  Form1: TForm1;
  var
  CursorTypes: array[0..14] of TCursor = (
    crDefault, crArrow, crCross, crIBeam, crHelp, crHandPoint,
    crSizeNWSE, crSizeNESW, crSizeWE, crSizeNS, crSizeAll, crNoDrop,
    crDrag, crNo, crHSplit
  );
  CursorTypeNames: array[0..14] of string = (
    'crDefault', 'crArrow', 'crCross', 'crIBeam', 'crHelp', 'crHandPoint',
    'crSizeNWSE', 'crSizeNESW', 'crSizeWE', 'crSizeNS', 'crSizeAll', 'crNoDrop',
    'crDrag', 'crNo' ,'crHSplit'
  );


implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  PopulateCursorList;
end;


procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  MousePos: TPoint;
begin
  MousePos := Mouse.CursorPos;
  Label1.Caption:='X: '+ IntToStr(MousePos.X);
  Label2.Caption:='Y: '+ IntToStr(MousePos.Y);
  Writeln('X:');
  writeln(MousePos.X);
  writeln('Y:');
  writeln(MousePos.Y);
//  ShowMessage(Format('Mouse Position - X: %d, Y: %d', [MousePos.X, MousePos.Y]));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  PopulateCursorList;
  //ShowMessage(ListBox1.Items[Listbox1.ItemIndex]);
//  Form1.Cursor :=CursorTypes[Listbox1.ItemIndex];
  Writeln('ok');
end;

procedure TForm1.FormClick(Sender: TObject);
var
  MousePos: TPoint;
begin
  MousePos := Mouse.CursorPos;
  ShowMessage(Format('Mouse Position - X: %d, Y: %d', [MousePos.X, MousePos.Y]));
end;




procedure TForm1.PopulateCursorList;
var
i: Integer;
begin


  ListBox1.Clear;
  for i := Low(CursorTypes) to High(CursorTypes) do

  begin
    // Optionally, set each cursor type to a control to visually verify
    ListBox1.Items.Add(CursorTypeNames[i] + ' - Example');

    // Example of applying the cursor type to the form temporarily (for demonstration)
//    Application.MainForm.Cursor := CursorTypes[i];
  //  Sleep(500); // Pause to visually see the cursor change
  end;
end;

end.

