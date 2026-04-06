# mounta11n's Homebrew Tap

Personal Homebrew tap for macOS utilities and tools.

## Installation

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
