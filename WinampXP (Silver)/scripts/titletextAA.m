#include "lib/std.mi"

//guess we are doing this the hard way
//include this in skin.xml if the title shadow looks like ass

Global Container containerMain, containerPL , containerEQ;
Global Layout layoutMainNormal, layoutMainShade, layoutPLNormal, layoutPLShade, layoutEQShade;
Global Group MainGroup, MainGroupShade, DisplayGroupShade, PLGroupShade, PLGroupShadeDisplay, EQShadeGroup;
Global Text MainTitle, PLEditInfo, EQShadeTitle;
Global GuiObject PLShadeTitle, ShadeTitle;

System.onScriptLoaded(){
  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");
	MainGroup = layoutMainNormal.getObject("player.normal.group.main");
  layoutMainShade = containerMain.getLayout("shade");

  containerPL = System.getContainer("PLEdit");
  layoutPLShade = containerPL.getLayout("shade");
  layoutPLNormal = containerPL.getLayout("normalpl");
  PLGroupShade = layoutPLShade.getObject("pledit.shade.group.main");
  PLGroupShadeDisplay = PLGroupShade.getObject("pledit.shade.group.display");

  containerEQ = System.getContainer("equalizer");
  layoutEQShade = containerEQ.getLayout("shade");
  EQShadeGroup = layoutEQShade.getObject("equalizer.shade.group");

  MainTitle = MainGroup.getObject("window.titlebar.title.dropshadow");
  ShadeTitle = layoutMainShade.findObject("shade.display.songname.shadow");
  PLShadeTitle = PLGroupShadeDisplay.getObject("main.pl.shadow");
  PLEditInfo = layoutPLNormal.getObject("pledit.info.shadow");
  EQShadeTitle = EQShadeGroup.getObject("window.titlebar.title.dropshadow");

  //all this because of an ugly drop shadow

  MainTitle.setXmlParam("antialias", "0");
  ShadeTitle.setXmlParam("antialias", "0");
  PLShadeTitle.setXmlParam("antialias", "0");
  PLEditInfo.setXmlParam("antialias", "0");
  EQShadeTitle.setXmlParam("antialias", "0");

  }
