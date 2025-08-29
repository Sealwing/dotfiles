# ghostty
rm $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
ln -s ~/dotfiles/ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config 

# neovim
rm -r ~/.config/nvim
ln -s ~/dotfiles/nvim-cfg ~/.config/nvim

# zsh
rm -r ~/.zshrc
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
