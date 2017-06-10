
uses
 GlobalConst,
 GlobalConfig,
 Platform,
 HeapManager;
 
const
 //This value must not conflict with any of the HEAP_FLAG_ values in HeapManager
 HEAP_FLAG_CUSTOM  = $08000000;
  
var
 RequestAddress:PtrUInt;
 ActualAddress:PtrUInt;
 
begin
  //Request the heap manager to reserve a 64KB block of memory starting at 0x10000000
  //The size can be any amount that is a power of 2 (must be more than 32 bytes)
  //The address must be a multiple of HEAP_REQUEST_ALIGNMENT which is normally 4KB
  RequestAddress:=$10000000;
  
  //Call RequestHeapBlock to reserve the memory, if it returns the same address we requested then it was successful
  ActualAddress:=PtrUInt(RequestHeapBlock(Pointer(RequestAddress), SIZE_64K, HEAP_FLAG_CUSTOM, CPU_AFFINITY_NONE));
  
  if ActualAddress <> RequestAddress then
   begin
     //Error, block could not be reserved
   end
  else
   begin
     //Success, the block can be used. You MUST NOT use the first 32 bytes!
     //Each of the pages can now be marked as PAGE_TABLE_FLAG_EXECUTABLE
   end;