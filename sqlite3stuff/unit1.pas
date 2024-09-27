unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids,Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnLoadTables: TButton;
    Button1: TButton;
    //btnLoadTables: TButton;
    ListBoxTables: TListBox;
    //ListBoxTables: TListBox;
    OpenDialog1: TOpenDialog;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StringGrid1: TStringGrid;
    procedure btnLoadTablesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBoxTablesClick(Sender: TObject);
    procedure LoadDataFromDatabase(const FileName: string);
    procedure AdjustColumnWidths(Grid: TStringGrid);
  private
    procedure LoadTableNames;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.btnLoadTablesClick(Sender: TObject);
begin
  // Open the file dialog to allow the user to select the SQLite database file
  if OpenDialog1.Execute then       // If the user successfully selects a file
  begin
    // Debugging: Ensure the file path is correct
    if not FileExists(OpenDialog1.FileName) then
    begin
      ShowMessage('File does not exist: ' + OpenDialog1.FileName);
      Exit;  // Stop execution if the file doesn't exist
    end;

    // Assign the selected file path to the database connection component
    SQLite3Connection1.DatabaseName := OpenDialog1.FileName;

    // Debugging: Check if the DatabaseName is correctly assigned
    if SQLite3Connection1.DatabaseName = '' then
    begin
      ShowMessage('DatabaseName not assigned');
      Exit;  // Stop execution if the DatabaseName is not set
    end;

    try
      // Open the connection to the SQLite database
      SQLite3Connection1.Open;

      SQLTransaction1.DataBase:=SQLite3Connection1; // THIS IS CRITICAL!
      // Start a transaction to ensure data consistency while reading the table names
      SQLTransaction1.StartTransaction;

      // Call the procedure to load table names from the selected database
      LoadTableNames;

      // Commit the transaction after successfully loading the table names
      SQLTransaction1.Commit;
      // Close the connection after the work is done
      SQLite3Connection1.Close;
    except
      on E: Exception do
        // If there is any error during the database connection or query, show a message
        ShowMessage('Error: ' + E.Message);
    end;
  end
  else
    // If the user cancels the file selection, show a message
    ShowMessage('No file selected.');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
        AdjustColumnWidths(StringGrid1);
end;


procedure TForm1.ListBoxTablesClick(Sender: TObject);
var
  selectedItem: String;
begin
  // Ensure an item is selected (ItemIndex >= 0 means an item is selected)
  if ListBoxTables.ItemIndex >= 0 then
  begin
    // Get the selected item from the ListBox
    selectedItem := ListBoxTables.Items[ListBoxTables.ItemIndex];
    // Display the selected item in a message box
//    ShowMessage('You selected: ' + selectedItem);
    LoadDataFromDatabase(selectedItem);


  end
  else
  begin
    ShowMessage('No item selected');
  end;
end;

procedure TForm1.LoadTableNames;
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create(nil);
  try
    Query.DataBase := SQLite3Connection1;
    Query.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table"';
    Query.Open;

    // Clear the listbox
    ListBoxTables.Items.Clear;

    // Loop through the result set and add table names to the listbox
    while not Query.EOF do
    begin
      ListBoxTables.Items.Add(Query.FieldByName('name').AsString);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;


procedure TForm1.LoadDataFromDatabase(const FileName: string);
var
  i, j: Integer;
  lRowCount: integer;
begin

  // Prepare and execute the query
  SQLQuery1.DataBase:=SQLite3Connection1;  //THIS IS CRITICAL chatGPT does not generate this line
  SQLQuery1.SQL.Text := 'SELECT * FROM '+ FileName ; // Change "your_table_name" to your actual table name
  SQLQuery1.Open;

  // Clear all cells in the grid
  StringGrid1.Clear;
  {
  // Optionally reset the column and row counts
  StringGrid1.ColCount := 0; // Reset column count to 0
  StringGrid1.RowCount := 1; // Reset row count to 1 (for header or empty row)
  }

  writeln(SQLQuery1.FieldCount);
  writeln(SQLQuery1.RecordCount);

  lRowCount := 0; // Count total row count.
  SQLQuery1.First;
  while not SQLQuery1.EOF do begin
    inc(lRowCount);
    SQLQuery1.Next;
  end;
   writeln(lRowCount);

    // Set up the StringGrid to match the number of columns in the query
  StringGrid1.ColCount := SQLQuery1.FieldCount;
  StringGrid1.RowCount := lRowCount + 1; // 1 extra row for the header

  // Populate the column headers in the StringGrid
  for i := 0 to SQLQuery1.FieldCount - 1 do
  begin
    StringGrid1.Cells[i, 0] := SQLQuery1.Fields[i].FieldName; // Add field names as headers
  end;

  // Populate the grid with the database records
  SQLQuery1.First; // Move to the first record
  i := 0;          // Start at row 1 (row 0 is the header)

  while not SQLQuery1.EOF do
  begin
    for j := 0 to SQLQuery1.FieldCount - 1 do
    begin
      // Populate each cell with data from the current record
      StringGrid1.Cells[j, i+1] := SQLQuery1.Fields[j].AsString;
    end;
    Inc(i);          // Move to the next row
    SQLQuery1.Next;  // Move to the next record in the query result
  end;

  SQLQuery1.SQL.Clear;
  SQLQuery1.Close;
  // SQLQuery1.Free; <- DONT DO THAT, you wont be able to do a new query
  //                    if SQLQuery1 has been freed
end;

// Auto-Adjust Column Widths
// If you want to automatically adjust the column widths to fit the content,
// you can iterate through the rows and measure the required width:

procedure TForm1.AdjustColumnWidths(Grid: TStringGrid);
  var
    i, j, MaxWidth: Integer;
  begin
    for i := 0 to Grid.ColCount - 1 do
    begin
      MaxWidth := 0;
      for j := 0 to Grid.RowCount - 1 do
      begin
        MaxWidth := Max(MaxWidth, Grid.Canvas.TextWidth(Grid.Cells[i, j]));
      end;
      Grid.ColWidths[i] := MaxWidth + 10; // Add some padding
    end;
  end;



end.

