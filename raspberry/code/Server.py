from flask import Flask
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.cleanup()
GPIO.setup(11, GPIO.OUT)

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World'
    
@app.route('/on')
def on():
    GPIO.setup(11, GPIO.OUT)
    GPIO.output(11, GPIO.HIGH)
    return "On"
    
@app.route('/off')
def off():
    GPIO.setup(11, GPIO.OUT)
    GPIO.output(11, GPIO.LOW)
    return "Off"
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')