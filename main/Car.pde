

class Car {
    PVector size = new PVector(120, 300);
    PVector pos = new PVector();
    PVector Vel = new PVector();

    public Car() {
        println("omgCar");
    }

    void draw() {
        rect(pos.x, pos.y, size.x, size.y);
    }

    void handleKey(int keyCode) {
        switch (keyCode) {
            case LEFT:
            case RIGHT:
            case UP:
            case DOWN:
                pos.x += 10;
        }
    }
};
