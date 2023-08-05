class Linklint < Formula
  desc "Link checker and web site maintenance tool"
  homepage "http://linklint.org"
  url "http://linklint.org/download/linklint-2.3.6.d.tar.gz"
  sha256 "05c2aee1c530af566ef67857fc6b052abb3521d54318749375f8c4a092cd3dea"

  livecheck do
    url "http://linklint.org/download.html"
    regex(/href=.*?linklint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef392eb8173eedd8caad7b9ac1d3aa0354fe9aeec2c6fe902b02bf1e9966518a"
  end

  def install
    mv "READ_ME.txt", "README"

    doc.install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    (testpath/"index.html").write('<a href="/">Home</a>')
    system "#{bin}/linklint", "/"
  end
end
