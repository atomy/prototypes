Field f = null;
ArrayList<Ap> aps = new ArrayList<Ap>();
Stats stats = null;
Ap curAp = null;
int s_active_wlan_client = 0; 
int s_active_wlan_ap = 0;

void setup() {
  size(800,700);
  smooth();
  background(255);
  f = new Field(500, 500);
  f.generate(20);
  curAp = new Ap();
  stats = new Stats(520, 20, 250, 400);
}

void draw() {
  background(0);  
  f.draw();
  if(curAp != null)
    curAp.draw();
  for(Ap a : aps) {
    a.draw();
  }
  if(stats != null) {
    stats.draw();
  }
}

void mouseReleased() {
  if(curAp != null) {
    addNewAp(curAp);
  }
}

void addNewAp(Ap cur) {  
  curAp.deploy();
  aps.add(curAp);
  curAp = new Ap();
  s_active_wlan_ap++;
}

void mouseMoved() {
}

void keyReleased() {  
}

void tick() {  
}
