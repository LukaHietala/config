All config files and notes for setting up a new machine. Scripts are for debian-based systems and might need tweaks on other distros. Use at your own risk. Config files are as directories in this repo. Scripts are in this README.

- [Go](#go)
- [Fnm for Node.js](#fnm-for-nodejs)
- [Docker](#docker)
- [Neovim](#neovim)
- [Cargo](#cargo)
- [Alacritty](#alacritty)
- [Ripgrep (rg)](#ripgrep-rg)
- [Fd (fd-find)](#fd-fd-find)
- [Git](#git)
- [Bun](#bun)
- [i3](#i3)
- [SDL3](#sdl-3)
- [Useful scripts and aliases](#useful-scripts-and-aliases)
- [LSP Servers](#lsp-servers)
  - [lua_ls](#lua)
  - [gopls](#go)

### Scripts

#### Go

Downloads specified version of Go, extracts it, checks the SHA256 checksum, changes the owner of the extracted directory to root, and moves it to `/usr/local/go`. Also adds the Go binary to the PATH in the user's `.bashrc` file and sources it.

```bash
#!/bin/bash
set -euo pipefail

VERSION="1.24.0"
ARCH="amd64"
FILE="go${VERSION}.linux-${ARCH}.tar.gz"

curl -O -L "https://golang.org/dl/${FILE}"
if [ ! -f "${FILE}" ]; then
  echo "Error: ${FILE} was not downloaded successfully" >&2
  exit 1
fi

html=$(curl -sL https://golang.org/dl/)
checksum=$(echo "$html" | grep -A 5 -w "${FILE}" | grep -oP '<tt>\K[a-f0-9]{64}(?=</tt>)')

if [ -z "${checksum}" ]; then
  echo "Error: Failed to extract checksum" >&2
  exit 1
fi

echo "SHA256 checksum: ${checksum}"

echo -n "${checksum} *${FILE}" | shasum -a 256 --check

tar -xf "${FILE}"

sudo chown -R root:root ./go
sudo mv -v go /usr/local
```

#### Fnm for Node.js

Node version manager. [Github](https://github.com/Schniz/fnm)

```bash
#!/bin/bash
FNM_PATH="${HOME}/.local/share/fnm"

curl -fsSL https://fnm.vercel.app/install | bash
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
```

#### Docker

#### Cargo

```bash
curl https://sh.rustup.rs -sSf | sh
```

#### Alacritty

```bash
# install deps and clone the repo
sudo apt install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
git clone https://github.com/alacritty/alacritty.git
cd alacritty

# build and install
rustup override set stable
rustup update stable
cargo build --release

# install terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
infocmp alacritty

# copy binary to PATH and desktop file
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
```

#### Neovim

From source

```bash
sudo apt-get install ninja-build gettext cmake curl build-essential
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd .. && rm -rf neovim
cd ~/.config && mkdir nvim
cd nvim && touch init.lua
```

LuaRocks

```bash
sudo apt install build-essential libreadline-dev unzip
curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -zxf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test
sudo make install
```

#### Ripgrep (rg)

```bash
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
```

#### Fd (fd-find)

```bash
# create a dir for the binary in ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin
# add the binary to the PATH
sudo apt-get install fd-find
ln -s $(which fdfind) ~/.local/bin/fd
```

#### Git

Git with GPG commit verification.

```bash
# Set up Git user details
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com

# Optionally store HTTPS credentials
git config --global credential.helper store

## GPG Commit Verification

# Generate a GPG key (install GPG: https://gnupg.org/download/)
gpg --full-generate-key

# List GPG keys (LONG format)
gpg --list-secret-keys --keyid-format LONG

# Export your public key (<GPG_KEY_ID>)
gpg --armor --export <GPG_KEY_ID>
# Add it to GitHub: https://github.com/settings/keys

# Set Git to sign commits/tags with your GPG key
git config --global user.signingkey <GPG_KEY_ID>
git config --global gpg.program gpg

# Enable signing by default
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```

#### Bun

```bash
curl -fsSL https://bun.sh/install | bash
```

#### i3

#### SDL 3

```bash
git clone https://github.com/libsdl-org/SDL.git -b release-3.2.x
cd SDL
cmake -S . -B build
cmake --build build
sudo cmake --install build --prefix /usr/local
```

#### Useful scripts and aliases

```bash
# Copy command output to clipboard
alias cs='xclip -selection clipboard'

# Paste clipboard content
alias vs='xclip -o -selection clipboard'

# Bluetoothctl aliases
alias bl='bluetoothctl connect <MAC_ADDRESS>'
alias bd='bluetoothctl disconnect <MAC_ADDRESS>'
alias bp='bluetoothctl pair <MAC_ADDRESS>'

# Bluetoothctl for bad connections

MAC_ADDRESS="<MAC_ADDRESS>"

bluetoothctl remove "${MAC_ADDRESS}"
bluetoothctl power off
bluetoothctl power on

bluetoothctl scan on

bluetoothctl pair "${MAC_ADDRESS}"
bluetoothctl trust "${MAC_ADDRESS}"
bluetoothctl connect "${MAC_ADDRESS}"
```

### LSP Servers

Lsp servers mainly for Neovim.

#### Lua (lua_ls)

```bash
apt-get install ninja-build
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
ln -s bin/lua-language-server ~/.local/bin/lua-language-server
```

Vim globals for `lua-language-server`

```lua
dependencies = {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
		  library = {
		    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
		  },
		},
	},
},
```

#### Go (gopls)

https://pkg.go.dev/golang.org/x/tools/gopls#section-readme

```bash
go install golang.org/x/tools/gopls@latest
ln -s $(which gopls) ~/.local/bin/gopls
```
