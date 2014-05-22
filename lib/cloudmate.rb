require 'cloudmate/version'
require 'cloudmate/node'
require 'cloudmate/provider'

class Cloudmate

  $child_node
  $current_node = nil
  $tmp_asynchronously = false
  $tmp_safely = false
  $tmp_execution_place = 'localhost'
  $in_after_scope = false
  $in_before_scope = false
  $root

  def Cloudmate::experiment(name, &block)
    $root = Node.new(nil,block)
    $current_node = $root
    block.call
  end

  def asynchronously
    $child_node = ConcurrentNode.new($current_node, nil)
    $current_node.node_list.push($child_node)
    $current_node = $child_node
  end

  def safely
    puts 'should be safely'
  end

  def before(*args, &block)
    $in_before_scope = true
    yield
    $in_before_scope = false
    #$current_node.before_list.push(block)
  end

  def after(*args, &block)
    $in_after_scope = true
    yield
    $in_after_scope = false
#    $current_node.after_list.push(block)
  end

  def foreach(parameters, *args, &block)
    parameters.each do |parameter|
      $child_node = Node.new($current_node, block)
      $child_node.is_safely = $tmp_safely
      $child_node.is_asynchronously = $tmp_asynchronously
      $current_node.node_list.push($child_node)

      $current_node = $child_node
      block.call parameter
      $current_node = $current_node.parent
    end
  end

  def on(instance, *args, &block)
    $child_node = OnNode.new($current_node, instance, block)

    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def concurrent(*args, &block)
    $child_node = ConcurrentNode.new($current_node, block)
    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def execute(*args, &block)
    $child_node = ExecutionBlock.new($current_node, block)
    $child_node.is_safely = $tmp_safely
    $child_node.is_asynchronously = $tmp_asynchronously
    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def ssh(command)
    if $in_before_scope then
      $current_node.before_list.push(command)
    elsif $in_after_scope then
      $current_node.after_list.push(command)
    else
      $current_node.commands.push(command)
    end
  end
end
