
class GUI {
    PFont font;
    
    GUI() {
        font = createFont("Courier New", 32);
    }

    void update() {
    }

    void draw() {
        textFont(font);
        fill(240);
        text("Score: " + score, 20, 40);
        text("Speed: " + (int)(car.speed*3), 20, 80);
    }
}
