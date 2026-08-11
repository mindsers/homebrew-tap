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
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.2.0/omh-aarch64-apple-darwin.tar.gz"
      sha256 "b5e89058a827ee785488554503025b3c2bfc957486dff24b9cc5af923db24b26"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.2.0/omh-x86_64-apple-darwin.tar.gz"
      sha256 "f5422d499d6364341d913d14d18ced41a9fdb12b4343482eca546a32d069521b"
    end
  end

  on_linux do
    # Static musl, so one build covers every distribution.
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.2.0/omh-aarch64-unknown-linux-musl.tar.gz"
      sha256 "120a295b2f60c3fd3b2b82a61bd3be035c8a9320ea7205bc1e281ea6b9b29796"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.2.0/omh-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dc5a1866898e514f3f4e78b7b5985dd11e98299a4c9d2a3917503f09d7921ec1"
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
