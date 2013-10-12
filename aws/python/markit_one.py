from wsgiref.simple_server import make_server, demo_app
import boto.sdb
import traceback
import sys
import datetime

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

def _serve_db(env,start_response):
    global db_con,db_domain,db_kill
    if ( env['REQUEST_METHOD']=='POST' ):
        return _serve_db_post(env,start_response)
    elif ( env['REQUEST_METHOD'] == 'GET' ):
        return _serve_db_get(env,start_response)
    start_response('401 Bad request',[('Content-Type','text/html')])
    return []

def _serve_db_get(env,start_response):
    # the iPhone app makes http get requests, want to follow-up on the request and serve the data back
    try:
        _post_size = int(env['CONTENT_LENGTH']) if env['CONTENT_LENGTH'] else 0
        _post_body = env['wsgi.input'].read(_post_size)
    except TypeError,ValueError:
        _post_body = '0'
    ## now process the body



def _serve_db_post(env,start_response):
 global db_con,db_domain,db_kill
 start_response('204 No Content',[('Content-Type','text/html')])
 response_body = []
 if ( env['REQUEST_METHOD'] == 'POST' ):
  try:
   _post_size = int(env['CONTENT_LENGTH']) if env['CONTENT_LENGTH'] != '' else 0
   _post_body = env['wsgi.input'].read(_post_size)
  except TypeError,ValueError:
   _post_body = '0'
  __db_process_post(_post_body,db_con,db_domain,db_kill)
 return response_body

def _log_payload(payload):
 for item in payload.split(","):
  print(item)

def _init_user(db,username,meta_info=None):
    default_data = { 'username':username,'signup_date':str(datetime.date.today()),'apps':{'whatever':{'app_name':'markit','app_url':'whatever','app_number':1,'app_id':'whatever'}}}
    if meta_info:
        for meta_key in meta_info:
            default_data[meta_key]=meta_info[meta_key]
    db.put_attributes(username,default_data)

def _parse_app(app_info,num=1):
    return {'app_name':app_info[0],'app_url':app_info[1],'app_number':num,'app_id':app_info[1]} # for now identify apps based on iTunes URL

def __db_process_post(payload,conn,domain,killword):
 _log_payload(payload)
 if payload == '0':
  return
 items = payload.split(",")
 user = items.pop(0)
 app = _parse_app(items)
 user_record = domain.get_item(user)
 if not user_record:
  try:
   _init_user(domain,user)
   user_record = domain.get_item(user,consistent_read=True)
  except Exception, e:
   exc_type, exc_value, exc_traceback = sys.exc_info()
   errorText = ""
   errorText += "".join(traceback.format_exception(exc_type,exc_value,exc_traceback))
   print(errorText)
   raise AssertionError(repr(e))
  
 user_apps = eval(str(user_record['apps']))
 # now to add a new app, all the other apps need their numbers incremented
 for existing_app in user_apps:
     user_apps[existing_app]['app_number']+=1
 # now add the new app
 user_apps[app['app_id']]=app
 user_record['apps'] = user_apps
 user_record.save()
 print(domain.get_item(user,consistent_read=True))
 
if __name__ == "__main__":
 global db_con,db_domain,db_kill
 db_con,db_domain,db_kill = _init_db()
 httpd = make_server('',80,_serve_db)
 print "Serving HTTP on port 5804"

 httpd.serve_forever()
