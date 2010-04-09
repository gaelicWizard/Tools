#!/bin/bash

ORIGTIME="$(echo "$1" | cut -c 2-12)"
ADDTOTIME="$(echo "$2" | cut -c 2-12)"

ORIGFRAME="$(echo "$ORIGTIME" | cut -c 10-11)"
if [ "$(echo "$ORIGFRAME" | cut -c 1)" == 0 ]
then
    ORIGFRAME="$(echo "$ORIGFRAME" | cut -c 2)"
fi
ADDTOFRAME="$(echo "$ADDTOTIME" | cut -c 10-11)"
if [ "$(echo "$ADDTOFRAME" | cut -c 1)" == 0 ]
then
    ADDTOFRAME="$(echo "$ADDTOFRAME" | cut -c 2)"
fi

ORIGSEC="$(echo "$ORIGTIME" | cut -c 7-8)"
if [ "$(echo "$ORIGSEC" | cut -c 1)" == 0 ]
then
    ORIGSEC="$(echo "$ORIGSEC" | cut -c 2)"
fi
ADDTOSEC="$(echo "$ADDTOTIME" | cut -c 7-8)"
if [ "$(echo "$ADDTOSEC" | cut -c 1)" == 0 ]
then
    ADDTOSEC="$(echo "$ADDTOSEC" | cut -c 2)"
fi

ORIGMIN="$(echo "$ORIGTIME" | cut -c 4-5)"
if [ "$(echo "$ORIGMIN" | cut -c 1)" == 0 ]
then
    ORIGMIN="$(echo "$ORIGMIN" | cut -c 2)"
fi
ADDTOMIN="$(echo "$ADDTOTIME" | cut -c 4-5)"
if [ "$(echo "$ADDTOMIN" | cut -c 1)" == 0 ]
then
    ADDTOMIN="$(echo "$ADDTOMIN" | cut -c 2)"
fi

ORIGHOUR="$(echo "$ORIGTIME" | cut -c 1-2)"
if [ "$(echo "$ORIGHOUR" | cut -c 1)" == 0 ]
then
    ORIGHOUR="$(echo "$ORIGHOUR" | cut -c 2)"
fi
ADDTOHOUR="$(echo "$ADDTOTIME" | cut -c 1-2)"
if [ "$(echo "$ADDTOHOUR" | cut -c 1)" == 0 ]
then
    ADDTOHOUR="$(echo "$ADDTOHOUR" | cut -c 2)"
fi

NEWFRAME="$(echo "$(($ORIGFRAME + $ADDTOFRAME))")"
NEWSEC="$(echo "$(($ORIGSEC + $ADDTOSEC))")"
NEWMIN="$(echo "$(($ORIGMIN + $ADDTOMIN))")"
NEWHOUR="$(echo "$(($ORIGHOUR + $ADDTOHOUR))")"


if [ "$NEWFRAME" -ge 24 ]
then
    NEWFRAME="$(($NEWFRAME - 24))"
    NEWSEC="$(($NEWSEC + 1))"
fi

if [ "$NEWSEC" -ge 60 ]
then
    NEWSEC="$(($NEWSEC - 60))"
    NEWMIN="$(($NEWMIN + 1))"
fi

if [ "$NEWMIN" -ge 60 ]
then
    NEWMIN="$(($NEWMIN - 60))"
    NEWHOUR="$(($NEWHOUR + 1))"
fi

if [ "$NEWFRAME" -lt 10 ]
then
    NEWFRAME="0$NEWFRAME"
fi

if [ "$NEWSEC" -lt 10 ]
then
    NEWSEC="0$NEWSEC"
fi

if [ "$NEWMIN" -lt 10 ]
then
    NEWMIN="0$NEWMIN"
fi

if [ "$NEWHOUR" -lt 10 ]
then
    NEWHOUR="0$NEWHOUR"
fi

NEWTIME="$NEWHOUR:$NEWMIN:$NEWSEC.$NEWFRAME"

echo "[$NEWTIME]"
