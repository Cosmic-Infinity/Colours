#include <MsgBoxConstants.au3> ;message box library
#include <AutoItConstants.au3> ;MouseClick library
;#AutoIt3Wrapper_icon="C:\Users\%username%\Desktop\Colours Icon85.ico"


PickColour()
ApplyColour()


Func PickColour()
      ;changing mouse coordinate to 'relative coords to the active window'
	  Opt("MouseCoordMode", 0)


	; #r is win+run, rest is application and enter key
	Send("#r ms-settings:colors{ENTER}")

    ;wait for settings to start by checking visible text on the window is 'Settings'
	  While 1
		 Local $text = WinGetText("[ACTIVE]")
			if Not StringInStr ($text , "Settings") = 0 Then
				  ExitLoop
			Else
				  Sleep(50)
			EndIf

		 WinActivate("Settings")
	  WEnd


	;bring settings to focus
    WinActivate("Settings")

    ;reach down
    Send("{TAB 9}")

	;move mouse upto the colour
    MouseMove(370, 590, 0)

	  ;start power toys if off
	  If Not ProcessExists("PowerToys.exe") Then
		 Run("%programfiles%\PowerToys\PowerToys.exe")
		 ProcessWait("PowerToys.exe")
	  EndIf

	  ;sent WIN+SHIFT+C
	  Send("#+c")
	  Sleep(500)
	  MouseClick($MOUSE_CLICK_PRIMARY)

	  ;close settings
	  WinClose("Settings")
	  ;close PowerToys
	  ProcessClose("PowerToys.exe")
	  ProcessWaitClose("PowerToys.exe")

EndFunc


Func ApplyColour()

    ;start notepad
    Run("Notepad.exe")
    Sleep(100)
    ProcessWait("notepad.exe")
    WinActivate("Notepad")
	;send CTRL+O for open
    Send("^o")
    ;wait for open window
    WinWaitActive("Open")

	;changing key press delay momentarily
    opt("SendKeyDelay",1)
    Send("%UserProfile%\AppData\Roaming\TranslucentTB\config.cfg{ENTER}")
    opt("SendKeyDelay",5)

    ;move cursor to location
    Send("{DOWN}{RIGHT 6}")

    ;select old colour
    Send("+{RIGHT 6}")

    ;open replace window , fill 'replace with' box
    Send("^h{TAB}^v")

    ;go back 6 steps and remove #, reach 'replace all' button
    Send("{LEFT 6}{BACKSPACE}{TAB 5}")

    ;press enter
    Send("{ENTER}")

    Sleep (250)

    ;close replace window
    Send("!{F4}")


    ;close TranslucentTB
    ProcessClose("TranslucentTB.exe")
    ProcessWaitClose("TranslucentTB.exe")

    ;save the file changes
    Send("^s")
    Sleep(500)

	;close Notepad
    Send("!{F4}")

    ;start translucentTB again
    Run("C:\Program Files (x86)\TranslucentTB\TranslucentTB.exe")

EndFunc
