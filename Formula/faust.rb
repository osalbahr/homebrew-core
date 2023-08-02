class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.60.3/faust-2.60.3.tar.gz"
  sha256 "1088b31ad2a6175ff27807afc33c5929c33e97a7d09a1995e126bdda9940fc1e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6387dca087a6e2f68900ed571fc9f150f4d76e8adfb8f9236ddc32a74b7ba12"
    sha256 cellar: :any,                 arm64_monterey: "d2e5d073b745daac75adad48b4f7df552dd3447c9787f30ca1865d60b62d7e72"
    sha256 cellar: :any,                 arm64_big_sur:  "d9575401ec2b10ea2001dec0fd69879e3aae716e95420b12b5ad93fed08df08d"
    sha256 cellar: :any,                 ventura:        "e3f7fd4b3389906ff7da5bc3589c6af6db01a6ae2dee22dc3b95041e74545401"
    sha256 cellar: :any,                 monterey:       "a6f924997956ce405aa97fc72a0e0532b399b836d37b44e029ed3e37ed7344f2"
    sha256 cellar: :any,                 big_sur:        "c16fe1b50b58aebd3fde27f7d0aeb27584ec59aa4c91f45bf9db035b0c58786c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15535584735832b88f4144838f6853f15bbed013729e0fb858004921cff23f2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@14" # Needs LLVM 14 for `csound`.

  fails_with gcc: "5"

  def install
    ENV.delete "TMP" # don't override Makefile variable
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
