# ARC runner image

A small, public container image for ephemeral GitHub Actions runners managed by
Actions Runner Controller (ARC).

The image intentionally stays close to GitHub's official ARC runner image. It
adds only `libatomic1`, which is required by the standalone pnpm 11 executable,
and uses the official [ICSCoE Ubuntu mirror][icscoe-mirror] for Ubuntu archive
and security packages.

## Image

```text
ghcr.io/kurotch-homelab/runner-image:2.336.0-1
```

Production deployments should pin the digest printed by the build workflow.

```yaml
containers:
  - name: runner
    image: ghcr.io/kurotch-homelab/runner-image@sha256:...
```

## Contents

- Base: `ghcr.io/actions/actions-runner:2.336.0`
- Architecture: `linux/amd64`
- Added package: `libatomic1`
- APT mirror: `https://ftp.udx.icscoe.jp/Linux/ubuntu`
- Default user: upstream `runner` user (`1001:1001`)

Language runtimes and build tools are not bundled. Workflows should continue to
use setup actions such as `actions/setup-node`, `actions/setup-go`, and the
appropriate Rust toolchain action.

## Publishing

Create and push a release tag to build the image and publish it to GHCR:

```bash
git tag v2.336.0-1
git push origin v2.336.0-1
```

The workflow publishes both the version tag and a commit-derived tag, then
checks the runner user, runner entrypoint, APT mirror, and `libatomic.so.1`.

## Security

No credentials, internal network addresses, cluster names, or deployment
configuration are included. The image is public and should be treated as fully
inspectable. Runtime credentials must be injected by the deployment platform.

[icscoe-mirror]: https://launchpad.net/ubuntu/+mirror/ftp.udx.icscoe.jp-archive
