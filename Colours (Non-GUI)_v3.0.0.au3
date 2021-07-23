#AutoIt3Wrapper_Icon= @ScriptDir & "\assets\ColoursIconNew85.ico" ;optional
TraySetIcon(@ScriptDir & "\assets\ColoursIconNew32.ico")
#include <File.au3>
#include <GUIConstants.au3>

Global $colour = ""
Global $installlocation = StringLeft(@WindowsDir, 3) & "Program Files (x86)\TranslucentTB\TranslucentTB.exe"


;---------------path defining window and logic. only applicable when TranslucentTB isn't installed in it's native path---------------


If Not FileExists(@AppDataDir & "\TranslucentTB\config.cfg") Then
	Local $notfound = MsgBox(BitOR($MB_OK, $MB_SETFOREGROUND, $MB_ICONERROR), "Not Found!", "It seems like TranslucentTB's config file cannot be detected" & @CRLF & "Make sure :" & @CRLF & @CRLF & " 1. TranslucentTB is installed." & @CRLF & @CRLF & " 2. Translucent TB config file is under : "  &@CRLF&@CRLF&  @AppDataDir & " \TranslucentTB\config.cfg")
	Exit
EndIf

If FileExists(@AppDataDir & "\TranslucentTB\colours.cfg") Then

	$installlocation1 = FileReadLine(@AppDataDir & "\TranslucentTB\colours.cfg", 3)
	If FileExists($installlocation1) Then
		$installlocation = $installlocation1
	Else
		SetError(1)
	EndIf


	If @error Then

		If FileExists($installlocation) Then
			_FileWriteToLine(@AppDataDir & "\TranslucentTB\colours.cfg", 3, $installlocation, True, True)
		Else
			definepath()
			_FileWriteToLine(@AppDataDir & "\TranslucentTB\colours.cfg", 3, $installlocation, True, True)
			MsgBox(BitOR($MB_ICONINFORMATION, $MB_SETFOREGROUND), "Path Updated", "Restart Colours." &@CRLF& "If you run into issues, delete this file" & @CRLF & @CRLF  & @AppDataDir & " \TranslucentTB\colours.cfg")
			Exit
		EndIf
	EndIf

Else
	_FileCreate(@AppDataDir & "\TranslucentTB\colours.cfg")


	If FileExists($installlocation) Then
		_FileWriteToLine(@AppDataDir & "\TranslucentTB\colours.cfg", 3, $installlocation, True, True)
	Else
		definepath()
		_FileWriteToLine(@AppDataDir & "\TranslucentTB\colours.cfg", 3, $installlocation, True, True)
		MsgBox(BitOR($MB_ICONINFORMATION, $MB_SETFOREGROUND), "Path Updated", "Restart Colours." &@CRLF& "If you run into issues, delete this file" & @CRLF & @CRLF & @AppDataDir & " \TranslucentTB\colours.cfg")
		Exit
	EndIf
EndIf

Func definepath()
	Local $notinstalled = MsgBox(BitOR($MB_YESNO, $MB_SETFOREGROUND, $MB_ICONWARNING), "Install Path", "It seems like TranslucentTB isn't installed in the default path." & @CRLF & "Would you like to mention a path?")
	If $notinstalled = $IDYES Then
		If @OSVersion = 'WIN_10' Then DllCall("User32.dll", "bool", "SetProcessDpiAwarenessContext", "HWND", "DPI_AWARENESS_CONTEXT" - 2)
		Local $installgui = GUICreate("Installation Location", @DesktopWidth / 4, @DesktopHeight / 4, -1, -1, BitOR(0x00080000, 0x00020000, 0x00040000, 0x00010000))
		GUISetIcon("assets\ColoursIconNew24.ico")
		TraySetIcon("assets\ColoursIconNew48.ico")
		GUISetBkColor(0x00FFFFFF)
		GUISetState()

		Local $size = WinGetPos($installgui)

		Local $installlabel = GUICtrlCreateLabel("Path for TranslucentTB.exe without "" "": ", "", $size[3] * 0.15, $size[2], $size[3] / 5,  	0x01 + 0x0200)
		GUICtrlSetFont(-1, 10, 200, 0, "Segoe UI", 2)

		Local $installtx = GUICtrlCreateInput("", $size[2] * 0.04, $size[3] * 0.5, $size[2] * 0.75, $size[3] * 0.15)
		;GUICtrlSetLimit(-1, 6)
		GUICtrlSetFont(-1, 10, 200, 0, "Segoe UI", 2)
		GUICtrlSetTip(-1, "Path for TranslucentTB.exe")

		Local $installok = GUICtrlCreateButton("OK", $size[2] * 0.825, $size[3] * 0.5, $size[2] * 0.1, $size[3] * 0.15)
		GUICtrlSetFont(-1, 10, 200, 0, "Candara", 2)
		GUICtrlSetTip(-1, "Once done, click here.")

		Do
			Local $n = GUIGetMsg()

			Switch $n
				Case $installok
					$installlocation = GUICtrlRead($installtx)
					Return
			EndSwitch

		Until $n = $GUI_EVENT_CLOSE

	Else
		Exit
	EndIf
EndFunc   ;==>definepath


;----------------------------------end of path defining logic---------------------------------------------------------



PickColour()
ApplyColour($colour)


Func PickColour()
	$colour = Hex(RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\History\Colors", "ColorHistory0"))
	$colour = StringRight($colour, 6)
	$colour = StringRight($colour, 2) & StringMid($colour, 3, 2) & StringLeft($colour, 2)

	;MsgBox(0, "COLOUR", $colour)

EndFunc   ;==>PickColour



Func ApplyColour($applying)

	Local $aLines
	_FileReadToArray(@AppDataDir & "\TranslucentTB\config.cfg", $aLines, $FRTA_COUNT)
	Local $count = 0
	Local $replace


	For $i = 1 To $aLines[0]
		For $j = 0 to(StringLen($aLines[$i]) - 1)
			If(StringMid($aLines[$i], $j, 1) == Chr(61)) Then
				$count += 1
			EndIf
			If $count == 2 Then
				$replace = StringMid($aLines[$i], $j + 1, 6)
				ExitLoop
			EndIf

		Next

		If $count == 2 Then
			ExitLoop
		EndIf
	Next


	_ReplaceStringInFile(@AppDataDir & "\TranslucentTB\config.cfg", $replace, $applying, 0, 1)

	;close TranslucentTB
	ProcessClose("TranslucentTB.exe")
	ProcessWaitClose("TranslucentTB.exe")


	;start translucentTB again
	Run($installlocation)
	ProcessWait("TranslucentTB.exe")

EndFunc   ;==>ApplyColour
