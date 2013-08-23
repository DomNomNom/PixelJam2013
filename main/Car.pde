

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(600, 0);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(0, -1);
    float speed = 0, maxSpeed = 40;
    float steer = 0;

    PImage sprite;

    private final float accel = 0.4;       // car acceleration rate
    private final float brake = 0.8;       // car braking rate
    private final float turnFactor = 0.03; // car steering rate
    private final float turnLimit = 0.04;  // car steering limit
    private final float drag = 0.12;        // air friction
    private final float turnFriction = 0.9999;   // car steering limit

    private final float steerReset = 0.1;   // car steering limit
    private final float steeringLimit = HALF_PI/2;  // game steering limit (radians)

    public Car() {
        sprite = loadImage("assets/scaled/car.png", "png");
    }

    void update() {
        float tmpTurnLimit = lerp(0, turnLimit, constrain(speed/(maxSpeed*0.5), 0, 1));
        if(Input.left){
            if(steer > 0) steer = 0;
            steer -= lerp(0, turnFactor, 1 - speed/(maxSpeed*1.3));
            steer = constrain(steer, -tmpTurnLimit, tmpTurnLimit);
            speed *= turnFriction;
            facing.rotate(steer);
        } else if(Input.right){
            if(steer < 0) steer = 0;
            steer += lerp(0, turnFactor, 1 - speed/(maxSpeed*1.3));
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
            if(speed > maxSpeed) speed = maxSpeed;
        } else {
            speed -= drag;
            if(speed < 0) speed = 0;
        }
        if(Input.down){
            speed -= brake;
            if(speed < 0) speed = 0;
        }
        facing.normalize();
        vel.set(facing.x, facing.y);
        vel.mult(speed);
        pos.add(vel);
        pos.x = constrain(pos.x, -50, windowSize.x+50);
    }

    void draw() {

        pushMatrix();
        translate(pos.x, pos.y);
        rotate(facing.heading() + HALF_PI);
        // scale(4, 4);


        image(sprite, 0, 0);


        //rect(0, 0, size.x, size.y);
        popMatrix();

    }
};
