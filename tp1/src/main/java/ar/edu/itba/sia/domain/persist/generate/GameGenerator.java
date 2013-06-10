package ar.edu.itba.sia.domain.persist.generate;

import ar.edu.itba.sia.domain.persist.GameXML;

import java.awt.*;
import java.util.HashMap;
import java.util.Random;

public class GameGenerator {
    private int size;
    private int colorCount;
    private float[] probabilities;

    public static void main(final String[] args) throws Exception {
		GameGenerator generator = new GameGenerator(6, 6);
        GameXML game = generator.generate();
        game.toFile("random.xml");
	}

    public GameGenerator(int size, int colorCount) {
        float[] probabilities = new float[colorCount];
        for (int i = 0; i < probabilities.length; i++) {
            probabilities[i] = (float) Math.random();
        }
        init(size, colorCount, probabilities);
    }

    public GameGenerator(int size, int colorCount, float[] colorProbability) {
        init(size, colorCount, colorProbability);
    }

    private void init(int size, int colorCount, float[] probabilities) {
        this.size = size;
        this.colorCount = colorCount;

        normalize(probabilities);

        this.probabilities = probabilities;
    }

    private void normalize(float[] probabilities) {
        float sum = 0.0f;
        float[] tmp = new float[probabilities.length];

        for (int i = 0; i < probabilities.length; i++) {
            sum += probabilities[i];
        }
        for (int i = 0; i < probabilities.length; i++) {
            tmp[i] = probabilities[i] / sum;
        }
        for (int i = 0; i < probabilities.length; i++) {
            probabilities[i] = tmp[i] + ((i > 0) ? probabilities[i - 1] : 0);
        }
    }



    public GameXML generate() {
        GameXML game = new GameXML();
        game.gameSize = size;
        game.numberOfColors = colorCount;
        game.nodes = new HashMap<Point, GameXML.GameNode>();

        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                game.nodes.put(new Point(i, j), nodeFor(game, new Point(i, j)));
            }
        }

        return game;
    }

    private GameXML.GameNode nodeFor(GameXML game, Point point) {
        GameXML.GameNode node = new GameXML.GameNode();

        if (point.getX() == 0) { node.left = 0; }
        if (point.getX() == size - 1) { node.right = 0; }
        if (point.getY() == 0) { node.up = 0; }
        if (point.getY() == size - 1) { node.down = 0; }

        GameXML.GameNode rightNode = game.nodes.get(new Point(point.x + 1, point.y));
        GameXML.GameNode leftNode  = game.nodes.get(new Point(point.x - 1, point.y));
        GameXML.GameNode upNode    = game.nodes.get(new Point(point.x, point.y - 1));
        GameXML.GameNode downNode  = game.nodes.get(new Point(point.x, point.y + 1));

        if (rightNode != null && rightNode.left != -1) { node.right = rightNode.left; }
        if (leftNode != null && leftNode.right != -1)  { node.left  = leftNode.right; }
        if (upNode != null && upNode.down != -1)       { node.up    = upNode.down; }
        if (downNode != null && downNode.up != -1)     { node.down  = downNode.up; }

        if (node.left == -1)  { node.left  = randomColor(); }
        if (node.right == -1) { node.right = randomColor(); }
        if (node.down == -1)  { node.down  = randomColor(); }
        if (node.up == -1)    { node.up    = randomColor(); }

        return node;
    }

    private Random r = new Random(System.currentTimeMillis());

    private int randomColor() {
        int ind = -1;
        float rand = r.nextFloat();

        for (int i = 0; i < probabilities.length; i++) {
            if (rand <= probabilities[i]) {
                ind = i;
                break;
            }
        }
        if (ind == -1) {
            ind = 0;
        }

        return ind + 1;
    }


}
