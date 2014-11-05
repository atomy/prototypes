import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 

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

public class paternoster extends PApplet {

class Paternoster
{
  Zahnrad r1, r2;
  Pfad p1;
  ArrayList<MountPoint> mPoints;
  int dummyTick;
  ArrayList<Laufband> mLaufbaender;  
  
  Paternoster() {
    r1 = new Zahnrad(this, new PVector(425, 104));
    r2 = new Zahnrad(this, new PVector(425, 457));
    mLaufbaender = new ArrayList<Laufband>();
    p1 = new Pfad(this);
    //dummy = p1.GetStartPoint();
    dummyTick = millis();
    mPoints = p1.CreatePointsAlongPath();
    //println("we have '" + mPoints.size() + "' points along the path!");
    Laufband b1 = new Laufband(this, new PVector(10, 400), new PVector(330, 10), true);
    Abspalter a1 = new Abspalter(new PVector(470, 300));
    Laufband b2 = new Laufband(this, new PVector(490, 320), new PVector(300, 10), false);
    b2.speed = 2.0f;
    mDrawables.add(a1);
    mLaufbaender.add(b1);
    mLaufbaender.add(b2);
  }
  
  public void draw() {
    noFill();
    stroke(255, 0, 0);
    r1.draw();
    r2.draw();      
    p1.draw();
    
    for(MountPoint mp : mPoints) {
      mp.draw();
    }
    for(Laufband b : mLaufbaender) {
      b.draw();
    }  
    //noStroke();
    //fill(255, 0, 0);
    //ellipse(dummy.x, dummy.y, 50, 50);
  }
  
  public void tick(float delta) {
    r1.tick(delta);
    r2.tick(delta);
    if(millis() - dummyTick >= 0) {
      //MoveDummy();
      for(MountPoint mp : mPoints) {
        mp.tick(delta);
      }      
      dummyTick = millis();
    }
  }
  
  /*
  void MoveDummy() {
    PVector next = p1.GetNextPoint(dummy);
    if(next != null)
      dummy = next;
  }
  */
  public MountPoint GetNearestMountPoint(PVector p) {    
    for(MountPoint mp : mPoints) {
      if(dist(mp.pos.x, mp.pos.y, p.x, p.y) < 100) {
        return mp;
      }
    }
    return null;
  }
}
class Abspalter extends Entity implements Drawable
{
  float lastTick;
  
  Abspalter(PVector pos) {
    super();
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.doesNotBlock = true;
    this.velo.x = 0;
    this.velo.y = 0;
    this.lastTick = millis();
  }
  
  public void draw() {
    fill(255, 0,0);
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-PI/4);
    rect(0,0,10,30);
    popMatrix();
  }
  
  public void tick(float delta) {
    super.tick(delta);
    if(millis() - lastTick < 100)
      return;
    CatchBlocksInRange(70);
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  public void CatchBlocksInRange(int range) {
    for(Entity ent : mEntities) {
      if(ent == this)
        continue;
      if(ent instanceof Wuerfel || ent instanceof Kugel || ent instanceof Mounter) {
        if(ent.attachedTo == null) {
          if(ent instanceof Wuerfel || ent instanceof Kugel)
            continue;
        }
        if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) < range) {
      //    MountPoint mp = (MountPoint)ent.attachedTo;
//          if(mp != null) {
  //          RemoveEntity(mp.mount);
    //        mp.mount = null;
//          }
          if(ent instanceof Mounter) {
            Mounter mn = (Mounter) ent;
            mn.mp.mount = null;
            RemoveEntity(ent);
            continue;
          }
          //else
          //  println("Abspalter::CatchBlocksInRange() cant detach mount-tool! (" + ent.attachedTo.toString() + ")");          
          ent.attachedTo.attachedEntity = null;
          ent.attachedTo = null;
          ent.doesNotBlock = false;
          ent.groundEntity = null;
          TeleportToLaufband(ent);
          break;
        }
      }
    }
  }
  
  public void TeleportToLaufband(Entity ent) {
    //println("TeleportToLaufband()");
    audio_object_disconnect.rewind();
    audio_object_disconnect.play();
    for(Entity e : mEntities) {
      if(e instanceof Laufband) {
        Laufband lb = (Laufband) e;
        if(lb.stop == null) {
          ent.pos.x = lb.pos.x + 20;
          ent.pos.y = lb.pos.y - 60;  
          ent.velo.y = 1.0f;
          break;
        }
      }
    }
  }
}
class Buymenu implements MouseEvent {
  PVector pos;
  PVector size;
  ArrayList<MenuItem> items;
  
  Buymenu() {
    items = new ArrayList<MenuItem>();
    MenuItem item1 = new MenuItem(this, new PVector(15, 15), "wuerfel");
    MenuItem item2 = new MenuItem(this, new PVector(100, 15), "kugel");
    items.add(item1);
    items.add(item2);
    pos = new PVector(100, 550);
    mouseEventListeners.add(this); 
    mouseEventListeners.add(item1);
    mouseEventListeners.add(item2);
  }
  
  public void draw() {
    stroke(0);
    noFill();
    rect(pos.x, pos.y, 550, 125);
    for(MenuItem item : items) {
      item.draw();
    }
  }
  
  public void mouseReleased() {      
  }
  
  public void mousePressed() {
  }
  
  public void keyReleased() {
  }
}

class MenuItem implements MouseEvent
{
  PVector pos;
  String text;
  Buymenu buy;
  
  MenuItem(Buymenu buy, PVector pos, String txt) {
    this.buy = buy;
    this.pos = pos;
    this.text = txt;
  }
  
  public void draw() {
    stroke(0);
    noFill();
    rect(buy.pos.x + pos.x, buy.pos.y + pos.y, 70, 95);    
    if(text == "kugel") {
      fill(200,100, 200);
      stroke(50,50,50);      
      ellipse(pos.x+35+buy.pos.x, pos.y+35+buy.pos.y, 50, 50);
      text("$ 30", buy.pos.x + pos.x + 20, buy.pos.y + pos.y + 80);
    } else if (text == "wuerfel") {
      fill(0,200,200);
      stroke(50,50,50);      
      rect(pos.x+10+buy.pos.x, pos.y+10+buy.pos.y, 50, 50);   
      text("$ 20", buy.pos.x + pos.x + 20, buy.pos.y + pos.y + 80); 
    }
  }
  
  public void mouseReleased() {
    if(mouseX <= buy.pos.x+pos.x+70 && mouseX >= pos.x+buy.pos.x && mouseY <= buy.pos.y+pos.y+70 && mouseY >= buy.pos.y+pos.y) {
//      println("MenuItem::mouseReleased()");
      MountPoint mp = patern.GetNearestMountPoint(supply.pos);
      if(mp == null || mp.mount != null) {
        audio_buy_fail.rewind();
        audio_buy_fail.play();
        //println("MenuItem::mouseReleased() unable to find valid mountpoint");
        return;
      }
      if(text == "wuerfel") {
        if(stats_money < 20) {
          audio_buy_fail.rewind();
          audio_buy_fail.play();
          return;
        }
        RectMounter m = new RectMounter(mp);  
        mDrawables.add(m);
        stats_money -= 20;
        audio_buy_success.rewind();
        audio_buy_success.play();
      } else if (text == "kugel") {
        if(stats_money < 30) {
          audio_buy_fail.rewind();
          audio_buy_fail.play();
          return;
        }
        KugelMounter m = new KugelMounter(mp);  
        mDrawables.add(m);        
        stats_money -= 30;
        audio_buy_success.rewind();
        audio_buy_success.play();
      }
    }
  }
  
  public void mousePressed() {
  }
  
  public void keyReleased() {
  }  
}
interface Drawable
{
  public void draw();
  public boolean IsMarkedAsDeleted();
}
class Kugel extends Entity implements Drawable
{
  
  Kugel(Spawner spawn, int size) {
    super();
    this.pos.x = spawn.pos.x;
    this.pos.y = spawn.pos.y;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = false;
  }
  
  public void draw() {
    rectMode(CORNER);
    fill(200,100, 200);
    stroke(50,50,50);
    pushMatrix();
    translate(pos.x+25, pos.y+25);
    rotate(pos.z);
    ellipse(0, 0, size.x, size.y);
    popMatrix();
  }
  
  public void tick(float delta) {
    super.tick(delta);
  }
  
  public BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
class Laufband extends Entity
{
  Paternoster patern;
  Stopper stop;
  float speed;
  
  Laufband(Paternoster patern, PVector pos, PVector size, boolean doBlocker) {
    super();
    this.pos = pos;
    this.size = size;
    this.patern = patern;
    speed = 1.0f;
  
    if(doBlocker)
      this.stop = new Stopper(this);
  }
  
  public void draw() {
    rectMode(CORNER);
    noStroke();
    noFill();
    stroke(100, 100, 100);
    fill(200, 0, 0);
    rect(pos.x, pos.y, size.x, size.y);
    if(stop != null)
      stop.draw();
  }
  
  public void tick(float delta) {
  }
  
  public BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }  
  public PVector GetConnectedEntVelo() {
    PVector p = new PVector();
    p.x = speed;
    p.y = 0.0f;
    return p;
  }  
}

class Stopper extends Entity {
  Stopper(Laufband b) {
    super();
    this.size.x = 10;
    this.size.y = 30;
    this.pos.x = b.pos.x;
    this.pos.y = b.pos.y;
    this.pos.x += b.size.x;
    this.pos.y -= 20;
    this.velo.x = 0;
    this.velo.y = 0;
  }
  
  public void draw() {
    stroke(50, 150, 0);
    fill(200, 0, 200);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
}
class MountPoint extends Entity
{
  Paternoster patern;
  PVector pos;
  float lastTick;
  Mounter mount;

  MountPoint(Paternoster p, float x, float y, float z) {
    this.patern = p;
    pos = new PVector(x, y, z);
    this.velo.x = 0;
    this.velo.y = 0;
    lastTick = millis();
  }

  public void draw() {
    fill(0, 255, 0);
    noStroke();
    ellipse(pos.x, pos.y, 20, 20);
  }

  public void tick(float delta) {
    super.tick(delta);    
    if(millis() - lastTick <= 10)
      return;    
    lastTick = millis();
    pos = patern.p1.GetNextPoint(pos);
    if(attachedEntity == null && mount != null) {
      AttachEntityInRange();
    } else if(attachedEntity != null) {
      attachedEntity.pos.x = pos.x-25;
      attachedEntity.pos.y = pos.y-25;
      attachedEntity.pos.z = pos.z;
      attachedEntity.doesNotBlock = true;
      attachedEntity.velo.x = 0;
      attachedEntity.velo.y = 0;
      attachedEntity.attachedTo = this;
    }
  }
  
  public void AttachEntityInRange() {
    for(Entity ent : mEntities) {
      if(ent == this)
        continue;
      if((ent instanceof Wuerfel && mount instanceof RectMounter)
       || ent instanceof Kugel && mount instanceof KugelMounter) {
        if(ent.attachedTo != null)
          continue;
        if(!IsValidPickUpEnt(ent))
          continue;        
        if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) < 100) {
          //println("AttachEntityInRange() attached ent!");
          attachedEntity = ent;
          audio_object_connect.rewind();
          audio_object_connect.play();
        }
      }
    }
  }
  
  public boolean IsValidPickUpEnt(Entity ent) {
    if(ent.groundEntity instanceof Laufband) {
      Laufband b = (Laufband)ent.groundEntity;
      if(b.stop != null)
        return true;
    }
    return false;
  }
}

class KugelMounter extends Mounter
{
  KugelMounter(MountPoint point) {
    super(point);
  }
  
  public void tick(float delta) {
    super.tick(delta);
  }
  
  public void draw() {
    noFill();
    stroke(0);
//    strokeWeight();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(mp.pos.z);
    ellipse(0, 0, 50, 50);
    popMatrix();
  }
}

class RectMounter extends Mounter
{
  RectMounter(MountPoint point) {
    super(point);
  }
  
  public void tick(float delta) {
    super.tick(delta);
  }
  
  public void draw() {
    noFill();
    stroke(0);
//    strokeWeight();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(mp.pos.z);
    line(25, -25, 25, 25); // A
    line(25, -25, -30, -25); // B
    line(25, 25, -30, 25); // C
    popMatrix();
  }
}

class Mounter extends Entity implements Drawable
{
  MountPoint mp;
  
  Mounter(MountPoint point) {
    super();
    this.mp = point;
    this.velo.x = 0;
    this.velo.y = 0;
    point.mount = this;
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  public void draw() {
  }
  
  public void tick(float delta) {
    super.tick(delta);
    this.pos.x = mp.pos.x;
    this.pos.y = mp.pos.y;
  }
}
class Pfad
{
  ArrayList<PVector> points; // z is angle
  Paternoster patern;
  
  Pfad(Paternoster p) {
    this.patern = p;
    points = new ArrayList<PVector>();
    Create();
  }
  
  public void Create() {
    for(float x = PI; x <= PI*2; x+=PI/64) {
      points.add(new PVector(420+cos(x)*40, 100+sin(x)*40, x+PI));
    }
    for(int i = 100; i <= 450; i +=2) {
      points.add(new PVector(460, i, PI));
    }     
    for(float x = 0; x <= PI; x+=PI/64) {
      points.add(new PVector(420+cos(x)*40, 450+sin(x)*40, x+PI));
    }
    for(int i = 450; i >= 100; i-=2) {
      points.add(new PVector(380, i, 0));
    }
  }
  
  public void draw() {
    noStroke();
    fill(0,0,255);
    for(PVector v : points) {
      rect(v.x, v.y, 10, 10);
    }
  }
  
  public void DumpPoints() {
    //println("DumpPoints() points are: ");
    for(int i = 0; i < 100; i++) {
      println("[" + i + "]" + "x: " + points.get(i).x + " y: " + points.get(i).y);
    }        
  }
  
  public ArrayList<MountPoint> CreatePointsAlongPath() {    
    ArrayList<MountPoint> mPoints = new ArrayList<MountPoint>();
    int i = 1;
    for(PVector v : points) {      
      if(i >= 50) {
        mPoints.add(new MountPoint(this.patern, v.x, v.y, v.z));
        i = 1;
      }
      i++;
    }
    return mPoints;
  }
  
  public PVector GetStartPoint() {
    //println("GetStartPoint() returning x: " + points.get(0).x + " y: " + points.get(0).y);
    return new PVector(points.get(0).x, points.get(0).y);
  }
  
  public PVector GetNextPoint(PVector d) {
    //println("GetNextPoint() asking for next point using x: " + d.x + " y: " + d.y);
    PVector p = null;
    boolean next = false;
    for(PVector v : points) {
      if(next) {
        if(d.x == v.x && d.y == v.y)
          continue;
        p = new PVector(v.x, v.y, v.z);
        //println("GetNextPoint() next flag set, bailing out...");
        break;
      }
      if(d.x == v.x && d.y == v.y) {
        //println("GetNextPoint() search point found, setting next flag...");
        next = true;
      }
    }
    if(p == null) {      
      p = GetStartPoint();
      //println("GetNextPoint() point is null, returning startpoint - x: " + p.x + " y: " + p.y);
    }
      
    //println("GetNextPoint() returning x: " + p.x + " y: " + p.y);
    return p;
  }
}
class Entity {
  PVector pos;
  PVector velo;
  PVector size;
  Entity groundEntity;
  boolean doesNotBlock;
  Entity attachedEntity;
  Entity attachedTo;
  boolean markAsDeleted;
  
  Entity() {
    doesNotBlock = false;
    mEntities.add(this);
    pos = new PVector(0,0);
    velo = new PVector(0, 1.0f);
    size = new PVector(1, 1);
  }
  
  public BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, new PVector(1,1));
  }  
  
  public void tick(float delta) {
//    println("Entity::tick()");
    if(groundEntity != null) {
      velo = groundEntity.GetConnectedEntVelo();
    }
    
    if(velo.x == 0 && velo.y == 0)
      return;
      
    // deny movement if we are going down and already have a groundEntity assigned
    if(velo.y > 0 && groundEntity != null) {
      return;
    }
    
    Entity blockingEnt = GetEntityAt(pos.x+size.x+velo.x, pos.y+size.y+velo.y);
    if(blockingEnt == null) {
      pos.x += velo.x;
      pos.y += velo.y;
    } else {
      if(groundEntity == null)
        groundEntity = blockingEnt;
      //println("Entity::tick() holy shit someone is at x: '" + (pos.x+velo.x+velo.y) + "' y: '" + (pos.y+velo.y+velo.y) + "'");
    }
  }
  
  public PVector GetConnectedEntVelo() {
    PVector p = new PVector();
    p.x = p.y = 0.0f;
    return p;
  }
}
class Rewarder extends Entity implements Drawable
{
  float lastTick;
  
  Rewarder(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    lastTick = millis();
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  public void draw() {
    noStroke();
    fill(0, 200, 0);
    rect(pos.x, pos.y, 10, 50);
  }
  
  public void tick(float delta) {
    if(millis() - lastTick <= 100) {
      return;
    }
    RewardObjectsInRange(100);
  }
  
  public void RewardObjectsInRange(float range) {
    for(Entity ent: mEntities) {
      if(ent == this)
        continue;
      if(ent.markAsDeleted)
        continue;
      if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) <= range) {
        RewardObject(ent);
      }      
    }
  }
  
  public void RewardObject(Entity ent) {
    audio_reward.rewind();
    audio_reward.play();
    if(ent instanceof Wuerfel) {
      stats_money += 30;
    }
    else if(ent instanceof Kugel) {
      stats_money += 40;
    } 
    RemoveEntity(ent);   
  }
}
class Spawner extends Entity implements Drawable
{
  boolean spawned = false;
  float lastTick;
  
  Spawner(PVector pos, int size) {
    super();
    this.pos = pos;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = true;
    this.velo.x = 0;
    this.velo.y = 0;
    this.lastTick = millis();
  }
  
  public void draw() {
    stroke(255,0,0);
    fill(100,100,0);
    rect(pos.x, pos.y, size.x, size.y);
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
  
  public void tick(float delta) {
    if(millis() - lastTick <= 500)
      return;
    lastTick = millis();
    super.tick(delta);
    if(!IsSpawnBlocked()/* && mousePressed && mouseButton == RIGHT*/) {
      Drawable obj;
      if(random(0,2) <= 1.0f)
        obj = new Kugel(this, 50);
      else {
        obj = new Wuerfel(this, 50);
      }
      mDrawables.add(obj);
      spawned = true;
    }    
  }
  
  public boolean IsSpawnBlocked() {
    if(GetEntityAt(pos.x, pos.y) == null && GetEntityAt(pos.x+50, pos.y) == null && GetEntityAt(pos.x, pos.y+50) == null && GetEntityAt(pos.x+50, pos.y+50) == null)
      return false;
    return true;
  }
}
class StatsPanel {
  PVector pos;
  ArrayList<StatsItem> items;
  
  StatsPanel() {
    items = new ArrayList<StatsItem>();
    StatsItem item1 = new StatsItem(this, new PVector(15, 5), "money");
    //StatsItem item2 = new StatsItem(this, new PVector(100, 15), "kugel");
    items.add(item1);
   // items.add(item2);
    pos = new PVector(525, 10);    
  }
  
  public void draw() {
    stroke(0);
    noFill();
    rect(pos.x, pos.y, 225, 150);
    for(StatsItem item : items) {
      item.draw();
    }
  }
}

class StatsItem
{
  PVector pos;
  String text;
  StatsPanel panel;
  
  StatsItem(StatsPanel panel, PVector pos, String txt) {
    this.panel = panel;
    this.pos = pos;
    this.text = txt;
  }
  
  public void draw() {
    stroke(0);
    noFill();
    if(text == "money") {
      fill(0);
      noStroke();
      String moneyString = "money:       $ " + stats_money;
      text(moneyString, pos.x+panel.pos.x, pos.y+panel.pos.y+20);
    } else if (text == "wuerfel") {
      fill(0,200,200);
      stroke(50,50,50);      
      rect(pos.x+10+panel.pos.x, pos.y+10+panel.pos.y, 50, 50);    
    }
  }
}
class ToolSupply extends Entity implements Drawable {
  ToolSupply(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.velo.x = 0;
    this.velo.y = 0;
  }
  
  public void draw() {
    stroke(100);
    fill(200);
    rect(pos.x, pos.y, 20, 20);
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
class Wuerfel extends Entity implements Drawable
{
  
  Wuerfel(Spawner spawn, int size) {
    super();
    this.pos.x = spawn.pos.x;
    this.pos.y = spawn.pos.y;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = false;
  }
  
  public void draw() {
    rectMode(CORNER);
    fill(0,200,200);
    stroke(50,50,50);
    pushMatrix();
    translate(pos.x+25, pos.y+25);
    rotate(pos.z);
    rect(-25, -25, size.x, size.y);
    popMatrix();
  }
  
  public void tick(float delta) {
    super.tick(delta);
    //println("Wuerfel::tick()");
  }
  
  public BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }
  
  public boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
class Zahnrad
{
  PVector pos;
  Paternoster patern;
  float angle;
  float lastTick;
  
  Zahnrad(Paternoster p, PVector pos) {
    this.patern = p;
    this.pos = pos;
    this.angle = 0.2f;
    this.lastTick = millis();
  }
  
  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(this.angle);  
    image(img_zahnrad, -52, -52,104, 104);
    popMatrix();    
  }
  
  public void tick(float delta) {
    if(millis() < lastTick + 10.0f)
      return;
    lastTick = millis();
    this.angle += PI/64;
    
    if(abs(this.angle) >= PI*2)
      this.angle = 0.0f;
  }
}


Minim minim;
AudioSnippet audio_reward;
AudioSnippet audio_buy_success;
AudioSnippet audio_buy_fail;
AudioSnippet audio_object_connect;
AudioSnippet audio_object_disconnect;

PImage img_zahnrad;
  
int lastTick;
Paternoster patern  = null;
ArrayList<Entity> mEntities;
ArrayList<Drawable> mDrawables;
Spawner s1;
Buymenu buy;
ToolSupply supply;
float lastEntRefresh;
ArrayList<MouseEvent> mouseEventListeners;
Rewarder rew;
StatsPanel stats;
PFont font;
int stats_money;

public void setup() {  	
  randomSeed(second());
  frameRate(60);
  size(800,700);
  smooth();
  background(0);
  mDrawables = new ArrayList<Drawable>();
  mEntities = new ArrayList<Entity>();
  mouseEventListeners = new ArrayList<MouseEvent>();
  lastTick = millis();
  patern = new Paternoster();   
  buy = new Buymenu();
  stats = new StatsPanel();
  s1 = new Spawner(new PVector(30, 340), 10);
  mDrawables.add(s1);
  supply = new ToolSupply(new PVector(410, 520));
  mDrawables.add(supply);
  lastEntRefresh = millis();
  rew = new Rewarder(new PVector(780, 270));
  mDrawables.add(rew);
  font = loadFont("ArialMT-12.vlw");
  textFont(font);
  stats_money = 300;
  
  minim = new Minim (this);
  
  audio_reward = minim.loadSnippet("reward.wav");
  audio_buy_success = minim.loadSnippet("buy_success.wav");
  audio_buy_fail = minim.loadSnippet("buy_fail.wav");
  audio_object_connect = minim.loadSnippet("object_connect.mp3");
  audio_object_disconnect = minim.loadSnippet("object_disconnect.wav");
  
  img_zahnrad = loadImage("zahnrad2.png");
}

public void draw() {
  background(255);
  if(millis() - lastTick > 100) {
    tick(millis()-lastTick);
  }
  for(Drawable d : mDrawables) {
    d.draw();
  }
  patern.draw();
  buy.draw();
  stats.draw();
}

public void mouseDragged() {
}

public void mouseReleased() {
  for(MouseEvent me : mouseEventListeners) {
    me.mouseReleased();
  }
}

public void mousePressed() {
  for(MouseEvent me : mouseEventListeners) {
    me.mousePressed();
  }  
}

public void keyReleased() {
  for(MouseEvent me : mouseEventListeners) {
    me.keyReleased();
  }  
}

public void tick(float delta) {
  patern.tick(delta);
  for(int i = 0; i < mEntities.size(); i++) {
    Entity ent = mEntities.get(i);
    ent.tick(delta);
  }
  if(millis() - lastEntRefresh > 300) {
    EntRefresh();
    lastEntRefresh = millis();
  }  
}

/*
void PhysSimul(float delta) {
  for(PhysObject p : mPhysObjects) {
    for(PhysObject t : mPhysObjects) {
      if(p == t)
        continue;
      else {
        println("PhysSimul()");
        DoPhysOnObjects(p, t);
      }
    }
  }
}


void DoPhysOnObjects(PhysObject o1, PhysObject o2) {
  Rectangle r1 = o1.GetBoundingBox();
  Rectangle r2 = o2.GetBoundingBox();
  if(!r1.Touches(r2)) {
    o1.DoMove();
    o2.DoMove();
  }
}
*/
class BoundingBox
{
  PVector pos;
  PVector size;
  
  BoundingBox(PVector pos, PVector size) {
    this.pos = pos;
    this.size = size;
  }
  
  public boolean Touches(BoundingBox r) {
    BoundingBox r1 = this;
    BoundingBox r2 = r;
    if(r2.pos.x >= r1.pos.x && r2.pos.y >= r1.pos.y && r2.pos.x <= r1.pos.x+r1.size.x && r2.pos.y <= r1.pos.x+r1.size.y) {
      return true;
    }
    r1 = r;
    r2 = this;
    if(r2.pos.x >= r1.pos.x && r2.pos.y >= r1.pos.y && r2.pos.x <= r1.pos.x+r1.size.x && r2.pos.y <= r1.pos.x+r1.size.y) {
      return true;
    }
    return false;
  }
}

public Entity GetEntityAt(float x, float y) {
  for(Entity ent : mEntities) {
    if(ent.doesNotBlock)
      continue;
    if(x >= ent.pos.x && y >= ent.pos.y && x <= ent.pos.x+ent.size.x && y <= ent.pos.y+ent.size.y) {
      //println("AnyoneAt() object with pos x: '" + ent.pos.x + "' y: '" + ent.pos.y + "' is here");
      return ent;
    }    
  }
  return null;
}

public void RemoveEntity(Entity delEnt) {
  for(Entity ent : mEntities) {
    if(ent == delEnt) {
      ent.markAsDeleted = true;
    }
  }
}

public void EntRefresh() {
  ArrayList<Entity> newEnts = new ArrayList<Entity>();
  for(Entity ent : mEntities) {
    if(!ent.markAsDeleted) {
      newEnts.add(ent);
    }
  }
  mEntities = newEnts;
  ArrayList<Drawable> newDrawables = new ArrayList<Drawable>();
  for(Drawable d : mDrawables) {
    if(!d.IsMarkedAsDeleted()) {
      newDrawables.add(d);
    }
  }  
  mDrawables = newDrawables;
}

interface MouseEvent {
  public void mouseReleased();  
  public void mousePressed();
  public void keyReleased();
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "paternoster" });
  }
}
