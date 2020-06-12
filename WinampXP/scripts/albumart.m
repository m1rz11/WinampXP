#include "std.mi"

Global AlbumArtLayer waaa;
Global Layout aalayout;

System.onScriptLoaded()
{
	Container albumart = System.getContainer("winamp.albumart");
	aalayout = albumart.getLayout("normal");
	waaa = getScriptGroup().findObject(getParam());
}

system.onScriptUnloading ()
{
	if (!aalayout) return;
	setPrivateInt(getSkinName(), "Album Art XPos", aalayout.getLeft());
	setPrivateInt(getSkinName(), "Album Art YPos", aalayout.getTop());
}

aalayout.onStartup ()
{
	resize(getPrivateInt(getSkinName(), "Album Art XPos", 0), getPrivateInt(getSkinName(), "Album Art YPos", 0), getWidth(), getHeight());
}


waaa.onRightButtonDown (int x, int y)
{
	popupmenu p = new popupmenu;

	p.addCommand("Refresh Album Art", 1, 0, 0);
	String path = getPath(getPlayItemMetaDataString("filename"));
	if(path != "")
	{
		p.addCommand("Open Folder", 2, 0, 0);
	}

	int result = p.popatmouse();
	delete p;

	if (result == 1)
	{
		waaa.refresh();
	}
	else if (result == 2)
	{
		if(path != "")
		{
			System.navigateUrl(path);
		}
		else
		{
			String url = getPlayItemMetaDataString("streamurl");
			if(url != "")
			{
				System.navigateUrl(url);
			}
		}
	}
}

waaa.onLeftButtonDblClk (int x, int y)
{
	String path = getPath(getPlayItemMetaDataString("filename"));
	if(path != "")
	{
		System.navigateUrl(path);
	}
	else
	{
		String url = getPlayItemMetaDataString("streamurl");
		if(url != "")
		{
			System.navigateUrl(url);
		}
	}
}