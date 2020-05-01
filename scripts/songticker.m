Function init_Songticker();
Function unloadSongticker();

#include "lib/std.mi"
#include "attribs.m"


Function updateTickerScrolling();


init_Songticker ()
{
	initAttribs();


	updateTickerScrolling();
}


unloadSongticker ()
{
// nada
}

ScrollingAttribute.onDataChanged () 
{
	updateTickerScrolling();
}

updateTickerScrolling ()
{
	if (textNormalSongInfo == NULL)
	{
		return;
	}

	if (songticker_scrolling_disabled_attrib.getData() == "1")
	{ textNormalSongInfo.setXMLParam("ticker", "off"); textShadeSongInfo.setXMLParam("ticker", "off");
	}
	if (songticker_scrolling_modern_attrib.getData() == "1")
	{ textNormalSongInfo.setXMLParam("ticker", "bounce"); textShadeSongInfo.setXMLParam("ticker", "bounce");
	}
	if (songticker_scrolling_classic_attrib.getData() == "1")
	{ textNormalSongInfo.setXMLParam("ticker", "scroll"); textShadeSongInfo.setXMLParam("ticker", "scroll");
	}

}



songticker_scrolling_disabled_attrib.onDataChanged()
{
	if (attribs_mychange) return;
	NOOFF
	attribs_mychange = 1;
	songticker_scrolling_modern_attrib.setData("0");
	songticker_scrolling_classic_attrib.setData("0");
	attribs_mychange = 0;
}

songticker_scrolling_classic_attrib.onDataChanged()
{
	if (attribs_mychange) return;
	NOOFF
	attribs_mychange = 1;
	songticker_scrolling_modern_attrib.setData("0");
	songticker_scrolling_disabled_attrib.setData("0");
	attribs_mychange = 0;
}

songticker_scrolling_modern_attrib.onDataChanged()
{
	if (attribs_mychange) return;
	NOOFF
	attribs_mychange = 1;
	songticker_scrolling_disabled_attrib.setData("0");
	songticker_scrolling_classic_attrib.setData("0");
	attribs_mychange = 0;
}