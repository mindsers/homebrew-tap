# mindsers/homebrew-tap

Homebrew formulae for [omh](https://github.com/mindsers/ohmyharness) — launch
any coding harness, in a sandbox, with your setup already there.

```console
$ brew install mindsers/tap/omh
```

## What is in here

| formula | what it is |
|---|---|
| `omh` | the omh CLI, as a prebuilt binary for macOS and Linux, arm64 and x86_64 |

Linux builds are static musl, so one build covers every distribution.

## omh needs a container runtime

Homebrew cannot express that as a dependency: Docker Desktop is a cask, the
`docker` formula is only the client, and a formula may not depend on a cask. So
it is said here and in the formula's caveats rather than enforced.

```console
$ brew install --cask docker    # or: brew install podman
```

## This repository is generated

`Formula/omh.rb` is written by the release pipeline in
[mindsers/ohmyharness](https://github.com/mindsers/ohmyharness), from a
template that lives there, whenever a version is tagged. Editing it here works
until the next release overwrites it.

Fix the template, not the output:
[`packaging/homebrew/omh.rb.tmpl`](https://github.com/mindsers/ohmyharness/blob/main/packaging/homebrew/omh.rb.tmpl).

Bugs, features and questions about omh itself belong in the
[main repository](https://github.com/mindsers/ohmyharness/issues).

## Licence

MIT, matching omh — see [`LICENSE`](LICENSE).
