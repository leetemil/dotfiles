Import-Module posh-git
Import-Module oh-my-posh
Set-Theme emil

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# nice command for fish-like completion, found here https://github.com/PowerShell/PSReadLine/issues/687
# pwsh.exe -noni -nop -c "iwr -useb https://git.io/InstallPSReadlineAutocompleteBeta.ps1 | iex

# Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# This command should update the powershell version to latest
# iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

Set-PSReadLineOption -Colors @{
    Command            = 'DarkGreen'
    Number             = 'Green'
    Member             = 'Red'
    Operator           = 'White'
    Type               = 'Gray'
    Variable           = 'DarkGreen'
    Parameter          = 'DarkYellow'
    ContinuationPrompt = 'Gray'
    Default            = 'Gray'
}
