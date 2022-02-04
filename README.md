# Nexys Video Design Debugger

The purpose of this component is to allow students to take their instantiated designs for the Nexys video board and debug them.

Despite extensive workbench testing, it is difficult to write test suites that check for every possible scenario. In fact, this is a widely researched subject in the areas of computer science, software engineering, and cybersecurity. As a result, despite best efforts it can be significantly challenging to determine the cause of unexpected malfunction with a synthesized design. This project makes it possible for a user to instantiate a simple component which allows for desired data values to be sent from a running design to the user's computer, where the data can be examined using Wireshark.

## Usage

All inputs and outputs to the main component can be directly mapped to their respective pins (ethernet has ~11 pins alone), excepting two which are used by the user: payload and pkt_sent_n. Furthermore, payload makes use of the generic N which must be port-mapped when instantiating the component. 

Payload is the data payload of the packet to be sent and is N bits. The maximum size of this payload is 1024 bits and can be comprised of any arbitrary binary data as formatted by the user. Thus, the signal or value mapped to payload in the port map must be a standard logic vector with bits N-1 down to 0. 

Finally, the pkt_sent_n can be thought of as a reset low line for queued data to be transmitted. This line goes low after a packet with a data payload has been sent out, informing the system that the ethernet transmitter is ready for the next packet's data payload and otherwise remains high when the line is currently transmitting.

The largest issue with this system is that the ordering of the packets cannot be used to recreate the original data. The connection is UDP, so any packets dropped for whatever reason are not retransmitted. As a result, if you choose to use this system to check values which may change during the operation of the design, it is highly recommended that some form of time stamping or further context (like the current value for whatever signal/input causes the changes) is included with the data. Another simpler approach is creating logic which checks for a particular value associated with a desired state and only outputting that value down the data line. If the value appears in a packet, you know that part of the logic is working correctly.
