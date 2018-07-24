//
//  EZSUsefulBlocks.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>
#import <EasySequence/EZSBlockDefines.h>

/**
 Returns An EZSMapBlock type block directly without any change

 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_ID(void);

/**
 Returns an EZSFliterBlock type block that indicates whether object accepted in return block is an instance of given class or an instance of any class that inherits from that class
 
 @param klass A class object representing the Objective-C class to be tested.
 @return An EZSFliterBlock type block
 */
EZSFliterBlock EZS_isKindOf_(Class klass);
#define EZS_isKindOf(__klass__)     EZS_isKindOf_([__klass__ class])

/**
 Returns an EZSFliterBlock block that indicates whether object accepted in return block and a given object are equal.
 
 @param value The object to be compared to the receiver.
 @return An EZSFliterBlock type block
 */
EZSFliterBlock EZS_isEqual(id value);

/**
 Returns an EZSFliterBlock block that indicates whether the element exists.
 
 @return An EZSFliterBlock type block
 */
EZSFliterBlock EZS_isExists(void);

/**
 Returns an EZSFliterBlock block that has the logically opposite value of original. it turns a true into a false, etc.
 
 @param block An `EZSFliterBlock` type block
 @return An EZSFliterBlock type block
 */
EZSFliterBlock EZS_not(EZSFliterBlock block);

/**
 EZS_KeyPath allows compile-time verification of key paths. Given a real class and key path

 @param OBJ The Class
 @param PATH Key path
 @return the macro returns an NSString containing all but the first path component or argument
 */
#define EZS_KeyPath(OBJ, PATH)  (((void)(NO && ((void)[OBJ new].PATH, NO)), @# PATH))

/**
 Returns an EZSMapBlock type block and object accepted in return block performs `valueForKeyPath:` with propertyName
 
 @param keyPath The name of one of the objects's properties.
 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_valueForKeypath(NSString *keyPath);

/**
 Returns an EZSMapBlock type block and object in return block gets the value associated with a given key
 
 @param key The key for which to return the corresponding value
 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_valueForKey(NSString *key);

/**
 Returns an EZSApplyBlock type block and object accepted in return block performs selctor
 
 @param selector A selector identifying the message to send. 
 @return An EZSApplyBlock type block
 */
EZSApplyBlock EZS_performSelector(SEL selector);

/**
 Returns an EZSApplyBlock type block and object accepted in return block performs selctor with one argument.
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the sole argument of the message.
 @return An EZSApplyBlock type block
 */
EZSApplyBlock EZS_performSelector1(SEL selector, id param1);

/**
 Returns an EZSApplyBlock type block and object accepted in return block performs selctor with two arguments.
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @param param2 An object that is the second argument of the message
 @return An EZSApplyBlock type block
 */
EZSApplyBlock EZS_performSelector2(SEL selector, id param1, id param2);

/**
 Returns an EZSMapBlock type block and object accepted in return block performs selctor

 @param selector A selector identifying the message to send
 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_mapWithSelector(SEL selector);

/**
 Returns an EZSMapBlock type block and object accepted in return block performs selctor with one argument

 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_mapWithSelector1(SEL selector, id param1);

/**
 Returns an EZSMapBlock type block and object accepted in return block performs selctor with two arguments

 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @param param2 An object that is the second argument of the message
 @return An EZSMapBlock type block
 */
EZSMapBlock EZS_mapWithSelector2(SEL selector, id param1, id param2);

/**
 Compares two objects for equality.

 @param left The first object to compare.
 @param right The second object to compare.
 @return Returns true if the objects are equal, otherwise false.
 */
FOUNDATION_EXTERN BOOL EZS_instanceEqual(id left, id right);
