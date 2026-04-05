#!/bin/sh

echo -e "${GREEN} Creating .local/share ~${NC}"
mkdir -p ~/.local/share

if [ ! -f ~/.zshrc ]; then
  echo -e "${GREEN}.zshrc file not found, not deleting ${NC}"
else
  rm ~/.zshrc
fi

echo -e "${GREEN}Copy system config files... ${NC}"
cp -r applications ~/.local/share/

cp -r dotfiles/.* ~/
