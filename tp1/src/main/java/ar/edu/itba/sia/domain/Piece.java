package ar.edu.itba.sia.domain;

import java.awt.*;

public interface Piece {
	
	int getUpColor();

	int getDownColor();

	int getLeftColor();

	int getRightColor();
	
	int getId();

	/**
	 * Rotates the piece 90 degrees clockwise
	 * @return
	 */
	Piece rotate(int times);
	
	boolean isEmpty();


    boolean hasSameColors(Piece piece);

    boolean hasSameIdWith(Piece piece);

	long generateChecksum();
	
	public int getRotationLevel();
}
