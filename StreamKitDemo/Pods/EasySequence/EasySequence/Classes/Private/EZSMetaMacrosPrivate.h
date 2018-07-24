//
//  EZSMetaMacrosPrivate.h
//  Pods
//
//  Created by nero on 2018/5/2.
//

#ifndef EZSMetaMacrosPrivate_h
#define EZSMetaMacrosPrivate_h



#define EZS_CONCAT(A, B)             EZS_CONCAT_(A, B)
#define EZS_CONCAT_(A, B)            A ## B

#define EZS_LOCK_TYPE                dispatch_semaphore_t
#define EZS_LOCK_DEF(LOCK)           dispatch_semaphore_t LOCK
#define EZS_LOCK_INIT(LOCK)          LOCK = dispatch_semaphore_create(1)
#define EZS_LOCK(LOCK)               dispatch_semaphore_wait(LOCK, DISPATCH_TIME_FOREVER)
#define EZS_UNLOCK(LOCK)             dispatch_semaphore_signal(LOCK)

static inline void EZS_unlock(EZS_LOCK_TYPE *lock) {
    EZS_UNLOCK(*lock);
}

#define EZS_SCOPELOCK(LOCK)          EZS_LOCK(LOCK);EZS_LOCK_TYPE EZS_CONCAT(auto_lock_, __LINE__) __attribute__((cleanup(EZS_unlock), unused)) = LOCK

static inline BOOL EZS_idConformsToProtocol(id object, Protocol *protocol) {
    return [[object class] conformsToProtocol:protocol];
}

#define EZS_idConformsTo(obj, pro) EZS_idConformsToProtocol(obj, @protocol(pro))

#define EZS_THROW(NAME, REASON, INFO)                            \
NSException *exception = [[NSException alloc] initWithName:NAME reason:REASON userInfo:INFO]; @throw exception;

#endif /* EZSMetaMacrosPrivate_h */
