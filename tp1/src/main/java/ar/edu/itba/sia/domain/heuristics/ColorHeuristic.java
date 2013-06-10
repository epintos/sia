package ar.edu.itba.sia.domain.heuristics;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.domain.Util;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.api.Heuristic;

/**
 * Created with IntelliJ IDEA.
 * User: cris
 * Date: 23/03/13
 * Time: 11:50
 * To change this template use File | Settings | File Templates.
 */
public class ColorHeuristic implements Heuristic {

    private boolean isValidColorCount(Board board) {
        Piece piece = board.getPiece();

        if (piece.getDownColor() != 0 &&
                board.getColorCountFor(Board.Direction.UP, piece.getDownColor()) < 0) {
            return false;
        }
        if (piece.getUpColor() != 0 &&
                board.getColorCountFor(Board.Direction.DOWN, piece.getUpColor()) < 0) {
            return false;
        }
        if (piece.getRightColor() != 0 &&
                board.getColorCountFor(Board.Direction.LEFT, piece.getRightColor()) < 0) {
            return false;
        }
        if (piece.getLeftColor() != 0 &&
                board.getColorCountFor(Board.Direction.RIGHT, piece.getLeftColor()) < 0) {
            return false;
        }
        return true;
    }

    @Override
    public Integer apply(GPSState state) {

        Board board = state.getBoard();

        int result = -1;

        if (result == -1
                && board.getPiece() != null
                && !Util.canPutPieceOnBoard(board.getPiece(), board,
                board.getPieceLocation().x, board.getPieceLocation().y)) {
            result = Integer.MAX_VALUE / 10;
        }
        if (result == -1 && board.getPiece() != null && !board.isValid()) {
            result = Integer.MAX_VALUE / 10;
        }

        if (result == -1 && board.getPiece() != null && !isValidColorCount(board)) {
            result = Integer.MAX_VALUE / 10;
        }
        else if (result == -1) {
            result = (board.getHeight() * board.getWidth() - board.getPieceCount());
        }

        return result;
    }
}
