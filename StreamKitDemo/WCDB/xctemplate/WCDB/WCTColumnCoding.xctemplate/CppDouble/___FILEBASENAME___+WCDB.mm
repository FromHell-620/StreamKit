//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___FILEBASENAME___+WCTColumnAccessor.h"

template <>
WCTColumnRuntimeCppAccessor<___FILEBASENAMEASIDENTIFIER___>::CType WCTColumnRuntimeCppAccessor<___FILEBASENAMEASIDENTIFIER___>::convertPropertyTypeToCType(___FILEBASENAMEASIDENTIFIER___ value)
// double convertPropertyTypeToCType(___FILEBASENAMEASIDENTIFIER___ value)
{
    return (double) <#C value #>;
}

template <>
___FILEBASENAMEASIDENTIFIER___ WCTColumnRuntimeCppAccessor<___FILEBASENAMEASIDENTIFIER___>::convertCTypeToPropertyType(WCTColumnRuntimeCppAccessor<___FILEBASENAMEASIDENTIFIER___>::CType cvalue)
// ___FILEBASENAMEASIDENTIFIER___ convertCTypeToPropertyType(double cvalue)
{
    return (___FILEBASENAMEASIDENTIFIER___)<#value #>;
}
