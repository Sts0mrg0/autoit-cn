#Include <APIConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)

If (_WinAPI_GetVersion() < '6.1') Or (Not _WinAPI_DwmIsCompositionEnabled()) Then
	MsgBox(16, 'Error', 'Require Windows 7 or later with enabled Aero theme.')
	Exit
EndIf

Global $hForm, $hAutoIt

; 加载位图来创建缩略图
$hAutoIt = _WinAPI_LoadImage(0, @ScriptDir & '\Extras\AutoIt.bmp', $IMAGE_BITMAP, 0, 0, BitOR($LR_LOADFROMFILE, $LR_CREATEDIBSECTION))

; 创建 GUI
$hForm = GUICreate('MyGUI', 400, 400)

; 设置 DWM 窗口属性来提供图标的位图, 并总是使用图标的位图转化成缩略图和实时预览
_WinAPI_DwmSetWindowAttribute($hForm, $DWMWA_FORCE_ICONIC_REPRESENTATION, 1)
_WinAPI_DwmSetWindowAttribute($hForm, $DWMWA_HAS_ICONIC_BITMAP, 1)

; 注册 WM_DWMSENDICONICLIVEPREVIEWBITMAP 窗口消息来显示实时预览
GUIRegisterMsg($WM_DWMSENDICONICLIVEPREVIEWBITMAP, 'WM_DWMSENDICONICLIVEPREVIEWBITMAP')

; 注册 WM_DWMSENDICONICTHUMBNAIL 窗口消息来显示缩略图
GUIRegisterMsg($WM_DWMSENDICONICTHUMBNAIL, 'WM_DWMSENDICONICTHUMBNAIL')

GUISetState()

Do
Until GUIGetMsg() = -3

Func _CreateThumbnail($hSource, $iWidth, $iHeight)

	Local $tSIZE, $hSrcDC, $hSrcSv, $hDestDC, $hDestSv, $hBitmap

	$hBitmap = _WinAPI_CreateDIB($iWidth, $iHeight)
	$hDestDC = _WinAPI_CreateCompatibleDC(0)
	$hDestSv = _WinAPI_SelectObject($hDestDC, $hBitmap)
	$tSIZE = _WinAPI_GetBitmapDimension($hSource)
	$hSrcDC = _WinAPI_CreateCompatibleDC(0)
	$hSrcSv = _WinAPI_SelectObject($hSrcDC, $hSource)
	_WinAPI_SetStretchBltMode($hDestDC, $HALFTONE)
	_WinAPI_StretchBlt($hDestDC, 0, 0, $iWidth, $iHeight, $hSrcDC, 0, 0, DllStructGetData($tSIZE, 'X'), DllStructGetData($tSIZE, 'Y'), $SRCCOPY)
	_WinAPI_SelectObject($hDestDC, $hDestSv)
	_WinAPI_DeleteDC($hDestDC)
	_WinAPI_SelectObject($hSrcDC, $hSrcSv)
	_WinAPI_DeleteDC($hSrcDC)
	Return $hBitmap
EndFunc   ;==>_CreateThumbnail

Func WM_DWMSENDICONICLIVEPREVIEWBITMAP($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $hForm

			Local $hBitmap

			$hBitmap = _CreateThumbnail($hAutoIt, 400, 400)
			_WinAPI_DwmSetIconicLivePreviewBitmap($hForm, $hBitmap, 1)
			_WinAPI_DeleteObject($hBitmap)
			Return 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_DWMSENDICONICLIVEPREVIEWBITMAP

Func WM_DWMSENDICONICTHUMBNAIL($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $hForm

			Local $W, $H, $hBitmap

			$W = _WinAPI_HiWord($lParam)
			$H = _WinAPI_LoWord($lParam)
			If $W > $H Then
				$W = $H
			Else
				$H = $W
			EndIf
			$hBitmap = _CreateThumbnail($hAutoIt, $W, $H)
			_WinAPI_DwmSetIconicThumbnail($hForm, $hBitmap, 1)
			_WinAPI_DeleteObject($hBitmap)
			Return 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_DWMSENDICONICTHUMBNAIL
