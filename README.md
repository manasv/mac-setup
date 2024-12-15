# My Setup Script

This repository contains a setup script for configuring a development environment on macOS. The script automates the installation of essential tools, configuration of shell settings, and setup of SSH keys for version control platforms.

## Features

- Installs Homebrew and essential CLI tools
- Configures Zsh with custom settings and plugins
- Sets up SSH keys for Git (Feel free to customize the providers)
- Configures macOS settings for a better user experience

## Prerequisites

- macOS
- Internet connection

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/manasv/mac-setup.git
   cd mac-setup
   ```

2. Make the setup script executable:

   ```sh
   chmod +x setup.sh
   ```

3. Run the setup script:

   ```sh
   ./setup.sh
   ```

## Usage

- Follow the prompts in the setup script to enter your SSH key comment and name.
- The script will create an SSH key and configure your SSH settings for GitHub and Bitbucket.
- It will also copy the Zsh configuration from the `config/.zshrc` file to your home directory.

## Configuration Files

- **`config/.zshrc`**: Contains custom Zsh settings and aliases.