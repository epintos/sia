package ar.edu.itba.sia.gps.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.gps.api.GPSProblem;
import ar.edu.itba.sia.gps.api.GPSRule;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.api.SearchStrategy;
import ar.edu.itba.sia.gps.api.StatsHolder;
import ar.edu.itba.sia.gps.exception.NotAppliableException;

import com.google.common.collect.Sets;

public abstract class GPSEngine {

	private List<GPSNode> closed = new ArrayList<GPSNode>();

	private GPSProblem problem;

	private StatsHolder stats;

	// Use this variable in the addNode implementation
	private SearchStrategy strategy;

	public GPSEngine(GPSProblem problem, SearchStrategy strategy) {
		super();
		this.problem = problem;
		this.strategy = strategy;
	}

	private Random r = new Random();

	public boolean engine(GPSProblem myProblem, SearchStrategy myStrategy,
			StatsHolder holder) {
		visitedBoards.clear();
		closed.clear();
		resetOpen();
		this.stats = holder;
		problem = myProblem;
		strategy = myStrategy;

		GPSNode rootNode = new GPSNode(problem.getInitState(), 0);
		stats.addState();
		boolean finished = false;
		boolean failed = false;

		addNode(rootNode);
		startSim(holder);
		while (!failed && !finished) {
			if (getOpenSize() <= 0) {
				failed = true;
			} else {
				GPSNode currentNode = getNext();
				closed.add(currentNode);
				removeNode(currentNode);

				if (isGoal(currentNode)) {
					finished = true;
					stopSim(holder);
					holder.setSolutionDepth(currentNode.getDepth());
					System.out.println("Showing a solution");
					System.out.println(currentNode.getSolution());
				} else {
					stats.addExplodedNode();
					explode(currentNode);
				}
			}
		}

		if (finished) {
			System.out.println("OK! solution found!");
			stats.setLeafNodes(getOpenSize());
			return true;
		} else if (failed) {
			System.err.println("FAILED! solution not found!");
			return false;
		}
		return false;
	}

	private boolean isGoal(GPSNode currentNode) {
		return currentNode.getState() != null
				&& problem.checkGoalState(currentNode.getState());
	}

	protected boolean explode(GPSNode node) {
		if (problem.getRules() == null) {
			return false;
		}

		for (GPSRule rule : problem.getRules()) {
			GPSState newState = null;
			try {
				newState = rule.evalRule(node.getState());
			} catch (NotAppliableException e) {
				// Do nothing
			}
			if (newState != null
					&& !checkBranch(node, newState)
					&& !checkOpenAndClosed(node.getCost() + rule.getCost(),
							newState)) {
				stats.addState();
				GPSNode newNode = new GPSNode(newState, node.getCost()
						+ rule.getCost());
				newNode.setParent(node);
				addNode(newNode);
			}
		}
		return true;
	}

	private boolean checkOpenAndClosed(Integer cost, GPSState state) {
		if (visitedBoards.contains(state.getBoard())) {
			return true;
		}

		for (int i = 1; i <= 3; i++) {
			Board b = state.getBoard().rotateBoard();
			boolean eq = visitedBoards.contains(b);
			if (eq) {
				return true;
			}

		}

		return false;
	}

	private boolean checkBranch(GPSNode parent, GPSState state) {
		if (parent == null) {
			return false;
		}
		return checkBranch(parent.getParent(), state)
				|| state.compare(parent.getState());
	}

	private HashSet<Board> visitedBoards = Sets.newHashSet();

	public void addNode(GPSNode node) {
		visitedBoards.add(node.getState().getBoard());
	}

	protected abstract Iterable<GPSNode> getOpenNodes();

	protected abstract GPSNode getNext();

	protected abstract void removeNode(GPSNode node);

	protected abstract int getOpenSize();

	public GPSProblem getProblem() {
		return problem;
	}
	
	protected abstract void resetOpen();
	
	protected void startSim(StatsHolder holder) {
		holder.startSimulation();
	}
	
	protected void stopSim(StatsHolder holder) {
		holder.stopSimulation();
	}

}
