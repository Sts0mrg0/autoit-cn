#include <GDIPlus.au3>
#include <ScreenCapture.au3>

_Main()

Func _Main()
	Local $hImage, $sCLSID, $tData, $tParams

	; ��Ļ����
	_ScreenCapture_Capture(@MyDocumentsDir & "\GDIPlus_Image.jpg")

	; ��ʼ�� GDI+ ��
	_GDIPlus_Startup()

	; ����ͼ��
	$hImage = _GDIPlus_ImageLoadFromFile(@MyDocumentsDir & "\GDIPlus_Image.jpg")

	; ��ȡ JPEG �������� CLSID
	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")

	; ������ʾ��ת 90 �ȵĲ���
	$tData = DllStructCreate("int Data")
	DllStructSetData($tData, "Data", $GDIP_EVTTRANSFORMROTATE90)
	$tParams = _GDIPlus_ParamInit(1)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGTRANSFORMATION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Data"))

	; ������ת���ͼ��
	_GDIPlus_ImageSaveToFileEx($hImage, @MyDocumentsDir & "\GDIPlus_Image2.jpg", $sCLSID, DllStructGetPtr($tParams))

	; �ر� GDI+ ��
	_GDIPlus_Shutdown()

EndFunc   ;==>_Main