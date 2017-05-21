{
<call_function(Module_Name, Function_Name, Parameter_List)>
}
unit call_client;

{$mode objfpc}{$H+}
{$inline on}   {Allow use of Inline procedures}

interface

uses
  GlobalConfig,
  GlobalConst,{for SIZE_* define use}
  GlobalTypes,
  Classes,
  SysUtils;

{==============================================================================}
{Global definitions}
{$I sys_api.inc}

{==============================================================================}
const
  PTR_SIZE = SIZE_4K;

{==============================================================================}
{type}

{==============================================================================}
{Initialization Functions}
function call_function(ModName:String; FuncName:String; Para:PLONG):PLONG; inline;

implementation

function call_function(ModName:String; FuncName:String; Para:PLONG):PLONG; inline;
begin
    ModHash, FuncHash:Word;
    {Hash(*) is inline function}
    {ModHash = Hash(ModName);}
    {FuncHash = Hash(FuncName);}
    {check the API version here?}
    asm
       push FuncHash
       push ModHash
       bl CAL_ADDR

       .word ModHash
       .word FuncHash
    end;
end;

end.

