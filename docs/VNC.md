
# Setting Remote Desktop

## Seting x11vnc server
~~~

# install
$ sudo apt-get install x11vnc

# set password 
$ x11vnc -storepasswd

<you will enter a password>


# launch
$ x11vnc -usepw

<you will get port no of x11vnc.>

~~~

## Preparing of client  

- Real VNC (windows client)
https://www.realvnc.com/en/connect/download/viewer/

- Install and launch in default settings. 
- Then, connect "<your remote machine ip>:5900" and enter above the password.

## Tips 

- If you cannot use 5900 port in your environment, you may use ssh fowarding.
- Below is an example of ssh config. 
  Of cource, you can use your favorite your terminal - putty, teraterm.

.ssh/config
~~~
Host <your host setting>
  LocalForward localhost:5900 localhost:5900
~~~

