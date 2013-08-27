class RoadTile {
    PImage img;
    String name;
    int probSum;
    
    ArrayList<Float> lanes_slow = new ArrayList<Float>();
    ArrayList<Float> lanes_fast = new ArrayList<Float>();
    ArrayList<Float> lanes_all  = new ArrayList<Float>();
    ArrayList<RoadTransition> transitions = new ArrayList<RoadTransition>();
    ArrayList<RoadTileObstacle> obstacles = new ArrayList<RoadTileObstacle>();

    RoadTile(String fileName, String n) {
        img = loadImage(fileName);
        name = n;
        
        // parse settings file
        String[] ln = loadStrings("assets/roadSettings/"+n+".txt");
        Scanner sc;
        for(String s : ln){
            if(s.length() <= 1) continue; 
            sc = new Scanner(s);
            String t = sc.next().toLowerCase();
            if(t.length() != 1){
                throw new RuntimeException("Expected token character of size 1; got "+t);
            }
            char token = t.charAt(0);
            switch(token){
                case 's':
                while(sc.hasNext()) lanes_slow.add((float)sc.nextInt());
                break;
                case 'f':
                while(sc.hasNext()) lanes_fast.add((float)sc.nextInt());
                break;
                case 't':
                    int p = sc.nextInt();
                    probSum += p;
                    transitions.add(new RoadTransition(p, sc.next()));
                break;
                case 'o':
                    obstacles.add(new RoadTileObstacle(new PVector(sc.nextInt(), sc.nextInt()), sc.next()));
                break;
                default:
                throw new RuntimeException("Expected token character (s, f, t, o); got "+t);
            }
            sc.close();
        }

        for (Float lane : lanes_slow) lanes_all.add(lane);
        for (Float lane : lanes_fast) lanes_all.add(lane);
    }

    void draw(float y) {
        image(
            img,
            center.x, y,
            img.width, img.height
        );
        if(this.name.equals("TrainTracks") && y < cam.top && !trainSignals){
            trainSign.update();
            trainSign.draw(center.x, cam.top+100);
            if(!trainSound.isPlaying()){
                trainSound.rewind();
                trainSound.loop();
            }
            trainSignals = true;
        }
        if(this.name.equals("Bridge") && y+(img.height*0.5) < cam.top){
            image(bridgeSign, center.x, cam.top+100);
        }
    }
};

class RoadTransition{
    int prob;
    String name;
    RoadTransition(int p, String n){
        prob = p; name = n;
    }
}

class RoadTileObstacle{
    PVector pos;
    String fileName;
    RoadTileObstacle(PVector p, String n){
        pos = p; fileName = n;
    }
}
