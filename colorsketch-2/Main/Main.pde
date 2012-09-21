float lastTick;
ArrayList<ColorLine> lines;
ArrayList<FarbTopf> farbToepfe;
ArrayList<Point> junctionPoints;
ColorLine curLine;
ColorLine lastLine;

void setup() {
  size(800,600);
  smooth();
  background(0);
  lastTick = System.currentTimeMillis();
  lines = new ArrayList<ColorLine>();
  farbToepfe = new ArrayList<FarbTopf>();
  junctionPoints = new ArrayList<Point>();
  curLine = null;
  lastLine = null;
  farbToepfe.add(new FarbTopf(new Color(255,0,0),new Point(20,20)));
  farbToepfe.add(new FarbTopf(new Color(0,255,0),new Point(200,20)));
  farbToepfe.add(new FarbTopf(new Color(0,0,255),new Point(100,100)));
}

void draw() {
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
}

void mouseDragged() {
  if(curLine != null) {
    curLine.AddPoint(mouseX, mouseY);
  }
}

void mouseReleased() {   
  lastLine = curLine;
  curLine = null;
  connectLines();
}

void mousePressed() {
  curLine = new ColorLine();
  curLine.AddPoint(mouseX, mouseY);
  lines.add(curLine);
}

void keyReleased() {
}

void tick(float delta) {
}

void assignmentCheck(ColorLine clrLine) {
  if(clrLine.assigned)
    return;
  for(FarbTopf topf : farbToepfe) {
    if(topf.IsPointColliding(clrLine.content.get(0)) /*|| topf.IsPointColliding(clrLine.content.get(clrLine.content.size()-1))*/) { // check if the first and last point if its colliding
      clrLine.AssignToTopf(topf, true);
      topf.AssignToLine(clrLine, true);
    }
  }  
}

void connectLines() {
//  println("WHAT: " + System.currentTimeMillis());
  // check match with farbtopf
  for(ColorLine clrLine : lines) {
    assignmentCheck(clrLine);
  }    
  cleanUp();    
  // check if recent drawn line can be merged with existing
  ArrayList<Point> jPoints;
  ColorLine branch1 = new ColorLine();
  ColorLine branch2 = new ColorLine();
  for(ColorLine clrLine : lines) {
    if(!clrLine.assigned || clrLine == lastLine) {
//      println("skipping...");
      continue;
    }
    
    jPoints = clrLine.GetJunctionPoints(lastLine);
    
    // check for multiple junctions, if so, kill it
    if(jPoints.size() > 1) {
      lastLine.deleteMe = true;
      break;
    }
    
    if(jPoints.size() > 0) {
      junctionPoints.add(jPoints.get(0));
      lastLine.GetBranches(branch1, branch2, jPoints.get(0));
      assignmentCheck(branch1);
      branch1.endAssigned = true; // branch1 always has its end assigned
      assignmentCheck(branch2);
      lastLine.deleteMe = true;
      lines.add(branch1);
      lines.add(branch2);     
      cleanUp();
      break;
    }
  }    
  cleanUp();
}

void cleanUp() {
  // remove unassigned lines
  ArrayList<ColorLine> newLines = new ArrayList<ColorLine>();
  for(ColorLine clrLine : lines) {
    if(clrLine.assigned && !clrLine.deleteMe) {
      newLines.add(clrLine);
    }
  }
  lines = newLines;  
}

class Point {
  int x, y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  boolean Equals(Point p) {
    if(abs(p.x-this.x) <= 2 && abs(p.y-this.y) <= 2)
      return true;
    return false;
  }
  
  boolean IsPointNear(Point p) {
    if(abs(p.x-this.x) <= 5 && abs(p.y-this.y) <= 5)
      return true;
    return false;
  }  
  
  void draw() {
    strokeWeight(10);
    stroke(255);
    point(x, y);
  }
}

class Color {
  int r, g, b;
  Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}
