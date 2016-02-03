# Dothtml

Graphviz is a great visualization tool for coding digraphs.

d3 is a great tool for dynamic html presentations.

Dothtml will convert your Graphviz dot files to nicely formatted html files.
It can convert them on-demand, or it can constantly convert them as you develop,
using a simple [Guard](http://guardgem.org/) process.

## Installation

```
gem install dothtml
```

## Usage

When starting a project for the first time, just call `dothtml create` with
a new directory name.  Dothtml will create the directory with a sample.dot file,
and then `git init` the directory.

Edit the sample.dot file, or just copy it with a new name, and then call
`dothtml build`.  That's it!  Dothtml has created the .html files.

You can then monitor your live changes to the dot files with `dothtml watch`,
which will start a Guard process to monitor them.  Change your dot files, and
they will be built into .html files upon saving.

Once the Guard process has started, you can also open the .html files in your
browser and automatically have then reload with the
[LiveReload browser extension](http://livereload.com/extensions/).

You can get more information on the command line with `dothtml --help`

## Similar Projects

- https://github.com/ioquatix/graphviz
- https://github.com/kui/octopress-graphviz
- https://github.com/glejeune/Ruby-Graphviz

## TODO

- Add radio button for class association
- Embed external svg images into html file

## Contributing

1. Fork it ( https://github.com/kbrock/dothtml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
