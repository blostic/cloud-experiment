require './foreach.rb'

foreach [1, 2, 3, 4], asynchronously, safely do |x|
	foreach ['a', 'b', 'c'], asynchronously do |y|
		print "[x: ", x, ", y: ", y, "]\n"
	end
end
