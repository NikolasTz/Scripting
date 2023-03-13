


## Description

This tool is the implementation of a simple adblocking mechanism. For the implementation of tool were used the iptables,iptables-save,iptables-restore commands.


## Implementation

```
domainNames

For resolving the domainName was used the host command option -t(only IPv4 addresses)
The IPv4 addresses are written to the IPAddresses.txt file and after the adblock rules are configured 

```


## Tool Specifications

```
Options:
        -domains  Configure adblock rules based on the domain names of domainNames file
        -ips Configure adblock rules based on the IP addresses of IPAddresses file
        -save Save rules to $adblockRules file
        -load  Load rules from adblockRules file
        -list  List current rules
        -reset  Reset rules to default settings (i.e. accept all)
        -help  Display this help and exit

```

## Compilation and Execution

#### Requirements: Any Linux distribution

#### Run

    sudo path_to_file/adblock.sh -option , requires root privileges
