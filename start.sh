#!/bin/bash

function pause(){
	read -p "$*"
}

function cprec(){
	if [[ -d "$1" ]]; then
		if [[ ! -d "$2" ]]; then
			sudo mkdir -p "$2"
		fi

		for i in $(ls -A "$1"); do
			cprec "$1/$i" "$2/$i"
		done
	else
		sudo cp "$1" "$2"
	fi
}

echo
PS3='Please enter your choice: '
options=("Install and update Rust" "Update Rust" "Build and run Wekan" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install and update Rust")

		if [[ "$OSTYPE" == "linux-gnu" ]]; then
	                echo "Linux";
			# Debian, Ubuntu, Mint
			sudo apt-get install -y build-essential git curl wget
			curl https://sh.rustup.rs -sSf | sh
		elif [[ "$OSTYPE" == "darwin"* ]]; then
		        echo "macOS";
			pause '1) Install XCode 2) Press [Enter] key to continue.'
			curl https://sh.rustup.rs -sSf | sh
		elif [[ "$OSTYPE" == "cygwin" ]]; then
		        # POSIX compatibility layer and Linux environment emulation for Windows
		        echo "TODO: Add Cygwin";
			exit;
		elif [[ "$OSTYPE" == "msys" ]]; then
		        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
		        echo "TODO: Add msys on Windows";
			exit;
		elif [[ "$OSTYPE" == "win32" ]]; then
		        # I'm not sure this can happen.
		        echo "TODO: Add Windows";
			exit;
		elif [[ "$OSTYPE" == "freebsd"* ]]; then
		        echo "TODO: Add FreeBSD";
			exit;
		else
		        echo "Unknown"
			echo ${OSTYPE}
			exit;
		fi

		# Add Rust settings to .bashrc
		echo "export PATH=$HOME/.cargo/bin:$PATH" >> ~/.bashrc
		echo "source $HOME/.cargo/env" >> ~/.bashrc

		# Add Rust settings to current shell
                export PATH=$HOME/.cargo/bin:$PATH
                source $HOME/.cargo/env

		# Update Rust
		echo "Updating Rust"
		rustup self update
		rustup toolchain uninstall stable
		rustup toolchain install stable
		rustup default stable
		echo "Installing and Updating Rust Done."
		break
		;;
	"Update Rust")
                # Update Rust
                echo "Updating Rust."
                rustup self update
                rustup toolchain uninstall stable
                rustup toolchain install stable
                rustup default stable
                echo "Updating Rust Done."
                break
                ;;
        "Build and run Wekan")
		echo "Building and running Wekan."
		cargo run
		echo "Building and running Wekan Done."
		break
		;;
        "Quit")
		break
		;;
        *) echo invalid option;;
    esac
done
