unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  csvdataset, DB;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CSVDataset1: TCSVDataset;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    EditFilter: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit1Change(Sender: TObject);
    procedure EditFilterChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    procedure LoadCSVFile(const FileName: string);
  public

  end;

var
  Form1: TForm1;
  i:Integer;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.EditFilterChange(Sender: TObject);
var
  country: string;
begin

  country := EditFilter.Text;
  country := country+'*';  //THE TRICK WAS TO ADD A WILDCARD "*" TO THE FILTER STRING AT THE END OF EACH KEYPRESS. THERE HAS TO BE A BETTER WAY?
  CSVDataSet1.Filtered := False; // Disable previous filters
  CSVDataSet1.Filter := Format('country = ''%s''', [country]);
  CSVDataSet1.Filtered := True;
  end;

procedure TForm1.FormCreate(Sender: TObject);
var
  TotalFieldCount: Integer;
begin
  // Get the total field count
//    TotalFieldCount := CSVDataSet1.FieldCount;
  //  Label5.Caption:=IntToStr(TotalFieldCount);
end;

procedure TForm1.Label4Click(Sender: TObject);
begin

end;


procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
   //showmessage('sort clicked');
  CSVDataset1.IndexFieldNames := Uppercase(Column.Title.Caption);
  Label4.Caption:=IntToStr(Column.Index);

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.LoadCSVFile(const FileName: string);
var
  TotalFieldCount:Integer;
begin
  CSVDataset1.Close; // Close any previously opened dataset

  //clear fields definition
  CSVDataset1.Clear;  //fix by @paweld

  //clear IndexfieldNames definition
  CSVDataset1.IndexFieldNames := '';

  // Clear the filter
  CSVDataset1.Filter := '';

  // Ensure the filter is no longer applied
  CSVDataset1.Filtered := False;


  // Set the new file name
  CSVDataset1.FileName := FileName;
  Label1.Caption:=Filename;

 // Optionally configure properties
//  CSVDataset1.FirstLineAsFieldNames := True;

  CSVDataset1.Open; // Open the new dataset

  DataSource1.DataSet := CSVDataset1; // Link the DataSource to the new dataset
  DBGrid1.DataSource := DataSource1; // Link the DBGrid to the DataSource

    for i:=0 to DBGrid1.Columns.Count-1 do
      DBGrid1.Columns[i].Width := 150;

    Label2.Caption:='Record Count: '+intToStr(CSVDataset1.RecordCount);

    TotalFieldCount := CSVDataSet1.FieldCount;
    Label5.Caption:='Total Field Count: '+IntToStr(TotalFieldCount);
end;




procedure TForm1.Button1Click(Sender: TObject);
  begin
        OpenDialog1.Filter := 'CSV Files|*.csv';
  if OpenDialog1.Execute then
  begin
    LoadCSVFile(OpenDialog1.FileName);

  end;
end;



  {CSVDataset1.Close;

  OpenDialog1.Filter := 'CSV Files|*.csv';

  if OpenDialog1.Execute then
    CSVDataSet1.FileName := OpenDialog1.FileName;

    Label1.Caption:='CSV File Path: '+OpenDialog1.FileName;

    CSVDataSet1.Open;

    DataSource1.DataSet := CSVDataset1; // Link the DataSource to the new dataset
    DBGrid1.DataSource := DataSource1; // Link the DBGrid to the DataSource

    for i:=0 to DBGrid1.Columns.Count-1 do
      DBGrid1.Columns[i].Width := 150;

    Label2.Caption:='Record Count: '+intToStr(CSVDataset1.RecordCount);


    CSVDataset1.refresh;
    DBGrid1.refresh;



end;}



procedure TForm1.Button2Click(Sender: TObject);
begin

   CSVDataset1.IndexFieldNames := 'First Name DESC;';
  //CSVDataset1.IndexFieldNames := Uppercase(Column.Title.Caption);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
// Sort in descending order by a field (e.g., Field1)
CSVDataset1.IndexFieldNames := 'First Name;';


end;

procedure TForm1.Button4Click(Sender: TObject);
begin

end;

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  Label3.Caption:='Current Record: '+IntToStr(CSVDAtaset1.RecNo);
end;

end.

