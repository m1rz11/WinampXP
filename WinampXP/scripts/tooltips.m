#include "lib/std.mi"

Global Group tipGroup;
Global Text tipText;

System.onScriptLoaded() {
  tipGroup = getScriptGroup();
  tipText = tipGroup.getObject("tooltip.text");

  tipGroup.setXmlParam("h", "17"); //Vic trick: Setting this via XML is ignored, but the script does the job! Yay!
}

// When text is changed, resize the group accordingly and make sure it's fully visible

tipText.onTextChanged(String newtext) {
  int x = getMousePosX();
  int y = getMousePosY()+21;

  int vpleft = getViewportLeftFromPoint(x, y);
  int vptop = getViewportTopFromPoint(x, y);
  int vpright = vpleft+getViewportWidthFromPoint(x, y);
  int vpbottom = vptop+getViewportHeightFromPoint(x, y);

  int w = getTextWidth()+1;
  int h = tipGroup.getHeight();

  if (x + w > vpright) x = vpright - w;
  if (x < vpleft) x = vpleft;
  if (x + w > vpright) { w = vpright-vpleft-64; x = 32; }
  if (y + h > vpbottom) y = vpbottom - h;
  if (y < vptop) y = vptop + 32; // avoid mouse
  if (y + h > vpbottom) { h = vpbottom-vptop-64; y = 32; }

  tipGroup.resize(x, y, w, h);
}