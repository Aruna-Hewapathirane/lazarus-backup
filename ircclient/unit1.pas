unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets, BaseUnix;

type
  // Custom sockaddr_in structure as requested
  TSockAddrIn = record
    sin_family: Word;
    sin_port: Word;
    sin_addr: in_addr;
    sin_zero: array[0..7] of Char;
  end;


type
  { TForm1 }
  TForm1 = class(TForm)
    BtnConnect: TButton;
    BtnSend: TButton;
    EditMessage: TEdit;
    EditChannel: TEdit;
    LabelChannel: TLabel;
    MemoChat: TMemo;

    Timer1: TTimer;
    ListUsers: TListBox;   // Shows user list
    procedure BtnConnectClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    IRC_Socket: LongInt;
    ChannelName: String;
    UsersList: TStringList;  // Holds the channel user list
    procedure ConnectToIRC;
    procedure SendData(const Data: String);
    procedure HandleIncomingMessages;
    procedure UpdateUserList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UsersList := TStringList.Create;  // Initialize user list
end;

destructor TForm1.Destroy;
begin
  UsersList.Free;  // Free user list memory
  inherited Destroy;
end;

procedure TForm1.SendData(const Data: String);
begin
  if (IRC_Socket > 0) and (fpSend(IRC_Socket, @Data[1], Length(Data), 0) < 0) then
    MemoChat.Lines.Add('Error sending: ' + Data);
end;

procedure TForm1.ConnectToIRC;
var
  Addr: TSockAddrIn;
begin
  MemoChat.Lines.Add('Connecting to IRC...');

  // Get channel name
  ChannelName := Trim(EditChannel.Text);
  if ChannelName = '' then
  begin
    MemoChat.Lines.Add('Error: Enter a channel!');
    Exit;
  end;
  if ChannelName[1] <> '#' then
    ChannelName := '#' + ChannelName;

  // Create socket
  IRC_Socket := fpSocket(AF_INET, SOCK_STREAM, 0);
  if IRC_Socket < 0 then
  begin
    MemoChat.Lines.Add('Error: Cannot create socket');
    Exit;
  end;

  // Zero the structure
  FillChar(Addr, SizeOf(Addr), 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(6667);  // IRC standard port
  Addr.sin_addr := StrToNetAddr('195.148.124.80'); // libera.chat IP

  // Connect
  if fpConnect(IRC_Socket, @Addr, SizeOf(Addr)) < 0 then
  begin
    MemoChat.Lines.Add('Error: Cannot connect');
    fpShutdown(IRC_Socket, 2);
    Exit;
  end;

  MemoChat.Lines.Add('Connected to IRC!');

  // Send IRC login
  SendData('NICK LazarusIDE' + #13#10);
  SendData('USER LazarusIDE 0 * :Lazarus Client' + #13#10);
  SendData('JOIN ' + ChannelName + #13#10);

  MemoChat.Lines.Add('Joined ' + ChannelName);

  // Request user list
  SendData('NAMES ' + ChannelName + #13#10);
end;

procedure TForm1.BtnConnectClick(Sender: TObject);
begin
  ConnectToIRC;
end;

procedure TForm1.BtnSendClick(Sender: TObject);
var
  MsgText: String;
begin
  MsgText := Trim(EditMessage.Text);
  if (MsgText <> '') and (IRC_Socket > 0) then
  begin
    SendData('PRIVMSG ' + ChannelName + ' :' + MsgText + #13#10);
    MemoChat.Lines.Add('You: ' + MsgText);
    EditMessage.Clear;
  end;
end;

procedure TForm1.HandleIncomingMessages;
var
  buffer: array[0..1023] of Char;
  receivedBytes: Integer;
  message, temp: string;
  ReadSet: TFDSet;
  Timeout: TTimeVal;
  StartPos: Integer;
begin
  fpFD_ZERO(ReadSet);
  fpFD_SET(IRC_Socket, ReadSet);
  Timeout.tv_sec := 0;
  Timeout.tv_usec := 100000;

  if fpSelect(IRC_Socket + 1, @ReadSet, nil, nil, @Timeout) > 0 then
  begin
    receivedBytes := fpRecv(IRC_Socket, @buffer, SizeOf(buffer), 0);
    if receivedBytes > 0 then
    begin
      SetString(message, buffer, receivedBytes);

      // PING response
      if Pos('PING', message) > 0 then
      begin
        SendData('PONG ' + Copy(message, Pos(':', message) + 1, Length(message)) + #13#10);
        MemoChat.Lines.Add('PONG SENT..');
      end;

      // Handle PRIVMSG
      if Pos('PRIVMSG', message) > 0 then
      begin
        message := Copy(message, Pos(':', message) + 1, Length(message));
        MemoChat.Lines.Add(message);
        MemoChat.SelStart := Length(MemoChat.Lines.Text);
      end;

      // Handle User List (353 response)
      if Pos(' 353 ', message) > 0 then
      begin
        StartPos := Pos(':', message);
        if StartPos > 0 then
        begin
          temp := Copy(message, StartPos + 1, Length(message));
          UsersList.Text := StringReplace(temp, ' ', #13#10, [rfReplaceAll]);
          UpdateUserList;
        end;
      end;
    end;
  end;
end;

procedure TForm1.UpdateUserList;
begin
  ListUsers.Items.Assign(UsersList);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  HandleIncomingMessages;
end;

end.

