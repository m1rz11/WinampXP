#include "lib/std.mi"
#include "lib/application.mi"
#include "lib/fileio.mi"

Function setNewGroup(String strGroupID);

Global Layout layoutStandardFrame;
Global Group groupStandardFrame;
Global Group groupStandardFrameContent;
Global Group groupStandardFrameTitlebar;
Global Layer layerMouseTrap;
Global Group WasabiFrameGroup;
Global String strParamX, strParamY, strParamW, strParamH, strParamRX, strParamRY, strParamRW, strParamRH;
Global Button WinampIcon;
Global File myCheckerDoc;

System.onScriptLoaded() {
	groupStandardFrame = System.getScriptGroup();
	layoutStandardFrame = groupStandardFrame.getParentLayout();	
	String strParam = System.getParam();
	strParamX = System.getToken(strParam, ",", 0);
	strParamY = System.getToken(strParam, ",", 1);
	strParamW = System.getToken(strParam, ",", 2);
	strParamH = System.getToken(strParam, ",", 3);
	strParamRX = System.getToken(strParam, ",", 4);
	strParamRY = System.getToken(strParam, ",", 5);
	strParamRW = System.getToken(strParam, ",", 6);
	strParamRH = System.getToken(strParam, ",", 7);

	//icon stuff
	WasabiFrameGroup = groupStandardFrame.findobject("wasabi.frame.layout");
	WinampIcon = WasabiFrameGroup.findobject("player.button.mainmenu");

	myCheckerDoc = new File;
  String temp = (Application.GetSettingsPath()+"/WACUP_Tools/koopa.ini");
  myCheckerDoc.load (temp);
  
  if(!myCheckerDoc.exists())
  {
    WinampIcon.setXmlParam("image", "player.button.mainmenu.winamp");
    WinampIcon.setXmlParam("hoverimage", "player.button.mainmenu.winamp.h");
    WinampIcon.setXmlParam("downimage", "player.button.mainmenu.winamp.d");
  }
}

System.onSetXuiParam(String strParam, String strValue) {
	if (strParam == "content") {
		setNewGroup(strValue);
		groupStandardFrameTitlebar = groupStandardFrame.findObject("wasabi.titlebar");
		if (groupStandardFrameTitlebar != NULL) {
			layerMouseTrap = groupStandardFrameTitlebar.findObject("mousetrap");
		}
	}
	if (strParam == "padtitleright" || strParam == "padtitleleft") {
		if (groupStandardFrameTitlebar != NULL) {
			groupStandardFrameTitlebar.setXMLParam(strParam, strValue);
		}
	}
	if (strParam == "shade") {
		if (layerMouseTrap != NULL) {
			layerMouseTrap.setXMLParam("dblclickaction", "switch;" + strValue);
		} else {
			messagebox("Cannot set shade parameter for StandardFrame object, no mousetrap found", "Skin Error", 0, "");
		}
	}
}

groupStandardFrame.onNotify(String strCommandPair, String strParam, Int intA, Int intB) {
	String strCommand = System.getToken(strCommandPair, ",", 0);
	String strCommandParam = System.getToken(strCommandPair, ",", 1);
	if (strCommand == "content" || strCommand == "padtitleright" || strCommand == "padtitleleft" || strCommand == "shade") {
		System.onSetXuiParam(strCommand, strCommandParam);
	}
}

setNewGroup(String strGroupID) {
	groupStandardFrameContent = System.newGroup(strGroupID);
	if (groupStandardFrameContent == NULL) {
		messagebox("group \"" + strGroupID + "\" not found", "ButtonGroup", 0, "");
		return;
	}
	groupStandardFrameContent.setXMLParam("x", strParamX);
	groupStandardFrameContent.setXMLParam("y", strParamY);
	groupStandardFrameContent.setXMLParam("w", strParamW);
	groupStandardFrameContent.setXMLParam("h", strParamH);
	groupStandardFrameContent.setXMLParam("relatx", strParamRX);
	groupStandardFrameContent.setXMLParam("relaty", strParamRY);
	groupStandardFrameContent.setXMLParam("relatw", strParamRW);
	groupStandardFrameContent.setXMLParam("relath", strParamRH);
	groupStandardFrameContent.init(groupStandardFrame);
}