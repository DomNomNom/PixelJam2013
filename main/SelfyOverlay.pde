


class SelfyOverlay {
    // Capture webcam;
    Capture webcam;// = new Capture(this, Capture.list()[0]);

    PImage phone;
    PImage glitchScreen;

    int time_up     = 0;
    int time_end    = 0;
    int time_flash  = 0;
    int time_down   = 0;

    SelfyOverlay() {
        phone        = loadImage("assets/scaled/phone.png",        "png");
        glitchScreen = loadImage("assets/scaled/glitchscreen.png", "png");
        String[] cameras = Capture.list();
        if (cameras.length == 0) {
            println("There are no cameras available for capture.");
        } else {
            // println("Available cameras:");
            // for (int i = 0; i < cameras.length; i++) {
            //     println(cameras[i]);
            // }

            // element from the array returned by list():
            webcam = new Capture(globalSelfReference, cameras[0]);
            webcam.start();
        }
    }

    void selfy() {
        int tim = millis();
        time_up     = tim       + 1000;
        time_flash  = time_up   + 2000;
        time_down   = time_flash+ 2000;
        time_end    = millis()  + 1000;
    }

    void update() { }

    void draw() {
        int tim = millis();
        if (tim < time_end) {
            pushMatrix();
            // if      (tim < time_up  )   translate(center.x, lerp(center.y*3, center.y, );
            // else if (tim < time_down)   translate(center.x, center.y);
            // else                        translate(center.x, center.y);

            rotate(HALF_PI*-.2);
            if (webcam!=null) {
                if(tim < time_flash && webcam.available())
                    webcam.read();
                pushMatrix();
                scale(0.8, 0.8);
                image(webcam, 0, 0);
                popMatrix();
            }
            else {
                image(glitchScreen, 0, 0);
            }


            rotate(HALF_PI);
            image(phone, 0,0);


            popMatrix();
        }
    }
}
