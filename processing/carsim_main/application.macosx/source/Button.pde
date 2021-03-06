public class MenuButton extends LabelButton {
  ControlMenu parent;
  
  MenuButton(float x, float y, float w, float h, String label) {
    super(x, y, w, h, label);  
  }
  
  void setParent(ControlMenu f) {
    this.parent = f;
  }
  
  void onClick(int x, int y) {
//    println("MenuButton::onClick()");
    parent.setCurActive(this);
  }
}

public class Button extends Frame { 
  color fillColor;
  color strokeColor;
  
  Button(float x, float y, float w, float h) {
    super(x, y, w, h); 
    resetColor();
  }
  
  void draw() {
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CORNER);
    rect(round(x), round(y), round(w), round(h));
  }
  
  @Override
  void onClick(float x, float y) {
    //println("Button::onClick()");
  }
  
  void resetColor() {
    strokeColor = color(0);
    fillColor = color(230);    
  }
  
  void setDisabled() {
    fillColor = color(255, 0, 0);
    bDisabled = true;
  }
  
  void setEnabled() {
    resetColor();
    bDisabled = false;
  }
}

public class LabelButton extends Button {
  String label;
  
  LabelButton(float x, float y, float w, float h, String label) {
    super(x, y, w, h);
    this.label = label;
  }
  
  void draw() {
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CORNER);
    rect(x, y, w, h);
    fill(0);
    textFont(font2);
    text(label, this.x+20, this.y+20);  
  }
  
  @Override
  void onClick(float x, float y) {
    //println("LabelButton::onClick()");
  }
}
