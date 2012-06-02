# RedGrape - Extremely Simple GraphDB

* https://github.com/technohippy/red-grape

## DESCRIPTION:

RedGrape is an in-memory graph database written in ruby. I made this in order to learn how graph databases work so that please do not use this for serious purposes.

## FEATURES/PROBLEMS:

* REPL
* load GraphML
* construct a graph programmatically
* traverse nodes and edges

## SYNOPSIS:

  g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  g1.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.take
  g2 = RedGrape.load_graph 'data/graph-example-2.xml'
  g2.v(89).as('x').outE.inV.loop('x'){loops < 3}.path.take

## REPL:

  $ bin/redgrape 
          T
        ooooo
  -----  ooo  -----
   RED    o   GRAPE
  -----------------
  ruby :001 > g1 = RedGrape.load_graph 'data/graph-example-1.xml'
   => redgrape[vertices:6 edges:6] 
  ruby :002 > g1.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}
   => [5] 
  ruby :003 > g2 = RedGrape.load_graph 'data/graph-example-2.xml'
   => redgrape[vertices:809 edges:8049] 
  ruby :004 > g2.v(89).as('x').outE.inV.loop('x'){loops < 3}.path
   => [[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]], [...
  ruby :005 > exit
  $ 

In REPL, the `take' method is automatically called.

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
