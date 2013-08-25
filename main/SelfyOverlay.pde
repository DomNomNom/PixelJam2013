


class SelfyOverlay {
    // Capture webcam;
    Capture webcam;// = new Capture(this, Capture.list()[0]);


    int time_end = 0;
    int time_flash = 0;

    SelfyOverlay() {
        String[] cameras = Capture.list();
        if (cameras.length == 0) {
            println("There are no cameras available for capture.");
            exit();
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
        time_end = millis() + 4000;
        time_flash = millis() + 2000;
    }

    void update() { }

    void draw() {
        int tim = millis();
        if (tim < time_end) {
            if (webcam!=null && webcam.available() && tim<time_flash) {
                webcam.read();
            }
            pushMatrix();
            image(webcam, 0, 0);
            popMatrix();
        }
    }
}