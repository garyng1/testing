#SingleInstance force
;Delay time for hiding the notification windows
_DelayTime = 1000

;Opacity for the notification window
_NotiOpacity = 200
;Top coordinate of the notification windows
_NotiTop = 20

;Receive the left mouse up message
WM_LBUTTONUP = 0x0202	

;List of webhotkeys seperated by ,
_strWebHotKeys := ""
_strWebHotKeysArray := ""

readSettings()
getDomainURL(asd)

^!+n::
{
	getUserInput(UserInput)

	if UserInput = google
		;Run www.google.com
		showNotification("Launching www.google.com with default browser")
		Sleep, %_DelayTime%
		showNotification(,False)
	Return
}

showNotification(strNoti = "", isShow = True, fontSize = 24)
{
	global _NotiOpacity
	global _NotiTop
	global NotiBack
	global NotiFore
	global WM_LBUTTONUP

	if (isShow = True)
	{
		Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
		Gui, Color, 303030
		Gui, Font, cWhite
		Gui, Font, S%fontSize%, Segoe UI
		Gui, Add, Text, ,%strNoti% 
		WinSet, Transparent , %_NotiOpacity%
		Gui, Show, y%_NotiTop%
		OnMessage(WM_LBUTTONUP, "MouseUp")
	}
	else 
	{
		fadeWinCount := _NotiOpacity
		While, fadeWinCount>0
		{
			fadeWinCount-=5
			WinSet,Transparent, %fadeWinCount%
			Sleep, 10
		}
		Gui, Destroy
	}
}

MouseUp()
{
	;Exit the notification window
	;without fading
	Gui, Destroy
}

getUserInput(ByRef outputVar)
{
	showNotification("Enter input mode",,12)
	Input, outputVar,, {enter},
	Gui, Destroy
	return %outputVar%
}

readSettings()
{
	global ;assume global
	IniRead, _strWebHotKeys, settings.ini, HotKeyWeb, Domain

	;Split string
	StringSplit, _strWebHotKeysArray, _strWebHotKeys, `,
	MsgBox, %_strWebHotKeysArray0%
}

getDomainURL(domain)
{
	global _strWebHotKeysArray
	MsgBox, % _strWebHotKeysArray0
}