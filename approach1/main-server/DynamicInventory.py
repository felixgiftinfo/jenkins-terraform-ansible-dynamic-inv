#!/bin/python

import pprint
import boto3
import json

AWS_REGION = "us-east-1"

def getgroupofhosts(ec2):
    allgroups = {}
    filters = [{'Name': 'instance-state-name', 'Values': ['running']}]
    filters.append({'Name':'key-name', 'Values': ['*ansible*']})
    filters.append({'Name': 'tag:Name', 'Values': ['ansible-node*']})
    filters.append({'Name': 'instance-type', 'Values': ['t3.micro']})

    for each_in in ec2.instances.filter(Filters=filters):
     
        for tag in each_in.tags:
            if tag["Key"] in allgroups:
                hosts = allgroups.get(tag["Key"])
                hosts.append(each_in.public_ip_address)
                allgroups[tag["Key"]] = hosts
            else:
                hosts = [each_in.public_ip_address]
                allgroups[tag["Key"]] = hosts
            
            if tag["Value"] in allgroups:
                hosts = allgroups.get(tag["Value"]) 
                hosts.append(each_in.public_ip_address)
                allgroups[tag["Value"]] = hosts
            else:
                hosts = [each_in.public_ip_address]
                allgroups[tag["Value"]] = hosts

    return allgroups

def main():
    ec2 = boto3.resource("ec2", region_name=AWS_REGION)
    all_groups = getgroupofhosts(ec2)
    inventory = {}
    for key, value in all_groups.items():
        hostsobj = {'hosts' : value}
        inventory[key] = hostsobj
    print(json.dumps(inventory))

if __name__ == "__main__":
    main()
