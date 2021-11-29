@SET MASM32=\masm32

@%MASM32%\bin\ml /c /coff /Cp /nologo needle.asm
%MASM32%\bin\link /SUBSYSTEM:WINDOWS  /LIBPATH:%MASM32%\lib  /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,RWE  needle.obj 
@pause
