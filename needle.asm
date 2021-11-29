    .586p
    .model flat, stdcall
    option casemap :none 

ASSUME  cs:FLAT, ds:FLAT, ss:FLAT, es:FLAT, fs:FLAT, gs:ERROR

    include \masm32\include\windows.inc
    include \masm32\include\advapi32.inc
    include \masm32\include\masm32.inc
    include \masm32\include\user32.inc
    include \masm32\include\shell32.inc  
    include \masm32\include\shlwapi.inc  
    include \masm32\include\kernel32.inc
    include \masm32\include\comdlg32.inc
    include	\masm32\macros\macros.asm
    
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\advapi32.lib
    includelib \masm32\lib\msvcrt.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\shell32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\shlwapi.lib
    includelib \masm32\lib\comdlg32.lib

    IDI_TASKBARICON    equ 101
    WM_SHELLNOTIFY     equ WM_USER + 10005
    NIIF_ERROR         equ 3
    NIF_INFO           equ 10h
    IDI_TRAY           equ 0
    NOTIFYICON_VERSION equ 3
    
.data

ProgTitle              db    "Needle",0
tip_text_not_found     db    "Target process not found, exiting !",0
loadlib_str            db    "LoadLibraryA",0
kernel32_str           db    "kernel32.dll",0
dll_to_inject          db    "\poison.dll",0
sz_ini                 db    ".\needle.ini",0
sz_Target_window       db    "Target_window",0
sz_Dll_to_load         db    "Dll_to_load",0
sz_slash               db    "\",0

nid   NOTIFYICONDATA    <>

.data?

tempdword              dd    ?
target_pid             dd    ?
target_P_handle        dd    ?
target_window_handle   dd    ?
hInstance              dd    ?
target_space           dd    ?
LoadL_address          dd    ?
namebuffer             db    256 dup(?)
target_window_buffer   db    32 dup (?)
buffer                 db    32 dup (?)

.code
start:

invoke GetModuleHandle,NULL
mov hInstance,eax
m2m nid.hwnd, hInstance
mov nid.cbSize, SIZEOF NOTIFYICONDATA
mov nid.uID, IDI_TRAY
mov nid.uFlags, NIF_INFO  ;+NIF_ICON
mov nid.uVersion, NOTIFYICON_VERSION

invoke GetCurrentDirectory, 256, offset namebuffer
invoke GetPrivateProfileString, offset ProgTitle, offset sz_Dll_to_load, offset sz_ini, offset buffer, 32 ,offset sz_ini
mov eax, add$(offset namebuffer,offset sz_slash)
mov eax, add$(offset namebuffer,offset buffer)

invoke GetPrivateProfileString, offset ProgTitle, offset sz_Target_window, offset sz_ini, offset target_window_buffer, 32 ,offset sz_ini
invoke FindWindow , 0, offset target_window_buffer
.IF eax==0
   mov nid.dwInfoFlags, NIIF_ERROR
   invoke lstrcpy, ADDR nid.szInfo, ADDR tip_text_not_found
   invoke lstrcpy, ADDR nid.szInfoTitle, ADDR ProgTitle
   invoke Shell_NotifyIcon, NIM_ADD, ADDR nid
   invoke Sleep, 2000
   invoke Shell_NotifyIcon, NIM_DELETE, ADDR nid
.ELSE
    invoke GetWindowThreadProcessId, EAX , offset target_pid
    invoke OpenProcess, PROCESS_ALL_ACCESS	, 0 , dword ptr [target_pid]
    mov dword ptr [target_P_handle] , eax
    
    invoke GetModuleHandle, offset kernel32_str
    invoke GetProcAddress, eax, offset loadlib_str
    mov dword ptr [LoadL_address], eax
    
    invoke VirtualAllocEx, target_P_handle, NULL, 1000h, MEM_COMMIT, PAGE_EXECUTE_READWRITE
    mov dword ptr [target_space], eax
    invoke WriteProcessMemory, dword ptr [target_P_handle], dword ptr [target_space], offset namebuffer, 50, tempdword
    invoke CreateRemoteThread, dword ptr [target_P_handle], NULL, NULL, dword ptr [LoadL_address], dword ptr [target_space], NULL, NULL
.ENDIF

invoke ExitProcess, 0
end start







