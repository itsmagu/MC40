cd C:\MultiMC\instances\minepack-30\
git stash
git pull
Write-Host -Object ('press any key... ' -f [System.Console]::ReadKey().Key.ToString());
Write-Output 'press any key to exit'
