unit mc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ShellCtrls, StdCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListBox1: TListBox;
    ShellTreeView1: TShellTreeView;
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure PopulateListBox;
var
  SearchRec: TSearchRec;
  Path: string;
begin

  Form1.ListBox1.Clear;

  // Get the path of the selected directory
  Path := Form1.ShellTreeView1.Selected.GetTextPath;

  // Check if the path is a directory and exists
  if DirectoryExists(Path) then
  begin
    // Find and list files in the selected directory
    if FindFirst(Path + PathDelim + '*.*', faAnyFile, SearchRec) = 0 then
    try
      repeat
        // Skip '.' and '..'
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          Form1.ListBox1.Items.Add(SearchRec.Name);
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
end;



procedure TForm1.ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  PopulateListBox;
end;

end.

