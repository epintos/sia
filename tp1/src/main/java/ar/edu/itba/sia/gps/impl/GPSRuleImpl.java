package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.gps.api.CostFunction;
import ar.edu.itba.sia.gps.api.GPSRule;
import ar.edu.itba.sia.gps.api.GPSState;
import ar.edu.itba.sia.gps.exception.NotAppliableException;

import java.awt.*;

public class GPSRuleImpl implements GPSRule {

    private Piece piece;
    private int y;
    private int x;
    private CostFunction function;

    public GPSRuleImpl(Piece piece, int y, int x, CostFunction function) {
        this.piece = piece;
        this.y = y;
        this.x = x;
        this.function = function;
    }
    public Integer getCost(GPSState state) {
        return function.getCost(piece, state);
    }

    public String getName() {
        return "Put " + piece.toString() + " in " + y + " " + x;
    }



    public GPSState evalRule(GPSState state) throws NotAppliableException {
        Board board = state.getBoard();

        if (board.containsPiece(piece)) {
            return null;
        }

        if (!board.getPieceIn(x, y).isEmpty()) {
            return null;
        }

        return GPSStateImpl.fromParent(state, new Point(x, y), piece);
    }


}
