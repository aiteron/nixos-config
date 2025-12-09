# Flakes
**Nix flakes** является частью Nix Package Manager (сейчас находится в экспериментальном режиме). Предоставляет стандартный способ для описания Nix выражений и пакетов, чьи зависимости привязаны к версиям в файле блокировки. Это улучшает воспроизводимость Nix установок.

# Использование
- Т.к. содержимое flake файлов копируется в папку-хранилище Nix в читаемом формате, не помещайте не зашифрованные пароли и другую важную информацию в flake файлы!
- Чтобы включить временно поддержку flakes: `--experimental-features 'nix-command flakes'`
- Чтобы включить постоянную поддержку flakes в NixOS, в `configuration.nix` добавьте настройку: `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
- Можно создать базовую конфигурацию flake файла с помощью `nix flake init`

# Полезное
- https://nixos.wiki/wiki/Flakes
- https://librephoenix.com/2023-10-21-intro-flake-config-setup-for-new-nixos-users
