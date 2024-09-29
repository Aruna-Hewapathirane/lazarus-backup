{-------------------------------------------------------------------------------
  Arduino offers a wide range of development boards, each designed for different
  purposes and use cases, ranging from beginners to advanced projects. Below is
  a full list of Arduino boards categorized by their families and form factors.

  1. Classic Arduino Boards
     These are the most popular and widely used boards.

  2. ARM Cortex-M Based Arduino Boards
     These boards are based on more powerful ARM microcontrollers.

  3. Arduino MKR Family
     Compact, powerful boards designed for IoT (Internet of Things) projects.

  4. Arduino Nano Family
     Smaller form-factor boards suitable for wearable and compact projects.

  5. Arduino Pro Family
     These are more advanced boards for industrial or specialized uses.

  6. Arduino IoT Cloud Boards
     These boards are designed specifically for IoT applications with cloud support.

  7. Other Specialized Arduino Boards

  8. Retired/Discontinued Arduino Boards

  9. Third-Party Arduino-Compatible Boards
     There are many third-party manufacturers who make Arduino-compatible boards
     with additional features or custom designs. These often use the same
     microcontrollers or are compatible with the Arduino IDE.

     This list covers the majority of Arduino's official boards, offering a
     variety of sizes, power capabilities, and features for different
     applications. If you're looking for further details on any specific board,
     feel free to ask!
-------------------------------------------------------------------------------}




unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ComCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    TreeView1: TTreeView;

    procedure FormCreate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure AddTreeViewItems;
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
  AddTreeViewItems;
end;


procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if treeview1.Selected.Text='Arduino Uno' then
  begin
    Memo1.Text:='Microcontroller  : ATmega328P'+ LineEnding+
                'Operating Voltage: 5V'+LineEnding+
                'Digital I/O Pins : 14 (6 PWM)'+LineEnding+
                'Analog Input Pins: 6'+LineEnding+
                'Memory           : 32 KB Flash, 2 KB SRAM, 1 KB EEPROM';

    Image1.Picture.LoadFromFile('assets/uno.png');
  end;

  if treeview1.Selected.Text='Arduino Leonardo' then
  begin
    Memo1.Text:='Microcontroller  : ATmega32U4'+ LineEnding+
                'Operating Voltage: 5V'+ LineEnding+
                'Digital I/O Pins : 20 (7 PWM)'+ LineEnding+
                'Analog Input Pins: 12'+ LineEnding+
                'Memory           : 32 KB Flash, 2.5 KB SRAM, 1 KB EEPROM';
    Image1.Picture.LoadFromFile('assets/leonardo.png');
  end;

    if treeview1.Selected.Text='Arduino Mega 2560' then
  begin
    Memo1.Text:='Microcontroller: ATmega2560'+ LineEnding+
                'Operating Voltage: 5V'+ LineEnding+
                'Digital I/O Pins: 54 (15 PWM)'+ LineEnding+
                'Analog Input Pins: 16'+ LineEnding+
                'Memory: 256 KB Flash, 8 KB SRAM, 4 KB EEPROM';
    Image1.Picture.LoadFromFile('assets/mega2560.png');
  end;

end;

procedure TForm1.AddTreeViewItems;
  var
    RootNode, ChildNode: TTreeNode;
  begin
    // Clear any existing items in the TreeView
    TreeView1.Items.Clear;

    // Add a root node
    RootNode := TreeView1.Items.Add(nil, 'Arduino boards categorized by their families and form factors.');



    // Add child nodes to the root
    ChildNode := TreeView1.Items.AddChild(RootNode, 'Classic Arduino Boards');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Uno');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Leonardo');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Mega 2560');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Nano');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Micro');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Mini');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Ethernet');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Fio');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'ARM Cortex-M Based Arduino Boards');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Due');
    TreeView1.Items.AddChild(ChildNode, 'Arduino Zero');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'Arduino MKR Family');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR Zero');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR WiFi 1010');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR GSM 1400');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR FOX 1200');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR WAN 1300/1310');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR NB 1500');
    TreeView1.Items.AddChild(ChildNode, 'Arduino MKR Vidor 4000');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'Arduino Nano Family');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.1');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.2');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'Arduino Pro Family');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.1');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.2');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'Arduino IoT Cloud Boards');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.1');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.2');

    ChildNode := TreeView1.Items.AddChild(RootNode, 'Other Specialized Arduino Boards');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.1');
    TreeView1.Items.AddChild(ChildNode, 'Sub-child Item 2.2');

    // Expand the root node to show its children

    // Find the root node you want to expand (e.g., "Node A")
      RootNode := TreeView1.Items.FindNodeWithText('Arduino boards categorized by their families and form factors.');

      if Assigned(RootNode) then
      begin
        // Expand the root node
        RootNode.Expand(False);

        // Find the ChildNode under "Node A" (e.g., "ChildNode A1")
        ChildNode := RootNode.FindNode('Classic Arduino Boards');

        if Assigned(ChildNode) then
        begin
          // Expand the ChildNode
          ChildNode.Expand(False);

          // Optionally, make the ChildNode the selected node and visible
          TreeView1.Selected := ChildNode;
          ChildNode.MakeVisible;
        end;

//    RootNode.Expand(True);

end;
end;

end.

