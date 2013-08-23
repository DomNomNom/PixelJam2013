

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(20, 20);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(1, 0);
    float speed = 0, maxSpeed = 30;
    float steer = 0;
    
    private final float accel = 0.25;       // car acceleration rate
    private final float turnFactor = 0.002; // car steering rate
    private final float maxSteer = 0.08;   // car steering limit
    private final float drag = 0.97;       // air friction
    private final float turnFriction = 0.99;   // car steering limit

    public Car() {
        //println("omgCar");
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
        speed *= drag;
        facing.normalize();
        vel.set(facing.x, facing.y);
        vel.mult(speed);
        pos.add(vel);
    }

    void draw() {
        
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(facing.heading());
        rect(0, 0, size.x, size.y);
        popMatrix();
        
    }
};
