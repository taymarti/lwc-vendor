# taymarti/python-packages

Python wheels we build, for environments that can't build them: the latest version of each (a release
replaces the previous wheel; older ones are in git history). `INTEGRITY` has their SHA-256 hashes
(pip's `--hash=sha256:...` form).

| Wheel | What it is | Built from |
|---|---|---|
| `dh_chart_ext-0.2.0-py3-none-any.whl` | `dh-chart-ext`: the server side of dh-charts. Its JS plugin for Deephaven's TradingView charts (`@acme/chart-ext`, bundled), chart data and nodes on demand, the request API framework (`rpc`), saved workspaces, the update-graph explorer, the backtest service with its CEP stand-in (`_cep_sim/runner.py`), and since 0.2.0 the app kit (`live`: tables an app writes, `uikit`: deephaven.ui helpers) and the bundled introspection | [dh-charts](https://github.com/taymarti/dh-charts) `dh-plugin/` at `f8a51ef` (`pip wheel --no-deps ./dh-plugin`, after `npm --prefix dh-plugin/js run build`) |
| `deephaven_plugin_tradingview_lightweight-0.1.0+acme.1-py3-none-any.whl` | Deephaven's TradingView plugin with our two changes (chart-events API, time-zone cache); the same JS as `../node-packages/deephaven-js-plugin-tradingview-lightweight-0.1.0-acme.1.tgz` | [our fork](https://github.com/taymarti/deephaven-plugins/tree/acme/tradingview-lightweight), commit `e0cdfdd` (`python -m build --wheel plugins/tradingview-lightweight`; on Windows with the npm shim the dh-charts README describes) |

Install both (their other dependencies, `deephaven-plugin` and `deephaven-plugin-utilities`, come from
your mirror):

```powershell
pip install --find-links <path to lwc-vendor>/taymarti/python-packages dh-chart-ext "deephaven-plugin-tradingview-lightweight==0.1.0+acme.1"
```

Name the fork's version explicitly: `dh-chart-ext` depends on the plugin by name only, and a newer
upstream release on your mirror would otherwise win. Checked: both installed in a clean virtual environment
with their dependencies from PyPI; the server's plugin entry points registered, the JS bundle and the
runner in place, the pure-Python modules importing.
