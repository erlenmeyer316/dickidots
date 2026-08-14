#!/usr/bin/env bash

set -euo pipefail
# set prompt
ln -s ${HOME}/.config/bash/prompts.d/starship.sh ${HOME}/.config/bash/prompt.sh

# set terminal theme
ln -s ${HOME}/.config/bash/themes.d/dracula.sh ${HOME}/.config/bash/theme.sh
