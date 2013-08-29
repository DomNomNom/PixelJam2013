
class GUI {
    PFont font;
    PImage overlay;
    int overlayStart, overlayTimer;
    PImage scoreSpeed;

    public void reset(){
        overlay = null;
    }

    GUI() {
        font = createFont("Courier New", 32);
        scoreSpeed = loadImage("assets/scaled/scorespeed.png");
    }

    void update() {
        // if (!bgm.isPlaying()) bgm.loop();
    }

    void draw() {
        textFont(font);
        if (overlay != null){
            if (millis() - overlayStart > overlayTimer){
                if (gameState == 2) overlay = null;
            } else {
                image(overlay, center.x, center.y);
            }
        }

        noStroke();

        //fill(240);
        //text("Score: " + score, 20, 40);
        //text("Speed: " + (int)(car.speed*5), 20, 80);

        fill(255);
        float x = scoreSpeed.width*0.5 + 10;
        float y = scoreSpeed.height*0.5 + 10;
        rect(x, y, scoreSpeed.width*0.9, scoreSpeed.height*0.5);
        if (car.boosting){
            color from = color(46, 153, 244);
            color to = color(250, 10, 20);
            fill(lerpColor(from, to, (car.speed-car.maxSpeed)/(car.boostSpeed-car.maxSpeed)));
        } else fill(46, 153, 244);
        float barSize = (constrain(car.speed, 0, car.maxSpeed)/car.maxSpeed) * scoreSpeed.width*0.9;
        rect(lerp(x-scoreSpeed.width*0.45, x, constrain(car.speed, 0, car.maxSpeed)/car.maxSpeed), y, barSize, scoreSpeed.height*0.5);
        image(scoreSpeed, x, y);
        fill(255);
        text(score, x-20, y+45);
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
