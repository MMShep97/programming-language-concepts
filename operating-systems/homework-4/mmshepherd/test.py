#!/usr/bin/env python

import subprocess
import time
import sys
import hashlib
import struct
import random
import os
import signal



NSOLUTIONS = 8
SPEED_THRESHOLD = 0.75
BIN_NAME = sys.argv[1]

total_errors = 0

# this code is just to prevent child processes to be left running after test.py is closed
last_child = None
def termination_handler(signum=None, frame=None):
    if last_child != None:
        print "killing pg", last_child
        os.killpg(last_child, 9)

signal.signal(signal.SIGHUP, termination_handler)

def setpg():
    try:
        os.setpgid(0, 0)
    except:
        pass
###


def run_cmd(args, timeout = None):
    global last_child

    if timeout != None:
        fargs = ["/usr/bin/timeout", "-k", "1", str(timeout)] + args
    else:
        fargs = args
    pipe = subprocess.PIPE
    #print repr(fargs)
    ntime = time.time()
    p = subprocess.Popen(fargs, stdout=pipe, stderr=pipe, preexec_fn=setpg)
    last_child = p.pid
    stdout, stderr = p.communicate()
    etime = time.time() - ntime
    rc = p.returncode
    p.wait()
    last_child = None
    return (stdout, stderr, rc, etime)


def test_hash(c, s):
    dg = hashlib.sha256(struct.pack("<Q",s)).digest()
    if struct.unpack("<H", dg[:2])[0] != c:
        return 0
    return 1


def test_challenges(challenges, nthread=1, timeout=None):
    global total_errors

    cmd = [BIN_NAME, str(nthread)] + [str(c) for c in challenges]
    print "running the command:"
    print " ".join(cmd)
    if timeout == None:
        timeout = 25.0
    stdout, stderr, rc, etime = run_cmd(cmd, timeout)
    if(etime>=timeout):
        print "ERROR the command took more than %f seconds, probably your code got stuck in an infinite loop" % timeout; total_errors+=1
        return 0
    else:
        print "the result was:"
        print stdout
        if stderr != "":
            print stderr

    for i,c in enumerate(challenges):
        res = stdout.split("\n")[i]
        ss = [int(i) for i in res.split()]
        ch = ss[0]
        #print ch, s1, s2
        if ch!=c:
            print "ERROR the challenge returned is not correct:", "%d vs. %d" % (ch,c); total_errors+=1
            return 0
        if len(ss) != NSOLUTIONS+1:
            print "ERROR returned an incorrect number of challenges"; total_errors+=1
            return 0
        dd = {}
        for s in ss[1:]:
            if not test_hash(c,s):
                print "ERROR the returned solution (%d) is not correct for the challenge (%d)" % (s,c); total_errors+=1
                return 0
            if any([s%i==0 for i in xrange(1000000,1500000+1)]):
                print "ERROR found a solution divisible by a number between 1000000 and 1500000: ", s; total_errors+=1
                return 0
            if(s%10) in dd:
                print "ERROR two solutions have the same last digit:", s, dd[s%10]; total_errors+=1
                return 0
            else:
                dd[s%10] = s 

        else:
            continue
        break
    else:
        return etime


def main():
    global total_errors

    #count the number of vCPUs
    fc = open("/proc/cpuinfo").read()
    vcpu = 0
    for l in fc.split("\n"):
        if l.startswith("processor\t:"):
            vcpu+=1
    print "DETECTED", vcpu, "vCPUs"
    if vcpu < 4:
        print "WARNING", "You have less than 4 vCPUs. Even if your code is correct, it may not speed up enough when using multiple threads"


    print "="*5, "testing 1 challenge with 1 thread"
    res = test_challenges([random.randint(0,pow(2,16)-1)],1)
    if res!=0:
        print "SUCCESS"
    else:
        pass
    print "="*5

    print "="*5, "testing 10 challenges with 1 thread"
    res = test_challenges([random.randint(0,pow(2,16)-1) for _ in xrange(10)],1)
    if res!=0:
        exec_time_1t = res/10.0
        if exec_time_1t >= 1.5:
            print "ERROR", "the average execution time is too slow:", res/10.0, "it should be less than 1.5 second"; total_errors+=1
        else:
            print "SUCCESS", "the average execution time was:", res/10.0
    else:
        return 1
    print "="*5

    ###
    print "="*20, "starting intensive tests"
    nrounds = 3
    for i in xrange(nrounds):
        print "="*20, "round %d of %d" % (i+1,nrounds)

        exec_time_1t_list = []
        for _ in xrange(5):
            print "="*5, "testing 20 challenges with 1 thread"
            res = test_challenges([random.randint(0,pow(2,16)-1) for _ in xrange(20)],1)
            if res!=0:
                exec_time_1t = res/20.0
                exec_time_1t_list.append(exec_time_1t)
                if exec_time_1t >= 1.5:
                    print "ERROR", "the average execution time is too slow:", res/20.0, "it should be less than 1.5 second"; total_errors+=1
                else:
                    print "SUCCESS", "the average execution time was:", res/20.0
            else:
                return 1
            print "="*5
        if len(exec_time_1t_list) > 0:
            exec_time_1t = sum(exec_time_1t_list)/float(len(exec_time_1t_list))
            print "--> the average execution time for 1 challenge with 1 thread is:", exec_time_1t


        for nthreads in xrange(2,5+1):
            exec_time_1t_list = []
            for _ in xrange(5):
                print "="*5, "testing 20 challenges with %d threads" % nthreads
                res = test_challenges([random.randint(0,pow(2,16)-1) for _ in xrange(20)],nthreads)
                if res!=0:
                    pavg = res/20.0
                    print "the average execution time was: %f" % pavg
                    exec_time_1t_list.append(pavg)
                else:
                    pass
                print "="*5
            if len(exec_time_1t_list) > 0:
                avg = sum(exec_time_1t_list)/float(len(exec_time_1t_list))
                print "--> the average execution time for 1 challenge with %d thread is: %f" % (nthreads, avg)
                if avg<(exec_time_1t*SPEED_THRESHOLD):
                    print "SUCCESS average execution time:", avg
                else:
                    print "ERROR", "running with %d threads does not improve the execution time enough. The average execution time was: %f, should be less than: %f" % (nthreads,avg,exec_time_1t*SPEED_THRESHOLD); total_errors+=1


        print "="*5, "testing 20 challenges with 10 threads"
        res = test_challenges([random.randint(0,pow(2,16)-1) for _ in xrange(20)],10)
        if res!=0:
            print "SUCCESS average execution time:", res/20.0
        else:
            pass
        print "="*5


        print "="*5, "testing 5 challenges with 100 threads"
        res = test_challenges([random.randint(0,pow(2,16)-1) for _ in xrange(5)],100)
        if res!=0:
            print "SUCCESS average execution time:", res/5.0
        else:
            pass
        print "="*5


    print "="*20, "total_errors: %d" % total_errors
    if total_errors == 0:
        return 0
    else:
        return 2


if __name__ == "__main__":
    try:
        sys.exit(main())
        last_child = None
    finally:
        termination_handler()



