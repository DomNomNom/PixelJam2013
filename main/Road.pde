

class Road {
    float baseLine;

    ArrayList<RoadTile> tiles = new ArrayList<RoadTile>();
    ArrayList<Integer> drawIndexes = new ArrayList<Integer>(); // indecies of tiles
    ArrayList<Float>   drawOffsets = new ArrayList<Float>();

    float top;
    float bot;

    Road() {
        tiles.add(new RoadTile("assets/TestRoad.png"));
        drawIndexes.add(0);
        drawOffsets.add(0.0);

        top = 0;
        bot = tiles.get(0).img.height;
    }

    void update() {
        // make sure all things are tiled
        while (top > cam.top - windowSize.y) {
            Integer next = nextTileIndex();
            RoadTile nextTile = tiles.get(next);
            drawIndexes.add(next);
            drawOffsets.add(top - nextTile.img.height);
            top -= nextTile.img.height;
            // println("new top: " + drawOffsets);
        }

    }

    Integer nextTileIndex() {
        return 0;
    }

    Obstacle generateObstacle() {
        return new Obstacle("assets/scaled/barrier.png", new PVector(top, center.x));
    }

    void draw() {
        pushMatrix();
        for (int i=0; i<drawIndexes.size(); ++i) {
            tiles.get(drawIndexes.get(i)).draw(drawOffsets.get(i));
        }
        popMatrix();
    }
};


class RoadTile {
    PImage img;

    RoadTile(String fileName) {
        img = loadImage(fileName);
    }

    void draw(float y) {
        image(
            img,
            center.x, y,
            img.width, img.height
        );

    }
}