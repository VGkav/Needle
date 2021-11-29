# Needle

Small tool to inject any 32bit dll to any 32bit running process. Edit the ini to provide the window title of the target process and the filename of the dll to be injected. It uses the GetWindowThreadProcessId API to find the PID and then does the VirtualAllocEx+WriteProcessMemory+CreateRemoteThread trick to run LoadLibrary with the correct argument on that target process.

poison.dll is a very simple dll that shows a MessageBox when the LibMain is called (after the DLL_PROCESS_ATTACH event). That's how you can verify the code is run (inside the target process address space obviously, that's the whole point)
