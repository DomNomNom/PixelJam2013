
class Powerup extends Obstacle{
    Powerup(String fileName, PVector pos) {
        super(fileName, pos);
    }

    //has effect behaviour
    void applyEffect(){}
};

class Boost extends Powerup{
    Boost(PVector pos) {super("assets/powerup.png", pos);}
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
        drunk += 0.4;
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
        gui.applyOverlay(overlayImg, 8000);
        score += 500;
    }
};

Powerup randomPowerup(PVector pos) {
    switch((int)random(3)) {
        case 0:
        return new Beer(pos);
        case 1:
        return new Boost(pos);
        case 2:
        return new RayBans(pos);
    }
    return null;
}
