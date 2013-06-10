package ar.edu.itba.sia;

import ar.edu.itba.sia.domain.Board;
import ar.edu.itba.sia.domain.BoardImpl;
import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.domain.StatsHolderImpl;
import ar.edu.itba.sia.domain.persist.GameXML;
import ar.edu.itba.sia.domain.persist.generate.GameGenerator;
import ar.edu.itba.sia.domain.renderer.BoardRenderer;
import ar.edu.itba.sia.gps.api.GPSProblem;
import ar.edu.itba.sia.gps.api.StatsHolder;
import ar.edu.itba.sia.gps.impl.GPSEngine;
import ar.edu.itba.sia.gps.impl.GPSProblemImpl;
import com.google.common.collect.Lists;

import java.awt.*;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import static ar.edu.itba.sia.CLIParser.getAppConfig;


public class App {

    public static AtomicBoolean isOver = new AtomicBoolean(false);

    public static AtomicBoolean cut = new AtomicBoolean(false);

    public static void main(String[] args) throws Exception {
        final AppConfig config;

        config = getAppConfig(args);

        if (config == null) {
            return;
        }

        shutDownHook();

        GameXML game;

        if (config.getFilePath() != null) {
            game = GameXML.fromXml(config.getFilePath());
        } else {
            game = new GameGenerator(config.getBoardSize(), config.getBoardColor()).generate();
        }

        Map<Point, GameXML.GameNode> map =  game.nodes;
		List<Piece> pieces = Lists.newArrayList();
        List<Point> points = Lists.newArrayList();
        points.addAll(map.keySet());
        Collections.reverse(points);
		for(Point p: points) {
			GameXML.GameNode node = map.get(p);
            pieces.add(node.toPiece());
		}

        Board board = BoardImpl.withPieces(game.gameSize, game.gameSize, map);

        if (!config.isOnlyResult())       {
            System.out.println("Showing the start level...");
            new BoardRenderer(board).render();
        }

        final StatsHolder holder = new StatsHolderImpl();

		GPSProblem problem = new GPSProblemImpl(game.gameSize, game.gameSize, pieces, game.numberOfColors, config);
        GPSEngine engine = config.getEngine(problem);


        if (config.getTimeoutSeconds() > 0){
            doTimeoutThread(config);
        }

		engine.engine(problem, holder);
		System.out.println("-------------------------------------------");
		System.out.println("Simulation time: " + holder.getSimulationTime()/(double)1000 + " seconds");
		System.out.println("Exploded nodes: " + holder.getExplodedNodes());
		System.out.println("Leaf nodes: " + holder.getLeafNodesNumber());
		System.out.println("Solution depth: " + holder.getSolutionDepth());
		System.out.println("Generated states: " + holder.getStatesNumber());
        System.out.println("Symmetries found: " + holder.getSymmetriesCount());
    }

    private static void doTimeoutThread(final AppConfig config) {
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < config.getTimeoutSeconds(); i++) {
                    if (App.cut.get()) {
                        break;
                    }
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                    }
                }

                App.isOver.set(true);
            }
        });
        t.setDaemon(false);
        t.start();
    }

    private static void shutDownHook() {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                if (App.isOver.get()) {
                    return;
                }
                App.isOver.set(true);

                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                        e.printStackTrace();
                }
            }
        });
    }
}
