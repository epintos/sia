package ar.edu.itba.sia.domain.costFunctions;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.gps.api.CostFunction;
import ar.edu.itba.sia.gps.api.GPSState;

/**
 * Created with IntelliJ IDEA.
 * User: cris
 * Date: 24/03/13
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */
public class CenterCostFunction implements CostFunction {
    @Override
    public Integer getCost(Piece piece, GPSState state) {
        Board board = state.getBoard();
        int actual = 0;
        int n = board.getWidth();
        int constant = n / 2;

        if (state.getBoard().getPiece() != null) {

            int i = state.getBoard().getPieceLocation().x;
            int j = state.getBoard().getPieceLocation().y;


            return (Math.abs(constant - 0)
                    + Math.abs(constant - 0)) - (Math.abs(constant - i)
                    + Math.abs(constant - j));
        } else {
            return 0;
        }


    }
}
