UseLZMAPacker()

Procedure CompressFile(file2Compress.s)
  If ReadFile(0, file2Compress)
    fileLength = Lof(0)
    *fileBuffer = AllocateMemory(fileLength)
    *compressBuffer = AllocateMemory(fileLength)
    If fileLength And *fileBuffer And *compressBuffer
      ReadData(0, *fileBuffer, fileLength)
      startTimer = GetTickCount_()
      compressedLength = CompressMemory(*fileBuffer, fileLength,
                                        *compressBuffer, fileLength,  #PB_PackerPlugin_Lzma  , 9)
                                       
      CloseFile(0)
      If compressedLength
        compressionTime = GetTickCount_() - startTimer
        compressedFileName.s = SaveFileRequester("Choose a file to save to:",
                                                 "", "All files | *.*", 0)
        If compressedFileName
          OpenFile(1,compressedFileName)
          WriteLong(1, fileLength)
          WriteData(1, *compressBuffer, compressedLength)
          CloseFile(1)
          MessageRequester("Info", "Compression succeded:" + Chr(10) + Chr(10) + 
                                   "Old size: " + Str(FileLength) + Chr(10) + 
                                   "New size:"+ Str(CompressedLength + 4) + Chr(10) +
                                   "Compression time: " + Str(CompressionTime) + " ms",
                                   #MB_ICONINFORMATION)
          ProcedureReturn 1
        EndIf
      EndIf 
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

file2Compress.s = OpenFileRequester("Choose a file to compress",
                                    "", "All files | *.*", 0)
If file2Compress
  If CompressFile(file2Compress) = 0
    MessageRequester("Info", "Something went wrong.", #MB_ICONINFORMATION)
  EndIf
EndIf


; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 40
; Folding = -
; Optimizer
; EnableThread
; Executable = compress.exe