class Edit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d91205513b245bf4ed1127c35d148cac4f7dafd22b071fe3443d080bbda4b9ef"
  license "MIT"

  depends_on "rust" => :build

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    PTY.spawn(bin/"edit", "test.txt") do |r, w, pid|
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0013" # Ctrl+S
      sleep 1
      w.write "\u0011" # Ctrl+Q
      sleep 1
    end

    assert_match "test data", (testpath/"test.txt").read
  end
end
