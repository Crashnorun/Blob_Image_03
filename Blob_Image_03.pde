import processing.video.*;
import blobDetection.*;
import processing.opengl.*;



//----GLOBAL VARIABLES----
Capture video;
BlobDetection theBlobDetection;
PImage img;
PImage img2;
PImage img3;

int count = 0;
int imgcount = 0;
color c = color(0, 0, 0, 5);
float threshold;

String path;
//----GLOBAL VARIABLES----


//----SETUP----
void setup() {
  path = sketchPath("");
  CreateFolders(path + "Cam_Images");
  CreateFolders(path + "Blob_Images");
  
  size(1600, 1200, P2D);
  frameRate(9);
  theBlobDetection = new BlobDetection(width, height);
  background(0);
  smooth();
  video = new Capture(this, width, height);
  video.start();
}    // close setup
//----SETUP----

//----DRAW----
void draw() {
  if (video.available()) {
    video.read();                                  // read the web cam
    img  = createImage(width, height, RGB);        // create an image from the camera
    img = video;                                   // assign video to the image

    theBlobDetection.setPosDiscrimination(true);
    theBlobDetection.setThreshold(threshold);

    if (second() % 5 ==0) {                        // every 5 seconds save the image
      img.save(path + "\\Cam_Images\\" + str(imgcount) + ".jpg");
      img2 = loadImage(path + "\\Cam_Images\\" + str(imgcount) + ".jpg");    // load the saved image
      imgcount++;

      if (imgcount >= 100) {
        imgcount = 0;
      }
    }

    if (second() % 20 == 0) {                    // save the blob image every 20
      save(path + "\\Blob_Images\\Image_" + count + ".jpg");

      count++;
      if (count >=400) {                          // save 400 final images for record keeping
        count = 0;
      }
    }


    if (img2 != null) {                          // when there is an image saved
      fill(c);
      rect(0, 0, width, height);                 // redraw the background

      theBlobDetection.computeBlobs(img2.pixels);// computes the blobs in the image
      drawBlobsAndEdges(false, true, 255);       // first bolean is rectangle, second bolean is blob edge
    }

    if (threshold <= 0) {                        // counter for threshold
      threshold= 0.95;
    } else {
      threshold = threshold - 0.0125;
    }
  }    // close IF available
}    // close draw
//----DRAW----


//----BLOB EDGES----
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges, int MN)
{
  noFill();
  //fill(threshold);
  Blob b;
  EdgeVertex eA, eB;
  stroke(MN);


  for (int n = 0; n < theBlobDetection.getBlobNb (); n++) {  // theBlobDetection.getBlobNb - returns the nuber of blobs in an image
    b=theBlobDetection.getBlob(n);                           // returns the blob whose index is n in the list of blobs

    if (b!=null) {
      // Edges
      if (drawEdges) {
        strokeWeight(0.5);

        for (int m=0; m<b.getEdgeNb (); m= m + 1) {
          eA = b.getEdgeVertexA(m);                          // each edge of a blob is made of two points and a line
          eB = b.getEdgeVertexB(m);

          if (eA !=null && eB !=null) 
            line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
        }
      }
      // Blobs
      if (drawBlobs) {
        strokeWeight(0.5);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }
    }
  }
}//----BLOB EDGES----


//----CAMERA INFO----
//this prints out the information for the web cam
void CameraInfo() {
  Capture cam;
  String[] cameras = Capture.list();

  for (int i = 0; i < cameras.length; i++) {
    println(cameras[i]);
  }
}//----CAMERA INFO----



  //-------------------------------------------------------------------------------
  // Create the appropiate file paths
  private void CreateFolders(String FilePath) {

    File folder = new File(FilePath);
    if (!folder.exists()) {                            //check if file path exists
      println("creating directory: " + FilePath);
      folder.mkdir();                                  //make the file path
    } 
    else {
      println("Path: '" + FilePath + "' already exists");
    }
  }





