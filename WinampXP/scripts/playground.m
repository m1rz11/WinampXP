#include "lib/std.mi"

Global List objList;
Global Timer mainTimer;

Global int grav;
Global int num_balls;

System.onScriptLoaded() {
  //xml stuff
  Group scriptgroup = getScriptGroup();

  //create new list
  objList = new List;
  mainTimer = new Timer;

  grav = 1;
  num_balls = 25;

  mainTimer.setDelay(33);

  for(int i = 0; i < num_balls; i++){
    //String pos = integerToString(i+1);
    Text t = new Text;

    t.init(scriptgroup);

    //t.setXmlParam("text", "O");
    t.setXmlParam("x", integerToString(i*15));
    t.setXmlParam("y", integerToString(i*15));

    objList.addItem(t);
  }

  mainTimer.start();
}

mainTimer.onTimer(){
  for(int i = 0; i < num_balls; i++){
    GuiObject t = objList.enumItem(i);
    int y = t.getXmlParam("y");
    int speed_y = t.getXmlParam("text");

    t.setXmlParam("y", integerToString(speed_y+y));
    t.setXmlParam("text", integerToString(speed_y+grav));
    
    if(y+speed_y > 400){
      t.setXmlParam("text", integerToString(-speed_y));
    }
  }
}