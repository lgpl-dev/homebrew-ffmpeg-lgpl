I can do that. Here's the README in English.

# 🚀 Homebrew LGPL FFmpeg

This repository provides a Homebrew formula for an LGPL-licensed version of FFmpeg. While the official Homebrew core version includes GPL-licensed components, this tap offers a build that adheres to the LGPL license, making it a great choice for projects with LGPL requirements.

You can find the official `ffmpeg` formula from the Homebrew core repository [here](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/f/ffmpeg.rb).

-----

### ✨ Installation

To install `ffmpeg-lgpl`, first tap this repository and then run the installation command.

```bash
brew tap lgpl-dev/ffmpeg-lgpl
brew install ffmpeg-lgpl
```

-----

### 🗑️ Uninstallation

To uninstall `ffmpeg-lgpl`, use the following commands.

```bash
brew uninstall ffmpeg-lgpl
brew untap lgpl-dev/ffmpeg-lgpl
```

-----

### 🛠️ How It Works

This formula is based on the official `ffmpeg` formula from the Homebrew core repository. We apply a patch to the official formula to change the build options, ensuring compatibility with the LGPL license.

### 🤖 Automated Workflow

This repository leverages GitHub Actions to **keep itself up to date automatically**.

1.  **Scheduled Checks**: Our workflow automatically checks for new versions of the official `ffmpeg` formula on a daily schedule.
2.  **Automated Builds**: When a new version is detected, GitHub Actions kicks off an automated build of the LGPL-compliant version.
3.  **Binary Release**: Once the build is complete, the binary bottle is uploaded to GitHub Releases. The new `sha256` checksum is then automatically written back to the formula file.

Thanks to this process, you can always get the latest LGPL-compliant FFmpeg version with a simple `brew install` command.

-----

### 📝 Patch Details

The `gpl2lgpl.patch` file is created by comparing the official `ffmpeg.rb` with our formula.

```bash
diff -u ffmpeg.rb ffmpeg-lgpl.rb > gpl2lgpl.patch
```

To apply the patch to a new `ffmpeg.rb` file, use this command.

```bash
patch -o ffmpeg-lgpl.rb ffmpeg.rb gpl2lgpl.patch
```

-----

### 🤝 Contribution

We welcome your contributions\! If you find any issues or have suggestions, please feel free to open a new issue or a pull request. Let's work together to make this project even better. 💪
