require 'node.rb'

class OnNode < Node
	attr_accessor :instance
	def initialize (parent, instance, block)
		super(parent, block)
		self.instance = instance
    self.name = "[OnNode]\n" + instance
  end

  def run(instance)
    init_time

    before_exec(@instance, @total_time)
    node_list.each do |node|
      puts @instance
      @total_time[:exec].push(node.run(@instance))
    end

    after_exec(@instance, @total_time)

    return @total_time
  end

  def draw_block(graph)
    graph.hexagon << graph.node(id)
    graph.node(id).label(name)
  end

end