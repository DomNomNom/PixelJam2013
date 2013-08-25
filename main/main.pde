import processing.video.*;
import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.GL2;
import ddf.minim.*;
GL2 gl;
PGraphicsOpenGL pgl;

Minim minim;
AudioPlayer bgm;

AudioPlayer beerSound, boostSound;

PVector center; // center of the screen
PVector windowSize;

int prevMillis = 0;
int updatePeriod = 17;
int updateAccumulator = 0;

Car car;
Camera cam;
Road road;
ScoreNotify scoreNotify;

GUI gui;
ArrayList<Obstacle> obstacles;
static PImage trainSign;

SelfyOverlay selfyOverlay;

PVector debugPoint = new PVector(-100, -100);
float drunk = 0;
int drinkStart;
int score = 0;
main globalSelfReference = this;

void setup() {

    // processing draw opions
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);
    noSmooth();
    // window
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

    // game entities
    minim = new Minim(this);
    //bgm = minim.loadFile("assets/sounds/background.mp3");
    beerSound = minim.loadFile("assets/sounds/beer.mp3");
    boostSound = minim.loadFile("assets/sounds/boost.mp3");
    trainSign = loadImage("assets/trainWarning.png");
    car = new Car();
    cam = new Camera();
    road = new Road();
    gui = new GUI();
    scoreNotify = new ScoreNotify();
    selfyOverlay = new SelfyOverlay();


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

            scoreNotify.update();
            selfyOverlay.update();
            //gui.update();

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
        rotate(0.4*drunk*HALF_PI*sin(0.01*drunk*(millis()-drinkStart)));
        translate(-center.x, -center.y);
        cam.doTranslate();

        road.draw();
        car.draw();
        scoreNotify.draw();
        // fill(color(255, 0, 0));
    popMatrix();
    pgl.endPGL();

    selfyOverlay.draw();
    gui.draw();
}

void keyPressed()  { key(keyCode, true);  }
void keyReleased() { key(keyCode, false); }
private void key(int keyCode, boolean pressed){
    if(key == 'd' && pressed){
        if(drunk == 0) drinkStart = millis();
        drunk += 0.05;
    }
    else if (key == 's' && pressed) {
        selfyOverlay.selfy();
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

void stop(){
    bgm.close();
    car.crash.close();
    car.tireScreech.close();
    beerSound.close();
    boostSound.close();
    for(AudioPlayer a : car.engine.engSound){
        a.pause();
        a.close();
    }
    minim.stop();
    super.stop();
}

int[] getTrainConfig(){
    switch((int)random(8)){
        default:
        case 0: return new int[]{10, 7, 2};
        case 1: return new int[]{9, 8, 5, 1};
        case 2: return new int[]{9, 6, 3};
        case 3: return new int[]{10, 8, 2};
        case 4: return new int[]{7, 4, 0};
        case 5: return new int[]{8, 6, 3, 1};
        case 6: return new int[]{9, 4, 3, 1};
        case 7: return new int[]{8, 4, 2};
    }
}
