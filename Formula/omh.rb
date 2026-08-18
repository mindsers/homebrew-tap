# Rendered into mindsers/homebrew-tap by the `homebrew` job in release.yml.
# The at-delimited placeholders below are filled from the tag and from the
# release's own SHA256SUMS, so the formula cannot disagree with what was
# published — the checksums are not recomputed here, they are the ones the
# release ships. (Written that way round on purpose: the renderer refuses if a
# placeholder-shaped token survives, and a literal example here would trip it.)
#
# No `version` field: Homebrew scans it from the release URL, and `brew audit
# --strict` rejects stating it twice. `version` in the test block below is that
# scanned value, which makes the assertion sharper than it looks — it compares
# the binary against the version the URL claims, not against a string this file
# also controls.
#
# Edit this file, never the copy in the tap.
class Omh < Formula
  desc "Launch any coding harness, in a sandbox, with your setup already there"
  homepage "https://github.com/mindsers/ohmyharness"
  license "MIT"

  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.5.0/omh-aarch64-apple-darwin.tar.gz"
      sha256 "395916fa40e5fe561342d1f8996600f35f2cab1362f003927ca8f7cddab1bb12"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.5.0/omh-x86_64-apple-darwin.tar.gz"
      sha256 "7eaf7d1e66ef925194b5d611574542277fd40b334f79b59b9ac0baf4088b5fb8"
    end
  end

  on_linux do
    # Static musl, so one build covers every distribution.
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.5.0/omh-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2dd3d9b8125fa8bc00a4e201c6ea9230862543d4b9c444e2727e6392be497542"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.5.0/omh-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fedfc320007c63d150b680234578cd704bd544658f8ad7f0cdbf42d6e7bd86d5"
    end
  end

  def install
    # The tarball holds a single omh-<target>/ directory, which Homebrew has
    # already entered by this point.
    bin.install "omh"
  end

  def caveats
    <<~EOS
      omh runs agents in containers, so it needs a container runtime:

        brew install --cask docker    (or: brew install podman)

      Homebrew cannot express that as a dependency — Docker Desktop is a cask,
      the `docker` formula is only the client, and a formula may not depend on
      a cask — so it is stated here rather than enforced.

      Then, in a git repository:

        omh init
    EOS
  end

  test do
    # The version the binary reports, not the one the formula claims. A tarball
    # built from the wrong commit passes every other check in the pipeline.
    assert_match version.to_s, shell_output("#{bin}/omh --version")

    # omh refuses to run outside a git repository, and the refusal is the
    # difference between a binary that works and one that merely starts.
    # `brew test` runs in a scratch directory that is not a repository, so this
    # is the refusal, on stderr, exiting 1 — all three asserted.
    assert_match "not inside a git repository",
                 shell_output("#{bin}/omh ls 2>&1", 1)
  end
end
