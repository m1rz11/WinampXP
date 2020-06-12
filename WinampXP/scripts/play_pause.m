/*
Victhor Play-pause script taken and adapted from cPro2 script by pjn123
*/

#include "lib/std.mi"

Global Container containerMain;
Global Layout layoutMainNormal, layoutMainShade;
Global Group scriptgroup, MainGroupShade;
Global Button PlayButton, PauseButton, PlayButtonActive, PlayButtonInactive, PauseButtonActive, PauseButtonInactive;

System.onScriptLoaded() {

	containerMain = System.getContainer("main");
  
	layoutMainNormal = containerMain.getLayout("normal");
	layoutMainShade = containerMain.getLayout("shade");

	MainGroupShade = layoutMainShade.getObject("player.shade.group.main");
	
	scriptgroup = getScriptGroup();
	PlayButton = scriptgroup.findObject(System.getToken(System.getParam(), ";", 0));
	PauseButton = scriptgroup.findObject(System.getToken(System.getParam(), ";", 1));

	PlayButtonActive = MainGroupShade.getObject("play.active");
	PlayButtonInactive = MainGroupShade.getObject("play.inactive");

	PauseButtonActive = MainGroupShade.getObject("pause.active");
	PauseButtonInactive = MainGroupShade.getObject("pause.inactive");
			
	// Play-Pause button
	if(System.getStatus() == STATUS_PLAYING){
		PlayButton.hide();
		PlayButtonActive.hide();
		PlayButtonInactive.hide();

		PauseButton.show();
		PauseButtonActive.show();
		PauseButtonInactive.show();
	}
	else{
		PlayButton.show();
		PlayButtonActive.show();
		PlayButtonInactive.show();

		PauseButton.hide();
		PauseButtonActive.hide();
		PauseButtonInactive.hide();
	}
}

// Play-Pause button
System.onPlay(){
	PlayButton.hide();
	PlayButtonActive.hide();
	PlayButtonInactive.hide();

	PauseButton.show();
	PauseButtonActive.show();
	PauseButtonInactive.show();
}
System.onStop(){
	PlayButton.show();
	PlayButtonActive.show();
	PlayButtonInactive.show();

	PauseButton.hide();
	PauseButtonActive.hide();
	PauseButtonInactive.hide();
}
System.onPause(){
	PlayButton.show();
	PlayButtonActive.show();
	PlayButtonInactive.show();

	PauseButton.hide();
	PauseButtonActive.hide();
	PauseButtonInactive.hide();
}
System.onResume(){
	PlayButton.hide();
	PlayButtonActive.hide();
	PlayButtonInactive.hide();

	PauseButton.show();
	PauseButtonActive.show();
	PauseButtonInactive.show();
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