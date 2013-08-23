

class Road {
    float baseLine;

    ArrayList<PImage> images;
    ArrayList<RoadTile> tiles;

    Road() {
        tiles = new ArrayList<RoadTile>();
        tiles.add(new RoadTile("assets/TestRoad.png"));
    }

    void draw() {
        pushMatrix();
        tiles.get(0).draw();
        popMatrix();
    }
};


class RoadTile {
    PImage img;

    RoadTile(String fileName) {
        img = loadImage(fileName);
    }

    void draw() {
        image(
            img,
            center.x, 0,
            windowSize.x, windowSize.y
        );

    }
}