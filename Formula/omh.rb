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
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.7.0/omh-aarch64-apple-darwin.tar.gz"
      sha256 "632c32948f06b7b171a7abc5fc228eca48bd6c0b302224ead9da2633bef4f558"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.7.0/omh-x86_64-apple-darwin.tar.gz"
      sha256 "de7c9521af42c1fff7548476c7baa2c9231ae708858881e1e8773e8302f4a0ac"
    end
  end

  on_linux do
    # Static musl, so one build covers every distribution.
    on_arm do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.7.0/omh-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2960744abdaf53ba2bd9e6939551cfb15c62c05969f273fbc7145deadf9e1a0d"
    end
    on_intel do
      url "https://github.com/mindsers/ohmyharness/releases/download/v0.7.0/omh-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3d61c642beec9cc6741572d91959d0240a6689764d4527315ae5aa8343db7449"
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
