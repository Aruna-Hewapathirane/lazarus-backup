unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  ComCtrls, SynEdit, SynHighlighterPas, SynHighlighterCpp, SynHighlighterPython;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    Quit: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    CloseFile: TMenuItem;
    NewFile: TMenuItem;
    OpenFile: TMenuItem;
    SaveFile: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    StatusBar1: TStatusBar;
    SynCppSyn1: TSynCppSyn;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    SynPythonSyn1: TSynPythonSyn;
    procedure CloseFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure NewFileClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);

  private
    function HasTextInSynEdit: Boolean;
    function IsTextModified: Boolean;
    procedure UpdateStatusBar(const FileName: string);
    procedure getDateTime;

  public

  end;

var
  Form1: TForm1;
  FileName: string;

implementation

{$R *.lfm}

{ TForm1 }

// OPEN File
procedure TForm1.OpenFileClick(Sender: TObject);
var
      //FileName: string;
      FileExtension: string;
    begin
      if OpenDialog1.Execute then
      begin
        FileName := OpenDialog1.FileName;         // Get the selected file's full path
        FileExtension := ExtractFileExt(FileName); // Extract the file extension
//        ShowMessage('File Extension: ' + FileExtension); // Display the file extension

// Example of applying syntax highlighting based on file extension
   if FileExtension = '.pas' then
     SynEdit1.Highlighter := SynPasSyn1  // Pascal syntax highlighting
   else if FileExtension = '.cpp' then
     SynEdit1.Highlighter := SynCppSyn1  // C++ syntax highlighting
   else if FileExtension = '.py' then
     SynEdit1.Highlighter := SynPythonSyn1; // Python syntax highlighting
   end;

   SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
   UpdateStatusBar(FileName);

end;

procedure TForm1.QuitClick(Sender: TObject);
begin
  Close;
end;

// When the content of SynEdit changes, update the status bar
procedure TForm1.SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
  getDateTime;
  UpdateStatusBar('');
end;

// NEW File
procedure TForm1.NewFileClick(Sender: TObject);
begin

  if IsTextModified then
  begin
    if MessageDlg('You have unsaved changes. Do you want to save?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      SaveFileClick(Sender);
  end;

  SynEdit1.Lines.Clear; // Clear the editor content
  SynEdit1.Modified := False; // Reset modification flag
//  UpdateStatusBar(''); // Update the status bar


end;

// EXIT To System
procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  close;
end;

//CLOSE File
procedure TForm1.CloseFileClick(Sender: TObject);
begin
  if HasTextInSynEdit then
  begin
    // Optionally prompt the user to save changes before closing
    if MessageDlg('Unsaved changes will be lost. Do you want to save the changes?', mtWarning, [mbYes, mbNo, mbCancel], 0) = mrYes then
    begin
      SaveFileClick(Sender); // Save changes
    end
    else if MessageDlg('Are you sure you want to close the file without saving?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      SynEdit1.Lines.Clear; // Clear the editor content
          Form1.Caption:='Programmers Work Bench 2024';
      //UpdateStatusBar(''); // Update the status bar to indicate no file is open
    end;
  end
  else
  begin
    SynEdit1.Lines.Clear; // Clear the editor content
    Form1.Caption:='Programmers Work Bench 2024';
    //UpdateStatusBar(''); // Update the status bar to indicate no file is open
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    SynEdit1.OnStatusChange := @SynEdit1StatusChange;
end;


// SAVE File
procedure TForm1.SaveFileClick(Sender: TObject);
  var
  FileName: string;



begin
  if SaveDialog1.Execute then
  begin
    FileName := SaveDialog1.FileName;
    SynEdit1.Lines.SaveToFile(FileName); // Save content of SynEdit
  end;
  else

end;


// Check if SynEdit has any text
function TForm1.HasTextInSynEdit: Boolean;
begin
  Result := (SynEdit1.Lines.Count > 0) and (SynEdit1.Lines.Text.Trim <> '');
end;

// Check if the text in SynEdit has been modified
function TForm1.IsTextModified: Boolean;
begin
  Result := SynEdit1.Modified;
end;

// UPDATE STATUS BAR
procedure TForm1.UpdateStatusBar(const FileName: string);
begin
  if FileName = '' then
    StatusBar1.Panels[1].Text := 'No file opened'
  else
    Form1.Caption:=ExtractFileName(FileName);;
    StatusBar1.Panels[0].Text := ExtractFileName(FileName);
    StatusBar1.Panels[1].Text := 'Line:'+IntToStr(SynEdit1.CaretY)+'/'+IntToStr(SynEdit1.Lines.Count);  // Total lines
    StatusBar1.Panels[2].Text := 'COL: ' + IntToStr(SynEdit1.CaretX);    // Current line
end;

// DATE & TIME
procedure TForm1.getDateTime;
  var
    CurrentDateTime: TDateTime;
    FormattedDateTime: string;
  begin
    CurrentDateTime := Now;  // Get the current date and time
    FormattedDateTime := FormatDateTime('ddd, mmm dd yyyy', CurrentDateTime); // Format it as 'YYYY-MM-DD HH:MM:SS'
    StatusBar1.Panels[3].Text:=FormattedDateTime ;
    StatusBar1.Panels[4].Text:=FormatDateTime('hh:nn:ss AM/PM', CurrentDateTime) ;

  end;


end.
