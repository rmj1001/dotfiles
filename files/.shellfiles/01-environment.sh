#!/bin/bash

################################## ENVIRONMENT #################################

# Default Editor
# (checks for each editor, if proceeding editor exists then default is changed)
[[ -f "$(command -v nano)" ]] && EDITOR="$(command -v nano)"
[[ -f "$(command -v nvim)" ]] && EDITOR="$(command -v nvim)"
[[ -f "$(command -v code)" ]] && EDITOR="$(command -v code)"
[[ -f "$(command -v micro)" ]] && EDITOR="$(command -v micro)"
export EDITOR

# Default Browser
[[ -x "$(command -v firefox)" ]] && BROWSER="$(command -v firefox)"
[[ -x "$(command -v microsoft-edge)" ]] &&
    BROWSER="$(command -v microsoft-edge)"
export BROWSER

# Default Authentication
# (sudo is default, if doas exists then it becomes default)
[[ -x "$(command -v sudo)" ]] && AUTH="$(command -v sudo)"
[[ -x "$(command -v doas)" ]] && AUTH="$(command -v doas)"
export AUTH

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"

# Trash
export TRASH="${XDG_DATA_HOME}/Trash/files"

# Environment Variables
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LESSCHARSET="utf-8"
export SNAPS="/snap/bin"
export GNUPGHOME="${HOME}/.gnupg"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"   # Rust
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup" # Rust
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export ANDROID_HOME="${XDG_DATA_HOME}/android-sdk"
export MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
export QT_QPA_PLATFORMTHEME="qt5ct"
export SSH_KEY_PATH="${HOME}/.ssh/id_rsa"
# GPG authorization
GPG_TTY="$(tty)"
export GPG_TTY

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# User Scripts/AppImages
export SYSTEM32="${HOME}/System32"
export SCRIPTS="${SYSTEM32}"
export BIN="${HOME}/.local/bin"
export APPIMAGES="${HOME}/Apps"

# Update PATH with script paths and AppImages
export PATH=${PATH}:${SYSTEM32}:${BIN}:${APPIMAGES}

# Developer Language Paths
export GOPATH="${XDG_DATA_HOME}/go:${HOME}/Bin/projects/golang"
export HOMEBREW="/home/linuxbrew/.linuxbrew/bin"
export DENO_INSTALL="/home/roy/.deno"
export FLATPAK_ENABLE_SDK_EXT=rust-stable,php74,openjdk,node16,mono6,dotnet,haskell,golang

# RUST lang paths
export RUSTUP_HOME="${HOME}/.local/share/rustup"
export CARGO_HOME="${HOME}/.local/share/cargo"
export RUST_BIN="${HOME}/.local/share/cargo/bin"

# FNM (node manager)
export FNM_MULTISHELL_PATH="/tmp/fnm_multishells/36217_1631124687204"
export FNM_DIR="/home/roy/.fnm"
export FNM_LOGLEVEL="info"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_ARCH="x64"

# Conditional PATH additions (Developer Languages)
[[ -z "${RUST_BIN}" ]] || PATH="${PATH}:${RUST_BIN}"
[[ -z "${GOPATH}" ]] || PATH="${PATH}:${GOPATH}/bin"
[[ -z "${HOMEBREW}" ]] || PATH="${PATH}:${HOMEBREW}"
[[ -z "${DENO_INSTALL}" ]] || PATH="${PATH}:${DENO_INSTALL}/bin"
[[ -z "${FNM_MULTISHELL_PATH}" ]] || PATH="${PATH}:${FNM_MULTISHELL_PATH}/bin"

export PATH