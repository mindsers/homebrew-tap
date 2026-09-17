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
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.13.0/omh-aarch64-apple-darwin.tar.gz"
      sha256 "381eae2d9bfb3f0c3d14151464734c825a66e37d11830a9e5b769e76247cf4cb"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.13.0/omh-x86_64-apple-darwin.tar.gz"
      sha256 "06b2d9ae216019ce9b354d30b5e9909a0e7d0eff2bd11cc5c0452e49d531e820"
    end
  end

  on_linux do
    # Static musl, so one build covers every distribution.
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.13.0/omh-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a56ce6e002732214d5dfe0be997a91ea9ac9cf115d747b0bf70f6dc4e11f1912"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.13.0/omh-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d739500b8f09ba65e229232dd524cb83af2523a48228005d4ca232e2c7a46f85"
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
                 shell_output("#{bin}/omh info 2>&1", 1)
  end
end
