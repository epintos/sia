package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.gps.api.GPSProblem;

import java.util.LinkedList;
import java.util.List;

public class BFSEngine extends GPSEngine {

	private List<GPSNode> open = new LinkedList<GPSNode>();

    public BFSEngine(GPSProblem problem) {
        super(problem);
    }


    @Override
	public void addNode(GPSNode node) {
		super.addNode(node);
		open.add(node);
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
