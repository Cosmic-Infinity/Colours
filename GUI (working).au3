#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Cosmic-Infinity



#ce ----------------------------------------------------------------------------


#include <GUIConstantsEx.au3>
;#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
;#include <WindowsConstants.au3>
;#include <ButtonConstants.au3>
;#include <FontConstants.au3>
#include <StaticConstants.au3> ; For graphic(lines)
;#include <GuiToolTip.au3>
#include <ScreenCapture.au3> ; Screenshot Library
#include <GDIPlus.au3> ; ImageProcessing Library
#include <File.au3> ; temporary file name generation library
#include <Misc.au3> ; mouse click detection And font styles
#include <ColorPicker.au3> ; colour picker udf
;#Include <WinAPI.au3>
#include <GuiEdit.au3>
;#include <StringConstants.au3> ;for string constants
#include <File.au3>




#AutoIt3Wrapper_Icon="C:\Users\Shubham\Documents\GitHub\Colours\assets\Colours-Icon-new-85.ico" ;optional

;!Highly recommended for improved overall performance and responsiveness of the GUI effects etc.! (after compiling):
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
;Required if you want High DPI scaling enabled.
#AutoIt3Wrapper_Res_HiDpi=y



Global $sfilepath = "C:\Users\Shubham\Desktop\colourstarget.txt"

;_ReplaceStringInFile ( $sFilePath, "color", "colours", 0 , 0 )

;Control temporary state /  reading file state on launch
Global $max
Global $previewactive = False


Global $stateCB[5]                     ;stores checkbox selected. 0-3 are checkbox. 4 is advance & standard box
$stateCB[0] = False
$stateCB[1] = True
$stateCB[2] = False
$stateCB[3] = True
$stateCB[4] = False

Global $stateRB[5]                    ;stores radio button states for each category
$stateRB[0] = 1
$stateRB[1] = 2
$stateRB[2] = 3
$stateRB[3] = 4
$stateRB[4] = 5

Global $stateBLUR[5]                      ;stores current blur value
$stateBLUR[0] = 10
$stateBLUR[1] = 20
$stateBLUR[2] = 30
$stateBLUR[3] = 40
$stateBLUR[4] = 50

Global $colourset[5]                    ;stores current colour for each element
$colourset[0] = ""
$colourset[1] = ""
$colourset[2] = ""
$colourset[3] = ""
$colourset[4] = ""

Global $stateextra[5]
$stateextra[0] = 1
$stateextra[1] = 1
$stateextra[2] = 69
$stateextra[3] = 1
$stateextra[4] = 1


Global $sTempFile                      ;trmporary file to save image file use for eye button
Global $colour = "FFFFFF"             ;detected/extracted/selected colour


;Global $iScale = RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI") / 96
;$iScale=$iScale/1.5 ;scale correction relative to my display's scaling





DrawWin()
DrawElements()
fload()
main()



Func DrawWin()
	If @OSVersion = 'WIN_10' Then DllCall("User32.dll", "bool", "SetProcessDpiAwarenessContext", "HWND", "DPI_AWARENESS_CONTEXT" - 2)

	Global $gui = GUICreate("Colours GUI", @DesktopWidth / 1.28, @DesktopHeight / 1.2855, -1, -1, BitOR($WS_SYSMENU, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	;1500, 840
	GUISetIcon("C:\Users\Shubham\Documents\GitHub\Colours\assets\ColoursIconNew16.ico")
	TraySetIcon("C:\Users\Shubham\Documents\GitHub\Colours\assets\ColoursIconNew32.ico")
	GUISetBkColor(0x00FFFFFF) ; will change background color

	;sw enable
	GUISetState()
EndFunc   ;==>DrawWin





Func DrawElements()


	Local $size = WinGetPos($gui)

	Local $leftLB = $size[2] / 30 ;50
	Local $topLB = $size[3] / 33.6 ;25
	Local $heightLB = $topLB * 5 ;125
	Local $lengthtLB = $leftLB * 14 ;700

	;------------------------------------------------------------------------------TASKBAR------------------------------------------------------------------------



	Global $taskbarGR = GUICtrlCreateGroup("Desktop / Global Taskbar", $leftLB, $topLB, $lengthtLB, $heightLB)
	GUICtrlSetFont($taskbarGR, ($topLB / 2), 600, 0, "Segoe UI", 5)
	;font weight, font attribute, font name, quality


	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.


	;Global $check1 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB) + $heightLB / 2)
	;GUICtrlSetState($check1, $GUI_CHECKED)
	GUIStartGroup()
	Global $Radio1_1 = GUICtrlCreateRadio("Clear", ($leftLB * 2.3), ($heightLB) - ($heightLB * 0.46), $lengthtLB / 6.3)
	GUICtrlSetFont($Radio1_1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio1_2 = GUICtrlCreateRadio("Fluent", (($leftLB * 2.3) * 2), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_2, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio1_3 = GUICtrlCreateRadio("Opaque", (($leftLB * 2.3) * 3), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_3, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio1_4 = GUICtrlCreateRadio("Normal", (($leftLB * 2.3) * 4), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_4, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio1_5 = GUICtrlCreateRadio("Blur", (($leftLB * 2.3) * 5), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_5, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")



	Global $Slider_1 = GUICtrlCreateSlider(($leftLB * 1.5), ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 1
	GUICtrlSetLimit($Slider_1, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_1, $stateBLUR[0]) ; set cursor

	Global $InputBox_1 = GUICtrlCreateInput($stateBLUR[0], ($lengthtLB * 0.99), ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ; ;textbox 1
	GUICtrlSetLimit(-1, 3) ;-1 means last created control





	;$stateRB[0] = 1


	If $stateRB[0] = 1 Then
		GUICtrlSetState($Radio1_1, $GUI_CHECKED)
	ElseIf $stateRB[0] = 2 Then
		GUICtrlSetState($Radio1_2, $GUI_CHECKED)
	ElseIf $stateRB[0] = 3 Then
		GUICtrlSetState($Radio1_3, $GUI_CHECKED)
		GUICtrlSetState($Slider_1, $GUI_DISABLE)
		GUICtrlSetState($InputBox_1, $GUI_DISABLE)
	ElseIf $stateRB[0] = 4 Then
		GUICtrlSetState($Radio1_4, $GUI_CHECKED)
	ElseIf $stateRB[0] = 5 Then
		GUICtrlSetState($Radio1_5, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Taskbar accent can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf











	;--------------------Dynamic Windows. State to use when a window is maximised.--------------------------------------------------



	Global $maximisedGR = GUICtrlCreateGroup("Window Maximised", $leftLB, $topLB * 2 + $heightLB, $lengthtLB, $heightLB)
	GUICtrlSetFont($maximisedGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check2 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 2) + $heightLB * (3 / 2))
	GUICtrlSetState($check2, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio2_1 = GUICtrlCreateRadio("Clear", (($lengthtLB / 6) * 1), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio2_2 = GUICtrlCreateRadio("Fluent", (($lengthtLB / 6) * 2), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio2_3 = GUICtrlCreateRadio("Opaque", (($lengthtLB / 6) * 3), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio2_4 = GUICtrlCreateRadio("Normal", (($lengthtLB / 6) * 4), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio2_5 = GUICtrlCreateRadio("Blur", (($lengthtLB / 6) * 5), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")




	;slider 2
	Global $Slider_2 = GUICtrlCreateSlider($lengthtLB / 9, $heightLB + $topLB + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1)
	GUICtrlSetLimit($Slider_2, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_2, $stateBLUR[1]) ; set cursor
	;textbox 2
	Global $InputBox_2 = GUICtrlCreateInput($stateBLUR[1], ($lengthtLB * 0.99), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ; create input box
	GUICtrlSetLimit(-1, 3)

	;$stateRB[1] = 2

	If $stateRB[1] = 1 Then
		GUICtrlSetState($Radio2_1, $GUI_CHECKED)
	ElseIf $stateRB[1] = 2 Then
		GUICtrlSetState($Radio2_2, $GUI_CHECKED)
	ElseIf $stateRB[1] = 3 Then
		GUICtrlSetState($Radio2_3, $GUI_CHECKED)
		GUICtrlSetState($Slider_2, $GUI_DISABLE)
		GUICtrlSetState($InputBox_2, $GUI_DISABLE)
	ElseIf $stateRB[1] = 4 Then
		GUICtrlSetState($Radio2_4, $GUI_CHECKED)
	ElseIf $stateRB[1] = 5 Then
		GUICtrlSetState($Radio2_5, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Window Maximised accent can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	;$stateCB[0] = False


	If $stateCB[0] = False Then
		GUICtrlSetState($check2, $GUI_UNCHECKED)
		GUICtrlSetState($Radio2_1, $GUI_DISABLE)
		GUICtrlSetState($Radio2_2, $GUI_DISABLE)
		GUICtrlSetState($Radio2_3, $GUI_DISABLE)
		GUICtrlSetState($Radio2_4, $GUI_DISABLE)
		GUICtrlSetState($Radio2_5, $GUI_DISABLE)
		GUICtrlSetState($Slider_2, $GUI_DISABLE)
		GUICtrlSetState($InputBox_2, $GUI_DISABLE)
	EndIf






	;------------------Dynamic Start. State to use when the start menu is opened.-------------------------------------------------------------------



	Global $startGR = GUICtrlCreateGroup("Start Menu Open", $leftLB, ($topLB * 3) + ($heightLB * 2), $lengthtLB, $heightLB)
	GUICtrlSetFont($startGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check3 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 3) + $heightLB * (5 / 2))
	GUICtrlSetState($check3, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio3_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio3_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio3_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio3_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio3_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")



	Global $Slider_3 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 3
	GUICtrlSetLimit($Slider_3, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_3, $stateBLUR[2]) ; set cursor

	Global $InputBox_3 = GUICtrlCreateInput($stateBLUR[2], ($lengthtLB * 0.99), ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 3
	GUICtrlSetLimit(-1, 3)

	;$stateRB[2] = 3

	If $stateRB[2] = 1 Then
		GUICtrlSetState($Radio3_1, $GUI_CHECKED)
	ElseIf $stateRB[2] = 2 Then
		GUICtrlSetState($Radio3_2, $GUI_CHECKED)
	ElseIf $stateRB[2] = 3 Then
		GUICtrlSetState($Radio3_3, $GUI_CHECKED)
		GUICtrlSetState($Slider_3, $GUI_DISABLE)
		GUICtrlSetState($InputBox_3, $GUI_DISABLE)
	ElseIf $stateRB[2] = 4 Then
		GUICtrlSetState($Radio3_4, $GUI_CHECKED)
	ElseIf $stateRB[2] = 5 Then
		GUICtrlSetState($Radio3_5, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Start accent can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	;$stateCB[1] = False


	If $stateCB[1] = False Then
		GUICtrlSetState($check3, $GUI_UNCHECKED)
		GUICtrlSetState($Radio3_1, $GUI_DISABLE)
		GUICtrlSetState($Radio3_2, $GUI_DISABLE)
		GUICtrlSetState($Radio3_3, $GUI_DISABLE)
		GUICtrlSetState($Radio3_4, $GUI_DISABLE)
		GUICtrlSetState($Radio3_5, $GUI_DISABLE)
		GUICtrlSetState($Slider_3, $GUI_DISABLE)
		GUICtrlSetState($InputBox_3, $GUI_DISABLE)
	EndIf




	;-------------------Dynamic Cortana. State to use when Cortana or the search menu is opened.----------------------------------------------------------------------



	Global $cortanaGR = GUICtrlCreateGroup("Cortana Open", $leftLB, ($topLB * 4) + ($heightLB * 3), $lengthtLB, $heightLB)
	GUICtrlSetFont($cortanaGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check4 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 4) + $heightLB * (7 / 2))
	GUICtrlSetState($check4, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio4_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio4_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio4_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio4_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio4_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")




	Global $Slider_4 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 4
	GUICtrlSetLimit($Slider_4, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_4, $stateBLUR[3]) ; set cursor

	Global $InputBox_4 = GUICtrlCreateInput($stateBLUR[3], ($lengthtLB * 0.99), ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 4
	GUICtrlSetLimit(-1, 3)


	;$stateRB[3] = 4

	If $stateRB[3] = 1 Then
		GUICtrlSetState($Radio4_1, $GUI_CHECKED)
	ElseIf $stateRB[3] = 2 Then
		GUICtrlSetState($Radio4_2, $GUI_CHECKED)
	ElseIf $stateRB[3] = 3 Then
		GUICtrlSetState($Radio4_3, $GUI_CHECKED)
		GUICtrlSetState($Slider_4, $GUI_DISABLE)
		GUICtrlSetState($InputBox_4, $GUI_DISABLE)
	ElseIf $stateRB[3] = 4 Then
		GUICtrlSetState($Radio4_4, $GUI_CHECKED)
	ElseIf $stateRB[2] = 5 Then
		GUICtrlSetState($Radio4_5, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Cortana menu accent can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	;$stateCB[2] = False


	If $stateCB[2] = False Then
		GUICtrlSetState($check4, $GUI_UNCHECKED)
		GUICtrlSetState($Radio4_1, $GUI_DISABLE)
		GUICtrlSetState($Radio4_2, $GUI_DISABLE)
		GUICtrlSetState($Radio4_3, $GUI_DISABLE)
		GUICtrlSetState($Radio4_4, $GUI_DISABLE)
		GUICtrlSetState($Radio4_5, $GUI_DISABLE)
		GUICtrlSetState($Slider_4, $GUI_DISABLE)
		GUICtrlSetState($InputBox_4, $GUI_DISABLE)
	EndIf




	;------------------Dynamic Timeline. State to use when the timeline (or task view on older builds) is opened.---------------------------------------------------------------------------------------



	Global $timelineGR = GUICtrlCreateGroup("Timeline Open", $leftLB, ($topLB * 5) + ($heightLB * 4), $lengthtLB, $heightLB)
	GUICtrlSetFont($timelineGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check5 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 5) + $heightLB * (9 / 2))
	GUICtrlSetState($check5, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio5_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio5_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio5_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio5_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio5_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6))
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")




	Global $Slider_5 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 5
	GUICtrlSetLimit($Slider_5, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_5, $stateBLUR[4]) ; set cursor

	Global $InputBox_5 = GUICtrlCreateInput($stateBLUR[4], ($lengthtLB * 0.99), ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 5
	GUICtrlSetLimit(-1, 3)

	;$stateRB[4] = 5

	If $stateRB[4] = 1 Then
		GUICtrlSetState($Radio5_1, $GUI_CHECKED)
	ElseIf $stateRB[4] = 2 Then
		GUICtrlSetState($Radio5_2, $GUI_CHECKED)
	ElseIf $stateRB[4] = 3 Then
		GUICtrlSetState($Radio5_3, $GUI_CHECKED)
		GUICtrlSetState($Slider_5, $GUI_DISABLE)
		GUICtrlSetState($InputBox_5, $GUI_DISABLE)
	ElseIf $stateRB[4] = 4 Then
		GUICtrlSetState($Radio5_4, $GUI_CHECKED)
	ElseIf $stateRB[4] = 5 Then
		GUICtrlSetState($Radio5_5, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Timeline accent can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	;$stateCB[3] = False


	If $stateCB[3] = False Then
		GUICtrlSetState($check5, $GUI_UNCHECKED)
		GUICtrlSetState($Radio5_1, $GUI_DISABLE)
		GUICtrlSetState($Radio5_2, $GUI_DISABLE)
		GUICtrlSetState($Radio5_3, $GUI_DISABLE)
		GUICtrlSetState($Radio5_4, $GUI_DISABLE)
		GUICtrlSetState($Radio5_5, $GUI_DISABLE)
		GUICtrlSetState($Slider_5, $GUI_DISABLE)
		GUICtrlSetState($InputBox_5, $GUI_DISABLE)
	EndIf







	;---------------------------------------------------Advance / Simple -------------------------------------------------------

	Global $separate = GUICtrlCreateGraphic($size[2] / 1.9, $topLB, 1, $heightLB * 5.9, $SS_BLACKRECT)
	Global $separate2 = GUICtrlCreateGraphic($size[2] / 1.9, $topLB * 4, $size[2] / 2.3, 1, $SS_BLACKRECT)


	Global $StandardCtrl = GUICtrlCreateCheckbox("Standard Mode", $size[2] / 1.7, $topLB * 1.5, $size[2] / 8)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Everything you need to get that Translucent Taskabar", "Standard Controls", 1, BitOR(1, 2))
	Global $AdvanceCtrl = GUICtrlCreateCheckbox("Advance Mode", $size[2] / 1.25, $topLB * 1.5, $size[2] / 8)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Extra Customisation. + Dynamic Controls." & @CRLF & "Dynamic Controls : They all have their own accent, color and opacity settings", "Advance Controls", 1, BitOR(1, 2))

	;BitOR($SS_CENTER, $SS_CENTERIMAGE)







	;----------------------------------------------------colour palette------------------------------------------------------------



	Global $paletteGR = GUICtrlCreateGroup("Colour Selection", $size[2] / 1.81, $topLB * 5, $size[2] / 2.5, $heightLB * 1.5)
	GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)


	Global $btauto = GUICtrlCreateButton("Autodetect", $size[2] / 1.72, $topLB * 7, $leftLB * 3, $topLB * 1.3)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Autodetect currently selected colour in Windows Settings." & @CRLF & "DO NOT move the mouse for a few seconds after clicking this.", "Aotodetect", 1, BitOR(1, 2))  ;& @CRLF & "ALLOW SOME SECONDS to open setting and detect current colour"
	Global $bteye = GUICtrlCreateButton("EyeDropper", $size[2] / 1.42, $topLB * 7, $leftLB * 3, $topLB * 1.3)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Turns the mouse into an Eyedropper" & @CRLF & "allowing selection of any colour from UI." & @CRLF & "NOTE : Temporarily hides this Window till colour selection.", "Eyedropper", 1, BitOR(1, 2)) ;@CRLF & "Samples 2 pixels diagonally above the mouse pointer."

	; Create Picker1 with custom cursor
	Global $btpick = _GUIColorPicker_Create("Colour Picker", $size[2] / 1.21, $topLB * 7, $leftLB * 3, $topLB * 1.3, "0x" & $colour, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), '', 0, -1, -1, 'Pick a Colour', 'More')

	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Choose from a colour palette", "Colour Picker", 1, BitOR(1, 2))









	Global $preview = GUICtrlCreatePic($sTempFile, $size[2] / 1.62, $topLB * 9.5, $leftLB, $topLB * 2)
	GUICtrlSetTip(-1, "Preview of selected area for colour extraction", "Sample Viewer", 0, BitOR(1, 1))

	Global $arrow = GUICtrlCreateLabel(ChrW(0x27A2), $size[2] / 1.485, $topLB * 9.5, 0, 0)
	GUICtrlSetFont(-1, $leftLB * (2 / 5))

	Global $colourout = GUICtrlCreateGraphic($size[2] / 1.4, $topLB * 9.5, $leftLB, $topLB * 2)
	GUICtrlSetGraphic(-1, $GUI_GR_RECT)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor($colourout, "0x" & $colour)


	Global $arrow2 = GUICtrlCreateLabel(ChrW(0x27A3), $size[2] / 1.298, $topLB * 9.5, 0, 0)
	GUICtrlSetFont(-1, $leftLB * (2 / 5))

	Global $hexsym = GUICtrlCreateLabel("0x", $size[2] / 1.23, $topLB * 9.9)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	Global $colourtext = GUICtrlCreateInput($colour, $size[2] / 1.2, $topLB * 9.8, $leftLB * 2, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "HEX value of the colour.", "Colour Hex Viewer", 0, BitOR(1, 1))










	;----------------------------------------------------apply colour to---------------------------------------------------------------








	Global $applyGR = GUICtrlCreateGroup("Apply Colour", $size[2] / 1.81, $topLB * 13, $size[2] / 2.5, $heightLB * 1.6)
	GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)



	Global $colourset_tas = GUICtrlCreateLabel("Desktop :", $size[2] / 1.7, $topLB * 14.8, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $colourset_tastx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 14.7, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	_GUICtrlEdit_SetCueBanner(-1, "0x")
	GUICtrlSetData($colourset_tastx, $colourset[0])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Colour for taskbar on Desktop.")


	Global $colourset_max = GUICtrlCreateLabel("Maximised :", $size[2] / 1.3, $topLB * 14.8, $leftLB * 2.2, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $colourset_maxtx = GUICtrlCreateInput("", $size[2] / 1.184, $topLB * 14.7, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	_GUICtrlEdit_SetCueBanner(-1, "0x")
	GUICtrlSetData($colourset_maxtx, $colourset[1])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Colour for taskbar during fullscreen.")

	Global $colourset_sta = GUICtrlCreateLabel("Start      :", $size[2] / 1.7, $topLB * 16.8, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $colourset_statx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 16.7, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	_GUICtrlEdit_SetCueBanner(-1, "0x")
	GUICtrlSetData($colourset_statx, $colourset[2])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Colour for taskbar during Start")


	Global $colourset_cor = GUICtrlCreateLabel("Cortana    :", $size[2] / 1.3, $topLB * 16.8, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $colourset_cortx = GUICtrlCreateInput("", $size[2] / 1.184, $topLB * 16.7, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	_GUICtrlEdit_SetCueBanner(-1, "0x")
	GUICtrlSetData($colourset_cortx, $colourset[3])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Colour for taskbar during Cortana.")

	Global $colourset_tim = GUICtrlCreateLabel("Timeline :", $size[2] / 1.7, $topLB * 18.8, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $colourset_timtx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 18.7, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetLimit(-1, 6)
	_GUICtrlEdit_SetCueBanner(-1, "0x")
	GUICtrlSetData($colourset_timtx, $colourset[4])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Colour for taskbar wne Timeline open.")








	;------------------------------------------------------ aero peek behaviour---------------------------------------------------

	Global $peekGR = GUICtrlCreateGroup("Aero Peek", $size[2] / 1.81, $topLB * 21.3, $size[2] / 8.3, $heightLB * 1.9)
	GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)


	GUIStartGroup()
	Global $peekdynamic = GUICtrlCreateRadio("Dynamic", $size[2] / 1.73, $topLB * 23, ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Invisible when desktop is already visible.")
	Global $peekshow = GUICtrlCreateRadio("Show", $size[2] / 1.73, $topLB * 24.6, ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Always visible")
	Global $peekhide = GUICtrlCreateRadio("Hide", $size[2] / 1.73, $topLB * 26.3, ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB / 5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Always hidden")

	If $stateextra[0] = 1 Then
		GUICtrlSetState($peekdynamic, $GUI_CHECKED)
	ElseIf $stateextra[0] = 2 Then
		GUICtrlSetState($peekshow, $GUI_CHECKED)
	ElseIf $stateextra[0] = 3 Then
		GUICtrlSetState($peekhide, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Peek Behaviour Control state can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	Global $peekmain = GUICtrlCreateLabel("Peek only main ", $size[2] / 1.755, $topLB * 28, $leftLB * 2.5, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)

	GUIStartGroup()
	Global $peekmainyes = GUICtrlCreateRadio("Yes", $size[2] / 1.75, $topLB * 29.3, ($lengthtLB / 9.5))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Decides whether only the main monitor is considered when dynamic peek is enabled.")
	Global $peekmainno = GUICtrlCreateRadio("No", $size[2] / 1.61, $topLB * 29.3, ($lengthtLB / 12))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Decides whether only the main monitor is considered when dynamic peek is enabled.")
	GUICtrlSetState($peekmain, $GUI_CHECKED)

	If $stateextra[1] = 1 Then
		GUICtrlSetState($peekmainyes, $GUI_CHECKED)
	ElseIf $stateextra[1] = 2 Then
		GUICtrlSetState($peekmainno, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Peek Main Control state can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf




	;--------------------------------------------------------- extras ----------------------------------------------------------

	Global $extrasGR = GUICtrlCreateGroup("Extras", $size[2] / 1.44, $topLB * 21.3, $size[2] / 7.5, $heightLB * 1.9)
	GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)

	Global $sleeptime = GUICtrlCreateLabel("Sleep Time ", $size[2] / 1.42, $topLB * 23, $leftLB * 2.0, $topLB * 1.45)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)
	Global $sleeptime_tx = GUICtrlCreateInput("", $size[2] / 1.293, $topLB * 23, $leftLB * 1.32, $topLB * 1.3)
	GUICtrlSetLimit(-1, 5)
	_GUICtrlEdit_SetCueBanner(-1, "10")
	GUICtrlSetData($sleeptime_tx, $stateextra[2])
	GUICtrlSetFont(-1, $leftLB / 5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Sleep time in milliseconds." & @CRLF & "a shorter time reduces flicker when opening start" & @CRLF & "but results in higher CPU usage." & @CRLF & "Default is 10.")


	Global $systemtray = GUICtrlCreateLabel("System Tray icon", $size[2] / 1.42, $topLB * 25, $leftLB * 3, $topLB * 1.3)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)

	GUIStartGroup()
	Global $trayyes = GUICtrlCreateRadio("Yes", $size[2] / 1.41, $topLB * 26.25, ($lengthtLB / 10))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Show icon in system tray when TranslucentTB is running.")
	Global $trayno = GUICtrlCreateRadio("No", $size[2] / 1.31, $topLB * 26.25, ($lengthtLB / 10))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No icon in system tray when TranslucentTB is running.")

	If $stateextra[3] = 1 Then
		GUICtrlSetState($trayyes, $GUI_CHECKED)
	ElseIf $stateextra[3] = 2 Then
		GUICtrlSetState($trayno, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "System Tray Icon control state can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf


	Global $logging = GUICtrlCreateLabel("Verbose Logging", $size[2] / 1.42, $topLB * 28, $leftLB * 3, $topLB * 1.3)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Candara", 2)

	GUIStartGroup()
	Global $loggingyes = GUICtrlCreateRadio("Yes", $size[2] / 1.41, $topLB * 29.25, ($lengthtLB / 10))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "More informative logging. Can make huge log files.")
	Global $loggingno = GUICtrlCreateRadio("No", $size[2] / 1.31, $topLB * 29.25, ($lengthtLB / 10))
	GUICtrlSetFont(-1, $leftLB / 5.5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "more informative logging. Can make huge log files.")

	If $stateextra[4] = 1 Then
		GUICtrlSetState($loggingyes, $GUI_CHECKED)
	ElseIf $stateextra[4] = 2 Then
		GUICtrlSetState($loggingno, $GUI_CHECKED)
	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Logging state control state can't be read!" & @CRLF & "Please restore the config file to its initial state")
	EndIf






	;---------------------------------------------------final buttons---------------------------------------------------------

	Global $finalload = GUICtrlCreateButton("Load", $size[2] / 1.17, $topLB * 23, $leftLB * 3, $topLB * 1.5)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Load current TranslucentTB Settings", "", 1, BitOR(1, 2))  ;& @CRLF & "ALLOW SOME SECONDS to open setting and detect current colour"

	Global $finalpreview = GUICtrlCreateButton("Preview", $size[2] / 1.17, $topLB * 25.5, $leftLB * 3, $topLB * 1.5)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Apply on-screen settings and preview. To revert click load.", "", 1, BitOR(1, 2))  ;& @CRLF & "ALLOW SOME SECONDS to open setting and detect current colour"

	Global $finalsave = GUICtrlCreateButton("Save", $size[2] / 1.17, $topLB * 28, $leftLB * 3, $topLB * 1.5)
	GUICtrlSetFont(-1, $leftLB / 5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
	GUICtrlSetTip(-1, "Apply and Save current settings.", "", 1, BitOR(1, 2))  ;& @CRLF & "ALLOW SOME SECONDS to open setting and detect current colour"





	;-----------------------------------------------------hide buttons for standarad controls------------------------------------------------

	;$stateCB[4] = False

	If $stateCB[4] = True Then
		advancehide()

	ElseIf $stateCB[4] = False Then
		advanceshow()

	Else
		MsgBox($MB_ICONWARNING, "Error Reading Value", "Standard/Advance Control state can't be read!" & @CRLF & "Please restore the config file to its initial state")



	EndIf












	Return

EndFunc   ;==>DrawElements













Func main()


	;------------------------------------Sliider Behaviour and InputBox Link---------------------------------------------
	Local $check_Slide1[2]
	Local $check_Slide2[2]
	Local $check_Slide3[2]
	Local $check_Slide4[2]
	Local $check_Slide5[2]



	Do

		Local $n = GUIGetMsg()

		If $n = $GUI_EVENT_CLOSE Then Exit
		Local $Info = GUIGetCursorInfo()


		If @error Then

		Else
			Switch $n

				#cs
				Case $check1
					If GUICtrlRead($check1) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio1_1, $GUI_DISABLE)
						GUICtrlSetState($Radio1_2, $GUI_DISABLE)
						GUICtrlSetState($Radio1_3, $GUI_DISABLE)
						GUICtrlSetState($Radio1_4, $GUI_DISABLE)
						GUICtrlSetState($Radio1_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_1, $GUI_DISABLE)
						GUICtrlSetState($InputBox_1, $GUI_DISABLE)
					Else
						GUICtrlSetState($Radio1_1, $GUI_ENABLE)
						GUICtrlSetState($Radio1_2, $GUI_ENABLE)
						GUICtrlSetState($Radio1_3, $GUI_ENABLE)
						GUICtrlSetState($Radio1_4, $GUI_ENABLE)
						GUICtrlSetState($Radio1_5, $GUI_ENABLE)
						If GUICtrlRead($Radio1_3) = $GUI_UNCHECKED Then
							GUICtrlSetState($Slider_1, $GUI_ENABLE)
							GUICtrlSetState($InputBox_1, $GUI_ENABLE)
						EndIf
					EndIf
				#ce

				Case $Radio1_1
					GUICtrlSetState($Slider_1, $GUI_ENABLE)
					GUICtrlSetState($InputBox_1, $GUI_ENABLE)
					$stateRB[0] = 1
				Case $Radio1_2
					GUICtrlSetState($Slider_1, $GUI_ENABLE)
					GUICtrlSetState($InputBox_1, $GUI_ENABLE)
					$stateRB[0] = 2

				Case $Radio1_3
					GUICtrlSetState($Slider_1, $GUI_DISABLE)
					GUICtrlSetState($InputBox_1, $GUI_DISABLE)
					$stateRB[0] = 3

				Case $Radio1_4
					GUICtrlSetState($Slider_1, $GUI_ENABLE)
					GUICtrlSetState($InputBox_1, $GUI_ENABLE)
					$stateRB[0] = 4
				Case $Radio1_5
					GUICtrlSetState($Slider_1, $GUI_ENABLE)
					GUICtrlSetState($InputBox_1, $GUI_ENABLE)
					$stateRB[0] = 5

				Case $check2

					If GUICtrlRead($check2) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio2_1, $GUI_DISABLE)
						GUICtrlSetState($Radio2_2, $GUI_DISABLE)
						GUICtrlSetState($Radio2_3, $GUI_DISABLE)
						GUICtrlSetState($Radio2_4, $GUI_DISABLE)
						GUICtrlSetState($Radio2_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_2, $GUI_DISABLE)
						GUICtrlSetState($InputBox_2, $GUI_DISABLE)
						$stateCB[0] = False
					ElseIf GUICtrlRead($check2) = $GUI_CHECKED Then
						GUICtrlSetState($Radio2_1, $GUI_ENABLE)
						GUICtrlSetState($Radio2_2, $GUI_ENABLE)
						GUICtrlSetState($Radio2_3, $GUI_ENABLE)
						GUICtrlSetState($Radio2_4, $GUI_ENABLE)
						GUICtrlSetState($Radio2_5, $GUI_ENABLE)
						If GUICtrlRead($Radio2_3) = $GUI_UNCHECKED Then
							GUICtrlSetState($Slider_2, $GUI_ENABLE)
							GUICtrlSetState($InputBox_2, $GUI_ENABLE)
						EndIf
						$stateCB[0] = True
					EndIf

				Case $Radio2_1
					GUICtrlSetState($Slider_2, $GUI_ENABLE)
					GUICtrlSetState($InputBox_2, $GUI_ENABLE)
					$stateRB[1] = 1

				Case $Radio2_2
					GUICtrlSetState($Slider_2, $GUI_ENABLE)
					GUICtrlSetState($InputBox_2, $GUI_ENABLE)
					$stateRB[1] = 2

				Case $Radio2_3
					GUICtrlSetState($Slider_2, $GUI_DISABLE)
					GUICtrlSetState($InputBox_2, $GUI_DISABLE)
					$stateRB[1] = 3
				Case $Radio2_4
					GUICtrlSetState($Slider_2, $GUI_ENABLE)
					GUICtrlSetState($InputBox_2, $GUI_ENABLE)
					$stateRB[1] = 4

				Case $Radio2_5
					GUICtrlSetState($Slider_2, $GUI_ENABLE)
					GUICtrlSetState($InputBox_2, $GUI_ENABLE)
					$stateRB[1] = 5

				Case $check3

					If GUICtrlRead($check3) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio3_1, $GUI_DISABLE)
						GUICtrlSetState($Radio3_2, $GUI_DISABLE)
						GUICtrlSetState($Radio3_3, $GUI_DISABLE)
						GUICtrlSetState($Radio3_4, $GUI_DISABLE)
						GUICtrlSetState($Radio3_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_3, $GUI_DISABLE)
						GUICtrlSetState($InputBox_3, $GUI_DISABLE)
						$stateCB[1] = False
					ElseIf GUICtrlRead($check3) = $GUI_CHECKED Then
						GUICtrlSetState($Radio3_1, $GUI_ENABLE)
						GUICtrlSetState($Radio3_2, $GUI_ENABLE)
						GUICtrlSetState($Radio3_3, $GUI_ENABLE)
						GUICtrlSetState($Radio3_4, $GUI_ENABLE)
						GUICtrlSetState($Radio3_5, $GUI_ENABLE)
						If GUICtrlRead($Radio3_3) = $GUI_UNCHECKED Then
							GUICtrlSetState($Slider_3, $GUI_ENABLE)
							GUICtrlSetState($InputBox_3, $GUI_ENABLE)
						EndIf
						$stateCB[1] = True
					EndIf

				Case $Radio3_1
					GUICtrlSetState($Slider_3, $GUI_ENABLE)
					GUICtrlSetState($InputBox_3, $GUI_ENABLE)
					$stateRB[2] = 1
				Case $Radio3_2
					GUICtrlSetState($Slider_3, $GUI_ENABLE)
					GUICtrlSetState($InputBox_3, $GUI_ENABLE)
					$stateRB[2] = 2
				Case $Radio3_3
					GUICtrlSetState($Slider_3, $GUI_DISABLE)
					GUICtrlSetState($InputBox_3, $GUI_DISABLE)
					$stateRB[2] = 3
				Case $Radio3_4
					GUICtrlSetState($Slider_3, $GUI_ENABLE)
					GUICtrlSetState($InputBox_3, $GUI_ENABLE)
					$stateRB[2] = 4
				Case $Radio3_5
					GUICtrlSetState($Slider_3, $GUI_ENABLE)
					GUICtrlSetState($InputBox_3, $GUI_ENABLE)
					$stateRB[2] = 5

				Case $check4
					If GUICtrlRead($check4) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio4_1, $GUI_DISABLE)
						GUICtrlSetState($Radio4_2, $GUI_DISABLE)
						GUICtrlSetState($Radio4_3, $GUI_DISABLE)
						GUICtrlSetState($Radio4_4, $GUI_DISABLE)
						GUICtrlSetState($Radio4_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_4, $GUI_DISABLE)
						GUICtrlSetState($InputBox_4, $GUI_DISABLE)
						$stateCB[2] = False
					ElseIf GUICtrlRead($check4) = $GUI_CHECKED Then
						GUICtrlSetState($Radio4_1, $GUI_ENABLE)
						GUICtrlSetState($Radio4_2, $GUI_ENABLE)
						GUICtrlSetState($Radio4_3, $GUI_ENABLE)
						GUICtrlSetState($Radio4_4, $GUI_ENABLE)
						GUICtrlSetState($Radio4_5, $GUI_ENABLE)
						If GUICtrlRead($Radio4_3) = $GUI_UNCHECKED Then
							GUICtrlSetState($Slider_4, $GUI_ENABLE)
							GUICtrlSetState($InputBox_4, $GUI_ENABLE)
						EndIf
						$stateCB[2] = True
					EndIf

				Case $Radio4_1
					GUICtrlSetState($Slider_4, $GUI_ENABLE)
					GUICtrlSetState($InputBox_4, $GUI_ENABLE)
					$stateRB[3] = 1
				Case $Radio4_2
					GUICtrlSetState($Slider_4, $GUI_ENABLE)
					GUICtrlSetState($InputBox_4, $GUI_ENABLE)
					$stateRB[3] = 2
				Case $Radio4_3
					GUICtrlSetState($Slider_4, $GUI_DISABLE)
					GUICtrlSetState($InputBox_4, $GUI_DISABLE)
					$stateRB[3] = 3
				Case $Radio4_4
					GUICtrlSetState($Slider_4, $GUI_ENABLE)
					GUICtrlSetState($InputBox_4, $GUI_ENABLE)
					$stateRB[3] = 4
				Case $Radio4_5
					GUICtrlSetState($Slider_4, $GUI_ENABLE)
					GUICtrlSetState($InputBox_4, $GUI_ENABLE)
					$stateRB[3] = 5

				Case $check5
					If GUICtrlRead($check5) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio5_1, $GUI_DISABLE)
						GUICtrlSetState($Radio5_2, $GUI_DISABLE)
						GUICtrlSetState($Radio5_3, $GUI_DISABLE)
						GUICtrlSetState($Radio5_4, $GUI_DISABLE)
						GUICtrlSetState($Radio5_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_5, $GUI_DISABLE)
						GUICtrlSetState($InputBox_5, $GUI_DISABLE)
						$stateCB[3] = False
					ElseIf GUICtrlRead($check5) = $GUI_CHECKED Then
						GUICtrlSetState($Radio5_1, $GUI_ENABLE)
						GUICtrlSetState($Radio5_2, $GUI_ENABLE)
						GUICtrlSetState($Radio5_3, $GUI_ENABLE)
						GUICtrlSetState($Radio5_4, $GUI_ENABLE)
						GUICtrlSetState($Radio5_5, $GUI_ENABLE)
						If GUICtrlRead($Radio5_3) = $GUI_UNCHECKED Then
							GUICtrlSetState($Slider_5, $GUI_ENABLE)
							GUICtrlSetState($InputBox_5, $GUI_ENABLE)
						EndIf
						$stateCB[3] = True
					EndIf

				Case $Radio5_1
					GUICtrlSetState($Slider_5, $GUI_ENABLE)
					GUICtrlSetState($InputBox_5, $GUI_ENABLE)
					$stateRB[4] = 1
				Case $Radio5_2
					GUICtrlSetState($Slider_5, $GUI_ENABLE)
					GUICtrlSetState($InputBox_5, $GUI_ENABLE)
					$stateRB[4] = 2
				Case $Radio5_3
					GUICtrlSetState($Slider_5, $GUI_DISABLE)
					GUICtrlSetState($InputBox_5, $GUI_DISABLE)
					$stateRB[4] = 3
				Case $Radio5_4
					GUICtrlSetState($Slider_5, $GUI_ENABLE)
					GUICtrlSetState($InputBox_5, $GUI_ENABLE)
					$stateRB[4] = 4
				Case $Radio5_5
					GUICtrlSetState($Slider_5, $GUI_ENABLE)
					GUICtrlSetState($InputBox_5, $GUI_ENABLE)
					$stateRB[4] = 5



				Case $StandardCtrl
					advancehide()
					$stateCB[4] = True

				Case $AdvanceCtrl
					advanceshow()
					$stateCB[4] = False


				Case $btauto

					$colour = Hex(RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\History\Colors", "ColorHistory0"))
					$colour = StringRight($colour, 6)
					$colour = StringRight($colour, 2) & StringMid($colour, 3, 2) & StringLeft($colour, 2)

					GUICtrlSetImage($preview, "")
					GUICtrlSetState($arrow, $GUI_HIDE)

					GUICtrlSetBkColor($colourout, "0x" & $colour)
					GUICtrlSetData($colourtext, $colour)



				Case $bteye

					$sTempFile = _TempFile(@TempDir, "\" & "colour_Sample_", ".jpg", 3)

					GUISetState(@SW_MINIMIZE)

					While 1
						If _IsPressed("01") Then
							ExitLoop
						EndIf
					WEnd

					WinActivate("Program Manager")


					;getting mouse position and taking a screenshot
					$pos = MouseGetPos()
					_ScreenCapture_Capture($sTempFile, $pos[0] - 25, $pos[1] - 25, $pos[0] + 25, $pos[1] + 25)
					Sleep(200)
					GUISetState(@SW_RESTORE)
					GUICtrlSetImage($preview, $sTempFile)
					GUICtrlSetState($arrow, $GUI_SHOW)

					;Getting Colour Value from the screenshot's 10*10 position
					$iPosX = 23
					$iPosY = 23
					_GDIPlus_Startup()
					$hImage = _GDIPlus_ImageLoadFromFile($sTempFile)
					$colour = Hex(_GDIPlus_BitmapGetPixel($hImage, $iPosX, $iPosY), 6)
					GUICtrlSetBkColor($colourout, "0x" & $colour)
					GUICtrlSetData($colourtext, $colour)
					;ShellExecute($sTempFile)
					;MsgBox(0, "Pixel Color", $colour)
					_GDIPlus_ImageDispose($hImage)
					_GDIPlus_Shutdown()



				Case $btpick


					GUICtrlSetState($arrow, $GUI_HIDE)
					GUICtrlSetImage($preview, "")
					; Load cursor
					#cs
					Dim $aPalette[20] = _
						[0xFFFFFF, 0x000000, 0xC0C0C0, 0x808080, _
						0xFF0000, 0x800000, 0xFFFF00, 0x808000, _
						0x00FF00, 0x008000, 0x00FFFF, 0x008080, _
						0x0000FF, 0x000080, 0xFF00FF, 0x800080, _
						0xC0DCC0, 0xA6CAF0, 0xFFFBF0, 0xA0A0A4]

					#ce
					$colour = Hex(_GUIColorPicker_GetColor($btpick), 6)
					GUICtrlSetBkColor($colourout, "0x" & $colour)
					GUICtrlSetData($colourtext, $colour)

				Case $peekdynamic
					$stateextra[0] = 1
				Case $peekshow
					$stateextra[0] = 2
				Case $peekhide
					$stateextra[0] = 3

				Case $trayyes
					$stateextra[3] = 1
				Case $trayno
					$stateextra[3] = 2





				Case $finalload
					fload()

				Case $finalpreview
					fpreview()

				Case $finalsave
					fsave()




				Case $GUI_EVENT_RESIZED
					Sleep(50)
					uirefresh()
				Case $GUI_EVENT_MAXIMIZE
					uirefresh()
					$max = True
				Case $GUI_EVENT_RESTORE
					Sleep(50)
					If $max Then
						uirefresh()
						$max = False ;unnessary refresh on window restored after being minimised fix
					EndIf



			EndSwitch






			;Sleep(60)




			If $Info[4] = $Slider_1 And $Info[2] Then
				$check_Slide1[1] = True
				$check_Slide1[0] = True
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $InputBox_1 And $Info[2] Then
				$check_Slide1[1] = True
				$check_Slide1[0] = False
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $Slider_2 And $Info[2] Then
				$check_Slide2[1] = True
				$check_Slide1[1] = False
				$check_Slide2[0] = True
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $InputBox_2 And $Info[2] Then
				$check_Slide2[1] = True
				$check_Slide1[1] = False
				$check_Slide2[0] = False
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $Slider_3 And $Info[2] Then
				$check_Slide3[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[0] = True
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $InputBox_3 And $Info[2] Then
				$check_Slide3[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[0] = False
				$check_Slide4[1] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $Slider_4 And $Info[2] Then
				$check_Slide4[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[0] = True
				$check_Slide5[1] = False

			ElseIf $Info[4] = $InputBox_4 And $Info[2] Then
				$check_Slide4[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[0] = False
				$check_Slide5[1] = False

			ElseIf $Info[4] = $Slider_5 And $Info[2] Then
				$check_Slide5[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[0] = True

			ElseIf $Info[4] = $InputBox_5 And $Info[2] Then
				$check_Slide5[1] = True
				$check_Slide1[1] = False
				$check_Slide2[1] = False
				$check_Slide3[1] = False
				$check_Slide4[1] = False
				$check_Slide5[0] = False

			EndIf



			If $check_Slide1[1] = True Then
				If $check_Slide1[0] Then
					Local $val = GUICtrlRead($Slider_1)
					GUICtrlSetData($InputBox_1, $val)
					$stateBLUR[0] = $val

				ElseIf Not $check_Slide1[0] Then
					Local $val = GUICtrlRead($InputBox_1)
					GUICtrlSetData($Slider_1, $val)
					$stateBLUR[0] = $val
				EndIf

			ElseIf $check_Slide2[1] = True Then
				If $check_Slide2[0] Then
					Local $val = GUICtrlRead($Slider_2)
					GUICtrlSetData($InputBox_2, $val)
					$stateBLUR[1] = $val

				ElseIf Not $check_Slide2[0] Then
					Local $val = GUICtrlRead($InputBox_2)
					GUICtrlSetData($Slider_2, $val)
					$stateBLUR[1] = $val
				EndIf

			ElseIf $check_Slide3[1] = True Then
				If $check_Slide3[0] Then
					Local $val = GUICtrlRead($Slider_3)
					GUICtrlSetData($InputBox_3, $val)
					$stateBLUR[2] = $val

				ElseIf Not $check_Slide3[0] Then
					Local $val = GUICtrlRead($InputBox_3)
					GUICtrlSetData($Slider_3, $val)
					$stateBLUR[2] = $val
				EndIf

			ElseIf $check_Slide4[1] = True Then
				If $check_Slide4[0] Then
					Local $val = GUICtrlRead($Slider_4)
					GUICtrlSetData($InputBox_4, $val)
					$stateBLUR[3] = $val

				ElseIf Not $check_Slide4[0] Then
					Local $val = GUICtrlRead($InputBox_4)
					GUICtrlSetData($Slider_4, $val)
					$stateBLUR[3] = $val
				EndIf

			ElseIf $check_Slide5[1] = True Then
				If $check_Slide5[0] Then
					Local $val = GUICtrlRead($Slider_5)
					GUICtrlSetData($InputBox_5, $val)
					$stateBLUR[4] = $val

				ElseIf Not $check_Slide5[0] Then
					Local $val = GUICtrlRead($InputBox_5)
					GUICtrlSetData($Slider_5, $val)
					$stateBLUR[4] = $val
				EndIf

			ElseIf StringCompare($colour, GUICtrlRead($colourtext), 2) <> 0 Then
				GUICtrlSetBkColor($colourout, "0x" & GUICtrlRead($colourtext))
				$colour = GUICtrlRead($colourtext)
				_GUIColorPicker_SetColor($btpick, Dec(GUICtrlRead($colourtext)))

			ElseIf StringCompare($colourset[0], GUICtrlRead($colourset_tastx), 2) <> 0 Then
				$colourset[0] = GUICtrlRead($colourset_tastx)

			ElseIf StringCompare($colourset[1], GUICtrlRead($colourset_maxtx), 2) <> 0 Then
				$colourset[1] = GUICtrlRead($colourset_maxtx)

			ElseIf StringCompare($colourset[2], GUICtrlRead($colourset_statx), 2) <> 0 Then
				$colourset[2] = GUICtrlRead($colourset_statx)

			ElseIf StringCompare($colourset[3], GUICtrlRead($colourset_cortx), 2) <> 0 Then
				$colourset[3] = GUICtrlRead($colourset_cortx)

			ElseIf StringCompare($colourset[4], GUICtrlRead($colourset_timtx), 2) <> 0 Then
				$colourset[4] = GUICtrlRead($colourset_timtx)

			ElseIf StringCompare($stateextra[2], GUICtrlRead($sleeptime_tx), 2) <> 0 Then
				$stateextra[2] = GUICtrlRead($sleeptime_tx)
			EndIf






		EndIf ;minimise/outer click error mitigation endif

	Until $n = $GUI_EVENT_CLOSE








EndFunc   ;==>main



Func fload()


	If $previewactive Then
		$previewactive = False
		ProcessClose("TranslucentTB.exe")
		ProcessWaitClose("TranslucentTB.exe")
		FileCopy(@AppDataDir & "\TranslucentTB\con_edit.cfg", @AppDataDir & "\TranslucentTB\config.cfg", 1)
		FileDelete(@AppDataDir & "\TranslucentTB\con_edit.cfg")

		Run(StringLeft(@WindowsDir, 3) & "Program Files (x86)\TranslucentTB\TranslucentTB.exe")
		ProcessWait("TranslucentTB.exe")
		fload()
	Else

		Local $aLines
		_FileReadToArray(@AppDataDir & "\TranslucentTB\config.cfg", $aLines, $FRTA_COUNT)
		Local $count = 0
		Local $replace
		Local $position
		Local $count1

		For $i = 1 To $aLines[0]
			$position = 0
			For $j = 0 To (StringLen($aLines[$i]) - 1)
				If (StringMid($aLines[$i], $j, 1) == Chr(59)) Then
					ExitLoop
				ElseIf (StringMid($aLines[$i], $j, 1) == Chr(61)) Then
					$count += 1
					$position = $j
					$count1 = $count
					ExitLoop
				EndIf
			Next

			Switch ($count1)
				Case 0


				Case 1
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Clear", $value, 0) Then
						$stateRB[0] = 1
						$count1 = 0
					ElseIf StringInStr("Fluent", $value, 0) Then
						$stateRB[0] = 2
						$count1 = 0
					ElseIf StringInStr("Opaque", $value, 0) Then
						$stateRB[0] = 3
						$count1 = 0
					ElseIf StringInStr("Normal", $value, 0) Then
						$stateRB[0] = 4
						$count1 = 0
					ElseIf StringInStr("Blur", $value, 0) Then
						$stateRB[0] = 5
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Global Taskbar blur style incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 2
					$value = StringMid($aLines[$i], $position + 1, 6)
					;MsgBox(0, "", $value)
					$colourset[0] = $value
					$count1 = 0

				Case 3
					$value = StringMid($aLines[$i], $position + 1, 3)
					$stateBLUR[0] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 4
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateCB[0] = True
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateCB[0] = False
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Window Maximised checkbox value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 5
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Clear", $value, 0) Then
						$stateRB[1] = 1
						$count1 = 0
					ElseIf StringInStr("Fluent", $value, 0) Then
						$stateRB[1] = 2
						$count1 = 0
					ElseIf StringInStr("Opaque", $value, 0) Then
						$stateRB[1] = 3
						$count1 = 0
					ElseIf StringInStr("Normal", $value, 0) Then
						$stateRB[1] = 4
						$count1 = 0
					ElseIf StringInStr("Blur", $value, 0) Then
						$stateRB[1] = 5
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Window Maximised blur style incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 6
					$value = StringMid($aLines[$i], $position + 1, 6)
					;MsgBox(0, "", $value)
					$colourset[1] = $value
					$count1 = 0

				Case 7
					$value = StringMid($aLines[$i], $position + 1, 3)
					$stateBLUR[1] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 9
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateCB[1] = True
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateCB[1] = False
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Dynamic Start checkbox value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 10
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Clear", $value, 0) Then
						$stateRB[2] = 1
						$count1 = 0
					ElseIf StringInStr("Fluent", $value, 0) Then
						$stateRB[2] = 2
						$count1 = 0
					ElseIf StringInStr("Opaque", $value, 0) Then
						$stateRB[2] = 3
						$count1 = 0
					ElseIf StringInStr("Normal", $value, 0) Then
						$stateRB[2] = 4
						$count1 = 0
					ElseIf StringInStr("Blur", $value, 0) Then
						$stateRB[2] = 5
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Dynamic Start blur style incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 11
					$value = StringMid($aLines[$i], $position + 1, 6)
					;MsgBox(0, "", $value)
					$colourset[2] = $value
					$count1 = 0

				Case 12
					$value = StringMid($aLines[$i], $position + 1, 3)
					$stateBLUR[2] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 13
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateCB[2] = True
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateCB[2] = False
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Cortana checkbox value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 14
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Clear", $value, 0) Then
						$stateRB[3] = 1
						$count1 = 0
					ElseIf StringInStr("Fluent", $value, 0) Then
						$stateRB[3] = 2
						$count1 = 0
					ElseIf StringInStr("Opaque", $value, 0) Then
						$stateRB[3] = 3
						$count1 = 0
					ElseIf StringInStr("Normal", $value, 0) Then
						$stateRB[3] = 4
						$count1 = 0
					ElseIf StringInStr("Blur", $value, 0) Then
						$stateRB[3] = 5
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Cortana blur style incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 15
					$value = StringMid($aLines[$i], $position + 1, 6)
					;MsgBox(0, "", $value)
					$colourset[3] = $value
					$count1 = 0

				Case 16
					$value = StringMid($aLines[$i], $position + 1, 3)
					$stateBLUR[3] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 17
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateCB[3] = True
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateCB[3] = False
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Timeline checkbox value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 18
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Clear", $value, 0) Then
						$stateRB[4] = 1
						$count1 = 0
					ElseIf StringInStr("Fluent", $value, 0) Then
						$stateRB[4] = 2
						$count1 = 0
					ElseIf StringInStr("Opaque", $value, 0) Then
						$stateRB[4] = 3
						$count1 = 0
					ElseIf StringInStr("Normal", $value, 0) Then
						$stateRB[4] = 4
						$count1 = 0
					ElseIf StringInStr("Blur", $value, 0) Then
						$stateRB[4] = 5
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Timeline blur style incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 19
					$value = StringMid($aLines[$i], $position + 1, 6)
					;MsgBox(0, "", $value)
					$colourset[4] = $value
					$count1 = 0

				Case 20
					$value = StringMid($aLines[$i], $position + 1, 3)
					$stateBLUR[4] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 21
					$value = StringMid($aLines[$i], $position + 1, 4)
					;MsgBox(0, "", $value)
					If StringInStr("Dynamic", $value, 0) Then
						$stateextra[0] = 1
						$count1 = 0
					ElseIf StringInStr("Show", $value, 0) Then
						$stateextra[0] = 2
						$count1 = 0
					ElseIf StringInStr("Hide", $value, 0) Then
						$stateextra[0] = 3
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Aero Peek value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 22
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateextra[1] = 1
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateextra[1] = 2
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Peek only main value incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 23
					$value = StringMid($aLines[$i], $position + 1, 5)
					$stateextra[2] = Number($value)
					;MsgBox(0, "", $stateBLUR[0])
					$count1 = 0

				Case 24
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateextra[3] = 2
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateextra[3] = 1
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "System tray icon state incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

				Case 25
					$value = StringMid($aLines[$i], $position + 1, 5)
					;MsgBox(0, "", $value)
					If StringInStr("Enable", $value, 0) Then
						$stateextra[4] = 1
						$count1 = 0
					ElseIf StringInStr("Disable", $value, 0) Then
						$stateextra[4] = 2
						$count1 = 0
					Else
						MsgBox($MB_ICONWARNING, "Error Reading Value", "Verbose Logging state incorrect in config." & @CRLF & "Please restore the config file to its initial state")
					EndIf

			EndSwitch

		Next


		uirefresh()
	EndIf

	Return


EndFunc   ;==>fload


Func fpreview()

	$previewactive = True
	ProcessClose("TranslucentTB.exe")
	ProcessWaitClose("TranslucentTB.exe")
	FileCopy(@AppDataDir & "\TranslucentTB\config.cfg", @AppDataDir & "\TranslucentTB\con_edit.cfg", 8)


	Local $aConfig
	_FileReadToArray(@AppDataDir & "\TranslucentTB\config.cfg", $aConfig)

	For $i = 1 To $aConfig[0]
		If StringInStr($aConfig[$i], "accent=", 0, 1, 1 , 7) Then
			$aConfig[$i] = ("accent=" & rbconvert($stateRB[0]))

		ElseIf StringInStr($aConfig[$i], "color=", 0, 1, 1 , 6) Then
			$aConfig[$i] = ("color=" & $colourset[0])

		ElseIf StringInStr($aConfig[$i], "opacity=", 0, 1, 1 , 8) Then
			$aConfig[$i] = ("opacity=" & $stateBLUR[0])




		ElseIf StringInStr($aConfig[$i], "dynamic-ws=", 0, 1) Then
			$aConfig[$i] = "dynamic-ws=" & ($stateCB[0] ? "enable" : "disable")

		ElseIf StringInStr($aConfig[$i], "dynamic-ws-accent=", 0, 1) Then
			$aConfig[$i] = "dynamic-ws-accent=" & rbconvert($stateRB[1])

		ElseIf StringInStr($aConfig[$i], "dynamic-ws-color=", 0, 1) Then
			$aConfig[$i] = "dynamic-ws-color=" & $colourset[1]

		ElseIf StringInStr($aConfig[$i], "dynamic-ws-opacity=", 0, 1) Then
			$aConfig[$i] = "dynamic-ws-opacity=" & $stateBLUR[1]




		ElseIf StringInStr($aConfig[$i], "dynamic-start=", 0, 1) Then
			$aConfig[$i] = "dynamic-start=" & ($stateCB[1] ? "enable" : "disable")

		ElseIf StringInStr($aConfig[$i], "dynamic-start-accent=", 0, 1) Then
			$aConfig[$i] = "dynamic-start-accent=" & rbconvert($stateRB[2])

		ElseIf StringInStr($aConfig[$i], "dynamic-start-color=", 0, 1) Then
			$aConfig[$i] = "dynamic-start-color=" & $colourset[2]

		ElseIf StringInStr($aConfig[$i], "dynamic-start-opacity=", 0, 1) Then
			$aConfig[$i] = "dynamic-start-opacity=" & $stateBLUR[2]




		ElseIf StringInStr($aConfig[$i], "dynamic-cortana=", 0, 1) Then
			$aConfig[$i] = "dynamic-cortana=" & ($stateCB[2] ? "enable" : "disable")

		ElseIf StringInStr($aConfig[$i], "dynamic-cortana-accent=", 0, 1) Then
			$aConfig[$i] = "dynamic-cortana-accent=" & rbconvert($stateRB[3])

		ElseIf StringInStr($aConfig[$i], "dynamic-cortana-color=", 0, 1) Then
			$aConfig[$i] = "dynamic-cortana-color=" & $colourset[3]

		ElseIf StringInStr($aConfig[$i], "dynamic-cortana-opacity=", 0, 1) Then
			$aConfig[$i] = "dynamic-cortana-opacity=" & $stateBLUR[3]




		ElseIf StringInStr($aConfig[$i], "dynamic-timeline=", 0, 1) Then
			$aConfig[$i] = "dynamic-timeline=" & ($stateCB[3] ? "enable" : "disable")

		ElseIf StringInStr($aConfig[$i], "dynamic-timeline-accent=", 0, 1) Then
			$aConfig[$i] = "dynamic-timeline-accent=" & rbconvert($stateRB[4])

		ElseIf StringInStr($aConfig[$i], "dynamic-timeline-color=", 0, 1) Then
			$aConfig[$i] = "dynamic-timeline-color=" & $colourset[4]

		ElseIf StringInStr($aConfig[$i], "dynamic-timeline-opacity=", 0, 1) Then
			$aConfig[$i] = "dynamic-timeline-opacity=" & $stateBLUR[4]





		ElseIf StringInStr($aConfig[$i], "peek=", 0, 1) Then
			$aConfig[$i] = "peek=" & ($stateextra[0] == 1 ? "dynamic" : ($stateextra[0] == 2 ? "show" : "hide"))

		ElseIf StringInStr($aConfig[$i], "peek-only-main=", 0, 1) Then
			$aConfig[$i] = "peek-only-main=" & ($stateextra[1] ? "enable" : "disable")

		ElseIf StringInStr($aConfig[$i], "sleep-time=", 0, 1) Then
			$aConfig[$i] = "sleep-time=" & $stateextra[2]

		ElseIf StringInStr($aConfig[$i], "no-tray=", 0, 1) Then
			$aConfig[$i] = "no-tray=" & ($stateextra[3] ? "disable" : "enable")

		ElseIf StringInStr($aConfig[$i], "verbose=", 0, 1) Then
			$aConfig[$i] = "verbose=" & ($stateextra[4] ? "enable" : "disable")


		EndIf



	Next

	_FileWriteFromArray(@AppDataDir & "\TranslucentTB\config.cfg", $aConfig, 1)

	Run(StringLeft(@WindowsDir, 3) & "Program Files (x86)\TranslucentTB\TranslucentTB.exe")
	ProcessWait("TranslucentTB.exe")

	_ArrayDisplay($aConfig)

	Return


EndFunc   ;==>fpreview

Func fsave()

	If Not $previewactive Then fpreview()
	FileDelete(@AppDataDir & "\TranslucentTB\con_edit.cfg")


	Return


EndFunc   ;==>fsave



Func rbconvert($num)
	If $num == 1 Then
		Return "clear"
	ElseIf $num == 2 Then
		Return "fluent"
	ElseIf $num == 3 Then
		Return "opaque"
	ElseIf $num == 4 Then
		Return "normal"
	ElseIf $num == 5 Then
		Return "blur"
	EndIf

EndFunc   ;==>rbconvert



Func uirefresh()


	GUICtrlDelete($taskbarGR)
	;GUICtrlDelete($check1)
	GUICtrlDelete($Radio1_1)
	GUICtrlDelete($Radio1_2)
	GUICtrlDelete($Radio1_3)
	GUICtrlDelete($Radio1_4)
	GUICtrlDelete($Radio1_5)
	GUICtrlDelete($InputBox_1)
	GUICtrlDelete($Slider_1)

	GUICtrlDelete($maximisedGR)
	GUICtrlDelete($check2)
	GUICtrlDelete($Radio2_1)
	GUICtrlDelete($Radio2_2)
	GUICtrlDelete($Radio2_3)
	GUICtrlDelete($Radio2_4)
	GUICtrlDelete($Radio2_5)
	GUICtrlDelete($InputBox_2)
	GUICtrlDelete($Slider_2)

	GUICtrlDelete($startGR)
	GUICtrlDelete($check3)
	GUICtrlDelete($Radio3_1)
	GUICtrlDelete($Radio3_2)
	GUICtrlDelete($Radio3_3)
	GUICtrlDelete($Radio3_4)
	GUICtrlDelete($Radio3_5)
	GUICtrlDelete($InputBox_3)
	GUICtrlDelete($Slider_3)

	GUICtrlDelete($cortanaGR)
	GUICtrlDelete($check4)
	GUICtrlDelete($Radio4_1)
	GUICtrlDelete($Radio4_2)
	GUICtrlDelete($Radio4_3)
	GUICtrlDelete($Radio4_4)
	GUICtrlDelete($Radio4_5)
	GUICtrlDelete($InputBox_4)
	GUICtrlDelete($Slider_4)

	GUICtrlDelete($timelineGR)
	GUICtrlDelete($check5)
	GUICtrlDelete($Radio5_1)
	GUICtrlDelete($Radio5_2)
	GUICtrlDelete($Radio5_3)
	GUICtrlDelete($Radio5_4)
	GUICtrlDelete($Radio5_5)
	GUICtrlDelete($InputBox_5)
	GUICtrlDelete($Slider_5)


	GUICtrlDelete($separate)
	GUICtrlDelete($separate2)
	GUICtrlDelete($StandardCtrl)
	GUICtrlDelete($AdvanceCtrl)
	GUICtrlDelete($paletteGR)
	GUICtrlDelete($btauto)
	GUICtrlDelete($bteye)
	_GUIColorPicker_Delete($btpick)   ;this screwed with me a lot, and for a LONG while
	GUICtrlDelete($btpick)

	GUICtrlDelete($preview)
	GUICtrlDelete($arrow)
	GUICtrlDelete($colourout)
	GUICtrlDelete($arrow2)
	GUICtrlDelete($hexsym)
	GUICtrlDelete($colourtext)

	GUICtrlDelete($applyGR)
	GUICtrlDelete($colourset_tas)
	GUICtrlDelete($colourset_tastx)
	GUICtrlDelete($colourset_max)
	GUICtrlDelete($colourset_maxtx)
	GUICtrlDelete($colourset_sta)
	GUICtrlDelete($colourset_statx)
	GUICtrlDelete($colourset_cor)
	GUICtrlDelete($colourset_cortx)
	GUICtrlDelete($colourset_tim)
	GUICtrlDelete($colourset_timtx)

	GUICtrlDelete($peekGR)
	GUICtrlDelete($peekdynamic)
	GUICtrlDelete($peekshow)
	GUICtrlDelete($peekhide)
	GUICtrlDelete($peekmain)
	GUICtrlDelete($peekmainyes)
	GUICtrlDelete($peekmainno)


	GUICtrlDelete($extrasGR)
	GUICtrlDelete($sleeptime)
	GUICtrlDelete($sleeptime_tx)
	GUICtrlDelete($systemtray)
	GUICtrlDelete($trayyes)
	GUICtrlDelete($trayno)
	GUICtrlDelete($logging)
	GUICtrlDelete($loggingyes)
	GUICtrlDelete($loggingno)

	GUICtrlDelete($finalload)
	GUICtrlDelete($finalpreview)
	GUICtrlDelete($finalsave)
	DrawElements()
	Return
EndFunc   ;==>uirefresh

Func advancehide()

	GUICtrlSetState($AdvanceCtrl, $GUI_UNCHECKED)
	GUICtrlSetState($StandardCtrl, $GUI_CHECKED)
	GUICtrlSetState($maximisedGR, $GUI_HIDE)
	GUICtrlSetState($check2, $GUI_HIDE)
	GUICtrlSetState($Radio2_1, $GUI_HIDE)
	GUICtrlSetState($Radio2_2, $GUI_HIDE)
	GUICtrlSetState($Radio2_3, $GUI_HIDE)
	GUICtrlSetState($Radio2_4, $GUI_HIDE)
	GUICtrlSetState($Radio2_5, $GUI_HIDE)
	GUICtrlSetState($InputBox_2, $GUI_HIDE)
	GUICtrlSetState($Slider_2, $GUI_HIDE)
	GUICtrlSetState($startGR, $GUI_HIDE)
	GUICtrlSetState($check3, $GUI_HIDE)
	GUICtrlSetState($Radio3_1, $GUI_HIDE)
	GUICtrlSetState($Radio3_2, $GUI_HIDE)
	GUICtrlSetState($Radio3_3, $GUI_HIDE)
	GUICtrlSetState($Radio3_4, $GUI_HIDE)
	GUICtrlSetState($Radio3_5, $GUI_HIDE)
	GUICtrlSetState($InputBox_3, $GUI_HIDE)
	GUICtrlSetState($Slider_3, $GUI_HIDE)
	GUICtrlSetState($cortanaGR, $GUI_HIDE)
	GUICtrlSetState($check4, $GUI_HIDE)
	GUICtrlSetState($Radio4_1, $GUI_HIDE)
	GUICtrlSetState($Radio4_2, $GUI_HIDE)
	GUICtrlSetState($Radio4_3, $GUI_HIDE)
	GUICtrlSetState($Radio4_4, $GUI_HIDE)
	GUICtrlSetState($Radio4_5, $GUI_HIDE)
	GUICtrlSetState($InputBox_4, $GUI_HIDE)
	GUICtrlSetState($Slider_4, $GUI_HIDE)
	GUICtrlSetState($timelineGR, $GUI_HIDE)
	GUICtrlSetState($check5, $GUI_HIDE)
	GUICtrlSetState($Radio5_1, $GUI_HIDE)
	GUICtrlSetState($Radio5_2, $GUI_HIDE)
	GUICtrlSetState($Radio5_3, $GUI_HIDE)
	GUICtrlSetState($Radio5_4, $GUI_HIDE)
	GUICtrlSetState($Radio5_5, $GUI_HIDE)
	GUICtrlSetState($InputBox_5, $GUI_HIDE)
	GUICtrlSetState($Slider_5, $GUI_HIDE)
	GUICtrlSetState($colourset_max, $GUI_HIDE)
	GUICtrlSetState($colourset_maxtx, $GUI_HIDE)
	GUICtrlSetState($colourset_sta, $GUI_HIDE)
	GUICtrlSetState($colourset_statx, $GUI_HIDE)
	GUICtrlSetState($colourset_cor, $GUI_HIDE)
	GUICtrlSetState($colourset_cortx, $GUI_HIDE)
	GUICtrlSetState($colourset_tim, $GUI_HIDE)
	GUICtrlSetState($colourset_timtx, $GUI_HIDE)
	GUICtrlSetState($peekmain, $GUI_HIDE)
	GUICtrlSetState($peekmainyes, $GUI_HIDE)
	GUICtrlSetState($peekmainno, $GUI_HIDE)
	GUICtrlSetState($extrasGR, $GUI_HIDE)
	GUICtrlSetState($sleeptime, $GUI_HIDE)
	GUICtrlSetState($sleeptime_tx, $GUI_HIDE)
	GUICtrlSetState($systemtray, $GUI_HIDE)
	GUICtrlSetState($trayyes, $GUI_HIDE)
	GUICtrlSetState($trayno, $GUI_HIDE)
	GUICtrlSetState($logging, $GUI_HIDE)
	GUICtrlSetState($loggingyes, $GUI_HIDE)
	GUICtrlSetState($loggingno, $GUI_HIDE)
	Return
EndFunc   ;==>advancehide



Func advanceshow()
	GUICtrlSetState($StandardCtrl, $GUI_UNCHECKED)
	GUICtrlSetState($AdvanceCtrl, $GUI_CHECKED)
	GUICtrlSetState($maximisedGR, $GUI_SHOW)
	GUICtrlSetState($check2, $GUI_SHOW)
	GUICtrlSetState($Radio2_1, $GUI_SHOW)
	GUICtrlSetState($Radio2_2, $GUI_SHOW)
	GUICtrlSetState($Radio2_3, $GUI_SHOW)
	GUICtrlSetState($Radio2_4, $GUI_SHOW)
	GUICtrlSetState($Radio2_5, $GUI_SHOW)
	GUICtrlSetState($InputBox_2, $GUI_SHOW)
	GUICtrlSetState($Slider_2, $GUI_SHOW)
	GUICtrlSetState($startGR, $GUI_SHOW)
	GUICtrlSetState($check3, $GUI_SHOW)
	GUICtrlSetState($Radio3_1, $GUI_SHOW)
	GUICtrlSetState($Radio3_2, $GUI_SHOW)
	GUICtrlSetState($Radio3_3, $GUI_SHOW)
	GUICtrlSetState($Radio3_4, $GUI_SHOW)
	GUICtrlSetState($Radio3_5, $GUI_SHOW)
	GUICtrlSetState($InputBox_3, $GUI_SHOW)
	GUICtrlSetState($Slider_3, $GUI_SHOW)
	GUICtrlSetState($cortanaGR, $GUI_SHOW)
	GUICtrlSetState($check4, $GUI_SHOW)
	GUICtrlSetState($Radio4_1, $GUI_SHOW)
	GUICtrlSetState($Radio4_2, $GUI_SHOW)
	GUICtrlSetState($Radio4_3, $GUI_SHOW)
	GUICtrlSetState($Radio4_4, $GUI_SHOW)
	GUICtrlSetState($Radio4_5, $GUI_SHOW)
	GUICtrlSetState($InputBox_4, $GUI_SHOW)
	GUICtrlSetState($Slider_4, $GUI_SHOW)
	GUICtrlSetState($timelineGR, $GUI_SHOW)
	GUICtrlSetState($check5, $GUI_SHOW)
	GUICtrlSetState($Radio5_1, $GUI_SHOW)
	GUICtrlSetState($Radio5_2, $GUI_SHOW)
	GUICtrlSetState($Radio5_3, $GUI_SHOW)
	GUICtrlSetState($Radio5_4, $GUI_SHOW)
	GUICtrlSetState($Radio5_5, $GUI_SHOW)
	GUICtrlSetState($InputBox_5, $GUI_SHOW)
	GUICtrlSetState($Slider_5, $GUI_SHOW)
	GUICtrlSetState($colourset_max, $GUI_SHOW)
	GUICtrlSetState($colourset_maxtx, $GUI_SHOW)
	GUICtrlSetState($colourset_sta, $GUI_SHOW)
	GUICtrlSetState($colourset_statx, $GUI_SHOW)
	GUICtrlSetState($colourset_cor, $GUI_SHOW)
	GUICtrlSetState($colourset_cortx, $GUI_SHOW)
	GUICtrlSetState($colourset_tim, $GUI_SHOW)
	GUICtrlSetState($colourset_timtx, $GUI_SHOW)
	GUICtrlSetState($peekmain, $GUI_SHOW)
	GUICtrlSetState($peekmainyes, $GUI_SHOW)
	GUICtrlSetState($peekmainno, $GUI_SHOW)
	GUICtrlSetState($extrasGR, $GUI_SHOW)
	GUICtrlSetState($sleeptime, $GUI_SHOW)
	GUICtrlSetState($sleeptime_tx, $GUI_SHOW)
	GUICtrlSetState($systemtray, $GUI_SHOW)
	GUICtrlSetState($trayyes, $GUI_SHOW)
	GUICtrlSetState($trayno, $GUI_SHOW)
	GUICtrlSetState($logging, $GUI_SHOW)
	GUICtrlSetState($loggingyes, $GUI_SHOW)
	GUICtrlSetState($loggingno, $GUI_SHOW)
	Return
EndFunc   ;==>advanceshow



