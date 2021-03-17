Import-Module posh-git
Import-Module oh-my-posh
Set-Theme emil

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

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
