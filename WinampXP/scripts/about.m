/*---------------------------------------------------
Author:		Victhor
---------------------------------------------------*/

#include "lib/std.mi"

Global Group scriptGroup;
Global Button link1,link2,link3,link4,link5;


System.onScriptLoaded ()
{
	scriptGroup = getScriptGroup();
  link1 = scriptGroup.findObject("link1");
  link2 = scriptGroup.findObject("link2");
  link3 = scriptGroup.findObject("link3");
  link4 = scriptGroup.findObject("link4");
  link5 = scriptGroup.findObject("link5");
}


link1.onLeftClick()
{
	System.navigateUrlBrowser("https://www.deviantart.com/victhor/art/Winamp-Classic-Modern-805797724");
	complete;
}

link2.onLeftClick()
{
	System.navigateUrlBrowser("https://github.com/mirzi1");
	complete;
}

link3.onLeftClick()
{
	System.navigateUrlBrowser("https://github.com/0x5066");
	complete;
}

link4.onLeftClick()
{
	System.navigateUrlBrowser("https://github.com/mirzi1/WinampXP");
	complete;
}

link5.onLeftClick()
{
	System.navigateUrlBrowser("https://github.com/teil-aidcx");
	complete;
}