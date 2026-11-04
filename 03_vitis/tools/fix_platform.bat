@echo off
REM 换 XSA / Clean 之前跑一下: 修平台里所有会被重新生成的 Makefile
python -I "%~dp0fix_platform_makefiles.py" %*
