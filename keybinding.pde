void keyPressed() {
  if(PLAYTESTING) return;
  if (key != CODED) {
    // println(key);
    switch(key) {
        case('0'): startUpLoaded = true; goToStage(0); break;  // Blackout
        case('1'): startUpLoaded = true; goToStage(1); break;  // "Await input"
        case('2'): startUpLoaded = true; goToStage(2); break;  // "startup"
        case('3'): startUpLoaded = true; goToStage(3); break;  // Curves without user
        case('4'): startUpLoaded = true; goToStage(4); break;  // Curves with user
        case('5'): startUpLoaded = true; goToStage(5); break;  // Success!
        case('6'): startUpLoaded = true; goToStage(6); break;  // Elisas thoughts
        default: startUpLoaded = true; goToStage(0); break;
        //case('1'):myKnobA.setValue(180);break;
        //case('2'):myKnobB.setConstrained(false).hideTickMarks().snapToTickMarks(false);break;
        //case('3'):myKnobA.shuffle();myKnobB.shuffle();break;
    }
  } else {
    // println(keyCode);
    switch(keyCode) {
        case(39): startUpLoaded = true; nextStage(); break;
        case(37): startUpLoaded = true; prevStage(); break;
    }
  }
}

/*  void keyPressed() {
   if(keyCode == 10) {  // Enter
     if(message.length() > 0) {
       udp.send(message, ip, port );   // the message to send
       feedback("Enter pressed, message sent: " + message, 0,255,0);
       message = "";
     } else {
       feedback("Empty message ignored", 255,0,0);
     }
   } else if (keyCode == 8 ) {  //  backspace
     if(message.length() > 0) {
       message = message.substring(0, message.length() - 1);
     }
     feedback("Message to send: '" +message+"'");
   } else if (keyCode == 127 ) {  //  delete
     message = "";
     feedback("Message to send: '" +message+"'");
   } else if (key != CODED) {   // if printable
     message += str(key);
     feedback("Message to send: '" +message+"'");
   } else {
     feedback("Non-printing character ignored", 255,0,0);
   }
 } */
 