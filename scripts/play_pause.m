/*
Victhor Play-pause script taken and adapted from cPro2 script by pjn123
*/

#include "std.mi"

Global Container containerMain;
Global Layout layoutMainNormal, layoutMainShade;
Global Group scriptgroup;
Global Button PlayButton, PauseButton;

System.onScriptLoaded() {

	containerMain = System.getContainer("main");
  
	layoutMainNormal = containerMain.getLayout("normal");
	layoutMainShade = containerMain.getLayout("shade");
	
	scriptgroup = getScriptGroup();
	PlayButton = scriptgroup.findObject(System.getToken(System.getParam(), ";", 0));
	PauseButton = scriptgroup.findObject(System.getToken(System.getParam(), ";", 1));
			
	// Play-Pause button
	if(System.getStatus() == STATUS_PLAYING){
		PlayButton.hide();
		PauseButton.show();
	}
	else{
		PlayButton.show();
		PauseButton.hide();
	}
}

// Play-Pause button
System.onPlay(){
	PlayButton.hide();
	PauseButton.show();
}
System.onStop(){
	PlayButton.show();
	PauseButton.hide();
}
System.onPause(){
	PlayButton.show();
	PauseButton.hide();
}
System.onResume(){
	PlayButton.hide();
	PauseButton.show();
}

//Restart current track ;)
PauseButton.onRightButtonDown(int x, int y){ //Winamp bug hack
	PauseButton.setXmlParam("action", "");
}
PauseButton.onRightButtonUp(int x, int y){ 
	System.play();
	complete;
	PauseButton.setXmlParam("action", "PAUSE");
}