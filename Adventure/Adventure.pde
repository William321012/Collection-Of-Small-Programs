/**
  William Lin 
  CISC 1600, Fall 2021
  Project II - Graphics
*/
//Default sound libary from processing foundation.
//*Important*: If program doesn't run because of sound import issues, please delete lines 8, 11, 24, 25, 127, 135 and 179)
import processing.sound.*;

/* ******************** Variables ******************** */
SoundFile mFile;
int gamestate = 0;
int rotate = 1;
boolean summon = false, obtained = false, keepGoing = false;
PImage cloud, slime, moon, sword;
PImage[] stick = new PImage[6];
PImage[] stick2 = new PImage[6];
int xCloud = 0, xCloud2 = 700, xStick = -10, ySlime = -100, ySword = 0;
int numFrames = 6, frame = 0;

/* ******************** Setup ******************** */
//Assigns sounds and image files and sets size and framerate
void setup() {
  mFile = new SoundFile(this, "adventure.mp3");
  mFile.loop();
 
  size(700, 400);
  frameRate(17);
  
  cloud = loadImage("cloud.png");
  slime = loadImage("slime.png");
  moon = loadImage("moon.jpg");
  sword = loadImage("sword.png");
  for (int i = 0; i < 6; i++) {
    stick[i] = loadImage("stick" + i + ".png");
    stick[i].resize(70, 135);
  }
  for (int i = 0; i < 6; i++) {
    stick2[i] = loadImage("stick" + 2+i + ".png");
    stick2[i].resize(70, 135);
  }
}

/* ******************** Draw ******************** */
//Calls other functions and asks for user inputs.
void draw() {
  if (gamestate == 0) {
    background(#78d9f6);
    createBackground();
    createSun(rotate);
    rotate++;
    createStick();
    fill(#ffffff);
    textSize(17);
    text("Controls: Press P to Pause, Press SPACE Key to Spawn Slime", 0, 395);
    text("Press Z To Exit", 570, 395);
  } else if (gamestate == 1) {
    textSize(20);
    fill(#000000);
    text("Please Press P To Unpause", 240, 200);
  } else if (gamestate == 2) {
    background(moon);
    createBackground();
    createStick();
    fill(#ffffff);
    textSize(15);
    text("Controls: Press P to Pause, Press S To Send Sword", 0, 395);
    text("Press Z To Exit", 570, 395);
    createSlime();
    if (summon == true) {
      createSword();
    }
  }
}

/* ******************** Functions ******************** */
//Creates the animated sun.
void createSun(int rotate) {
  fill(#f9d71c); //Didn't change stroke because a black stroke made the animation pop out more.
  circle(50, 50, 50);
  pushMatrix();
  translate(50, 50);
  rotate(radians(3*rotate));
  for (int i = 1; i < 10; i++) {
    pushMatrix();
    translate(0, 0);
    rotate(radians(45*i));
    if (i % 2 == 0) {
      scale(1.09);
    } else {
      scale(1);
    }
    triangle(-5, 30, 5, 30, 0, 40);
    popMatrix();
  }
  popMatrix();
}

//Creates clouds and the ground, used two images to make it look continuous.
void createBackground() {
  if (gamestate != 2) {
    image(cloud, xCloud, 20);
    image(cloud, xCloud2, 20);
    xCloud -= 10;
    xCloud2 -= 10;
    if (xCloud < -700) {
      xCloud = 700;
    }
    if (xCloud2 < -700) {
      xCloud2 = 700;
    }
  }
  fill(#009A17);
  rect(-10, 350, 800, 400);
}

//Create two different animated stick figures with and without sword and has interaction code with the slime.
void createStick() {
  frame = ( frame + 1 ) % numFrames;
  if (obtained == false) {
    image(stick[frame], xStick, 280 );
  } else if (obtained == true) {
    image(stick2[frame], xStick, 280 );
  }
  xStick = (xStick + 5);

  if (summon == true && xStick == 350 && ySword > 285) {
    obtained = true;
  }

  if (xStick > width || (gamestate ==  2 && xStick > 465)) {
    xStick = -25;
    if (obtained == true) {
      noLoop();
      mFile.stop();
      textSize(25);
      text("You've Defeated The Evil Slime Congratulations!", 100, 180);
      text("Press Any Key To Restart Animation", 160, 210);
      keepGoing = true;
      reset();
    } else if (obtained == false && gamestate == 2) {
      noLoop();
      mFile.stop();
      textSize(25);
      text("You've Died, Pressed Any Key To revive", 135, 200);
      keepGoing = true;
    }
  }
}

//Creates the slime and it comes down from the sky.
void createSlime() {
  slime.resize(200, 150);

  if (ySlime < 230) {
    image(slime, 500, ySlime);
    ySlime = ySlime + 8;
  }
  image(slime, 500, ySlime);
}

//Creates a sword and sents it down from the sky.
void createSword() {
  if (obtained == false) {
    if (ySword < 320) {
      sword.resize(45, 45);
      image(sword, 350, ySword);
      ySword += 10;
    } else {
      image(sword, 350, 320);
    }
  }
}

//resets variables and gamestate
void reset() {
  gamestate = 0;
  obtained = false;
  summon = false;
  ySword = 0;
}

//Reset the animation and changes gamestate with different key presses.
void keyPressed() {
  if (keepGoing == true) {
    loop();
    mFile.loop();
    keepGoing = false;
  } else {
    if (key == 'p' || key == 'P') {
      if (gamestate == 0 || gamestate == 2) {
        gamestate = 1;
      } else if (gamestate == 1 && summon == true) {
        gamestate = 2;
      } else if (gamestate == 1 ) {
        gamestate = 0;
      }
    } else if (key == ' ') {
      gamestate = 2;
    } else if (gamestate == 2 && (key == 's' || key == 'S')) {
      summon = true;
    } else if (key == 'z') {
      exit();
    }
  }
}
