
class Powerup extends Obstacle{
    Powerup(String fileName, PVector pos) {
        super(fileName, pos);
    }
    
    //has effect behaviour
    void applyEffect(){}
};

class Boost extends Powerup{
    Boost(PVector pos) {super("assets/boost.png", pos);}
    
    void applyEffect(){
        car.speed = car.maxSpeed;
    }
}

class Beer extends Powerup{
    Beer(PVector pos) {super("assets/powerups/beer.png", pos);}
    
    void applyEffect(){
        drunk += 0.2;
    }
}
