#!/bin/sh
devnum=`xinput list | grep SynPS/2 | sed "s/.*id=\([0-9]*\).*/\1/"`
tapping=`xinput list-props $devnum | grep "Tapping Enabled (" | sed "s/.*(\([0-9]*\)).*/\1/"`
xinput set-prop $devnum $tapping 1
NaturalScrolle=`xinput list-props $devnum | grep "Natural Scrolling Enabled (" | sed "s/.*(\([0-9]*\)).*/\1/"`
xinput set-prop $devnum $NaturalScrolle 1