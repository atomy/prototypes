public class ControlMenu extends FrameContainer {
  Button curHighlightedButton;
  
  ControlMenu(int x, int y, int w, int h) {
    super(x, y, w, h);
  }
  
  @Override
  void addElement(Frame f) {
    if(f instanceof MenuButton) {
      MenuButton mb = (MenuButton) f;
      mb.setParent(this);
    }
    super.addElement(f);
  }
  
  void setCurActive(MenuButton b) {    
//    println("ControlMenu::setCurActive() label: " + b.label);
    if(curHighlightedButton != null)
      curHighlightedButton.resetColor();
    this.curHighlightedButton = b;
    b.fillColor = color(255, 140, 0);
  }
  
  void setDefault(int i) {
    Frame f = elements.get(i);
    if(f != null && f instanceof MenuButton) {
      MenuButton m = (MenuButton)f;
      m.onClick(-1, -1);
    }
  }
}
