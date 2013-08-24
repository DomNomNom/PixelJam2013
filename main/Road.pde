import java.util.*;

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
        obstacles.add(new Beer(new PVector(center.x-50, -500)));
        obstacles.add(new Boost(new PVector(center.x-250, -1800)));
        obstacles.add(new Boost(new PVector(center.x+170, -3500)));

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

        // remove old tiles
        if (drawOffsets.get(0) - tiles.get(drawIndexes.get(0)).img.height > cam.bot) {
            drawOffsets.remove(0);
            drawIndexes.remove(0);
        }

        // generate obstacles
        ++obstacleTime;
        if (obstacleTime >= obstaclePeriod) {
            obstacleTime = 0;
            generateObstacle();
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
            else if (o.pos.y > bot) { // remove old obstacles
                obstacles.remove(i);
            }
        }


    }

    Integer nextTileIndex() {
        return 0;
    }

    void generateObstacle() {
        RoadTile topTile = tiles.get(tiles.size()-1);
        if (topTile.lanes_all.size() == 0) {
            println("trying to generate obstacle for tile with no lanes");
            return;
        }

        Float lane = topTile.lanes_all.get(int(random(topTile.lanes_all.size())));
        boolean fast = topTile.lanes_fast.contains(lane);

        PVector vel = new PVector(0, 7);
        if (fast) vel.y *= -1;

        PVector startPos = new PVector(lane, cam.top - 400);
        // if (fast) startPos.y += topTile.img.height;

        EnemyCar e = new EnemyCar(randomCar(), startPos, vel);
        obstacles.add(e);

        // return new Obstacle("assets/scaled/barrier.png", new PVector(center.x, top));
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
    ArrayList<Float> lanes_all  = new ArrayList<Float>();


    RoadTile(String fileName) {
        img = loadImage(fileName);

        lanes_slow.add(375.0);
        lanes_slow.add(475.0);
        lanes_slow.add(585.0);
        lanes_fast.add(685.0);
        lanes_fast.add(795.0);
        lanes_fast.add(895.0);

        for (Float lane : lanes_slow) lanes_all.add(lane);
        for (Float lane : lanes_fast) lanes_all.add(lane);
    }

    void draw(float y) {
        image(
            img,
            center.x, y,
            img.width, img.height
        );
    }
};

int weightedChoice(ArrayList<Float> weights) {
    float sum = 0;
    for (Float f : weights)
        sum += f;

    int choice;
    float r = random(sum);
    for (choice=0; choice<weights.size(); ++choice) {
        r -= weights.get(choice);
        if (r < 0)
            break;
    }

    return choice;
};

