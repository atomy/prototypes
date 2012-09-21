static int TICK_DELAY_FIELD = 1000;

class Field {
  int x, y;
  ArrayList<Client> clients = null;
  long lastTick = 0;
  
  Field(int x, int y) {
    clients = new ArrayList<Client>();
    this.x = x;
    this.y = y;
  }
  
  void draw() {
    noFill();
    strokeWeight(2);
    stroke(0,0,255);
    rect(0, 0, x, y);
    for(Client c : clients) {
      if(c.markForRemoval) {       
        continue;
      }
      c.draw();
    }
    if(lastTick + TICK_DELAY_FIELD < millis()) {
      tick();
    }
  }
  
  void tick() {
    lastTick = millis();
    ArrayList<Client> newClients = new ArrayList<Client>();
    for(Client c : clients) {
      if(!c.markForRemoval)
        newClients.add(c);
      else
        s_active_wlan_client--;
    }
    clients = newClients;
  }
  
  void addClientAtCurMouse() {
    addClientAt(mouseX, mouseY);    
  }
  
  void addClientAt(int x, int y) {
    clients.add(new Client(x, y));
    s_active_wlan_client++;
  }
  
  void generate(int i) {
    for(int k = 0; k < i; k++) {
      randomSeed((minute()+hour()+second())*+millis()*k);
      int rx = round(random(0, x));
      int ry = round(random(0, y));
      addClientAt(rx, ry);
      //println("Field::generate() i: " + i + " x: " + rx + " y: " + ry);
    }
  }
}
