#! /run/current-system/sw/bin/nu

def setup [repo: string, parts: list<string>, --wsl]  {
  if not $wsl {
    print "this script only supports WSL setup"
    return
  }

  let config_dir = $"($env.HOME)/.config/"

  if not ($config_dir | path exists) {
    print $"Making ($config_dir)"
    mkdir $config_dir
  }

  $parts | each {|part| setup_part $repo $config_dir $part} 
}

def setup_part [repo: string, config_dir: string, part: string] {
  print $"Setting up ($part).."

  # aggressively(!) remove existing config
  remove_existing $"($config_dir)/($part)"
  ln --symbolic --force $"($repo)/($part)" $config_dir

  if $part == "nushell" {
    let cache_dir = $"($env.HOME)/.cache/carapace/"
    if not ($cache_dir | path exists) {
      mkdir $cache_dir
    }
    carapace _carapace nushell | save --force $"($cache_dir)/init.nu"
  }
}

def remove_existing [target: string] {
  let is_symlink = ($target | path type) == 'symlink'

  if $is_symlink {
    rm --verbose ($target | str trim --right --char '/')
  } else if ($target | path exists) {
    rm --verbose --recursive $target
  }
}

# actually do things
let repo_dir = $"($env.HOME)/repos/dotfiles"
setup --wsl $repo_dir ["nushell" "helix" "starship.toml"]
