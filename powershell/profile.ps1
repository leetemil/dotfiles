Import-Module posh-git
Import-Module PSReadLine
Import-Module PSFzf
Import-Module DockerCompletion

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardWord

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# fish-like autocomplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionSource History

# Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

Set-PSReadLineOption -Colors @{
    Command = 'DarkGreen'
    Number = 'Green'
    Member = 'Red'
    Operator = 'White'
    Type = 'Gray'
    Variable = 'DarkGreen'
    Parameter = 'DarkYellow'
    ContinuationPrompt = 'Gray'
    Default = 'Gray'
    # Prediction = 'DarkGray'
}

function touch {
    param ([string] $filename)
    Write-Host "" >> $filename
    # New-Item -Path . -Name "$filename" -ItemType "file" -Value ""
}

# Use bat instead of cat
Set-Alias -Name cat -Value bat
Set-Alias -Name tf -Value terraform
# vim is actually neovim
Set-Alias -Name vim -Value nvim
# you probably want to use 'wsl' instead of 'bash', as wsl runs the default shell (i.e. it can run zsh directly)
Set-Alias -Name bash -Value wsl

# a variable for the nvim config
Set-Variable -Name "vimconfig" -Value "~\AppData\Local\nvim\init.vim"

# gh autocompletion --  as of 2021-02-24 doesnt really work
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# use starship prompt
Invoke-Expression (&starship init powershell)
