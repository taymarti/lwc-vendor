# lwc-vendor

The Lightweight Charts npm packages, for development environments whose package mirror (e.g. an
internal Artifactory) doesn't carry them. Projects that use them, such as
[dh-charts](https://github.com/taymarti/dh-charts), keep ordinary registry dependencies; nothing in
them changes.

| Package | Version | License |
|---|---|---|
| `lightweight-charts` | 5.2.0 | Apache-2.0 |
| `fancy-canvas` (its dependency) | 2.1.0 | MIT (stated in its package.json; the package ships no LICENSE file) |
| `@tradingview/lwc-plugin-user-price-lines` | 1.0.0 | Apache-2.0 |

The tarballs in `packages/` are the ones published to npm, unmodified: their SHA-512 hashes
(`INTEGRITY`) equal the `integrity` the npm registry publishes for each version. `node_modules/` is
the same packages installed, for use without npm. The Apache-2.0 packages carry their LICENSE (and NOTICE).

## Use it (once per machine)

```powershell
git clone https://github.com/taymarti/lwc-vendor.git
.\lwc-vendor\prime-cache.ps1        # or ./lwc-vendor/prime-cache.sh
```

Then install projects as usual (`npm ci`). npm looks packages up in its cache by the lockfile's
`integrity` before fetching, so these three come from the cache and never touch the registry; every
other package still comes from your mirror. Checked with the registry unreachable and a cache primed
only from these tarballs: a lockfile resolving all three to registry.npmjs.org installed in full,
with plain `npm ci` and with `npm ci --offline`.

Run the script again if npm's cache is cleared (`npm cache clean --force`), or point npm at a
persistent cache (`npm config set cache <dir>`).

## Add or upgrade a package

```powershell
npm pack <name>@<version> --pack-destination packages   # the published tarball
# add it to package.json, then:
npm install                                              # refreshes package-lock.json and node_modules
```

Check that the new tarball's hash equals the lockfile's `integrity` (as `INTEGRITY` records for the
current set), commit `packages/`, `node_modules/`, `package.json`, `package-lock.json`, and `INTEGRITY`,
and bump the version in the projects that use it.
