#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Cosmic-Infinity

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <StaticConstants.au3>
#include <GuiToolTip.au3>
#include <ScreenCapture.au3> ;Screenshot Library
#include <GDIPlus.au3> ; ImageProcessing Library
#include <File.au3> ; temporary file name generation library
#include <Misc.au3> ; mouse click detection

   #include <GuiEdit.au3>




#AutoIt3Wrapper_Icon="C:\Users\Shubham\Desktop\Software Projects\Colours\Icons\Colours Icon new 85.ico"

;!Highly recommended for improved overall performance and responsiveness of the GUI effects etc.! (after compiling):
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe

;Required if you want High DPI scaling enabled. (Also requries _Metro_EnableHighDPIScaling())
#AutoIt3Wrapper_Res_HiDpi=y
#include-once


;Control temporary state /  reading file state on launch
Global $stateSD[5] ;stores slider values. index corresponds to slider Number
Global $stateCB[6] ;stores checkbox selected. 1-4 are checkbox 2-5, 5-6 are advance & standard sliders





;Global $iScale = RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI") / 96
Global $old_value = 10
Global $resize = False
DrawWin()
DrawElements()
main()



Func DrawWin()
	If @OSVersion = 'WIN_10' Then DllCall("User32.dll", "bool", "SetProcessDpiAwarenessContext", "HWND", "DPI_AWARENESS_CONTEXT" - 2)

	Global $gui = GUICreate("Colours GUI", @DesktopWidth / 1.28, @DesktopHeight / 1.2857, -1, -1, BitOR($WS_SYSMENU, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	;1500, 840
	GUISetIcon("C:\Users\Shubham\Desktop\Software Projects\Colours\Icons\Colours Icon new 85.ico")
	;_GUIScrollbars_Generate($gui, 2000, 1000)
	;_GUIScrollBars_Init ( $gui)

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






	;----------------------------------TASKBAR--------------------------------------------------
	Global $taskbarGR = GUICtrlCreateGroup("Desktop / Global Taskbar", $leftLB, $topLB, $lengthtLB, $heightLB)
	GUICtrlSetFont($taskbarGR, ($topLB / 2), 600, 0, "Segoe UI", 5)
	;font weight, font attribute, font name, quality


	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.


	;Global $check1 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB) + $heightLB / 2)
	;GUICtrlSetState($check1, $GUI_CHECKED)
	GUIStartGroup()
	Global $Radio1_1 = GUICtrlCreateRadio("Clear", ($leftLB * 2.3), ($heightLB) - ($heightLB * 0.46), $lengthtLB / 6.3)
	GUICtrlSetFont($Radio1_1, $leftLB/5, $FW_EXTRALIGHT, 0, "Calibri", $CLEARTYPE_QUALITY)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio1_2 = GUICtrlCreateRadio("Fluent", (($leftLB * 2.3) * 2), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_2, $leftLB/5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio1_3 = GUICtrlCreateRadio("Opaque", (($leftLB * 2.3) * 3), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_3, $leftLB/5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio1_4 = GUICtrlCreateRadio("Normal", (($leftLB * 2.3) * 4), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_4, $leftLB/5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio1_5 = GUICtrlCreateRadio("Blur", (($leftLB * 2.3) * 5), ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont($Radio1_5, $leftLB/5, 200, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")
	GUICtrlSetState($Radio1_1, $GUI_CHECKED)

	Global $Slider_1 = GUICtrlCreateSlider(($leftLB * 1.5), ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 1
	GUICtrlSetLimit($Slider_1, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_1, $old_value) ; set cursor

	Global $InputBox_1 = GUICtrlCreateInput($old_value, ($lengthtLB * 0.99), ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ; ;textbox 1
	GUICtrlSetLimit(-1, 3) ;-1 means last created control








	;--------------------Dynamic Windows. State to use when a window is maximised.--------------------------------------------------
	Global $maximisedGR = GUICtrlCreateGroup("Window Maximised", $leftLB, $topLB * 2 + $heightLB, $lengthtLB, $heightLB)
	GUICtrlSetFont($maximisedGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check2 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 2) + $heightLB * (3 / 2))
	GUICtrlSetState($check2, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio2_1 = GUICtrlCreateRadio("Clear", (($lengthtLB / 6) * 1), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio2_2 = GUICtrlCreateRadio("Fluent", (($lengthtLB / 6) * 2), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio2_3 = GUICtrlCreateRadio("Opaque", (($lengthtLB / 6) * 3), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio2_4 = GUICtrlCreateRadio("Normal", (($lengthtLB / 6) * 4), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio2_5 = GUICtrlCreateRadio("Blur", (($lengthtLB / 6) * 5), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")
	GUICtrlSetState($Radio2_2, $GUI_CHECKED)

	;slider 2
	Global $Slider_2 = GUICtrlCreateSlider($lengthtLB / 9, $heightLB + $topLB + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1)
	GUICtrlSetLimit($Slider_2, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_2, $old_value) ; set cursor
	;textbox 2
	Global $InputBox_2 = GUICtrlCreateInput($old_value, ($lengthtLB * 0.99), $topLB + $heightLB + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ; create input box
	GUICtrlSetLimit(-1, 3)







	;------------------Dynamic Start. State to use when the start menu is opened.-------------------------------------------------------------------
	Global $startGR = GUICtrlCreateGroup("Start Menu Open", $leftLB, ($topLB * 3) + ($heightLB * 2), $lengthtLB, $heightLB)
	GUICtrlSetFont($startGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check3 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 3) + $heightLB * (5 / 2))
	GUICtrlSetState($check3, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio3_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio3_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio3_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio3_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio3_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")
	GUICtrlSetState($Radio3_3, $GUI_CHECKED)


	Global $Slider_3 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 3
	GUICtrlSetLimit($Slider_3, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_3, $old_value) ; set cursor

	Global $InputBox_3 = GUICtrlCreateInput($old_value, ($lengthtLB * 0.99), ($topLB * 2) + ($heightLB * 2) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 3
	GUICtrlSetLimit(-1, 3)





	;-------------------Dynamic Cortana. State to use when Cortana or the search menu is opened.----------------------------------------------------------------------
	Global $cortanaGR = GUICtrlCreateGroup("Cortana Open", $leftLB, ($topLB * 4) + ($heightLB * 3), $lengthtLB, $heightLB)
	GUICtrlSetFont($cortanaGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check4 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 4) + $heightLB * (7 / 2))
	GUICtrlSetState($check4, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio4_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio4_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio4_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio4_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio4_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")
	GUICtrlSetState($Radio4_4, $GUI_CHECKED)


	Global $Slider_4 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 4
	GUICtrlSetLimit($Slider_4, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_4, $old_value) ; set cursor

	Global $InputBox_4 = GUICtrlCreateInput($old_value, ($lengthtLB * 0.99), ($topLB * 3) + ($heightLB * 3) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 4
	GUICtrlSetLimit(-1, 3)







	;------------------Dynamic Timeline. State to use when the timeline (or task view on older builds) is opened.---------------------------------------------------------------------------------------
	Global $timelineGR = GUICtrlCreateGroup("Timeline Open", $leftLB, ($topLB * 5) + ($heightLB * 4), $lengthtLB, $heightLB)
	GUICtrlSetFont($timelineGR, ($topLB / 2.1), 600, 0, "Segoe UI", 5)
	;clear (default), fluent (only on build 17063 and up), opaque, normal, or blur.

	Global $check5 = GUICtrlCreateCheckbox(" ", $leftLB * (2 / 5), ($topLB * 5) + $heightLB * (9 / 2))
	GUICtrlSetState($check5, $GUI_CHECKED)

	GUIStartGroup()
	Global $Radio5_1 = GUICtrlCreateRadio("Clear", ($lengthtLB / 6) * 1, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No Blur." & @CRLF & "Transparent taskbar.")
	Global $Radio5_2 = GUICtrlCreateRadio("Fluent", ($lengthtLB / 6) * 2, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Windows 10 April 2018 update (build 17063) and up only." & @CRLF & "Will give the taskbar an appearance similar to Microsoft's Fluent Design guidelines." & @CRLF & "Windows disables this blur in a low power state / when on battery")
	Global $Radio5_3 = GUICtrlCreateRadio("Opaque", ($lengthtLB / 6) * 3, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "No transparency/translucency.")
	Global $Radio5_4 = GUICtrlCreateRadio("Normal", ($lengthtLB / 6) * 4, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6.3))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Regular Windows style." & @CRLF & "(as if TranslucentTB was not running)")
	Global $Radio5_5 = GUICtrlCreateRadio("Blur", ($lengthtLB / 6) * 5, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.46), ($lengthtLB / 6))
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Will make the taskbar slightly blurred.")
	GUICtrlSetState($Radio5_5, $GUI_CHECKED)


	Global $Slider_5 = GUICtrlCreateSlider($lengthtLB / 9, ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.2), ($lengthtLB * (5.15 / 6)), $heightLB / 3.3 < 45 ? $heightLB / 3.3 : 45, -1) ;slider 5
	GUICtrlSetLimit($Slider_5, 255, 0) ; change min/max value,
	GUICtrlSetTip(-1, "Set transparency level" & @CRLF & "0 = Completely Transparent" & @CRLF & "255 = Completely Opaque")
	GUICtrlSetData($Slider_5, $old_value) ; set cursor

	Global $InputBox_5 = GUICtrlCreateInput($old_value, ($lengthtLB * 0.99), ($topLB * 4) + ($heightLB * 4) + ($heightLB) - ($heightLB * 0.17), @DesktopWidth / 51, $heightLB / 4.5 < 31 ? $heightLB / 4.5 : 30, $ES_NUMBER) ;textbox 5
	GUICtrlSetLimit(-1, 3)



	;---------------------------------------------------Advance / Simple -------------------------------------------------------

	Global $separate = GUICtrlCreateGraphic($size[2] / 1.9, $topLB, 1, $heightLB * 5.9, $SS_BLACKRECT)
	Global $separate2 = GUICtrlCreateGraphic($size[2] / 1.9, $topLB * 4, $size[2] / 2.3, 1, $SS_BLACKRECT)


	Global $StandardCtrl = GUICtrlCreateCheckbox("Standard Mode", $size[2] / 1.7, $topLB * 1.5, $size[2] / 8)
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Everything you need to get that Translucent Taskabar", "Standard Controls", 1, BitOR(1, 2))
	Global $AdvanceCtrl = GUICtrlCreateCheckbox("Advance Mode", $size[2] / 1.25, $topLB * 1.5, $size[2] / 8)
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Extra Customisation." & @CRLF & "Includes Dynamic Controls", "Advance Controls", 1, BitOR(1, 2))

	;BitOR($SS_CENTER, $SS_CENTERIMAGE)





   ;----------------------------------------------------colour palette------------------------------------------------------------



	Global $paletteGR = GUICtrlCreateGroup("Colour Selection", $size[2] / 1.81, $topLB * 5, $size[2] / 2.5, $heightLB*1.5)
	GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)


	Global $btauto = GUICtrlCreateButton("Autodetect", $size[2] / 1.72, $topLB * 7, $leftLB * 3)
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Autodetect currently selected colour in Windows Settings." & @CRLF & "DO NOT move the mouse for a few seconds after clicking this." , "Aotodetect", 1, BitOR(1, 2)) ;& @CRLF & "ALLOW SOME SECONDS to open setting and detect current colour"
	Global $bteye = GUICtrlCreateButton("EyeDropper", $size[2] / 1.42, $topLB * 7, $leftLB * 3)
	GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
	GUICtrlSetTip(-1, "Turns the mouse into an Eyedropper" & @CRLF & "allowing selection of any colour from UI.", "Eyedropper", 1, BitOR(1, 2)) ;@CRLF & "Samples 2 pixels diagonally above the mouse pointer."

   Global $btpick = GUICtrlCreateButton("Colour Picker", $size[2] / 1.21, $topLB * 7, $leftLB * 3)
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2)
   GUICtrlSetTip(-1, "Choose from a colour palette" , "Colour Picker", 1, BitOR(1, 2))

	Global $preview = GUICtrlCreatePic("C:\Users\Shubham\AppData\Local\Temp\colour_Sample_vsm.jpg", $size[2] / 1.62, $topLB * 9.5, $leftLB, $topLB*2)
   GUICtrlSetTip(-1, "Preview of selected area for colour extraction" , "Sample Viewer", 0, BitOR(1, 1))

   Global $arrow = GUICtrlCreateLabel(ChrW(0x27A2), $size[2] / 1.485,$topLB * 9.5,0,0)
   GUICtrlSetFont(-1, $leftLB*(2/5))

   Global $colourout = GUICtrlCreateGraphic($size[2] / 1.4, $topLB * 9.5, $leftLB, $topLB*2)
   GUICtrlSetGraphic(-1, $GUI_GR_RECT)
   GUICtrlSetColor (-1 , 0x000F0F )


   Global $arrow2 = GUICtrlCreateLabel(ChrW(0x27A3), $size[2] / 1.298,$topLB * 9.5,0,0)
   GUICtrlSetFont(-1, $leftLB*(2/5))

   Global $hexsym = GUICtrlCreateLabel("0x", $size[2] / 1.23, $topLB * 9.9)
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   Global $colourtext = GUICtrlCreateInput("", $size[2] / 1.2, $topLB * 9.8, $leftLB*2, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "HEX value of the colour." , "Colour Hex Viewer", 0, BitOR(1, 1))


   ;----------------------------------------------------apply colour to---------------------------------------------------------------













   Global $applyGR = GUICtrlCreateGroup("Apply Colour", $size[2] / 1.81, $topLB * 13, $size[2] / 2.5, $heightLB*1.6)
   GUICtrlSetFont(-1, ($topLB / 2.1), 500, 0, "Segoe UI", 5)



	Global $colourset_tas = GUICtrlCreateLabel("Desktop :", $size[2] / 1.7,$topLB * 14.8,$leftLB*2.0,$topLB*1.45 )
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Times New Roman", 2 )
   Global $colourset_tastx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 14.7 , $leftLB*2.0, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   _GUICtrlEdit_SetCueBanner(-1, "0x")
   GUICtrlSetFont(-1, $leftLB/5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "Colour for taskbar on Desktop.")


   	Global $colourset_max = GUICtrlCreateLabel("Maximised :", $size[2] / 1.3,$topLB * 14.8,$leftLB*2.2,$topLB*1.45 )
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2 )
	Global $colourset_maxtx = GUICtrlCreateInput("", $size[2] / 1.184, $topLB * 14.7 , $leftLB*2.0, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   _GUICtrlEdit_SetCueBanner(-1, "0x")
   GUICtrlSetFont(-1, $leftLB/5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "Colour for taskbar during fullscreen.")

   	Global $colourset_sta = GUICtrlCreateLabel("Start      :", $size[2] / 1.7,$topLB * 16.8,$leftLB*2.0,$topLB*1.45 )
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2 )
	Global $colourset_statx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 16.7 , $leftLB*2.0, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   _GUICtrlEdit_SetCueBanner(-1, "0x")
   GUICtrlSetFont(-1, $leftLB/5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "Colour for taskbar during Start")


   	Global $colourset_cor = GUICtrlCreateLabel("Cortana    :", $size[2] / 1.3,$topLB * 16.8,$leftLB*2.0,$topLB*1.45 )
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2 )
	Global $colourset_cortx = GUICtrlCreateInput("", $size[2] / 1.184, $topLB * 16.7 , $leftLB*2.0, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   _GUICtrlEdit_SetCueBanner(-1, "0x")
   GUICtrlSetFont(-1, $leftLB/5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "Colour for taskbar during Cortana.")

   	Global $colourset_tim = GUICtrlCreateLabel("Timeline :", $size[2] / 1.7,$topLB * 18.8,$leftLB*2.0,$topLB*1.45 )
   GUICtrlSetFont(-1, $leftLB/5, $FW_EXTRALIGHT, 0, "Candara", 2 )
	Global $colourset_timtx = GUICtrlCreateInput("", $size[2] / 1.54, $topLB * 18.7 , $leftLB*2.0, $topLB*1.45 )
   GUICtrlSetLimit(-1, 6)
   _GUICtrlEdit_SetCueBanner(-1, "0x")
   GUICtrlSetFont(-1, $leftLB/5.5, $FW_EXTRALIGHT, 0, "Segoe UI", 2)
   GUICtrlSetTip(-1, "Colour for taskbar wne Timeline open.")















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
			Sleep(1000)
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

				Case $Radio1_3
					GUICtrlSetState($Slider_1, $GUI_DISABLE)
					GUICtrlSetState($InputBox_1, $GUI_DISABLE)
				Case $Radio1_1, $Radio1_2, $Radio1_4, $Radio1_5
					GUICtrlSetState($Slider_1, $GUI_ENABLE)
					GUICtrlSetState($InputBox_1, $GUI_ENABLE)
				Case $check2
					If GUICtrlRead($check2) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio2_1, $GUI_DISABLE)
						GUICtrlSetState($Radio2_2, $GUI_DISABLE)
						GUICtrlSetState($Radio2_3, $GUI_DISABLE)
						GUICtrlSetState($Radio2_4, $GUI_DISABLE)
						GUICtrlSetState($Radio2_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_2, $GUI_DISABLE)
						GUICtrlSetState($InputBox_2, $GUI_DISABLE)
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
					EndIf

				Case $Radio2_3
					GUICtrlSetState($Slider_2, $GUI_DISABLE)
					GUICtrlSetState($InputBox_2, $GUI_DISABLE)
				Case $Radio2_1, $Radio2_2, $Radio2_4, $Radio2_5
					GUICtrlSetState($Slider_2, $GUI_ENABLE)
					GUICtrlSetState($InputBox_2, $GUI_ENABLE)
				Case $check3
					If GUICtrlRead($check3) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio3_1, $GUI_DISABLE)
						GUICtrlSetState($Radio3_2, $GUI_DISABLE)
						GUICtrlSetState($Radio3_3, $GUI_DISABLE)
						GUICtrlSetState($Radio3_4, $GUI_DISABLE)
						GUICtrlSetState($Radio3_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_3, $GUI_DISABLE)
						GUICtrlSetState($InputBox_3, $GUI_DISABLE)
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
					EndIf
				Case $Radio3_3
					GUICtrlSetState($Slider_3, $GUI_DISABLE)
					GUICtrlSetState($InputBox_3, $GUI_DISABLE)
				Case $Radio3_1, $Radio3_2, $Radio3_4, $Radio3_5
					GUICtrlSetState($Slider_3, $GUI_ENABLE)
					GUICtrlSetState($InputBox_3, $GUI_ENABLE)
				Case $check4
					If GUICtrlRead($check4) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio4_1, $GUI_DISABLE)
						GUICtrlSetState($Radio4_2, $GUI_DISABLE)
						GUICtrlSetState($Radio4_3, $GUI_DISABLE)
						GUICtrlSetState($Radio4_4, $GUI_DISABLE)
						GUICtrlSetState($Radio4_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_4, $GUI_DISABLE)
						GUICtrlSetState($InputBox_4, $GUI_DISABLE)
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
					EndIf
				Case $Radio4_3
					GUICtrlSetState($Slider_4, $GUI_DISABLE)
					GUICtrlSetState($InputBox_4, $GUI_DISABLE)
				Case $Radio4_1, $Radio4_2, $Radio4_4, $Radio4_5
					GUICtrlSetState($Slider_4, $GUI_ENABLE)
					GUICtrlSetState($InputBox_4, $GUI_ENABLE)
				Case $check5
					If GUICtrlRead($check5) = $GUI_UNCHECKED Then
						GUICtrlSetState($Radio5_1, $GUI_DISABLE)
						GUICtrlSetState($Radio5_2, $GUI_DISABLE)
						GUICtrlSetState($Radio5_3, $GUI_DISABLE)
						GUICtrlSetState($Radio5_4, $GUI_DISABLE)
						GUICtrlSetState($Radio5_5, $GUI_DISABLE)
						GUICtrlSetState($Slider_5, $GUI_DISABLE)
						GUICtrlSetState($InputBox_5, $GUI_DISABLE)
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
					EndIf
				Case $Radio5_3
					GUICtrlSetState($Slider_5, $GUI_DISABLE)
					GUICtrlSetState($InputBox_5, $GUI_DISABLE)
				Case $Radio5_1, $Radio5_2, $Radio5_4, $Radio5_5
					GUICtrlSetState($Slider_5, $GUI_ENABLE)
					GUICtrlSetState($InputBox_5, $GUI_ENABLE)


				Case $StandardCtrl
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
				Case $AdvanceCtrl
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

					;DrawElements()

				Case $btauto

					 Opt("MouseCoordMode", 0)
					Send("#r")
					Sleep(500)
					Send("ms-settings:colors{ENTER}")
					Opt("SendKeyDelay", 1)

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


					;bring settings to focus
					WinActivate("Settings")

					;reach down
					Send("{TAB 9}")

					 ;Setting window to DPI Aware
				    DllCall("User32.dll", "bool", "SetProcessDPIAware")
					;move mouse upto the colour
					MouseMove(560, 865, 0)
					Sleep(200)





					;taking focus away from settings as windows prevents screenshots of settings
					WinActivate("Program Manager")

					Local $sTempFile = _TempFile(@TempDir, "\" & "colour_Sample_", ".jpg", 3)


					;getting mouse position and taking a screenshot
					$pos = MouseGetPos()
					_ScreenCapture_Capture($sTempFile, $pos[0] - 25, $pos[1] - 25, $pos[0] + 25, $pos[1] + 25)
					GUICtrlSetImage($preview, $sTempFile )

					;Getting Colour Value from the screenshot's 10*10 position
					$iPosX = 22
					$iPosY = 22
					_GDIPlus_Startup()
					$hImage = _GDIPlus_ImageLoadFromFile($sTempFile)
					$colour = Hex(_GDIPlus_BitmapGetPixel($hImage, $iPosX, $iPosY), 6)
					 GUICtrlSetBkColor($colourout, "0x"&$colour)
					 GUICtrlSetData($colourtext, $colour)
					;ShellExecute($sTempFile)
					;MsgBox(0, "Pixel Color", $colour)
					_GDIPlus_ImageDispose($hImage)
					_GDIPlus_ShutDown()

					 ProcessClose("SystemSettings.exe")
					 ProcessWaitClose("SystemSettings.exe")


				 Case $bteye

				    Local $sTempFile = _TempFile(@TempDir, "\" & "colour_Sample_", ".jpg", 3)

					GUISetState(@SW_MINIMIZE)

					 while 1
						   If _IsPressed("01") Then
							  ExitLoop
						   EndIf
					 WEnd

					 WinActivate("Program Manager")


					;getting mouse position and taking a screenshot
					$pos = MouseGetPos()
					_ScreenCapture_Capture($sTempFile, $pos[0] - 25, $pos[1] - 25, $pos[0] + 25, $pos[1] + 25)
					Sleep(1000)
					GUISetState(@SW_RESTORE)
					GUICtrlSetImage($preview, $sTempFile )

					;Getting Colour Value from the screenshot's 10*10 position
					$iPosX = 23
					$iPosY = 23
					_GDIPlus_Startup()
					$hImage = _GDIPlus_ImageLoadFromFile($sTempFile)
					$colour = Hex(_GDIPlus_BitmapGetPixel($hImage, $iPosX, $iPosY), 6)
					GUICtrlSetBkColor($colourout, "0x"&$colour)
					GUICtrlSetData($colourtext, $colour)
					;ShellExecute($sTempFile)
					;MsgBox(0, "Pixel Color", $colour)
					_GDIPlus_ImageDispose($hImage)
					_GDIPlus_ShutDown()

			EndSwitch






			Sleep(60)




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
					GUICtrlSetData($InputBox_1, GUICtrlRead($Slider_1))

				ElseIf Not $check_Slide1[0] Then
					GUICtrlSetData($Slider_1, GUICtrlRead($InputBox_1))
				EndIf

			ElseIf $check_Slide2[1] = True Then
				If $check_Slide2[0] Then
					GUICtrlSetData($InputBox_2, GUICtrlRead($Slider_2))

				ElseIf Not $check_Slide2[0] Then
					GUICtrlSetData($Slider_2, GUICtrlRead($InputBox_2))
				EndIf

			ElseIf $check_Slide3[1] = True Then
				If $check_Slide3[0] Then
					GUICtrlSetData($InputBox_3, GUICtrlRead($Slider_3))

				ElseIf Not $check_Slide3[0] Then
					GUICtrlSetData($Slider_3, GUICtrlRead($InputBox_3))
				EndIf

			ElseIf $check_Slide4[1] = True Then
				If $check_Slide4[0] Then
					GUICtrlSetData($InputBox_4, GUICtrlRead($Slider_4))

				ElseIf Not $check_Slide4[0] Then
					GUICtrlSetData($Slider_4, GUICtrlRead($InputBox_4))
				EndIf

			ElseIf $check_Slide5[1] = True Then
				If $check_Slide5[0] Then
					GUICtrlSetData($InputBox_5, GUICtrlRead($Slider_5))

				ElseIf Not $check_Slide5[0] Then
					GUICtrlSetData($Slider_5, GUICtrlRead($InputBox_5))
				EndIf
			EndIf

		EndIf



		If ($n = $GUI_EVENT_RESIZED) Or ($n = $GUI_EVENT_MAXIMIZE) Or ($n = $GUI_EVENT_RESTORE)  Then


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






			DrawElements()
		EndIf



	Until $n = $GUI_EVENT_CLOSE
EndFunc   ;==>main