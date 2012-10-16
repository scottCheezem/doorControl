#include <Servo.h>
 
 
 
Servo myservo;
 
boolean lockState = false;
 
 
 
volatile int pos = 90;
 
int lockedAngle = pos;
int unlockedAngle = 0;
int theta = 5;
 
const int toggleButton = 3;
 
const int greenLed = 4;
const int redLed = 5;
 
volatile int toggleRead = 0;
int digitick = 0;
 
 
 
 
void unlock(){
 
  lockState = false;
  digitalWrite(redLed,LOW);
  digitalWrite(greenLed, HIGH); 
  //Serial.println("unlocked");
  Serial.print("lockState:");
  if(lockState){
  Serial.println("true");
  }else{
    Serial.println("false");
  }
  while(pos < lockedAngle){
    pos+=theta;
    myservo.write(pos);
    //Serial.println(pos);
    delay(15);
  }
  delay(200); 
 
}
 
void lock(){
 
 lockState = true; 
  digitalWrite(greenLed, LOW);
  digitalWrite(redLed, HIGH);
  //Serial.println("locked");
  Serial.print("lockState:");
  if(lockState){
  Serial.println("true");
  }else{
  Serial.println("false");
  }
  while(pos>unlockedAngle){
    pos-=theta;
    myservo.write(pos);
    //Serial.println(pos);
    delay(15);
  }
  delay(200);  
   
}
 
void lockToggle(){
 if(lockState){
    unlock();
 }else{
  lock();
 } 
  
  
}
 
void setInterruptFlag(){
 toggleRead = 1; 
}
 
 
 
void setup(){
  Serial.begin(9600);
  myservo.attach(9);
  //pinMode(unlockButton, INPUT);
  //pinMode(lockButton, INPUT);
  
  pinMode(toggleButton, INPUT);
  
  //attachInterrupt(3, setInterruptFlag, RISING);
 
  pinMode(greenLed, OUTPUT);
  pinMode(redLed, OUTPUT);
  myservo.write(pos);
  digitalWrite(greenLed, HIGH);
  Serial.println("Starting");
}
  
  
void loop(){
  //unlocked = digitalRead(unlockButton);
  //locked = digitalRead(lockButton); 
  
  //toggleRead = digitalRead(toggleButton);
  
   
  
  

 byte val = 0;
 
 
while(Serial.available()) {
  val = Serial.read();
  //Serial.println(val);
  delay(200);
  
  if (val == 'e'){
   Serial.println("exit"); 
  }else if(val == '.'){
    //Serial.println(".");
     lockToggle();
  }else if(val == 'U'){
    //Serial.println("unlocking via remote command");
      unlock();
  }else if(val == 'L'){
    //Serial.println("locking via remote command");
      lock();
  }else if(val == '?'){
      if(lockState){
        Serial.println("lockstate:true");
      }else{
        Serial.println("lockstate:false");
      }
    
  }
  
  delay(200);
}
  
  
  delay(200);
  
  
  if(digitalRead(3) == HIGH){
    Serial.println("button HIGH");
    //digitick+=1;
    digitalWrite(redLed, HIGH);
    lockToggle();
    
    delay(500);
     
  }
    
}
