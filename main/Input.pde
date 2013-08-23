static class Input{
    public static boolean up, down, left, right;
    
    static void handleKey(int keyCode, boolean pressed){
        switch (keyCode) {
            case LEFT:
                left = pressed;
                break;
            case RIGHT:
                right = pressed;
                break;
            case UP:
                up = pressed;
                break;
            case DOWN:
                down = pressed;
                break;
        }
}
}
