;Delay time for hiding the notification windows
DelayTime = 1000	

;Opacity for the notification window
NotiOpacity = 200
;Top coordinate of the notification windows
NotiTop = 20

;Receive the left mouse up message
WM_LBUTTONUP = 0x0202	

^!+n::
{
	getUserInput(UserInput)
	if UserInput = google
		;Run www.google.com
		showNotification("Launching www.google.com with default browser")
		Sleep, %DelayTime%
		showNotification(,False)
	Return
}

showNotification(strNoti = "", isShow = True)
{
	global NotiOpacity
	global NotiTop
	global NotiBack
	global NotiFore
	global WM_LBUTTONUP

	if (isShow = True)
	{
		Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
		Gui, Color, 303030
		Gui, Font, cWhite
		Gui, Font, S24, Segoe UI
		Gui, Add, Text, ,%strNoti% 
		WinSet, Transparent , %NotiOpacity%
		Gui, Show, y%NotiTop%
		OnMessage(WM_LBUTTONUP, "MouseUp")
	}
	else 
	{
		fadeWinCount := NotiOpacity
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
	Input, outputVar,, {enter},
	return %outputVar%
}