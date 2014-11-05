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

float lastTick;
ArrayList<ColorLine> lines;
ArrayList<FarbTopf> farbToepfe;
ArrayList<Point> junctionPoints;
ColorLine curLine;
ColorLine lastLine;
Storage store;
PFont dbgFont = createFont("ArialMT", 10);
boolean enableDebug = false;

public void setup() {
  size(800,600);
  smooth();
  background(0);
  lastTick = System.currentTimeMillis();
  lines = new ArrayList<ColorLine>();
  farbToepfe = new ArrayList<FarbTopf>();
  junctionPoints = new ArrayList<Point>();
  curLine = null;
  lastLine = null;
  farbToepfe.add(new FarbTopf(color(255,0,0),new Point(20,20)));
  farbToepfe.add(new FarbTopf(color(0,255,0),new Point(200,20)));
  farbToepfe.add(new FarbTopf(color(0,0,255),new Point(100,100))); 
  store = new Storage(new Point(350,500));
}

public void draw() {
  background(0);
  tick(System.currentTimeMillis()-lastTick);
  lastTick = System.currentTimeMillis();  
  for(ColorLine clrLine : lines) {
    clrLine.draw();
  }  
  for(FarbTopf topf : farbToepfe) {
    topf.draw();
  }
  for(Point p : junctionPoints) {
    p.draw();
  }
  store.draw();
}

public void mouseDragged() {
  if(curLine != null) {
    curLine.AddPoint(mouseX, mouseY);
  }
}

public void mouseReleased() {
  if(curLine != null) {
    lastLine = curLine;
    curLine = null;
    // no junction, so we need to search for something to attach to or we gonna die
    if(!HandleLineJunctions(lastLine)) {
      // check if last point is near our storage
      if(store.CanPointAttach(lastLine.content.get(lastLine.content.size()-1))) {
        store.AddLine(lastLine);
        //println("adding line to store");
        lastLine.nextNodes.add(store);
      }
    }
    if(lastLine.nextNodes.size() <= 0) {
      //println("killed, no next nodes");
      lastLine.deleteMe = true;
      RemoveLine(lastLine);
    }
    RecalculateFlow();
  }  
}

public void mousePressed() {
  for(FarbTopf topf : farbToepfe) {
    if(topf.CanPointAttach(new Point(mouseX,mouseY))) {
      curLine = new ColorLine();
      curLine.prevNodes.add(topf);
      curLine.clr = topf.clr;
      curLine.AddPoint(mouseX, mouseY);
      topf.AddLine(curLine);
      lines.add(curLine);
    }
  }  
}

public void RemoveLine(ColorLine clrLine) {
  //println("removed line: '" + clrLine.toString());  
//  Node delNode = (Node)clrLine;
  for(Node xNode : farbToepfe)
    xNode.RemoveNodeRelation(clrLine);
  for(Node xNode : lines)
    xNode.RemoveNodeRelation(clrLine); 
  store.RemoveNodeRelation(clrLine); 
  lines.remove(clrLine);
//  for(Node n : store.prevNodes) {
//    println("store has prevnode '" + n.toString() + "'");
//  }  
}

public void keyReleased() {
}

public void tick(float delta) {
}


// return, junction handled?
public boolean HandleLineJunctions(ColorLine checkLine) {
  // 2 lines t max can be affected by branching  
  ColorLine line1, line2;
  line1 = line2 = null;
  line1 = checkLine;
  Point junctionPoint = null;
  ArrayList<Point> ignorePoints = new ArrayList<Point>();
  // check every point of the given line against our current lines on the playfield
  for(Point checkPoint : checkLine.content) {
   for(ColorLine clrLine : lines) {
     if(clrLine == checkLine)
       continue;
     for(Point clrPoint : clrLine.content) {
       boolean skip = false;
       // skip already found areas
       for(Point iPoint : ignorePoints) {
         if(iPoint.IsNearPoint(clrPoint))
           skip = true;
       }
       // skip farbt\u00f6pfe
       for(FarbTopf topf : farbToepfe) {
         if(topf.CanPointAttach(clrPoint))
           skip = true;
       }      
       // skip storage 
       if(store.CanPointAttach(clrPoint))
         skip = true;
       if(skip)
         continue;
       // touch\u00e9!
       if(clrPoint.Touches(checkPoint)) {
         if(line2 != null) { // multiple junctions found, rewind and kill the invalid new line
           //println("multiple junctions!");
           RemoveLine(checkLine);
           return true;
         }
         line2 = clrLine;
         junctionPoint = clrPoint;
         ignorePoints.add(clrPoint); // ignore point for further runs, since we are checking a range and dont wanna hit it again
       }
     }
   } 
  }
  
  // junction found, handle it
  if(line2 != null) {
    HandleJunction(line1, line2, junctionPoint);
  } 
 //else {
 //   println("no junction found!");
 // }
  return false;
}

// split lines, line1 wont keep its tail
public void HandleJunction(ColorLine l1, ColorLine l2, Point jPoint) {
  ColorLine newL1 = l1.copy();  
  ColorLine newL2a = l2.copy();
  ColorLine newL2b = l2.copy();
  
  newL1.content.clear();
  newL2a.content.clear();
  newL2b.content.clear();
  newL2b.prevNodes.clear();
  newL2a.nextNodes.clear();
  
  newL1.CopyAndUpdatePrevNodes(l1);
  newL2a.CopyAndUpdatePrevNodes(l2);
  newL2b.CopyAndUpdateNextNodes(l2); // this lines breaks shit!
  newL1.nextNodes.add(newL2b);
  newL2a.nextNodes.add(newL2b);
  newL2b.prevNodes.add(newL1);
  newL2b.prevNodes.add(newL2a);
  
  for(Point pl1 : l1.content) {
    if(pl1.Touches(jPoint))
      break;
    newL1.AddPoint(pl1);
  }  
  
  boolean fillA = true;
  for(Point pl2 : l2.content) {
    if(pl2.Touches(jPoint))
      fillA = false;
    if(fillA)
      newL2a.AddPoint(pl2);
    else
      newL2b.AddPoint(pl2);
  }  
  
//  println("removing lines, l1: '" + l1.toString() + "' l2: '" + l2.toString());
  RemoveLine(l1);
  RemoveLine(l2);  
  lines.add(newL1);
  lines.add(newL2a);
  lines.add(newL2b);
//  println("new branches are, l1: '" + newL1.toString() + "' l2a: '" + newL2a.toString() + "' l2b: '" + newL2b.toString());
  junctionPoints.add(jPoint);
}

public void RecalculateFlow() {
//  println("RecalculateFlow()");
  // reset flow
  for(ColorLine clrLine : lines) {
    clrLine.Reset();
  }  
//  println("store has now '" + store.prevNodes.size() + "' prevnodes");
  // recursively get flow
  for(Node prevNode : store.prevNodes) {
    ColorLine clrLine = (ColorLine)prevNode;     
    GetFlowOfLine(clrLine);
    GetColorOfLine(clrLine);
//    println("highest flow is now: " + clrLine.flow);
  }
}

public void GetFlowOfLine(ColorLine clrLine) {
  float flow = 0.0f;  
  for(Node prevNode : clrLine.prevNodes) {
    if(prevNode instanceof ColorLine) {
      ColorLine prevLine = (ColorLine)prevNode;
      GetFlowOfLine(prevLine);
      flow += prevLine.flow;
    }
    if(prevNode instanceof FarbTopf) {
      flow += clrLine.maxFlow;  
    }      
  }
  clrLine.flow = flow;
}

public void GetColorOfLine(ColorLine clrLine) {
  int clr = color(0,0,0);
  float flow = 0.0f;  
  for(Node prevNode : clrLine.prevNodes) {
    if(prevNode instanceof ColorLine) {
      ColorLine prevLine = (ColorLine)prevNode;
      GetColorOfLine(prevLine);
      int newclr = blendColors(prevLine.clr, clr, prevLine.flow, flow);
      flow += prevLine.flow;
      clr = newclr;
    }
    if(prevNode instanceof FarbTopf) {
      FarbTopf topf = (FarbTopf)prevNode;
      clr = topf.clr;
      flow = clrLine.defaultFlow;
    }
  }
  clrLine.clr = clr;
}

public int blendColors(int c1, int c2, float c1flow, float c2flow) {
  if(c1flow <= 0)
    return c2;
  if(c2flow <= 0)
    return c1;
  
  // scale c1 so c2 is 1
  c1flow = c1flow / c2flow;
  c2flow = 1;  
  
  float r = ( red(c1)*(2*c1flow-1) + red(c2) ) / (2*c1flow);
  float g = ( green(c1)*(2*c1flow-1) + green(c2) ) / (2*c1flow);
  float b = ( blue(c1)*(2*c1flow-1) + blue(c2) ) / (2*c1flow);
  return color(r,g,b);
}

class Point {
  int x, y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public boolean Equals(Point p) {
    if(abs(p.x-this.x) <= 2 && abs(p.y-this.y) <= 2)
      return true;
    return false;
  }
  
  public boolean Touches(Point p) {
    if(abs(p.x-this.x) <= 1 && abs(p.y-this.y) <= 1)
      return true;
    return false;
  }  
  
  public boolean IsNearPoint(Point p) {
    if(abs(p.x-this.x) <= 2 && abs(p.y-this.y) <= 2)
      return true;
    return false;    
  }
  
  public void draw() {
    strokeWeight(10);
    stroke(255);
    point(x, y);
  }
}

class Node {
  int clr;
  boolean deleteMe;
  ArrayList<Node> nextNodes = new ArrayList<Node>();
  ArrayList<Node> prevNodes = new ArrayList<Node>();
  
  public void RemoveNodeRelation(Node delNode) {
//    println("OMGWTFBBQ: '" + delNode.toString() + "'");
    for(Node n : nextNodes) {
      if(n == delNode)
        n.deleteMe = true;
    }   
      
    for(Node n : prevNodes) {
//      println("if node '" + n.toString() + "' == '" + delNode.toString() + "'");
      if(n == delNode)        
        n.deleteMe = true;
    }
    
    ArrayList<Node> newNextNodes = new ArrayList<Node>();
    ArrayList<Node> newPrevNodes = new ArrayList<Node>();    
    for(Node n : nextNodes) {
      if(!n.deleteMe)
        newNextNodes.add(n);
    } 
    for(Node n : prevNodes) {
      if(!n.deleteMe)
        newPrevNodes.add(n);
    }    
    nextNodes = newNextNodes;
    prevNodes = newPrevNodes;
  }
  
  public void CopyAndUpdatePrevNodes(Node oldNode) {
    for(Node prev : oldNode.prevNodes) {
      prev.nextNodes.add(this);
    }
  }  
  
  public void CopyAndUpdateNextNodes(Node oldNode) {
    for(Node next : oldNode.nextNodes) {
      next.prevNodes.add(this);
    }    
  }
}
class ColorLine extends Node {
  ArrayList<Point> content = new ArrayList<Point>();
  boolean deleteMe;
  float flow;
  float maxFlow; // only matters for the first line after the origin
  float defaultFlow = 1.0f;
  
  ColorLine() {
    Reset();
  }
  
  public void Reset() {
    flow = defaultFlow;
    maxFlow = defaultFlow;    
  }
  
  public void AddPoint(int x, int y) {
    content.add(new Point(x, y));
  }
  
  public void AddPoint(Point p) {
    content.add(p);
  }
  
  public void draw() {
    strokeWeight(flow);
    noFill();
    stroke(255);   
    stroke(clr);
    beginShape();
    for(Point p : content) {
      vertex(p.x, p.y);
    }
    endShape();
    
    if(enableDebug)
      drawDebug();
  } 
   
  public void drawDebug() {
    Point mid = content.get(content.size() / 2);
    stroke(clr);
    fill(clr);
    textFont(dbgFont);
    int x = mid.x+10;
    int y = mid.y;
    text("ref: " + this.toString(), x, y);
    y+=10;
    text("flow: " + this.flow, x, y);
    y+=10;
    for(Node n : prevNodes) {
      text("prev: " + n.toString(), x, y);
      y+=10;      
    }
    for(Node n : nextNodes) {
      text("next: " + n.toString(), x, y);
      y+=10;
    }    
  }
   
  public ColorLine copy() {
    ColorLine newLine = new ColorLine();
    newLine.content = (ArrayList<Point>)content.clone();
    newLine.deleteMe = deleteMe;
    newLine.nextNodes = (ArrayList<Node>)nextNodes.clone();
    newLine.prevNodes = (ArrayList<Node>)prevNodes.clone();
    newLine.clr = clr;
    return newLine;
  }
}
class FarbTopf extends Node {
  Point p;
  int sizeXY = 30;
  int safeDistance = 10;
  
  FarbTopf(int clr, Point p) {
    this.clr = clr;
    this.p = p;
  }
  
  public void AddLine(ColorLine line) {
    nextNodes.add(line);
  }
  
  public void draw() {
    noStroke();
    fill(clr);
    rect(p.x, p.y, sizeXY, sizeXY);
    
    if(enableDebug)
      drawDebug();
  }
  
  public void drawDebug() {
    Point mid = p;
    stroke(clr);
    fill(clr);
    textFont(dbgFont);
    int x = mid.x+sizeXY+10;
    int y = mid.y;
    text("ref: " + this.toString(), x, y);
    y+=10;
    for(Node n : prevNodes) {
      text("prev: " + n.toString(), x, y);
      y+=10;      
    }
    for(Node n : nextNodes) {
      text("next: " + n.toString(), x, y);
      y+=10;
    }     
  }
  
  public boolean IsPointColliding(Point p) {
    if(p.x > this.p.x && p.x < this.p.x + sizeXY && p.y > this.p.y && p.y < this.p.y + sizeXY)
      return true;
    return false;
  }  
  
  public boolean CanPointAttach(Point p) {
    if(p.x > this.p.x - safeDistance && p.x < this.p.x + sizeXY + safeDistance && p.y > this.p.y - safeDistance && p.y < this.p.y + sizeXY + safeDistance)
      return true;
    return false;    
  }
}
class Storage extends Node {
  Point p;
  float fillprt;
  int clr = color(100,100,0);
  int sizeX = 100;
  int sizeY = 40;
  int safeDistance = 10;  
  
  Storage(Point p) {
    this.p = p;
    fillprt = 0.0f; // 0.0%
  }
  
  public void draw() {
    noStroke();
    fill(clr);
    rect(this.p.x, this.p.y, this.sizeX, this.sizeY);
    
    if(enableDebug)
      drawDebug();
  }
  
  public void drawDebug() {
    Point mid = p;
    stroke(clr);
    fill(clr);
    textFont(dbgFont);
    int x = mid.x+sizeX+10;
    int y = mid.y;
    text("ref: " + this.toString(), x, y);
    y+=10;
    for(Node n : prevNodes) {
      text("prev: " + n.toString(), x, y);
      y+=10;      
    }
    for(Node n : nextNodes) {
      text("next: " + n.toString(), x, y);
      y+=10;
    }     
  }
  
  public void AddLine(ColorLine clrLine) {
    prevNodes.add(clrLine);
  }
  
  public boolean CanPointAttach(Point p) {
    if(p.x > this.p.x - safeDistance && p.x < this.p.x + sizeX + safeDistance && p.y > this.p.y - safeDistance && p.y < this.p.y + sizeY + safeDistance)
      return true;
    return false;    
  }  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Main" });
  }
}
