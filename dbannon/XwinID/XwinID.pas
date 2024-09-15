program findXIDs;
{$mode objfpc}{$H+}

{ Notes :
    (XLib) functions like XQueryTree() may fail if given bad data. It will drop a message
    to the console, eg "X Error of failed request:  BadWindow (invalid Window parameter)"
    and terminate. Does not seem to be a way to protect against this happening. So,
    don't mess with the data.

}
uses x, xlib, xatom, unix, xutil, ctypes, sysutils;

        // Returns true (with ID in WinID) if Term matches an XWindow title under
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

function search(WinCaption : string; out WinID : TWindow) : Boolean;
var
  Display : PDisplay;
  nwindows, i : integer;
  RootWin, RootRet, ParentRet : TWindow;
  //FoundWin : array of TWindow;                    // seeems a better choice than PPWindow
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

var
    WinID : TWindow;
begin
	//if search('tomboy-ng Release Process', WinID) then
    if search('mate-power-manager', WinID) then
        writeln('Found it : ', WinID.ToHexString(8), ' : ', WinID.ToString)
    else Writeln('Sorry, did not find it');
end.

{ Refs -
  * https://tronche.com/gui/x/xlib/window-information/XQueryTree.html
}
