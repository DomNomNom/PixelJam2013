
class Animation{
    PImage[] frames;
    int index = 0;
    int frameSpeed;
    int tick = 0;
    PVector pos;
    
    Animation(PImage[] img, PVector p, int fs){
        frames = img;
        pos = p;
        frameSpeed = fs;
    }
    
    void draw(){
        image(getCurrentFrame(), pos.x, pos.y);
    }
    
    void update(){
        ++tick;
        if(tick > frameSpeed){
            ++index;
            if(index >= frames.length){
                index = 0;
            }
            tick = 0;
        }
    }
    
    PImage getCurrentFrame(){
        return frames[index];
    }
}
