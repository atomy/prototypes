float lastTick;
ArrayList<ColorLine> lines;
ArrayList<FarbTopf> farbToepfe;
ArrayList<Point> junctionPoints;
ColorLine curLine;
ColorLine lastLine;
Storage store;
PFont dbgFont;
boolean enableDebug = false;
float minDistance = 9999999999.0f;
boolean showTutorial = true;
PImage tutorialImage;

void setup() {
  fullScreen();
  //size(800,600);
  smooth();  
  lastTick = System.currentTimeMillis();
  lines = new ArrayList<ColorLine>();
  farbToepfe = new ArrayList<FarbTopf>();
  junctionPoints = new ArrayList<Point>();
  curLine = null;
  lastLine = null;
  farbToepfe.add(new FarbTopf(color(255,0,0),new Point(width - width/3 + 50, height/5)));
  farbToepfe.add(new FarbTopf(color(0,255,0),new Point(width - width/3 - width/3 + 50, height/5)));
  farbToepfe.add(new FarbTopf(color(0,0,255),new Point(width - width/3 - width/3 - width/3 + 50, height/5))); 
  store = new Storage();
  dbgFont = createFont("ArialMT", 10);  
  tutorialImage = loadImage("colorio.howto.png");
}

void draw() {
  background(255);
  
  if (showTutorial) {
    image(tutorialImage, 0, 0);
    return;
  }
  
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

void mouseDragged() {
  if(curLine != null) {
    curLine.AddPoint(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (showTutorial) {
    showTutorial = false;
    return;
  }
  
  if(curLine != null) {
    lastLine = curLine;
    curLine = null;
    
    // no junction, so we need to search for something to attach to or we gonna die
    if(!HandleLineJunctions(lastLine)) {
      // check if last point is near our storage
      if(store.CanPointAttach(lastLine.content.get(lastLine.content.size()-1))) {
        store.AddLine(lastLine);
        store.addDebugText("prev line: " + lastLine);
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

void mousePressed() {
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

void RemoveLine(ColorLine clrLine) {
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

void keyReleased() {
}

void tick(float delta) {
}


// return, junction handled?
boolean HandleLineJunctions(ColorLine checkLine) {
  // 2 lines t max can be affected by branching  
  ColorLine line1, line2;
  line1 = line2 = null;
  line1 = checkLine;
  Point junctionPoint = null;
  ArrayList<Point> ignorePoints = new ArrayList<Point>();
  minDistance = 9999999.0f; // %TODO
  
  // check every point of the given line against our current lines on the playfield
  for(Point checkPoint : checkLine.content) {
   for(ColorLine clrLine : lines) {
     if(clrLine == checkLine) {
       continue;
     }
    
     for(Point clrPoint : clrLine.content) {
       boolean skip = false;
     
       // skip already found areas
       for(Point iPoint : ignorePoints) {
         if(iPoint.IsNearPoint(clrPoint))
           skip = true;
       }
       
       // skip farbtöpfe
       for(FarbTopf topf : farbToepfe) {
         if(topf.CanPointAttach(clrPoint)) {           
           skip = true;
         }
       }
       
       // skip storage 
       if(store.CanPointAttach(clrPoint)) {        
         skip = true;
       }
       
       if(skip) {
         continue;
       }
       
       // touché!
       if (clrPoint.Touches(checkPoint)) {
         if (line2 != null && false) { // multiple junctions found, rewind and kill the invalid new line
           if (enableDebug) {
             println("multiple junctions!");             
           }
           
           //RemoveLine(checkLine);
           return true;
         }
                  
         line2 = clrLine;
         junctionPoint = clrPoint;
         HandleJunction(line1, line2, junctionPoint);
         ignorePoints.add(clrPoint); // ignore point for further runs, since we are checking a range and dont wanna hit it again
         
         return true;
       }
     }
   }
   
   if (enableDebug) {
     println("not touching - as the closest we came is: " + minDistance);
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
void HandleJunction(ColorLine l1, ColorLine l2, Point jPoint) {
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

void RecalculateFlow() {
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
//    println("highest flow is now: " + clrLine.flow);
  }
  
  store.calcAndApplyColor();
}

void GetFlowOfLine(ColorLine clrLine) {
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

void GetColorOfLine(ColorLine clrLine) {
  color clr = color(0,0,0);
  float flow = 0.0f;  
  for(Node prevNode : clrLine.prevNodes) {
    if(prevNode instanceof ColorLine) {
      ColorLine prevLine = (ColorLine)prevNode;
      GetColorOfLine(prevLine);
      color newclr = blendColors(prevLine.clr, clr, prevLine.flow, flow);
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

color blendColors(color c1, color c2, float c1flow, float c2flow) {
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
