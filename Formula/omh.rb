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
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.6.0/omh-aarch64-apple-darwin.tar.gz"
      sha256 "97665d6233ad2edee77ebb7536249b352b6d8719279163da11ae7aff6c032520"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.6.0/omh-x86_64-apple-darwin.tar.gz"
      sha256 "81218b463421aca98a47ab8e5e1f1828f51c450bc9b7ff3803cc9968e1eda941"
    end
  end

  on_linux do
    # Static musl, so one build covers every distribution.
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.6.0/omh-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b81052ab09ecbe5a2cb02b48e8d78c94bcec81032d08bc4b2314e38cf0b5f3dd"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.6.0/omh-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ad09b1be5113c9af2fd1c21670093848306900566463b23791490397940eed79"
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
