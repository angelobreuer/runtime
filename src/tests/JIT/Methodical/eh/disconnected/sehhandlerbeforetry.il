// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// seh handler before body

.assembly extern System.Console
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )
  .ver 4:0:0:0
}
.assembly extern mscorlib
{
  .ver 0:0:0:0
}
.assembly extern common {}
.assembly test
{
  .ver 0:0:0:0
}
.module test.exe
.imagebase 0x00400000
.subsystem 0x00000003
.file alignment 512
.corflags 0x00000001

.method public static int32 main() {
    .entrypoint
    .maxstack  2
	  .locals init (
	  class [mscorlib]System.IO.StringWriter expectedOut,
	  class [common]TestUtil.TestLog testLog
	)

    newobj     instance void [mscorlib]System.IO.StringWriter::.ctor()
    stloc.s    expectedOut
    ldloc.s    expectedOut
    ldstr      "In try"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    ldstr      "Done"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    newobj     instance void [common]TestUtil.TestLog::.ctor(object)
    stloc.s    testLog

    ldloc.s    testLog
    callvirt   instance void [common]TestUtil.TestLog::StartRecording()

  br.s try_start
filter_begin:  
  pop
  ldstr "In filter"
  call       void [System.Console]System.Console::WriteLine(string)
  ldc.i4.1 
  endfilter

handler_begin:
  pop
  ldstr "In handler"
  call       void [System.Console]System.Console::WriteLine(string)
  leave.s    done
handler_end:

try_start:  ldstr "In try"
  call       void [System.Console]System.Console::WriteLine(string)
  
  leave.s    done
try_end:


done: 
  ldstr      "Done"
  call       void [System.Console]System.Console::WriteLine(string)
  ldloc.s    testLog
  callvirt   instance void [common]TestUtil.TestLog::StopRecording()
  
   ldloc.s    testLog
   callvirt   instance int32 [common]TestUtil.TestLog::VerifyOutput()
	ret
	
.try try_start to try_end filter filter_begin handler handler_begin to handler_end
}
