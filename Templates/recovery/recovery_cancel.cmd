REM recovery_cancel.cmd

call setdrives.cmd

REM Make sure drive letters are available (using removal script), then assign drive letters
call diskpart /s diskpart_remove.txt >>%WINDIR%\system32\diskpart_remove_log.txt
call diskpart /s diskpart_assign.txt >>%WINDIR%\system32\diskpart_assign_log.txt
set RECOVERYDRIVE=%DL_MMOS%
set EFIDRIVE=%DL_EFIESP%

REM Initialize logging
set RECOVERY_LOG_FOLDER=%RECOVERYDRIVE%:\recoverylogs
md %RECOVERY_LOG_FOLDER%
echo --- Device recovery initiated --- >>%RECOVERY_LOG_FOLDER%\recovery_log.txt
call date /t >>%RECOVERY_LOG_FOLDER%\recovery_log.txt
call time /t >>%RECOVERY_LOG_FOLDER%\recovery_log.txt
copy %WINDIR%\system32\winpeshl.log %RECOVERY_LOG_FOLDER%
copy %WINDIR%\system32\diskpart_assign_log.txt %RECOVERY_LOG_FOLDER%
copy %WINDIR%\system32\diskpart_remove_log.txt %RECOVERY_LOG_FOLDER%

echo Recovery cancelled by user. Returning to MainOS >>%RECOVERY_LOG_FOLDER%\recovery_log.txt

REM Go back to MainOS on next boot
echo Setting bootsequence to MainOS. >>%RECOVERY_LOG_FOLDER%\recovery_log.txt
bcdedit /store %EFIDRIVE%:\EFI\microsoft\boot\bcd /set {bootmgr} bootsequence {01de5a27-8705-40db-bad6-96fa5187d4a6} >>%RECOVERY_LOG_FOLDER%\recovery_log.txt

echo --- Device recovery completed --- >>%RECOVERY_LOG_FOLDER%\recovery_log.txt

REM Remove extra drive letters
call diskpart /s diskpart_remove.txt

REM Restart system
wpeutil reboot