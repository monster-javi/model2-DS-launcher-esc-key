#Requires AutoHotkey v2.0
#SingleInstance Force

; --- RUTAS RELATIVAS ---
emuPath := A_ScriptDir
emuExe  := "emulator_multicpu.exe"
dsPath  := A_ScriptDir . "\..\..\frontends\demulshooter"
dsExe   := "DemulShooter.exe"

; Recupera la ROM enviada por Attract-Mode
if (A_Args.Length < 1)
    ExitApp()

rom := A_Args[1]

; 1. LANZAR DEMULSHOOTER Y EMULADOR
Run('"' . dsPath . "\" . dsExe . '" -target=model2 -rom=' . rom . ' -no_gui', dsPath, "Hide")
SetWorkingDir(emuPath)
Run('"' . emuPath . "\" . emuExe . '" ' . rom, emuPath)

; 2. AL PRESIONAR ESC
$Escape::
{
    ; Cierre limpio del emulador (restaura la resolución)
    if WinExist("ahk_exe " . emuExe)
    {
        WinActivate("ahk_exe " . emuExe)
        Send("!{F4}")
        WinWaitClose("ahk_exe " . emuExe, , 2)
    }

    ; Cierre elegante de DemulShooter vía sistema para limpiar el icono de la bandeja
    if ProcessExist(dsExe)
    {
        RunWait('taskkill /IM ' . dsExe, , "Hide")
        Sleep(150)
    }

    ; Cierre de seguridad por si alguno quedó colgado
    if ProcessExist(emuExe)
        ProcessClose(emuExe)
    if ProcessExist(dsExe)
        ProcessClose(dsExe)

    ; Devolver foco a Attract-Mode
    if WinExist("ahk_class SFML_Window")
        WinActivate("ahk_class SFML_Window")

    ExitApp()
}