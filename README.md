# Raksit's personal blog
This is my portfolio, sharings, and notes specially for software development.

## Minimum requirements
- **Ruby**: v2.7.3

or simply follow GitHub Pages [dependency versions](https://pages.github.com/versions/)

## Installation
1. Install bundler:

``` shell
$ sudo gem install bundler
```

2. Install all dependencies:

```shell
$ sudo bundle install
```

## Development
To start dev server for published posts only:

```shell
$ bundle exec jekyll serve
```

To start dev server for all posts, including drafts:

```shell
$ bundle exec jekyll serve --drafts
```

Navigate to `http://localhost:4000`. The app will automatically reload if you change any of the source files.