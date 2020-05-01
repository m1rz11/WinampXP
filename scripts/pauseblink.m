#include "std.mi"

Function doFade();
Function stopFade();
Function startFade();

Global Container containerMain;
Global Layout layoutMainNormal, layoutMainShade;
Global Group ScriptGroup, MainGroup, DisplayGroup, MainGroupShade, DisplayGroupShade;
Global Text tracktimer;
Global Boolean direction;
Global Timer myTimer;

System.onScriptLoaded() {

	containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");
	layoutMainShade = containerMain.getLayout("shade");

  ScriptGroup = getScriptGroup();

  if (ScriptGroup.getParentLayout().getID() != "shade")
  {
    MainGroup = layoutMainNormal.getObject("player.normal.group.main");
    DisplayGroup = MainGroup.getObject("player.normal.group.display");
    tracktimer = DisplayGroup.findObject("display.time");
	}
  else
  {
    MainGroupShade = layoutMainShade.getObject("player.shade.group.main");
    DisplayGroupShade = MainGroupShade.getObject("player.shade.group.display");
    tracktimer = DisplayGroupShade.findObject("shade.time");
  }
  
	myTimer = new Timer;
	myTimer.setDelay(700);
	
	if(System.getStatus()==STATUS_PAUSED){
		startFade();
	}
}


System.onScriptUnloading() {
	delete myTimer;
}

myTimer.onTimer(){
	doFade();
}

System.onStop(){
	stopFade();
}
System.onPlay(){
	stopFade();
}
System.onResume(){
	stopFade();
}
System.onPause(){
	startFade();
}

doFade(){
	if(direction){
		tracktimer.setTargetA(0);
	}
	else{
		tracktimer.setTargetA(253);
	}
	tracktimer.setTargetSpeed(0.6);
	tracktimer.gotoTarget();
	direction=!direction;
}


startFade(){
	direction=true;
	doFade();
	myTimer.start();
}


stopFade(){
	myTimer.stop();
	tracktimer.cancelTarget();
	tracktimer.setAlpha(253);
}