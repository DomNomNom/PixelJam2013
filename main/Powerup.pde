
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
    }
};

class Beer extends Powerup{
    Beer(PVector pos) {
        super("assets/powerups/beer.png", pos);
    }

    void applyEffect(){
        drinkStart = millis();
        drunk += 0.2;
        score += 500;
        beerSound.rewind();
        beerSound.play();
    }
};

Powerup randomPowerup(PVector pos) {
    switch((int)random(4)) {
        case 0:
        return new Beer(pos);
        case 1:
        return new Beer(pos);
        case 2:
        return new Beer(pos);
        case 3:
        return new Boost(pos);
    }
    return null;
}
