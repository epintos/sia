package ar.edu.itba.sia.gps.api;

public interface StatsHolder {

	/**
	 * Adds one to the states counter.
	 */
	void addState();
	
	/**
	 * Returns the number of states.
	 * @return
	 */
	long getStatesNumber();
	
	/**
	 * Sets the depth for the found solution.
	 */
	void setSolutionDepth(long depth);
	
	/**
	 * Gets the depth of the solution.
	 * @return
	 */
	long getSolutionDepth();
	
	/**
	 * This method must be called before the simulation starts.
	 */
	void startSimulation();
	
	/**
	 * This method must be called when the simulation ends.
	 */
	void stopSimulation();
	
	/**
	 * Returns the simulation time in milliseconds.
	 * @return
	 */
	long getSimulationTime();
	
	/**
	 * Adds one to the counter of exploded nodes.
	 */
	void addExplodedNode();
	
	/**
	 * Gets the number of exploded nodes/
	 * @return
	 */
	long getExplodedNodes();
	
	/**
	 * Adds one to the leaf node counter.
	 */
	void addLeafNode();
	
	/**
	 * Gets the amount of leaf nodes.
	 * @return
	 */
	long getLeafNodesNumber();
	
	/**
	 * Resets all stats
	 */
	void resetStats();
	
	void setLeafNodes(long leafNodes);

    Integer getSymmetriesCount();

    void addSymmetry();
}
