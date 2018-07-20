import hpglgraphics.*;

String file="output.hpgl";
//String file="scorpion.hpgl";
String[] commands;

Plotter plotter;
Serial port;
int lf = 10;      // CII linefeed

void initPlotter(){
    String portName = Serial.list()[0];
  
  port = new Serial(this, portName, 9600);
  port.bufferUntil(lf);
  
  plotter = new Plotter(port);
}


void setup(){
  size(10,80);
  initPlotter();
  
  commands = loadStrings(file);
   
  plotter.plotCommands(commands);
}