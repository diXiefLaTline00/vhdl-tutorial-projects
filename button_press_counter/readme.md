Button press counter functions as the name suggests. A user presses a button and the module records the number of times it was pressed. A second button is used to reset the count. This project implements an 8 bit counter, meaning that the count rolls over everytime the user presses the button 255 times. What a lot of work to get to that point!

This project demonstrates two pieces of knowledge: a button bouncing method and a counter method. Synthesized code is tested on the DE0-Nano and 
module:
    inputs: keys, clock, count_reset
    output: 8 bit register with 