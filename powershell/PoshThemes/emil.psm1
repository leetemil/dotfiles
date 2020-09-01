#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt = Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
    }

    # #check for elevated prompt
    # If (Test-Administrator) {
    #     $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor
    # }

    # $user = $sl.CurrentUser
    # if (Test-NotDefaultUser($user)) {
    #     $prompt += Write-Prompt -Object "$user " -ForegroundColor $sl.Colors.PromptForegroundColor
    # }

    # Writes the drive portion
    $prompt += Write-Prompt -Object "$(Get-ShortPath -dir $pwd) " -ForegroundColor $sl.Colors.Path

    $status = Get-VCSStatus
    # if ($status) {
    #     $themeInfo = Get-VcsInfo -status ($status)
        # $prompt += Write-Prompt -Object "git:" -ForegroundColor $sl.Colors.PromptForegroundColor
        # $prompt += Write-Prompt -Object "$($themeInfo.VcInfo) " -ForegroundColor $themeInfo.BackgroundColor
    # }

    # write virtualenv
    # if (Test-VirtualEnv) {
    #     $prompt += Write-Prompt -Object 'env:' -ForegroundColor $sl.Colors.PromptForegroundColor
    #     $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $themeInfo.VirtualEnvForegroundColor
    # }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    # Writes the postfixes to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $sl.Colors.ArrowColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x276F)
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x27A4)
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x1405)
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x00BB)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x003E)
# $s1.Colors.DriveForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.ArrowColor = [ConsoleColor]::Green
$sl.Colors.Path = [ConsoleColor]::DarkGray
$sl.Colors.PromptSymbolColor = [ConsoleColor]::White
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
