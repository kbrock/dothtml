# Change Log

## [Unreleased]


## [0.1.0] - 2016-02-09
### Added
- Rewritten CLI that supports subcommands build, create, and watch
- Detect/Add presence of outer `graph {}`
- Added minimal layout detection (neato vs dot)
- Added support for arbitrary cdn value

### Removed
- Removed merging of id and class as class attribute is now supported by graphviz.

## [0.0.3] - 2014-12-23
### Added
- Rule to generate an svg file

## [0.0.2] - 2014-12-10
### Added
- This CHANGELOG
- Added behavior and style files. (no longer in template file)

### Removed
- Removed temporary svg file and associated Rakefile rule.
- Removed documentation and radioboxes when not necessary.

## 0.0.1 - 2014-12-08
### Added
- Rakefile task rule to convert dot files to svg files
- Rakefile rule to convert svg files to html files
- Guardfile to auto generate site

### Remove
- Removed embedding of svg images. Not ready for prime time yet.
- Removed requirement on liquid gem. Default template now in erb.

[Unreleased]: https://github.com/kbrock/dothtml/compare/v0.1.0...HEAD
[0.2.0]: https://github.com/kbrock/dothtml/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/kbrock/dothtml/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/kbrock/dothtml/compare/v0.0.1...v0.0.2
