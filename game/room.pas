unit Room;

interface

uses
   Dialogs,SysUtils;  // Add SysUtils to the uses clause for Exception handling
const
  MAX_ROOMS = 10;

type
  PRoom = ^TRoom;
  TRoom = record
    Id: string;
    Name: string;
    Descr: string;
    N, S, E, W: string;
  end;

var
  Rooms: array[0..MAX_ROOMS] of PRoom;
  RoomCount: Integer = 0;

procedure InitRooms;
procedure DestroyRooms;
procedure CreateRoom(id, name, descr, n, s, e, w: string);
function GetRoom(id: string): PRoom;

implementation

procedure InitRooms;
var
  i: Integer;
begin
  for i := 0 to MAX_ROOMS do
    Rooms[i] := nil;

  showmessage('Rooms Created');

end;

procedure DestroyRooms;
var
  i: Integer;
begin
  for i := 0 to RoomCount - 1 do
    Dispose(Rooms[i]);
end;

procedure CreateRoom(id, name, descr, n, s, e, w: string);
begin
  if RoomCount >= MAX_ROOMS then
    raise Exception.Create('Maximum room count reached');

  New(Rooms[RoomCount]);
  Rooms[RoomCount]^.Id := id;
  Rooms[RoomCount]^.Name := name;
  Rooms[RoomCount]^.Descr := descr;
  Rooms[RoomCount]^.N := n;
  Rooms[RoomCount]^.S := s;
  Rooms[RoomCount]^.E := e;
  Rooms[RoomCount]^.W := w;

  Inc(RoomCount);
end;

function GetRoom(id: string): PRoom;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to RoomCount - 1 do
  begin
    if Rooms[i]^.Id = id then
    begin
      Result := Rooms[i];
      Exit;
    end;
  end;

  raise Exception.Create('Room with ID "' + id + '" not found.');
end;

end.

