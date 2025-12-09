;[UPDATE SPOKYZ GLOW WALLHACK]

buildscr = 4 ;версия для сравнения, если меньше чем в verlen.ini - обновляем
downlurl := "https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/updt.exe"
downllen := "https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/verlen.ini"

Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd = 
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
	{
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {	
		
			IfnotExist, %A_ScriptDir%\Private Wallhack ;Если такой папки нет, то...
        {
			FileCreateDir, %A_ScriptDir%\Private Wallhack ;Он создает эту папку
        }
            IfnotExist, %A_ScriptDir%\Private Wallhack\Glow Update.exe ;Если такого файла нет, то...
        {
            URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/updt.exe, %A_ScriptDir%\Private Wallhack\Glow Update.exe ;Он этот файл скачивает
            URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/imgui.dll, %A_ScriptDir%\Private Wallhack\imgui.dll ;Он этот файл скачивает
            URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/imgui.ini, %A_ScriptDir%\Private Wallhack\imgui.ini ;Он этот файл скачивает
			URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/UPDATE.exe, %A_ScriptDir%\Private Wallhack\UPDATE.exe ;Он этот файл скачивает
        }
			Filedelete, %A_ScriptDir%\Private Wallhack\Glow Update.exe ;Команда для удаления вашего скрипта для скачивания новой версии
			Filedelete, %A_ScriptDir%\Private Wallhack\UPDATE.exe ;Команда для удаления вашего скрипта для скачивания новой версии
            IfnotExist, %A_ScriptDir%\Private Wallhack\Glow Update.exe ;Если такого файла нет, то...
			IfnotExist, %A_ScriptDir%\Private Wallhack\UPDATE.exe ;Если такого файла нет, то...

            URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/GlowUpdate.exe ,%A_ScriptDir%\Private Wallhack\Glow Update.exe ;Он скачивает ваш скрипт по ссылке
			URLDownloadToFile, https://gitlab.com/gokuskywhite1/AutoUpdateGlow/-/raw/main/UPDATE.exe ,%A_ScriptDir%\Private Wallhack\UPDATE.exe ;Он скачивает ваш скрипт по ссылке
			MsgBox, , Автообновление, Обновление Успешно :) 
			put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/Glow Update.exe
            sleep, 1000        
		}
    }
}
SplashTextoff
ExitApp