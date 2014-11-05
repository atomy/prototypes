class CGETopLeft extends CGameElement { 
  CGETopLeft(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0,-1));
    inout.add(new Vector2D(1,0));
  }
  
  void draw() {
    super.draw();   
  }
  
  CGameElement copy() {    
    return new CGETopLeft(x, y);
  }   
}

class CGETopRight extends CGameElement { 
  CGETopRight(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0,-1));
    inout.add(new Vector2D(-1,0));
  }
  
  void draw() {
    super.draw();   
  }
  
  CGameElement copy() {    
    return new CGETopRight(x, y);
  }   
}

class CGEVertical extends CGameElement {
  CGEVertical(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0, -1));
    inout.add(new Vector2D(0, 1));    
  }
  
  void draw() {
    super.draw();
  }
  
  CGameElement copy() {    
    return new CGEVertical(x, y);
  }   
}

class CGEHorziontal extends CGameElement { 
  CGEHorziontal(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(1,0));
    inout.add(new Vector2D(-1,0));
  }
  
  void draw() {
    super.draw();   
  }
  
  CGameElement copy() {    
    return new CGEHorziontal(x, y);
  }   
}

class CGERightDown extends CGameElement { 
  CGERightDown(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(1,0));
    inout.add(new Vector2D(0,1));
  }
  
  void draw() {
    super.draw();   
  }
  
  CGameElement copy() {    
    return new CGERightDown(x, y);
  }  
}

class CGELeftDown extends CGameElement { 
  CGELeftDown(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(-1,0));
    inout.add(new Vector2D(0,1));
  }
  
  void draw() {
    super.draw();   
  }
  
  CGameElement copy() {    
    return new CGELeftDown(x, y);
  }
}
