class Buymenu implements MouseEvent {
  PVector pos;
  PVector size;
  ArrayList<MenuItem> items;
  
  Buymenu() {
    items = new ArrayList<MenuItem>();
    MenuItem item1 = new MenuItem(this, new PVector(15, 15), "wuerfel");
    MenuItem item2 = new MenuItem(this, new PVector(100, 15), "kugel");
    items.add(item1);
    items.add(item2);
    pos = new PVector(100, 550);
    mouseEventListeners.add(this); 
    mouseEventListeners.add(item1);
    mouseEventListeners.add(item2);
  }
  
  void draw() {
    stroke(0);
    noFill();
    rect(pos.x, pos.y, 550, 125);
    for(MenuItem item : items) {
      item.draw();
    }
  }
  
  void mouseReleased() {      
  }
  
  void mousePressed() {
  }
  
  void keyReleased() {
  }
}

class MenuItem implements MouseEvent
{
  PVector pos;
  String text;
  Buymenu buy;
  
  MenuItem(Buymenu buy, PVector pos, String txt) {
    this.buy = buy;
    this.pos = pos;
    this.text = txt;
  }
  
  void draw() {
    stroke(0);
    noFill();
    rect(buy.pos.x + pos.x, buy.pos.y + pos.y, 70, 95);    
    if(text == "kugel") {
      fill(200,100, 200);
      stroke(50,50,50);      
      ellipse(pos.x+35+buy.pos.x, pos.y+35+buy.pos.y, 50, 50);
      text("$ 30", buy.pos.x + pos.x + 20, buy.pos.y + pos.y + 80);
    } else if (text == "wuerfel") {
      fill(0,200,200);
      stroke(50,50,50);      
      rect(pos.x+10+buy.pos.x, pos.y+10+buy.pos.y, 50, 50);   
      text("$ 20", buy.pos.x + pos.x + 20, buy.pos.y + pos.y + 80); 
    }
  }
  
  void mouseReleased() {
    if(mouseX <= buy.pos.x+pos.x+70 && mouseX >= pos.x+buy.pos.x && mouseY <= buy.pos.y+pos.y+70 && mouseY >= buy.pos.y+pos.y) {
//      println("MenuItem::mouseReleased()");
      MountPoint mp = patern.GetNearestMountPoint(supply.pos);
      if(mp == null || mp.mount != null) {
        audio_buy_fail.rewind();
        audio_buy_fail.play();
        //println("MenuItem::mouseReleased() unable to find valid mountpoint");
        return;
      }
      if(text == "wuerfel") {
        if(stats_money < 20) {
          audio_buy_fail.rewind();
          audio_buy_fail.play();
          return;
        }
        RectMounter m = new RectMounter(mp);  
        mDrawables.add(m);
        stats_money -= 20;
        audio_buy_success.rewind();
        audio_buy_success.play();
      } else if (text == "kugel") {
        if(stats_money < 30) {
          audio_buy_fail.rewind();
          audio_buy_fail.play();
          return;
        }
        KugelMounter m = new KugelMounter(mp);  
        mDrawables.add(m);        
        stats_money -= 30;
        audio_buy_success.rewind();
        audio_buy_success.play();
      }
    }
  }
  
  void mousePressed() {
  }
  
  void keyReleased() {
  }  
}
