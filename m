Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 26 Jul 2011 18:50:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110726145016.GA8583@albatros>
References: <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
 <20110608172307.GA3380@albatros>
 <20110612023916.GC14976@openwall.com>
 <20110724185036.GC3510@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110724185036.GC3510@albatros>
Subject: Re: [kernel-hardening] [RFC v2] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a demonstration of procfs feature I'm writing now.  It is not
yet fully ready (need more clean code and need to divide the patch into
series), however, it's ready for some demonstration:

# mount -o remount,tgid_allowed=none,tid_allowed=none,attr_allowed=none /proc
root@albatros:~# ls -ld /proc/1
dr-x------ 8 root root 0 2011-07-26 17:57 /proc/1
# mount -o remount,tgid_allowed=stat /proc
# ls -ld /proc/1
dr-xr-xr-x 8 root root 0 2011-07-26 18:03 /proc/1
# ls -ld /proc/1/{stat,status,sched}
-rw------- 1 root root 0 2011-07-26 18:03 /proc/1/sched
-r--r--r-- 1 root root 0 2011-07-26 18:03 /proc/1/stat
-r-------- 1 root root 0 2011-07-26 18:03 /proc/1/status
# mount -o remount,tgid_allowed=all /proc
# ls -ld /proc/1/{stat,status,sched}
-rw-r--r-- 1 root root 0 2011-07-26 18:03 /proc/1/sched
-r--r--r-- 1 root root 0 2011-07-26 18:03 /proc/1/stat
-r--r--r-- 1 root root 0 2011-07-26 18:03 /proc/1/status
# ls -ld /proc/1/task/1/ 
dr-xr-xr-x 6 root root 0 2011-07-26 18:03 /proc/1/task/1/
# ls -ld /proc/1/task/1/{stat,status,sched}
-rw------- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/sched
-r-------- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/stat
-r-------- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/status
# mount -o remount,tid_allowed=sched /proc
# ls -ld /proc/1/task/1/{stat,status,sched}
-rw-r--r-- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/sched
-r-------- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/stat
-r-------- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/status
# mount -o remount,tid_allowed=all /proc
# ls -ld /proc/1/task/1/{stat,status,sched}
-rw-r--r-- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/sched
-r--r--r-- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/stat
-r--r--r-- 1 root root 0 2011-07-26 18:04 /proc/1/task/1/status
# ls -l /proc/1/attr/
итого 0
-rw------- 1 root root 0 2011-07-26 18:04 current
-rw------- 1 root root 0 2011-07-26 18:04 exec
-rw------- 1 root root 0 2011-07-26 18:04 fscreate
-rw------- 1 root root 0 2011-07-26 18:04 keycreate
-r-------- 1 root root 0 2011-07-26 18:04 prev
-rw------- 1 root root 0 2011-07-26 18:04 sockcreate
# mount -o remount,attr_allowed=exec\;sockcreate /proc
# ls -l /proc/1/attr/
итого 0
-rw------- 1 root root 0 2011-07-26 18:05 current
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 exec
-rw------- 1 root root 0 2011-07-26 18:05 fscreate
-rw------- 1 root root 0 2011-07-26 18:05 keycreate
-r-------- 1 root root 0 2011-07-26 18:05 prev
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 sockcreate
# mount -o remount,attr_allowed=all /proc
# ls -l /proc/1/attr/
итого 0
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 current
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 exec
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 fscreate
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 keycreate
-r--r--r-- 1 root root 0 2011-07-26 18:05 prev
-rw-rw-rw- 1 root root 0 2011-07-26 18:05 sockcreate
# mount -o remount,attr_allowed=none /proc
# ls -l /proc/1/attr/
итого 0
-rw------- 1 root root 0 2011-07-26 18:08 current
-rw------- 1 root root 0 2011-07-26 18:08 exec
-rw------- 1 root root 0 2011-07-26 18:08 fscreate
-rw------- 1 root root 0 2011-07-26 18:08 keycreate
-r-------- 1 root root 0 2011-07-26 18:08 prev
-rw------- 1 root root 0 2011-07-26 18:08 sockcreate


As you see, there are different sets for /proc/PID, /proc/PID/task/TID/,
/proc/PID/attr.  I've slightly changed the semantics and removed ".", it
is implicitly enabled iff something inside is enabled.  To deny "."
XXX=none should be passed.

Questions/comments:

1) it seems to me "\;" is hard to pass, maybe ":" is a better separator?

2) almost all tid files are copies of tgid files. coredump_filter,
mountstats, net are missing in task/.  So, maybe fully remove
tid_allowed= and copy the tgid files' permissions to the appropriate tid
files?

3) currently the implementation is somewhat slow as every file is
wrapped into additional file operations handlers.  It cannot be removed
for "fast" cases as all permissions of all files should be dynamically
recalculated for every access.  Probably I could make it faster a bit.
It is the most significant drawback of the patch :-(

Thanks,

-- 
Vasiliy Kulikov
