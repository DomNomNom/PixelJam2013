
class GUI {
    PFont font;
    PImage overlay;
    int overlayStart, overlayTimer;
    

    GUI() {
        font = createFont("Courier New", 32);
    }

    void update() {
        if(!bgm.isPlaying()) bgm.loop();
    }

    void draw() {
        textFont(font);
        if(overlay != null){
            if(millis() - overlayStart > overlayTimer){
                overlay = null;
            } else {
                image(overlay, center.x, center.y);
            }
        }
        fill(240);
        text("Score: " + score, 20, 40);
        text("Speed: " + (int)(car.speed*3), 20, 80);
    }
    
    /**
    /* Overlay an image on the gui, underneath the gui elements.
    /* @param img The image to display
    /* @param time The length of time to overlay image, in milliseconds
    /**/
    void applyOverlay(PImage img, int time){
        overlay = img;
        overlayStart = millis();
        overlayTimer = time;
    }
};
