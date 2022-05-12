set MCUX_WORKSPACE_LOC=.
set MCUX_FLASH_DIR0=C:/Installer/MCUXpressoIDE_11.5.0_7232/ide/plugins/com.nxp.mcuxpresso.tools.bin.win32_11.5.0.202112161150/binaries/Flash
set MCUX_IDE_BIN=C:/Installer/MCUXpressoIDE_11.5.0_7232/ide/plugins/com.nxp.mcuxpresso.tools.bin.win32_11.5.0.202112161150/binaries/

%MCUX_IDE_BIN%/crt_emu_cm_redlink --flash-load-exec "%MCUX_WORKSPACE_LOC%/MorseSender/Debug/MorseSender.axf" -p LPC1549 --ConnectScript LPC15RunBootRomConnect.scp --vc --probeserial LSARBQDQ -CoreIndex=0 --flash-driver LPC15xx_256K.cfx -x "%MCUX_WORKSPACE_LOC%/MorseSender/Debug" --flash-hashing