/*
===============================================================================
 Name        : main.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : main definition
===============================================================================
 */

#if defined (__USE_LPCOPEN)
#if defined(NO_BOARD_LIB)
#include "chip.h"
#else
#include "board.h"
#endif
#endif

#include <cr_section_macros.h>

// TODO: insert other include files here
#include <cstdio>
#include <cctype>
#include <cstring>
#include "heap_lock_monitor.h"
#include "LpcUart.h"
#include "DigitalIoPin.h"
#include "morse_codes.h"
// TODO: insert other definitions and declarations here


#define LINE_SIZE 80

void vUartTask(void *pvParameters);

DigitalIoPin *morse_tx;

int main(void) {

#if defined (__USE_LPCOPEN)
	// Read clock settings and update SystemCoreClock variable
	SystemCoreClockUpdate();
#if !defined(NO_BOARD_LIB)
	// Set up and initialize all required blocks and
	// functions related to the board hardware
	Board_Init();
	// Set the LED to the state of "On"
	Board_LED_Set(0, true);
#endif
#endif

	// TODO: insert code here
	heap_monitor_setup();
	/* Set up SWO to PIO1_2 to enable ITM */
	Chip_SWM_MovablePortPinAssign(SWM_SWO_O, 1, 2);

	morse_tx = new DigitalIoPin(0, 8, DigitalIoPin::output, false);
	morse_tx->write(0);

	/* UART->morse transmitter */
	xTaskCreate(vUartTask, "morse",
			configMINIMAL_STACK_SIZE * 5, NULL, (tskIDLE_PRIORITY + 1UL),
			(TaskHandle_t *) NULL);

	/* Start the scheduler */
	vTaskStartScheduler();

	/* Should never arrive here */
	return 0 ;
}






void morse_symbol(char c, int dot_length)
{
	int k = 0;
	int i = 0;
	bool match = false;

	if(c == ' ') {
		morse_tx->write(0);
		// add four more to get standard word gap (we have a gap of three at the end of previous letter)
		vTaskDelay(DOT * dot_length * 4);
	}
	else {
		do {
			// linear search for morse code
			for(k = 0; ITU_morse[k].symbol != 0; k++) {
				if(ITU_morse[k].symbol == c) {
					for(i = 0; ITU_morse[k].code[i] != 0; i++) {
						morse_tx->write(1);
						vTaskDelay(ITU_morse[k].code[i] * dot_length);
						morse_tx->write(0);
						vTaskDelay(DOT * dot_length); // intra character gap
					}
					vTaskDelay(2 * DOT * dot_length); // add two more to get short gap at the end of letter
					match = true;
					break;
				}
			}
			c = 'X'; // this will be used on the second round if no match was found
		} while(!match);
	}
}


void morse_send(const char *str, int dot_length)
{
	int i;

	for(i = 0; str[i] != 0; i++) {
		morse_symbol(toupper((int)str[i]), dot_length);
	}

}

void send_test(int code)
{
	switch(code) {
	case 1:
		morse_send("Hello, World!", 100);
		break;
	case 2:
		morse_send("SOS", 300);
		break;
	case 3:
		morse_send("Welcome to Hawaiji and have a nice holiday", 15);
		break;
	case 4:
		morse_send("abcdef ghijk lmnopqrstu vwxyz 1234 567890", 40);
		break;
	case 5:
		morse_send("abcdef ghijk lmnopqrstu vwxyz 1234 567890", 6);
		break;
	}
}

void vUartTask(void *pvParameters)
{
	LpcPinMap none = { .port = -1, .pin = -1}; // unused pin has negative values in it
	LpcPinMap txpin1 = { 0, 18 }; // transmit pin that goes to debugger's UART->USB converter
	LpcPinMap rxpin1 = { 0, 13 }; // receive pin that goes to debugger's UART->USB converter
	//LpcPinMap txpin1 = { .port = 0, .pin = 10 }; // transmit pin that goes to Arduino D4
	//LpcPinMap rxpin1 = { .port = 0, .pin = 9 }; // receive pin that goes to Arduino D3
	LpcUartConfig cfg1 = {
			.pUART = LPC_USART0,
			.speed = 115200,
			.data = UART_CFG_DATALEN_8 | UART_CFG_PARITY_NONE | UART_CFG_STOPLEN_1,
			.rs485 = false,
			.tx = txpin1,
			.rx = rxpin1,
			.rts = none,
			.cts = none
	};
	LpcUart dbgu(cfg1);
	char str[LINE_SIZE];
	int count = 0;

	char rcv[LINE_SIZE];
	int pos = 0;
	int speed = 100;


	dbgu.write("Boot\r\n");

	while (1) {
		count = dbgu.read(str, 80, portTICK_PERIOD_MS * 100);
		if(count > 0) {
			for(int i=0; i < count; ++i) {
				char ch = str[i];
				if(ch != 0) {
					if(ch == '\r' || ch == '\n') {
						// crude command parser
						if(strncmp(rcv, "TEXT ", 5)== 0) {
							morse_send(rcv+5, speed);
						}
						else if(strstr(rcv, "WPM ") != NULL) {
							int wpm = 10;
							if(sscanf(rcv+4, "%d", &wpm)==1) {
								speed = 1000 / wpm;
							}
						}
						else if(strstr(rcv, "TEST ") != NULL) {
							int code = 0;
							if(sscanf(rcv+5, "%d", &code)==1) {
								send_test(code);
							}
						}

						// clear
						rcv[0] = '\0';
						pos = 0;
					}
					else {
						if(ch == 127) { /* backspace handling */
							if(pos > 0) {
								--pos;
							}
						}
						else {
							if(isspace(ch)) ch = ' '; // convert all white space to spaces
							rcv[pos++] = toupper(ch); // store in upper case
							if(pos >= LINE_SIZE) --pos;
						}
						rcv[pos] = '\0';
					}
				}
			}
		}
		else {
			/* receive timed out */
		}
	}
}
