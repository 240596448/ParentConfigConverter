@echo off
SET OSPX_DIR=temp_ospx
md %OSPX_DIR% 2> nul
del %OSPX_DIR%\*.ospx 2> nul
call opm build -m ./packagedef -o ./%OSPX_DIR%/
call opm install -f ./%OSPX_DIR%/*.ospx
del %OSPX_DIR%\*.ospx
rd %OSPX_DIR%
echo Installation completed successfully...
