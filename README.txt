# RedGrape - Extremely Simple GraphDB

* https://github.com/technohippy/red-grape

## DESCRIPTION:

RedGrape is an in-memory graph database written in ruby. I made this in order to learn how graph databases work so that please do not use this for any serious purpose.

## FEATURES/PROBLEMS:

* REPL
* load GraphML
* construct a graph programmatically
* traverse nodes and edges

## SYNOPSIS:

  g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  g1.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.take
  # => [5]

  g2 = RedGrape.load_graph 'data/graph-example-2.xml'
  g2.v(89).as('x').outE.inV.loop('x'){loops < 3}.path.take
  # => [[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]], [v[89], 

## REPL:

  $ bin/redgrape 
          T
        ooooo
  -----  ooo  -----
   RED    o   GRAPE
  -----------------
  ruby :001 > g = RedGrape.create_tinker_graph
   => redgrape[vertices:6 edges:6] 
  ruby :002 > g.class
   => RedGrape::Graph 
  ruby :003 > g.V
   => [v[1], v[2], v[3], v[4], v[5], v[6]] 
  ruby :004 > g.V.name
   => ["marko", "vadas", "lop", "josh", "ripple", "peter"] 
  ruby :005 > g.E
   => [e[7][1-knows->2], e[8][1-knows->4], e[9][1-created->3], e[10][4-created->5], e[11][4-created->3], e[12][6-created->3]] 
  ruby :006 > v = g.v(1)
   => v[1] 
  ruby :007 > "#{v.name} is #{v.age} years old."
   => "marko is 29 years old." 
  ruby :008 > v.out
   => [v[2], v[4], v[3]] 
  ruby :009 > v.out('knows')
   => [v[2], v[4]] 
  ruby :010 > v.outE
   => [e[7][1-knows->2], e[8][1-knows->4], e[9][1-created->3]] 
  ruby :011 > v.outE('knows')
   => [e[7][1-knows->2], e[8][1-knows->4]] 
  ruby :012 > v.outE.weight
   => [0.5, 1.0, 0.4] 
  ruby :013 > v.outE.has('weight', :lt, 1).inV
   => [v[2], v[3]] 
  ruby :014 > v.outE.filter{it.weight < 1}.inV
   => [v[2], v[3]] 
  ruby :015 > v.out('knows').filter{it.age > 30}.out('created').name
   => ["ripple", "lop"] 

In REPL, the `take' method which invokes all pipes is automatically called.

## REQUIREMENTS:

* Nokogiri (http://nokogiri.org/)

## DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## REFERENCES:

* [Gremlin](https://github.com/tinkerpop/gremlin/wiki)
* [Pipes](https://github.com/tinkerpop/pipes/wiki/)

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
