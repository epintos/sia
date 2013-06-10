heuristics = %w(center color order order,color)
costfunction = %w(rotation dummy center)
noninformed = %w(DFS BFS ID)
files = %w(random.2.xml random.3.xml random.4.xml random.5.xml random.6.xml)
informed = %w(AStar Greedy)

output = File.open("results.txt", "w+")

files.each do |file|
	noninformed.each do |method|
		output.puts "Checking method: #{method} on file: #{file}"
		output.flush
		output.puts `java -Xmx4g -jar TP1-SIA-0.0.1-SNAPSHOT-jar-with-dependencies.jar --checksymmetry true --cachedepth 36 --filename #{file} --method #{method} --timeoutseconds 60 --onlyresults true`
		output.flush
	end
end

files.each do |file|
	heuristics.each do |heuristic|
		costfunction.each do |costfunction|
			informed.each do |method|
				output.puts "Checking method: #{method} with costfunction #{costfunction} with heuristic #{heuristic} on file: #{file}"
				output.flush
				output.puts `java -Xmx4g -jar TP1-SIA-0.0.1-SNAPSHOT-jar-with-dependencies.jar --checksymmetry true --cachedepth 36 --filename #{file} --method #{method} --timeoutseconds 60 --onlyresults true --costfunction #{costfunction} --heuristic #{heuristic}`
				output.flush			
			end
		end
	end
end

# java -Xmx2g -jar TP1-SIA-0.0.1-SNAPSHOT-jar-with-dependencies.jar --heuristic order,color --method Greedy --checksymmetry true --costfunction center --cachedepth 20 --filename random.5.xml --timeoutseconds 120 --onlyresults true --help
# usage: java -jar tp1-sia.jar
#  -boardcolors,--boardcolors <arg>         Disable or enable symmetry check
#  -boardsize,--boardsize <arg>             If no filename is passed,
#                                           generates a random board with
#                                           the size given.
#  -cachedepth,--cachedepth <arg>           The depth of the cache size for
#                                           accesing board elements, a low
#                                           value has a negative impact on
#                                           CPU but uses few RAM, but the
#                                           higher the value is, the more
#                                           RAM it consumes
#  -checksymmetry,--checksymmetry <arg>     Disable or enable symmetry check
#  -costfunction,--costfunction <arg>       Cost function to use: color,
#                                           dummy, rotation, center, default
#                                           is dummy
#  -filename,--filename <arg>               The filename of the board to
#                                           load, must be a valid XML
#  -help,--help                             Shows this help
#  -heuristic,--heuristic <arg>             The heuristic to use (only with
#                                           AStar/Greedy methods), accepted
#                                           values are: center, order, color
#  -method,--method <arg>                   The method to explore, options
#                                           are: ID, DFS, BFS, AStar, Greedy
#  -onlyresults,--onlyresults <arg>         Only show results
#  -shownodes,--shownodes                   The percentage of evaluated
#                                           nodes to show, accepted value: a
#                                           double from 0 to 1
#  -timeoutseconds,--timeoutseconds <arg>   The time it takes to cut the
#                                           simulation, in seconds.