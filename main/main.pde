import processing.video.*;
import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.GL2;
import ddf.minim.*;

GL2 gl;
PGraphicsOpenGL pgl;

Minim minim;
AudioPlayer bgm;

AudioPlayer beerSound, boostSound, trainSound;

PVector center; // center of the screen
PVector windowSize;

int debugX = 0, debugY = 0;

int prevMillis = 0;
int updatePeriod = 17;
int updateAccumulator = 0;


Car car;
Camera cam;
// Road road;
// ScoreNotify scoreNotify;

// GUI gui;
// ArrayList<Obstacle> obstacles;

// SelfyOverlay selfyOverlay;
// PImage bridgeSides;
// PImage bridgeSign;
// Animation trainSign;
// boolean trainSignals;
PImage hashtag;

// PVector debugPoint = new PVector(-100, -100);
float drunk = 0;
int drinkStart;
int score = 0, hiscore = 0;

main globalSelfReference = this;

int gameState = 0; // hello, zooom in, play, dead
PImage gameState0;
PImage gameState1;
PImage gameState3;
int gameState1_end=0;
int restart = 0;

int  nameClash = 0;
void nameClash() { }
boolean javascript;

void setup() {
    // a hacky way of telling whether we are in javascript or not
    // compatible with processing.
    try {
        nameClash();
        javascript = false;
    } catch (Exception e) {
        javascript = true;
    }

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
    if (!javascript) {
        pgl = (PGraphicsOpenGL) g;  // g may change
        gl = pgl.beginPGL().gl.getGL2();
        gl.glEnable(GL.GL_BLEND);
        gl.glBlendFunc (GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);
    }

    gameState0 = loadImage("assets/scaled/title.png");
    gameState1 = loadImage("assets/scaled/title2.png");
    gameState3 = loadImage("assets/scaled/ending.png");
    image(gameState0, center.x, center.y);

    // game entities
    minim = new Minim(this);
    bgm = sound("background");
    bgm.loop();
    beerSound = sound("beer");
    boostSound = sound("boost");
    trainSound = sound("railwaycrossing"); // was .wav
    // bridgeSides = loadImage("assets/scaled/bridgesides.png");
    // PImage[] ts = new PImage[2];
    // ts[0] = loadImage("assets/scaled/railwaysign.png");
    // ts[1] = loadImage("assets/scaled/railwaysign2.png");
    // trainSign = new Animation(ts, new PVector(center.x, 50), 25);
    // bridgeSign = loadImage("assets/bridgewarning.png");

    hashtag = loadImage("assets/scaled/hashtag.png");

    car = new Car();
    cam = new Camera();
    // road = new Road();
    // gui = new GUI();
    // scoreNotify = new ScoreNotify();
    // selfyOverlay = new SelfyOverlay();

    gameState = 0;

    prevMillis = millis();


    // String names[] = {"Alexis", "Thomas", "Antoine"};
    // // for (String name : names) {
    // for (int i=0; i<names.length; ++i)
    //     alert(names[i]);
    // }

    // ArrayList<String> names = new ArrayList<String>();
    // names.add("Alexis");
    // for (String name : names) {
    // // for (int i=0; i<names.length; ++i)
    //     alert(name);
    // }

}

void draw() {
    if (!javascript) {
        pgl.beginPGL();
        clear();
    }

    image(gameState0, center.x, center.y);
    if (gameState == 0) {
        image(gameState0, center.x, center.y);
        return;
    }
    int mills = millis();
    updateAccumulator += mills - prevMillis;
    prevMillis = mills;
    updateAccumulator = constrain(updateAccumulator, 0, 200);
    while (updateAccumulator > 0) {
        if (millis()  > restart + 2000) {
            if (gameState == 2 && car.dead && !car.explosion.ready()) {
                gameState = 3;
            }
        }
        else { // invunerability frames for the car
            score = 0;
            car.dead = false;
        }

        if (gameState == 2){
            car.update();
            cam.update();
            // road.update();

            // scoreNotify.update();
            // selfyOverlay.update();
            // gui.update();

            if(drunk > 0){
                drunk -= 0.00025;
                if(drunk < 0) drunk = 0;
            }
        }
        else {
            cam.update();
        }
        updateAccumulator -= updatePeriod;
    }

    pushMatrix();
        // drunkness
        translate(center.x, center.y);
        rotate(0.4*drunk*HALF_PI*sin(0.01*drunk*(millis()-drinkStart)));
        translate(-center.x, -center.y);

        cam.doTranslate();

        // road.draw();
        car.draw();
        // scoreNotify.draw();

        // gamestate overlays
        // fill(color(255, 0, 0));
        // else if (gameState == 3) {
        //     image(gameState3, center.x, center.y);
        // }
    popMatrix();

    // selfyOverlay.draw();
    // gui.draw();

    if (gameState == 1) {
        image(gameState1, center.x, center.y);
    }
    else if (gameState == 3) {
        image(gameState3, center.x, center.y);
        fill(0);
        text("Score: " + score, center.x-240, windowSize.y - 120);
        text("Hi-Score: " + hiscore, center.x-240, windowSize.y - 60);
    }


    if (!javascript) pgl.endPGL();
}

void doRestart(){
    //println("qq: " + gameState);
    if (gameState == 0) {
        gameState = 1;
    } else if (gameState == 1 || gameState == 3) {
        restart = millis();
        gameState = 2;
        gameState1_end = millis() + 1000;
        car.reset();
        drunk = 0;
        score = 0;

        // road.reset();
        // gui.reset();
    }
}


void keyPressed()  {
    if(key == ENTER || key == ' ') doRestart();
    if(key == 'n') debugX--;
    if(key == 'm') debugX++;
    if(key == 'j') debugY--;
    if(key == 'k') debugY++;
    handleKey(keyCode, true);
}
void keyReleased() { handleKey(keyCode, false); }

private void handleKey(int keyCode, boolean pressed){
    if (pressed) {
        if(key == 'q'){
            // console.log("AAA");
            doRestart();
        }
        if(key == 'd'){
            if (drunk == 0) drinkStart = millis();
            drunk += 0.05;
        }
        else if (key == 's') {
            // selfyOverlay.selfy();
        }
        else if (key == 'p') {
            toggleMute();
        }
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

boolean audioMute = false;
void toggleMute() {
    if (audioMute) {
        bgm.unmute();
        car.crash.unmute();
        car.tireScreech.unmute();
        beerSound.unmute();
        boostSound.unmute();
        trainSound.unmute();
    }
    else {
        bgm.mute();
        car.crash.mute();
        car.tireScreech.mute();
        beerSound.mute();
        boostSound.mute();
        trainSound.mute();
    }
    audioMute = !audioMute;
}

void stop(){
    bgm.close();
    car.crash.close();
    car.tireScreech.close();
    beerSound.close();
    boostSound.close();
    trainSound.close();
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
