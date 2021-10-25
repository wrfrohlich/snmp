#!/bin/bash

HOST=$1
VERS=$2
DEST=$3
COMM=$4

INX='"wrfrohlich"."1"'
CRED1="-v2c -c"
CRED2="-r0"

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-PING-MIB::pingCtlRowStatus.$INX = destroy \

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-PING-MIB::pingCtlRowStatus.$INX = createAndWait \

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-PING-MIB::pingCtlTargetAddressType.$INX = $VERS \
    DISMAN-PING-MIB::pingCtlTargetAddress.$INX = $DEST \
    DISMAN-PING-MIB::pingCtlDataSize.$INX = 1000 \
    DISMAN-PING-MIB::pingCtlProbeCount.$INX = 500 \
    DISMAN-PING-MIB::pingCtlAdminStatus.$INX = enabled

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-PING-MIB::pingCtlRowStatus.$INX = active \

sleep 3

snmptable $CRED1 $COMM $CRED2 -Cb -Cw 120 $HOST DISMAN-PING-MIB::pingCtlTable
snmptable $CRED1 $COMM $CRED2 -Cib -Cw 120 $HOST DISMAN-PING-MIB::pingResultsTable
snmptable $CRED1 $COMM $CRED2 -Cib -Cw 120 $HOST DISMAN-PING-MIB::pingProbeHistoryTable
