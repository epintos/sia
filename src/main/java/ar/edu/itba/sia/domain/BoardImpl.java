package ar.edu.itba.sia.domain;

import ar.edu.itba.sia.domain.persist.GameXML;
import ar.edu.itba.sia.domain.renderer.BoardRenderer;
import ar.edu.itba.sia.gps.api.GPSState;
import com.google.common.collect.Maps;

import java.awt.*;
import java.util.Collection;
import java.util.Map;

public class BoardImpl implements Board {

	private Map<Point, Piece> board = Maps.newHashMap();
    private Map<Piece, Boolean> pieceCache = Maps.newHashMap();

    private static double cacheFactor = 0.33;

	private int height;
	private int width;
	private GPSState state;
	private Board parent;

    // TODO: Fix this for rotations
    private Map<BoardImpl.Direction, short[]> availableColors = Maps.newHashMapWithExpectedSize(4);
	private Point pieceLocation;
	private Piece piece;
    private int depth;
    private int colorCount;
    private int checkSum = -1;
    private int rotationLevel;

    private BoardImpl() {}
    
    public static Board initialBoard(int height, int width, GPSState state, Collection<Piece> piecesInProblem, int colorCount) {
    	BoardImpl board = new BoardImpl();
    	board.height = height;
    	board.width = width;
    	board.state = state;    	
    	board.depth = 0;
        board.colorCount = colorCount;
        board.buildColorCountMap(piecesInProblem);
        return board;
    }
    
    public static Board fromParent(GPSState state,
			Point pieceLocation, Piece toAdd) {
    	BoardImpl board = new BoardImpl();
    	board.height = state.getParent().getBoard().getHeight();
    	board.width = state.getParent().getBoard().getWidth();
    	board.state = state;
        board.colorCount = state.getParent().getBoard().getColorCount();
    	board.pieceLocation = pieceLocation;
    	board.piece = toAdd;
        board.depth = state.getParent().getBoard().getDepth() + 1;
        board.parent = state.getParent().getBoard();
    	board.decrementColorCount(toAdd, state.getParent().getBoard());
        board.setPieceIn(pieceLocation.x, pieceLocation.y, toAdd);
		return board;
	}
    


	private void buildColorCountMap(Collection<Piece> pieces) {
        getAvailableColors().put(Board.Direction.UP, new short[this.colorCount]);
        getAvailableColors().put(Board.Direction.DOWN, new short[this.colorCount]);
        getAvailableColors().put(Board.Direction.LEFT, new short[this.colorCount]);
        getAvailableColors().put(Board.Direction.RIGHT, new short[this.colorCount]);
        short[] up, down, left, right;
        up    = getAvailableColors().get(Board.Direction.UP);
        down  = getAvailableColors().get(Board.Direction.DOWN);
        left  = getAvailableColors().get(Board.Direction.LEFT);
        right = getAvailableColors().get(Board.Direction.RIGHT);
        for(Piece p : pieces) {
            if (p.getUpColor() > 0) {
                up[p.getUpColor() - 1]++;
            }
            if (p.getDownColor() > 0) {
                down[p.getDownColor() - 1]++;
            }
            if (p.getLeftColor() > 0) {
                left[p.getLeftColor() - 1]++;
            }
            if (p.getRightColor() > 0) {
                right[p.getRightColor() - 1]++;
            }
        }
    }

    private void decrementColorCount(Piece addedPiece, Board parent) {
        for(Board.Direction d : parent.getAvailableColors().keySet()) {
            getAvailableColors().put(d, parent.getAvailableColors().get(d).clone());
        }

        if (addedPiece.getDownColor() > 0) {
            short[] downCount = getAvailableColors().get(Board.Direction.DOWN);
            downCount[addedPiece.getDownColor() - 1]--;
        }
        if (addedPiece.getUpColor() > 0) {
            short[] upCount = getAvailableColors().get(Board.Direction.UP);
            upCount[addedPiece.getUpColor() - 1]--;
        }
        if (addedPiece.getLeftColor() > 0) {
            short[] leftCount = getAvailableColors().get(Board.Direction.LEFT);
            leftCount[addedPiece.getLeftColor() - 1]--;
        }
        if (addedPiece.getRightColor() > 0) {
            short[] rightCount = getAvailableColors().get(Board.Direction.RIGHT);
            rightCount[addedPiece.getRightColor() - 1]--;
        }
    }



	public Board rotateBoard() {
        BoardImpl board = new BoardImpl();
        board.height = this.height;
        board.width = this.width;
        board.state = this.state;
        board.colorCount = this.colorCount;
        board.pieceLocation = this.pieceLocation;
        board.piece = this.piece;
        if (state != null) {
            board.depth = state.getParent().getBoard().getDepth() + 1;
            board.parent = state.getParent().getBoard();
        }
        board.rotationLevel = this.rotationLevel + 1;
        board.board = this.board;
        return board;
    }

    public int getHeight() {
		return height;
	}

	public int getWidth() {
		return width;
	}

	public int getPieceCount() {
        return depth;
	}



	public void setPieceIn(int x, int y, Piece piece) {
		board.put(new Point(x, y), piece);
	}

	@Override
	public boolean equals(Object obj) {
		BoardImpl board2 = (BoardImpl) obj;
		if (board2.depth == this.depth) {
            for (Point p : board.keySet()) {
                Point myPoint = Util.rotate(p, this.rotationLevel, this.width);
                Point point = Util.rotate(p, board2.rotationLevel, this.width);
                if (!board2.getPieceIn(point)
                        .rotate(board2.rotationLevel)
                        .equals(getPieceIn(myPoint).rotate(this.rotationLevel))) {
                    return false;
                }
            }
            return true;
        }  else {
            return false;
        }
	}

	public static Board withPieces(int width, int height,
			Map<Point, GameXML.GameNode> map) {
		BoardImpl b = new BoardImpl(); 
		b.width = width;
		b.height = height;
		for (Point point : map.keySet()) {
			b.board.put(new Point(point.x, point.y), map.get(point).toPiece());
		}
		return b;
	}

    private boolean cacheableBoard() {
        return depth <= 12;

    }

	public boolean containsPiece(Piece piece) {
        boolean result;
        if (piece != null && cacheableBoard() && (pieceCache.containsKey(piece))) {
            return pieceCache.get(piece);
        }

		if (this.piece != null && this.piece.hasSameIdWith(piece)) {
            result = true;
		} else {
			if (parent == null) {
				result = false;
			} else {
				result = parent.containsPiece(piece);
			}
            if (cacheableBoard()) {
                pieceCache.put(piece, result);
            }
		}
        return result;
	}

    @Override
    public int getDepth() {
        return depth;
    }

    @Override
    public int getColorCount() {
        return colorCount;
    }

    @Override
    public int getColorCountFor(Direction up, int color) {
        return availableColors.get(up)[color - 1];
    }

    @Override
    public Piece getPiece() {
        return piece;
    }

    @Override
    public boolean isValid() {
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                if (!Util.canPutPieceOnBoard(getPieceIn(x, y), this, x, y)) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
	public int getChecksum() {
        int sum = 0;
        if (checkSum == -1) {
            if (piece != null) {
                sum += piece.generateChecksum();
            }
            if (parent != null) {
                sum += parent.getChecksum();
            }
            return sum;
        } else {
            return checkSum;
        }

    }

	@Override
	public Piece getPieceIn(Point point) {
        Point rotated = Util.rotate(point, this.rotationLevel, this.width);
        Piece p = board.get(rotated);
        if (p == null) {
            if (parent != null) {
                p = parent.getPieceIn(rotated);
            } else {
                p = PieceImpl.empty();
			}
            if (cacheableBoard()) {
                board.put(rotated, p);
            }
		}
        return p.rotate(this.rotationLevel);
    }

    public Piece getPieceIn(int x, int y) {
        return getPieceIn(new Point(x, y));
    }



	public Map<BoardImpl.Direction, short[]> getAvailableColors() {
		return availableColors;
	}

	@Override
	public Point getPieceLocation() {
		return pieceLocation;
	}

    @Override
    public String toString() {
        return new BoardRenderer(this).renderString();
    }

}
