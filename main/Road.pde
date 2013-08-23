

class Road {
    float baseLine;

    ArrayList<PImage> images;
    ArrayList<RoadTile> tiles;

    Road() {
        baseLine = center.y * 1.5;

        images = new ArrayList<PImage>();
        images.add(loadImage("assets/TestRoad.png"));
    }

    void draw() {
        pushMatrix();

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
            0, center.y,
            windowSize.x, windowSize.y
        );

    }
}