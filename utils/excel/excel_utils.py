from utils.misc_basic.misc_utils import  os_file_to_string, os_file_exists, append_text_to_file, \
     b64decode, encode, decode, write_array_to_file, write_text_to_file, b64encode
from utils.misc_basic.misc_utils_log import Log, logger, PRIORITY
from collections import OrderedDict
from types import ListType, StringType
from os.path import basename
import sys
from os import chdir

if sys.platform == "win32":
    LOGDIR = "./"
else:
    LOGDIR = "/tmp/log"
    
log = Log(cacheflag=False,logdir=LOGDIR,verbosity=5)
log.config =OrderedDict([('now',12),('type',10),('class',30),('funcname',30),
                         ('module',20),('msg',-1),('today',8)])

class ExcelBase(object):
    '''
    the ExcelBase class is dynamic and the class attributes are set by 
    values found in the input file that is being passed from excel.
    this class knows how to parse the file and validate the fields '''
    def __init__(self,**kwargs):

        global log
        
        if sys.platform == "win32":
            self.logdir = "./"
        else:
            self.logdir = "/tmp/log"
            
        if kwargs.has_key('runtime_path') == True:
            setattr(self,"runtime_path",kwargs['runtime_path'])
            self.logdir = kwargs['runtime_path']
            log.logdir = self.logdir
            # force the logfile to be written into the runtime directory
            log.startlog()
        else:
            setattr(self,"runtime_path",".")

    @staticmethod    
    def _get_file_encoding(filepath):
        if basename(filepath).startswith("b64"):
            return "base64"
        elif basename(filepath).startswith("uu"):
            return "uuencode"
        elif basename(filepath).startswith("uni"):
            return "unicode"
        else:
            raise Exception("cannot determine the encoding being used, filename does not start with b64/uue/uni")

    def _get_parse_result_file(self,**kwargs):
        """ result_file can be specified either through passed arguments or
        via a config_file (so would be already available as a member attr in raw form)
        also any file attribute can either be a single file or a list of file and needs
        to be normalized to always be a list
        :param kwargs: dict, potentialy containing result_file info
        :rtype boolean
        """
        if hasattr(self,'result_file'):
            _result_file = getattr(self,'result_file')
        elif kwargs.has_key('result_file'):
            _result_file = kwargs['result_file']
        else:
            return -1
            
        if isinstance(_result_file, ListType):
            if len(_result_file) == 1:
                _result_file = _result_file[0]
            else:
                log.log(PRIORITY.INFO,msg="cant use file not a list of len one")
                return -1
        return _result_file
            
    @classmethod
    def reset(cls):
        """ because the class attribute persist throughout a python session,
        when testing we need to be able to delete dynamic attributes and start again.
        this is probably not the right way to do it....
        """
        attrs = [_attr for _attr,_ in inspect.getmembers(cls, lambda a:not(inspect.isroutine(a)))]
        for _attr in attrs:
            if _attr.startswith("__") == False:
                try:
                    delattr(cls,_attr)
                except AttributeError, e:
                    log.log(PRIORITY.INFO,msg="cannot delattr "+_attr+" setting to None")  
                    setattr(cls,_attr,None)
    
    @classmethod   
    def _validate_filename(self,fieldname,encoding="unicode",mustexist=True):
        """ check if filename exists
        :param fieldname:string or list of strings
        :rtype : -1 on failure or None
        """
        filepaths = getattr(self,fieldname).split("$$")
        for i in range(len(filepaths)):
            if os_file_exists(decode(filepaths[i],encoding)) == False:
                if mustexist == True:
                    return([-1])
            #else:
            filepaths[i] = decode(filepaths[i],encoding)
        setattr(self,fieldname,filepaths)
        
    @classmethod   
    def _validate_field(self,fieldname,encoding="unicode"):
        """ check the a raw value for the field has been set
        :param filename:string
        :param encoding: [base64|unicode|b64encode]
        :rtype : -1 on failure or None
        """
        if hasattr(self,fieldname) == False:
            log.log(PRIORITY.FAILURE,msg=fieldname+" name must be passed")   
            return([-1]) 
    
        setattr(self,fieldname,decode(getattr(self,fieldname),encoding))
        #if encoding=="base64":
        #    setattr(self,fieldname,b64decode(getattr(self,fieldname)))
        #elif encoding=="unicode":
        #    setattr(self,fieldname,getattr(self,fieldname))            

    @classmethod   
    def _validate_flag(self,flagname,encoding="unicode"):
        """ check the a raw flag exists and update attr to be boolean value
        :param flagname:string
        :param encoding: [base64|unicode|b64encode]
        :rtype : -1 on failure or None
        """
        if hasattr(self,flagname) == False:
            log.log(PRIORITY.FAILURE,msg=flagname+" name must be passed")   
            return([-1]) 
        
        if decode(getattr(self,flagname),encoding) == "True":
            setattr(self,flagname,True)
        elif decode(getattr(self,flagname),encoding) == "False":
            setattr(self,flagname,False)
        else:
            raise Exception(encoded," encoded flag needs to be either True|False")
        
    def _create_output_file(self,filepath,input_rows,encoding="unicode"):
        outstr = "$$".join(["^".join(map(str,_row)) for _row in input_rows])
        write_text_to_file(filepath,outstr)
    
    @staticmethod
    def _encode_2darray(array,encoding="base64"):
        result = []
        for _row in array:
            result.append([encode(str(_field),encoding) for _field in _row])
        return result

    @staticmethod
    def _decode_2darray(array,encoding="base64"):
        result = []
        for _row in array:
            result.append([ExcelBase._tryint(decode(_field,encoding)) for _field in _row])
        return result

    @staticmethod
    def _tryint(value):
        result = value
        try:
            result = int(value)
        except:
            pass
        return result
    
    @classmethod            
    def _parse_input_file(cls,filepath,mandatory_fields,encoding="unicode",
                                       runtime_path=".",**kwargs):
        """ take a key,value pair param text file and create class attributes of the name
        key with the value, value
        :param filepath:string, full path of the param text file
        :param encoding: string of member unicode|base64|b64encode
        :param mandatory_fields: list, all the fields that must be present in this file
        rtype : -1 on failure or None
        """
        if os_file_exists(filepath) == False:
            log.log(PRIORITY.FAILURE,msg="filename ["+filepath+"] not found]")   
            return([-1])

        file_str = os_file_to_string(filepath)

        if encoding=="base64":
            # this is just for uuencoding; because encoding can create newline characters
            # we can get around this by converting them to + and then to space; which 
            # is treated as the same as a newline
            file_str = file_str.replace("+++"," ")
            
        lines = file_str.split("\n")    

        all_fields = [] # holds all fields detected not just mandatory ones
        try:
            # first load all attributes passed
            for _line in lines:
                _line_split = []

                try:
                    _line_split = _line.split(":")
                except:
                    log.log(PRIORITY.INFO,msg="cannot process line   ["+_line+"] in file [" + filepath + "]") 

                if len(_line_split) == 2:
                    setattr(cls,_line_split[0],_line_split[1])
                    all_fields.append(_line_split[0])
                else:
                    log.log(PRIORITY.INFO,msg="cannot process line ["+_line+"] in file [" + filepath + "]") 
                    
            # call validate func for each mandatory field
            for _field in mandatory_fields:
                if getattr(cls,"_validate_"+_field)(encoding=encoding) == [-1]:
                    log.log(PRIORITY.FAILURE,msg="mandatory field could not be validated  ["+_field+"]")
                    raise Exception("mandatory field could not be validated  ["+_field+"]")
                else:
                    log.log(PRIORITY.INFO,msg="parsed mandatory ["+str(_field)+"="+str(getattr(cls,_field))+"]")
            
            # then validate all optional fields
            for _field in all_fields:
                if _field not in mandatory_fields:
                    if getattr(cls,"_validate_"+_field)(encoding=encoding) != [-1]:
                        log.log(PRIORITY.INFO,msg="parsed optional ["+str(_field)+"="+str(getattr(cls,_field))+"]")
                    
            # check to see if an explicit runtime path is set for databases and log files
            setattr(cls,"runtime_path",runtime_path)
            log.log(PRIORITY.INFO,msg="setting runtime_path to ["+runtime_path+"]")
            
        except TypeError, e:
            log.log(PRIORITY.FAILURE,msg="TypeError encoding issues? ["+str(e.message)+"]")   
            return([-1])            

        return cls