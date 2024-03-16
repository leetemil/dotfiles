$env.STARSHIP_SHELL = "nu"

# mkdir ~/.cache/carapace
# carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH, you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

$env.GPG_TTY = $"(tty)"
$env.XGD_CURRENT_DESKTOP = 'sway'
$env.EDITOR = 'helix'

$env.PATH = (
    $env.PATH | split row (char esep)
        | append '/opt/cinc-workstation/bin'
        | append '/opt/cinc-workstation/embedded/bin'
        | prepend '/home/emp/.local/bin'
        | prepend $"(go env GOPATH)/home/emp/.local/bin"
        | prepend '/home/linuxbrew/.linuxbrew/bin'
        | prepend '/home/emp/.asdf/installs/golang/1.21.1/packages/bin'
)

# magic spell to make default aws credentials variables
open ~/.aws/credentials
    | lines
    | reduce --fold {lines: [], default: 0} {|line, acc|
            # we've hit the default section for the first time; start appending
            if (($line | str starts-with "[default]") and ($acc.default == 0)) {
                $acc | upsert default ($acc.default + 1)
            # we've hit a section that is not default; stop appending
            } else if (($line | str starts-with "[") and ($acc.default == 1)) {
                $acc | upsert default ($acc.default + 1)
            # otherwise, continue appending, if we're doing that
            } else if ($acc.default == 1) {
                $acc | upsert lines ($in.lines | append $line)
            # or just move to next line
            } else {
                $acc
            }
        }
    | get lines
    | grep aws # throw away region, endpoint_url, etc.
    | parse -r '(?<key>\w+)\s*=\s*(?<value>\w+)'
    | reduce --fold {} {|it, acc| $acc | upsert $it.key $it.value }
    | load-env
