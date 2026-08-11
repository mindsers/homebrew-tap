# Security

## Reporting a vulnerability

Report it against **omh itself**, not here:
[private vulnerability reporting on mindsers/ohmyharness](https://github.com/mindsers/ohmyharness/security/advisories/new),
or email **nathanael@cherrier.dev** with `omh security` in the subject.

Please do not open a public issue.

## What this repository is

A Homebrew tap: one generated file naming release URLs and their SHA-256
checksums. It holds no code of its own. `Formula/omh.rb` is written by the
release pipeline in
[mindsers/ohmyharness](https://github.com/mindsers/ohmyharness) and its
checksums come from the release itself rather than being recomputed, so the
formula cannot disagree with what was published.

That makes the interesting question here a narrow one: **does this formula
still describe what omh actually released?** Worth reporting:

- a `sha256` that does not match the release asset it names
- a `url` pointing anywhere other than a `mindsers/ohmyharness` release
- a formula installing something other than the `omh` binary
- an unexpected commit — every legitimate one is authored by the release
  pipeline and says which tag it came from

Vulnerabilities *in omh* — the sandbox, credential handling, the sshd behind
`omh attach` — belong in the main repository, which states its scope in
[its own SECURITY.md](https://github.com/mindsers/ohmyharness/blob/main/.github/SECURITY.md).

## Verifying an install yourself

Every release publishes `SHA256SUMS`, and the formula's checksums are copied
from it. The two can be compared without trusting either:

```console
$ brew fetch mindsers/tap/omh          # prints the cached download and its hash
$ curl -fsSL https://github.com/mindsers/ohmyharness/releases/latest/download/SHA256SUMS
```

## Supported versions

The tap always describes the most recent release, and only that one. There are
no older formulae to patch.
