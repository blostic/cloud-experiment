# Claudius

Claudius is a easy-to-use domain specific language for clouds experiments. Language is build on [fog.io](http://fog.io), which enables flexible and powerfull way to manage virtual machine instances on various cloude poviders. Connections with virtual machines is based on ssh. To provide information experiment flow, DSL generates readable graph of execution.

## Installation


Install it as:

    $ sudo gem install claudius

If you want export execution tree to image you need [Graphivz](http://www.graphviz.org).

## Usage

Check doc [here](http://blostic.github.io/claudius).


## Documentation

Documemtation is autogenerated from examples by [Groc](https://github.com/nevir/groc).
To build doc you need [Node.js](http://nodejs.org/) and [Pygments](http://pygments.org/).

    npm install -g groc

Generate to *doc* folder:

    groc examples/* README.md

Generate to GitHub page:

    groc --gh examples/* README.md


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request