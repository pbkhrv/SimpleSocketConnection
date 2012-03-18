SimpleSocketConnection is an iPhone app that allows you to connect to a simple TCP/IP server and send/receive messages.

Its purpose is to demonstrate a couple of things:

1. A good way to separate your networking code from the rest of your application.
2. How to use NSStreams to work with TCP/IP connections.
3. How to use Objective-C blocks to handle high-level network events.


### Running a server using netcat

In order to fully use the app, you will need a server to connect to.
The easiest way to create a TCP/IP server is a command-line utility called 'nc' (or netcat) that comes with OS X:

1. Open your OS X terminal and run the following command:

       nc -k -l 45678


### Running the app in Simulator

Launch SimpleSocketConnection in iPhone Simulator on the same Mac that 'nc' is running on and tap 'Connect'.


### Running the app on iPhone

Connection information is specified in the code. Address is "localhost" and port is 45678 
("localhost" generally means "same computer/device").

Since you'll be running the server piece on your Mac and SimpleSocketConnection app on your iPhone, you will need to change "localhost" to another value:

1. Connect your iPhone to Wi-Fi (same network as the Mac that's running 'nc') and find out IP address of your iPhone.
2. In Xcode, open NetworkController.m, search for "host =" and replace the word 'localhost' with the IP address of your iPhone.
3. Build and deploy SimpleSocketConnection, launch it on the iPhone and tap 'Connect'.
