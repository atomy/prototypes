class StatsPanel {
  PVector pos;
  ArrayList<StatsItem> items;
  
  StatsPanel() {
    items = new ArrayList<StatsItem>();
    StatsItem item1 = new StatsItem(this, new PVector(15, 5), "money");
    //StatsItem item2 = new StatsItem(this, new PVector(100, 15), "kugel");
    items.add(item1);
   // items.add(item2);
    pos = new PVector(525, 10);    
  }
  
  void draw() {
    stroke(0);
    noFill();
    rect(pos.x, pos.y, 225, 150);
    for(StatsItem item : items) {
      item.draw();
    }
  }
}

class StatsItem
{
  PVector pos;
  String text;
  StatsPanel panel;
  
  StatsItem(StatsPanel panel, PVector pos, String txt) {
    this.panel = panel;
    this.pos = pos;
    this.text = txt;
  }
  
  void draw() {
    stroke(0);
    noFill();
    if(text == "money") {
      fill(0);
      noStroke();
      String moneyString = "money:       $ " + stats_money;
      text(moneyString, pos.x+panel.pos.x, pos.y+panel.pos.y+20);
    } else if (text == "wuerfel") {
      fill(0,200,200);
      stroke(50,50,50);      
      rect(pos.x+10+panel.pos.x, pos.y+10+panel.pos.y, 50, 50);    
    }
  }
}
