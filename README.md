# CLI helper for Git Conventional Commits

## Install

```bash
make && make install
```

## Usage

```bash
git conventional-commit feat! backend: rework public API
git fix: ensure stability of the session
git feat --no-verify backend ! : rework public API
git feat --no-verify --breaking backend: rework public API
```

## Tests

```bash
make && make test
```
