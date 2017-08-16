**SECURITY WARNING: THIS SERVER FEATURES A FILE TRAVERSAL VULNERABILITY WHICH ALLOWS YOU TO EXECUTE ANY EXECUTABLE ON YOUR SYSTEM. DO *NOT* UNDER ANY CIRCUMSTANCES USE IN PRODUCTION**

This is a really simple testserver for cgi scripts. 

Reasons for building such a crappy tool: I need to debug cgi scripts without spinning up a server every time  
Reasons for releasing such a crappy tool: It might save you an hour

Features:
* Execution of any file marked as executable (via CGI)
* Serving of static files (with mime type detection based on file signature!)
* Very crude implementation of the CGI protocol
* Extra Ugly code (don't kill me, it does it's job)
* Now with free security vulnerabilities included

How to use:
```bash
bundle
rackup
```

### FAQ (not really, i don't get any questions)

*"I used it in production and my server got hacked"*  
Serves you right for not reading.

*"Will you make it less crappy"*  
Only if i see a need or got time to spare

*"What if i make it less crappy for you?"*  
Submit a pull request and i'll probably accept it.
