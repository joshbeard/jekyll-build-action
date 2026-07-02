# jekyll-build-action

A GitHub Action that builds a Jekyll site in place and leaves the output in `_site/` for a follow-on deploy step.

Forked from [jerryjvl/jekyll-build-action](https://github.com/jerryjvl/jekyll-build-action). The upstream action is a minimal wrapper around `jekyll build`; this version adds the Git and Bundler handling needed for real-world Jekyll sites on current GitHub Actions runners.

## Usage

This action only builds the site. Your workflow still needs to check out the source, then publish `_site/` afterward (S3, Pages, an artifact, etc.).

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Build
        uses: joshbeard/jekyll-build-action@master
        env:
          GIT_CEILING_DIRECTORIES: $GITHUB_WORKSPACE

      - name: Upload site
        uses: actions/upload-artifact@v4
        with:
          name: site
          path: _site/
```

For production workflows, pin to a commit SHA or release tag instead of a branch name.

## How it works

The action runs in a Docker container based on [`jekyll/builder:4`](https://hub.docker.com/r/jekyll/builder). On startup it:

1. Makes the workspace writable
2. Marks the checkout as a Git safe directory
3. Sets `GIT_CEILING_DIRECTORIES` so nested Git dependencies resolve correctly
4. Runs `bundle install` (required for Git-based gems in `Gemfile`)
5. Runs `bundle exec jekyll build --trace`

The built site is written to `_site/` in the checked-out repository.

## Differences from upstream

| Area | [jerryjvl/jekyll-build-action](https://github.com/jerryjvl/jekyll-build-action) | This fork |
| --- | --- | --- |
| Base image | `jekyll/builder:latest` | `jekyll/builder:4` (pinned) |
| Dependencies | Assumes gems are already available | Runs `bundle install` before build |
| Jekyll invocation | `jekyll build` | `bundle exec jekyll build` |
| Git in CI | None | Configures `safe.directory` and `GIT_CEILING_DIRECTORIES` |
| Workspace path | Hardcoded `/github/workspace` | Uses `$GITHUB_WORKSPACE` |

These changes support sites that use a `Gemfile` with Git dependencies (for example, a plugin checked out from another repository) and avoid Bundler/Ruby version conflicts on current builder images.

## Requirements

- A `Gemfile` and `Gemfile.lock` in the repository root
- Jekyll configuration at `_config.yml` (or whatever your project uses by default)

Sites running on Ruby 3.4 may also need explicit `base64` and `bigdecimal` gems in the `Gemfile`; see [joshbeard.com](https://github.com/joshbeard/website) for an example.

## References

- [actions/checkout](https://github.com/actions/checkout)
- [Jekyll Docker images](https://github.com/envygeeks/jekyll-docker)

## License

MIT. See [LICENSE](LICENSE). Based on [jerryjvl/jekyll-build-action](https://github.com/jerryjvl/jekyll-build-action) by Jerry van Leeuwen.
