
class Engine {
    AudioPlayer[] engSound;
    boolean soundSwitch = false;
    int playedTime = -2000;
    int prevRev = 0;

    Engine(){
        engSound = new AudioPlayer[10];
        engSound[0] = sound("engine0");
        engSound[1] = sound("engine1");
        engSound[2] = sound("engine2");
        engSound[3] = sound("engine3");
        engSound[4] = sound("engine4");
        engSound[5] = sound("engine5");
        engSound[6] = sound("engine6");
        engSound[7] = sound("engine7");
        engSound[8] = sound("engine8");
        engSound[9] = sound("engine9");
    }

    void update(){
         int time = millis();
         int revs = (int)lerp(0, 10, car.speed/(car.boostSpeed+1));
         if(revs < 0) revs = 0;
         if(revs != prevRev){
             engSound[revs].rewind();
             engSound[revs].setGain(-50);
             engSound[revs].play();
             engSound[revs].shiftGain(-5, -1, 200);
             engSound[prevRev].shiftGain(-1, -25, 500);
             playedTime = time;
             prevRev = revs;
         }
         if(time - playedTime > 4000){
             engSound[prevRev].rewind();
             engSound[revs].setGain(-1);
             engSound[prevRev].play();
             playedTime = time;
         }
    }

}
