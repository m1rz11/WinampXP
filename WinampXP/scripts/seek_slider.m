Function initSeekSlider();
Function sliderSeekOnSetPositionUtil(Slider sliderGhost, Int intPosition);

Global Slider sliderMainNormalSeek;
Global Slider sliderMainShadeSeek;
Global Boolean boolSeeking;

initSeekSlider() {
	sliderMainNormalSeek = layoutMainNormal.findObject("player.slider.seek");
	sliderMainShadeSeek = layoutMainShade.findObject("player.slider.seek");
}

sliderMainNormalSeek.onSetPosition(Int intPosition) { sliderSeekOnSetPositionUtil(sliderMainNormalSeek, intPosition); }
sliderMainShadeSeek.onSetPosition(Int intPosition) { sliderSeekOnSetPositionUtil(sliderMainShadeSeek, intPosition); }

sliderSeekOnSetPositionUtil(Slider sliderGhost, Int intPosition) {
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