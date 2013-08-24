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
GUI gui;
ArrayList<Obstacle> obstacles;

PVector debugPoint = new PVector(-100, -100);
float drunk = 0;
int drinkStart;
int score = 0;

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
    gui = new GUI();
    obstacles = new ArrayList<Obstacle>();
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -1000)));
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -3000)));
    obstacles.add(new Obstacle("assets/scaled/barrier.png", new PVector(center.x, -5000)));
    obstacles.add(new Beer(new PVector(center.x-50, -500)));
    obstacles.add(new Boost(new PVector(center.x-250, -1800)));
    obstacles.add(new Boost(new PVector(center.x+170, -3500)));

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
                    if(o instanceof Powerup){
                        ((Powerup)o).applyEffect();
                    } else car.collide();
                }
            }
            cam.update();
            road.update();
        }
        updateAccumulator -= updatePeriod;
    }

    pgl.beginPGL();
    pushMatrix();
        translate(center.x, center.y);
        rotate(0.5*drunk*HALF_PI*sin(0.01*drunk*(millis()-drinkStart)));
        translate(-center.x, -center.y);
        cam.doTranslate();

        road.draw();
        for (Obstacle o : obstacles) o.draw();
        car.draw();
        fill(color(255, 0, 0));
    popMatrix();
    pgl.endPGL();
    gui.draw();
}

void keyPressed()  { key(keyCode, true);  }
void keyReleased() { key(keyCode, false); }
private void key(int keyCode, boolean pressed){
    if(key == 'd' && pressed){
        if(drunk == 0) drinkStart = millis();
        drunk += 0.05;
    }
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
