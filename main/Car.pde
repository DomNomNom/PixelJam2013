

class Car {
    PVector pos = new PVector(450, 0);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(0, -1);
    float speed = 0, maxSpeed = 20, boostSpeed = 33.34;
    float steer = 0;
    public PVector[] collisionPts;
    public boolean dead = false;
    public int boostTime;
    public boolean boosting;

    PImage sprite;
    Engine engine;
    AudioPlayer crash;
    boolean useEngine = minim.getLineOut().hasControl(Controller.GAIN);

    private final float accel = 0.1;       // car acceleration rate
    private final float brake = 0.8;       // car braking rate
    private final float turnFactor = 0.028; // car steering rate
    private final float turnLimit = 0.02;  // car steering limit
    private final float drag = 0.12;       // air friction
    private final float turnFriction = 0.9999;   // car steering limit

    private final float steerReset = 0.075;   // car steering limit
    private final float steeringLimit = HALF_PI*0.3;  // game steering limit (radians)
    private final int roadLimit = 200;

    // things for tire marks
    TireMark[] tireMarks = new TireMark[50];
    int nextTireMarkIndex = 0;
    PVector prevTire_l = new PVector(0,0);
    PVector prevTire_r = new PVector(0,0);
    PVector nextTire_l = new PVector(0,0);
    PVector nextTire_r = new PVector(0,0);
    boolean marking = true;

    public Car() {
        sprite = loadImage("assets/scaled/car.png", "png");
        engine = new Engine();
        crash = minim.loadFile("assets/sounds/Car Crash.mp3");
        for (int i=0; i<tireMarks.length; ++i)
            tireMarks[i] = new TireMark();

        if (useEngine)
            engine = new Engine();    // TODO: fix engine sounds
    }

    void update() {
        float tmpTurnLimit = lerp(0, turnLimit, constrain(speed/(maxSpeed*0.5), 0, 1));
        if(Input.left){
            if(steer > 0) steer = 0;
            if(boosting) steer -= lerp(0, turnFactor, 1 - speed/(boostSpeed*1.3));
            else steer -= lerp(0, turnFactor, 1 - speed/(maxSpeed*1.3));
            steer = constrain(steer, -tmpTurnLimit, tmpTurnLimit);
            speed *= turnFriction;
            facing.rotate(steer);
        } else if(Input.right){
            if(steer < 0) steer = 0;
            if(boosting) steer += lerp(0, turnFactor, 1 - speed/(boostSpeed*1.3));
            else steer += lerp(0, turnFactor, 1 - speed/(maxSpeed*1.3));
            steer = constrain(steer, -tmpTurnLimit, tmpTurnLimit);
            speed *= turnFriction;
            facing.rotate(steer);
        } else { // steering auto-reset
            steer = -(facing.heading()  + HALF_PI)*steerReset;
            steer = constrain(steer, -tmpTurnLimit, tmpTurnLimit);
            facing.rotate(steer);
        }

        // steering limiter
        if(facing.heading() < -HALF_PI){
            if(facing.heading() < -HALF_PI - steeringLimit){
                facing.set(0, -1);
                facing.rotate(-steeringLimit);
                steer = 0;
            }
        } else {
            if(facing.heading() > -HALF_PI+steeringLimit){
                facing.set(0, -1);
                facing.rotate(steeringLimit);
                steer = 0;
            }
        }

        if(Input.up){
            speed += accel;
            speed += accel;
            if(speed > maxSpeed) speed = maxSpeed;
            if(boosting) {
                float time = millis() - boostTime;
                if(time < Boost.time){
                    speed = boostSpeed;
                } else if(time < Boost.time*2){
                    speed = lerp(maxSpeed, boostSpeed, (Boost.time - (time-Boost.time))/Boost.time);
                } else boosting = false;
            }
        } else {
            speed -= drag;
            if(speed < 0) speed = 0;
        }
        if(Input.down){
            speed -= brake*5;
            if(speed < -maxSpeed*0.6) speed = -maxSpeed*0.6;
        }
        facing.normalize();
        vel.set(facing.x, facing.y);
        vel.mult(speed);
        pos.add(vel);
        pos.x = constrain(pos.x, roadLimit, windowSize.x-roadLimit);

        collisionPts = getCollisionPts();

        prevTire_r = nextTire_r;
        prevTire_l = nextTire_l;
        nextTire_r = collisionPts[1];
        nextTire_l = collisionPts[2];

        if (marking) {
            tireMarks[nextTireMarkIndex].from = prevTire_r;
            tireMarks[nextTireMarkIndex].to   = nextTire_r;
            nextTireMarkIndex = (nextTireMarkIndex+1) % tireMarks.length;

            tireMarks[nextTireMarkIndex].from = prevTire_l;
            tireMarks[nextTireMarkIndex].to   = nextTire_l;
            nextTireMarkIndex = (nextTireMarkIndex+1) % tireMarks.length;
        }

        if (useEngine)
            engine.update();
    }

    void draw() {

        pushMatrix();
        for (TireMark t : tireMarks)
            t.draw();

        translate(pos.x, pos.y);
        rotate(facing.heading() + HALF_PI);

        image(sprite, 0, 0);
        popMatrix();

        //fill(220, 50, 0); stroke(220, 50, 0);
        //for(PVector p : getCollisionPts()) rect(p.x, p.y, 4, 4); // collision bounds
    }

    public void collide(){
        // explode!
        //dead = true;
        speed = 0;
        steer = 0;
        println("u ded boi");
        if(!crash.isPlaying()){
            crash.rewind();
            crash.play();
        }
    }

    /**
    /* returns the points of collision of this object-
    /* in this case, the corners of the car (clockwise)
    /**/
    public PVector[] getCollisionPts(){
        float wid = sprite.width*0.9;
        float hgt = sprite.height*0.9;
        PVector[] pts = new PVector[4];
        pts[0] = new PVector( wid/2, hgt/2);
        pts[1] = new PVector( wid/2,-hgt/2);
        pts[2] = new PVector(-wid/2,-hgt/2);
        pts[3] = new PVector(-wid/2, hgt/2);
        for(int i = 0; i < 4; i++){
            pts[i].rotate(facing.heading() + HALF_PI);
            pts[i].add(pos);
        }
        return pts;
    }
};


class TireMark {
    PVector from = new PVector(-1000, 0);
    PVector to   = new PVector(-1000, 0);

    void draw() {
        // strokeWidth(5);
        stroke(color(0));
        line(
            from.x, from.y,
            to.x,   to.y
        );
    }
};
