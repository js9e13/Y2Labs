#include <avr/io.h>
#include <util/delay.h>

typedef volatile uint8_t * reg;

int main(void)
{
	MCUCR |= _BV(SRE);
	DDRD |= 0x01;
	reg p = (reg)0xFFAA;
	uint8_t x = 0x00;

	for (;;) {
		PORTD &= ~0x01;
		*p = x;
		PORTD |= 0x01;
		*p;
		x = ~x;
	}

	return 1;
}