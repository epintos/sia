package ar.edu.itba.sia.domain.heuristics;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Util;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.api.Heuristic;

import java.util.Random;

public class CenterHeuristic implements Heuristic {

	private static Random r = new Random();

	@Override
	public Integer apply(GPSState state) {
		Board board = state.getBoard();

		try {

			int result = -1;
			
			double factor = 1.0;

			if (result == -1
					&& !Util.canPutPieceOnBoard(board.getPiece(), board,
							board.getPieceLocation().x,
							board.getPieceLocation().y)) {
				result = Integer.MAX_VALUE / 10;
			}
			if (result == -1 && !board.isValid()) {
				result = Integer.MAX_VALUE / 10;
			}

			if (result == -1 && board.getDepth() <= 4) {
				int i = board.getPieceLocation().x;
				int j = board.getPieceLocation().y;
				if (!((j == 0 && i == 0)
						|| (j == 0 && i == board.getWidth() - 1)
						|| (i == 0 && j == board.getWidth() - 1) || (i == board
						.getWidth() - 1 && j == board.getWidth() - 1))) {
					result = Integer.MAX_VALUE / 10;
				}
			}

			if (result == -1
					&& board.getDepth() <= board.getWidth() * 2
							+ (board.getWidth() - 2) * 2) {
				int i = board.getPieceLocation().x;
				int j = board.getPieceLocation().y;
				if (!(j == 0 || i == 0 || i + 1 == board.getHeight() || j + 1 == board
						.getWidth())) {
					result = Integer.MAX_VALUE / 10;
				}
			}

			if (result == -1) {
				int complete = 0;
				int actual = 0;
				int n = board.getWidth();
				int constant = n / 2;
				for (int i = 0; i < board.getHeight(); i++) {
					for (int j = 0; j < board.getWidth(); j++) {
						int distance = Math.abs(constant - i)
								+ Math.abs(constant - j);
						if (!board.getPieceIn(i, j).isEmpty()) {
							actual += distance;
						}
						complete += distance;
					}
				}
				result = (complete - actual) * (n * n);
			}

			return (int) (result * factor);
		} catch (Exception e) {
			return 0;
		}

	}

}
