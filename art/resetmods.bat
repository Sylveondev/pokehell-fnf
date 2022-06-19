@echo off
color 1f
echo ***************************************************
echo *                                                 *
echo ***************************************************
echo * Are you sure you want to reset the mods folder? *
echo * If you opened this by mistake, simply close the *
echo * window. Otherwise press any button to clear the *
echo *                 mods folder.                    *
echo ***************************************************
pause
cls
echo Deleting the mods folder..
rd mods /s /q
IF %ERRORLEVEL% NEQ 0 (
  color 4f
  echo "Failed to clear the mods folder."
  pause
  exit %ERRORLEVEL%
)
echo Extracting the mods folder..
tar -xf assets/mods.zip
IF %ERRORLEVEL% NEQ 0 (
  color 4f
  echo "Failed to clear the mods folder."
  pause
  exit %ERRORLEVEL%
)
echo Done.
pause