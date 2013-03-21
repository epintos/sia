package ar.edu.itba.sia.domain.heuristics;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Util;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.api.Heuristic;

public class BorderHeuristic implements Heuristic {

	@Override
	public Integer apply(GPSState state) {
		Board board = state.getBoard();
		
		if(!Util.canPutPieceOnBoard(board.getPiece(), board, board.getPieceLocation().x, board.getPieceLocation().y)) {
			return Integer.MAX_VALUE;
		}
		if(!board.isValid()) {
			return Integer.MAX_VALUE;
		}
		int complete = 0;
		int actual = 0;
		int n = board.getWidth();
		int constant = n/2;
		for (int i = 0; i < board.getHeight(); i++) {
			for (int j = 0; j < board.getWidth(); j++) {
				int distance = Math.abs(constant - i) + Math.abs(constant - j);
				if(board.getPieceIn(i, j).isEmpty()) {
					complete += distance;
				} else {
					complete += distance;
					actual += distance;
				}
			}
			
		}
		
		return complete - actual;
	}

}
