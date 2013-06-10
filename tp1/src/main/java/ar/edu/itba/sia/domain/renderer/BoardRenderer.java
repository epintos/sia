package ar.edu.itba.sia.domain.renderer;

import ar.edu.itba.sia.domain.Board;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;

/**
 * Created with IntelliJ IDEA.
 * User: cris
 * Date: 14/03/13
 * Time: 17:40
 */
public class BoardRenderer {

    private Board board;
    private char[][] printMap;
    private PrintStream out;

    public BoardRenderer(Board board) {
        this.board = board;
        this.out = System.out;
        this.printMap = new char[board.getHeight() * 5 + 1][board.getWidth() * 5 + 1];
    }

    public BoardRenderer() {
		try {
			this.out = new PrintStream(new File("test.txt"));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
    
    public void setBoard(Board board) {
		this.board = board;
		this.printMap = new char[board.getHeight() * 5 + 1][board.getWidth() * 5 + 1];
	}
    
    public String renderString() {
    	return internalRender().toString();
    }
    
    private StringBuffer internalRender() {
        clearBoard();

		for (int j = 0; j < board.getHeight(); j++) {
			for (int i = 0; i < board.getWidth(); i++) {
                printMap[j * 5 + 1][i * 5 + 2] = Character.forDigit(board.getPieceIn(i,j).getUpColor() == -1? 7:board.getPieceIn(i,j).getUpColor(), 10);
                printMap[j * 5 + 3][i * 5 + 2] = Character.forDigit(board.getPieceIn(i,j).getDownColor() == -1? 7:board.getPieceIn(i,j).getDownColor(), 10);
                printMap[j * 5 + 2][i * 5 + 1] = Character.forDigit(board.getPieceIn(i,j).getLeftColor() == -1? 7:board.getPieceIn(i,j).getLeftColor(), 10);
                printMap[j * 5 + 2][i * 5 + 3] = Character.forDigit(board.getPieceIn(i,j).getRightColor() == -1? 7:board.getPieceIn(i,j).getRightColor(), 10);
            }
        }
        StringBuffer buff = new StringBuffer();
        buff.append("---------------\n");


		for (int j = 0; j < printMap.length; j++) {
			for (int i = 0; i < printMap[0].length; i++) {
				buff.append(printMap[j][i]);
			}
			buff.append("\n");
		}
        buff.append("---------------\n");
        return buff;
    }

	public void render() {
        out.print(internalRender().toString());
    }
	
	public void renderInitial() {

        clearBoard();

		for (int j = 0; j < board.getHeight(); j++) {
			for (int i = 0; i < board.getWidth(); i++) {
                printMap[j * 5 + 1][i * 5 + 2] = Character.forDigit(board.getPieceIn(i,j).getUpColor() == -1? 7:board.getPieceIn(i,j).getUpColor(), 10);
                printMap[j * 5 + 3][i * 5 + 2] = Character.forDigit(board.getPieceIn(i,j).getDownColor() == -1? 7:board.getPieceIn(i,j).getDownColor(), 10);
                printMap[j * 5 + 2][i * 5 + 1] = Character.forDigit(board.getPieceIn(i,j).getLeftColor() == -1? 7:board.getPieceIn(i,j).getLeftColor(), 10);
                printMap[j * 5 + 2][i * 5 + 3] = Character.forDigit(board.getPieceIn(i,j).getRightColor() == -1? 7:board.getPieceIn(i,j).getRightColor(), 10);
            }
        }
        StringBuffer buff = new StringBuffer();
        buff.append("---------------\n");


		for (int j = 0; j < printMap.length; j++) {
			for (int i = 0; i < printMap[0].length; i++) {
				buff.append(printMap[j][i]);
			}
			buff.append("\n");
		}
        buff.append("---------------\n");
        out.print(buff.toString());
    }

    private void clearBoard() {
        for (int i = 0; i < board.getWidth() * 5 + 1; i++) {
            for (int j = 0; j < board.getHeight() * 5 + 1; j++) {
                printMap[i][j] = ' ';
            }
        }
    }
}
