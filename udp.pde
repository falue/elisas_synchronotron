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

  if(Arrays.equals(data, "sync_stage0".getBytes())) {
    // Blackout
    startUpLoaded = true;
    goToStage(0);
  
  } else if(Arrays.equals(data, "sync_stage1".getBytes())) {
    // "Await input"
    startUpLoaded = true;
    goToStage(1);
  
  } else if(Arrays.equals(data, "sync_stage2".getBytes())) {
    // "startup"
    startUpLoaded = true;
    goToStage(2);
  
  } else if(Arrays.equals(data, "sync_stage3".getBytes())) {
    // Curves without user
    startUpLoaded = true;
    goToStage(3);
  
  } else if(Arrays.equals(data, "sync_stage4".getBytes())) {
    // Curves with user
    startUpLoaded = true;
    goToStage(4);
  
  } else if(Arrays.equals(data, "sync_stage5".getBytes())) {
    // Success!
    startUpLoaded = true;
    goToStage(5);
  
  } else if(Arrays.equals(data, "sync_stage6".getBytes())) {
    // Elisas thoughts
    startUpLoaded = true;
    goToStage(6);
  
  } else if(Arrays.equals(data, "sync_skipLoading".getBytes())) {
    // Abort loading if stuck
     println("Aborted Loading by dungeon master");
     startUpLoaded = true;
     goToStage(0);
     udp.send("sync_ready", remoteIp, remotePort);
  } else {
    println("Message was not for me :(");
  }
 }