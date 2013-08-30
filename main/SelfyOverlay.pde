


class SelfyOverlay {

    PImage phone;
    PImage glitchScreen;
    PImage whiteScreen;

    int time_start  = 0;
    int time_up     = 0;
    int time_end    = 0;
    int time_flash  = 0;
    int time_down   = 0;

    SelfyOverlay() {
        phone        = loadImage("assets/scaled/phone.png");
        glitchScreen = loadImage("assets/scaled/glitchscreen.png");
        whiteScreen  = loadImage("assets/scaled/whitescreen.png");
        webcam_init(640, 480);
    }

    void selfy() {
        int tim = millis();
        time_start  = tim       +    0;
        time_up     = tim       + 1000;
        time_flash  = time_up   + 2000;
        time_down   = time_flash+ 2000;
        time_end    = time_down + 1000;
    }

    void update() { }

    void draw() {
        int tim = millis();
        if (tim < time_end) {
            pushMatrix();
            translate(center.x, 0);

            if      (tim < time_up  )   translate(0, lerp(center.y*3, center.y, (tim-time_start)/1000.0));
            else if (tim < time_down)   translate(0, center.y);
            else                        translate(0, lerp(center.y, center.y*3, (tim-time_down)/1000.0));

            rotate(HALF_PI*-.2);
            pushMatrix();
                scale(0.8, 0.8);
                if (webcam_ready()) {
                    if (tim < time_flash)
                        webcam_update();
                    webcam_draw();
                }
                else {
                    image(glitchScreen, 0, 0);
                }
                if (tim > time_flash && tim < time_flash + 200) {
                    // fill(255, dlerp(255,0, tim-time_flash));
                    // rect(0,0, glitchScreen.width, glitchScreen.height);
                    image(whiteScreen, 0,0);
                }
            popMatrix();


            rotate(HALF_PI);
            image(phone, 0,0);


            popMatrix();
        }
    }
};
