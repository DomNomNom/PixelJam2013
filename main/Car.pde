

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(600, 0);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(0, -1);
    float speed = 0, maxSpeed = 100;
    float steer = 0;
    
    PImage sprite;
    
    private final float accel = 0.18;       // car acceleration rate
    private final float turnFactor = 0.004; // car steering rate
    private final float turnLimit = 0.075;  // car steering limit
    private final float drag = 0.02;        // air friction
    private final float turnFriction = 0.99;   // car steering limit
    
    private final float steerReset = 0.9;   // car steering limit
    private final float steeringLimit = HALF_PI/2;  // game steering limit (radians)
    
    public Car() {
        sprite = loadImage("assets/car.png", "png");
    }

    void update() {
        if(Input.left){
            steer -= turnFactor;
            if(steer < -turnLimit) steer = -turnLimit;
            speed *= turnFriction;
            facing.rotate(steer);
        } else if(Input.right){
            steer += turnFactor;
            if(steer > turnLimit) steer = turnLimit;
            speed *= turnFriction;
            facing.rotate(steer);
        } else { // steering auto-reset
            steer = -(facing.heading()  + HALF_PI)*0.01;
            steer = clamp(steer, -turnLimit, turnLimit)
            facing.rotate(steer);
            /*
            if(facing.heading() < -HALF_PI){ // car is facing to the left
                if(steer < 0){
                    steer += turnFactor;
                    if(steer > turnLimit) steer = turnLimit;
                } else if(steer < turnLimit/2) {
                    steer -= turnFactor/2;
                    if(steer < 0) steer = 0;
                }
                facing.rotate(steer);
                if(facing.heading() > -HALF_PI){
                    steer = 0;
                    facing.set(0, -1);
                }
            } else {        // car is facing to the right
                if(steer > 0){
                    steer -= turnFactor;
                    if(steer < -turnLimit) steer = -turnLimit;
                } else if(steer > -turnLimit/2) {
                    steer += turnFactor/2;
                    if(steer > 0) steer = 0;
                }
                facing.rotate(steer);
                if(facing.heading() < -HALF_PI){
                    steer = 0;
                    facing.set(0, -1);
                }
            }
            */
            
            /* Steering wheel reset- replaced with directional reset
            if(steer < 0){
                steer += turnFactor*2.5;
                if(steer > 0) steer = 0;
            } else {
                steer -= turnFactor*2.5;
                if(steer < 0) steer = 0;
            } */
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
