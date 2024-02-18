# Development


## Clone

Clone the repo.

```sh
$ git clone git@github.com:jwillmer/jekyll-resize.git
$ cd jekyll-resize
```

The plugin depends on `jekyll` and `mini_magick` - these will be installed when the plugin is installed from the [jekyll-resize.gemspec](../jekyll-resize.gemspec) file.


## Build

```sh
$ make build-gem
```

This will output an archive file e.g. `jekyll-resize-1.1.0.gem`.

This is can be ignored from version control - the gem can still be installed using a GitHub URL.


## Release

Commit and push changes. It will be available on master - you do not need to tag.

Then run this in another project to get the latest version of this gem:

```sh
$ bundle update
```

When you are done testing this, update the version number in the gemspec file and tag the repo.
