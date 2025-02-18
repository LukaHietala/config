All config files and notes for setting up a new machine. Scripts are for debian-based systems and might need tweaks on other distros. Use at your own risk. Config files are as directories in this repo. Scripts are in this README.

- [Go](#go)
- [Fnm for Node.js](#fnm-for-nodejs)
- [Docker](#docker)
- [Git](#git)
- [Bun](#bun)
- [i3](#i3)
- [Bash](#bash)
- [Useful scripts and aliases](#useful-scripts-and-aliases)

### Scripts

#### Go

Requires sudo access. Downloads specified version of Go, extracts it, checks the SHA256 checksum, changes the owner of the extracted directory to root, and moves it to `/usr/local/go`. Also adds the Go binary to the PATH in the user's `.bashrc` file and sources it.

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

echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
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

cat << 'EOF' >> ~/.bashrc

# fnm
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
EOF
```

#### Docker

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

# Add gpg tty to bashrc
if [ -f ~/.bashrc ]; then
    echo -e '\nexport GPG_TTY=$(tty)' >> ~/.bashrc
fi
```

#### Bun

#### i3

#### Bash

#### Useful scripts and aliases
