@echo off

if exist poison.obj del poison.obj
if exist poison.dll del poison.dll

\masm32\bin\ml /c /coff poison.asm

\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL /DEF:poison.def poison.obj
pause