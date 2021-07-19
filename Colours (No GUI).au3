#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\Shubham\Documents\GitHub\Colours\assets\ColoursIconNew85.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Icon= @ScriptDir & "\assets\ColoursIconNew85.ico" ;optional
TraySetIcon(@ScriptDir & "\assets\ColoursIconNew32.ico")
#include <File.au3>

Global $colour = ""
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
	Run(StringLeft(@WindowsDir, 3) & "Program Files (x86)\TranslucentTB\TranslucentTB.exe")
	ProcessWait("TranslucentTB.exe")

EndFunc   ;==>ApplyColour
