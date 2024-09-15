unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  SynEdit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SynEdit1: TSynEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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
  Visibility: String;
  userData  :String;

begin
  // Determine visibility
  case ComboBox1.ItemIndex of
    0: Visibility := 'cvPrivate';
    1: Visibility := 'cvProtected';
    2: Visibility := 'cvPublic';
    3: Visibility := 'cvPublished';
  end;

  // Add the field to the class skeleton
  userData:=Edit1.Text +':'+ Edit2.Text+' //' + Visibility;

  // Clear the input fields
  Edit1.Clear;
  Edit2.Clear;


  SynEdit1.Lines.Add(userData);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  metaData:String;
begin
  metaData:='{'+  #13#10+
 ' ******************************************************************************'+ #13#10+
 '* Project      : <Project Name>'+ #13#10+
 '* Unit Name    : <Unit Name or Filename.pas>'+ #13#10+
 '* Author       : <Your Name>'+ #13#10+
 '* Created Date : <Creation Date, e.g., 2024-09-14>'+ #13#10+
 '* Created Time : <Creation Time, e.g., 14:30>'+ #13#10+
 '* Location     : <Location, e.g., Your City or Company>'+ #13#10+
 '* Description  : <Short description of the unit or program>'+ #13#10+
 '*'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* Version History:'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* Date          Time     Modified By       Description'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* <YYYY-MM-DD>  <Time>   <Name>            <Modification Description>'+ #13#10+
 '*'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* Notes:'+ #13#10+
 '* - <Any important notes regarding the code or implementation>'+ #13#10+
 '*'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* License/Usage:'+ #13#10+
 '* - <Any licensing or usage terms, if applicable>'+ #13#10+
 '*'+ #13#10+
 '* ----------------------------------------------------------------------------'+ #13#10+
 '* Contact Info:'+ #13#10+
 '* - <Your email or any relevant contact information>'+ #13#10+
 '*'+ #13#10+
 '* ******************************************************************************'+ #13#10+
 '}';

  SynEdit1.Lines.Text:=metaData;

end;

end.

