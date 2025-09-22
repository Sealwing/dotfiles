if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected"
    if [[ -z "$XDG_CONFIG_HOME" ]]; then
        GHOSTTY_CONFIG="$HOME/ghostty/config"
    else
        GHOSTTY_CONFIG="$XDG_CONFIG_HOME/ghostty/config"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS detected"
    GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
else
    echo "Can't detect platfor / no settings for it"
    echo "Exiting"
    exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"
echo "DOTFILES detected in $DOTFILES_DIR"

GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty/config"
NEOVIM_SOURCE="$DOTFILES_DIR/nvim-cfg"
ZSH_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
TMUX_SOURCE="$DOTFILES_DIR/tmux/.tmux.conf"

link_config () {
    local NAME=$1
    local SOURCE_CONFIG=$2
    local TARGET_CONFIG=$3

    echo "Configuring $NAME"

    echo "Removing $TARGET_CONFIG"
    rm -r "$TARGET_CONFIG"

    echo "Linking configuration from $SOURCE_CONFIG to $TARGET_CONFIG"
    ln -s "$SOURCE_CONFIG" "$TARGET_CONFIG"
    echo "---------------------------------------------------------------"
}

echo "---------------------------------------------------------------"
link_config ghostty "$GHOSTTY_SOURCE" "$GHOSTTY_CONFIG"
link_config neovim "$NEOVIM_SOURCE" "$HOME/.config/nvim"
link_config zsh "$ZSH_SOURCE" "$HOME/.zshrc"
link_config tmux "$TMUX_SOURCE" "$HOME/.tmux.conf" 
