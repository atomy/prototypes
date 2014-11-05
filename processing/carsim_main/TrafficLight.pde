public class TrafficLight extends Frame
{
  TrafficLight(float x, float y) {
    super(x, y, 60, 20);
    app.registerMethod("mouseEvent", this);
  }

  void draw() {
    noFill();
    stroke(0);
    rect(x, y, 80, 30);
    
    fill(0, 255, 0);  // green
    ellipse(x+20*1+5, y+15, 20, 20);   
    fill(255, 255, 0); //yellow    
    ellipse(x+20*2+5, y+15, 20, 20);
    fill(255, 0, 0);    // red

    ellipse(x+20*3+5, y+15, 20, 20);
    debugDraw();
  }
  
  public void mouseEvent(MouseEvent event) {
    if (event.getAction() == MouseEvent.RELEASE) {
      if (isWithin(new PVector(mouseX, mouseY))) {
        println("YUS" + mouseX + " " + mouseY);
      }
    }
  }
}
