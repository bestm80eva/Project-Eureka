{
<LOAD_LIB>, Kernel Space, Fucntion Call
load binary module from `C:/lib/<module_name>` with sturcture
-----------------------------------------------------
<CALL_LIB>, Kernel Space, FIXED System Call
push/pop, for parameter coupling
-----------------------------------------------------
<REMOVE_LIB>, Kernel Space, Function Call
remove from the link, free the allocated mem space
-----------------------------------------------------
<WRITE_LIB>, Kernel Space, Function Call
add to the link, write to the allocated memory
-----------------------------------------------------
<RUN_FILE>, read from current folder, load the binary code,
(OPTIONAL)check the format, build ENV for running and return
}

unit link_server;

{$mode objfpc}{$H+}
{$inline on}   {Allow use of Inline procedures}

interface

{here define the 2-dim doubl link, maintain folder&page information, and header for para_num etc.}

uses
  GlobalConfig,
  GlobalConst,{for SIZE_* define use}
  HeapManager,
  Classes,
  StrUtils,
  SysUtils,
  Platform,
  FileSystem,  {Include the file system core and interfaces}
  FATFS,       {Include the FAT file system driver}
  MMC,         {Include the MMC/SD core to access our SD card}
  BCM2710;     {And also include the MMC/SD driver for the Raspberry Pi}

{==============================================================================}
{Global definitions}
{$I sys_api.inc}

{==============================================================================}
const
  DEFAULT_LIB_BASE = 'C:\lib\';
  DL_BLOCK_SIZE = SIZE_64K; {64KB per Function}
  DL_PAGE_SIZE  = SIZE_1M; {1MB per Module}

{==============================================================================}
type
  TDLCallback = function():LongWord; {rewrite for fixed address}

  PDLModule = ^TDLModule;
  TDLModule = record
   Size:PtrUInt;           {Size of the Module Block }
   HashName:LongWord;         {Flags of the Heap Block (eg HEAP_FLAG_SHARED)}
   Prev:PDLModule;        {Previous Heap Block in list}
   Next:PDLModule;        {Next Heap Block in list}
  end;

  PDLFunc = ^TDLFunc;
  TDLFunc = record
   Size:PtrUInt;           {Size of the Function Block }
   HashName:LongWord;         {Flags of the Heap Block (eg HEAP_FLAG_SHARED)}
   Prev:PDLFunc;        {Previous Heap Block in list}
   Next:PDLFunc;        {Next Heap Block in list}
  end;

{==============================================================================}
{Binary File Loader Prototype}
type
 TBinLoader = class(TObject)
 constructor Create;
 destructor Destroy; override;
 private
  {}
  FLength:Integer;
  FBuffer:PByte;
  FEnabled:Boolean;

 public
  {}
  procedure LoadFile(mod_name:String);
  procedure Load2Lib;
  function RunBuffer:LongWord;
  procedure SetBufferSize(MEM_SIZE:Integer);
  {}
  property Length:Integer read FLength write FLength;
  property Buffer:PByte read FBuffer write FBuffer;
  property Enabled:Boolean read FEnabled write FEnabled;
 end;
 
{==============================================================================}

{==============================================================================}
var
  {Global specific variables}
  i:Integer;
  return_counter:Integer;

{==============================================================================}
{Initialization Functions}

{util function}


function LOAD_LIB(mod_name:String):Boolean;
function REMV_LIB(mod_name:String):Boolean;
function CALL_LIB(mod_name:String):PByte;
function RUNN_LIB(file_name:String):PByte;

implementation

{==============================================================================}
{==============================================================================}
var
  j:Integer;

{==============================================================================}
{==============================================================================}
{Initialization Functions}

function LOAD_LIB(mod_name:String):Boolean;
var
  aLoader:TBinLoader;
begin
  aLoader := TBinLoader.Create;
  aLoader.LoadFile(mod_name);
  LOAD_LIB := true;
end;

function REMV_LIB(mod_name:String):Boolean;
var
  aLoader:TBinLoader;
begin
  aLoader := TBinLoader.Create;
  aLoader.LoadFile(mod_name);
  REMV_LIB := true;
end;

function CALL_LIB(mod_name:String):PByte;
var
  aLoader:TBinLoader;
begin
  aLoader := TBinLoader.Create;
  aLoader.LoadFile(mod_name);
  CALL_LIB := PByte($10000000);
end;

function RUNN_LIB(file_name:String):PByte;
var
  aLoader:TBinLoader;
begin
  aLoader := TBinLoader.Create;
  aLoader.LoadFile(file_name);
  RUNN_LIB := PByte($10000000);
end;

procedure TBinLoader.SetBufferSize(MEM_SIZE:Integer);
var
  PageTableEntry:TPageTableEntry;
begin
  self.Buffer := GetAlignedMem(MEMORY_PAGE_SIZE, MEM_SIZE);
  if self.Buffer = nil then Exit;
  //Get the page table entry for our buffer
  PageTableEntry := PageTableGetEntry(PtrUInt(self.Buffer));
  //Add the executable attribute to our page table entry
  PageTableEntry.Flags := PageTableEntry.Flags or PAGE_TABLE_FLAG_EXECUTABLE;
  //And write it back so the page will now be executable
  PageTableSetEntry(PageTableEntry);
end;

procedure TBinLoader.LoadFile(mod_name:String);
var
  i, j: Integer;
  file_name, tmp_str : String;
  {SearchRec:TSearchRec;}
  StringList:TStringList;
  FileStream:TFileStream;
begin
  file_name := Concat(DEFAULT_LIB_BASE + mod_name); //'C:\bin\test';

  if DirectoryExists('C:\') and FileExists(file_name) then
    begin
      FileStream := TFileStream.Create(file_name, fmOpenReadWrite);
      StringList := TStringList.Create;
      StringList.LoadFromStream(FileStream);

      self.SetBufferSize(MEMORY_PAGE_SIZE); {Setup Buffer for this lib loader}

      for i := 0 to StringList.Count-1 do
        for j:= 0 to 3 do
          begin
            tmp_str := Copy(StringList.Strings[i], 2*j+1, 2);
            Buffer[4*i + (3-j)] := Byte(Hex2Dec(tmp_str));
          end;


      CleanDataCacheRange(PtrUInt(Buffer), MEMORY_PAGE_SIZE);
      FileStream.free;
      StringList.free;

      end
  else
    exit;
end;

function TBinLoader.RunBuffer:LongWord;
var
  ret :LongWord;
begin
  ret := TDLCallback(self.Buffer)();
  RunBuffer := ret;
end;

procedure TBinLoader.Load2Lib;
begin

end;

end.

