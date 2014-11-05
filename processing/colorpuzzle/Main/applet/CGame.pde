class CGame
{
  ArrayList<CGameArea> mDrawables;  
  
  CGame() 
  {
    mDrawables = new ArrayList<CGameArea>();
    CHeader h = new CHeader(0,0,width,100);
    CMainArea m = new CMainArea(0,100,width,500);
    CBottomArea b = new CBottomArea(0,600, width, 100);
    mDrawables.add(h);
    mDrawables.add(m);
    mDrawables.add(b);
  }
  
  void draw() 
  {
    for(int i = 0; i < mDrawables.size(); i++) 
    {
      CGameArea d = (CGameArea)mDrawables.get(i);
      d.draw();
    }    
  }
  
  void mousePressed() {
    for(int i = 0; i < mDrawables.size(); i++) 
    {
      CGameArea d = (CGameArea)mDrawables.get(i);
      if(IsPointInElementsArea(d, mouseX, mouseY))
        d.mousePressed();
    }     
  } 
}

