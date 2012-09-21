class CBottomArea extends CGameArea {
  CElementSelection mSelection;
  
  CBottomArea(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
    gElementSelection = new CElementSelection();
    gElementSelection.SetBounds(this.x, this.y, this.sizeX, this.sizeY);
    gElementSelection.AddElement(new CGEHorziontal(0,0));
    gElementSelection.AddElement(new CGEVertical(0,0));
    gElementSelection.AddElement(new CGETopLeft(0,0));
    gElementSelection.AddElement(new CGETopRight(0,0));    
    gElementSelection.AddElement(new CGELeftDown(0,0));
    gElementSelection.AddElement(new CGERightDown(0,0));   
  }
    
  void draw() {
    noFill();
    stroke(0,100,100);
    strokeWeight(4);
    rect(x, y, sizeX, sizeY);
    gElementSelection.draw();
  }
  
  void mousePressed() {
    //println("CBottomArea::mousePressed");
      if(IsPointInElementsArea(gElementSelection, mouseX, mouseY))
        gElementSelection.mousePressed();     
  }
}
