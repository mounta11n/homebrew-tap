# mounta11n's Homebrew Tap

Personal Homebrew tap for macOS utilities and tools.

## ⚠️ Known Issue: Sandbox Limitation

**Homebrew's sandbox blocks xcodebuild from resolving Swift Package dependencies.** 
This means `brew install --HEAD markdown-quicklook` currently fails during the build.

### Workaround: Manual Build + Install Script

Until this is resolved, please build manually:

```bash
# Clone and build
git clone --recursive https://github.com/mounta11n/markdown-quicklook.git
cd markdown-quicklook
./build.sh

# The apps are now in ~/Applications/
# To register them with Homebrew (optional):
brew tap mounta11n/tap
```

### Alternative: Create a Release with Pre-built Apps

If you want true Homebrew automation, you can create a GitHub release:

1. Build locally: `./build.sh`
2. Create a ZIP: `cd ~/Applications && zip -r markdown-quicklook.zip PreviewMarkdown.app QLToggle.app`
3. Create a GitHub release and upload the ZIP
4. Update the formula with the release URL and SHA256

---

## Installation (once sandbox issue is resolved)

Tap this repository:

```bash
brew tap mounta11n/tap
```

## Available Formulas

### markdown-quicklook

Quick Look preview for Markdown files on macOS. Renders `.md` files beautifully in Finder's Quick Look (press Space).

**Installation:**

```bash
brew install --HEAD markdown-quicklook
```

> Note: This formula requires `--HEAD` because it needs Git submodules for building.

**Usage:**
1. The formula automatically builds and installs the apps
2. Launch PreviewMarkdown and QLToggle (see installation output for paths)
3. Press Space on any `.md` file in Finder to see rendered Markdown
4. Use the menu bar icon to toggle between rendered and plain text modes

**Updating:**

After a macOS or Xcode update, reinstall to rebuild:

```bash
brew reinstall markdown-quicklook
```

For regular updates from the repository:

```bash
brew update
brew upgrade markdown-quicklook
```

## Development

To test formulas locally before pushing:

```bash
brew install --build-from-source ./Formula/markdown-quicklook.rb
```

## License

Individual formulas may have their own licenses. See each formula for details.
