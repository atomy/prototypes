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

CGame gGame;
CElementSelection gElementSelection;
CGameElement gDragElement;

public void setup()
{
  size(800,700);
  smooth();
  background(0);
  gGame = new CGame();
  gDragElement = null;
}

public void draw()
{
  background(0);
  gGame.draw();
}

public void mousePressed()
{
  gGame.mousePressed();
}

public void mouseMoved() {
  if(gDragElement != null) {
    gDragElement.x = mouseX;
    gDragElement.y = mouseY;
  }
}

public void keyReleased()
{
  
}

public void tick()
{
  
}

class CGameArea {
  int x, y, sizeX, sizeY;
  
  CGameArea(int x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;    
  }
  
  public void draw() {
  }
  
  public void mousePressed() {
  }
}

public boolean IsPointInElementsArea(CGameArea area, int x, int y) {
    if(x > area.x && x < area.x+area.sizeX) {
      if(y > area.y && y < area.y+area.sizeY) {       
        return true;
      }
    }
    return false;
}
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
    
  public void draw() {
    noFill();
    stroke(0,100,100);
    strokeWeight(4);
    rect(x, y, sizeX, sizeY);
    gElementSelection.draw();
  }
  
  public void mousePressed() {
    //println("CBottomArea::mousePressed");
      if(IsPointInElementsArea(gElementSelection, mouseX, mouseY))
        gElementSelection.mousePressed();     
  }
}
class CElementSelection extends CGameArea {
  ArrayList<CGameElement> mAvailElements;
  
  CElementSelection() {
    super(0,0,0,0);
    mAvailElements = new ArrayList<CGameElement>();
  }
  
  public void SetBounds(int x, int y, int sizeX, int sizeY)
  {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  public void draw() {
//    println("size: " + mAvailElements.size());
    for(CGameElement ele : mAvailElements) {
      ele.draw();
    }
  }
  
  public void AddElement(CGameElement ele) {
    int i = mAvailElements.size();
    ele.SetBounds(x+20+(60*i), y+20, tileSize, tileSize);
    mAvailElements.add(ele);
  }  
  
  public void mousePressed() {
    //println("CElementSelection::mousePressed");
    for(CGameElement ele : mAvailElements) {
      if(IsPointInElementsArea(ele, mouseX, mouseY))
        ele.mousePressed();
    }  
  }  
}
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
  
  public void draw() 
  {
    for(int i = 0; i < mDrawables.size(); i++) 
    {
      CGameArea d = (CGameArea)mDrawables.get(i);
      d.draw();
    }    
  }
  
  public void mousePressed() {
    for(int i = 0; i < mDrawables.size(); i++) 
    {
      CGameArea d = (CGameArea)mDrawables.get(i);
      if(IsPointInElementsArea(d, mouseX, mouseY))
        d.mousePressed();
    }     
  } 
}

class CGameElement extends CGameArea {
  CGrid g;
  ArrayList<Vector2D> inout;
  int flowRate;  
  
  CGameElement(int x, int y) {
    super(x, y, tileSize, tileSize);
    inout = new ArrayList<Vector2D>();
    this.flowRate = 10;
  }
  
  public void SetFlowRate(int rate) {
    this.flowRate = rate;
  }
  
  public void SetBounds(int x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;    
  }
  
  public void draw() {
    if(this.x < 0 || this.y < 0)
      return;
    fill(100);
    stroke(0,0,255);
    strokeWeight(2);
    if(sizeX <= 0 || sizeY <= 0)
      rect(x, y, tileSize, tileSize);
    else
      rect(x, y, this.sizeX, this.sizeY);

    noStroke();
    fill(255);
    int midX = this.x+this.sizeX/2;
    int midY = this.y+this.sizeY/2;
    int midPointSizeX = this.sizeX/8*this.flowRate;
    int midPointSizeY = this.sizeY/8*this.flowRate;
    //rect(midX-midPointSizeX/2, midY-midPointSizeY/2, midPointSizeX, midPointSizeY);
    
    for(Vector2D vecInOut : inout) {
      Vector2D vecDefaultSize = new Vector2D(midPointSizeX,midPointSizeY);
      Vector2D vecToDraw = vecInOut.mult(this.sizeX/2);
      strokeWeight(this.flowRate);
      stroke(255);
      line(midX, midY, midX+vecToDraw.x, midY+vecToDraw.y);
      //println("line("+midX+", "+midY+", "+(midX+vecToDraw.x)+", "+(midY+vecToDraw.y)+")");
    }
  }
  
  public void mousePressed() {
    if(gDragElement == null) {
      gDragElement = this.copy();
      gGame.mDrawables.add(gDragElement);
    }
  }
  
  public CGameElement copy() {
    return null;
  }
}
static int tileSize = 32;

class CGrid extends CGameArea {
  int rows, cols;
  CGridElement[][] mGrid;  
  
  CGrid(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
    this.cols = sizeX / tileSize;    
    this.rows = sizeY / tileSize;
    this.rows = rows;
    this.cols = cols;
    mGrid = new CGridElement[cols][rows];    
    
    for(int ix = 0; ix < cols; ix++) {     
      for(int iy = 0; iy < rows; iy++) {
        mGrid[ix][iy] = new CGridElement(this, this.x + ix*tileSize, this.y + iy*tileSize);
      }
    }
  }
  
  public void draw() {
    for(int x = 0; x < cols; x++) {
      for(int y = 0; y < rows; y++) {
        mGrid[x][y].draw();
      }
    }
    noFill();
    stroke(255,0,0);
    strokeWeight(4);
    rect(this.x, this.y, this.sizeX, this.sizeY);    
  }
  
  // TODO
  public boolean SnapToGrid() {
    if(gDragElement != null) {
      for(int ix = 0; ix < cols; ix++) {     
        for(int iy = 0; iy < rows; iy++) {
          CGridElement ele = mGrid[ix][iy];
        }
      }      
    }
    return true;
  }
}
class CGridElement extends CGameArea {
  CGrid grid;
  
  CGridElement(CGrid g, int x, int y) {
    super(x, y, tileSize, tileSize);
    this.grid = g;
  }
  
  public void draw() {
    fill(100);
    stroke(0,0,255);
    strokeWeight(2);
    rect(this.x, this.y, tileSize, tileSize);
  }
}
class CHeader extends CGameArea
{
  int x, y, sizeX, sizeY;
  
  CHeader(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
  }
  
  public void draw()
  {
    noFill();
    stroke(255,0,0);
    strokeWeight(1);
    rect(x, y, sizeX, sizeY);
  }
  
  public void mousePressed() {
    //println("CHeader::mousePressed");
  }
}
class CMainArea extends CGameArea {
  CGrid mGrid;
  CStartPoint mStartPoint;
  
  CMainArea(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
    mGrid = new CGrid(this.x+64, this.y+64, 672, 384);
    mStartPoint = new CStartPoint(this.x+tileSize/2, this.y+tileSize*4);    
  }
    
  public void draw() {
    noFill();
    stroke(0,255,0);
    strokeWeight(4);
    rect(x, y, sizeX, sizeY);
    mGrid.draw();
    mStartPoint.draw();        
  }
  
  public void mousePressed() {
    //println("CMainArea::mousePressed");
  }
}

class CStartPoint extends CGameArea {  
  CStartPoint(int x, int y) {
    super(x, y, 30, 100);   
  }
  
  public void draw() {
    fill(0, 255, 0);
    stroke(200,100,200);
    rect(this.x, this.y, this.sizeX, this.sizeY);
    stroke(255);
    strokeWeight(10);
    noFill();
    line(this.x+tileSize/2, this.y+tileSize*3+tileSize/2, this.x+tileSize/2+tileSize, this.y+tileSize*3+tileSize/2);
    line(this.x+tileSize/2, this.y+tileSize*3+tileSize/2, this.x+tileSize/2, this.y+tileSize*3);
  }
}
class CGETopLeft extends CGameElement { 
  CGETopLeft(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0,-1));
    inout.add(new Vector2D(1,0));
  }
  
  public void draw() {
    super.draw();   
  }
  
  public CGameElement copy() {    
    return new CGETopLeft(x, y);
  }   
}

class CGETopRight extends CGameElement { 
  CGETopRight(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0,-1));
    inout.add(new Vector2D(-1,0));
  }
  
  public void draw() {
    super.draw();   
  }
  
  public CGameElement copy() {    
    return new CGETopRight(x, y);
  }   
}

class CGEVertical extends CGameElement {
  CGEVertical(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(0, -1));
    inout.add(new Vector2D(0, 1));    
  }
  
  public void draw() {
    super.draw();
  }
  
  public CGameElement copy() {    
    return new CGEVertical(x, y);
  }   
}

class CGEHorziontal extends CGameElement { 
  CGEHorziontal(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(1,0));
    inout.add(new Vector2D(-1,0));
  }
  
  public void draw() {
    super.draw();   
  }
  
  public CGameElement copy() {    
    return new CGEHorziontal(x, y);
  }   
}

class CGERightDown extends CGameElement { 
  CGERightDown(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(1,0));
    inout.add(new Vector2D(0,1));
  }
  
  public void draw() {
    super.draw();   
  }
  
  public CGameElement copy() {    
    return new CGERightDown(x, y);
  }  
}

class CGELeftDown extends CGameElement { 
  CGELeftDown(int x, int y) {
    super(x, y);
    inout.add(new Vector2D(-1,0));
    inout.add(new Vector2D(0,1));
  }
  
  public void draw() {
    super.draw();   
  }
  
  public CGameElement copy() {    
    return new CGELeftDown(x, y);
  }
}
class Vector2D
{
  int x, y;
  
  Vector2D(int x, int y) { 
    this.x = x;
    this.y = y;
  }
  
  public Vector2D mult(Vector2D vec) {
    return new Vector2D(vec.x*this.x, vec.y*this.y);
  }
  
  public Vector2D mult(int scal) {
    return new Vector2D(scal*this.x, scal*this.y);
  }  
  
  public Vector2D add(Vector2D vec) {
    return new Vector2D(vec.x+this.x, vec.y+this.y);
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Main" });
  }
}
