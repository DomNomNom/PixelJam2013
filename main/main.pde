import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.GL2;
GL2 gl;
PGraphicsOpenGL pgl;

PVector center; // center of the screen
PVector windowSize;

int prevMillis = 0;
int updatePeriod = 17;
int updateAccumulator = 0;

Car car;
Camera cam;
Road road;
ArrayList<Obstacle> obstacles;

PVector debugPoint = new PVector(-100, -100);

void setup() {
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);
    noSmooth();

    windowSize = new PVector(1280, 720);
    center = PVector.mult(windowSize, 0.5);
    size(
        (int) windowSize.x,
        (int) windowSize.y,
        OPENGL
    );
    pgl = (PGraphicsOpenGL) g;  // g may change
    gl = pgl.beginPGL().gl.getGL2();

    gl.glEnable(GL.GL_BLEND);
    gl.glBlendFunc (GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);

    car = new Car();
    cam = new Camera();
    road = new Road();
    obstacles = new ArrayList<Obstacle>();
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -1000)));
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -3000)));
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -5000)));

    prevMillis = millis();
}

void draw() {
    clear();
    int millis = millis();
    updateAccumulator += millis - prevMillis;
    prevMillis = millis;
    while (updateAccumulator > 0) {
        if(!car.dead){
            car.update();
            for (Obstacle o : obstacles) {
                o.update();
                if (o.isColliding()) {
                    car.collide();
                }
            }
            cam.update();
            road.update();
        }
        updateAccumulator -= updatePeriod;
    }

    pgl.beginPGL();
    pushMatrix();
        cam.doTranslate();
        road.draw();
        for (Obstacle o : obstacles) o.draw();
        car.draw();
        fill(color(255, 0, 0));
    popMatrix();
    pgl.endPGL();
}

void keyPressed()  { key(keyCode, true);  }
void keyReleased() { key(keyCode, false); }
private void key(int keyCode, boolean pressed){
    if (key == CODED) {
        switch (keyCode) {
            case LEFT:
            case RIGHT:
            case UP:
            case DOWN:
                Input.handleKey(keyCode, pressed);
                break;
        }
    }
};
