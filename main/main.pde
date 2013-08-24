import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.GL2;
import ddf.minim.*;
GL2 gl;
PGraphicsOpenGL pgl;

Minim minim;
AudioPlayer bgm;

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

    minim = new Minim(this);
    //bgm = minim.loadFile("assets/sounds/background.mp3");
    //bgm.loop();
    car = new Car();
    cam = new Camera();
    road = new Road();
    gui = new GUI();

    prevMillis = millis();
}

void draw() {
    clear();
    int millis = millis();
    updateAccumulator += millis - prevMillis;
    prevMillis = millis;
    updateAccumulator = constrain(updateAccumulator, 0, 200);
    while (updateAccumulator > 0) {
        if(!car.dead){
            car.update();
            cam.update();
            road.update();

            if(drunk > 0){
                drunk -= 0.00025;
                if(drunk < 0) drunk = 0;
            }
        }
        updateAccumulator -= updatePeriod;
    }

    pgl.beginPGL();
    pushMatrix();
        translate(center.x, center.y);
        rotate(0.4*drunk*HALF_PI*sin(0.02*drunk*(millis()-drinkStart)));
        translate(-center.x, -center.y);
        cam.doTranslate();

        road.draw();
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
