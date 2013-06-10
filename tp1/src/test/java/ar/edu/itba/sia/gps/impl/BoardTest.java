package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.domain.persist.GameXML;
import org.junit.Test;

import java.awt.*;
import java.util.List;
import java.util.Map;

import static ar.edu.itba.sia.domain.BoardImpl.withPieces;
import static ar.edu.itba.sia.domain.persist.GameXML.GameNode;
import static ar.edu.itba.sia.domain.persist.GameXML.fromXml;
import static com.google.common.collect.Lists.newArrayList;
import static java.util.Collections.reverse;
import static org.junit.Assert.assertEquals;

/**
 * Created with IntelliJ IDEA.
 * User: cris
 * Date: 20/03/13
 * Time: 19:48
 */
public class BoardTest {
    @Test
    public void testRotation() throws Exception {
        GameXML game = fromXml("test.xml");
        Map<Point, GameNode> map =  game.nodes;
        List<Piece> pieces = newArrayList();
        List<Point> points = newArrayList();
        points.addAll(map.keySet());
        reverse(points);
        for(Point p: points) {
            GameNode node = map.get(p);
            pieces.add(node.toPiece());
        }

        Board board = withPieces(game.gameSize, game.gameSize, map);

//        out.println(board.toString());
//        out.println(board.rotateBoard().toString());


        assertEquals(board.rotateBoard(), board.rotateBoard());
        assertEquals(board.rotateBoard(), board);
    }

    @Test
    public void testCheckSums() throws Exception {
        GameXML game = fromXml("test.xml");
        Map<Point, GameNode> map =  game.nodes;
        List<Piece> pieces = newArrayList();
        List<Point> points = newArrayList();
        points.addAll(map.keySet());
        reverse(points);
        for(Point p: points) {
            GameNode node = map.get(p);
            pieces.add(node.toPiece());
        }

        Board board = withPieces(game.gameSize, game.gameSize, map);


        System.out.println(board.getChecksum());
        System.out.println(board.rotateBoard().getChecksum());

        assertEquals(board.equals(board.rotateBoard()), board.likelyToBeEqual(board.rotateBoard()));
        assertEquals(true, board.likelyToBeEqual(board.rotateBoard().rotateBoard()));
        assertEquals(true, board.likelyToBeEqual(board.rotateBoard().rotateBoard().rotateBoard()));
    }
}
