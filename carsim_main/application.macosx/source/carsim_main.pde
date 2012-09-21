PFont font1, font2;
FrameContainer menu, gridcontainer;
PApplet app = this;
CarLane l1, l2, l3;

void setup() {
  size(800, 600);
  font1 = loadFont("Kalinga-8.vlw");
  font2 = loadFont("Kalinga-14.vlw");  
  menu = new FrameContainer(600, 10, 100, 500);
  gridcontainer = new FrameContainer(10, 10, 500, 550);

  l1 = new UpCurvedLane(new Vector2(10, 250), new Vector2(450, 250));
  l1.generate();
  gridcontainer.addElement(l1);  
  l2 = new CarLane(new Vector2(10, 270), new Vector2(450, 270));
  l2.generate();
  gridcontainer.addElement(l2);
  l3 = new DownCurvedLane(new Vector2(10, 290), new Vector2(450, 290));
  l3.generate();
  gridcontainer.addElement(l3);
}

void spawnCar() {
  Car c1 = new Car(l1);
  gridcontainer.addElement(c1); 
  
  Car c2 = new Car(l2);
  gridcontainer.addElement(c2);

  Car c3 = new Car(l3);
  gridcontainer.addElement(c3);  
}

void draw() {
  //println("main::draw() mouse is at '" + mouseX + ":" + mouseY + "'");
}

void mouseReleased() {
  spawnCar();
}
