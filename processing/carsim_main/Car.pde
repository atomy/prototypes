public class Car extends Button {
  static final int sizeX = 25;
  static final int sizeY = 10;
  
  private long nextUpdate = 0;
  private PVector moveDir = new PVector(1,0);
  CarLane currentLane = null;
  PVector currentNode = null;
  float angle = 0;
  
  Car(CarLane lane) {
    super(lane.getFirstPoint().x, lane.getFirstPoint().y, sizeX, sizeY);
    fillColor = color(255, 0, 0);
    strokeColor = color(0, 0, 255);
    currentLane = lane;
  }
  
  void draw() {
    if(nextUpdate < millis()) {
      update();
      nextUpdate = millis() + 40;
    }
    strokeWeight(3);
    stroke(strokeColor);
    fill(fillColor);
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    rect(0, 0, w, h);
    popMatrix();
  }
  
  void updateMoveDir() {
    if(currentLane != null) {      
      PVector nextNode = currentLane.getNextNode(currentNode);
      if(nextNode == null) {
        currentLane = null;
        //println("Car::updateMoveDir() nextNode is 0!: '" + moveDir.x + ":" + moveDir.y + "'");
        return;
      }
      if(currentNode != null) {
        moveDir.x = nextNode.x - currentNode.x;
        moveDir.y = nextNode.y - currentNode.y;
      }
      currentNode = nextNode;
      if(moveDir.x == 0 && moveDir.y != 0) {
        if(moveDir.y > 0)
          angle = PI/2;
        else
          angle = -PI/2;
      } else {
        angle = atan(moveDir.y / moveDir.x);
      }
      //println("Car::updateMoveDir() nextNode is != 0!: '" + moveDir.x + ":" + moveDir.y + "' a: '" + angle + "'");
    } else {
      moveDir.x = moveDir.y = 0;
      deleteMe = true;
      //println("Car::updateMoveDir() setting to 0: '" + moveDir.x + ":" + moveDir.y + "'");
    }
  }
  
  void update() {
    updateMoveDir();
    pos.x += moveDir.x;
    pos.y += moveDir.y;
  }
}
