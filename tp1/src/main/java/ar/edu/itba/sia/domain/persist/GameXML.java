package ar.edu.itba.sia.domain.persist;

import java.awt.Point;
import java.io.File;
import java.util.Map;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementMap;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;

import ar.edu.itba.sia.domain.Piece;
import ar.edu.itba.sia.domain.PieceImpl;

@Root
public class GameXML {
	@Root
	public static class GameNode {
		@Element
		public int up = -1;
		@Element
		public int down = -1;
		@Element
		public int left = -1;
		@Element
		public int right = -1;

		public GameNode(final int up, final int right, final int down,
				final int left) {
			super();
			this.up = up;
			this.down = down;
			this.left = left;
			this.right = right;
		}
		
		public GameNode() {
			// TODO Auto-generated constructor stub
		}

        public Piece toPiece() {
            return PieceImpl.create(up, right, down, left);
        }

	}

	public static GameXML fromDomain(final Object domainObject) {
		return null;
	}

	public static GameXML fromXml(final String filePath) throws Exception {
		Serializer serializer = new Persister();
		File source = new File(filePath);

		return serializer.read(GameXML.class, source);
	}

	@Element
	public int numberOfColors;

	@Element
	public int gameSize;

	@ElementMap
	public Map<Point, GameNode> nodes;

	public Object toDomain() {
		return null;
	}

	public void toFile(final String filePath) throws Exception {
		Serializer serializer = new Persister();
		File result = new File(filePath);

		serializer.write(this, result);
	}
}
