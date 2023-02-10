#! /bin/sh

# TODO reinstall fiirefox using brew

# install GRPC client

# install DB

#init yabai
# sudo yabai --install-sa
# brew services start koekeishiya/formulae/yabai
# brew services start skhd

# https://gist.github.com/cooperpellaton/4d76ef3afdc78018af89dd6963d02481#file-bootstrap-brew-sh
# https://gist.github.com/toonetown/48101686e509fda81335
# https://github.com/thoughtbot/laptop/blob/master/mac

# vscode
echo 'Manually sync settings for vsCode'

# intellj
echo 'Manually sync settings for IntellJ'

# ------------------------------------------------------------

fancy_echo() {
  local fmt="$1"; shift
  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

config_homebrew() {
  xcode-select --install
  if test ! $(which brew); then
      echo "Installing homebrew..."
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

config_shell() {
  local shell_path;
  shell_path="$(command -v zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  if [ ! ${SHELL} = "/bin/zsh" ] ; then
    sudo chsh -s "$shell_path" "$USER"
  fi
}

config_oh_my_zsh() {
  if [ ! -d "${HOME}/.oh-my-zsh" ] 
  then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    fancy_echo "Oh-my-zsh already installed"
  fi

  autosuggest_folder="${HOME}/.config/zsh/plugins/zsh-autosuggestions"
  if [ ! -d "${autosuggest_folder}" ] 
  then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${autosuggest_folder}
  else
    fancy_echo "zsh-autosuggestions already installed"
  fi

  syntax_highlight_folder="${HOME}/.config/zsh/plugins/zsh-syntax-highlighting"
  if [ ! -d "${syntax_highlight_folder}" ] 
  then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${syntax_highlight_folder}
  else
    fancy_echo "zsh-autosuggestions already installed"
  fi
}

config_SDKMAN() {
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java 8.0.275-amzn
  sdk install maven
  sdk install gradle
  sdk install springboot
}

# currently interactive in order to generate a new profile
config_firefox() {
  echo "------------------------------------------"
  echo "Start firefox and login to firefox-account"
  echo "in order to generate a new profile folder "
  echo "------------------------------------------"

  read -n 1 -s -r -p "Press any key to continue"
  echo "\n"

  ff_cfg_path="${HOME}/Library/Application Support/Firefox/"
  ff_profile=${ff_cfg_path}$(cat "${ff_cfg_path}installs.ini" | sed -n -e 's/^.*Default=//p' | head -n 1)
  
  if [ ! -f "${ff_profile}/user.js" ]; then
    ln -s "${HOME}/.config/firefox/user.js" "${ff_profile}/user.js"
  fi

  if [ ! -d "${ff_profile}/chrome" ]; then
    ln -s "${HOME}/.config/firefox/chrome" "${ff_profile}/chrome"
  fi
}

config_cmd_insulter() {
  cif="${HOME}/.config/bash-insulter"
  #git clone https://github.com/hkbakke/bash-insulter.git $cif
  sudo cp $cif/src/bash.command-not-found /etc/
}

config_crontab() {
  crontab -l | grep -q 'search string'  && echo 'entry exists' || (crontab -l 2>/dev/null; echo "@reboot sleep 10 && ~/.config/cron/autostart") | crontab -
}

config_yabai() {
  sudo yabai --install-sa 
  sudo yabai --load-sa
  sudo visudo -f /private/etc/sudoers.d/yabai
  # echo in this code:
  # sudo yabai --load-sa
  # yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

  brew services start yabai
  brew services start skhd
}

# crontab @reboot path/to/script https://unix.stackexchange.com/questions/49207/how-do-i-set-a-script-that-it-will-run-on-start-up-in-freebsd
update_shell
config_oh_my_zsh
#config_SDKMAN
#setup_homebrew
config_shell
config_cmd_insulter
#config_crontab



