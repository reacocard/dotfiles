#!/usr/bin/env python2

import sys, os
import socket
import time
import pynotify
import getopt
import commands

# even in Python this is globally nasty :), do something nicer in your own code
capabilities = {'actions':                         False,
                'body':                            False,
                'body-hyperlinks':                 False,
                'body-images':                     False,
                'body-markup':                     False,
                'icon-multi':                      False,
                'icon-static':                     False,
                'sound':                           False,
                'image/svg+xml':                   False,
                'x-canonical-private-synchronous': False,
                'x-canonical-append':              False,
                'x-canonical-private-icon-only':   False,
                'x-canonical-truncation':          False}

icons = {
        60  : "notification-audio-volume-high",
        25  : "notification-audio-volume-medium",
        1   : "notification-audio-volume-low",
        0   : "notification-audio-volume-off",
        }

mute_icon = "notification-audio-volume-muted"

def initCaps():
    caps = pynotify.get_server_caps ()
    if caps is None:
        print "Failed to receive server caps."
        sys.exit (1)

    for cap in caps:
        capabilities[cap] = True

def initNotify():
    if not pynotify.init ("icon-value"):
        sys.exit (1) 


def pushNotification (icon, value):
    n = pynotify.Notification ("Volume", 
                               "",
                               icon);
    n.set_hint_int32 ("value", value);
    n.set_hint_string ("x-canonical-private-synchronous", "");
    n.show ()

def amixerControl(command):
    t = commands.getoutput(command)
    line = t.split("\n")[-1].split("]")
    muted = line[-2][-3:] == "off"
    try:
        currvol = int(line[-4].split("[")[-1][:-1])
    except:
        currvol = 0
    return currvol, muted


def process_command(opt):
    try:
        vol = 0
        muted = None

        if "m" == opt:
            vol, muted = amixerControl("amixer set Master toggle")
        elif "i" == opt:
            vol, muted = amixerControl("amixer set Master 3%+")
        elif "d" == opt:
            vol, muted = amixerControl("amixer set Master 3%-")

        if muted:
            icon = mute_icon
            vol = 0
        else:
            icos = icons.keys()
            icos.sort()
            icon = icons[[ i for i in icos if i <= vol ][-1]]

        pushNotification(icon, vol)
    except:
        import traceback
        print traceback.format_exc()

if __name__ == "__main__":
    initNotify()
    initCaps()

    disp = os.getenv("DISPLAY")
    if not disp:
        print "DISPLAY not set, exiting..."
        exit()
    sockpath = os.path.join(os.path.expanduser("~"), ".volcontrol-%s.sock"%disp)
    #sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        os.remove(sockpath)
    except OSError:
        pass
    #sock.bind(sockpath)
    #sock.listen(1)
    fifo = os.mkfifo(sockpath)
    while True:
        f = open(sockpath, "r")
        while True:
            data = f.read(1)
            if not data:
                break
            if data in "mid":
                process_command(data)
        f.close()
