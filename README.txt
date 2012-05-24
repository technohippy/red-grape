# RedGrape - Extremely Simple GraphDB

* https://github.com/technohippy/red-grape

## DESCRIPTION:

RedGrape is an in-memory graph database written in ruby. I made this in order to learn how graph databases work so that please do not use this for serious purposes.

## FEATURES/PROBLEMS:

* load GraphML
* construct a graph programmatically
* traverse nodes and edges

## SYNOPSIS:

  g = RedGrape.load_graph 'data/graph-example-1.xml'
  g.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}

## REQUIREMENTS:

* Nokogiri (http://nokogiri.org/)

## DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## REFERENCES:

* [Tinkerpop](http://tinkerpop.com/)
** [Gremlin](https://github.com/tinkerpop/gremlin/wiki)
** [Pipes](https://github.com/tinkerpop/pipes/wiki/)

## LICENSE:

(The MIT License)

Copyright (c) 2012 ANDO Yasushi

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
