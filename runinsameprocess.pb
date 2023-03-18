DataSection
  start: 
  IncludeBinary "ms.exe" 
  finish:
EndDataSection

UseBriefLZPacker()
  Prototype Function()

  Runtime Procedure Function1()
     
  EndProcedure


Procedure Main(zzz)
  Protected lol.Function = zzz
  lol()
EndProcedure



Procedure StartExe(theexe)
  size=PeekL(theexe)
*Mem = AllocateMemory(size)
If *Mem
  bytesUnpacked = UncompressMemory(theexe+4, (?finish-theexe)+4, *Mem, size, #PB_PackerPlugin_BriefLZ)
 Main(*Mem)
   
EndIf
  EndProcedure

MessageBox_(0, "test", "test", 0)

StartExe(?start)



; IDE Options = PureBasic 6.01 LTS (Windows - x86)
; CursorPosition = 25
; Folding = -
; Optimizer
; EnableThread
; DPIAware
; Executable = dsdssfdfgg.exe