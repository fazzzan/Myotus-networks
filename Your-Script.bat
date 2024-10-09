@if (@This==@IsBatch) @then
wscript //E:JScript "%~dpnx0" %1
exit /b
@end
WScript.CreateObject("WScript.Shell").Run("notepad++.exe " + decodeURIComponent(WScript.arguments(0).split("test:")[1]));
WScript.Quit(0);