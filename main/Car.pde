

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(20, 20);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(1, 0);
    float speed = 0;

    public Car() {
        //println("omgCar");
    }

    void update() {
        if(Input.left){
            facing.rotate(-0.1);
        }
        if(Input.right){
            facing.rotate(0.1);
        }
        if(Input.up){
            speed += 0.5;
        }
        if(Input.down){
            speed -= 0.5;
        }
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
