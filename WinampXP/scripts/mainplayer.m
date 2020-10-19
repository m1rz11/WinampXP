#include "lib/application.mi"
#include "lib/fileio.mi"


Function int getChannels (); // returning 1 for mono, 2 for stereo, more for multichannel (e.g. 6), -1 for no info available
Function initMainPlayer();
Function unloadMainPlayer();
Function volumeUpdateTicker(Int intVolume, Text textSongTicker, Text textVolumeTicker);
Function setVolumeAnim(int volValue);

Class ToggleButton RepeatShuffleHandler;

Global RepeatShuffleHandler RepeatBtn, ShuffleBtn;
Global Group ScriptGroup, MainGroup, WinampTxtGroup, SongInfoGroup, DisplayGroup, SongtickerGroup, MainGroupShade, DisplayGroupShade/*, SongtickerOptionsGroup*/;

// EQ shade mode stuff..
Global Group EqShadeGroup, EqShadeVolbalance;
Global Slider Balance;
// ..it's here to avoid a strange bug (center throws -0.2dB)

Global Button EqLight, PLLight, OAIDUMenuD, OAIDUBtnUE1, OAIDUBtnUE2, OAIDUBtnUE3, StopBtn, WinampIcon;
Global ToggleButton OAIDUBtnA;
Global AnimatedLayer VolumeAnim, MainVolumeAnim;
Global AnimatedLayer anlBalance, MainanlBalance;
Global Button OAIDUBtnI, OAIDUBtnD, OAIDUBtnU, AboutBtn;
Global GuiObject DisplayTime, OAIDUBtnO;
Global GuiObject SonginfoFrequencyBG, SonginfoFrequencyDISPLAY, SonginfoBitrateBG, SonginfoBitrateDISPLAY, ButtonClose;
Global Layer EqButton, PLButton, SonginfoMono, SonginfoStereo, SonginfoBitrateLabel, SonginfoFrequencyLabel;
Global togglebutton RepeatLight, ShuffleLight;
Global Layer WinampTxt, AboutBG, WinampTxtShade;
Global Text SonginfoBitrate, SonginfoFrequency, Title1, Title2, Title3;
Global Slider EqBalance;
Global Layer Trigger;
Global Container MainContainer;

Global timer getchanneltimer; // this has delay, apparently needed to have some time to get the info
Global int timemodestring;
Global int stopstate;
Global int dblscalestate;
Global int BalChanging=0;

Function string getBitrate();
Function string getFrequency();

Global timer delayload, songInfoTimer;

Global int tempwidth;
Global boolean param;

//Global Boolean iswacup;
Global File myCheckerDoc;


#define CENTER_VAR WinampGroup
#include "lib/com/centerlayer.m"
#undef CENTER_VAR


initMainPlayer() {
  MainContainer = getContainer("main");

	MainGroup = layoutMainNormal.getObject("player.normal.group.main");
	SongInfoGroup = MainGroup.getObject("player.normal.group.songinfo");

	AboutBG = MainGroup.getObject("about.bg");
	AboutBtn = MainGroup.getObject("player.button.about");
	ButtonClose = MainGroup.getObject("player.button.close");

	SonginfoMono = SongInfoGroup.getObject("songinfo.mono");
	SonginfoStereo = SongInfoGroup.getObject("songinfo.stereo.srrnd");

	SonginfoBitrateBG = SongInfoGroup.getObject("songinfo.bitrate.bg");
	SonginfoBitrateDISPLAY = SongInfoGroup.getObject("songinfo.bitrate.display");
	SonginfoBitrate = SongInfoGroup.getObject("songinfo.bitrate");
	SonginfoBitrateLabel = SongInfoGroup.getObject("songinfo.bitrate.label");

	SonginfoFrequencyBG = SongInfoGroup.getObject("songinfo.frequency.bg");
	SonginfoFrequencyDISPLAY = SongInfoGroup.getObject("songinfo.frequency.display");
	SonginfoFrequency = SongInfoGroup.getObject("songinfo.frequency");
	SonginfoFrequencyLabel = SongInfoGroup.getObject("songinfo.frequency.label");

	DisplayGroup = MainGroup.getObject("player.normal.group.display");
  OAIDUBtnU = DisplayGroup.getObject("OAIDU.buttons.U");
  OAIDUBtnUE1 = DisplayGroup.getObject("OAIDU.buttons.U.menuentry1");
  OAIDUBtnUE2 = DisplayGroup.getObject("OAIDU.buttons.U.menuentry2");
  OAIDUBtnUE3 = DisplayGroup.getObject("OAIDU.buttons.U.menuentry3");

  Title1 = MainGroup.getObject("window.titlebar.title.dropshadow");
  Title2 = MainGroup.getObject("window.titlebar.title");
  Title3 = MainGroup.getObject("window.titlebar.title.dim");

	//SongtickerOptionsGroup = MainGroup.getObject("songticker.options");

	SongtickerGroup = MainGroup.getObject("player.normal.group.songticker");
  //SongtickerObj = SongtickerGroup.getObject("player.display.songname");
	
	MainGroupShade = layoutMainShade.getObject("player.shade.group.main");
	DisplayGroupShade = MainGroupShade.getObject("player.shade.group.display");
  //DisplayTimeShade = DisplayGroupShade.getObject("shade.time");

	WinampTxtShade = MainGroupShade.getObject("winamp.txt");
  
  DisplayTime = DisplayGroup.getObject("display.time");
  
  Trigger = DisplayGroup.findObject("player.vis.trigger");

  OAIDUMenuD = DisplayGroup.getObject("OAIDU.menu.D");
  OAIDUBtnD = DisplayGroup.getObject("OAIDU.buttons.D");

  OAIDUBtnO = DisplayGroup.getObject("OAIDU.buttons.O.m");
  OAIDUBtnA = DisplayGroup.getObject("OAIDU.buttons.A");
  OAIDUBtnI = DisplayGroup.getObject("OAIDU.buttons.I");

	EqButton = MainGroup.getObject("player.button.eq");
	EqLight = MainGroup.getObject("player.button.eq.light");

	anlBalance = MainGroup.getObject("main.balance.anim");
	EqBalance = MainGroup.getObject("eq.slider.pan");

	PLButton = MainGroup.getObject("player.button.pl");
	PLLight = MainGroup.getObject("player.button.pl.light");

	ShuffleBtn = MainGroup.getObject("button.shuffle");
	ShuffleLight = MainGroup.getObject("shuffle.light");
	
  RepeatBtn = MainGroup.getObject("button.repeat");
	RepeatLight = MainGroup.getObject("repeat.light");
	
  MainVolumeAnim = MainGroup.getObject("main.volume.anim");

	StopBtn = MainGroup.getObject("button.stop");

	WinampTxtGroup = MainGroup.getObject("titlebar.winamptxt.group");
	WinampTxt = WinampTxtGroup.getObject("titlebar.winamptxt");
  WinampIcon = MainGroup.getObject("player.button.mainmenu");

  // EQ shade mode stuff, it's here to avoid strange bugs
	EqShadeGroup = layoutEqShade.getObject("equalizer.shade.group");
	EqShadeVolbalance = EqShadeGroup.getObject("eq.shade.volbalance");
  MainanlBalance = EqShadeVolbalance.getObject("balance.anim");
	Balance = EqShadeVolbalance.getObject("eq.slider.pan");
	VolumeAnim = EqShadeVolbalance.getObject("volume.anim");
	
  // EQ shade mode stuff, it's here to avoid strange bugs


  _WinampGroupInit(WinampTxtGroup, MainGroup, 1, 0);

	getchanneltimer = new Timer;
	getchanneltimer.setDelay(100);
  
  Int PlayerStatus = System.getStatus();
  
  if (PlayerStatus != 0) { getchanneltimer.start(); }

  timemodestring = getPrivateInt(getSkinName(), "timemodestring", timemodestring);

  if (timemodestring == 1)
  {
    DisplayTime.setXmlParam("display", "TIMEELAPSED");
    //DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 1;
  }
  else if (timemodestring == 2)
  {
    DisplayTime.setXmlParam("display", "TIMEREMAINING");
    //DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 2;
  }

  stopstate = getPrivateInt(getSkinName(), "stopstate", stopstate);

  if (stopstate == 0)
  {
    StopBtn.setXmlParam("image", "button.stop.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.h");
    StopBtn.setXmlParam("downimage", "button.stop.d");
    stopstate = 0;
  }
  else if (stopstate == 1)
  {
    StopBtn.setXmlParam("image", "button.stop.ac.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.ac.h");
    StopBtn.setXmlParam("downimage", "button.stop.ac.d");
    stopstate = 1;
  }

	delayload = new Timer;
	delayload.setDelay(100);

	songInfoTimer = new Timer;
	songInfoTimer.setDelay(1000);
	
  dblscalestate = getPrivateInt(getSkinName(), "dblscalestate", dblscalestate);
  
  /*
  if (dblscalestate == 0)
  {
    OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.n");
  }
  else if (dblscalestate == 1)
  {
    OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.h");
  }
  */
  
  //iswacup = getPrivateInt(getSkinName(), "iswacup", iswacup);
  
  myCheckerDoc = new File;
  String temp = (Application.GetSettingsPath()+"/WACUP_Tools/koopa.ini");
  myCheckerDoc.load (temp);
  
  if(myCheckerDoc.exists())
  {
    WinampTxt.setXmlParam("image", "titlebar.wacup.txt");
    WinampTxtShade.setXmlParam("image", "shade.wacup.txt");
    AboutBG.setXmlParam("image", "about.wacup.bg");
    AboutBtn.setXmlParam("image", "button.about.wacup.n");
    AboutBtn.setXmlParam("hoverimage", "button.about.wacup.h");
    AboutBtn.setXmlParam("downimage", "button.about.wacup.d");
    //setPrivateInt(getSkinName(), "iswacup", iswacup);
    //iswacup = 1;
  }
  else
  {
    WinampTxt.setXmlParam("image", "titlebar.winamp.txt");
    WinampTxtShade.setXmlParam("image", "shade.winamp.txt");
    AboutBG.setXmlParam("image", "about.bg");
    AboutBtn.setXmlParam("image", "button.about.n");
    AboutBtn.setXmlParam("hoverimage", "button.about.h");
    AboutBtn.setXmlParam("downimage", "button.about.d");
    //MainContainer.setXmlParam("name","Winamp");   //nope
    Title1.setXmlParam("text","Winamp");
    Title2.setXmlParam("text","Winamp");
    Title3.setXmlParam("text","Winamp");

    WinampIcon.setXmlParam("image", "player.button.mainmenu.winamp");
    WinampIcon.setXmlParam("hoverimage", "player.button.mainmenu.winamp.h");
    WinampIcon.setXmlParam("downimage", "player.button.mainmenu.winamp.d");
    //setPrivateInt(getSkinName(), "iswacup", iswacup);
    //iswacup = 0;
  }

  setVolumeAnim(System.getVolume());

  int v = EqBalance.GetPosition();
  
	if (v==127) anlBalance.gotoFrame(15); MainanlBalance.gotoFrame(15);
	if (v<127) v = (27-(v/127)*27); 
	if (v>127) v = ((v-127)/127)*27;
	
  anlBalance.gotoFrame(v);
  MainanlBalance.gotoFrame(v);  
}

unloadMainPlayer() {
	getchanneltimer.stop();
	delete getchanneltimer;

  setPrivateInt(getSkinName(), "timemodestring", timemodestring);
  setPrivateInt(getSkinName(), "stopstate", stopstate);
  setPrivateInt(getSkinName(), "dblscalestate", dblscalestate);
  //setPrivateInt(getSkinName(), "iswacup", iswacup);
  
	songinfotimer.stop();
	delete songinfotimer;
	delayload.stop();
	delete delayload;
}



EqLight.onEnterArea()
{	
	EqButton.setXmlParam("image", "player.h.button.eq");
}

EqLight.onLeaveArea()
{	
	EqButton.setXmlParam("image", "player.normal.button.eq");
}

EqLight.onLeftButtonDown(int x, int y)
{	
	EqButton.setXmlParam("image", "player.normal.button.eq.down");
}

EqLight.onLeftButtonUp(int x, int y)
{
  if (EqLight.isMouseOverRect()) { EqButton.setXmlParam("image", "player.h.button.eq");	}
	else { EqButton.setXmlParam("image", "player.normal.button.eq"); }
}

PLLight.onEnterArea()
{	
	PLButton.setXmlParam("image", "player.h.button.pl");
}

PLLight.onLeaveArea()
{	
	PLButton.setXmlParam("image", "player.normal.button.pl");
}

PLLight.onLeftButtonDown(int x, int y)
{	
	PLButton.setXmlParam("image", "player.normal.button.pl.down");
}

PLLight.onLeftButtonUp(int x, int y)
{
  if (PLLight.isMouseOverRect()) { PLButton.setXmlParam("image", "player.h.button.pl");	}
	else { PLButton.setXmlParam("image", "player.normal.button.pl"); }
}

/*SongtickerObj.onRightButtonDown(int x, int y)
{
  int playerleft = layoutMainNormal.getleft();
  int x = getMousePosX() - playerleft;

  //int playertop = layoutMainNormal.getTop();
  //int y = getMousePosY() - playertop - 38;

  //System.messageBox(IntegerToString(y), "LANGUE", 1, "");

    SongtickerOptionsGroup.setAlpha(253);
    SongtickerOptionsGroup.setTargetX(x);
    SongtickerOptionsGroup.setTargetY(20);
    SongtickerOptionsGroup.setTargetH(30);
    //SongtickerOptionsGroup.setTargetW(w);
    SongtickerOptionsGroup.setTargetSpeed(0.5);
    SongtickerOptionsGroup.gotoTarget();
}*/

RepeatShuffleHandler.onLeftButtonDown (int x, int y)
{
  if (RepeatShuffleHandler == RepeatBtn)
	{
		if (getCurCfgVal() == 1)
		{
      RepeatLight.setXmlParam("y", "201");
			showActionInfo("Repeat: Track");
		}
		else if (getCurCfgVal() == -1)
		{
      RepeatLight.setXmlParam("y", "201");
			showActionInfo("Repeat: Off");
		}
		else if (getCurCfgVal() == 0)
		{
      RepeatLight.setXmlParam("y", "201");
			showActionInfo("Repeat: Playlist");
		}
	}
  else if (RepeatShuffleHandler == ShuffleBtn)
  {
		if (getCurCfgVal() == 1)
		{
      ShuffleLight.setXmlParam("y", "201");
			showActionInfo("Shuffle: Off");
		}
		else
		{
      ShuffleLight.setXmlParam("y", "201");
			showActionInfo("Shuffle: On");
		}
	}
}

RepeatShuffleHandler.onLeftButtonUp (int x, int y)
{
  if (RepeatShuffleHandler == RepeatBtn)
	{
      if (getCurCfgVal() == 1)
      {
        if (RepeatBtn.isMouseOverRect())
        {
          RepeatLight.setXmlParam("y", "201");
        }
        else
        {
          RepeatLight.setXmlParam("y", "201");
        }
      }
      else if (getCurCfgVal() == -1)
      {
        if (RepeatBtn.isMouseOverRect())
        {
          RepeatLight.setXmlParam("y", "201");
        }
        else
        {
          RepeatLight.setXmlParam("y", "201");
        }
      }
      else if (getCurCfgVal() == 0)
      {
        if (RepeatBtn.isMouseOverRect())
        {
          RepeatLight.setXmlParam("y", "201");
        }
        else
        {
          RepeatLight.setXmlParam("y", "201");
        }
      }
		}
    else if (RepeatShuffleHandler == ShuffleBtn)
    {
      if (getCurCfgVal() == 1)
      {
        if (ShuffleBtn.isMouseOverRect())
        {
          ShuffleLight.setXmlParam("y", "201");
        }
        else {
          ShuffleLight.setXmlParam("y", "201");
        }
      }
      else
      {
        if (ShuffleBtn.isMouseOverRect())
        {
          ShuffleLight.setXmlParam("y", "201");
        }
        else
        {
          ShuffleLight.setXmlParam("y", "201");
        }
      }
		}
}

RepeatShuffleHandler.onEnterArea()
{
  if (RepeatShuffleHandler == RepeatBtn)
	{
		if (getCurCfgVal() == 1)
		{
			RepeatLight.setXmlParam("y", "201");
		}
		else if (getCurCfgVal() == -1)
		{
			RepeatLight.setXmlParam("y", "201");
		}
		else if (getCurCfgVal() == 0)
		{
			RepeatLight.setXmlParam("y", "201");
		}
  }
  else if (RepeatShuffleHandler == ShuffleBtn)
  {
		if (getCurCfgVal() == 1)
		{
			ShuffleLight.setXmlParam("y", "201");
		}
		else
		{
			ShuffleLight.setXmlParam("y", "201");
		}
  }
}

RepeatShuffleHandler.onLeaveArea()
{
  if (RepeatShuffleHandler == RepeatBtn)
	{
		if (getCurCfgVal() == 1)
		{
			RepeatLight.setXmlParam("y", "201");
		}
		else if (getCurCfgVal() == -1)
		{
			RepeatLight.setXmlParam("y", "201");
		}
		else if (getCurCfgVal() == 0)
		{
			RepeatLight.setXmlParam("y", "201");
		}
  }
  else if (RepeatShuffleHandler == ShuffleBtn)
  {
 		if (getCurCfgVal() == 1)
		{
			ShuffleLight.setXmlParam("y", "201");
		}
		else if (getCurCfgVal() == 0)
		{
      ShuffleLight.setXmlParam("y", "201");
		} 
  }
}

System.onResume()
{
	getchanneltimer.start();
	delayload.start();
	songInfoTimer.start();
}

System.onPlay()
{
	getchanneltimer.start();
	delayload.start();
	songInfoTimer.start();
}

System.onTitleChange(String newtitle)
{
	getchanneltimer.start();

  if (stopstate == 1) {
    StopBtn.setXmlParam("image", "button.stop.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.h");
    StopBtn.setXmlParam("downimage", "button.stop.d");
    stopstate = 0;
  }

  setPrivateInt(getSkinName(), "stopstate", stopstate);

	delayload.start();
	SonginfoBitrate.setText(getBitrate());
}

getchanneltimer.onTimer ()
{
  getchanneltimer.stop();
  int c = getChannels();
  
	if (c >= 3) { SonginfoMono.setXmlParam("image", "songinfo.mono.off"); SonginfoStereo.setXmlParam("image", "songinfo.surround.on");  }
	else if (c == -1) { SonginfoMono.setXmlParam("image", "songinfo.mono.off"); SonginfoStereo.setXmlParam("image", "songinfo.stereo.off"); }
	else if (c == 1) { SonginfoMono.setXmlParam("image", "songinfo.mono.on"); SonginfoStereo.setXmlParam("image", "songinfo.stereo.off"); }
	else if (c == 2 || c == 3) { SonginfoMono.setXmlParam("image", "songinfo.mono.off"); SonginfoStereo.setXmlParam("image", "songinfo.stereo.on"); }
}

Int getChannels ()
{
	if (strsearch(getSongInfoText(), "tereo") != -1)
	{
		return 2;
	}
	else if (strsearch(getSongInfoText(), "ono") != -1)
	{
		return 1;
	}
	else if (strsearch(getSongInfoText(), "annels") != -1)
	{
		int pos = strsearch(getSongInfoText(), "annels");
		return stringToInteger(strmid(getSongInfoText(), pos - 4, 1));
	}
	else
	{
		return -1;
	}
}

OAIDUBtnU.onLeftButtonUp (int x, int y)
{
  popupmenu OAIDUBtnUmenu = new popupmenu;
  	  
	OAIDUBtnUmenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 1, 0,0);
	OAIDUBtnUmenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 2, 0,0);
	OAIDUBtnUmenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 3, 0,0);
  //OAIDUBtnUmenu.addSeparator();	

	int result = OAIDUBtnUmenu.popAtMouse();
 
	  
  if (result == 1)
	{
    OAIDUBtnUE1.Leftclick ();
	}
  else if (result == 2)
	{
    OAIDUBtnUE2.Leftclick ();
	}
	else if (result == 3)
	{
		OAIDUBtnUE3.Leftclick ();
	}
	
	complete;
}

Trigger.onLeftButtonDblClk(int x, int y)
{
  OAIDUBtnUE1.Leftclick ();
}

OAIDUBtnD.onLeftButtonUp (int x, int y)
{
  if (layoutMainNormal.getScale() < 2)
  {
    layoutMainNormal.setScale(layoutMainNormal.getScale()*2);
    //OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.h");
    dblscalestate = 1;
  }
  else
  {
    layoutMainNormal.setScale(layoutMainNormal.getScale()/2);
    //OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.n");
    dblscalestate = 0;
  }
}

OAIDUBtnD.onRightButtonUp (int x, int y)
{
  OAIDUMenuD.Leftclick();
	complete;
}

System.onKeyDown(String key)
{
	if (key == "ctrl+d")
	{
    if (layoutMainNormal.getScale() < 2)
    {
      layoutMainNormal.setScale(layoutMainNormal.getScale()*2);
      //OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.h");
      dblscalestate = 1;
    }
    else
    {
      layoutMainNormal.setScale(layoutMainNormal.getScale()/2);
      //OAIDUBtnD.setXmlParam("image", "OAIDU.buttons.D.n");
      dblscalestate = 0;
    }
	}
	
	else if (key == "ctrl+v")
	{
    if (stopstate == 0 && System.getStatus() == 1)
    {
      if (layoutMainNormal.isActive() || layoutPLShade.isActive() || layoutPLNormal.isActive())
    {
      StopBtn.setXmlParam("image", "button.stop.ac.n");
      StopBtn.setXmlParam("hoverimage", "button.stop.ac.h");
      StopBtn.setXmlParam("downimage", "button.stop.ac.d");
      stopstate = 1;
    }
    }
    else if (stopstate == 1 && System.getStatus() == 1)
    {
      if (layoutMainNormal.isActive() || layoutPLShade.isActive() || layoutPLNormal.isActive())
    {
      StopBtn.setXmlParam("image", "button.stop.n");
      StopBtn.setXmlParam("hoverimage", "button.stop.h");
      StopBtn.setXmlParam("downimage", "button.stop.d");
      stopstate = 0;
    }
    }
	}
	
	return;
}



System.onAccelerator(String action, String section, String key)
{
	if (action == "HOTKEY_SHADETOGGLE")
	{
		if (layoutMainNormal.isActive()) layoutMainNormal.getContainer().switchToLayout("shade");
		else if (layoutMainShade.isActive()) layoutMainShade.getContainer().switchToLayout("normal");
		else if (layoutPLShade.isActive()) layoutPLShade.getContainer().switchToLayout("normalpl");
		else if (layoutEqShade.isActive()) layoutEqShade.getContainer().switchToLayout("normaleq");
		else if (layoutPLNormal.isActive()) layoutPLNormal.getContainer().switchToLayout("shade");
		else return;
		complete;
	}
}


DisplayTime.onLeftButtonUp (int x, int y)
{
  if (DisplayTime.getXmlParam("display") == "TIMEELAPSED")
  {
    DisplayTime.setXmlParam("display", "TIMEREMAINING");
    //DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 1;
  }
  else if (DisplayTime.getXmlParam("display") == "TIMEREMAINING")
  {
    DisplayTime.setXmlParam("display", "TIMEELAPSED");
    //DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 2;
  }
  
  setPrivateInt(getSkinName(), "timemodestring", timemodestring);
}

DisplayTime.onRightButtonUp (int x, int y)
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
    DisplayTime.setXmlParam("display", "TIMEELAPSED");
    //DisplayTimeShade.setXmlParam("display", "TIMEELAPSED");
    timemodestring = 1;
    setPrivateInt(getSkinName(), "timemodestring", timemodestring);
	}
  else if (result == 2)
	{
    DisplayTime.setXmlParam("display", "TIMEREMAINING");
    //DisplayTimeShade.setXmlParam("display", "TIMEREMAINING");
    timemodestring = 2;
    setPrivateInt(getSkinName(), "timemodestring", timemodestring);
	}
	complete;
}


StopBtn.onLeftClick()
{
  if (System.isKeyDown(VK_CONTROL) == 1 && stopstate == 0 && System.getStatus() == 1) {
    StopBtn.setXmlParam("image", "button.stop.ac.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.ac.h");
    StopBtn.setXmlParam("downimage", "button.stop.ac.d");
    stopstate = 1;
  }
  else if (System.isKeyDown(VK_CONTROL) == 1 && stopstate == 1) {
    StopBtn.setXmlParam("image", "button.stop.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.h");
    StopBtn.setXmlParam("downimage", "button.stop.d");
    stopstate = 0;
  }
  else if (System.isKeyDown(VK_CONTROL) == 1 && stopstate == 0 && System.getStatus() == 0) {
    StopBtn.setXmlParam("image", "button.stop.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.h");
    StopBtn.setXmlParam("downimage", "button.stop.d");
    stopstate = 0;
  }

  //setPrivateInt(getSkinName(), "stopstate", stopstate);
}


System.onStop()
{
  if (stopstate == 1) {
    StopBtn.setXmlParam("image", "button.stop.n");
    StopBtn.setXmlParam("hoverimage", "button.stop.h");
    StopBtn.setXmlParam("downimage", "button.stop.d");
    stopstate = 0;
  }

  setPrivateInt(getSkinName(), "stopstate", stopstate);

  songInfoTimer.stop();
}






//////// Song info stuff ////////

/*System.onResume()
{
	delayload.start();
	songInfoTimer.start();
}

System.onPlay()
{
	delayload.start();
	songInfoTimer.start();
}

System.onStop ()
{
	songInfoTimer.stop();
}*/

system.onPause ()
{
	songInfoTimer.stop();
}

/*System.onTitleChange(String newtitle)
{
	delayload.start();
	SonginfoBitrate.setText(getBitrate()); 
}*/

delayload.onTimer ()
{
	//ensure to display bitrate & frequency
	SonginfoBitrate.setText(getBitrate());
	SonginfoFrequency.setText(getFrequency());
}

songInfoTimer.onTimer ()
{
	SonginfoBitrate.setText(getBitrate());
  SonginfoFrequency.setText(getFrequency());
}

string getBitrate ()
{
	string sit = strlower(getSongInfoText());
	if (sit != "")
	{
		string rtn;
		int searchresult;
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sit, " ", i);
			searchResult = strsearch(rtn, "kbps");
			if (searchResult>0) return StrMid(rtn, 0, searchResult);
		}
		return "";
	}
	else
	{
		return "";
	}
}

string getFrequency ()
{
	string sit = strlower(getSongInfoText());
	if (sit != "")
	{
		string rtn;
		int searchresult;
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sit, " ", i);
			searchResult = strsearch(strlower(rtn), "khz");
			if (searchResult>0) 
			{
				rtn = StrMid(rtn, 0, searchResult);
				searchResult = strsearch(strlower(rtn), ".");
				if (searchResult>0)
				{
					rtn = getToken(rtn, ".", 0);
				}
				return rtn;
			}
		}
		return "";
	}
	else
	{
		return "";
	}
}

SonginfoBitrate.onTextChanged (String newtxt)
{
	if (param) return;
	if (SonginfoBitrate.getTextWidth() == tempwidth) return;
	tempwidth = getTextWidth();
	if (getTextWidth() > 31)
	{
    SonginfoBitrateBG.setXmlParam("w", "47");
    SonginfoBitrateDISPLAY.setXmlParam("w", "47");
		SonginfoBitrate.setXmlParam("w", "35");
		SonginfoBitrateLabel.setXmlParam("x", "48");
		SonginfoFrequencyBG.setXmlParam("x", "97");
		SonginfoFrequencyDISPLAY.setXmlParam("x", "97");
		SonginfoFrequency.setXmlParam("x", "105");
		SonginfoFrequencyLabel.setXmlParam("x", "135");
	}
	else
	{
    SonginfoBitrateBG.setXmlParam("w", "39");
    SonginfoBitrateDISPLAY.setXmlParam("w", "39");
		SonginfoBitrate.setXmlParam("w", "26");
		SonginfoBitrateLabel.setXmlParam("x", "40");
		SonginfoFrequencyBG.setXmlParam("x", "90");
		SonginfoFrequencyDISPLAY.setXmlParam("x", "90");
		SonginfoFrequency.setXmlParam("x", "97");
		SonginfoFrequencyLabel.setXmlParam("x", "128");
	}
}

System.onVolumeChanged(Int intVolume) {
  setVolumeAnim(intVolume);
  showActionInfo("Volume: " + System.integerToString(intVolume / 255 * 100) + "%");
}


EqBalance.onSetPosition(int newpos)
{
	string t=translate("Balance")+":";
	if (newpos==127) t+= " " + translate("Center");
	if (newpos<127) t += " " + integerToString((100-(newpos/127)*100))+"% "+translate("Left");
	if (newpos>127) t += " " + integerToString(((newpos-127)/127)*100)+"% "+translate("Right");

  showActionInfo(t);

  int v = newpos;
  
	if (newpos==127) anlBalance.gotoFrame(15); MainanlBalance.gotoFrame(15);
	if (newpos<127) v = (27-(newpos/127)*27); 
	if (newpos>127) v = ((newpos-127)/127)*27;
	
  anlBalance.gotoFrame(v);
  MainanlBalance.gotoFrame(v);
}


// Equalizer shade mode balance slider
Balance.onSetPosition(int newpos)
{
	string t=translate("Balance")+":";
	if (newpos==127) t+= " " + translate("Center");
	if (newpos<127) t += " " + integerToString((100-(newpos/127)*100))+"% "+translate("Left");
	if (newpos>127) t += " " + integerToString(((newpos-127)/127)*100)+"% "+translate("Right");

  showActionInfo(t);

  int v = newpos;
  
	if (newpos==127) anlBalance.gotoFrame(15); MainanlBalance.gotoFrame(15);
	if (newpos<127) v = (27-(newpos/127)*27); 
	if (newpos>127) v = ((newpos-127)/127)*27;
	
  anlBalance.gotoFrame(v);
  MainanlBalance.gotoFrame(v);
}


OAIDUBtnO.onLeftButtonDown(int x, int y)
{	
  showActionInfo("Options Menu");
}

OAIDUBtnA.onLeftButtonDown(int x, int y)
{	
  if (OAIDUBtnA.getCurCfgVal() == 1) { showActionInfo("Disable Always-On-top"); }
  else if (OAIDUBtnA.getCurCfgVal() == 0) { showActionInfo("Enable Always-On-top"); }
}

OAIDUBtnI.onLeftButtonDown(int x, int y)
{	
  showActionInfo("File Info Box");
}

OAIDUBtnD.onLeftButtonDown(int x, int y)
{	
  dblscalestate = getPrivateInt(getSkinName(), "dblscalestate", dblscalestate);
  
  if (dblscalestate == 0)
  {
    showActionInfo("Enable Doublesize Mode");
  }
  else if (dblscalestate == 1)
  {
    showActionInfo("Disable Doublesize Mode");
  }
}


OAIDUBtnU.onLeftButtonDown(int x, int y)
{	
  showActionInfo("Visualization Menu");
}


//sets the Animation to correct frame
setVolumeAnim(int Value) {
	int f = (Value * (VolumeAnim.getLength()-1)) / 255;
    if (Value > 0) {
		VolumeAnim.gotoFrame(f+1);
		MainVolumeAnim.gotoFrame(f+1);
	}
	if (Value == 255) {
		VolumeAnim.gotoFrame(f);
		MainVolumeAnim.gotoFrame(f);
	}
	if (Value == 0) {
		VolumeAnim.gotoFrame(0);
		MainVolumeAnim.gotoFrame(0);
	}
}