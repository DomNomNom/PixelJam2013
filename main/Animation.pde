
class Animation{
    PImage[] frames;
    int index = 0;
    int frameSpeed;
    int tick = 0;
    PVector pos;
    boolean looping = true;
    
    Animation(PImage[] img, PVector p, int fs){
        frames = img;
        pos = p;
        frameSpeed = fs;
    }
    
    Animation(PImage[] img, PVector p, int fs, boolean loop){
        frames = img;
        pos = p;
        frameSpeed = fs;
        looping = loop;
    }
    
    void draw(){
        if(!looping && index < 0) return; 
        image(getCurrentFrame(), pos.x, pos.y);
    }
    
    void draw(float x, float y){
        pos = new PVector(x, y);
        draw();
    }
    
    void update(){
        ++tick;
        if(tick > frameSpeed){
            ++index;
            if(index >= frames.length){
                if(looping) index = 0;
                else index = -1;
            }
            tick = 0;
        }
    }
    
    void rewind(){
        tick = 0;
        index = 0;
    }
    
    boolean ready(){
        return (index >= 0);  
    }
    
    PImage getCurrentFrame(){
        return frames[index];
    }
}
