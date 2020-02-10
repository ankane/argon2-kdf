# Argon2 KDF

[Argon2](https://github.com/P-H-C/phc-winner-argon2) key derivation for Ruby

- No dependencies
- Works on Linux, Mac, and Windows

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'argon2-kdf'
```

## Getting Started

```ruby
Argon2::KDF.argon2id("pass", salt: "salt", t: 3, m: 15, p: 1, length: 32)
```

`argon2i` and `argon2d` are also supported

## History

View the [changelog](https://github.com/ankane/argon2-kdf/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/argon2-kdf/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/argon2-kdf/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/argon2-kdf.git
cd argon2-kdf
bundle install
bundle exec rake vendor:all
bundle exec rake test
```
