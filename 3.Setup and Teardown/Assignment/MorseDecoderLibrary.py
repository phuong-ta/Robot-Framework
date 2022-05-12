import serial

class MorseDecoderLibrary(object):
    ''' Library for interacting with morse sender and decoder
    '''
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def __init__(self, port1, port2):
        self._sender = serial.Serial(port1, 115200, timeout = 1)
        self._decoder = serial.Serial(port2, 115200, timeout = 20)

    def set_speed(self, speed):
        self._sender.write(bytes('wpm ' + speed + '\n', 'utf-8'))

    def send_text(self, text):
        self._decoder.reset_input_buffer()
        self._sender.write(bytes("text " + text + '\n', 'utf-8'))

    def speed_should_be(self, expected_speed):
        self._decoder.write(bytes('WPM\n', 'utf-8'))
        text1 = self._decoder.readline().strip().decode('utf-8')
        speed = int(text1[7:9])
        if speed != int(expected_speed):
            raise AssertionError('Expected: ' + str(expected_speed) + ' got: '  + str(speed) + ' line: ' + text1)

    def text_should_be(self, expected_text):
        text = self._decoder.readline().strip().decode('utf-8')
        if text != expected_text:
            raise AssertionError('Expected: ' + expected_text + ' got: ' + text) 

    def set_wpm(self, controller):
        self._decoder.write(bytes('wpm ' + controller + '\n', 'utf-8'))
        text = self._decoder.readline().strip().decode('utf-8')
        if (text != '[ Print WPM is {} ]'.format(controller)):
            raise AssertionError('WPM output wasnt turned {} as its supposed to be'.format(controller))

    def set_imm(self, controller):
        self._decoder.write(bytes('IMM ' + controller + '\n', 'utf-8'))
        text = self._decoder.readline().strip().decode('utf-8')
        if (text != '[ Immediate output is {} ]'.format(controller)):
            raise AssertionError('Immediate output wasnt turned {} as its supposed to be'.format(controller))
