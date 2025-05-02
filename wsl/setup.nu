def clone_repo [url: string, repo: string] {
  if ($repo | path exists) {
    print $"($repo) already exists; exiting"
    return
  }

  mkdir $repo
  git clone $'($url)' $'($repo)'
}

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

  ln --symbolic --force $"($repo)/($part)" --target-directory $config_dir

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

let repo_url = "https://github.com/leetemil/dotfiles.git"
let repo_dir = $"($env.HOME)/repos/dotfiles"

clone_repo  $repo_url $repo_dir
setup --wsl $repo_dir ["nushell" "helix" "starship.toml"]
