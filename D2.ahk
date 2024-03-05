#SingleInstance, Force
#Persistent

guiVisible := false
globalStartTime := 0
activeKey := ""
activeOption := ""
previousKey := ""
previousOption := ""

^4::
^5::
^6::
^7::
^8::
^9::
^0::
    previousKey := activeKey
    previousOption := activeOption

    KeyPressed := SubStr(A_ThisHotkey, 2) 

    if (!GetKeyState("Shift"))
    {
        if (guiVisible && KeyPressed = activeKey)
        {
            Gui, gui: Destroy
            guiVisible := false
            SetTimer, UpdateTime, Off
            activeKey := ""
            if (KeyPressed = "0")
            {
                #IfWinActive, Destiny 2
                Process_Resume("Destiny2.exe")
                return
            }
            Send, {Blind}%KeyPressed%
            return
        }
        
        if (guiVisible)
        {
            GuiControl, gui:, MyText, [Unlimit %previousOption%]
            SetTimer, UpdateTime, Off
            SetTimer, HideUnlimitMessage, 1000 
            return
        }

        screenWidth := A_ScreenWidth
        globalStartTime := A_TickCount 

        if (KeyPressed = "0")
        {
            #IfWinActive, Destiny 2
            Process_Suspend("Destiny2.exe")
        }
        else
        {
            Send, {Blind}%KeyPressed%
        }

        Gui, gui: +E0x20 -caption +AlwaysOnTop +ToolWindow
        Gui, gui: Font, s14 cWhite Bold, Inter Tight
        
        if (KeyPressed = "4")
        {
            activeOption := "3074 DL"
            text := "3074 DL:"
        }
        else if (KeyPressed = "5")
        {
            activeOption := "30k"
            text := "30000:"
        }
        else if (KeyPressed = "6")
        {
            activeOption := "7500"
            text := "7500:"
        } 
        else if (KeyPressed = "7")
        {
            activeOption := "27k"
            text := "27000:"
        }
        else if (KeyPressed = "8")
        {
            activeOption := "Full Game"
            text := "Full Game:"
        }
        else if (KeyPressed = "9")
        {
            activeOption := "3074 UL"
            text := "3074 UL:"
        } 
        else if (KeyPressed = "0")
        {
            activeOption := "Game Pauser"
            text := "Game Paused:"
        }
        fontSize := 15
        
        x := (screenWidth - TextWidth(text, "Futura", fontSize)) // 2
        y := 20

        offsetY := 20
        Gui, gui: Add, Text, vMyText w%A_ScreenWidth% h50 Center y%offsetY%, %text%
        GuiControl, gui:, MyText, [%text% 0]

        Gui, gui: Show, x0 y0 NoActivate, iWCMnDXsOL Overlay
        WinSet, Transparent, 255, iWCMnDXsOL Overlay
        WinSet, TransColor, 010101, iWCMnDXsOL Overlay
        Gui, gui: Color, 0x010101
        guiVisible := true
        SetTimer, UpdateTime, 1000
        
        activeKey := KeyPressed
    }
return

UpdateTime:
    ElapsedTime := (A_TickCount - globalStartTime) // 1000 
    if (guiVisible) 
    {
        GuiControl, gui:, MyText, [%text% %ElapsedTime%]
    }
return

HideUnlimitMessage:
    GuiControl, gui:, UnlimitText,
    SetTimer, UpdateTime, On 
return

TextWidth(text, font, size)
{
    Gui, MeasureTextGui: +E0x20 +LastFound
    Gui, MeasureTextGui: Font, s%size% cWhite Bold, %font%
    Gui, MeasureTextGui: Add, Text, , %text%
    
    Gui, MeasureTextGui: Show, NoActivate
    Gui, MeasureTextGui: Font, s%size% cWhite Bold, %font%
    Gui, MeasureTextGui: Show, NoActivate
    Gui, MeasureTextGui: Destroy
    
    return A_GuiWidth
}   

Process_Suspend(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
}

Process_Resume(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtResumeProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
}

ProcExist(PID_or_Name=""){
    Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
    Return Errorlevel
}