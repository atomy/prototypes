public class TrafficLight extends Frame
{
  int state = 0;

  TrafficLight(float x, float y) {
    super(x, y, 60, 20);
    app.registerMethod("mouseEvent", this);
  }

  void draw() {
    noFill();
    stroke(0);
    rect(pos.x, pos.y, 80, 30);

    if (state == 0) {
      fill(0, 255, 0);  // green
      ellipse(pos.x+20*1+5, pos.y+15, 20, 20);   
      fill(255, 255, 0); //yellow    
      ellipse(pos.x+20*2+5, pos.y+15, 20, 20);
      fill(255, 0, 0);    // red
      ellipse(pos.x+20*3+5, pos.y+15, 20, 20);
    }
    
    if (state == 1) {
      fill(255);  // green
      ellipse(pos.x+20*1+5, pos.y+15, 20, 20);   
      fill(255); //yellow    
      ellipse(pos.x+20*2+5, pos.y+15, 20, 20);
      fill(255, 0, 0);    // red
      ellipse(pos.x+20*3+5, pos.y+15, 20, 20);
    }

    if (state == 2) {
      fill(255);  // green
      ellipse(pos.x+20*1+5, pos.y+15, 20, 20);   
      fill(255, 255, 0); //yellow    
      ellipse(pos.x+20*2+5, pos.y+15, 20, 20);
      fill(255);    // red
      ellipse(pos.x+20*3+5, pos.y+15, 20, 20);
    }
    
    if (state == 3) {
      fill(0, 255, 0);  // green
      ellipse(pos.x+20*1+5, pos.y+15, 20, 20);   
      fill(255); //yellow    
      ellipse(pos.x+20*2+5, pos.y+15, 20, 20);
      fill(255);    // red
      ellipse(pos.x+20*3+5, pos.y+15, 20, 20);
    }
    
    debugDraw();
  }

  public void mouseEvent(MouseEvent event) {
    if (event.getAction() == MouseEvent.RELEASE) {
      if (isWithin(new PVector(mouseX, mouseY))) {
        changeState();
      }
    }
  }

  void changeState() {
    state += 1;

    if (state >= 4) {
      state = 1;
    }
  }
}

