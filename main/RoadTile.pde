

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
        // this is a bit messy as we are trying to be compatible with JS.
        String[] lines = loadStrings("assets/roadSettings/"+n+".txt");
        for (int i=0; i<lines.length; ++i) {
            String s = lines[i];
            if (s.length() <= 1) continue;
            String[] tokens = s.split(" ");

            // decide from the first token what to do
            String token = tokens[0];
            if("t".equals(token)) { // transitions
                int p = (int)(Float.parseFloat(tokens[1]));
                probSum += p;
                transitions.add(new RoadTransition(p, tokens[2]));
            }
            else if("o".equals(token)) { // obstacles
                obstacles.add(new RoadTileObstacle(
                    new PVector(Float.parseFloat(tokens[1]), Float.parseFloat(tokens[2])),
                    tokens[3]
                ));
            }
            // slow and fast lane
            else if("s".equals(token))  for (int j=1; j<tokens.length; ++j) lanes_slow.add(Float.parseFloat(tokens[j]));
            else if("f".equals(token))  for (int j=1; j<tokens.length; ++j) lanes_fast.add(Float.parseFloat(tokens[j]));
            else {
                println("OMG WTF, FILE IS WRONG! why you have to be mad?");
            }
        }
        // String[] ln = loadStrings("assets/roadSettings/"+n+".txt");
        // Scanner sc;
        // for(String s : ln) {
        //     if(s.length() <= 1) continue;
        //     sc = new Scanner(s);
        //     String t = sc.next().toLowerCase();
        //     if(t.length() != 1){
        //         throw new RuntimeException("Expected token character of size 1; got "+t);
        //     }
        //     char token = t.charAt(0);
        //     switch(token){
        //         case 's':
        //         while(sc.hasNext()) lanes_slow.add((float)sc.nextInt());
        //         break;
        //         case 'f':
        //         while(sc.hasNext()) lanes_fast.add((float)sc.nextInt());
        //         break;
        //         case 't':
        //             int p = sc.nextInt();
        //             probSum += p;
        //             transitions.add(new RoadTransition(p, sc.next()));
        //         break;
        //         case 'o':
        //             obstacles.add(new RoadTileObstacle(new PVector(sc.nextInt(), sc.nextInt()), sc.next()));
        //         break;
        //         default:
        //         throw new RuntimeException("Expected token character (s, f, t, o); got "+t);
        //     }
        //     sc.close();
        // }

        // build lanes_all from both slow and fast
        for (Float lane : lanes_slow) lanes_all.add(lane);
        for (Float lane : lanes_fast) lanes_all.add(lane);
    }

    void draw(float y) {
        image(
            img,
            center.x, y,
            img.width, img.height
        );
        // if(this.name.equals("TrainTracks") && y < cam.top && !trainSignals){
        //     trainSign.update();
        //     trainSign.draw(center.x, cam.top+100);
        //     if(!trainSound.isPlaying()){
        //         trainSound.rewind();
        //         trainSound.loop();
        //     }
        //     trainSignals = true;
        // }
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
};

class RoadTileObstacle{
    PVector pos;
    String fileName;
    RoadTileObstacle(PVector p, String n){
        pos = p; fileName = n;
    }
};


