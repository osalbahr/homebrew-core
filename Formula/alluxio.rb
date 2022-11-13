class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.9.0/alluxio-2.9.0-bin.tar.gz"
  sha256 "9d31364538938031c618e3ffafdd2da8aa62b08e0c9e6710cce544eebd829690"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab0727c7081dd1db69d14d83aa0074d00ba7c5166cf11a213ebac08d843323d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab0727c7081dd1db69d14d83aa0074d00ba7c5166cf11a213ebac08d843323d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ab0727c7081dd1db69d14d83aa0074d00ba7c5166cf11a213ebac08d843323d"
    sha256 cellar: :any_skip_relocation, monterey:       "841697122a0ff55545e065ba3ded610ae839bacdc80fb95f6cf77adb34b331a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "841697122a0ff55545e065ba3ded610ae839bacdc80fb95f6cf77adb34b331a5"
    sha256 cellar: :any_skip_relocation, catalina:       "841697122a0ff55545e065ba3ded610ae839bacdc80fb95f6cf77adb34b331a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ab0727c7081dd1db69d14d83aa0074d00ba7c5166cf11a213ebac08d843323d"
  end

  # Alluxio requires Java 8 or Java 11
  depends_on "openjdk@11"

  def default_alluxio_conf
    <<~EOS
      alluxio.master.hostname=localhost
    EOS
  end

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
    chmod "+x", Dir["#{libexec}/bin/*"]

    rm_rf Dir["#{etc}/alluxio/*"]

    (etc/"alluxio").install libexec/"conf/alluxio-env.sh.template" => "alluxio-env.sh"
    ln_sf "#{etc}/alluxio/alluxio-env.sh", "#{libexec}/conf/alluxio-env.sh"

    defaults = etc/"alluxio/alluxio-site.properties"
    defaults.write(default_alluxio_conf) unless defaults.exist?
    ln_sf "#{etc}/alluxio/alluxio-site.properties", "#{libexec}/conf/alluxio-site.properties"
  end

  def caveats
    <<~EOS
      To configure alluxio, edit
        #{etc}/alluxio/alluxio-env.sh
        #{etc}/alluxio/alluxio-site.properties

      To use `alluxio-fuse` on macOS:
        brew install --cask macfuse
    EOS
  end

  test do
    output = shell_output("#{bin}/alluxio validateConf")
    assert_match "ValidateConf - Validating configuration.", output

    output = shell_output("#{bin}/alluxio clearCache 2>&1", 1)
    expected_output = OS.mac? ? "drop_caches: No such file or directory" : "drop_caches: Read-only file system"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/alluxio version")
  end
end
