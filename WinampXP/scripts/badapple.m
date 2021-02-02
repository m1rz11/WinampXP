#include "lib/std.mi"

Global Text mainText;
Global Timer mainTimer;

Global int frameNumber, frameCount;

Global List frameList;

System.onScriptLoaded() {
  //xml stuff
  Group scriptgroup = getScriptGroup();
  mainText = scriptgroup.getObject("badapple_text");

  //create new list
  frameList = new List;

  //add frames to list
  frameList.addItem("O");
  frameList.addItem(" O");
  frameList.addItem("  O");
  frameList.addItem("   O");
  frameList.addItem("    O");
  frameList.addItem("     O");
  frameList.addItem("      O");
  frameList.addItem("       O");
  frameList.addItem("        O");
  frameList.addItem("       O");
  frameList.addItem("      O");
  frameList.addItem("     O");
  frameList.addItem("    O");
  frameList.addItem("   O");
  frameList.addItem("  O");
  frameList.addItem(" O");

  //starting frame
  frameNumber = 0;
  //frame count is length of frameList
  frameCount = frameList.getNumItems();

  //update timer
  mainTimer = new Timer;
  mainTimer.setDelay(66);
  mainTimer.start();
}

mainTimer.onTimer(){
  //get correct frame number with modulo
  int frameNum = frameNumber%frameCount;
  //set text
  mainText.setXmlParam("text", "frame " + integerToString(frameNum+1) + "/" + integerToString(frameCount) + ", time: " + integerToString(frameNumber) + "\n" + frameList.enumItem(frameNum));
  //add 1 to framenumber
  frameNumber++;
}