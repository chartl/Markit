import boto.sdb
import sys

def get_test_items():
 item1 = {'iliasbeshimov':{'urls':['http://itunes.apple.com/app1','http://itunes.apple.com/app2','http://itunes.apple.com/HAHA_NOT_AN_APP_YOU_FOOL'],'uname':'ilias','prefs':{}}}
 item2 = {'chartl':{'urls':['http://itunes.apple.com/npr'],'uname':'chartl','prefs':{}}}
 return [item1,item2]

def test_add_items(db_domain):
 for item in get_test_items():
  for username in item.keys(): # the test items are dictionaries to allow for testing a batch of usernames rather than a single one
   db_domain.put_attributes(username,item[username])

def test_retrieve_items(db_domain,db_domain_meta):
 expected = sum(map(lambda item: len(item.keys()),get_test_items())) # lambda function takes an item to the number of usernames it holds, then that is summed
 if ( expected != db_domain_meta.item_count ):
  print("WARNING: Item count is not as expected. Wanted " + str(expected) + " but observed "+str(db_domain_meta.item_count))
 print(db_domain.get_item('iliasbeshimov'))
 print(db_domain.get_item('chartl'))

if __name__ == "__main__":
 access_id = raw_input("Enter your AWS access ID: ")
 access_key = raw_input("Enter your AWS access KEY: ")

 conn = boto.sdb.connect_to_region('us-west-2',aws_access_key_id=access_id,aws_secret_access_key=access_key)

 all_domains = conn.get_all_domains()

 print("The domains available are: ")
 print(all_domains)
 user_domain = raw_input("Choose a domain or select NEW: ")
 if ( user_domain == "NEW" ):
  user_domain = raw_input("Enter a name for the NEW domain: ")
  conn.create_domain(user_domain)
 domain = conn.get_domain(user_domain)
 print("You are now on domain: "+str(domain))
 domain_metadata = conn.domain_metadata(domain)
 test_add_items(domain)
 test_retrieve_items(domain,domain_metadata)

 # issue a simple query
 query = 'select * from `' + user_domain + '`'
 result = domain.select(query)
 for record in result:
  print(record)
