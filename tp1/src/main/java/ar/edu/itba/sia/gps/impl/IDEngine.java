package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.gps.api.GPSProblem;
import ar.edu.itba.sia.gps.api.StatsHolder;

public class IDEngine extends DFSEngine {

	private int depth = 0;

	public IDEngine(GPSProblem problem) {
		super(problem);
	}

	@Override
	public boolean engine(GPSProblem myProblem,
			StatsHolder holder) {
		boolean solutionFound = false;
		long start = System.currentTimeMillis();
//		holder.startSimulation();
		while (!solutionFound) {
			
//			holder.resetStats();
			solutionFound = super.engine(myProblem, holder);
			if(!solutionFound) {
				System.out.println("No solution found for depth: " + depth);
			}
			depth++;
		}
		long end = System.currentTimeMillis();
		System.out.println(start);
		System.out.println(end);
		System.out.println((end-start));
		System.out.println((end-start)/1000);
//		holder.stopSimulation();
		return solutionFound;
	}

	@Override
	protected boolean explode(GPSNode node) {
		if (node.getDepth() >= depth) {
			return false;
		}
		return super.explode(node);
	}
	
	@Override
	protected void startSim(StatsHolder holder) {
		//do nothing!
	}
	
	@Override
	protected void stopSim(StatsHolder holder) {
		//do nothing!
	}

}
