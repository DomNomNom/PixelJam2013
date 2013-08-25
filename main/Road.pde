import java.util.*;
import java.io.FileNotFoundException;
import java.lang.RuntimeException;

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
        tiles.add(new RoadTile("assets/scaled/Road.png", "Road"));
        tiles.add(new RoadTile("assets/scaled/Town.png", "Town"));
        tiles.add(new RoadTile("assets/scaled/TrainTracks.png", "TrainTracks"));
        tiles.add(new RoadTile("assets/scaled/Bridge.png", "Bridge"));
        drawIndexes.add(0);
        drawOffsets.add(0.0);

        top = tiles.get(0).img.height * -.5;
        bot = tiles.get(0).img.height * 0.5;
    }

    void update() {

        // generate new tiles
        while (top > cam.top - 1000) {
            Integer next = nextTileIndex();
            RoadTile nextTile = tiles.get(next);
            drawIndexes.add(next);
            drawOffsets.add(top - nextTile.img.height/2);
            top -= nextTile.img.height;

            // generate tile's obstacles
            int[] trains = null;
            if(nextTile.name.equals("TrainTracks")){
                trains = getTrainConfig();
            }
            for (int i = 0; i < nextTile.obstacles.size(); i++){
                if(trains != null && !arrayContains(trains, i)) continue;
                
                RoadTileObstacle o = nextTile.obstacles.get(i);
                
                PVector vel = new PVector(0, 0);
                if (o.fileName.equals("train.png")) {    // Traaaaains...
                    if (o.pos.x < center.x) vel = new PVector(4, 0);
                    else vel = new PVector(-4, 0);
                }
                PVector pos = o.pos.get();
                pos.y += top;
                if(o.fileName.equals("bridgesides.png")){
                    println("bridge sides added");
                    Obstacle ob = new Obstacle(bridgeSides, o.fileName, pos);
                    obstacles.add(ob);
                } else {
                    EnemyCar e = new EnemyCar("assets/scaled/"+o.fileName, pos, vel);
                    obstacles.add(e);
                }
            }
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
                if (o instanceof Powerup) {
                    ((Powerup)o).applyEffect();
                    obstacles.remove(i);
                } 
                else {
                    car.collide();
                }
            }
            else if (o.pos.y > bot) { // remove old obstacles
                obstacles.remove(i);
            }
        }
    }

    Integer nextTileIndex() {
        RoadTile last = lastTile();
        float rand = random(last.probSum);
        for (RoadTransition t : last.transitions) {
            rand -= t.prob;
            if (rand <= 0) {
                for (int i = 0; i < tiles.size(); i++) {
                    if (tiles.get(i).name.equals(t.name)) return i;
                }
            }
        }

        println("WARNING: Failed to generate a new tile? Returning default.");
        return 0;
    }

    RoadTile lastTile() {
        return(tiles.get(drawIndexes.get(drawIndexes.size()-1)));
    }

    void generateObstacle() {
        RoadTile topTile = lastTile();
        if (topTile.lanes_all.size() == 0) {
            //println("trying to generate obstacle for tile with no lanes");
            return;
        }

        Float lane = topTile.lanes_all.get(int(random(topTile.lanes_all.size())));
        boolean fast = topTile.lanes_fast.contains(lane);

        PVector vel = new PVector(0, -7);
        if (fast) vel.y *= -1;

        PVector startPos = new PVector(lane, cam.top - (fast? 1200 : 600));
        // if (fast) startPos.y += topTile.img.height;

        EnemyCar e = new EnemyCar(randomCar(), startPos, vel);
        obstacles.add(e);

        if (random(3) < 1) {
            lane = topTile.lanes_all.get(int(random(topTile.lanes_all.size())));
            obstacles.add(randomPowerup(new PVector(lane, cam.top - 400)));
        }

        // return new Obstacle("assets/scaled/barrier.png", new PVector(center.x, top));
    }

    void draw() {
        pushMatrix();
        for (int i=0; i<drawIndexes.size(); ++i) {
            tiles.get(drawIndexes.get(i)).draw(drawOffsets.get(i));
        }

        for (Obstacle o : obstacles){
            if(!o.fileName.equals("bridgesides.png")){
                o.draw();
            }
        }

        popMatrix();
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

boolean arrayContains(int[] ar, int n){
    for(int a : ar){
        if(n == a){
            return true;
        } 
    }
    return false;    
}
