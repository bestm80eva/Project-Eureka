@echo off
SET THEFILE=program
echo Assembling %THEFILE%
C:\Ultibo\Core\fpc\3.1.1\bin\i386-win32\arm-ultibo-as.exe -mfloat-abi=hard -meabi=5 -march=armv7-a -mfpu=vfpv3 -o C:\Users\iamhy_000\Documents\workspace\lib\arm-ultibo\project1.o  C:\Users\iamhy_000\Documents\workspace\lib\arm-ultibo\project1.s
if errorlevel 1 goto asmend
Del C:\Users\iamhy_000\Documents\workspace\lib\arm-ultibo\project1.s
SET THEFILE=project1
echo Linking %THEFILE%
C:\Ultibo\Core\fpc\3.1.1\bin\i386-win32\arm-ultibo-ld.exe -g     --gc-sections  -L. -o project1.elf -T link.res
if errorlevel 1 goto linkend
SET THEFILE=project1
echo Linking %THEFILE%
C:\Ultibo\Core\fpc\3.1.1\bin\i386-win32\arm-ultibo-objcopy.exe -O binary project1.elf kernel7.img
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
