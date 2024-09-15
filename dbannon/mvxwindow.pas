unit mvxwindow;

{ A small unit that wil move a window between Linux Workspaces using X11 }


{$mode ObjFPC}{$H+}

interface

uses
  x, xlib, xatom, unix, ctypes, sysutils;

function MvXWinWorkSpace(Caption : string; WorkS : integer = -1) : boolean;

var
    MvXWinError : string = '';    // contains an error msg if above returns false.

implementation

{ Notes :

    Copyright (C) 2024 David Bannon <dbannon@internode.on.net>

    License:
    This code is licensed under MIT License, see
    https://spdx.org/licenses/MIT.html  SPDX short identifier: MIT

    Alternativly, your choice, it is released under the GNU General Public License,
    either version 2 of the License, or (at your option) any later version.

    Uses, in some part, the C code for wmctrl as a template. See refs below.
    wmctrl was authored by Tomas Styblo <tripie@cpan.org> and released under GPL 2

    A small unit to move a Window between Linux Workspaces (or "Virtual Desktops").
    You pass the windows Title or Caption and it will be moved to the current
    workspace or include an option integer to move to a specific one. User friendly
    Desptops ( innamon, Mate, XFCe etc) usually have four such workspaces. Others
    have the workspaces hidden or set to just one and you need to look at your
    Desktop's settings.


    Gnome : This works as expected for GTK2. It works for Qt5 and Qt6 if (and only
            if) you use the QT_QPA_PLATFORM=xcb or the similar command line switch.
            It does not work with Wayland, maybe, when Wayland works as it should,
            maybe it will ?

    KDE :   Does not work on KDE's "Virtual Desktop" system, different API ?  All
            Widgetsets. This does not seem to be a Wayland thing, same thing happens
            if Desktop is set to use X11. It all about KDE inventing their own
            workspace/virtual desktops/activities. Must be documented some where
            but I cannot find it.
            wmctrl does not work there either.  More work needed I guess.

    Cinnamon : All good.

    XFCe :  All Good.

    Mate :  All Good.


    (XLib) functions like XQueryTree() may fail if given bad data. It will drop a message
    to the console, eg "X Error of failed request:  BadWindow (invalid Window parameter)"
    and terminate. Does not seem to be a way to protect against this happening. So,
    don't mess with the data.

    The Client_Msg() function will post a message, if it turns out you gave it an invalid
    window ID, the message is silently ignored.

    If you send a window to a non-existing workspace, its (usually ?) ignored.
    While this code does set an error message, it was more about debugging than
    production use.

    Because we identify the Window to move by its Caption there is a risk, if you
    have multiple windows with the same caption, that the one 'chosen' is undetermined.
    Reversing the direction, in GetXWinID() of the for loop ?

    Workspaces are usually numbered 0-3 inclusivly but are presented in user
    menus as being 1-4. Requests for an invalid workspace are ignored.
}


        // Returns true (with ID in WinID) if Term matches an XWindow caption under
        // the passed XWindow.
function TestXWinName(Display : PDisplay; ParentWinID : longint;
                                Term : string; out WinID : TWindow) : boolean;
var
    WindowsRet, i : integer;
    RootWin, ParentRet : TWindow;                       // just dummy place holders
    WinName : pchar;
    ChildWinArray : PPWindow;
    // ChildWinArray : array of TWindow;
begin
    result := False;
	XQueryTree(Display, ParentWinID, @RootWin, @ParentRet, @ChildWinArray, @WindowsRet);
    // here, every xchildw[x] is a child window under the passed childw
    for i := 0 to WindowsRet - 1 do begin
        if (XFetchName(Display, TWindow(ChildWinArray[i]), @WinName) = 1)
                and (Term = WinName) then begin
            WinID := qword(ChildWinArray[i]);
            exit(True);
        end;
    end;
    // Free here ?  Or within the loop ?  Heaptrc says no leaks .....
end;

    // Returns with the Window ID of a Window with the passed caption
function GetXWinID(WinCaption : string; out WinID : TWindow) : Boolean;
var
    Display : PDisplay;
    nwindows, i : integer;
    RootWin, RootRet, ParentRet : TWindow;
    //FoundWin : array of TWindow;
    FoundWin : PPWindow;
    WinName : PChar;
begin
	result := false;
    Display:= XOpenDisplay(nil);
    RootWin := RootWindow(Display, DefaultScreen(Display));
    XQueryTree(Display, RootWin, @RootRet, @ParentRet, @FoundWin, @nwindows);
    try
        for i := 0 to nwindows - 1 do begin
            if (XFetchName(Display, TWindow(FoundWin[i]), @WinName) = 1)             // Maybe this window ?
                    and (WinCaption = WinName) then begin
                        WinID := TWindow(FoundWin[i]);
                        exit(true);
            end;
            if TestXWinName(Display, TWindow(FoundWin[i]), WinCaption, WinID) then  // Or one of its children ?
                exit(True);
        end;
    finally
        // WARNING - heaptrc says this does not leak, I'd like to be sure. Should I 'free' every iteration ?
        if Result = true then
            XFree((FoundWin));
        XCloseDisplay(Display);
    end;
end;

        // Posts a message to X11 that might alter the charactistics of an XWindow
function Client_Msg(Disp : PDisplay; Win : TWindow; Msg {*msg : char} : string; Data0 : qword) : boolean;
var
    event : TXEvent;         // will be 'cased' to event.xclient... as a TXClientMessageEvent event (line #756 xlib.pp)
    mask : longint;
begin
    mask := SubstructureRedirectMask or SubstructureNotifyMask;
    event.xclient._type := ClientMessage;
    event.xclient.serial := 0;
    event.xclient.send_event := 1;
    event.xclient.message_type := XInternAtom(disp, pchar(msg), False);   // '_NET_WM_ACTION_CHANGE_DESKTOP' ? nope.
    if event.xclient.message_type = 0 then exit(false);
    event.xclient.window := win;                                   // the window we want to move
    event.xclient.format := 32;
    event.xclient.data.l[0] := clong(Data0);                       // the desktop we want to move to.
    event.xclient.data.l[1] := clong(0);
    event.xclient.data.l[2] := clong(0);
    event.xclient.data.l[3] := clong(0);
    event.xclient.data.l[4] := clong(0);
    // returns 1 on success.
    Result := (XSendEvent(Disp, DefaultRootWindow(Disp), False, Mask, @event) <> 0);
end;

        // Returns the Window ID of the current Workspace.
function CurrentWorkSpace : integer;
var
    Disp: PDisplay;
    RootWin: TWindow;
    PropInst, type_ret : TAtom;
    Status: integer;
    format_ret: integer;
    nitems_ret, bytes_after_ret: culong;
    prop: Pcuchar;
begin
    Disp := xlib.XOpenDisplay(nil);
    RootWin := XDefaultRootWindow(Disp);
    PropInst := XInternAtom(Disp, '_NET_CURRENT_DESKTOP', True);
    Status := XGetWindowProperty(Disp, RootWin, PropInst, 0, 1, False,
            XA_CARDINAL, @type_ret,  @format_ret, @nitems_ret, @bytes_after_ret, @prop);
    if Status = 0 then
        Result :=  PCardinal(prop)^         // we know its a Cardinal, deref to get the value.
    else Result := -1;
end;


        // Sole entry point for this using, tries to move a window with the passed
        // caption to indicated workspace. -1 means move to current active workspace.
function MvXWinWorkSpace(Caption : string; WorkS : integer) : boolean;
var
    Disp: PDisplay;
    WinID: TWindow;
begin
    MvXWinError := '';
    if WorkS = -1 then
        WorkS := CurrentWorkSpace();
    Disp := xlib.XOpenDisplay(nil);
    if GetXWinID(Caption, WinID) then begin
        if not Client_Msg(Disp, WinID, '_NET_WM_DESKTOP', qword(WorkS)) then    // note, no guaranteee mmsg works !
            MvXWinError := 'ERROR - Failed to send Window Move Message !'
        else begin
            sleep(100);
            if not client_msg(Disp, WinID, '_NET_ACTIVE_WINDOW', 0) then
                MvXWinError := 'ERROR - Failed to send Window Activate Message'
            else
                XMapRaised(Disp, winID);
        end;
    end else
        MvXWinError := 'ERROR - Failed to find that Window !';
    Result := MvXWinError = '';
end;

end.


{ Refs -
  * https://tronche.com/gui/x/xlib/window-information/XQueryTree.html
  * https://tronche.com/gui/x/xlib/window-information/XGetWindowProperty.html
  * https://specifications.freedesktop.org/wm-spec/latest/ar01s05.html
  * https://tronche.com/gui/x/xlib/event-handling/XSendEvent.html
  * https://stackoverflow.com/questions/67318357/how-to-set-the-position-of-a-wayland-window-on-the-screen
  * https://github.com/Conservatory/wmctrl

  https://forum.lazarus.freepascal.org/index.php/topic,68389.0.html
  https://www.x.org/releases/X11R7.5/doc/man/man3/XChangeProperty.3.html

}
