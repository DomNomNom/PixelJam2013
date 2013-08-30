
// this is a hybrid processing/JS file which can be used the same way as webcam.pde

var video = document.createElement("video");
video.setAttribute("style", "display:none;");
video.setAttribute("id", "videoOutput");
video.setAttribute("width", "500px");
video.setAttribute("height", "660px");
video.setAttribute("autoplay", "true");
if(document.body!=null) document.body.appendChild(video);

// var video = document.getElementById("videoOutput");


var getUserMedia = function(t, onsuccess, onerror) {
    if (navigator.getUserMedia)              return navigator.getUserMedia(         t, onsuccess, onerror);
    else if (navigator.webkitGetUserMedia)   return navigator.webkitGetUserMedia(   t, onsuccess, onerror);
    else if (navigator.mozGetUserMedia)      return navigator.mozGetUserMedia(      t, onsuccess, onerror);
    else if (navigator.msGetUserMedia)       return navigator.msGetUserMedia(       t, onsuccess, onerror);
    else {
        onerror(new Error("No getUserMedia implementation found."));
    }
};

var URL = window.URL || window.webkitURL;
var createObjectURL = URL.createObjectURL || webkitURL.createObjectURL;
if (!createObjectURL) {
    throw new Error("URL.createObjectURL not found.");
}

var video_ready = false;
var ctx;


PGraphics buffer;
int webcam_wd;
int webcam_ht;


// interface from here on

void webcam_init(int desired_wd, int desired_ht) {
    buffer = createGraphics(desired_wd, desired_ht, P3D);
    webcam_wd = desired_wd;
    webcam_ht = desired_ht;

    ctx = externals.context;

    getUserMedia({audio:true, video:true},
        function(stream) {
            var url = createObjectURL(stream);
            video.src = url;
            video_ready = true;
        },
        function(error) {
            println("Couldn’t access webcam.");
            //alert&#40;"Couldn’t access webcam."&#41;;
        }
    );
}

boolean webcam_ready() {
    return video_ready;
}

void webcam_update() {
    // buffer.beginDraw();
    //     // imageMode(CENTER);
    //     pushMatrix();
    //         translate(-webcam_wd, -webcam_ht);
    //     popMatrix();
    //     // image(video, webcam_wd/2, webcam_ht/2, webcam_wd, webcam_ht);
    // buffer.endDraw();
}

void webcam_draw() {
    // imageMode(CENTER);
    // image(buffer.get(), 0,0, webcam_wd, webcam_ht);
    ctx.drawImage(video, -webcam_wd/2, -webcam_ht/2, webcam_wd, webcam_ht);
}


// ========== example sketch ============

// var ctx;
// PImage img;
// int nb=20;

// void setup(){
//     size(500,660);
//     ctx = externals.context;
//     ellipseMode(CORNER);
//     smooth();
// }

// void draw(){
//     pushMatrix();
//     translate(width,0);
//     scale(-1,1);//mirror the video
//     ctx.drawImage(video, 0, 0, width, height); //video is defined outside processing code
//     popMatrix();

//     img=get();
//     img.resize(nb,nb);
//     background(255);
//     noStroke();
//     for(int j=0; j<nb; j++){
//         for(int i=0; i<nb; i++){
//             fill(img.get(i, j));
//             ellipse(i*width/nb, j*height/nb, width/nb, height/nb);
//         }
//     }
// }
