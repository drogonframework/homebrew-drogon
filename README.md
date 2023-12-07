# Drogon Homebrew Formula

> [!NOTE]  
> This formula has been [merged into homebrew-core](https://github.com/Homebrew/homebrew-core/pull/152693) and can now be installed by `brew install drogon`.

## Installation Using `brew tap`

```bash
$ brew tap drogonframework/drogon
$ brew install drogon
```

## Installation Without `brew tap`

```bash
$ brew install drogonframework/drogon/drogon
```

## Contribution

```bash
$ git clone https://github.com/drogonframework/homebrew-drogon.git
$ cd homebrew-drogon
$ cp -f Formula/drogon.rb $(brew --repo)/Library/Taps/homebrew/homebrew-core/Formula/
$ brew install --build-from-source --verbose --debug drogon
$ brew test drogon
$ brew audit --strict drogon
```
