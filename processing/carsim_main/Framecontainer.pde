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

    for (int i = 0; i < elements.size(); i++) {
      Frame f = (Frame) elements.get(i);
      f.setOffset(new PVector(x, y));

      if(f.deleteMe) {
        elements.remove(i);
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
    int maxHeight = 0;
    int maxWide = 0;
    for(Frame e : elements) {
      if(e.h+ (int)e.y > maxHeight)
        maxHeight = e.h+ (int)e.y;
      if(e.w+ (int)e.x > maxWide)
        maxWide = e.w+ (int)e.x;
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
        //f.onClick(x-this.x, y-this.y);   
      }
    }
  }
}
