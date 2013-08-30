

// this file is deliberately not included in the JS version
// The functions in this file can be treated as the shared interface to the webcam.


// implementation variables
Capture webcam;// = new Capture(this, Capture.list()[0]);
int webcam_wd;
int webcam_ht;

void webcam_init(int desired_wd, int desired_ht) {
    webcam_wd = desired_wd;
    webcam_ht = desired_ht;

    String[] cameras = Capture.list();
    if (cameras.length == 0) {
        //println("There are no cameras available for capture.");
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

boolean webcam_ready() {
    return (webcam != null);
}

void webcam_update() {
    if (webcam.available())
        webcam.read();
}

void webcam_draw() {
    image(webcam, 0, 0, webcam_wd, webcam_ht);
}

