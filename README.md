# Mac Setup

This repository contains a comprehensive setup script for configuring a new macOS environment for development. It automates the installation of applications, command-line tools, and sets up your shell and system settings.

## Features

- **Homebrew-Powered**: Uses a `Brewfile` to manage all Homebrew, Cask, and Mac App Store installations, making it easy to add or remove applications.
- **Modular & Idempotent**: The main setup script is broken down into logical functions and can be run multiple times without causing issues.
- **SSH Key Setup**: Automatically generates an SSH key and configures it for common Git providers.
- **Zsh Configuration**: Includes a well-structured `.zshrc` file with useful aliases, plugins, and a custom prompt.
- **macOS Defaults**: Sets sensible macOS defaults to improve the user experience.

## Prerequisites

- A fresh installation of macOS.
- An internet connection.

## How to Use

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/your-username/mac-setup.git
    cd mac-setup
    ```

2.  **Customize the `Brewfile` (Optional)**

    Open the `Brewfile` and add or remove any applications you want to install. The file is already populated with a solid set of development tools and applications.

3.  **Run the Setup Script**

    ```bash
    ./setup.sh
    ```

    The script will guide you through the following steps:

    *   Setting up your SSH key.
    *   Installing Xcode Command Line Tools.
    *   Installing Homebrew and all the packages listed in the `Brewfile`.
    *   Configuring your Git user name and email.
    *   Applying custom macOS settings.
    *   Backing up your existing `.zshrc` and replacing it with the one from this repository.

## Structure

-   **`setup.sh`**: The main script that orchestrates the entire setup process.
-   **`Brewfile`**: The single source of truth for all applications and tools to be installed via Homebrew.
-   **`config/.zshrc`**: The Zsh configuration file that will be copied to your home directory.

## Contributing

This is a personal setup script, but feel free to fork it and adapt it to your own needs. If you have suggestions for improvements, please open an issue or submit a pull request.
