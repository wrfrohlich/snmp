#!/bin/bash

HOST=$1
VERS=$2
DEST=$3
COMM=$4

INX='"wrfrohlich"."1"'
CRED1="-v2c -c"
CRED2="-r0"

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlRowStatus.$INX = destroy \

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlRowStatus.$INX = createAndWait \

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlTargetAddressType.$INX = $VERS \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlTargetAddress.$INX = $DEST \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlAdminStatus.$INX = enabled

snmpset $CRED1 $COMM $CRED2 $HOST \
    DISMAN-TRACEROUTE-MIB::traceRouteCtlRowStatus.$INX = active

sleep 120

snmptable $CRED1 $COMM $CRED2 -Cb -Cw 120 $HOST DISMAN-TRACEROUTE-MIB::traceRouteCtlTable
snmptable $CRED1 $COMM $CRED2 -Cib -Cw 120 $HOST DISMAN-TRACEROUTE-MIB::traceRouteResultsTable
snmptable $CRED1 $COMM $CRED2 -Cib -Cw 120 $HOST DISMAN-TRACEROUTE-MIB::traceRouteProbeHistoryTable
