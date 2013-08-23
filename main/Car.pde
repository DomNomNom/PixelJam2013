

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(600, 0);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(0, -1);
    float speed = 0, maxSpeed = 100;
    float steer = 0;

    PImage sprite;

    private final float accel = 0.15;       // car acceleration rate
    private final float turnFactor = 0.003; // car steering rate
    private final float maxSteer = 0.075;   // car steering limit
    private final float drag = 0.02;       // air friction
    private final float turnFriction = 0.99;   // car steering limit

    public Car() {
        sprite = loadImage("assets/car.png");
    }

    void update() {
        if(Input.left){
            steer -= turnFactor;
            if(steer < -maxSteer) steer = -maxSteer;
            speed *= turnFriction;
        } else if(Input.right){
            steer += turnFactor;
            if(steer > maxSteer) steer = maxSteer;
            speed *= turnFriction;
        } else { // steering auto-reset
            if(steer < 0){
                steer += turnFactor*2.5;
                if(steer > 0) steer = 0;
            } else {
                steer -= turnFactor*2.5;
                if(steer < 0) steer = 0;
            }
        }
        facing.rotate(steer);
        if(Input.up){
            speed += accel;
            if(speed > maxSpeed) speed = maxSpeed;
        }
        if(Input.down){
            speed -= accel;
            if(speed < -maxSpeed*0.6) speed = -maxSpeed*0.6;
        }
        if(speed < 0){
            speed += drag;
            if(speed > 0) speed = 0;
        } else {
            speed -= drag;
            if(speed < 0) speed = 0;
        }
        facing.normalize();
        vel.set(facing.x, facing.y);
        vel.mult(speed);
        pos.add(vel);
    }

    void draw() {

        pushMatrix();
        translate(pos.x, pos.y);
        rotate(facing.heading() + HALF_PI);
        scale(4, 4);
        noSmooth();
        image(sprite, 0, 0);
        //rect(0, 0, size.x, size.y);
        popMatrix();

    }
};
