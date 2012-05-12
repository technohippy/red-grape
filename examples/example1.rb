# http://markorodriguez.com/2011/08/03/on-the-nature-of-pipes/

$: << 'src'
require 'red_grape'

g = RedGrape.load_graph 'data/graph-example-1.xml'

puts "g.v(1): #{g.v(1)}"

puts "g.v(1).out: #{g.v(1).out}"
puts "g.v(1).out.name: #{g.v(1).out.name}"
puts "g.v(1).out.name.paths: #{g.v(1).out.name.paths}"
puts "g.v(1).out.name.paths.to_a: #{g.v(1).out.name.paths.to_a}"

puts "g.v(1).out('knows'): #{g.v(1).out('knows')}"
puts "g.v(1).out('knows').filter{self.age < 30}: #{g.v(1).out('knows').filter{self.age < 30}}"
puts "g.v(1).out('knows').filter{self.age < 30}.name: #{g.v(1).out('knows').filter{self.age < 30}.name}"
puts "g.v(1).out('knows').filter{self.age < 30}.name.transform{self.size}: #{g.v(1).out('knows').filter{self.age < 30}.name.transform{self.size}}"
puts "g.v(1).out('knows').filter{self.age < 30}.name.transform{self.size}.to_a: #{g.v(1).out('knows').filter{self.age < 30}.name.transform{self.size}.to_a}"

puts "g.v(1).side_effect{x = self}: #{g.v(1).side_effect{x = self}}"
#puts "g.v(1).side_effect{x = self}.out('created'): #{g.v(1).side_effect{x = self}.out('created')}"
#puts "g.v(1).side_effect{x = self}.out('created').in('created'): #{g.v(1).side_effect{x = self}.out('created').in('created')}"
#puts "g.v(1).side_effect{x = self}.out('created').in('created').filter{self != x}: #{g.v(1).side_effect{x = self}.out('created').in('created').filter{self != x}}"
#puts "g.v(1).side_effect{x = self}.out('created').in('created').filter{self != x}.to_a: #{g.v(1).side_effect{x = self}.out('created').in('created').filter{self != x}.to_a}"

#puts "g.v(1).out('knows').if_then_else(->{self < 30}, ->{self.name}, ->{self.out('created').name}): #{g.v(1).out('knows').if_then_else(->{self < 30}, ->{self.name}, ->{self.out('created').name})}"

#puts "g.v(1).out('knows').name: #{g.v(1).out('knows').name}"
#puts "g.v(1).out('knows').name.filter{self[0] == 'v'}: #{g.v(1).out('knows').name.filter{self[0] == 'v'}}"
#puts "g.v(1).out('knows').name.filter{self[0] == 'v'}.back(2): #{g.v(1).out('knows').name.filter{self[0] == 'v'}.back(2)}"
#puts "g.v(1).out('knows').name.filter{self[0] == 'v'}.back(2).to_a: #{g.v(1).out('knows').name.filter{self[0] == 'v'}.back(2).to_a}"
#puts "g.v(1).out('knows').as('here').name.filter{self[0] == 'v'}.back('here'): #{g.v(1).out('knows').as('here').name.filter{self[0] == 'v'}.back('here')}"

#puts "g.v(1).out.loop(1){self.loops < 3}: #{g.v(1).out.loop(1){self.loops < 3}}"
#puts "g.v(1).out.loop(1){self.loops < 3}.name: #{g.v(1).out.loop(1){self.loops < 3}.name}"
