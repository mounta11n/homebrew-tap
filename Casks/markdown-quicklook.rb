# This cask is for pre-built releases of markdown-quicklook
# To use this:
# 1. Build locally: cd markdown-quicklook && ./build.sh
# 2. Create ZIP: cd ~/Applications && zip -r markdown-quicklook-v1.0.0.zip PreviewMarkdown.app QLToggle.app
# 3. Upload to GitHub release: https://github.com/mounta11n/markdown-quicklook/releases
# 4. Update url and sha256 below

cask "markdown-quicklook" do
  version "1.0.0"
  sha256 :no_check  # Replace with actual SHA256 after creating release

  url "https://github.com/mounta11n/markdown-quicklook/releases/download/v#{version}/markdown-quicklook-v#{version}.zip"
  name "Markdown QuickLook"
  desc "Quick Look preview for Markdown files on macOS"
  homepage "https://github.com/mounta11n/markdown-quicklook"

  depends_on macos: ">= :ventura"

  app "PreviewMarkdown.app"
  app "QLToggle.app"

  postflight do
    # Register the Quick Look extension
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/PreviewMarkdown.app"]
    
    # Reset Quick Look cache
    system_command "/usr/bin/qlmanage",
                   args: ["-r"],
                   print_stderr: false
  end

  uninstall quit: [
    "com.local.PreviewMarkdown",
    "com.local.QLToggle",
  ]

  zap trash: [
    "~/Library/Preferences/com.local.PreviewMarkdown.plist",
    "~/Library/Preferences/com.local.QLToggle.plist",
  ]

  caveats <<~EOS
    To start using markdown-quicklook:
    1. Open PreviewMarkdown.app (it will register the Quick Look extension)
    2. Open QLToggle.app (adds menu bar toggle)
    3. Press Space on any .md file in Finder to see rendered Markdown

    After macOS or Xcode updates, you may need to reinstall:
      brew reinstall --cask markdown-quicklook
  EOS
end
