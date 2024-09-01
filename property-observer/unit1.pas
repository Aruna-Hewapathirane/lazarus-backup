unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  csvdataset, DB, TypInfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CSVDataset1: TCSVDataset;
    DBGrid1: TDBGrid;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;


procedure ListComponentProperties(Component: TComponent; Strings: TStrings);
var
 Count, Size, I: Integer;
 List: PPropList;
 PropInfo: PPropInfo;
 PropOrEvent, PropValue: string;
begin
 Count := GetPropList(Component.ClassInfo, tkAny, nil);
 Size  := Count * SizeOf(Pointer);
 GetMem(List, Size);
 try
   Count := GetPropList(Component.ClassInfo, tkAny, List);
   for I := 0 to Count - 1 do
   begin
     PropInfo := List^[I];

     if PropInfo^.PropType^.Kind in tkMethods then
       PropOrEvent := 'Event'
     else
       PropOrEvent := 'Property';

     PropValue := GetPropValue(Component, PropInfo^.Name);
     Strings.Add(Format('[%s] %s: %s = %s', [PropOrEvent, PropInfo^.Name,
       PropInfo^.PropType^.Name, PropValue]));
   end;
 finally
   FreeMem(List);
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
// showmessage('Calling Function');
   ListComponentProperties(ListBox1, ListBox1.Items);
end;

end.


end.

