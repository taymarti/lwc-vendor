# vendor/python-packages

Third-party Python wheels and sdists, exactly as their registry (PyPI) published them, for environments
whose mirror doesn't carry them. None are needed yet. When one is: download it unmodified
(`pip download <name>==<version> --no-deps -d vendor/python-packages`), add its SHA-256 to `INTEGRITY`
here (it must equal the hash PyPI publishes), and install with `pip install --no-index --find-links
vendor/python-packages <name>==<version>`.
