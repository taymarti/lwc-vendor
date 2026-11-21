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

## Our own packages (`acme/`)

npm tarballs of the JS packages we build, for environments that can't build them. They are on no
registry, so the cache prime doesn't apply: install them by path. `acme/INTEGRITY` has their hashes.

| Tarball | What it is | Built from |
|---|---|---|
| `acme-chart-ext-0.1.0.tgz` | `@acme/chart-ext`: our Lightweight Charts plugins (price lines, drawings, OHLC legend, shading, crosshair sync), the hook for Deephaven charts, and the annotation store. One ES module for bundlers, with types | [dh-charts](https://github.com/taymarti/dh-charts) `ext/` (`npm pack`, which builds `dist/`) |
| `acme-chart-react-0.1.0.tgz` | `@acme/chart-react`: React components for trading charts; `ChartToolbar` (TradingView-style: symbol search, interval, chart type, indicators dialog, range, scale). Peer dependency: react 18 or 19 | [dh-charts](https://github.com/taymarti/dh-charts) `react/` (`npm pack`) |
| `deephaven-js-plugin-tradingview-lightweight-0.1.0-acme.1.tgz` | Deephaven's TradingView plugin JS with our two changes (chart-events API, time-zone cache) | [our fork](https://github.com/taymarti/deephaven-plugins/tree/acme/tradingview-lightweight), commit `e0cdfdd`, `plugins/tradingview-lightweight/src/js` |

```powershell
.\prime-cache.ps1                                            # their Lightweight Charts dependencies
npm install <path to lwc-vendor>/acme/acme-chart-ext-0.1.0.tgz lightweight-charts@5.2.0
```

npm records the dependency as `file:<path>`, so keep `lwc-vendor` at the same relative place for
everyone (for example next to the project). Checked: a project with `@acme/chart-ext` from the tarball
and a lockfile installed with `npm ci` with the registry unreachable and only this repo's cache prime;
the module imported with all its exports.

The fork's plugin also needs the `@deephaven/*` packages and `react-redux` from your mirror. Most
apps don't install it from npm at all: the Deephaven server serves the plugin to the browser from its
Python wheel (built from the same fork commit).

To refresh: `npm pack --pack-destination <lwc-vendor>/acme` in each source folder (in dh-charts
`ext/`, it builds first), then regenerate `acme/INTEGRITY`.

## License

The scripts and documentation here: Apache-2.0 (`LICENSE`). The packages keep their own licenses (see
`NOTICE`).
