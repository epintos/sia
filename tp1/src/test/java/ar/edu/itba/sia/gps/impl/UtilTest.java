package ar.edu.itba.sia.gps.impl;

import ar.edu.itba.sia.domain.Util;
import org.junit.Test;

import java.awt.*;

import static junit.framework.Assert.assertEquals;

/**
 * Created with IntelliJ IDEA.
 * User: cris
 * Date: 20/03/13
 * Time: 18:54
 */
public class UtilTest {

    @Test
    public void testRotation() {
        Point p = new Point(0, 2);
        int N = 5;
        assertEquals(Util.rotate(p, 1, N), new Point(2, 4));
        assertEquals(Util.rotate(p, 2, N), new Point(4, 2));
        assertEquals(Util.rotate(p, 3, N), new Point(2, 0));
    }
}
