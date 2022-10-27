# ~/.docker/config.json

[Use the Docker command line \| Docker Documentation](https://docs.docker.com/engine/reference/commandline/cli/#sample-configuration-file)

## memo

適用には再起動が必要かも

- `systemctl restart docker`
- Docker Desktop (win)
  1. Open GUI
  1. Click Troubleshoot(bug) Icon
  1. Click Restart Docker Desktop (first line)
  - or right click taskbar docker icon and select restart.

## ファイル構造

```json
{
    "detachKeys": "ctrl-z,z", // default ctrl-p, ctrl-q、シェルでの ctrl-p 2度押し回避と VSCode でのコンフリクト回避
    "credsStore": "desktop.exe",
    "_credsStore": "desktop.exe" // _ を挟むことによってエラー回避
}
```

## error

### docker-compose up で error getting credentials \[WSL2]

- error message
  - `failed to solve with frontend dockerfile.v0: failed to create LLB definition: rpc error: code = Unknown desc = error getting credentials - err: exit status 1, out: \`\``
- reference
  - [`docker-compose up` fails in WSL 2 environment · Issue #12355 · docker/for-win](https://github.com/docker/for-win/issues/12355)
- temporary solution
  - `"credsStore":` -> `"_credsStore:"` としてキーを無効にする
- cause
  - よくわからない。
- env
  - WSL2 Ubuntu 20.04
  - Docker Desktop 4.13.0 (89412)
