import socket
import boto.sdb

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

def _init_socket(settings="/home/ec2-user/serversettings.cfg"):
 '''
 Initialize the socket listener to listen for incoming data
 and database commands.
 '''
 settings = dict(map(lambda kv: kv.split(":"),open(settings)))
 soc = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
 soc.bind((settings['listener_address'],int(settings['tcp_port'])))
 return soc

def _process_data(data,db_conn,db_domain,logger):
 '''
 Process the database commands
 '''
 # for now just log the connection
 logger.write(str(data)+"\n")

if __name__ == "__main__":
 db_conn,db_domain,killword = _init_db()
 listener = _init_socket()
 logger = open('/home/ec2-user/connection.log','w')
 killed = False
 while not killed:
  listener.listen(1)
  soc_conn,addr = listener.accept()
  logger.write("Connection from :"+str(addr)+"\n")
  data = soc_conn.recv(1024)
  while data:
   if data == killword:
    killed = True
    logger.write("Killed!")
    break
   _process_data(data,db_conn,db_domain,logger)
   data = soc_conn.recv(1024)
