package ar.edu.itba.sia.domain;

import ar.edu.itba.sia.gps.api.StatsHolder;

public class StatsHolderImpl implements StatsHolder {
	
	private long start = 0 ;
	private long end = 0;
	private long states = 0;
	private long depth = 0;
	private long explotions = 0;
	private long leafNodes = 0;
    private Integer symmetriesCount = 0;

    public void addState() {
		states++;
	}
    public void addSymmetry() {
        symmetriesCount++;
    }

	public long getStatesNumber() {
		return states;
	}

	public void setSolutionDepth(long depth) {
		this.depth = depth;
	}

	public long getSolutionDepth() {
		return depth;
	}

	public void startSimulation() {
		this.start = System.currentTimeMillis();
	}

	public void stopSimulation() {
		this.end = System.currentTimeMillis();
	}

	public long getSimulationTime() {
		return end - start;
	}

	public void addExplodedNode() {
		explotions++;
	}

	public long getExplodedNodes() {
		return explotions;
	}

	public void addLeafNode() {
		leafNodes++;
	}

	public long getLeafNodesNumber() {
		return leafNodes;
	}
	
	public void resetStats() {
		start = 0;
		end = 0;
		states = 0;
		depth = 0;
		leafNodes = 0;
		explotions = 0;
	}
	
	@Override
	public void setLeafNodes(long leafNodes) {
		this.leafNodes = leafNodes;
	}

    @Override
    public Integer getSymmetriesCount() {
        
        return symmetriesCount;
    }

}
