#NoEnv
#Persistent
#MaxThreadsPerHotkey 2
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
CoordMode, Pixel, Screen
SoundBeep, 300, 200
SoundBeep, 400, 200


; ===========================================
; Автообновляющий скрипт с автоматическим показом изменений
; ===========================================


SetWorkingDir %A_ScriptDir%

; -------------------------------
; Настройки
; -------------------------------
CurrentVersion := 4 ; текущая версия скрипта
DownloadFolder := A_ScriptDir "\Release" ; папка для обновлений

; Ссылки на сервер
VersionIniURL := "https://github.com/Gxku999/Ver-1/raw/main/verlen.ini" ; ini с последней версией
UpdateFileURL := "https://github.com/Gxku999/Ver-1/raw/main/Release/updt.ahk" ; основной файл обновления
AdditionalFiles := ["https://github.com/Gxku999/Ver-1/raw/main/Release/Alpha%201.0.ahk"] ; дополнительные файлы

; -------------------------------
; Функция UTF-8 -> ANSI
; -------------------------------
Utf8ToAnsi(ByRef Utf8String, CodePage := 1251) {
    if (NumGet(&Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM := 3
    else
        BOM := 0
    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0, "UInt", &Utf8String + BOM, "Int", -1, "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize*2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0, "UInt", &Utf8String + BOM, "Int", -1, "UInt", &UniBuf, "Int", UniSize)
    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0, "UInt", &UniBuf, "Int", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0, "UInt", &UniBuf, "Int", -1, "Str", AnsiString, "Int", AnsiSize, "Int", 0, "Int", 0)
    return AnsiString
}

; -------------------------------
; Создаём папку для обновлений
; -------------------------------
IfNotExist, %DownloadFolder%
    FileCreateDir, %DownloadFolder%

; -------------------------------
; Скачиваем ini с последней версией
; -------------------------------
TempIni := A_Temp "\verlen.ini"
SplashTextOn,, 60, Автообновление, Проверяем наличие обновлений...
URLDownloadToFile, %VersionIniURL%, %TempIni%
IniRead, RemoteBuild, %TempIni%, UPD, build

if RemoteBuild =
{
    SplashTextOn,, 60, Автообновление, Ошибка соединения с сервером.
    Sleep, 1500
    SplashTextOff
    ExitApp
}

; -------------------------------
; Сравниваем версию и обновляем автоматически
; -------------------------------
if (RemoteBuild > CurrentVersion) {
    IniRead, vupd, %TempIni%, UPD, v
    IniRead, desupd, %TempIni%, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %TempIni%, UPD, upd
    updupd := Utf8ToAnsi(updupd)

    SplashTextOn,, 60, Автообновление, Найдена новая версия %vupd%`nОбновление...
    
    ; Скачиваем основной файл обновления
    URLDownloadToFile, %UpdateFileURL%, %DownloadFolder%\updt.ahk

    ; Скачиваем дополнительные файлы
    for index, fileURL in AdditionalFiles {
        SplitPath, fileURL, OutFile
        URLDownloadToFile, %fileURL%, %DownloadFolder%\%OutFile%
    }

    Sleep, 1000
    SplashTextOff

    ; -------------------------------
    ; Автоматически показываем изменения после обновления
    ; -------------------------------
    MsgBox, 64, Обновление завершено! , Обновление до версии %vupd% успешно!`n`nОписание изменений:`n%desupd%`n`nПолный список:`n%updupd%
}

SplashTextOff
ExitApp




Windows_Disk := A_WinDir

if Windows_Disk contains Windows
{
    RegExMatch(Windows_Disk, "(.*)windows", Disk_7)
    if Disk_71 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_71%
    }
       
    RegExMatch(Windows_Disk, "(.*)Windows", Disk_8)
    if Disk_81 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_81%
    }
       
    RegExMatch(Windows_Disk, "(.*)WINDOWS", Disk_10)
    if Disk_101 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_101%
    }
}
else
{
    MsgBox, У тебя операционная система не Windows!
    ExitApp
}

Parse := ComObjCreate("WinHttp.WinHttpRequest.5.1")
Parse.Open("GET", "https://docs.google.com/document/d/1vU9ZLXraDrG-5WsFeyQjz98aMGV3Q2iGwGvHu45Oh5M/edit?usp=sharing", false)
Parse.Send()
Parse.WaitForResponse()
Text := Parse.ResponseText

if Text contains %HWID%
{
    Goto, true
}
else
{
    MsgBox, Добро пожаловать в поле регистрации!`nСкопированые Ключ Отправьте Продавцу.
    Gui, Font, S16 CBlack Bold, Arial
    Gui, Add, Text, x53 y0 w500 h30 , Твой ключ:
    Gui, Font, ,
    Gui, Add, Edit, x1 y31 w219 h21 +Center ReadOnly vEdit,
    Gui, Add, Button, x35 y52 w153 h24 gClip , Копировать и закрыть
    Gui, Add, Button, x35 y80 w153 h24 gContactSeller , Написать продавцу  ; Новая кнопка
    Gui, Show, w221 h120, Доступ   ; Изменил высоту окна
    GuiControl, , Edit, % HWID
    return
    
    Clip:
    Gui, Submit, NoHide
    Clipboard := Edit
    ExitApp
    
    ContactSeller:
    Run, https://funpay.com/users/6182457/   ; Замените на реальный адрес
    return
    
    GuiClose:
    ExitApp
}
true:
MsgBox, Добро пожаловать!





; Загрузка настроек из settings.ini
IniRead, pixel_box, settings.ini, Settings, pixel_box, 
IniRead, pixel_sens, settings.ini, Settings, pixel_sens, 
IniRead, pixel_color, settings.ini, Settings, pixel_color, 
IniRead, tap_time, settings.ini, Settings, tap_time, 
IniRead, key_stay_on, settings.ini, Settings, key_stay_on, 
IniRead, key_hold_mode, settings.ini, Settings, key_hold_mode, 
IniRead, key_fastclick, settings.ini, Settings, key_fastclick, 
IniRead, key_off, settings.ini, Settings, key_off, 
IniRead, key_gui_hide, settings.ini, Settings, key_gui_hide, 
IniRead, key_exit, settings.ini, Settings, key_exit, 
IniRead, key_hold, settings.ini, Settings, key_hold, 

; GUI
Gui, 2:Font, Cdefault, Fixedsys
Gui, 2:Color, EEAA99
Gui, 2:Add, Progress, x10 y20 w100 h23 Disabled BackgroundGreen vC3
Gui, 2:Add, Text, xp yp wp hp cYellow BackgroundTrans Center 0x200 vB3 gStart, ON
Gui, 2:Add, Progress, x10 y20 w100 h23 Disabled BackgroundGreen vC2
Gui, 2:Add, Text, xp yp wp hp cYellow BackgroundTrans Center 0x200 vB2 gStart, HOLD MODE
Gui, 2:Add, Progress, xp yp wp hp Disabled BackgroundRed vC1
Gui, 2:Add, Text, xp yp wp hp cYellow BackgroundTrans Center 0x200 vB1 gStart, OFF
Gui, 2:Add, Text, x10 y50 w500 h500 cWhite vC5 BackgroundTrans, 
(
Горячие клавиши:
%key_stay_on%  - AutoFire
%key_hold_mode%   - Hold Mode
%key_fastclick%   - Fast Click
%key_off%   - Выключить Trigger
%key_gui_hide% - Скрыть Меню
%key_exit%  - Выход
)
Gui, 2:Show, x10 y1 w200 h150
Gui 2:+LastFound +ToolWindow +AlwaysOnTop -Caption
WinSet, TransColor, EEAA99

; Установка границ
leftbound := A_ScreenWidth / 2 - pixel_box
rightbound := A_ScreenWidth / 2 + pixel_box
topbound := A_ScreenHeight / 2 - pixel_box
bottombound := A_ScreenHeight / 2 + pixel_box

; Установка горячих клавиш
Hotkey, %key_stay_on%, stayon
Hotkey, %key_hold_mode%, holdmode
Hotkey, %key_off%, offloop
Hotkey, %key_gui_hide%, guihide
Hotkey, %key_exit%, terminate
Hotkey, %key_fastclick%, fastclick

return

start:
Gui, 2:Submit, NoHide
return

terminate:
SoundBeep, 300, 200
SoundBeep, 200, 200
Sleep 400
ExitApp

stayon:
SoundBeep, 300, 200
SetTimer, Mainloop1, 40
SetTimer, Mainloop2, 15
GuiControl, 2:Hide, B1
GuiControl, 2:Hide, C1
GuiControl, 2:Hide, B2
GuiControl, 2:Hide, C2
GuiControl, 2:Show, B3
GuiControl, 2:Show, C3
GuiControl, 2:Show, C5
return

holdmode:
SoundBeep, 300, 200
SetTimer, Mainloop2, 15
SetTimer, Mainloop1, Off
GuiControl, 2:Hide, B1
GuiControl, 2:Hide, C1
GuiControl, 2:Show, B2
GuiControl, 2:Show, C2
GuiControl, 2:Hide, B3
GuiControl, 2:Hide, C3
GuiControl, 2:Show, C5
return

offloop:
SoundBeep, 300, 200
SetTimer, Mainloop2, 1
SetTimer, Mainloop1, 10
GuiControl, 2:Show, B1
GuiControl, 2:Show, C1
GuiControl, 2:Hide, B2
GuiControl, 2:Hide, C2
GuiControl, 2:Hide, B3
GuiControl, 2:Hide, C3
GuiControl, 2:Show, C5
return

guihide:
if (guiVisible) {
    Gui, 2:Hide
    guiVisible := false
} else {
    Gui, 2:Show
    guiVisible := true
}
return

fastclick:
    SoundBeep, 300, 200
    toggle := !toggle
    if toggle
        SetTimer, FastClickLoop, 10
    else
        SetTimer, FastClickLoop, Off
return

FastClickLoop:
    if GetKeyState("LButton", "P")
    {
        actionpulse() ; безопасный клик через DllCall
    }
return

Mainloop2:
if (GetKeyState(key_hold, "P")) ; Проверка удержания клавиши XButton2
{
    FrameScan()
}
return

Mainloop1:
FrameScan()
return

return

FrameScan() {
    global pixel_box, pixel_sens, pixel_color, tap_time
    global FoundX, FoundY, leftbound, topbound, rightbound, bottombound

    ; Поиск пикселя в области
    PixelSearch, FoundX, FoundY, leftbound, topbound, rightbound, bottombound, pixel_color, pixel_sens, Fast RGB

    if !(ErrorLevel)
    {
        if !GetKeyState("LButton") ; Проверяем состояние левой кнопки
        {
            ActionPulse() ; Симуляция клика
        }
    }
    Sleep %tap_time% ; Задержка для стабильности
    return
	}
	

ActionPulse() {
    SendPlay {LButton Down}
    Sleep 10
    SendPlay {LButton Up}
}

