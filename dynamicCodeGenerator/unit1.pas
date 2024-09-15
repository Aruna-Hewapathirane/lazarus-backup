// Aruna Hewapathirane Thu, September 12th 2024 @ 6:33 AM
// North York, Toronto
// LICENSE: Still thinking about it :-)


unit Unit1;

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonGenerate: TButton;
    EditClassName : TEdit;
    EditAttributes: TEdit;
    EditMethods   : TEdit;
    MemoCode      : TMemo;

    procedure ButtonGenerateClick(Sender: TObject);
  private
    function GeneratePascalCode(const myClassName, Attributes, Methods: string): string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.ButtonGenerateClick(Sender: TObject);
var
  myClassName, Attributes, Methods, Code: string;
begin
  myClassName := EditClassName.Text;
  Attributes  := EditAttributes.Text;
  Methods     := EditMethods.Text;

  Code := GeneratePascalCode(myClassName, Attributes, Methods);
  MemoCode.Text := Code;
end;

function TForm1.GeneratePascalCode(const myClassName, Attributes, Methods: string): string;
var
  AttrList, MethList: TStringList;
  I: Integer;
  Code: TStringList;
begin
  Code := TStringList.Create;
  AttrList := TStringList.Create;
  MethList := TStringList.Create;

  try
    Code.Add('unit ' + myClassName + '_Unit;');
    Code.Add('');
    Code.Add('interface');
    Code.Add('');
    Code.Add('type');
    Code.Add('  ' + ClassName + ' = class');

    // Split attributes and add them
    AttrList.CommaText := Attributes;
    for I := 0 to AttrList.Count - 1 do
      Code.Add('    F' + AttrList[I] + ': string;'); // Assuming all attributes are strings for simplicity

    Code.Add('  public');

    // Split methods and add them
    MethList.CommaText := Methods;
    for I := 0 to MethList.Count - 1 do
      Code.Add('    procedure ' + MethList[I] + ';');

    Code.Add('  end;');
    Code.Add('');
    Code.Add('implementation');
    Code.Add('');

    // Generate method stubs
    for I := 0 to MethList.Count - 1 do
      Code.Add('procedure ' + ClassName + '.' + MethList[I] + ';');

    Code.Add('');
    Code.Add('end.');

    Result := Code.Text;

  finally
    Code.Free;
    AttrList.Free;
    MethList.Free;
  end;
end;

end.

