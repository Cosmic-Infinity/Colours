#AutoIt3Wrapper_Icon=.\assets\Colours-Icon-new-85.ico

Global $colour = ""
PickColour()
ApplyColour($colour)


Func PickColour()
	Send("#r")
	Sleep(500)
	Send("ms-settings:colors{ENTER}")
	Opt("SendKeyDelay",1)


	;wait for settings to start by checking visible text on the window is 'Settings'
	While 1
		Local $text = WinGetText("[ACTIVE]")
		if Not StringInStr($text, "Settings") = 0 Then
			ExitLoop
		Else
			Sleep(50)
		EndIf

		WinActivate("Settings")
	WEnd

Opt("SendKeyDelay",5)
	;bring settings to focus
	WinActivate("Settings")
	Send("{TAB 11}")
	Send("{ENTER}")
	Sleep(250)
	Send("{TAB 2}")
	Send("{ENTER}")
	Send("{TAB 5}")
	Send("{RIGHT} +{RIGHT 6}")
	Send("^{INSERT}") ;language agnostic copy

    Opt("SendKeyDelay",1)

	$colour = ClipGet()
	ProcessClose("SystemSettings.exe")
	ProcessWaitClose("SystemSettings.exe")

EndFunc   ;==>PickColour



Func ApplyColour($applying)

	;start notepad
	Run("Notepad.exe")
	ProcessWait("notepad.exe")
	WinActivate("Notepad")
	;send CTRL+O for open
	Send("^o")
	;wait for open window
	WinWaitActive("Open")

	;changing key press delay momentarily
	opt("SendKeyDelay", 3)
	Send("%UserProfile%\AppData\Roaming\TranslucentTB\config.cfg{ENTER}")
	opt("SendKeyDelay", 5)

	;move cursor to location
	Send("{DOWN}{RIGHT 6}")

	;select old colour
	Send("+{RIGHT 6}")

	;open replace window , fill 'replace with' box
	Send("^h{TAB}" & $applying)

	;reach 'replace all' button
	Send("{TAB 5}")

	;press enter
	Send("{ENTER}")

	Sleep(250)

	;close replace window
	Send("!{F4}")


	;close TranslucentTB
	ProcessClose("TranslucentTB.exe")
	ProcessWaitClose("TranslucentTB.exe")

	;save the file changes
	Send("^s")
	Sleep(500)

	;close Notepad and wait for it to close
	Send("!{F4}")
	ProcessWaitClose("notepad.exe")

	;start translucentTB again
	Send("#r")
	Sleep(500)
	Send("%ProgramFiles(x86)%\TranslucentTB\TranslucentTB.exe")
	send("{ENTER}")
	ProcessWait("TranslucentTB.exe")

EndFunc   ;==>ApplyColour
