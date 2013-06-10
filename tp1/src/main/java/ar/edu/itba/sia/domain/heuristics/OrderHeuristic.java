package ar.edu.itba.sia.domain.heuristics;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Util;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.api.Heuristic;
import com.google.common.collect.Maps;

import java.util.Map;

public class OrderHeuristic implements Heuristic {

    private static Map<GPSState,Integer> cache = Maps.newHashMap();

    @Override
	public Integer apply(GPSState state) {

//        if (cache.containsKey(state)) {
//            return cache.get(state);
//        }

        int result = -1;

        if (result == -1 && state.getBoard().getPiece() != null
                && !Util.canPutPieceOnBoard(state.getBoard().getPiece(), state.getBoard(),
                state.getBoard().getPieceLocation().x, state.getBoard().getPieceLocation().y)) {
            result = Integer.MAX_VALUE / 10;
        }
        if (result == -1 && state.getBoard().getPiece() != null && !state.getBoard().isValid()) {
            result = Integer.MAX_VALUE / 10;
        }

        if (state.getBoard().getPiece() == null || (result == -1 && Util.isValidEvalLocation(state))) {
            Board board = state.getBoard();
			int max = state.getBoard().getHeight() * state.getBoard().getWidth();
			int depth = board.getDepth();
			int x = depth % board.getWidth();
	    	int y = depth / board.getHeight();
	    	result = max - y * board.getWidth() - x;
		} else {
            result = Integer.MAX_VALUE / 10;
		}


//        cache.put(state, result);
        return result;
	}
}
