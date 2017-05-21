{

<READ_LIB>, Kernel Space, FIXED System Call
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
  GlobalTypes,
  HeapManager,
  Classes,
  SysUtils;

{==============================================================================}
{Global definitions}
{$I sys_api.inc}

{==============================================================================}
const
  DL_BLOCK_SIZE = SIZE_64K; {64KB per Function}
  DL_PAGE_SIZE  = SIZE_1M; {1MB per Module}

{==============================================================================}
type
  TDLCallback = function(Size:PtrUInt):LongWord; {rewrite for fixed address}

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
var
  {Global specific variables}
  i:Integer;

{==============================================================================}
{Initialization Functions}
{
procedure insert_method();
procedure call_method();
procedure remove_method();
procudere run
}

implementation

{==============================================================================}
{==============================================================================}
var
  j:Integer;

{==============================================================================}
{==============================================================================}
{Initialization Functions}


end.

