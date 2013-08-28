

// a wrapper for minim.loadFile
AudioPlayer sound(String fileName) {
    // fileName = "assets/oggSounds/cleaned/"+fileName+".wav";
    fileName = "assets/sounds/"+fileName+".mp3";
    // println("loading " + fileName);
    return minim.loadFile(fileName);
}