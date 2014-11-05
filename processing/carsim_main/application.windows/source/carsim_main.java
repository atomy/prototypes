import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class carsim_main extends PApplet {

PFont font1, font2;
FrameContainer menu, gridcontainer;
PApplet app = this;
CarLane l1, l2, l3;

public void setup() {
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

public void spawnCar() {
  Car c1 = new Car(l1);
  gridcontainer.addElement(c1); 
  
  Car c2 = new Car(l2);
  gridcontainer.addElement(c2);

  Car c3 = new Car(l3);
  gridcontainer.addElement(c3);  
}

public void draw() {
  //println("main::draw() mouse is at '" + mouseX + ":" + mouseY + "'");
}

public void mouseReleased() {
  spawnCar();
}
public class MenuButton extends LabelButton {
  ControlMenu parent;
  
  MenuButton(float x, float y, float w, float h, String label) {
    super(x, y, w, h, label);  
  }
  
  public void setParent(ControlMenu f) {
    this.parent = f;
  }
  
  public void onClick(int x, int y) {
//    println("MenuButton::onClick()");
    parent.setCurActive(this);
  }
}

public class Button extends Frame { 
  int fillColor;
  int strokeColor;
  
  Button(float x, float y, float w, float h) {
    super(x, y, w, h); 
    resetColor();
  }
  
  public void draw() {
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CORNER);
    rect(round(x), round(y), round(w), round(h));
  }
  
  public @Override
  void onClick(float x, float y) {
    //println("Button::onClick()");
  }
  
  public void resetColor() {
    strokeColor = color(0);
    fillColor = color(230);    
  }
  
  public void setDisabled() {
    fillColor = color(255, 0, 0);
    bDisabled = true;
  }
  
  public void setEnabled() {
    resetColor();
    bDisabled = false;
  }
}

public class LabelButton extends Button {
  String label;
  
  LabelButton(float x, float y, float w, float h, String label) {
    super(x, y, w, h);
    this.label = label;
  }
  
  public void draw() {
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CORNER);
    rect(x, y, w, h);
    fill(0);
    textFont(font2);
    text(label, this.x+20, this.y+20);  
  }
  
  public @Override
  void onClick(float x, float y) {
    //println("LabelButton::onClick()");
  }
}
public class Car extends Button {
  static final int sizeX = 25;
  static final int sizeY = 10;
  
  private long nextUpdate = 0;
  private Vector2 moveDir = new Vector2(1,0);
  CarLane currentLane = null;
  Vector2 currentNode = null;
  float angle = 0;
  
  Car(CarLane lane) {
    super(lane.getFirstPoint().x, lane.getFirstPoint().y, sizeX, sizeY);
    fillColor = color(255, 0, 0);
    strokeColor = color(0, 0, 255);
    currentLane = lane;
  }
  
  public void draw() {
    if(nextUpdate < millis()) {
      update();
      nextUpdate = millis() + 40;
    }
    strokeWeight(3);
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    rect(0, 0, w, h);
    popMatrix();
  }
  
  public void updateMoveDir() {
    if(currentLane != null) {      
      Vector2 nextNode = currentLane.getNextNode(currentNode);
      if(nextNode == null) {
        currentLane = null;
        //println("Car::updateMoveDir() nextNode is 0!: '" + moveDir.x + ":" + moveDir.y + "'");
        return;
      }
      if(currentNode != null) {
        moveDir.x = nextNode.x - currentNode.x;
        moveDir.y = nextNode.y - currentNode.y;
      }
      currentNode = nextNode;
      if(moveDir.x == 0 && moveDir.y != 0) {
        if(moveDir.y > 0)
          angle = PI/2;
        else
          angle = -PI/2;
      } else {
        angle = atan(moveDir.y / moveDir.x);
      }
      //println("Car::updateMoveDir() nextNode is != 0!: '" + moveDir.x + ":" + moveDir.y + "' a: '" + angle + "'");
    } else {
      moveDir.x = moveDir.y = 0;
      deleteMe = true;
      //println("Car::updateMoveDir() setting to 0: '" + moveDir.x + ":" + moveDir.y + "'");
    }
  }
  
  public void update() {
    updateMoveDir();
    x += moveDir.x;
    y += moveDir.y;
  }
}
public class CarLane extends Button
{
  public ArrayList<Vector2> nodes;
  Vector2 end, start;
  
  CarLane(Vector2 start, Vector2 end) {
    super(start.x, start.y, 10, 10);
    this.start = start;
    this.end = end;    
    fillColor = color(0);
    strokeColor = color(255);
    nodes = new ArrayList<Vector2>();
  }
  
  public void generate() {
    if(start.y == end.y) {
      //println("CarLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
      for(float x = start.x; x <= end.x; x+=4) {
        nodes.add(new Vector2(x, start.y));
      }
    } else if(start.x == end.x) {
      //println("CarLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
      for(float y = start.y; y <= end.y; y+=4) {
        nodes.add(new Vector2(start.x, y));
      }      
    }
//    for(Vector2 v : nodes) {
//      println("CarLane::generate() printing content: '" + v.x + ":" + v.y + "'");
//    }    
  }
  
  public void draw() {
    strokeWeight(1);
    stroke(strokeColor);
    fill(fillColor);
    //rect(x, y, w, h);
    fill(0);
    //println("CarLane::draw() drawing '" + nodes.size() + "' nodes");
    for(Vector2 v : nodes) {
//    println("CarLane::draw() drawing node at '" + v.x + ":" + v.y + "'");
      noFill();
      stroke(color(120, 120, 0));
      rect(v.x, v.y, 1, 1);
    }
  }
  
  public Vector2 getNextNode(Vector2 c) {    
    boolean found = false;
    if(c == null)
      found = true;
//    else
//      println("CarLane::getNextNode() looking for: '" + c.x + ":" + c.y + "'");
    for(Vector2 v : nodes) {
      if(found == true) {
//        if(c != null)
//          println("CarLane::getNextNode() returning: '" + v.x + ":" + v.y + "' current: '" + c.x + ":" + c.y + "'");
//        else
//          println("CarLane::getNextNode() returning: '" + v.x + ":" + v.y + "' current: null");
        return v;
      }
      if(v.x == c.x && v.y == c.y) {
        Vector2 last = nodes.get(nodes.size()-1);
        if(last.x == v.x && last.y == v.y)
          return null;
        else
          found = true;
      }
    }
    return null;
  }  
  
  public Vector2 getFirstPoint() {
    if(nodes.size() > 0)
      return nodes.get(0);
    return null;
  }
}

public class UpCurvedLane extends CarLane
{ 
  final Vector2 crossSize = new Vector2(100, 100);
  final Vector2 approachLen = new Vector2(200, 0);
  final Vector2 exitLen = new Vector2(0, 140);
  Vector2 mid = new Vector2(0, 0);
  
  UpCurvedLane(Vector2 start, Vector2 end) {
    super(start, end);
  }
    
  public void generate() {
    //println("UpCurvedLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
        
    Vector2 cur = new Vector2(start.x, start.y);  
    for(float x = cur.x; x <= approachLen.x+start.x; x+=4) {
      cur.x = x;
      nodes.add(new Vector2(x, cur.y));
     // println("UpCurvedLane::generate() adding element, x++-approach '" + x + ":" + y + "'");      
    }
    
    float angle;
    final int radius = 100;
    float startx = cur.x;
    float starty = cur.y - radius;;
    mid.x = startx;
    mid.y = starty;
    
    for(int i = 88; i >= 2; i-=2) {
      float x, y;
      angle = i;
      x = startx+cos(radians(angle))*radius;
      y = starty+sin(radians(angle))*radius;
      nodes.add(new Vector2(x, y));
      //println("UpCurvedLane::generate() adding element, x++y++-approach '" + x + ":" + y + "'");
      cur.x = x;
      cur.y = y;
    }
   
    for(float y = cur.y+1; y >= cur.y-exitLen.y; y-=4) {
      nodes.add(new Vector2(cur.x, y));
      //println("UpCurvedLane::generate() adding element, y++-approach '" + cur.x + ":" + y + "'");
    }
  }
}

public class DownCurvedLane extends CarLane
{ 
  final Vector2 crossSize = new Vector2(100, 100);
  final Vector2 approachLen = new Vector2(200, 0);
  final Vector2 exitLen = new Vector2(0, 140);
  Vector2 mid = new Vector2(0, 0);
  
  DownCurvedLane(Vector2 start, Vector2 end) {
    super(start, end);
  }
  
  public void generate() {
    //println("DownCurvedLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
        
    Vector2 cur = new Vector2(start.x, start.y);
    for(float x = cur.x; x <= approachLen.x+start.x; x+=4) {
      cur.x = x;
      nodes.add(new Vector2(x, cur.y));
      //println("DownCurvedLane::generate() adding element, x++-approach '" + x + ":" + y + "'");      
    }
    
    float angle;
    final int radius = 100;
    float startx = cur.x;
    float starty = cur.y + radius;;
    mid.x = startx;
    mid.y = starty;
    
    for(int i = -88; i <= 2; i+=2) {
      int x, y;
      angle = i;
      x = round(startx+cos(radians(angle))*radius);
      y = round(starty+sin(radians(angle))*radius);
      nodes.add(new Vector2(x, y));
      //println("DownCurvedLane::generate() adding element, x++y++-approach '" + x + ":" + y + "'");
      cur.x = x;
      cur.y = y;
    }
   
    for(float y = cur.y+1; y <= cur.y+exitLen.y; y+=4) {
      nodes.add(new Vector2(cur.x, y));
      //println("DownCurvedLane::generate() adding element, y++-approach '" + cur.x + ":" + y + "'");
    }
  }
}
public class ControlMenu extends FrameContainer {
  Button curHighlightedButton;
  
  ControlMenu(int x, int y, int w, int h) {
    super(x, y, w, h);
  }
  
  public @Override
  void addElement(Frame f) {
    if(f instanceof MenuButton) {
      MenuButton mb = (MenuButton) f;
      mb.setParent(this);
    }
    super.addElement(f);
  }
  
  public void setCurActive(MenuButton b) {    
//    println("ControlMenu::setCurActive() label: " + b.label);
    if(curHighlightedButton != null)
      curHighlightedButton.resetColor();
    this.curHighlightedButton = b;
    b.fillColor = color(255, 140, 0);
  }
  
  public void setDefault(int i) {
    Frame f = elements.get(i);
    if(f != null && f instanceof MenuButton) {
      MenuButton m = (MenuButton)f;
      m.onClick(-1, -1);
    }
  }
}
public class Frame implements Clickable {
  float x, y, w, h;
  boolean bDisabled, deleteMe;
  
  Frame(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    app.registerDraw(this);
    bDisabled = false; 
  }
  
  public void draw() {
    strokeWeight(1);
    stroke(0);
    fill(255);
    rectMode(CORNER);
    rect(round(x), round(y), round(w), round(h));
  }
  
  public void onClick(float x, float y) {
    println("Frame::onClick()");
  }
  
  public float getX() {
    return this.x;
  }
  
  public float getY() {
    return this.y;
  }
  
  public float getW() {
    return this.w;
  }
  
  public float getH() {
    return this.h;
  }
}
public class FrameContainer extends Frame {
  ArrayList<Frame> elements;
  
  FrameContainer(int x, int y, int w, int h) {
    super(x, y, w, h);
    elements = new ArrayList<Frame>();
  }
  
  public void draw() {
    super.draw();
    pushMatrix();
    translate(x, y);
    Iterator it = elements.iterator();
    while(it.hasNext()) {
      Frame f = (Frame)it.next();
      if(f.deleteMe) {
        it.remove();
        continue;
      }
      f.draw();
    }
    popMatrix();
  }
  
  public void addElement(Frame f) {
    elements.add(f);
    app.unregisterDraw(f);
  }
  
  public void doResize() {
    float maxHeight = 0;
    float maxWide = 0;
    for(Frame e : elements) {
      if(e.h+e.y > maxHeight)
        maxHeight = e.h+e.y;
      if(e.w+e.x > maxWide)
        maxWide = e.w+e.x;
    }
    h = maxHeight+10;
    w = maxWide+10;
  }
  
  public void onClick(int x, int y) {
    //println("FrameContainer::onClick() x: " + x + " y: " + y);
    for(Frame f : elements) {
      if(f.bDisabled)
        continue;
      if(x > f.x && x < f.x+f.w && y > f.y && y < f.y+f.h) {
//        println("FrameContainer::onClick() forward!");
        f.onClick(x-this.x, y-this.y);   
      }
    }
  }
}

class Vector2 {
  float x, y;
  
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Vector2(Vector2 v) {
    this.x = v.x;
    this.y = v.y;
  }
}

interface Clickable {
  public void onClick(float x, float y);
  public float getX();
  public float getY();
  public float getW();
  public float getH(); 
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "carsim_main" });
  }
}
