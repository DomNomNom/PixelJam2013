

class Road {
    float baseLine;

    ArrayList<RoadTile> tiles = new ArrayList<RoadTile>();
    ArrayList<Integer> drawIndexes = new ArrayList<Integer>(); // indecies of tiles
    ArrayList<Float>   drawOffsets = new ArrayList<Float>();

    ArrayList<Obstacle> obstacles;
    int obstaclePeriod = 100; // every X ticks, spawn a obstacle
    int obstacleTime = obstaclePeriod;

    float top;
    float bot;



    Road() {
        obstacles = new ArrayList<Obstacle>();
        // obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -1000)));
        // obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -3000)));
        // obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -5000)));

        // tiles.add(new RoadTile("assets/TestRoad.png"));
        tiles.add(new RoadTile("assets/scaled/Road.png"));
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
        }

        // generate obstacles
        ++obstacleTime;
        if (obstacleTime >= obstaclePeriod) {
            obstacleTime = 0;
            obstacles.add(generateObstacle());
        }

        // obstacle collision
        for (int i=obstacles.size()-1; i>=0; --i) {
            Obstacle o = obstacles.get(i);
            o.update();

            if (o.isColliding()) {
                if(o instanceof Powerup){
                    ((Powerup)o).applyEffect();
                    obstacles.remove(i);
                } else {
                    car.collide();
                }
            }
            else if (o.pos.y > bot) { // remove if too far down
                obstacles.remove(i);
            }
        }


    }

    Integer nextTileIndex() {
        return 0;
    }

    Obstacle generateObstacle() {
        return new Obstacle("assets/scaled/barrier.png", new PVector(center.x, top));
    }

    void draw() {
        pushMatrix();
        for (int i=0; i<drawIndexes.size(); ++i) {
            tiles.get(drawIndexes.get(i)).draw(drawOffsets.get(i));
        }

        for (Obstacle o : obstacles)
            o.draw();

        popMatrix();
    }
};


class RoadTile {
    PImage img;

    ArrayList<Float> lanes_slow = new ArrayList<Float>();
    ArrayList<Float> lanes_fast = new ArrayList<Float>();

    RoadTile(String fileName) {
        img = loadImage(fileName);

        lanes_slow.add(475.0);
        lanes_slow.add(540.0);
        lanes_slow.add(605.0);
        lanes_fast.add(670.0);
        lanes_fast.add(735.0);
        lanes_fast.add(800.0);
    }

    void draw(float y) {
        image(
            img,
            center.x, y,
            img.width, img.height
        );
    }
}