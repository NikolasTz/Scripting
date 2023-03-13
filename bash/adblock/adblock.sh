#!/bin/bash
# You are NOT allowed to change the files' names!
domainNames="domainNames.txt"
IPAddresses="IPAddresses.txt"
adblockRules="adblockRules"

function adBlock() {

    if [ "$EUID" -ne 0 ];then
        printf "Please run as root.\n"
        exit 1
    fi
    if [ "$1" = "-domains"  ]; then

        # Resolving every domain name in domainNames.txt
        for line in $(cat $domainNames) 
        do
            if [ -z "${line}" ]; then # empty line , skip!!!
                continue
            fi

            # Resolving
            host -t A $line | awk '/has address/ { print $4 }'

        done > $IPAddresses

        # Append rules to INPUT chain of filter table for every IP address
        for host_addr in $(cat $IPAddresses) 
        do
            if [ -z "${host_addr}" ]; then # empty line , skip!!!
                continue
            fi

            # Append rule to INPUT chain
            iptables -t filter -A INPUT -s $host_addr -j REJECT
        done
        true       
    elif [ "$1" = "-ips"  ]; then
        
        # Configure adblock rules based on the IP addresses of $IPAddresses file
        # Append rules to INPUT chain of filter table for every IP address of IPAddresses.txt file
        for host_addr in $(cat $IPAddresses) 
        do
            if [ -z "${host_addr}" ]; then # empty line , skip!!!
                continue
            fi

            # Append rule to INPUT chain
            iptables -t filter -A INPUT -s $host_addr -j REJECT
        done
        true    
    elif [ "$1" = "-save"  ]; then

        # Save rules to $adblockRules file.
        iptables-save > ./adblockRules
        true       
    elif [ "$1" = "-load"  ]; then

        # Load rules from $adblockRules file
        iptables-restore < ./adblockRules
        true
    elif [ "$1" = "-reset"  ]; then

        # Reset rules to default settings (i.e. accept all).
        # Flush all rules from INPUT chain of filter table
        iptables -t filter -F INPUT
        true      
    elif [ "$1" = "-list"  ]; then

        # List current rules
        iptables -t filter -L INPUT -n -v --line-numbers
        true   
    elif [ "$1" = "-help"  ]; then
        printf "This script is responsible for creating a simple adblock mechanism. It rejects connections from specific domain names or IP addresses using iptables.\n\n"
        printf "Usage: $0  [OPTION]\n\n"
        printf "Options:\n\n"
        printf "  -domains\t  Configure adblock rules based on the domain names of '$domainNames' file.\n"
        printf "  -ips\t\t  Configure adblock rules based on the IP addresses of '$IPAddresses' file.\n"
        printf "  -save\t\t  Save rules to '$adblockRules' file.\n"
        printf "  -load\t\t  Load rules from '$adblockRules' file.\n"
        printf "  -list\t\t  List current rules.\n"
        printf "  -reset\t  Reset rules to default settings (i.e. accept all).\n"
        printf "  -help\t\t  Display this help and exit.\n"
        exit 0
    else
        printf "Wrong argument. Exiting...\n"
        exit 1
    fi
}

adBlock $1
exit 0