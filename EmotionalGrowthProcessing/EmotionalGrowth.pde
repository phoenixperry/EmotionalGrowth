import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.awt.*;
import processing.net.*;

//this stuff receives from wek 
OscP5 oscP5; 
NetAddress myBroadcastLocation; 

//this sends to as3 
Server myServer;
int port = 3333;

int low, high; 


//info from Arudio 
float xpos = 0.0f; 
float ypos = 0.0f; 
//this is the udp port 
//Variables for Sending
byte zero = 0;

 void setup(){
 	//note 12000 is wek default - this val 
 	//is for oscelton and requres changing in wek
	oscP5 = new OscP5(this, 7110); 
	myBroadcastLocation = new NetAddress("127.0.0.1", 6448); 	
	myServer = new Server(this,port);
}

void draw(){
		
}


  void oscEvent(OscMessage theOscMessage) {
   if (theOscMessage.checkAddrPattern("/OSCSynth/params")==true) {

       if(theOscMessage.checkTypetag("ff")) { //looking for 1 parameter
          float receivedValue1 = theOscMessage.get(0).floatValue(); //get this parameter
     
       //   println("Received new params value from Wekinator");
          //Check value within acceptable bounds, and threshold if necessary
	          if (receivedValue1 == 0) {
	 				low = 0 ;
	 				high = 1; 
	 				println("high");
	          }else { 
	          	low = 1; 
	          	high = 0; 
	          	println("low");   
	          	}
	 		myServer.write(low+","); 
	        myServer.write(high+","); 
	        
	  		//don't forget the all important terminator for the server! 
	        myServer.write(zero);
	        
	        } 
        }
     }
  //end of receive funtion 
void sendOsc() {
 // println("Sending");
  OscMessage msg = new OscMessage("/oscCustomFeatures");
  for (int i= 0; i < features.length; i++){
     // println(features[0]);
      msg.add(features[i]);
  }
  oscP5.send(msg, myBroadcastLocation);
}

