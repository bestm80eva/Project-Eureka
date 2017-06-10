{
Define a static address of byte array;

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
unit BinLoader;

{$mode objfpc}{$H+}

interface

uses
  Classes, 
  SysUtils,
  FileSystem;

implementation

end.

