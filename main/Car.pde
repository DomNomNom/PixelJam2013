

class Car {
    PVector size = new PVector(100, 50);
    PVector pos = new PVector(20, 20);
    PVector vel = new PVector(0, 0);
    PVector facing = new PVector(1, 0);
    float speed = 0;

    public Car() {
        //println("omgCar");
    }

    void draw() {
        facing.normalize();
        
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(facing.heading());
        rect(0, 0, size.x, size.y);
        popMatrix();
        
        
        
        vel.set(facing.x, facing.y);
        vel.mult(speed);
        pos.add(vel);
    }

    void handleKey(int keyCode) {
        switch (keyCode) {
            case LEFT:
                facing.rotate(-0.1);
                break;
            case RIGHT:
                facing.rotate(0.1);
                break;
            case UP:
                speed += 1;
                println(speed);
                break;
            case DOWN:
        }
    }
};
