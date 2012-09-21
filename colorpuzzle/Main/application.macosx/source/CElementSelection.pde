class CElementSelection extends CGameArea {
  ArrayList<CGameElement> mAvailElements;
  
  CElementSelection() {
    super(0,0,0,0);
    mAvailElements = new ArrayList<CGameElement>();
  }
  
  void SetBounds(int x, int y, int sizeX, int sizeY)
  {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  void draw() {
//    println("size: " + mAvailElements.size());
    for(CGameElement ele : mAvailElements) {
      ele.draw();
    }
  }
  
  void AddElement(CGameElement ele) {
    int i = mAvailElements.size();
    ele.SetBounds(x+20+(60*i), y+20, tileSize, tileSize);
    mAvailElements.add(ele);
  }  
  
  void mousePressed() {
    //println("CElementSelection::mousePressed");
    for(CGameElement ele : mAvailElements) {
      if(IsPointInElementsArea(ele, mouseX, mouseY))
        ele.mousePressed();
    }  
  }  
}
