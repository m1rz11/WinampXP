Function initSeekSlider();
Function sliderSeekGhostOnSetPositionUtil(Slider sliderGhost, Int intPosition);

Global Slider sliderMainNormalSeek, sliderMainNormalSeekGhost;
Global Slider sliderMainShadeSeek, sliderMainShadeSeekGhost;
Global Boolean boolSeeking;

initSeekSlider() {
	sliderMainNormalSeek = layoutMainNormal.findObject("player.slider.seek");
	sliderMainNormalSeekGhost = layoutMainNormal.findObject("player.slider.seek.ghost");
	
	sliderMainShadeSeek = layoutMainShade.findObject("player.slider.seek");
	sliderMainShadeSeekGhost = layoutMainShade.findObject("player.slider.seek.ghost");
	

	sliderMainNormalSeekGhost.setAlpha(1);
	sliderMainShadeSeekGhost.setAlpha(1);
}

sliderMainNormalSeek.onLeftButtonDown(Int intPosX, Int intPosY) { boolSeeking = true; }
sliderMainNormalSeek.onLeftButtonUp(Int intPosX, Int intPosY) { boolSeeking = false; }

sliderMainShadeSeek.onLeftButtonDown(Int intPosX, Int intPosY) { boolSeeking = true; }
sliderMainShadeSeek.onLeftButtonUp(Int intPosX, Int intPosY) { boolSeeking = false; }

sliderMainNormalSeekGhost.onLeftButtonDown(Int intPosX, Int intPosY) { sliderMainNormalSeekGhost.setAlpha(128); }
sliderMainNormalSeekGhost.onLeftButtonUp(Int intPosX, Int intPosY) { sliderMainNormalSeekGhost.setAlpha(1); }

sliderMainShadeSeekGhost.onLeftButtonDown(Int intPosX, Int intPosY) { sliderMainShadeSeekGhost.setAlpha(128); }
sliderMainShadeSeekGhost.onLeftButtonUp(Int intPosX, Int intPosY) { sliderMainShadeSeekGhost.setAlpha(1); }

sliderMainNormalSeekGhost.onSetFinalPosition(Int intPostion) { sliderMainNormalSeekGhost.setAlpha(1); }
sliderMainShadeSeekGhost.onSetFinalPosition(Int intPostion) { sliderMainShadeSeekGhost.setAlpha(1); }

sliderMainNormalSeekGhost.onSetPosition(Int intPosition) { sliderSeekGhostOnSetPositionUtil(sliderMainNormalSeekGhost, intPosition); }
sliderMainShadeSeekGhost.onSetPosition(Int intPosition) { sliderSeekGhostOnSetPositionUtil(sliderMainShadeSeekGhost, intPosition); }

sliderSeekGhostOnSetPositionUtil(Slider sliderGhost, Int intPosition) {
	if (sliderGhost.getAlpha() == 1) {
		return;
	}
	Float floatPlayItemLength = System.getPlayItemLength();
	if (floatPlayItemLength > 0) {

    Float f;
		f = intPosition;
		f = f / 255 * 100;
		
		Float floatPositionPercentage = intPosition / 255 * 100;
		Int intNewPosition = floatPlayItemLength * floatPositionPercentage / 100;
		showActionInfo("Seek to: " + System.integerToTime(intNewPosition) + " / " + System.integerToTime(floatPlayItemLength) +" ("+ integerToString(f) +"%)");
	}
}