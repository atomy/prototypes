class Stats {
  int x, y, w, h;
  PFont font;
  
  Stats(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    font = loadFont("ArialMT-18.vlw"); 
    textFont(font);
  }
  
  void draw() {
    stroke(255);
    strokeWeight(4);
    noFill();
    rect(x, y, w, h);
    stroke(0);
    fill(255);
    text("active wlan clients:", x+10, y+50);
    text(s_active_wlan_client, x+200, y+50);
    text("active wlan aps:", x+10, y+100);
    text(s_active_wlan_ap, x+200, y+100);    
  }
}
