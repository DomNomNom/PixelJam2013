
class Engine {
    AudioPlayer[] engSound;
    boolean soundSwitch = false;
    int playedTime = -2000;
    int prevRev = 0;
    
    Engine(){
        engSound = new AudioPlayer[10];
        engSound[0] = minim.loadFile("assets/sounds/engine0.mp3");
        engSound[1] = minim.loadFile("assets/sounds/engine1.mp3");
        engSound[2] = minim.loadFile("assets/sounds/engine2.mp3");
        engSound[3] = minim.loadFile("assets/sounds/engine3.mp3");
        engSound[4] = minim.loadFile("assets/sounds/engine4.mp3");
        engSound[5] = minim.loadFile("assets/sounds/engine5.mp3");
        engSound[6] = minim.loadFile("assets/sounds/engine6.mp3");
        engSound[7] = minim.loadFile("assets/sounds/engine7.mp3");
        engSound[8] = minim.loadFile("assets/sounds/engine8.mp3");
        engSound[9] = minim.loadFile("assets/sounds/engine9.mp3");
        
    }
   
    void update(){ 
         int time = millis();
         int revs = (int)lerp(0, 10, car.speed/(car.boostSpeed+1));
         if(revs != prevRev){
             engSound[revs].rewind();
             engSound[revs].setGain(-50); 
             engSound[revs].play();
             engSound[revs].shiftGain(-5, 0, 200);
             engSound[prevRev].shiftGain(0, -25, 500);
             playedTime = time;
             prevRev = revs;
         }
         if(time - playedTime > 4000){
             engSound[prevRev].rewind();
             engSound[prevRev].play();
             playedTime = time;
         }
    }
  
} 
