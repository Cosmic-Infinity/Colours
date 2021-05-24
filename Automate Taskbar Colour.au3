#include <MsgBoxConstants.au3> ;message box library
#include <AutoItConstants.au3> ;MouseClick library
#include <ScreenCapture.au3> ;Screenshot Library
#include <GDIPlus.au3> ; ImageProcessing Library
#include <File.au3> ; temporary file name generation library

;#AutoIt3Wrapper_icon="C:\Users\%username%\Desktop\Colours Icon85.ico"

Global $colour=""
PickColour()
ApplyColour($colour)


Func PickColour()
      ;changing mouse coordinate to 'relative coords to the active window'
	  Opt("MouseCoordMode", 0)


	; #r is win+run, rest is application and enter key
	; not waiting for "Run" to open caused it to miss some keystrokes. sleep will help with that
	Send("#r")
	Sleep(500)
	Send("ms-settings:colors{ENTER}")
	Opt("SendKeyDelay", 1)


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
    Sleep(200)


	;Setting window to DPI Aware
	DllCall("User32.dll","bool","SetProcessDPIAware")

    ;taking focus away from settings as windows prevents screenshots of settings
	WinActivate("Program Manager")

	Local $sTempFile = _TempFile(@TempDir,"\" & "colour_Sample_", ".jpg", 3)

    ;getting mouse position and taking a screenshot
	$pos = MouseGetPos()
	_ScreenCapture_Capture($sTempFile, $pos[0] - 25, $pos[1] - 25, $pos[0] + 25, $pos[1] + 25)

	;Getting Colour Value from the screenshot's 10*10 position
	$iPosX = 12
	$iPosY = 12
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($sTempFile)
	 $colour = Hex(_GDIPlus_BitmapGetPixel($hImage, $iPosX, $iPosY), 6)
	 	;ShellExecute($sTempFile)
		;MsgBox(0, "Pixel Color", $colour)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_ShutDown()


	;delete file once done
	Local $iDelete = FileDelete($sTempFile)
		;Display a message of whether the file was deleted.
		;If $iDelete Then
		  ;MsgBox($MB_SYSTEMMODAL, "", "The file was successfuly deleted.")
			 ;Else
		   ;MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst deleting the file.")
		;EndIf

		 ProcessClose("SystemSettings.exe")
		 ProcessWaitClose("SystemSettings.exe")

EndFunc



Func ApplyColour($applying)

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
    opt("SendKeyDelay",3)
    Send("%UserProfile%\AppData\Roaming\TranslucentTB\config.cfg{ENTER}")
    opt("SendKeyDelay",5)

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

    Sleep (250)

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
	ProcessWaitClose("Notepad.exe")

    ;start translucentTB again
	  Send("#r")
	  Sleep(500)
	  	Opt("SendKeyDelay", 1)
	Send("%programfiles(x86)%\TranslucentTB\TranslucentTB.exe{ENTER}")
	ProcessWait("TranslucentTB.exe")

EndFunc
