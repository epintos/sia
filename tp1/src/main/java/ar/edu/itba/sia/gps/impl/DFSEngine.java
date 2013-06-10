package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.gps.api.GPSProblem;

import java.util.LinkedList;
import java.util.List;

public class DFSEngine extends GPSEngine {
	
	private List<GPSNode> open = new LinkedList<GPSNode>();

    public DFSEngine(GPSProblem problem) {
        super(problem);
    }

    @Override
	public void addNode(GPSNode node) {
		super.addNode(node);
		open.add(0, node);
	}


	@Override
	protected GPSNode getNext() {
		return open.get(0);
	}

	@Override
	protected void removeNode(GPSNode node) {
		open.remove(0);
	}

	@Override
	protected int getOpenSize() {
		return open.size();
	}

	@Override
	protected void resetOpen() {
		open.clear();
	}

}
