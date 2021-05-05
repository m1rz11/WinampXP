#include "lib/std.mi"

Global List objList;
Global Timer mainTimer;

//Global int grav;
//Global int num_balls;

Global int num_bars;

System.onScriptLoaded() {
  //xml stuff
  Group scriptgroup = getScriptGroup();

  //create new list
  objList = new List;
  mainTimer = new Timer;

  //grav = 1;
  //num_balls = 25;
  num_bars = 20;

  mainTimer.setDelay(33);
  
  //fill up the list
  for(int i = 0; i < num_bars; i++){
    Layer l = new Layer;
    l.init(scriptgroup);

    l.setXmlParam("image", "player.seeker.slider.n");

    l.setXmlParam("x", integerToString(20+i*11));
    l.setXmlParam("y", integerToString(20));

    l.setXmlParam("w", "10");
    l.setXmlParam("h", "50");

    objList.addItem(l);
  }

  //balls
  /*
  for(int i = 0; i < num_balls; i++){
    //String pos = integerToString(i+1);
    Text t = new Text;

    t.init(scriptgroup);

    t.setXmlParam("text", "O");
    t.setXmlParam("x", integerToString(i*15));
    t.setXmlParam("y", integerToString(i*15));

    objList.addItem(t);
  }
  */

  //it would be wiser to stop the timer when the song is paused
  mainTimer.start();
}

mainTimer.onTimer(){
  //more balls
  /*for(int i = 0; i < num_balls; i++){
    GuiObject t = objList.enumItem(i);
    int y = t.getXmlParam("y");
    int speed_y = t.getXmlParam("text");

    t.setXmlParam("y", integerToString(speed_y+y));
    t.setXmlParam("text", integerToString(speed_y+grav));
    
    if(y+speed_y > 400){
      t.setXmlParam("text", integerToString(-speed_y));
    }
  }
  */

  //get height for first bar
  GuiObject layer1 = objList.enumItem(0);
  

  //we skip the first one for obvious reasons
  //we go in reverse to avoid all the bars setting to the same value
  for(int i = num_bars-1; i >= 1; i--){
    //get value of previous bar
    GuiObject l_previous = objList.enumItem(i-1);
    String height_previous = l_previous.getXmlParam("h");

    //get current bar
    GuiObject l = objList.enumItem(i);
    
    //set its height
    l.setXmlParam("h", height_previous);
  }

  String height = integerToString(System.getLeftVuMeter());
  layer1.setXmlParam("h", height);
}