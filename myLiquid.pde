//sketch based on Daniel Shiffman's Nature of Code liquidFun sketch

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.particle.*;

// A reference to our box2d world
Box2DProcessing box2d;
Surface surface;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
ArrayList<Boundary> b;
// A list for all of our rectangles
ArrayList<Box> boxes;

Boundary bound;

float countC;

int countP = 0;

PShape terra;

float terraX, terraY;

PImage img, img1;

//Movie m1;

void setup() {
  size(1220, 720, P3D);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity


  // Create ArrayLists
  boundaries = new ArrayList<Boundary>();
  b = new ArrayList<Boundary>();
  boxes = new ArrayList<Box>();

  box2d.world.setParticleRadius(0.8f);
  box2d.world.setParticleDamping(0.5f);

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2, height/2, 150+20/2, 150+20/2));
  boundaries.add(new Boundary(0, 100, 10, height*2));
  boundaries.add(new Boundary(0, height, width*2, 10));
  boundaries.add(new Boundary(width, 0, 10, height*2));

  img = loadImage("morgi0021-natura-morta-still-life-1952-600x533.jpg");
  img.resize(1280, 720);

  img1 = loadImage("terra/Textures/Diffuse_2K.png");
  terra = loadShape("terra/Earth 2K.obj");
  terra.scale(40);
  terra.setTexture(img1);

  //surface = new Surface();

  //m1 = new Movie(this, "opticalflow01.m4v");
  //m1.play();
  //m1.loop();
}


//void movieEvent(Movie m) {
//  m.read();
//}


void keyPressed() {
  Box b = new Box(100, -400);
  boxes.add(b);
}


void draw() {
  background(0);

  countC += 0.006f;

  countP += 5;

  directionalLight(235, 235, 235, 0+sin(0.017+countC)*2, 0+cos(0.01+countC)*2, -1);

  // We must always step through time!
  box2d.step();

  // Display all the boundaries
  for (Boundary wall : boundaries) {
    wall.display();
  }
  for (Box b : boxes) {
    b.display();
  }


  //beginShape(POLYGON);
  Vec2[] velBuffer = box2d.world.getParticleVelocityBuffer();
  Vec2[] positionBuffer = box2d.world.getParticlePositionBuffer();
  if (positionBuffer != null) {
    for (int i = 0; i < positionBuffer.length; i++) {

      float gx = noise(i* 0.002f + countC);
      float gy = noise(i* 0.002f + countC);

      box2d.setGravity(random(-100, 105)*gx, random(-70)*gy);

      Vec2 vel = box2d.coordWorldToPixels(velBuffer[i]);
      Vec2 pos = box2d.coordWorldToPixels(positionBuffer[i]);

      color c = img.get(int(pos.x), int(pos.y));

      float s = brightness(c);

      strokeWeight(1);
      fill(c);
      noStroke();
      stroke(10,20);

      //noStroke();
      //noFill();
      push();
      translate(pos.x, pos.y);
      //vertex(pos.x, pos.y, map(b,0,255,-100,-50));
      //curveVertex(pos.x, pos.y);
      //float theta = velocity.heading() + PI/2;
      rotateZ(radians( (i + vel.x) * 0.01));
      rotateY(radians( (i + vel.y) * 0.013));
      rotateX(radians( (i + vel.x) * 0.013));
      box(15,15,5);
      pop();



      //println(i);
    }
    //endShape();
    //surface.display();
  }


  fill(0);
  stroke(220, 240);
  strokeWeight(0.6);
  translate(0,0,10);
  rect(width/2, height/2, 150, 150);

  // terraX += 0.06;
  // terraY += 0.07;

  //stroke(100,200);
  //noStroke();
  //fill(255,0,0);
  //translate(width/2, height/2);
  //rotateY(radians(terraX));
  //rotateX(radians(terraY));
  //shape(terra);

  //fill(0);
  //text(frameRate, 10, 60);


  //saveFrame("frames_liquidMoon/liq_#####.png");
}

class Surface {

  ArrayList<Vec2> surface;

  float t = 0;

  Surface() {

    surface = new ArrayList<Vec2>();

    for (int i = 0; i < width; i++) {
      surface.add(new Vec2(i, 400+i*noise(0.002+t)));
      t += 0.002;
    }

    ChainShape chain = new ChainShape();

    Vec2[] vertices = new Vec2[surface.size()];

    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }

    chain.createChain(vertices, vertices.length);

    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(chain, 1);
  }

  void display() {

    strokeWeight(1);
    stroke(0);
    noFill();

    beginShape();
    for (Vec2 v : surface) {
      vertex(v.x, v.y);
    }

    endShape();
  }


}
