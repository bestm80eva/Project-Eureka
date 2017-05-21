
uses
 sysutils,
 GlobalConst,
 GlobalConfig,
 GlobalTypes,
 Platform,
 Threads,
 Console,
 Framebuffer,
 BCM2837,
 BCM2710,
 HeapManager,
 link_server, {this_one}
 call_client, {and_this_one}
 Classes,
 Ultibo,
 UltiboClasses,
 UltiboUtils,
 Devices,
 USB,
 MMC,
 Storage,
 FileSystem,
 Keyboard,
 Font,
 Logging,
 Timezone,
 Services,
 Shell,
 ShellFilesystem;

type
  TMyFunc = function():longword; cdecl;

var
  ret:LongInt;
  Buffer:PByte;
  PageTableEntry:TPageTableEntry;
  WindowHandle:TWindowHandle;

begin
 //Allocate a buffer for our code, the buffer will be a full page size (normally 4096 bytes)
 //so that our page table changes don't affect anything else.
 //The buffer will also be aligned to the page size for the same reason.
 WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault, CONSOLE_POSITION_FULL, True);

 Buffer:=GetAlignedMem(MEMORY_PAGE_SIZE, MEMORY_PAGE_SIZE);
 if Buffer = nil then Exit;

 //Get the page table entry for our buffer
 PageTableEntry:=PageTableGetEntry(PtrUInt(Buffer));

 //Add the executable attribute to our page table entry
 PageTableEntry.Flags:=PageTableEntry.Flags or PAGE_TABLE_FLAG_EXECUTABLE;

 //And write it back so the page will now be executable
 PageTableSetEntry(PageTableEntry);


  Buffer[0]:=$63;
  Buffer[1]:=$00;
  Buffer[2]:=$a0;
  Buffer[3]:=$e3;
  Buffer[4]:=$1e;
  Buffer[5]:=$ff;
  Buffer[6]:=$2f;
  Buffer[7]:=$e1;
 CleanDataCacheRange(PtrUInt(Buffer),MEMORY_PAGE_SIZE);

 ConsoleWindowWriteLn(WindowHandle, '5 Seconds Later Execution');
 ThreadSleep(5000);

 ret := TMyFunc(Buffer)();

 ConsoleWindowWriteLn(WindowHandle, IntToStr(ret));

end.
