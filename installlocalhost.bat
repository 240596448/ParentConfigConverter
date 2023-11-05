@echo off
OSPX_DIR=temp_ospx
md %OSPX_DIR% 2> nul
del %OSPX_DIR%\*.ospx
opm build -m ./packagedef -o ./%OSPX_DIR%/
opm install -f ./%OSPX_DIR%/*.ospx
rd \S \Q %OSPX_DIR% 2> nul
echo "Installation completed successfully..."
