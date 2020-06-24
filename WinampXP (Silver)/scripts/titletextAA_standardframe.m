#include "lib/std.mi"

//this disables title text antialiasing for windows that use standardframe

Global Group groupStandardFrame;
Global Group groupStandardFrameTitlebar;
Global Text StandardFrameTitle;

System.onScriptLoaded(){
  groupStandardFrame = System.getScriptGroup();
  groupStandardFrameTitlebar = groupStandardFrame.findObject("wasabi.titlebar");

  StandardFrameTitle = groupStandardFrameTitlebar.getObject("window.titlebar.title.dropshadow");
  StandardFrameTitle.setXmlParam("antialias", "0");
  }
