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

public class Main extends PApplet {

Field f = null;
ArrayList<Ap> aps = new ArrayList<Ap>();
Stats stats = null;
Ap curAp = null;
int s_active_wlan_client = 0; 
int s_active_wlan_ap = 0;

public void setup() {
  size(800,700);
  smooth();
  background(255);
  f = new Field(500, 500);
  f.generate(20);
  curAp = new Ap();
  stats = new Stats(520, 20, 250, 400);
}

public void draw() {
  background(0);  
  f.draw();
  if(curAp != null)
    curAp.draw();
  for(Ap a : aps) {
    a.draw();
  }
  if(stats != null) {
    stats.draw();
  }
}

public void mouseReleased() {
  if(curAp != null) {
    addNewAp(curAp);
  }
}

public void addNewAp(Ap cur) {  
  curAp.deploy();
  aps.add(curAp);
  curAp = new Ap();
  s_active_wlan_ap++;
}

public void mouseMoved() {
}

public void keyReleased() {  
}

public void tick() {  
}
static int AP_RADIUS = 100;
static int AP_ANIM_TIME = 100;

class Ap {
  boolean attached = true;
  int x, y;
  float animState = 0;
  long nextAnimTime = 0;
  
  public void draw() {
    noFill();
    strokeWeight(4);
    stroke(200, 200, 200);
    ellipseMode(CENTER);
    if(attached)
      ellipse(mouseX, mouseY, AP_RADIUS, AP_RADIUS);
    else
      ellipse(x, y, AP_RADIUS, AP_RADIUS);
      
    if(!attached && nextAnimTime < millis()) {
      nextAnimTime = AP_ANIM_TIME + millis();
      animState+=0.1f;
      strokeWeight(1);
      int rad = constrain((int)animState, 0,(int) AP_RADIUS);
      ellipse(x, y, rad, rad);
      if(animState >= 1.0f)
        animState = 0.0f;
    }
  }
  
  public void deploy() {
    this.x = mouseX;
    this.y = mouseY;
    this.attached = false;
    catchClients();
  }
  
  public void catchClients() {
    for(Client c : f.clients) {
      if(dist(c.x, c.y, this.x, this.y) < AP_RADIUS/2) {
        c.markForRemoval = true;       
        //println("catchClients() dist is: " + dist(c.x, c.y, this.x, this.y));
      }
    }
  }
}
class Client {
  float x, y;
  boolean markForRemoval = false;
  
  Client(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    fill(255,0,0);
    stroke(125, 200, 0);
    strokeWeight(4);
    ellipseMode(CENTER);
    ellipse(x, y, 20, 20);
  }
}
static int TICK_DELAY_FIELD = 1000;

class Field {
  int x, y;
  ArrayList<Client> clients = null;
  long lastTick = 0;
  
  Field(int x, int y) {
    clients = new ArrayList<Client>();
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    noFill();
    strokeWeight(2);
    stroke(0,0,255);
    rect(0, 0, x, y);
    for(Client c : clients) {
      if(c.markForRemoval) {       
        continue;
      }
      c.draw();
    }
    if(lastTick + TICK_DELAY_FIELD < millis()) {
      tick();
    }
  }
  
  public void tick() {
    lastTick = millis();
    ArrayList<Client> newClients = new ArrayList<Client>();
    for(Client c : clients) {
      if(!c.markForRemoval)
        newClients.add(c);
      else
        s_active_wlan_client--;
    }
    clients = newClients;
  }
  
  public void addClientAtCurMouse() {
    addClientAt(mouseX, mouseY);    
  }
  
  public void addClientAt(int x, int y) {
    clients.add(new Client(x, y));
    s_active_wlan_client++;
  }
  
  public void generate(int i) {
    for(int k = 0; k < i; k++) {
      randomSeed((minute()+hour()+second())*+millis()*k);
      int rx = round(random(0, x));
      int ry = round(random(0, y));
      addClientAt(rx, ry);
      //println("Field::generate() i: " + i + " x: " + rx + " y: " + ry);
    }
  }
}
class Stats {
  int x, y, w, h;
  PFont font;
  
  Stats(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    font = loadFont("ArialMT-18.vlw"); 
    textFont(font);
  }
  
  public void draw() {
    stroke(255);
    strokeWeight(4);
    noFill();
    rect(x, y, w, h);
    stroke(0);
    fill(255);
    text("active wlan clients:", x+10, y+50);
    text(s_active_wlan_client, x+200, y+50);
    text("active wlan aps:", x+10, y+100);
    text(s_active_wlan_ap, x+200, y+100);    
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Main" });
  }
}
