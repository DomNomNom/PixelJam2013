
class Powerup extends Obstacle{
    protected AudioPlayer sound;
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
        sound = minim.loadFile("assets/sounds/beer.mp3");
    }

    void applyEffect(){
        drunk += 0.25;
        score += 500;
        sound.play();
    }
};
