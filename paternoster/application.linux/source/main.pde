import ddf.minim.*;

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

void setup() {  	
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

void draw() {
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

void mouseDragged() {
}

void mouseReleased() {
  for(MouseEvent me : mouseEventListeners) {
    me.mouseReleased();
  }
}

void mousePressed() {
  for(MouseEvent me : mouseEventListeners) {
    me.mousePressed();
  }  
}

void keyReleased() {
  for(MouseEvent me : mouseEventListeners) {
    me.keyReleased();
  }  
}

void tick(float delta) {
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
  
  boolean Touches(BoundingBox r) {
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

Entity GetEntityAt(float x, float y) {
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

void RemoveEntity(Entity delEnt) {
  for(Entity ent : mEntities) {
    if(ent == delEnt) {
      ent.markAsDeleted = true;
    }
  }
}

void EntRefresh() {
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
  void mouseReleased();  
  void mousePressed();
  void keyReleased();
}
