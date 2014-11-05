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

  l1 = new UpCurvedLane(new PVector(10, 250), new PVector(450, 250));
  l1.generate();
  gridcontainer.addElement(l1);  
  l2 = new CarLane(new PVector(10, 270), new PVector(450, 270));
  l2.generate();
  gridcontainer.addElement(l2);
  l3 = new DownCurvedLane(new PVector(10, 290), new PVector(450, 290));
  l3.generate();
  gridcontainer.addElement(l3);
  
  gridcontainer.addElement(new TrafficLight(100, 100));
}

void spawnCar() {
  ArrayList<Frame> elements = getElementsAt(gridcontainer, mouseX, mouseY);
  
  if (elements.size() <= 0 || !(elements.get(0) instanceof CarLane)) {
    return;
  }
  
  CarLane lane = (CarLane) elements.get(0);
  
  Car c1 = new Car(lane);
  gridcontainer.addElement(c1); 
}

void draw() {
  //println("main::draw() mouse is at '" + mouseX + ":" + mouseY + "'");
}

ArrayList<Frame> getElementsAt(FrameContainer container, int x, int y) {
  ArrayList<Frame> doh = new ArrayList<Frame>();
  
  for (int i = 0; i < container.elements.size(); i++) {
    Frame f = container.elements.get(i);
    float abs = f.absTo(x, y);
    
    if (abs < 30.0f) {
      doh.add(f);
    }
  }
  
  return doh;
}

void mouseReleased() {
  spawnCar();
}
