#include "lib/std.mi"
#include "lib/pldir.mi"
#include "lib/application.mi"
#include "lib/fileio.mi"

function refreshPL();

#define SCROLL_UP 1
#define SCROLL_DOWN 2

class text plline;

Global Container containerPL;
Global Layout layoutPLNormal, layoutPLShade;

global layout parentLayout;
Global group scriptGroup/*, elipsis*/, MainGroup;

global text dummy;
global guiobject plslider;
global group selector;
global Group shadeGroupMain;
global layer mousetrap;
global string xuiparams = "";
global int currNumLines, currMaxLines, linespace, pltopMod;
global int currSel;
global string playcolor, textcolor, selcolor;

Global Button shadeMainMenuIcon;

global PlEdit PeListener;

global timer delayOnLoad, scrollAnim, delayRefreshPL;
global int targetPLTop, scrollSpeed, scrollDir, noSlow;

global int texth = 20;
global int lenw, numlines;
global int mousePressed, lastY, lastY2, lastpltop, pltoptrack, lastmove, lasttime, origtime;
global int mousePressedSlider, lastYSlider, lastpltopSlider;

Global File myCheckerDoc;

System.onScriptLoaded() {
	containerPL = System.getContainer("PLEdit");

	layoutPLNormal = containerPL.getLayout("normalpl");
	layoutPLShade = containerPL.getLayout("shade");

	shadeGroupMain = layoutPLShade.getObject("pledit.shade.group.main");
	shadeMainMenuIcon = shadeGroupMain.getObject("pl.shade.mainmenu");

	scriptGroup = getScriptGroup();

	//parent = scriptGroup.getParent();

	parentLayout = scriptGroup.getParentLayout();
	dummy = scriptGroup.getObject("dummy");
	selector = scriptGroup.getObject("xui.playlistplus.selector");
	plslider = scriptGroup.getObject("plslider");

	//elipsis = scriptGroup.findObject("elipsis");

	MainGroup = layoutPLNormal.findObject("pledit.content.group");

	pltoptrack = getPrivateInt(getSkinName(),"PLTopTrack",0);
	playcolor = "wasabi.list.text.current";
	textcolor = "wasabi.text.color";

	delayOnLoad = new Timer;
	delayOnLoad.setDelay(50);
	delayOnLoad.start();

	delayRefreshPL = new Timer;
	delayRefreshPL.setDelay(50);
	delayRefreshPL.start();

	scrollAnim = new Timer;
	scrollAnim.setDelay(33);

	setPrivateInt(getSkinName(),"WheelReturn",0);

	myCheckerDoc = new File;
	String temp = (Application.GetSettingsPath()+"/WACUP_Tools/koopa.ini");
	myCheckerDoc.load (temp);

	if(!myCheckerDoc.exists()) {
		shadeMainMenuIcon.setXmlParam("image", "player.button.mainmenu.winamp");
    	shadeMainMenuIcon.setXmlParam("hoverimage", "player.button.mainmenu.winamp.h");
    	shadeMainMenuIcon.setXmlParam("downimage", "player.button.mainmenu.winamp.d");
	}
}

System.onScriptUnloading() {
	delete delayOnLoad;
	delete scrollAnim;
	delete delayRefreshPL;
	delete PeListener;
}

delayOnLoad.onTimer() {
	stop();

	refreshPL();
	mousetrap = scriptGroup.getObject("mousetrap"); // init only after PL is init

	PeListener = new PlEdit;
}

PeListener.onPleditModified () {
	int numtracks = pledit.getNumTracks();

	if (currSel >= numtracks) currSel = numtracks-1;
	if ((pltoptrack + numlines) >= numtracks ) { pltoptrack = numtracks - numlines + 1; pltopMod = 0;}
	if (pltoptrack < 0) { pltoptrack = 0; pltopMod = 0;}
	if (numtracks < numlines) { pltoptrack = 0; pltopMod = 0; }

	if (!delayRefreshPL.isRunning()) delayRefreshPL.start();
}

delayRefreshPL.onTimer() {
	stop();

	refreshPL();
}

/*scriptGroup.onResize(int x, int y, int w, int h) {
	//int selectorwidth = selector.getguiw();
	//string currenttrack = PlEdit.getTitle(pltoptrack);
	string currenttrack = dummy.getText();

	int tracklenght = System.strlen(currenttrack);
	int groupwidth = w - 98;

	if (groupwidth <= tracklenght) { elipsis.show(); }
	else { elipsis.hide(); }
}*/

scriptGroup.onSetVisible(int on) {
	if (on) {
		pltoptrack = currSel = PlEdit.getCurrentIndex ();
		plslider.setXMLParam("y", IntegertoString(pltoptrack));
		refreshPL();
	}
}

refreshPL() {
	text temp;
	text templen;

	texth = dummy.getAutoHeight() - linespace;
	lenw = dummy.getAutoWidth();
	numlines = scriptGroup.getHeight() / texth + 1;
	int c = 0, b = 0;
	string currparam = "", par, val;

	selector.setXMLParam("h",integertostring(texth));
	selector.setXMLParam("y","-20");

	if (plslider.getXMLParam("visible")=="1") {
		selector.setXMLParam("w",integertostring(-plslider.getguiw()+1));
		if (mousetrap) mousetrap.setXMLParam("w",integertostring(-plslider.getguiw()+1));
	}

	int numtracks = pledit.getNumTracks();
	if ((numtracks - numlines) > 0) {
		int plsliderh = 7;

		if (plslider.getXMLParam("visible")=="1") {
			if (numtracks > 0) {
				plsliderh = scriptGroup.getHeight()*numlines/numtracks;
			} else {
				plsliderh = scriptGroup.getHeight();
			}

			if (plsliderh < 20) plsliderh = 20;
			if (plsliderh > scriptGroup.getHeight()) plsliderh = scriptGroup.getHeight();

			plslider.setXMLParam("h", integertostring(plsliderh));
			if (numtracks > 0) {
				plslider.setXMLParam("y", integertostring((scriptGroup.getHeight()-plsliderh) * (pltoptrack*texth + pltopMod)/ ((numtracks - numlines)*texth)));
			} else {
				plslider.setXMLParam("y", "0");
			}
		}
	}

	for (c = 0; c <= numlines; c++) {
		int trackc = c+pltoptrack;
		temp = NULL;
		temp = scriptGroup.getObject("line"+integertostring(c));
		if (!temp) {
			temp = new text;
			temp.init(scriptGroup);

			temp.setXMLParam("id","line"+integertostring(c));
			temp.setXMLParam("x","1");
			if (plslider.getXMLParam("visible")=="1")
				temp.setXMLParam("w",integertostring(-lenw-plslider.getguiw()+1));
			else
				temp.setXMLParam("w",integertostring(-lenw));
			temp.setXMLParam("h",integertostring(texth));
			temp.setXMLParam("relatw","1");
			temp.setXMLParam("rectrgn","1");
			temp.setXMLParam("move","0");
			temp.setXMLParam("ghost","1");
			temp.setXMLParam("ticker","0");
		}

		templen = NULL;
		templen = scriptGroup.getObject("len"+integertostring(c));
		if (!templen) {
			templen = new text;
			templen.init(scriptGroup);

			templen.setXMLParam("id","len"+integertostring(c));
			if (plslider.getXMLParam("visible")=="1")
				templen.setXMLParam("x",integertostring(-lenw-4-plslider.getguiw()));
			else
				templen.setXMLParam("x",integertostring(-lenw+1));
			templen.setXMLParam("w",integertostring(lenw));
			templen.setXMLParam("h",integertostring(texth));
			templen.setXMLParam("relatx","1");
			templen.setXMLParam("rectrgn","1");
			templen.setXMLParam("align","right");
			templen.setXMLParam("move","0");
			templen.setXMLParam("ghost","1");
			templen.setXMLParam("ticker","0");

			b = 0;
			do {
				currparam = getToken(xuiparams,";",b);
				b++;

				if (currparam!="") {
					par = getToken(currparam,"=",0);
					val = getToken(currparam,"=",1);
					
					temp.setXMLParam(par, val);
					templen.setXMLParam(par, val);
				}
			} while (currparam!="");
		}

		if (trackc == currSel) {
			temp.setXMLParam("color",selcolor);
			templen.setXMLParam("color",selcolor);
			selector.setXMLParam("y",integertostring(c*texth - pltopMod));
			selector.show();
		}

		if ((c+pltoptrack) == PlEdit.getCurrentIndex ()) {
			temp.setXMLParam("color",playcolor);
			templen.setXMLParam("color",playcolor);
		} else  {
			temp.setXMLParam("color",textcolor);
			templen.setXMLParam("color",textcolor);
		}

		temp.setXMLParam("y",integertostring(c*texth - pltopMod));
		templen.setXMLParam("y",integertostring(c*texth - pltopMod));

		if ((trackc < numtracks) && (trackc >= 0)) {
			temp.setText(integertostring(trackc+1)+". "+PlEdit.getTitle(trackc));
			templen.setText(PlEdit.getLength(trackc));
		} else {
			temp.setText(" ");
			templen.setText(" ");
		}
	}

	if (currMaxLines < numlines) currMaxLines = numlines;
	currNumLines = numlines;

	if (!scrollAnim.isRunning() && !mousePressed) {
		if (pltoptrack < 0) {
			targetPLTop = 0;
			noSlow = 0;
			scrollSpeed = texth;
			scrollDir = SCROLL_UP;
			scrollAnim.start();
		}
		if ((pltoptrack + numlines - 2) >= numtracks && numlines < numtracks) {
			targetPLTop = numtracks - numlines + 1;
			noSlow = 0;
			scrollSpeed = texth;
			scrollDir = SCROLL_DOWN;
			scrollAnim.start();
		}
	} else {
		// set private int only if list is not animating
		
		setPrivateInt(getSkinName(),"PLTopTrack",pltoptrack);
		setPrivateInt(getSkinName(),"PLCurrSel",currSel);
	}
}

scrollAnim.onTimer() {
	int currtoppix = (pltoptrack*texth + pltopMod);
	int targetpix = targetPLTop*texth;
	int speed;

	speed = (targetpix-currtoppix)*0.2;
	if (speed < 0) speed = -speed;

	if (speed > scrollSpeed) speed = scrollSpeed;
	if (noSlow) speed = scrollSpeed;

	if (speed < 1) speed = 1;

	if (scrollDir == SCROLL_UP) {
		pltoptrack = currtoppix+speed;
		if (targetpix <= pltoptrack) {
			pltoptrack = targetpix;
			stop();
		}
	}

	if (scrollDir == SCROLL_DOWN) {
		pltoptrack = currtoppix-speed;
		if (targetpix >= pltoptrack) {
			pltoptrack = targetpix;
			stop();
		}
	}

	pltopMod = pltoptrack % texth;
	pltoptrack = pltoptrack / texth;

	refreshPL();
}

System.onTitleChange(String newtitle) {
	if (scrollAnim.isRunning()) return;

	pltoptrack = currSel = PlEdit.getCurrentIndex();

	plslider.setXMLParam("y", IntegertoString(pltoptrack));

	refreshPL();
}

parentLayout.onMouseWheelUp(int clicked , int lines) {
	sendAction("PLSCROLLUP", "", 0, 0, clicked, lines);

	int ret = getPrivateInt(getSkinName(),"WheelReturn",0);

	if (!scriptGroup.isVisible()) return ret;
	if (!mousetrap.isMouseOverRect()) return ret;

	pltoptrack = pltoptrack - lines;
	pltopMod = 0;

	if (pltoptrack < -4) pltoptrack = -4;

	if (scrollAnim.isRunning()) scrollAnim.stop();

	currSel--;
	if (currSel < 0) currSel = 0;

	if (currSel < pltoptrack) {
		pltoptrack = currSel;
		pltopMod = 0;
	}

	if ((currSel - pltoptrack + 2) > numlines) {
		pltoptrack = currSel-numlines+2;
		pltopMod = 0;
	}

	plslider.setXMLParam("y", IntegertoString(pltoptrack));

	refreshPL();

	return 1;
}

parentLayout.onMouseWheelDown(int clicked , int lines) {
	sendAction("PLSCROLLDOWN", "", 0, 0, clicked, lines);

	int ret = getPrivateInt(getSkinName(),"WheelReturn",0);

	if (!scriptGroup.isVisible()) return ret;
	if (!mousetrap.isMouseOverRect()) return ret;

	pltoptrack = pltoptrack + lines;
	pltopMod = 0;

	if (pltoptrack > (pledit.getNumTracks() - numlines +4)) pltoptrack = pledit.getNumTracks() - numlines +4;

	if (scrollAnim.isRunning()) scrollAnim.stop();

	currSel++;
	if (currSel >= pledit.getNumTracks()) currSel = pledit.getNumTracks()-1;

	if (currSel < pltoptrack) {
		pltoptrack = currSel;
		pltopMod = 0;
	}

	if ((currSel - pltoptrack + 2) > numlines) {
		pltoptrack = currSel-numlines+2;
		pltopMod = 0;
	}

	plslider.setXMLParam("y", IntegertoString(pltoptrack));

	refreshPL();

	return 1;
}

system.onKeyDown(string key) {
	if (!parentLayout.isActive()) return;
	if (!scriptGroup.isVisible()) return;
	if (delayOnLoad.isRunning()) return;

	key = strlower(key);

	if (key == "up") {
		currSel--;
		if (currSel < 0) currSel = 0;

		if (currSel < pltoptrack) {
			pltoptrack = currSel;
			pltopMod = 0;
		}

		if ((currSel - pltoptrack + 2) > numlines) {
			pltoptrack = currSel-numlines+2;
			pltopMod = 0;
		}

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "down") {
		currSel++;
		if (currSel >= pledit.getNumTracks()) currSel = pledit.getNumTracks()-1;

		if (currSel < pltoptrack) {
			pltoptrack = currSel;
			pltopMod = 0;
		}

		if ((currSel - pltoptrack + 2) > numlines) {
			pltoptrack = currSel-numlines+2;
			pltopMod = 0;
		}

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "pgup") {
		currSel = currSel - numlines;
		if (currSel < 0) currSel = 0;

		if (currSel < pltoptrack) {
			pltoptrack = currSel;
			pltopMod = 0;
		}

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "pgdn") {
		currSel = currSel + numlines;
		if (currSel >= pledit.getNumTracks()) currSel = pledit.getNumTracks()-1;

		if (currSel < pltoptrack) {
			pltoptrack = currSel;
			pltopMod = 0;
		}

		if ((currSel - pltoptrack + 2) > numlines) {
			pltoptrack = currSel-numlines+2;
			pltopMod = 0;
		}

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "home") {
		pltoptrack = 0;
		pltopMod = 0;
		currSel = 0;

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "end") {
		currSel = pledit.getNumTracks()-1;
		pltoptrack = pledit.getNumTracks()-numlines+1;
		pltopMod = 0;
		if (pltoptrack < 0) pltoptrack = 0;

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "return") {
		pledit.playTrack(currSel);

		if (currSel < pltoptrack) {
			pltoptrack = currSel;
			pltopMod = 0;
		}

		if ((currSel - pltoptrack + 2) > numlines) {
			pltoptrack = currSel-numlines+2;
			pltopMod = 0;
		}

		if (scrollAnim.isRunning()) scrollAnim.stop();
		refreshPL();

		complete;
	} else if (key == "del") {
		if (scrollAnim.isRunning()) scrollAnim.stop();
		pledit.removeTrack(currSel);

		complete;
	} else {
		return;
	}

	setPrivateInt(getSkinName(),"PLTopTrack",pltoptrack);
	//setPrivateInt(getSkinName(),"PLCurrSel",currSel);
}

mousetrap.onRightButtonUp(int x, int y) {
	pledit.playTrack(currSel);

	if (currSel < pltoptrack)
	{
		pltoptrack = currSel;
		pltopMod = 0;
	}

	if ((currSel - pltoptrack + 2) > numlines)
	{
		pltoptrack = currSel-numlines+2;
		pltopMod = 0;
	}

	if (scrollAnim.isRunning()) scrollAnim.stop();

	refreshPL();
	complete;
}

System.onSetXuiParam(String param, String value) {
	param = strlower(param);
	if (param=="linespacing") {
		linespace = stringtointeger(value);
	} else if (param=="playcolor") {
		playcolor = value;
	} else if (param=="color") {
		textcolor = value;
	} else {
		xuiparams = xuiparams + param + "=" + value + ";";
		dummy.setXMLParam(param, value);
	}
}

System.onAccelerator(String action, String section, String key) {
	if (action == "HOTKEY_SHADETOGGLEPL") {
		if (layoutPLNormal.isActive())
			containerPL.switchToLayout("shade");
		else
			containerPL.switchToLayout("normalpl");
		complete;
	}
}