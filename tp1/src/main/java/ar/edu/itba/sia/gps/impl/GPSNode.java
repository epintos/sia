package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.gps.api.GPSState;

public class GPSNode {

	private GPSState state;

	private GPSNode parent;

	private Integer cost;
	
	public GPSNode(GPSState state, Integer cost) {
		super();
		this.state = state;
		this.cost = cost;
	}

	public GPSNode getParent() {
		return parent;
	}

	public void setParent(GPSNode parent) {
		this.parent = parent;
	}

	public GPSState getState() {
		return state;
	}

	public Integer getCost() {
		return cost;
	}

	@Override
	public String toString() {
		return state.toString();
	}

	public String getSolution() {
		if (this.parent == null) {
			return this.state.toString();
		}
		return this.parent.getSolution() + "\n" + this.state;
	}
	
	public int getDepth() {
		if(this.parent == null) {
			return 0;
		}
		return this.parent.getDepth() + 1;
	}
	
	@Override
	public boolean equals(Object obj) {
		return state.equals(((GPSNode)obj).getState());
	}
	
	@Override
	public int hashCode() {
		return state.hashCode();
	}
	
}
