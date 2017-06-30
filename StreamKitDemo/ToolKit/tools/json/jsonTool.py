#! /usr/bin/python
import json
from sys import argv

classList = {}

def capitalize(name):
    if len(name) == 0 :
        return name
    return name[0].capitalize() + name[1:]

def underLineToCamel(name,firstCap = False):
    if name.find('_') < 0 :
        if firstCap:
            
            return capitalize(name)
        return name
        
    items = name.split('_')
    if firstCap:
        camel = capitalize(items[0])
    else:
        camel = items[0]

        
    for i in range(1,len(items)):
        camel = camel + capitalize(items[i])
        
    return camel


def defaultKeyMap(key):

    if key == "errno":
        return "dErrno"
    return key
    
def simpleTypeName(ktype):
    
    if ktype == "<type 'int'>" or  ktype == "<type 'float'>":
        #return "NSNumber"
        return "NSString"
    elif ktype == "<type 'bool'>":
        return "BOOL"
    elif ktype == "<type 'str'>" or ktype == "<type 'unicode'>":
        return "NSString"
    return None
        
    
def iterItem(item,className):
    
    if not str(type(item)) == "<type 'dict'>" :
        print "item type is: " , type(item)
        return

    for k , v in item.items():
        ktype = str(type(v))

        if ktype == "<type 'list'>":
            it = v[0]
            ittype = str(type(it))
            if ittype == "<type 'dict'>":
                subname = className + "_" +k
                subname = underLineToCamel(subname)
                printProtocol(subname)
                newdict = contactlist(v)
                iterItem(newdict,subname)
                
        elif ktype == "<type 'dict'>":
            subname = className + "_"+k
            subname = underLineToCamel(subname,True)
            iterItem(v,subname)

    printHeader(item,className)
 
def contactlist(item):
    newdict = {}
    for it in item:
        ittype = str(type(it))
        if ittype == "<type 'dict'>":
            for k, v in it.items():
                newdict[k] = v
    return newdict


def printHeader(item,className):

    t = str(type(item))
    if not  t == "<type 'dict'>" :
        print "error type: " , t
        print "item is  : " , item
        print "className is: " , className
        return None

    global classList
    varlist = {}
    print "@interface " , className + "Model" , " : JSONModel \n"

    for k , v in item.items():
        ktype = str(type(v))
        pname = underLineToCamel(defaultKeyMap(k))

        if ktype == "<type 'int'>" or  ktype == "<type 'float'>":
            print "@property (nonatomic, copy , nullable) NSString *%s;" %  pname
        elif ktype == "<type 'bool'>":
            print "@property (nonatomic, assign) BOOL %s;" % pname 
        elif ktype == "<type 'str'>" or ktype == "<type 'unicode'>":
            print "@property (nonatomic, copy , nullable) NSString *%s;" % pname
        elif ktype == "<type 'dict'>":
            classType = className + underLineToCamel(pname,True) + "Model"
            print "@property (nonatomic, strong , nullable) %s *%s ;  " % (classType, pname)
        elif ktype == "<type 'list'>":

            it = v[0]
            t = str(type(it))
            nn = simpleTypeName(t)
            if nn == None :
                print "@property (nonatomic, strong , nullable) NSArray<%sModel> *%s;" % (className+underLineToCamel(defaultKeyMap(k),True),pname)
            else:
                print "@property (nonatomic, strong , nullable) NSArray *%s;" % (pname)
                
        else:
            #print "type is: " , ktype , "for key : " , pname 
            print "@property (nonatomic)         typename<Optional>* %s;" % pname
        if not pname == k :
            varlist[k] = pname

    classList[className] = varlist
    print "\n@end\n\n"

def printProtocol(className):
    print "@protocol %sModel<NSObject>\n"%className
    print "@end\n\n"

def printImplemention(className , mapKeys):
    print "@implementation ",className+"Model\n"
    if mapKeys != None and len(mapKeys) > 0:
        print "+ (JSONKeyMapper*)keyMapper"
        print "{"
        print "  NSDictionary *dict = @{"
        #print "  return [[JSONKeyMapper alloc] initWithDictionary:@{",
        index = 1
        value = ""
        for k,v in mapKeys.items():
            value += "    @\"%s\": @\"%s\",\n" % (v,k)
            index+= 1
        print value,
        print "  };"
        print "  return [[JSONKeyMapper alloc]initWithModelToJSONBlock:^NSString *(NSString *keyName) {"
        print "     return dict[keyName]?:keyName;"
        print "  }];"
        print "}\n"

    #gen option
    print "+ (BOOL)propertyIsOptional:(NSString *)propertyName"
    print "{"
    print "    return YES;"
    print "}\n"
    
    print "@end\n\n"
    
def makeJson(path,className):

    f = file(path)
    j = json.load(f,encoding='utf8')
    f.close()
    
    iterItem(j,className)


    print "\n\n\n\n"
    print "//for implementation"
    for k , v in classList.items():
        printImplemention(k,v)
    
    

if __name__ == '__main__':

    if len(argv) < 3:
        print "Usage: jsonTool , jsonpath  className\n"
        exit(0)
    makeJson(argv[1],argv[2])
    