from wsgiref.simple_server import make_server, demo_app

def serve_page(env,start_response):
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

httpd = make_server('',80,serve_page)
print "Serving HTTP on port 5804"

httpd.serve_forever()
