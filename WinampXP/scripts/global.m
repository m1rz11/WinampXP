Function initGlobal();
Function unloadGlobal();
Function showActionInfo(String strValue);
Function setSongTicker();

Global Container containerMain;
Global Container containerPL;
Global Container containerEq;
Global Layout layoutEqNormal, layoutEqShade, layoutMainNormal, layoutMainShade;
Global Layout layoutPLNormal, layoutPLShade;
Global GuiObject textNormalSongInfo, textShadeSongInfo, textShadeSongInfoShadow, textShadeSongInfoInactive;
Global Text textNormalActionInfo, textShadeActionInfo, textShadeActionInfoShadow;
Global Timer timerSongTicker;
Global Boolean boolReleaseSongTicker;
Global Boolean boolSongTicker;


initGlobal() {
	containerMain = System.getContainer("main");
  containerEq = System.getContainer("equalizer");
	containerPL = System.getContainer("PLEdit");
	
	layoutEqNormal = containerEq.getLayout("normaleq");
	layoutEqShade = containerEq.getLayout("shade");
	layoutMainNormal = containerMain.getLayout("normal");
	layoutMainShade = containerMain.getLayout("shade");
	
	layoutPLNormal = containerPL.getLayout("normalpl");
	layoutPLShade = containerPL.getLayout("shade");

	textNormalSongInfo = layoutMainNormal.findObject("player.display.songname");
	textNormalActionInfo = layoutMainNormal.findObject("player.display.actioninfo");
	
	textShadeSongInfo = layoutMainShade.findObject("shade.display.songname");
	textShadeSongInfoShadow = layoutMainShade.findObject("shade.display.songname.shadow");
	textShadeSongInfoInactive = layoutMainShade.findObject("shade.display.songname.inactive");
	textShadeActionInfo = layoutMainShade.findObject("player.display.actioninfo");
	textShadeActionInfoShadow = layoutMainShade.findObject("player.display.actioninfo.shadow");

	textNormalActionInfo.hide();
	textShadeActionInfo.hide();
	textShadeActionInfoShadow.hide();
	
	timerSongTicker = new Timer;
	timerSongTicker.setDelay(1000);
	boolReleaseSongTicker = true;
	
	boolSongTicker = System.getPrivateInt(getSkinName(), "SongTicker", 1);
	setSongTicker();
}

unloadGlobal() {
	delete timerSongTicker;
}

timerSongTicker.onTimer() {
	if (boolReleaseSongTicker) {
		textNormalActionInfo.hide();
		textShadeActionInfo.hide();
		textShadeActionInfoShadow.hide();
		
		textNormalSongInfo.show();
		textShadeSongInfo.show();
		textShadeSongInfoShadow.show();
		textShadeSongInfoInactive.show();
		
		timerSongTicker.stop();
	}
}

showActionInfo(String strValue) {
	timerSongTicker.stop();
	timerSongTicker.start();
	
	textNormalSongInfo.hide();
	textNormalActionInfo.show();
	textNormalActionInfo.setText(strValue);
	
	textShadeSongInfo.hide();
	textShadeSongInfoShadow.hide();
	textShadeSongInfoInactive.hide();
	textShadeActionInfo.show();
	textShadeActionInfoShadow.show();
	textShadeActionInfo.setText(strValue);
	textShadeActionInfoShadow.setText(strValue);
}

setSongTicker() {
	textNormalSongInfo.setXMLParam("ticker", System.integerToString(boolSongTicker));
	//textShadeSongInfo.setXMLParam("ticker", System.integerToString(boolSongTicker));
	//textShadeSongInfoShadow.setXMLParam("ticker", System.integerToString(boolSongTicker));
	//textShadeSongInfoInactive.setXMLParam("ticker", System.integerToString(boolSongTicker));
	
	System.setPrivateInt(getSkinName(), "SongTicker", boolSongTicker);
}