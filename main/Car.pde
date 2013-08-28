

class Car {
    PVector pos = new PVector(450, 0);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(0, -1);
    float speed = 0, maxSpeed = 18, boostSpeed = 30;
    float steer = 0;
    public PVector[] collisionPts;
    public boolean dead = false;
    public int boostTime;
    public boolean boosting;

    PImage sprite;
    PImage sprite_dead;
    Engine engine;
    AudioPlayer crash, tireScreech;
    boolean useEngine = minim.getLineOut().hasControl(Controller.GAIN);
    Animation rocket, rocketFire, explosion;

    int YOLO_end = 0;
    PImage yololo;

    private final float accel = 0.09;      // car acceleration rate    (0.1)
    private final float brake = 0.8;       // car braking rate         (0.8)
    private final float turnFactor = 0.04; // car steering rate        (0.04)
    private final float turnLimit = 0.03;  // car steering limit       (0.03)
    private final float drag = 0.12;       // air friction             (0.12)
    private final float turnFriction = 0.987; // steering slowdown

    private final float steerReset = 0.1;    // car steering limit     (0.1)
    private final float steeringLimit = HALF_PI*0.6;  // game steering limit, radians (HALF_PI*0.6)
    private final int roadLimit = 200;

    // things for tire marks
    TireMark[] tireMarks = new TireMark[50];
    int nextTireMarkIndex = 0;
    PVector prevTire_l = new PVector(0,0);
    PVector prevTire_r = new PVector(0,0);
    PVector nextTire_l = new PVector(0,0);
    PVector nextTire_r = new PVector(0,0);
    boolean marking = true;

    public final PVector hitbox; // from center to bottom right corner

    public void reset(){
        pos = new PVector(450, 0);
        vel = new PVector(0, 0);
        facing = new PVector(0, -1);
        YOLO_end = millis()-1;
        boosting = false;
    }

    public Car() {
        sprite      = loadImage("assets/scaled/car.png",        "png");
        sprite_dead = loadImage("assets/scaled/car_dead.png",   "png");
        yololo      = loadImage("assets/scaled/YOLOtext.png",   "png");
        crash = sound("crash");
        tireScreech = sound("tireScreech");
        for (int i=0; i<tireMarks.length; ++i)
            tireMarks[i] = new TireMark();

        if (useEngine)
            engine = new Engine();    // TODO: fix engine sounds
        PImage[] rkt = new PImage[2];
        rkt[0] = loadImage("assets/scaled/rocket1.png");
        rkt[1] = loadImage("assets/scaled/rocket2.png");
        rocket = new Animation(rkt, new PVector(0,0), 10);
        rkt = new PImage[2];
        rkt[0] = loadImage("assets/scaled/flame1.png");
        rkt[1] = loadImage("assets/scaled/flame2.png");
        rocketFire = new Animation(rkt, new PVector(0, 62), 10);
        rkt = new PImage[8];
        for(int i = 0; i < 8; i++) rkt[i] = loadImage("assets/scaled/"+i+".png");
        explosion = new Animation(rkt, new PVector(0,0), 4, false);
        explosion.index = -1;

        hitbox = new PVector(
            0.88 * sprite.width,
            0.88 * sprite.height
        );
        hitbox.mult(0.5); // half
    }

    void update() {
        // steering
        if(!car.dead) {
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

            // tire squeal
            marking = (abs(steer) > turnLimit-0.01);

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

            // acceleration
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
            if(Input.down){    // braking
                speed -= brake;
                if(speed < 0) speed = 0;                            // brake
                //if(speed < -maxSpeed*0.6) speed = -maxSpeed*0.6;    // reverse
            }

            facing.normalize();
            vel.set(facing.x, facing.y);
            vel.mult(speed);
            pos.add(vel);
            pos.x = constrain(pos.x, roadLimit, windowSize.x-roadLimit);
        }
        collisionPts = getCollisionPts();

        prevTire_r = nextTire_r;
        prevTire_l = nextTire_l;
        nextTire_r = new PVector(sprite.width*0.37, sprite.height*-0.4);
        nextTire_l = new PVector(sprite.width*-.37, sprite.height*-0.4);
        local2global(nextTire_r);
        local2global(nextTire_l);


        if (marking) {
            tireMarks[nextTireMarkIndex].from = prevTire_r;
            tireMarks[nextTireMarkIndex].to   = nextTire_r;
            nextTireMarkIndex = (nextTireMarkIndex+1) % tireMarks.length;

            tireMarks[nextTireMarkIndex].from = prevTire_l;
            tireMarks[nextTireMarkIndex].to   = nextTire_l;
            nextTireMarkIndex = (nextTireMarkIndex+1) % tireMarks.length;
            if(!tireScreech.isPlaying()){
                tireScreech.rewind();
                tireScreech.play();
            }
        } else {
            tireScreech.pause();
        }

        if (useEngine)
            engine.update();
        if(boosting){
            if(millis() - boostTime < Boost.time) rocketFire.update();
            rocket.update();
        }
        if(explosion.ready()) explosion.update();
    }

    public void YOLO() {
        YOLO_end = millis() + 2000;
    }

    void draw() {

        pushMatrix();
        for (TireMark t : tireMarks)
            t.draw();

        translate(pos.x, pos.y);
        rotate(facing.heading() + HALF_PI);


        if (dead) {
            image(sprite_dead, 0, 0);
            if (explosion.ready())  explosion.draw();
        }
        else {
            image(sprite, 0, 0);
            if(boosting){
                rocket.draw();
                if(millis() - boostTime < Boost.time) rocketFire.draw();
            }
        }


        if (YOLO_end > millis()) {
            image(yololo, 0, 0);
        }

        popMatrix();

        //fill(220, 50, 0); stroke(220, 50, 0);
        //for(PVector p : getCollisionPts()) rect(p.x, p.y, 4, 4); // collision bounds
    }

    public void collide(){
        if(!dead){
            // explode!
            dead = true;
            explosion.rewind();
            speed = 0;
            steer = 0;
            if(score > hiscore) hiscore = score;
            if(!crash.isPlaying()){
                crash.rewind();
                crash.play();
            }
        }
    }

    /*
    / returns the points of collision of this object-
    / in this case, the corners of the car (clockwise)
    */
    public PVector[] getCollisionPts(){
        // float wid = sprite.width*0.88;
        // float hgt = sprite.height*0.88;
        PVector[] pts = new PVector[4];
        pts[0] = new PVector( hitbox.x, hitbox.y);
        pts[1] = new PVector( hitbox.x,-hitbox.y);
        pts[2] = new PVector(-hitbox.x,-hitbox.y);
        pts[3] = new PVector(-hitbox.x, hitbox.y);
        for(int i = 0; i <4; i++){
            local2global(pts[i]);
            // pts[i].rotate(facing.heading() + HALF_PI);
            // pts[i].add(pos);
        }
        return pts;
    }

    private void local2global(PVector p) {
        p.rotate(facing.heading() + HALF_PI);
        p.add(pos);
    }
};


PImage tireTracks = null;
class TireMark {
    PVector from = new PVector(-1000, 0);
    PVector to   = new PVector(-1000, 0);


    TireMark() {
        if(tireTracks == null) tireTracks = loadImage("assets/scaled/tires.png", "png");
    }

    void draw() {
        // if(tireTracks == null) return;
        // strokeWidth(5);
        stroke(color(0));

        // line(
        //     from.x, from.y,
        //     to.x,   to.y
        // );
        pushMatrix();
        translate(to.x, to.y);
        PVector diff = PVector.sub(from, to);
        rotate(diff.heading() + HALF_PI);

        // for (int l=0; l<=diff.mag(); l+=tireTracks.height)
        image(tireTracks, 0,0, tireTracks.width, diff.mag());
        popMatrix();
    }
};
