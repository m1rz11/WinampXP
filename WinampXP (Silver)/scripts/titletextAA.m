#include "lib/std.mi"

//guess we are doing this the hard way
//include this in skin.xml if the title shadow looks like ass

Global Container containerMain, /*containerEQ*/;
Global Layout layoutMainNormal, layoutMainShade;
Global Group MainGroup, MainGroupShade, /*EQGroup*/;
Global Text MainTitle, ShadeTitle;

System.onScriptLoaded(){
  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");
	MainGroup = layoutMainNormal.getObject("player.normal.group.main");

  layoutMainShade = containerMain.getLayout("shade");
  MainGroupShade = layoutMainShade.getObject("player.shade.group.main");

  /*
  containerEQ = System.getContainer("equalizer");
  EQGroup = containerEQ.getObject("equalizer.normal.group.main.content");
  //yeah i kinda just gave up here
  */

  MainTitle = MainGroup.getObject("window.titlebar.title.dropshadow");
  ShadeTitle = MainGroupShade.getObject("shade.window.titlebar.title.dropshadow");

  MainTitle.setXmlParam("antialias", "0");
  ShadeTitle.setXmlParam("antialias", "0");

  }
