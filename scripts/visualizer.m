#include "lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);

Global Container containerMain;
Global Container containerPL;
Global Layout layoutPL, layoutMainNormal, layoutMainShade;
Global Group NormalGroupMain, NormalGroupDisplay, ShadeGroupMain, ShadeGroupDisplay;
Global Vis visualizer, visualizershade, visualizerpl;
Global Button OAIDUBtnUE1, OAIDUBtnUE2, OAIDUBtnUE3;

Global PopUpMenu visMenu;
Global PopUpMenu specmenu;
Global PopUpMenu oscmenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu stylemenu;

Global Int currentMode, a_falloffspeed, p_falloffspeed, a_coloring;
Global Boolean show_peaks;
Global layer Trigger, HideForVic, TriggerBlocker, TriggerBlockerShade;



System.onScriptLoaded()
{ 
  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");
	NormalGroupMain = layoutMainNormal.findObject("player.normal.group.main");
	NormalGroupDisplay = NormalGroupMain.findObject("player.normal.group.display");
	OAIDUBtnUE1 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry1");
  OAIDUBtnUE2 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry2");
  OAIDUBtnUE3 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry3");

	visualizer = NormalGroupDisplay.findObject("player.vis");

	layoutMainShade = containerMain.getLayout("shade");
	ShadeGroupMain = layoutMainShade.findObject("player.shade.group.main");
	ShadeGroupDisplay = ShadeGroupMain.findObject("player.shade.group.display");
	visualizershade = ShadeGroupDisplay.findObject("shade.vis");
		
  containerPL = System.getContainer("PLEdit");
  layoutPL = containerPL.getLayout("normalpl");
	visualizerpl = layoutPL.findObject("shade.vis");


	Trigger = NormalGroupDisplay.findObject("player.vis.trigger");
	TriggerBlocker = layoutPL.findObject("player.vis.blocker");
	TriggerBlockerShade = ShadeGroupDisplay.findObject("player.vis.blocker");
	HideForVic = NormalGroupDisplay.findObject("hide.for.vic");

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));

	visualizershade.setXmlParam("peaks", integerToString(show_peaks));
	visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));

	visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
	visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));
	

	refreshVisSettings ();
}

visualizerpl.onSetVisible(int on) {
	if (on) refreshVisSettings ();
}

visualizershade.onSetVisible(int on) {
	if (on) refreshVisSettings ();
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff", 2);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 0);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));

	visualizershade.setXmlParam("peaks", integerToString(show_peaks));
	visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));	

	visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
	visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));

	if (a_coloring == 0)
	{
		visualizer.setXmlParam("coloring", "Normal");
		visualizershade.setXmlParam("coloring", "Normal");
		visualizerpl.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 1)
	{
		visualizer.setXmlParam("coloring", "Normal");
		visualizershade.setXmlParam("coloring", "Normal");
		visualizerpl.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 2)
	{
		visualizer.setXmlParam("coloring", "Fire");
		visualizershade.setXmlParam("coloring", "Fire");
		visualizerpl.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		visualizer.setXmlParam("coloring", "Line");
		visualizershade.setXmlParam("coloring", "Line");
		visualizerpl.setXmlParam("coloring", "Line");
	}

	setVis (currentMode);
}

Trigger.onLeftButtonDown (int x, int y)
{
	currentMode++;

	if (currentMode == 6)
	{
		currentMode = 0;
	}

	setVis	(currentMode);
	complete;
}



Trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	specmenu = new PopUpMenu;
	oscmenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;

	visMenu.addCommand("Presets:", 999, 0, 1);
	visMenu.addCommand("No Visualization", 100, currentMode == 0, 0);
	specmenu.addCommand("Thick Bands", 1, currentMode == 1, 0);
	specmenu.addCommand("Thin Bands", 2, currentMode == 2, 0);
	visMenu.addSubMenu(specmenu, "Spectrum Analyzer");

	oscmenu.addCommand("Solid", 3, currentMode == 3, 0);
	oscmenu.addCommand("Dots", 4, currentMode == 4, 0);
	oscmenu.addCommand("Lines", 5, currentMode == 5, 0);
	visMenu.addSubMenu(oscmenu, "Oscilloscope");

	visMenu.addSeparator();
	visMenu.addCommand("Options:", 102, 0, 1);
	visMenu.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	visMenu.addSubMenu(pksmenu, "Peak Falloff Speed");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	visMenu.addSubMenu(anamenu, "Analyzer Falloff Speed");
	stylemenu.addCommand("Normal", 400, a_coloring == 0, 0);
	stylemenu.addCommand("Fire", 402, a_coloring == 2, 0);
	stylemenu.addCommand("Line", 403, a_coloring == 3, 0);
	visMenu.addSubMenu(stylemenu, "Analyzer Coloring");
	visMenu.addSeparator();
	visMenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 404, 0,0);
	visMenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 405, 0,0);
	visMenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 406, 0,0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete specmenu;
	delete oscmenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		visualizer.setXmlParam("peaks", integerToString(show_peaks));
		visualizershade.setXmlParam("peaks", integerToString(show_peaks));
		visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));
		visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

	else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			visualizer.setXmlParam("coloring", "Normal");
			visualizershade.setXmlParam("coloring", "Normal");
			visualizerpl.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			visualizer.setXmlParam("coloring", "Normal");
			visualizershade.setXmlParam("coloring", "Normal");
			visualizerpl.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			visualizer.setXmlParam("coloring", "Fire");
			visualizershade.setXmlParam("coloring", "Fire");
			visualizerpl.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			visualizer.setXmlParam("coloring", "Line");
			visualizershade.setXmlParam("coloring", "Line");
			visualizerpl.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}
		
  else if (a == 404)
  {
    OAIDUBtnUE1.Leftclick ();
  }
  else if (a == 405)
  {
    OAIDUBtnUE2.Leftclick ();
  }
  else if (a == 406)
  {
    OAIDUBtnUE3.Leftclick ();
  }

}



setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		HideForVic.show();
		visualizer.setMode(0);
		visualizershade.setMode(0);
		visualizerpl.setMode(0);
	}
	else if (mode == 1)
	{
		visualizer.setXmlParam("bandwidth", "wide");
		visualizershade.setXmlParam("bandwidth", "wide");
		visualizerpl.setXmlParam("bandwidth", "wide");
		HideForVic.show();
		visualizer.setMode(1);
		visualizershade.setMode(1);
		visualizerpl.setMode(1);
	}
	else if (mode == 2)
	{
		visualizer.setXmlParam("bandwidth", "thin");
		visualizershade.setXmlParam("bandwidth", "thin");
		visualizerpl.setXmlParam("bandwidth", "thin");
		HideForVic.show();
		visualizer.setMode(1);
		visualizershade.setMode(1);
		visualizerpl.setMode(1);
	}
	else if (mode == 3)
	{
		visualizer.setXmlParam("oscstyle", "solid");
		visualizershade.setXmlParam("oscstyle", "solid");
		visualizerpl.setXmlParam("oscstyle", "solid");
		HideForVic.hide();
		visualizer.setMode(2);
		visualizershade.setMode(2);
		visualizerpl.setMode(2);
	}
	else if (mode == 4)
	{
		visualizer.setXmlParam("oscstyle", "dots");
		visualizershade.setXmlParam("oscstyle", "dots");
		visualizerpl.setXmlParam("oscstyle", "dots");
		HideForVic.hide();
		visualizer.setMode(2);
		visualizershade.setMode(2);
		visualizerpl.setMode(2);
	}
	else if (mode == 5)
	{
		visualizer.setXmlParam("oscstyle", "lines");
		visualizershade.setXmlParam("oscstyle", "lines");
		visualizerpl.setXmlParam("oscstyle", "lines");
		HideForVic.hide();
		visualizer.setMode(2);
		visualizershade.setMode(2);
		visualizerpl.setMode(2);
	}
	currentMode = mode;
}


TriggerBlocker.onLeftButtonDblClk(int x, int y)
{
  OAIDUBtnUE1.Leftclick ();
}

TriggerBlockerShade.onLeftButtonDblClk(int x, int y)
{
  OAIDUBtnUE1.Leftclick ();
}