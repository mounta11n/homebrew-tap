class MarkdownQuicklook < Formula
  desc "Quick Look preview for Markdown files on macOS"
  homepage "https://github.com/mounta11n/markdown-quicklook"
  head "https://github.com/mounta11n/markdown-quicklook.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Homebrew copies HEAD repos to build dir without proper submodule structure
    # We need to manually clone the submodule if it's not properly initialized
    pm_dir = buildpath/"PreviewMarkdown"
    
    if !File.directory?(pm_dir/"PreviewMarkdown.xcodeproj")
      # Submodule content is missing - clone it directly
      ohai "Cloning PreviewMarkdown submodule..."
      rm_rf pm_dir
      system "git", "clone", "--depth", "1",
             "https://github.com/smittytone/PreviewMarkdown.git",
             pm_dir.to_s
    end
    
    # Verify submodule exists
    odie "PreviewMarkdown not found after clone" unless File.directory?(pm_dir/"PreviewMarkdown.xcodeproj")
    
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
