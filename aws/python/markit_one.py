from wsgiref.simple_server import make_server, demo_app
import boto.sdb
import traceback
import sys

def _test_serve_page(env,start_response):
 start_response('200 OK',[('Content-Type','text/html')])
 response_body = open("foo.html").readlines()
 print "environment: ", str(env)
 method = env['REQUEST_METHOD']
 if ( method == 'POST' ):
  try:
   _post_size = int(env['CONTENT_LENGTH'])
   _post_body = env['wsgi.input'].read(_post_size)
  except TypeError,ValueError:
   _post_body = '0'
  print str(_post_body)
 return response_body

def _init_db(settings="/home/ec2-user/serversettings.cfg"):
 '''
 Initialize the Amazon SimpleDB with which to communicate information.

 This function reads the settings file to determine domain and login.
 '''
 db_settings = dict(map(lambda keyval:
    keyval.strip().split(":"), open(settings)))
 connection = boto.sdb.connect_to_region(db_settings['region'],
          aws_access_key_id=db_settings['key_id'],
          aws_secret_access_key=db_settings['key'])
 all_domains_str = set(map(str,connection.get_all_domains()))
 wanted_domain = "Domain:%s" % db_settings['domain']
 if ( wanted_domain not in all_domains_str ):
  connection.create_domain(db_settings['domain'])
 domain = connection.get_domain(db_settings['domain'])
 return connection,domain,db_settings['kill_command']

def _serve_db_post(env,start_response):
 global db_con,db_domain,db_kill
 start_response('204 No Content',[('Content-Type','text/html')])
 response_body = []
 if ( env['REQUEST_METHOD'] == 'POST' ):
  try:
   _post_size = int(env['CONTENT_LENGTH'])
   _post_body = env['wsgi.input'].read(_post_size)
  except TypeError,ValueError:
   _post_body = '0'
  __db_process(_post_body,db_con,db_domain,db_kill)
 return response_body

def _log_payload(payload):
 for item in payload.split(","):
  print(item)

def __db_process(payload,conn,domain,killword):
 _log_payload(payload)
 if payload == '0':
  return
 items = payload.split(",")
 user = items[0]
 url = items[1]
 print(items)
 print(url)
 user_record = domain.get_item(user)
 if not user_record:
  try:
   domain.put_attributes(user,{'urls':['None']}) # todo -- should be able to send an empty list there
   user_record = domain.get_item(user,consistent_read=True)
  except Exception, e:
   exc_type, exc_value, exc_traceback = sys.exc_info()
   errorText = ""
   errorText += "".join(traceback.format_exception(exc_type,exc_value,exc_traceback))
   print(errorText)
   raise AssertionError(repr(e))
  
 user_record['urls'] = map(str,user_record['urls']) + [url] # todo the map here winds up being over the string. Figure out the right way (bookmark limit and empty dict perhaps?) 
 print(user_record['urls'])
 user_record.save()
 print(domain.get_item(user,consistent_read=True))
 
if __name__ == "__main__":
 global db_con,db_domain,db_kill
 db_con,db_domain,db_kill = _init_db()
 httpd = make_server('',80,_serve_db_post)
 print "Serving HTTP on port 5804"

 httpd.serve_forever()
