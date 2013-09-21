import boto.sdb
import sys

if __name__ == "__main__":
 access_id = raw_input("Enter your AWS access ID: ")
 access_key = raw_input("Enter your AWS access KEY: ")

 conn = boto.sdb.connect_to_region('us-west-2',aws_access_key_id=access_id,aws_secret_access_key=access_key)

 print(conn)
