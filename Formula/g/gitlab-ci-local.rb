require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.52.1.tgz"
  sha256 "68677db10d5394a524ddf2c8b1d504b0a0655da2615f44870b5be70649affd3e"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57856f44c2b0576e707adf330d5f6733dc10a5c015bb380ba8c8d19b83b50947"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57856f44c2b0576e707adf330d5f6733dc10a5c015bb380ba8c8d19b83b50947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57856f44c2b0576e707adf330d5f6733dc10a5c015bb380ba8c8d19b83b50947"
    sha256 cellar: :any_skip_relocation, sonoma:         "a239fc7890fff3df37b71df4e4265114329e9381188e45680a0b492c229a5dc1"
    sha256 cellar: :any_skip_relocation, ventura:        "a239fc7890fff3df37b71df4e4265114329e9381188e45680a0b492c229a5dc1"
    sha256 cellar: :any_skip_relocation, monterey:       "a239fc7890fff3df37b71df4e4265114329e9381188e45680a0b492c229a5dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba9d35f17fab629b45c8a3fdb8cc37a0195ee5225d302b44f8e814458c5fd39"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YML
      ---
      stages:
        - build
        - tag
      variables:
        HELLO: world
      build:
        stage: build
        needs: []
        tags:
          - shared-docker
        script:
          - echo "HELLO"
      tag-docker-image:
        stage: tag
        needs: [ build ]
        tags:
          - shared-docker
        script:
          - echo $HELLO
    YML

    system "git", "init"
    system "git", "add", ".gitlab-ci.yml"
    system "git", "commit", "-m", "'some message'"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    rm ".git/config"

    (testpath/".git/config").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecow/gitlab-ci-local.git
        fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
        remote = origin
        merge = refs/heads/master
    EOS

    assert_match(/name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?needs\n/,
        shell_output("#{bin}/gitlab-ci-local --list"))
  end
end
