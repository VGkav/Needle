# Needle

Small tool to inject any 32bit dll to any 32bit running process. Edit the ini to provide the window title of the target process and the filename of the dll to be injected. It uses the GetWindowThreadProcessId API to find the PID and then does the VirtualAllocEx+WriteProcessMemory+CreateRemoteThread trick to run LoadLibrary with the correct argument on that target process.
