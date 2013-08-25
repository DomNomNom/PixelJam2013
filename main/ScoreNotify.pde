

PFont scoreFont = createFont("Helvetica-Bold", 32);
public class ScoreNotify {
    ArrayList<ScoreLabel> scores = new ArrayList<ScoreLabel>();

    public ScoreNotify() { }

    void notify(float x, int value) {
        if (value == 0) return;
        scores.add(new ScoreLabel(x, value));
    }

    void update() {
        int tim = millis();
        for (int i=scores.size()-1; i>=0; --i) {
            if (tim > scores.get(i).endTime)
                scores.remove(i);
        }
    }

    void draw() {
        for (ScoreLabel s : scores)
            s.draw();
    }
}

class ScoreLabel {
    float x;
    int value;
    int endTime;

    ScoreLabel(float x, int value) {
        this.x = x;
        this.value = value;
        endTime = millis() + 1000;
    }

    void draw() {
        pushMatrix();
        translate(x, car.pos.y);

        fill(0);
        textFont(scoreFont);
        String txt = "+" + value;
        float wd = textWidth(txt);
        text(txt, wd*-.5, 0);
        popMatrix();
    }
}