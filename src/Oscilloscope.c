#include "Oled.h"
#include "Analog.h"

void Oscilloscope() {

int i = 0;
float scale = 1;
int del = 1;
for(;;) {
		Clear_Screen();

		uint16_t oldv = 0;
		uint16_t trg = 256;
		for(;;) {
			uint16_t newv = ADC1ConvertedValue[2];
			if(newv > trg && oldv < trg || newv < trg && oldv > trg)
				break;
			oldv = newv;
		}

		
			


		for(i=0; i<96; ++i) {
			uint8_t v = ADC1ConvertedValue[2] / (4096 / 16) * scale; //range 0..15
			uint8_t ul = 0;
			if(v > 7)ul = (1 << (7-(v-8)));
			uint8_t ll = 0;
			if(v < 8)ll = (1 << (7-v));
			displayBuffer[i] = ul;
			displayBuffer[i+96] = ll;
			delayMs(del);
		}
		
		uint8_t buttons = getButtons(); //read the buttons status
		if(buttons == BUT_A){ 
			int8_t accy = getY();
			scale = 0.0625 * accy;

			int8_t accx = getX();
			del = 1 + -(accx+16) / 8;
			displayBuffer[0] = 0x1;
		}

		OLED_Sync();
	}
}
