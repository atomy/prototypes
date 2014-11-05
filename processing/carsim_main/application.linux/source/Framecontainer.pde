public class FrameContainer extends Frame {
  ArrayList<Frame> elements;
  
  FrameContainer(int x, int y, int w, int h) {
    super(x, y, w, h);
    elements = new ArrayList<Frame>();
  }
  
  void draw() {
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
  
  void addElement(Frame f) {
    elements.add(f);
    app.unregisterDraw(f);
  }
  
  void doResize() {
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
  
  void onClick(int x, int y) {
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
