Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 18 Jun 2011 22:28:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110618182812.GA16457@albatros>
References: <20110618104207.GA13752@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110618104207.GA13752@albatros>
Subject: [kernel-hardening] Re: proc info restrictions problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jun 18, 2011 at 14:42 +0400, Vasiliy Kulikov wrote:
> I feel doubt whether ptrace_may_access() may be changed to something
> more simple.  Both -ow and -grsecurity use changed posix permissions and
> gid on procfs files, so maybe just match subject's euid vs. object's uid?

Another choise - remove hidepid=2 at all.  As proc connector uses struct
proc_event as an information send to listeners, hidepid=1 is not related
to proc connector:

http://lxr.free-electrons.com/source/include/linux/cn_proc.h?a=avr32#L45

It means that with hidepid=1 only procfs and taskstats should be
restricted.  Taskstats uses direct "unicast" information sending, so
ptrace_task_may_access_current() and ptrace_may_access() should work
(with a patch I've recently sent to lsm list as RFC).


It is sad that hidepid=2 is losen and processes may spy on other users'
processes, but I don't see any technical solution for hidepid=2 and
cn_proc problem.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
