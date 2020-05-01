Function initShadePlayer();
Function unloadShadePlayer();

Global Group ScriptGroup, MainGroupShade, DisplayGroupShade, MainGroupMainPlayer, MainGroupPlayerDisplay;
Global Button VisMenuEntry1, VisMenuEntry2, VisMenuEntry3;
Global GuiObject DisplayTimeShade, Visualization, DisplayTimeMainPlayer;
Global int timemodestring;

initShadePlayer() {
	MainGroupMainPlayer = layoutMainNormal.getObject("player.normal.group.main");
  MainGroupPlayerDisplay = MainGroupMainPlayer.getObject("player.normal.group.display");
  DisplayTimeMainPlayer = MainGroupPlayerDisplay.getObject("display.time");

	MainGroupShade = layoutMainShade.getObject("player.shade.group.main");
	DisplayGroupShade = MainGroupShade.getObject("player.shade.group.display");
  DisplayTimeShade = DisplayGroupShade.getObject("shade.time");

  VisMenuEntry1 = DisplayGroupShade.getObject("vismenu.menuentry1");
  VisMenuEntry2 = DisplayGroupShade.getObject("vismenu.menuentry2");
  VisMenuEntry3 = DisplayGroupShade.getObject("vismenu.menuentry3");
  
  Visualization = DisplayGroupShade.getObject("shade.vis");

  timemodestring = getPrivateInt(getSkinName(), "timemodestring", timemodestring);

  if (timemodestring == 1)
  {
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEELAPSED");
    DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 1;
  }
  else if (timemodestring == 2)
  {
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEREMAINING");
    DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 2;
  }
}

unloadShadePlayer() {
  setPrivateInt(getSkinName(), "timemodestring", timemodestring);
}

Visualization.onRightButtonUp (int x, int y)
{
  popupmenu VisMenu = new popupmenu;
  	  
	VisMenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 1, 0,0);
	VisMenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 2, 0,0);
	VisMenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 3, 0,0);

	int result = VisMenu.popAtMouse();
 
	  
  if (result == 1)
	{
    VisMenuEntry1.Leftclick ();
	}
  else if (result == 2)
	{
    VisMenuEntry2.Leftclick ();
	}
	else if (result == 3)
	{
		VisMenuEntry3.Leftclick ();
	}
	
	complete;
}

Visualization.onLeftButtonDblClk(int x, int y)
{
  VisMenuEntry1.Leftclick ();
}

/*System.onKeyDown(String key)
{
	if (key == "ctrl+d")
	{
   if (layoutMainShade.getScale() < 2)
  {
    layoutMainShade.setScale(layoutMainShade.getScale()*2);
  }
  else
  {
    layoutMainShade.setScale(layoutMainShade.getScale()/2);
  }
	}
	return;
}*/


DisplayTimeShade.onLeftButtonUp (int x, int y)
{
  if (DisplayTimeShade.getXmlParam("display") == "TIMEELAPSED")
  {
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEREMAINING");
    DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 1;
  }
  else if (DisplayTimeShade.getXmlParam("display") == "TIMEREMAINING")
  {
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEELAPSED");
    DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 2;
  }
  
  setPrivateInt(getSkinName(), "timemodestring", timemodestring);
}

DisplayTimeShade.onRightButtonUp (int x, int y)
{
  popupmenu Timemenu = new popupmenu;
  	  
	Timemenu.addcommand(translate("Time elapsed")+"\tCtrl+T toggles", 1, 0,0);
	Timemenu.addcommand(translate("Time remaining")+"\tCtrl+T toggles", 2, 0,0);

  if (timemodestring == 1)
  {
    Timemenu.checkCommand(1, 1);
    timemodestring = 1;
  }
  else if (timemodestring == 2)
  {
    Timemenu.checkCommand(2, 1);
    timemodestring = 2;
  }

	int result = Timemenu.popAtMouse();
 	  
  if (result == 1)
	{
    DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 1;
    setPrivateInt(getSkinName(), "timemodestring", timemodestring);
	}
  else if (result == 2)
	{
    DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    DisplayTimeMainPlayer.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 2;
    setPrivateInt(getSkinName(), "timemodestring", timemodestring);
	}
	complete;
}