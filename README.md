# lwc-vendor

Packages for development environments whose package mirror (e.g. an internal Artifactory) doesn't carry
them, in two kinds, kept apart so it is always clear whose a package is:

```
vendor/                      third-party packages, byte-identical to what their registry published
  node-packages/               npm tarballs + INTEGRITY; installed/ is the same packages installed
  python-packages/             wheels and sdists (none needed yet)
taymarti/                    packages we build (dh-charts, our fork of Deephaven's plugin)
  node-packages/               npm tarballs + INTEGRITY, the latest version of each
  python-packages/             wheels + INTEGRITY, the latest version of each
```

Only the latest version of each package is kept: a release replaces the previous tarball or wheel.
Older versions are in git history (`git log --all -- <path>`, then `git show <commit>:<path> > <file>`).

Projects that use the third-party packages, such as [dh-charts](https://github.com/taymarti/dh-charts),
keep ordinary registry dependencies; nothing in them changes.

## Third-party npm packages (`vendor/node-packages/`)

| Package | Version | License |
|---|---|---|
| `lightweight-charts` | 5.2.0 | Apache-2.0 |
| `fancy-canvas` (its dependency) | 2.1.0 | MIT (stated in its package.json; the package ships no LICENSE file) |
| `@tradingview/lwc-plugin-user-price-lines` | 1.0.0 | Apache-2.0 |
| `@deephaven/app-utils` | 1.34.2 | Apache-2.0 |
| `@deephaven/auth-plugins` | 1.34.0 | Apache-2.0 |
| `@deephaven/chart` | 1.34.0 | Apache-2.0 |
| `@deephaven/console` | 1.34.0 | Apache-2.0 |
| `@deephaven/dashboard` | 1.34.0 | Apache-2.0 |
| `@deephaven/dashboard-core-plugins` | 1.34.2 | Apache-2.0 |
| `@deephaven/file-explorer` | 1.34.0 | Apache-2.0 |
| `@deephaven/golden-layout` | 1.34.0 | Apache-2.0 |
| `@deephaven/grid` | 1.34.1 | Apache-2.0 |
| `@deephaven/iris-grid` | 1.34.2 | Apache-2.0 |
| `@deephaven/jsapi-components` | 1.34.0 | Apache-2.0 |
| `@deephaven/jsapi-utils` | 1.34.0 | Apache-2.0 |
| `@deephaven/plugin` | 1.34.2 | Apache-2.0 |
| `@deephaven/react-hooks` | 1.34.0 | Apache-2.0 |

The tarballs in `vendor/node-packages/` are the ones published to npm, unmodified: their SHA-512 hashes
(`vendor/node-packages/INTEGRITY`) equal the `integrity` the npm registry publishes for each version.
`vendor/node-packages/installed/node_modules/` is the Lightweight Charts packages installed, for use without npm (the `@deephaven/*` packages are tarballs only: installed, they would pull in hundreds of dependencies). The Apache-2.0 packages carry their LICENSE (and NOTICE).

### Use them (once per machine)

```powershell
git clone https://github.com/taymarti/lwc-vendor.git
.\lwc-vendor\prime-cache.ps1        # or ./lwc-vendor/prime-cache.sh
```

Then install projects as usual (`npm ci`). npm looks packages up in its cache by the lockfile's
`integrity` before fetching, so these come from the cache and never touch the registry; every
other package still comes from your mirror. Checked with the registry unreachable and a cache primed
only from these tarballs: a lockfile resolving all three to registry.npmjs.org installed in full,
with plain `npm ci` and with `npm ci --offline`.

Run the script again if npm's cache is cleared (`npm cache clean --force`), or point npm at a
persistent cache (`npm config set cache <dir>`).

### Add or upgrade one

```powershell
npm pack <name>@<version> --pack-destination vendor/node-packages   # the published tarball
# add it to vendor/node-packages/installed/package.json, then in that folder:
npm install                                                          # refreshes package-lock.json and node_modules
```

Check that the new tarball's hash equals the lockfile's `integrity`, add it to `vendor/node-packages/INTEGRITY`,
commit, and bump the version in the projects that use it. Remove the old version's tarball and hash.

## Third-party Python packages (`vendor/python-packages/`)

None needed yet; its README says how to add one.

## Our npm packages (`taymarti/node-packages/`)

npm tarballs of the JS packages we build, for environments that can't build them. They are on no
registry, so the cache prime doesn't apply: install them by path. `taymarti/node-packages/INTEGRITY` has
their hashes. Only the latest version of each is kept.

| Tarball | What it is | Built from |
|---|---|---|
| `acme-chart-ext-0.5.0.tgz` | `@acme/chart-ext`, the chart component: our Lightweight Charts plugins (price lines, drawings with context menu, shortcuts and undo, OHLC legend, shading, crosshair and time sync groups, chart navigation with history on demand, alert lines and toasts, session shading and market status, bar-close countdown), `SeriesFeed` and `bindFeed` (any data source as price and studies in panes, compare overlays), time-zone and tick-size formats, the store interfaces, the hook for Deephaven charts, and since 0.5.0 chart themes from CSS custom properties, studies computed on bars, and spread and ratio expressions. No Deephaven dependency (since 0.4.0: the table stores and `subscribeRows` moved to `@acme/dh-bindings`). One ES module for bundlers, with types | [dh-charts](https://github.com/taymarti/dh-charts) `ext/` (`npm pack`, which builds `dist/`) |
| `acme-dh-bindings-0.3.0.tgz` | `@acme/dh-bindings`: the chart component's interfaces over Deephaven (annotation and alert stores over input tables, `subscribeRows`, `tableFeed`), the request API client (`openApi`, `ApiClient`) and `requestChart`; since 0.2.0 the connection (`connect`, `adoptConnection`, connection state, shared table leases), `TableViewport` (a grid's server-side window with sort and quick filters) and `safeClose`; since 0.3.0 `serverAvailable` (a real server, or fall back to the mock). Peer dependencies: `@acme/chart-ext` 0.5, `@deephaven/jsapi-types` (types), lightweight-charts 5.2.0 | [dh-charts](https://github.com/taymarti/dh-charts) `bindings/` (`npm pack`, after `ext/` is built) |
| `acme-app-shell-0.3.2.tgz` | `@acme/app-shell`: the app shell: dockable panels on dockview (`Shell`, saved workspaces, link groups; since 0.2.0 a heavy frame on each pane and a heavier accent frame on the selected one, `ChartWorkspace`, data hooks, a theme switch and API status), the Deephaven session as React context (`DeephavenRoot` reconnects after a server restart) and hooks, `DataGrid`, and panels: chart, watchlist, table, request form, update graph, series chart, strategies and backtests. Styles: `@acme/app-shell/style.css`. Dependency: `dockview-react` 8.8.3 (from npm). Peer dependencies: the three packages above, `@deephaven/jsapi-types` (types), lightweight-charts 5.2.0, react 18 or 19 | [dh-charts](https://github.com/taymarti/dh-charts) `shell/` (`npm pack`, after `ext/`, `react/` and `bindings/` are built) |
| `acme-chart-react-0.6.1.tgz` | `@acme/chart-react`: React components for trading charts: `ChartToolbar` (symbol search, interval, chart type, indicators dialog, compare, range, scale, layouts and sync, panels), `ChartLegend` (study rows and settings, market status), `Watchlist`, `AlertsPanel`, and the link bus (`createLinkBus`, `LinkProvider`, `useLink`). Peer dependencies: react 18 or 19, lightweight-charts 5 (types) | [dh-charts](https://github.com/taymarti/dh-charts) `react/` (`npm pack`) |
| `acme-dh-mock-0.1.0.tgz` | `@acme/dh-mock`: a Deephaven server that runs in the page, for demos, offline work and tests: a mock update graph and JS API, the request-API protocol, and a mock of dh_chart_ext's chart server (chart nodes, studies, stores, backtests). Peer dependency: `@acme/chart-ext` 0.5 | [dh-charts](https://github.com/taymarti/dh-charts) `mock/` (`npm pack`) |
| `acme-dh-widgets-0.1.1.tgz` | `@acme/dh-widgets` (front-end group B): Deephaven's own widgets (deephaven.ui, plotly express, the TradingView plugin) in a page of ours and in app-shell panels. Peer dependencies: `@acme/app-shell` 0.3, `@acme/dh-bindings` 0.3, the `@deephaven` React packages, react | [dh-charts](https://github.com/taymarti/dh-charts) `widgets/` (`npm pack`) |
| `deephaven-js-plugin-tradingview-lightweight-0.1.0-acme.1.tgz` | Deephaven's TradingView plugin JS with our two changes (chart-events API, time-zone cache) | [our fork](https://github.com/taymarti/deephaven-plugins/tree/acme/tradingview-lightweight), commit `e0cdfdd`, `plugins/tradingview-lightweight/src/js` |

```powershell
.\prime-cache.ps1                                            # their Lightweight Charts dependencies
npm install <path to lwc-vendor>/taymarti/node-packages/acme-chart-ext-0.5.0.tgz <path to lwc-vendor>/taymarti/node-packages/acme-dh-bindings-0.3.0.tgz lightweight-charts@5.2.0
```

npm records the dependency as `file:<path>`, so keep `lwc-vendor` at the same relative place for
everyone (for example next to the project). Checked (0.3.0): a project with `@acme/chart-ext` from the tarball
and a lockfile installed with `npm ci` with the registry unreachable and only this repo's cache prime;
the module imported with all its exports. Checked (0.4.0, with dh-bindings 0.1.0 and chart-react 0.4.0): installed together in a clean project and imported with all their exports. Checked (dh-bindings 0.2.0, app-shell 0.1.0): the four installed together in a clean project, which typechecks and builds with Vite (app-shell takes dockview-react from npm; it needs a DOM, so it is checked by a build, not a Node import).

The fork's plugin also needs the `@deephaven/*` packages and `react-redux` from your mirror. Most
apps don't install it from npm at all: the Deephaven server serves the plugin to the browser from its
Python wheel (built from the same fork commit).

To release: bump the package's version, `npm pack --pack-destination <lwc-vendor>/taymarti/node-packages` in each
source folder, `ext/` first (it builds first, and `bindings/` reads its types), and add the new tarballs' hashes
to `taymarti/node-packages/INTEGRITY`, removing the previous version's tarball and hash. A changed package gets a
new version rather than a repack under the same one, so a lockfile's recorded hash never silently stops matching.

## Our Python packages (`taymarti/python-packages/`)

Wheels of `dh-chart-ext` 0.2.1 (dh-charts' server side) and of the fork's `deephaven-plugin-tradingview-lightweight`
0.1.0+acme.1, with their SHA-256 hashes; its README says how to install them together (name the fork's version
explicitly, or a newer upstream release on your mirror wins).

## License

The scripts and documentation here: Apache-2.0 (`LICENSE`). The packages keep their own licenses (see
`NOTICE`).
