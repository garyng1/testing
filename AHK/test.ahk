#SingleInstance force
;Delay time for hiding the notification windows
_DelayTime = 1000

;Opacity for the notification window
_NotiOpacity = 200
;Top coordinate of the notification windows
_NotiTop = 20

;INI settings
_iniFilename := "settings.ini"

;INI settings - web
_webHotKeyPrefix := "web_"
_webModeHotKeySection := _webHotKeyPrefix . "mode"
_webHotKeySection := _webHotKeyPrefix . "hotkey"
	;Array of webhotkeys
	;[hotkeys][URL][name]
_arrayWebKeys := {}
	;List of webhotkeys seperated by ,
_strWebHotKeys := ""


;INI settings - app
_appHotKeyPrefix := "app_"
_appModeHotKeySection := _appHotKeyPrefix . "mode"
_appHotKeySection := _appHotKeyPrefix . "hotkey"
_arrayAppPath := {}
_strAppHotKeys := ""

;Modes keyword
_arrayModeKeyword := {}
_strAvailableModes := ""
;Control ID for the Notification
_NotificationID := ""

loadSettings()



;Ctrl + Alt + Shift + N => Open New
^!+n::
{

	getUserInput(UserInput,"[ Mode Selection ]" . _strAvailableModes)
	userMode := _arrayModeKeyword[UserInput]
	if (userMode == "web_mode")
	{
		getUserInput(UserInput, "[ web_mode ]`n" . _strWebHotKeys)
		webURL := _arrayWebKeys[UserInput]
		if (webURL != "")
		{
			Run %webURL%
			showNotification("Launching " . webURL . "with default browser")
			Sleep, %_DelayTime%
			showNotification(,False)
		}
	}
	else if (userMode == "app_mode")
	{
		getUserInput(UserInput, "[ app_mode ]`n" . _strAppHotKeys)
		path := _arrayAppPath[UserInput]
		if (path != "")
		{
			Run %path%
			showNotification("Launching " . )
		}
	}

	; webURL := getWebURL(UserInput)
	; if (webURL != "")
	; {
	; 	Run %webURL%
	; 	showNotification("Launching " . webURL . " with default browser")
	; 	Sleep, %_DelayTime%
	; 	showNotification(,False)
	; }
	Return
}

showNotification(strNoti = "", isShow = True, fontSize = 24)
{
	global _NotiOpacity
	global _NotiTop
	global NotiBack
	global NotiFore

	if (isShow = True)
	{
		Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
		Gui, Color, 303030
		Gui, Font, cWhite
		Gui, Font, S%fontSize%, Segoe UI
		Gui, Add, Text, v_NotificationID +Center,%strNoti% 
		WinSet, Transparent , %_NotiOpacity%
		Gui, Show, y%_NotiTop%`
	}
	else 
	{
		fadeWinCount := _NotiOpacity
		While, fadeWinCount>0
		{
			Gui, +LastFound
			fadeWinCount-=5
			WinSet,Transparent, %fadeWinCount%
			Sleep, 10
		}
		Gui, Destroy
	}
}

getUserInput(ByRef outputVar, notiString)
{
	showNotification(notiString,,10)
	Input, outputVar,, {enter}{escape},
	Gui, Destroy
	return %outputVar%
}

loadSettings()
{

	global _iniFilename

	loadWebHotKeys(_iniFilename)
	loadAppHotKeys(_iniFilename)
	loadModeKeyWord(_iniFilename)
}

loadAppHotKeys(filename)
{
	global _strAppHotKeys
	global _appHotKeyPrefix
	global _appHotKeySection
	global _arrayAppPath := {}

	IniRead, _strAppHotKeys, %filename%, %_appHotKeySection%, Keyword
	splitHotKeys(_arrayAppPath, _strAppHotKeys, _appHotKeyPrefix, filename, "Path")

	_strAppHotKeys := ""
	combineKeywordArray(_strAppHotKeys,_arrayAppPath)
}

loadWebHotKeys(filename)
{
	global _strWebHotKeys
	global _webHotKeyPrefix
	global _webHotKeySection
	global _arrayWebKeys := {}

	IniRead, _strWebHotKeys, %filename%, %_webHotKeySection%, Keyword
	splitHotKeys(_arrayWebKeys, _strWebHotKeys, _webHotKeyPrefix, filename, "Link")

	_strWebHotKeys := ""
	combineKeywordArray(_strWebHotKeys,_arrayWebKeys)
}

combineKeywordArray(ByRef string, array)
{
	i := 0
	arrCount := arrayCount(array)
	For keys, value in array
	{
		if (i > 0 && Mod(i,3) = 0)
		{
			string.= "`n"
		}
		string.= keys
		if (Mod(i,3) != 2 && i != arrCount-1)
		{
			 string.= " , "
		}
		i++
	}
}

arrayCount(array)
{
	arrCount := 0
	For keys, value in array
	{
		arrCount++
	}
	return arrCount
}

loadModeKeyWord(filename)
{
	global _webModeHotKeySection
	global _appModeHotKeySection
	global _arrayModeKeyword
	global _strAvailableModes

	IniRead, modeList, %filename%, mode, List
	StringSplit, modeTmp, modeList, `,
	Loop, %modeTmp0%
	{
		str:= modeTmp%A_Index%
		IniRead, key, %filename%, %str%, Keyword
		if (key != "ERROR")
		{
			_arrayModeKeyword[key] := str
			_strAvailableModes .= "`n" . key . " : " . str
		}
	}
}

splitHotKeys(ByRef outputArray, inputString, prefix, iniFilename, keyName)
{
	StringSplit, tmp, inputString, `,
	Loop, %tmp0%
	{
		str:= tmp%A_Index%
		strPrefix := prefix . str
		IniRead, key, %iniFilename%, %strPrefix%, %keyName%
		if (key != "ERROR")
		{
			outputArray[str] := key
		}

	}
}