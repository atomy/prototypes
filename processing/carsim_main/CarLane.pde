public class CarLane extends Button
{
  public ArrayList<PVector> nodes;
  PVector end, start;

  CarLane(PVector start, PVector end) {
    super(start.x, start.y, 10, 10);
    this.start = start;
    this.end = end;    
    fillColor = color(0);
    strokeColor = color(255);
    nodes = new ArrayList<PVector>();
  }

  void generate() {
    if (start.y == end.y) {
      //println("CarLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
      for (float x = start.x; x <= end.x; x+=4) {
        nodes.add(new PVector(x, start.y));
      }
    } else if (start.x == end.x) {
      //println("CarLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");
      for (float y = start.y; y <= end.y; y+=4) {
        nodes.add(new PVector(start.x, y));
      }
    }
    //    for(PVector v : nodes) {
    //      println("CarLane::generate() printing content: '" + v.x + ":" + v.y + "'");
    //    }
  }

  void draw() {
    strokeWeight(1);
    stroke(strokeColor);
    fill(fillColor);
    //rect(x, y, w, h);
    fill(0);
    //println("CarLane::draw() drawing '" + nodes.size() + "' nodes");
    for (PVector v : nodes) {
      //    println("CarLane::draw() drawing node at '" + v.x + ":" + v.y + "'");
      noFill();
      stroke(color(120, 120, 0));
      rect(v.x, v.y, 1, 1);
    }
  }

  PVector getNextNode(PVector c) {    
    boolean found = false;

    if (c == null)
      found = true;
    //    else
    //      println("CarLane::getNextNode() looking for: '" + c.x + ":" + c.y + "'");
    for (PVector v : nodes) {
      if (found == true) {
        //        if(c != null)
        //          println("CarLane::getNextNode() returning: '" + v.x + ":" + v.y + "' current: '" + c.x + ":" + c.y + "'");
        //        else
        //          println("CarLane::getNextNode() returning: '" + v.x + ":" + v.y + "' current: null");
        return v;
      }

      if (v.x == c.x && v.y == c.y) {
        PVector last = nodes.get(nodes.size()-1);
        if (last.x == v.x && last.y == v.y)
          return null;
        else
          found = true;
      }
    }
    return null;
  }  

  PVector getFirstPoint() {
    if (nodes.size() > 0)
      return nodes.get(0);
    return null;
  }
}

public class UpCurvedLane extends CarLane
{ 
  final PVector crossSize = new PVector(100, 100);
  final PVector approachLen = new PVector(200, 0);
  final PVector exitLen = new PVector(0, 140);
  PVector mid = new PVector(0, 0);

  UpCurvedLane(PVector start, PVector end) {
    super(start, end);
  }

  void generate() {
    //println("UpCurvedLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");       
    PVector cur = new PVector(start.x, start.y);

    for (float x = cur.x; x <= approachLen.x+start.x; x+=4) {
      cur.x = x;
      nodes.add(new PVector(x, cur.y));
      // println("UpCurvedLane::generate() adding element, x++-approach '" + x + ":" + y + "'");
    }

    float angle;
    final int radius = 100;
    float startx = cur.x;
    float starty = cur.y - radius;
    mid.x = startx;
    mid.y = starty;

    for (float i = 88; i >= 2; i-=2) {
      float x, y;
      angle = i;
      x = startx+cos(radians(angle))*radius;
      y = starty+sin(radians(angle))*radius;
      nodes.add(new PVector(x, y));
      //println("UpCurvedLane::generate() adding element, x++y++-approach '" + x + ":" + y + "'");
      cur.x = x;
      cur.y = y;
    }

    for (float y = cur.y+1; y >= cur.y-exitLen.y; y-=4) {
      nodes.add(new PVector(cur.x, y));
      //println("UpCurvedLane::generate() adding element, y++-approach '" + cur.x + ":" + y + "'");
    }
  }
}

public class DownCurvedLane extends CarLane
{ 
  final PVector crossSize = new PVector(100, 100);
  final PVector approachLen = new PVector(200, 0);
  final PVector exitLen = new PVector(0, 140);
  PVector mid = new PVector(0, 0);

  DownCurvedLane(PVector start, PVector end) {
    super(start, end);
  }

  void generate() {
    //println("DownCurvedLane::generate() path from '" + start.x + ":" + start.y + "' '" + end.x + ":" + end.y + "'");

    PVector cur = new PVector(start.x, start.y);
    for (float x = cur.x; x <= approachLen.x+start.x; x+=4) {
      cur.x = x;
      nodes.add(new PVector(x, cur.y));
      //println("DownCurvedLane::generate() adding element, x++-approach '" + x + ":" + y + "'");
    }

    float angle;
    final int radius = 100;
    float startx = cur.x;
    float starty = cur.y + radius;
    ;
    mid.x = startx;
    mid.y = starty;

    for (int i = -88; i <= 2; i+=2) {
      int x, y;
      angle = i;
      x = round(startx+cos(radians(angle))*radius);
      y = round(starty+sin(radians(angle))*radius);
      nodes.add(new PVector(x, y));
      //println("DownCurvedLane::generate() adding element, x++y++-approach '" + x + ":" + y + "'");
      cur.x = x;
      cur.y = y;
    }

    for (float y = cur.y+1; y <= cur.y+exitLen.y; y+=4) {
      nodes.add(new PVector(cur.x, y));
      //println("DownCurvedLane::generate() adding element, y++-approach '" + cur.x + ":" + y + "'");
    }
  }
}

