class Hyfetch < Formula
  desc "Maintained fork of Neofetch"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/hykilpikonna/hyfetch/archive/refs/tags/1.4.10.tar.gz"
  sha256 "a8988b081c79a4a80d92262e3588fab1ad7f890ff6dbfb4ed76f697be1f8d903"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git", branch: "master"

  on_macos do
    depends_on "screenresolution"
  end

  conflicts_with "neofetch", because: "both install `neofetch` binary"

  def install
    inreplace "neofetch", "/usr/local", HOMEBREW_PREFIX
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
