class MarkdownQuicklook < Formula
  desc "Quick Look preview for Markdown files on macOS"
  homepage "https://github.com/mounta11n/markdown-quicklook"
  head "https://github.com/mounta11n/markdown-quicklook.git", branch: "main", using: :git

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Ensure submodules are initialized
    # Homebrew's HEAD clone doesn't always initialize submodules automatically
    unless File.directory?("PreviewMarkdown/.git")
      system "git", "submodule", "update", "--init", "--recursive"
    end
    
    # Verify submodule exists
    odie "PreviewMarkdown submodule not found" unless File.directory?("PreviewMarkdown")
    
    # Run the build script
    system "./build.sh"
    
    # Install to the Cellar
    app_dir = "#{Dir.home}/Applications"
    prefix.install Dir["#{app_dir}/PreviewMarkdown.app"]
    prefix.install Dir["#{app_dir}/QLToggle.app"]
  end

  def post_install
    # Register the apps with Launch Services
    system "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
           "-f", "#{prefix}/PreviewMarkdown.app"
    
    # Reset Quick Look cache
    system "qlmanage", "-r"
    system "qlmanage", "-r", "cache"
    
    ohai "markdown-quicklook installed!"
    ohai "Launch PreviewMarkdown and QLToggle manually from:"
    ohai "  #{prefix}/PreviewMarkdown.app"
    ohai "  #{prefix}/QLToggle.app"
    ohai "Or use: open #{prefix}/PreviewMarkdown.app && open #{prefix}/QLToggle.app"
  end

  def caveats
    <<~EOS
      markdown-quicklook has been installed to:
        #{prefix}

      To start using the Quick Look extension:
        1. Open PreviewMarkdown:   open #{prefix}/PreviewMarkdown.app
        2. Open QLToggle:          open #{prefix}/QLToggle.app
        3. Press Space on any .md file in Finder to see rendered Markdown

      After macOS or Xcode updates, reinstall with:
        brew reinstall markdown-quicklook
    EOS
  end

  test do
    assert_predicate prefix/"PreviewMarkdown.app", :exist?
    assert_predicate prefix/"QLToggle.app", :exist?
  end
end
