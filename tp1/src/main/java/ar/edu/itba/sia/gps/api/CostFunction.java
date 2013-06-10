package ar.edu.itba.sia.gps.api;

import ar.edu.itba.sia.domain.Piece;


public interface CostFunction {

	Integer getCost(Piece piece, GPSState state);
	
}
