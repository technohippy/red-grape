# RedGrape - Extremely Simple GraphDB

* https://github.com/technohippy/red-grape

## Description:

RedGrape is an in-memory graph database written in ruby. I made this application in order to learn how a graph database works so that please do not use this for any serious purpose.

## Features/Problems:

* REPL
* load GraphML
* construct a graph programmatically
* traverse nodes and edges using a gremlin-like DSL
* REST API
* Graph viewer (in progress)

## Synopsis:

    g1 = RedGrape.load_graph 'data/graph-example-1.xml'
    g1.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.take
    # => [5]

    g2 = RedGrape.load_graph 'data/graph-example-2.xml'
    g2.v(89).as('x').outE.inV.loop('x'){it.loops < 3}.path.take
    # => [[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]], [v[89], 

## REPL:

    $ bin/redgrape
             T
           oOOOo
            oOo
    -------- O --------
    irb(main):001:0> g = RedGrape.create_tinker_graph
     => redgrape[vertices:6 edges:6] 
    irb(main):002:0> g.class
     => RedGrape::Graph 
    irb(main):003:0> g.V
     => [v[1], v[2], v[3], v[4], v[5], v[6]] 
    irb(main):004:0> g.V.name
     => ["marko", "vadas", "lop", "josh", "ripple", "peter"] 
    irb(main):005:0> g.E
     => [e[7][1-knows->2], e[8][1-knows->4], e[9][1-created->3], e[10][4-created->5], e[11][4-created->3], e[12][6-created->3]] 
    irb(main):006:0> v = g.v(1)
     => v[1] 
    irb(main):007:0> "#{v.name} is #{v.age} years old."
     => "marko is 29 years old." 
    irb(main):008:0> v.out
     => [v[2], v[4], v[3]] 
    irb(main):009:0> v.out('knows')
     => [v[2], v[4]] 
    irb(main):010:0> v.outE
     => [e[7][1-knows->2], e[8][1-knows->4], e[9][1-created->3]] 
    irb(main):011:0> v.outE('knows')
     => [e[7][1-knows->2], e[8][1-knows->4]] 
    irb(main):012:0> v.outE.weight
     => [0.5, 1.0, 0.4] 
    irb(main):013:0> v.outE.has('weight', :lt, 1).inV
     => [v[2], v[3]] 
    irb(main):014:0> v.outE.filter{it.weight < 1}.inV
     => [v[2], v[3]] 
    irb(main):015:0> v.out('knows').filter{it.age:0> 30}.out('created').name
     => ["ripple", "lop"] 

In REPL, the `take' method which invokes all pipes is automatically called.

## Server/Client:

### Server:

    $ ./bin/trellis
      +=================+
      |  +     T     +  |
      | oOo  oOOOo  oOo |
      |  8    oOo    8  |
      |        O        |       
    Start server: druby://localhost:28282
    [Ctrl+C to stop]

### Client:

    $ ./bin/redgrape 
             T
           oOOOo
            oOo
    -------- O --------
    irb(main):001:0> $store
     => #<RedGrape::GraphStore:0x007fb615137a90> 
    irb(main):002:0> $store.graphs
     => [:tinker] 
    irb(main):003:0> g = $store.graph :tinker
     => redgrape[vertices:6 edges:6] 
    irb(main):004:0> g.add_vertex 7
     => redgrape[vertices:7 edges:6] 
    irb(main):005:0> store.put_graph :tinker, g
     => redgrape[vertices:7 edges:6] 

Changes on a graph are not committed until the put_graph method is called.

## REST API:

### Server: 

    $ ./bin/juicer 
    [2012-06-30 02:03:01] INFO  WEBrick 1.3.1
    [2012-06-30 02:03:01] INFO  ruby 1.9.3 (2011-10-30) [x86_64-darwin11.0.1]
    == Sinatra/1.3.2 has taken the stage on 4567 for development with backup from WEBrick
    [2012-06-30 02:03:01] INFO  WEBrick::HTTPServer#start: pid=12098 port=4567

### Use from Console:

    $ curl http://localhost:4567/
    {
      "version": "0.1.0",
      "supportedPaths": {
        "GET": [
          "/graphs",
          "/graphs/[graph]",
          "/graphs/[graph]/vertices",
          "/graphs/[graph]/vertices?key=[key]&value=[value]",
          "/graphs/[graph]/vertices/[vertex]",
          "/graphs/[graph]/vertices/[vertex]/out",
          ...
        ],
        "POST": [
          ...
        ],
        "PUT": [
          ...
        ],
        "DELETE": [
          ...
        ]
      }
    }

    $ curl http://localhost:4567/graphs
    {
      "version": "0.1.0",
      "name": "Juicer: A Graph Server",
      "graphs": [
        "tinkergraph"
      ]
    }

    $ curl http://localhost:4567/graphs/tinkergraph/vertices/1
    {
      "version": "0.1.0",
      "results": {
        "_type": "_vertex",
        "_id": "1",
        "name": "marko",
        "age": 29
      }
    }

### Use from Browser:

    http://localhost:4567/cellar/index.html

![Screenshot](https://raw.github.com/technohippy/red-grape/master/public/image/cellar.png)

## Requirements:

* Nokogiri (http://nokogiri.org/)
* Sinatra (http://www.sinatrarb.com/)

## Developers:

after checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## References:

* [Gremlin](https://github.com/tinkerpop/gremlin/wiki/)
* [Pipes](https://github.com/tinkerpop/pipes/wiki/)
* [Rexter](https://github.com/tinkerpop/rexster/wiki/)

## License:

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
