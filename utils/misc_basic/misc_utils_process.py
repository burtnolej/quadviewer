from subprocess import Popen, STDOUT, PIPE
from time import sleep
import sys
from misc_utils import thisfuncname
from misc_utils_log import Log, logger, PRIORITY
from os import remove, kill
import signal
import unittest

if sys.platform == "win32":
    LOGDIR = "./"
else:
    LOGDIR = "/tmp/log"

log = Log(cacheflag=True,logdir=LOGDIR,verbosity=10)

__all__ = ['process_start','process_stdin','process_kill','process_instances_get', \
           'process_get_stdout']

def process_start(cmdlineargs,stdin=True):
    ''' pass stdin=True when you want the process to wait for 
    stdin '''
    args = dict(stderr=STDOUT,stdout=PIPE)
    
    if stdin == True:
        args['stdin'] = PIPE
    
    p = Popen(cmdlineargs,**args)

    #from misc_utils_log import Log
    #log = Log(cacheflag=True,logdir="/tmp/log",verbosity=20,pidlogname=False,proclogname=False,reset="")
    #log.log(thisfuncname(),3,msg="creating process",cmdlineargs=cmdlineargs)
    log.log(PRIORITY.INFO,msg="creating process [" +  ",".join(cmdlineargs) + "]")
    return(p)

def process_get_stdout(process):
    return(process.stdout.read()) 
    
def process_stdin(process,stdinstr):
    ''' pass stdin to a process waiting for stdin '''
    return(process.communicate(input=stdinstr))

def process_kill(p):
    ''' accepts a Popen object and if not assumes its a PID str or int'''
    
    if isinstance(p,Popen) == True:

        if sys.platform == "win32":
            cmd = ['TASKKILL','/F','/T','/PID',str(p.pid)]
            process_start(cmd)
            return
        else:
            _pid = int(p.pid)
    else:
        try:
            _pid = int(p)
        except ValueError:
            raise Exception('requires an int or int as string')

    kill(_pid,signal.SIGTERM)
    return()
    
def process_instances_get(match):

    '''
    "Image Name","PID","Session Name","Session#","Mem Usage"\r\n
    "System Idle Process","0","","0","8 K"\r\n
    "System","4","","0","28 K"\r\n"smss.exe","344","","0","408 K"\r\n
    ....
    '''
    
    if sys.platform == "win32":
        cmd = ['tasklist','/FO','csv']
    else:
        cmd = ['ps','-ef']
        
    p = process_start(cmd)
    processlist = p.stdout.read()
    
    if sys.platform == "win32":
        plist = {}
        for _pd in processlist.split("\n"):
            try:
                _pname = _pd.split(",")[0].replace("\"","")
                _pid = int(_pd.split(",")[1].replace("\"",""))
                if plist.has_key(_pname) == False:
                    plist[_pname] = [_pid]
                else:
                    plist[_pname].append(_pid)
            except:
                #print "unable to split [",_pd,"]"
                pass
        
        if plist.has_key(match):
            return plist[match]
        else:
            return []
            
    else:
        # put back into string format for grep -v an remove blank last item 
        process_str = "".join(list(processlist)[:-1]) 
    
        cmd = ['grep',match]
        pgrep1 = process_start(cmd,stdin=True)
        matches =  process_stdin(pgrep1,process_str)
       
        # put back into string format for grep -v an remove blank last item 
        matches_str = "".join(list(matches)[:-1]) 
         
        cmd = ['grep','-v','defunct']
        pgrep2 = process_start(cmd,stdin=True)
    
        nondefunctmatches = process_stdin(pgrep2,matches_str)[0].split("\n")[:-1]

        pid = [(match.split(" ")[2],match.split(" ")[4]) for match in nondefunctmatches]
    
        return(pid)
