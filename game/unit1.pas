unit Unit1;

interface

uses
  SysUtils, Classes, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  // Define the room structure as a simple record
  TRoom = record
    Id: string;
    Name: string;
    Descr: string;
    N, S, E, W: string;
  end;

  TForm1 = class(TForm)
    MemoDescription: TMemo;
    ButtonNorth: TButton;
    ButtonSouth: TButton;
    ButtonEast: TButton;
    ButtonWest: TButton;
    LabelError: TLabel;
    ImageRoom: TImage;  // TImage to display the room image
    procedure FormCreate(Sender: TObject);
    procedure ButtonNorthClick(Sender: TObject);
    procedure ButtonSouthClick(Sender: TObject);
    procedure ButtonEastClick(Sender: TObject);
    procedure ButtonWestClick(Sender: TObject);
  private
    currentRoom: TRoom;  // Declare currentRoom as a TRoom record
    Rooms: array of TRoom;  // Array to store rooms
    RoomCount: Integer;  // To keep track of the number of rooms
    procedure ShowRoom;
    procedure DisplayRoomImage;  // Load room image into TImage
    procedure CreateGameRooms;  // Add the procedure to create rooms
    function GetRoomById(id: string): TRoom;  // Function to get a room by ID
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Initialize rooms and create them
  RoomCount := 0;
  CreateGameRooms;

  // Start the game in the first room (Room1)
  currentRoom := GetRoomById('Room1');  // Initialize currentRoom

  // Show the room's description and image
  ShowRoom;
  DisplayRoomImage;
end;

procedure TForm1.CreateGameRooms;
begin
  // Initialize rooms with some default values
  SetLength(Rooms, 4);  // For 4 rooms
  RoomCount := 4;

  Rooms[0].Id    := 'Room1';
  Rooms[0].Name  := 'Entrance';
  Rooms[0].Descr := 'You are at the entrance of the mansion.';
  Rooms[0].N     := 'Room2';
  Rooms[0].S := '';
  Rooms[0].E := '';
  Rooms[0].W := '';

  Rooms[1].Id := 'Room2';
  Rooms[1].Name := 'Hallway';
  Rooms[1].Descr := 'A long, dark hallway. A door to the north leads to a library.';
  Rooms[1].N := 'Room3';
  Rooms[1].S := 'Room1';
  Rooms[1].E := '';
  Rooms[1].W := 'Room4';

  Rooms[2].Id := 'Room3';
  Rooms[2].Name := 'Library';
  Rooms[2].Descr := 'A dusty library with old books. There is a door leading south.';
  Rooms[2].N := '';
  Rooms[2].S := 'Room2';
  Rooms[2].E := '';
  Rooms[2].W := '';

  Rooms[3].Id := 'Room4';
  Rooms[3].Name := 'Secret Room';
  Rooms[3].Descr := 'A hidden room with a treasure chest. There is an exit to the east.';
  Rooms[3].N := '';
  Rooms[3].S := '';
  Rooms[3].E := 'Room2';
  Rooms[3].W := '';
end;

function TForm1.GetRoomById(id: string): TRoom;
var
  i: Integer;
begin
  // Find and return the room with the matching ID
  for i := 0 to RoomCount - 1 do
  begin
    if Rooms[i].Id = id then
    begin
      Result := Rooms[i];
      Exit;
    end;
  end;

  // Return a default empty room if not found
  Result.Id := '';
  Result.Name := '';
  Result.Descr := '';
  Result.N := '';
  Result.S := '';
  Result.E := '';
  Result.W := '';
end;

procedure TForm1.ShowRoom;
begin
  // Display the current room's description and directions in MemoDescription
  MemoDescription.Clear;
  MemoDescription.Lines.Add(' You are in: ' + currentRoom.Name);
  MemoDescription.Lines.Add(' Description: ' + currentRoom.Descr);

  if currentRoom.N <> '' then
    MemoDescription.Lines.Add('N: ' + currentRoom.N);
  if currentRoom.S <> '' then
    MemoDescription.Lines.Add('S: ' + currentRoom.S);
  if currentRoom.E <> '' then
    MemoDescription.Lines.Add('E: ' + currentRoom.E);
  if currentRoom.W <> '' then
    MemoDescription.Lines.Add('W: ' + currentRoom.W);

  // Clear any previous error messages
  LabelError.Caption := '';
end;

procedure TForm1.DisplayRoomImage;
begin
  // Attempt to load the image for the current room (using .png format)
  try
    // Check if the .png image exists in the directory
    if FileExists(currentRoom.Id + '.png') then
    begin
      ImageRoom.Picture.LoadFromFile(currentRoom.Id + '.png');
      LabelError.Caption := ''; // Clear any error message
    end
    else
    begin
      LabelError.Caption := 'Image not found: ' + currentRoom.Id + '.png';
      ImageRoom.Picture.Clear; // Clear the image if not found
    end;
  except
    on E: Exception do
    begin
      LabelError.Caption := 'Error loading image: ' + E.Message;
      ImageRoom.Picture.Clear;  // Clear the image if there's an error
    end;
  end;
end;

procedure TForm1.ButtonNorthClick(Sender: TObject);
var
  nextRoom: TRoom;
begin
  // Check if the current room has a valid 'N' (North) room to go to
  if currentRoom.N <> '' then
  begin
    nextRoom := GetRoomById(currentRoom.N);
    if nextRoom.Id <> '' then
    begin
      currentRoom := nextRoom;
      ShowRoom;
      DisplayRoomImage;
    end
    else
      LabelError.Caption := 'No room to the north.';
  end
  else
    LabelError.Caption := 'No room to the north.';
end;

procedure TForm1.ButtonSouthClick(Sender: TObject);
var
  nextRoom: TRoom;
begin
  // Check if the current room has a valid 'S' (South) room to go to
  if currentRoom.S <> '' then
  begin
    nextRoom := GetRoomById(currentRoom.S);
    if nextRoom.Id <> '' then
    begin
      currentRoom := nextRoom;
      ShowRoom;
      DisplayRoomImage;
    end
    else
      LabelError.Caption := 'No room to the south.';
  end
  else
    LabelError.Caption := 'No room to the south.';
end;

procedure TForm1.ButtonEastClick(Sender: TObject);
var
  nextRoom: TRoom;
begin
  // Check if the current room has a valid 'E' (East) room to go to
  if currentRoom.E <> '' then
  begin
    nextRoom := GetRoomById(currentRoom.E);
    if nextRoom.Id <> '' then
    begin
      currentRoom := nextRoom;
      ShowRoom;
      DisplayRoomImage;
    end
    else
      LabelError.Caption := 'No room to the east.';
  end
  else
    LabelError.Caption := 'No room to the east.';
end;

procedure TForm1.ButtonWestClick(Sender: TObject);
var
  nextRoom: TRoom;
begin
  // Check if the current room has a valid 'W' (West) room to go to
  if currentRoom.W <> '' then
  begin
    nextRoom := GetRoomById(currentRoom.W);
    if nextRoom.Id <> '' then
    begin
      currentRoom := nextRoom;
      ShowRoom;
      DisplayRoomImage;
    end
    else
      LabelError.Caption := 'No room to the west.';
  end
  else
    LabelError.Caption := 'No room to the west.';
end;

end.

