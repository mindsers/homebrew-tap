# Security

## Reporting a vulnerability

**A vulnerability in the software goes to the software's own repository**, not
here. A formula is a few lines naming a download and its checksum; the code it
installs lives elsewhere, and so does the person who can fix it.

| formula | report to |
|---|---|
| `omh` | [mindsers/ohmyharness](https://github.com/mindsers/ohmyharness/security/advisories/new) — [its policy](https://github.com/mindsers/ohmyharness/blob/main/.github/SECURITY.md) |

For anything about **this repository**, use
[private vulnerability reporting](https://github.com/mindsers/homebrew-tap/security/advisories/new)
or email **nathanael@cherrier.dev**. Please do not open a public issue.

## What is in scope here

A tap is a distribution point: it tells `brew` what to download and what that
download should hash to. So the question this repository answers is a narrow
one — **does each formula still describe what its project actually released?**

Worth reporting:

- a `sha256` that does not match the release asset it names
- a `url` pointing somewhere other than the project's own releases
- a formula installing something other than what it claims to
- an unexpected commit, particularly to a generated formula: every legitimate
  one is authored by that project's release pipeline and names the tag it came
  from

Out of scope: bugs in the installed software, and anything requiring an
attacker who already has write access to this repository.

## Verifying an install yourself

Nothing here has to be taken on trust. A generated formula's checksums are
copied from the release that produced them, so the two can be compared
independently:

```console
$ brew fetch mindsers/tap/omh    # prints the cached download and its hash
$ curl -fsSL https://github.com/mindsers/ohmyharness/releases/latest/download/SHA256SUMS
```

## Supported versions

Each formula describes the current release of its project, and only that one.
There are no older formulae to patch.
