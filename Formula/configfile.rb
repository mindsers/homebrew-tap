# Updated by hand for each release of mindsers/configfile: the URL's version,
# and the sha256 from the SHA256SUMS file attached to that release.
class Configfile < Formula
  desc "Manage your dotfiles and setup scripts from a git repository"
  homepage "https://github.com/mindsers/configfile"
  url "https://github.com/mindsers/configfile/releases/download/2.0.0/configfile-2.0.0.tgz"
  sha256 "4334cb1b2459123838600723eca31cc47dd8e7741c21ab02d9e34dc9a70f7822"
  license "Apache-2.0"

  depends_on "git"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/configfile --version")

    # More than starting: without a configuration, a command fails and says to
    # run init, on stderr, exiting 1.
    assert_match "configfile init", shell_output("#{bin}/configfile scripts list 2>&1", 1)
  end
end
