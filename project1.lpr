
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
 //call_client, {and_this_one}
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

{type
  TMyFunc = function():longword; cdecl;}

var
  ret:LongInt;
  aLoader:TBinLoader;
  //Buffer:PByte;
  //PageTableEntry:TPageTableEntry;
  WindowHandle:TWindowHandle;

begin
 //Allocate a buffer for our code, the buffer will be a full page size (normally 4096 bytes)
 //so that our page table changes don't affect anything else.
 //The buffer will also be aligned to the page size for the same reason.
 WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault, CONSOLE_POSITION_FULL, True);

 WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault, CONSOLE_POSITION_FULL, True);
  ThreadSleep(3000);
  {We may need to wait a couple of seconds for any drive to be ready}
 ConsoleWindowWriteLn(WindowHandle,'Waiting for drive C:\');
 while not DirectoryExists('C:\') do
  begin
   {Sleep for a second}
   Sleep(1000);
  end;
 ConsoleWindowWriteLn(WindowHandle,'C:\ drive is ready');
 ConsoleWindowWriteLn(WindowHandle,'');
 ThreadSleep(1000);
 ConsoleWindowWriteLn(WindowHandle, 'Binary Loader is Loading...');

 aLoader := TBinLoader.Create;
 aLoader.LoadFile('test');
 ThreadSleep(1000);
 ConsoleWindowWriteLn(WindowHandle, '');
 ConsoleWindowWriteLn(WindowHandle, 'Binary Buffer is Checking...');

 for i := 0 to 6 do
 begin
   ConsoleWindowWriteLn(WindowHandle, InttoHex(aLoader.Buffer[i], 4) );
 end;

 ConsoleWindowWriteLn(WindowHandle, '');
 ConsoleWindowWriteLn(WindowHandle, '3 Seconds Later Execution');
 ThreadSleep(3000);
 ret := aLoader.RunBuffer;


 ConsoleWindowWriteLn(WindowHandle, 'Display the Result:');
 ConsoleWindowWriteLn(WindowHandle, IntToStr(ret));

end.