import processing.serial.*;

class Plotter {
  Serial port;
  //Plotter dimensions
  int xMin = 170;
  int yMin = 602;
  int xMax = 15370;
  int yMax = 10602;
  int val;
  
  int bufferResponseDelay = 15;  // How long to wait after sending the ESC.B command to the printer before reading a response.  Can get away with 0.
  int bufferFullDelay = 15; // How long to wait if the printers available buffer is below the bufferFullLimit before checking again.  Can get away with 0.
    // Note: Some printers report a smaller buffer size for each command asking for the buffer even though documentation mentions that data commands should not
    //       interfer with the printing operation... currently unsure if this is a bug in my code, in my printer, or if it really causes an issue.
    
  int bufferFullLimit = 64; // If the buffer reports its free size is below this value we consider the buffer full.

  boolean PLOTTING_ENABLED=true;

  StringList hpglBuffer;


  Plotter(Serial _port) {
    port = _port;
  }


  void write(String hpgl) {
    if (PLOTTING_ENABLED) {

      port.write(hpgl);
    } else {
      hpglBuffer.append(hpgl);
    }
  }

  boolean bufferFree() {
    byte[] x = new byte[4];
    x[0]=27;
    x[1]='.';
    x[2]='B'; 
    x[3]=';';
    port.write(x);
    delay(bufferResponseDelay);


    String s = "";
    int remaining=0;

    while (plotter.port.available()>0) {
      s = port.readStringUntil(13);
      if (s!=null) {
        remaining = int(s.substring(0, s.length()-1));
      }
    }
    
    if (remaining < bufferFullLimit) {
      return false;
    }

    return true;
  }

  void plotCommands(String[] commands) {
    boolean hasRoom = false;
    println("Plotting ", commands.length, " commands");

    for (int i=0; i < commands.length; i++) {

      write(commands[i]);

      hasRoom = bufferFree();
      while (!hasRoom) {
        delay(0);
        hasRoom=bufferFree();
      }
    }
    
  }
}
