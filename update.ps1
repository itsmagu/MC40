cd C:\MultiMC\instances\MC40\
git stash
git pull
Write-Host -Object ('press any key... ' -f [System.Console]::ReadKey().Key.ToString());
Write-Output 'press any key to exit'
