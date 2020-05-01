/*---------------------------------------------------
Author:		Victhor
---------------------------------------------------*/

#include "std.mi"

Global Group scriptGroup;
Global Button Donate, DeviantArt, Zsolt;


System.onScriptLoaded ()
{
	scriptGroup = getScriptGroup();
  Donate = scriptGroup.findObject("link.donate");
  Zsolt = scriptGroup.findObject("link.zsolt");
  DeviantArt = scriptGroup.findObject("link.deviantart");
}


Donate.onLeftClick()
{
	System.navigateUrlBrowser("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=H2NNRMPGKKVDA");
	//System.navigateUrlBrowser("https://www.paypal.me/victorbrocaz"); // Should I use this?
	//return 1;
	complete;
}


DeviantArt.onLeftClick()
{
	System.navigateUrlBrowser("https://www.deviantart.com/victhor");
	complete;
}

Zsolt.onLeftClick()
{
	System.navigateUrlBrowser("http://www.trn.hu");
	complete;
}