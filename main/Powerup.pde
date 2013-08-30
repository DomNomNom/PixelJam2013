
class Powerup extends Obstacle{
    Powerup(String fileName, PVector pos) {
        super(fileName, pos);
    }

    //has effect behaviour
    void applyEffect(){}

    void draw(){
        super.draw();
        if (pos.y < cam.top) {
            pushMatrix();
            translate(pos.x, car.pos.y + 125);
            image(hashtag, 0, 0);
            popMatrix();
        }
    }
};

class Boost extends Powerup{
    Boost(PVector pos) {super("assets/scaled/boost.png", pos);}
    public final static int time = 2000;

    void applyEffect(){
        car.speed = car.boostSpeed;
        car.boosting = true;
        car.boostTime = millis();
        boostSound.rewind();
        boostSound.play();
    }
};

class Beer extends Powerup{
    Beer(PVector pos) {super("assets/scaled/beer.png", pos);}

    void applyEffect(){
        drinkStart = millis();
        drunk += 0.35;
        score += 500;
        beerSound.rewind();
        beerSound.play();
    }
};

class RayBans extends Powerup{
    PImage overlayImg;
    RayBans(PVector pos) {
        super("assets/scaled/raybans.png", pos);
        overlayImg = loadImage("assets/raybansOverlay.png");
    }

    void applyEffect(){
        gui.applyOverlay(overlayImg, 6000);
        score += 5000;
    }
};

class Selfy extends Powerup {
    Selfy(PVector pos) {super("assets/scaled/insta.png", pos);}

    void applyEffect(){
        // selfyOverlay.selfy();
        score += 10000;
    }
};

Powerup randomPowerup(PVector pos) {
    switch((int)random(4)) {
        case 0: return new Beer(pos);
        case 1: return new Selfy(pos);
        case 2: return new RayBans(pos);
        case 3: return new Boost(pos);
    }
    return null;
}

