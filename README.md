# DAG

Very simple directed acyclic graphs for Ruby.

[![Build Status](https://travis-ci.org/kevinrutherford/dag.png)](https://travis-ci.org/kevinrutherford/dag)
[![Dependency
Status](https://gemnasium.com/kevinrutherford/dag.png)](https://gemnasium.com/kevinrutherford/dag)
[![Code
Climate](https://codeclimate.com/github/kevinrutherford/dag.png)](https://codeclimate.com/github/kevinrutherford/dag)

## Installation

Install the gem

```
gem install dag
```

Or add it to your Gemfile and run `bundle`.

``` ruby
gem 'dag'
```

## Usage

```ruby
dag = DAG.new

v1 = dag.add_vertex
v2 = dag.add_vertex
v3 = dag.add_vertex

dag.add_edge from: v1, to: v2
dag.add_edge from: v2, to: v3

v1.has_path_to?(v3)                  # => true
v3.has_path_to?(v1)                  # => false

dag.add_edge from: v3, to: v1        # => ArgumentError: A DAG must not have cycles

dag.add_edge from: v1, to: v2
dag.add_edge from: v1, to: v3
v1.successors                        # => [v2, v3]
```

See the specs for more detailed usage scenarios.

## Compatibility

Tested with Ruby 1.9.x, JRuby, Rubinius.
See the [build status](https://travis-ci.org/kevinrutherford/dag)
for details.

## License

(The MIT License)

Copyright (c) 2013 Kevin Rutherford

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

