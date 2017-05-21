{
DYNAMIC_LIB_SPACE: Will occupy 64MB at the end the physical memory
At the header of the space: instructions jump to <WRITE/READ/REMOVE>_LIB
 which inner compiled into the kernel with symbol.
}

{$ifndef SYS_API}
{$define SYS_API}

Const
  API_VERSION = 0.1;
  LIB_ADDR = $FC000000;
  CAL_ADDR = $FE000000;

{$endif}
