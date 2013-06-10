package ar.edu.itba.sia;

import ar.edu.itba.sia.domain.costFunctions.CenterCostFunction;
import ar.edu.itba.sia.domain.costFunctions.DummyCostFunction;
import ar.edu.itba.sia.domain.costFunctions.RotationCostFunction;
import ar.edu.itba.sia.domain.heuristics.CenterHeuristic;
import ar.edu.itba.sia.domain.heuristics.ColorHeuristic;
import ar.edu.itba.sia.domain.heuristics.OrderHeuristic;
import ar.edu.itba.sia.gps.api.CostFunction;
import ar.edu.itba.sia.gps.api.GPSProblem;
import ar.edu.itba.sia.gps.api.Heuristic;
import ar.edu.itba.sia.gps.impl.*;
import com.google.common.collect.Sets;

import java.lang.reflect.InvocationTargetException;
import java.util.Set;

public class AppConfig {
    Set<Heuristic> heuristics = Sets.newHashSet();
    private String filePath;
    private int boardSize;
    private double nodePrintFactor;
    private Class<? extends GPSEngine> method;
    private int cachedepth;
    private CostFunction costfunction;
    private int timeoutSeconds;
	private boolean checkSymmetry;
    private int boardColor;
    private boolean onlyResult;
    private boolean shuffleRules;

    public void setHeuristic(String heuristic) {
        if (heuristic.contains("center")) {
            heuristics.add(new CenterHeuristic());
        }
        if (heuristic.contains("order")) {
            heuristics.add(new OrderHeuristic());
        }
        if (heuristic.contains("color")) {
            heuristics.add(new ColorHeuristic());
        }
    }

    public void setMethod(String method) {
        if (method.equals("DFS")) {
            this.method = DFSEngine.class;
        } else if (method.equals("BFS")) {
            this.method = BFSEngine.class;
        } else if (method.equals("ID")) {
            this.method = IDEngine.class;
        } else if (method.equals("AStar")) {
            this.method = AStarEngine.class;
        } else if (method.equals("Greedy")) {
            this.method = GreedyEngine.class;
        }     else {
            throw new RuntimeException("Invalid method passed!");
        }

    }

    public void setCachDepth(int cachedepth) {
        this.cachedepth = cachedepth;
    }

    public GPSEngine getEngine(GPSProblem problem) {
        try {
            return this.method.getConstructor(GPSProblem.class).newInstance(problem);
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        return null;
    }

    public CostFunction getCostFunction() {
        return costfunction;
    }

    public void setCostFunction(String costfunction) {
        if (costfunction.equals("dummy")) {
            this.costfunction = new DummyCostFunction();
        } else if (costfunction.equals("rotation")) {
            this.costfunction = new RotationCostFunction();
        } else if (costfunction.equals("center")) {
            this.costfunction = new CenterCostFunction();
        } else {
            throw new RuntimeException("Invalid cost function passed!");
        }
    }

    public Set<Heuristic> getHeuristics() {
        return heuristics;
    }

    public double getNodePrintFactor() {
        return nodePrintFactor;
    }

    public void setNodePrintFactor(double nodePrintFactor) {
        this.nodePrintFactor = nodePrintFactor;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public int getBoardSize() {
        return boardSize;
    }

    public void setBoardSize(int boardSize) {
        this.boardSize = boardSize;
    }

    public int cacheDepthSize() {
        return this.cachedepth;
    }

    public int getTimeoutSeconds() {
        return timeoutSeconds;
    }

    public void setTimeoutSeconds(int timeoutSeconds) {
        this.timeoutSeconds = timeoutSeconds;
    }

    public boolean getCheckSymmetry() {
		return this.checkSymmetry;
	}

	public void setCheckSymmetry(boolean checkSymmetry) {
		this.checkSymmetry = checkSymmetry;
	}

    public int getBoardColor() {
        return boardColor;
    }

    public void setBoardColor(Integer boardColor) {
        this.boardColor = boardColor;
    }

    public void setOnlyResult(boolean onlyResult) {
        this.onlyResult = onlyResult;
    }

    public boolean isOnlyResult() {
        return onlyResult;
    }

    public boolean shuffleRules() {
        return shuffleRules;
    }

    public void setShuffleRules(boolean shuffleRules) {
        this.shuffleRules = shuffleRules;
    }
}