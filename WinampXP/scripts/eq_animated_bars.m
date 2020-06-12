//----------------------------------------------------------------------
//    eq_layers.m
//    A Script By ThePlague
//    Edited by Doug Halamay for use of AnimatedLayers
//    This script animates the bars underneath your eq sliders, just like WA2.xx
//
//----------------------------------------------------------------------

#include "std.mi"

Function updateSlider(int number, int value);

Global Boolean ResetClicked=0, Load;

Global Group ScriptGroup;
Global Slider pre, eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10;
Global AnimatedLayer pre_layer, eq1back, eq2back, eq3back, eq4back, eq5back, eq6back, eq7back, eq8back, eq9back, eq10back;

Global Button butSetMax, butReset, butSetMin;

System.onScriptLoaded() {

  ScriptGroup = getScriptGroup();

  pre = ScriptGroup.findObject("preamp");
  pre_layer = ScriptGroup.findObject("preamp_layer");
  eq1 = ScriptGroup.findObject("eq1");
  eq1back = ScriptGroup.findObject("eq1.bg");
  eq2 = ScriptGroup.findObject("eq2");
  eq2back = ScriptGroup.findObject("eq2.bg");
  eq3 = ScriptGroup.findObject("eq3");
  eq3back = ScriptGroup.findObject("eq3.bg");
  eq4 = ScriptGroup.findObject("eq4");
  eq4back = ScriptGroup.findObject("eq4.bg");
  eq5 = ScriptGroup.findObject("eq5");
  eq5back = ScriptGroup.findObject("eq5.bg");
  eq6 = ScriptGroup.findObject("eq6");
  eq6back = ScriptGroup.findObject("eq6.bg");
  eq7 = ScriptGroup.findObject("eq7");
  eq7back = ScriptGroup.findObject("eq7.bg");
  eq8 = ScriptGroup.findObject("eq8");
  eq8back = ScriptGroup.findObject("eq8.bg");
  eq9 = ScriptGroup.findObject("eq9");
  eq9back = ScriptGroup.findObject("eq9.bg");
  eq10 = ScriptGroup.findObject("eq10");
  eq10back = ScriptGroup.findObject("eq10.bg");

  butSetMax = ScriptGroup.findObject("EQ_p12");
  butReset  = ScriptGroup.findObject("EQ_0");
  butSetMin = ScriptGroup.findObject("EQ_m12");

  Load=1;
  for (int i=0; i<=10; i++) updateSlider(i,0);
  Load=0;
}

updateSlider(int number, int value) {
  Slider sliTemp;
  AnimatedLayer lyrTemp;

  if (number==0) { sliTemp=pre; lyrTemp=pre_layer; }
  if (number==1) { sliTemp=eq1; lyrTemp=eq1back; } if (number==2) { sliTemp=eq2; lyrTemp=eq2back; }
  if (number==3) { sliTemp=eq3; lyrTemp=eq3back; } if (number==4) { sliTemp=eq4; lyrTemp=eq4back; }
  if (number==5) { sliTemp=eq5; lyrTemp=eq5back; } if (number==6) { sliTemp=eq6; lyrTemp=eq6back; }
  if (number==7) { sliTemp=eq7; lyrTemp=eq7back; } if (number==8) { sliTemp=eq8; lyrTemp=eq8back; }
  if (number==9) { sliTemp=eq9; lyrTemp=eq9back; } if (number==10) { sliTemp=eq10; lyrTemp=eq10back; }

  if (ResetClicked) {
	sliTemp.setPosition(value);
	lyrTemp.goToFrame(((sliTemp.getPosition()+127)/255)*27);
}

  if (Load) lyrtemp.goToFrame(((sliTemp.getPosition()+127)/255)*27);
  else lyrtemp.goToFrame(((value+127)/255)*27);
}

System.onEqBandChanged(int band, int newvalue){
if(!ResetClicked) updateSlider(band+1,newvalue);
}

System.onEqPreampChanged(int newvalue){
if(!ResetClicked) updateSlider(0,newvalue);
}

butSetMax.onLeftClick() {
  ResetClicked=1;
  for (int i=1; i<=10; i++) updateSlider(i,127);
  ResetClicked=0;
}

butReset.onLeftClick() {
  ResetClicked=1;
  for (int i=1; i<=10; i++) updateSlider(i,0);
  ResetClicked=0;
}

butSetMin.onLeftClick() {
  ResetClicked=1;
  for (int i=1; i<=10; i++) updateSlider(i,-127);
  ResetClicked=0;
}