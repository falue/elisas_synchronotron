 import hypermedia.net.*;  // for UDP communication
 UDP udp;  // define the UDP object
 String message = "";

// for ip & port see elisas_synchronotron
 
 // TEST CONENCTION IN TERMINAL
 // nc -u -l 8888
 // this listens to UDP on port 8888 on its own network.

 void udpSetup() {
    udp = new UDP( this, portIncoming );  // create a new datagram connection on port 6000
    udp.log( true );     // <-- printout the connection activity
    udp.listen( true );           // and wait for incoming message
 }


  //void receive( byte[] data ) {       // <-- default handler
  void receive( byte[] data, String ip, int port ) {  // <-- extended handler
   String message = "";
   for(int i=0; i < data.length; i++) {
     message += char(data[i]);
   }
   println("Received package on "+ip+" from port "+port+": "+message);

   // Have to use byte-wise comparison of byte array "data"
   //   because "message" and a comparable string is somehow not the same

   if(Arrays.equals(data, "sync_stage0".getBytes())) { goToStage(0); }       // Blackout
   else if(Arrays.equals(data, "sync_stage1".getBytes())) { goToStage(1); }  // "Await input"
   else if(Arrays.equals(data, "sync_stage2".getBytes())) { goToStage(2); }  // "startup"
   else if(Arrays.equals(data, "sync_stage3".getBytes())) { goToStage(3); }  // Curves without user
   else if(Arrays.equals(data, "sync_stage4".getBytes())) { goToStage(4); }  // Curves with user
   else if(Arrays.equals(data, "sync_stage5".getBytes())) { goToStage(5); }  // Success!
   else if(Arrays.equals(data, "sync_stage6".getBytes())) { goToStage(6); }  // Elisas thoughts
   else { println("Message was not for me :("); }
 }