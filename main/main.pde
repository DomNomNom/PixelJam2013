import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.GL2;
GL2 gl;
PGraphicsOpenGL pgl;

PVector center; // center of the screen
PVector windowSize;

float carLine;


Car car;
Camera cam;
Road road;

void setup() {
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);

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

    carLine = center.y * 1.5;
}

void draw() {
    clear();

    car.update();

    pgl.beginPGL();
    pushMatrix();
        cam.doTranslate();
        road.draw();
        car.draw();
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
