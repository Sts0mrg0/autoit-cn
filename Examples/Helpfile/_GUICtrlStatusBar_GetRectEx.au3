#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

$Debug_SB = False ; 检查传递给函数的类名, 设置为True并输出到一个控件的句柄,用于检查它是否工作

Global $iMemo

_Main()

Func _Main()

	Local $hGUI, $tRect, $hStatus
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("StatusBar Get RectEx", 400, 300)
	$hStatus = _GUICtrlStatusBar_Create($hGUI)

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; Set/Get parts
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Get part 1 rectangles
	$tRect = _GUICtrlStatusBar_GetRectEx($hStatus, 0)
	MemoWrite("Part 1 left ...: " & DllStructGetData($tRect, "Left"))
	MemoWrite("Part 1 top ....: " & DllStructGetData($tRect, "Top"))
	MemoWrite("Part 1 right ..: " & DllStructGetData($tRect, "Right"))
	MemoWrite("Part 1 bottom .: " & DllStructGetData($tRect, "Bottom"))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

; 写入消息到 memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
