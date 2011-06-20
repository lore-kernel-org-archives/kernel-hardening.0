Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 19:00:52 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620150052.GA12077@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
 <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
 <20110620103917.GA5230@albatros>
 <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com>
 <20110620141137.GA31044@openwall.com>
 <20110620141951.GA11607@albatros>
 <20110620142555.GA31234@openwall.com>
 <20110620143550.GA11835@albatros>
 <20110620144739.GA31510@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620144739.GA31510@openwall.com>
Subject: Re: [kernel-hardening] [RFC 2/5 v4] procfs: add hidepid= and gid=
 mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Mon, Jun 20, 2011 at 18:47 +0400, Solar Designer wrote:
> On Mon, Jun 20, 2011 at 06:35:50PM +0400, Vasiliy Kulikov wrote:
> > I didn't post a patch with taskstats and sysctl variables to LKML yet
> > (only the changes in ptrace/capabilities code).
> 
> I don't understand the rationale behind the latter.  I can try to guess,
> but I'd prefer to see a simple explanation from you.  (Maybe I missed
> one.)  It sounds like you're going to spend considerable time on those
> changes, but it is not clear to me whether they're needed or not.
> 
> So please explain (maybe in a more proper thread than this one).
> 
> Unfortunately, I won't have time to participate in a discussion on this
> today (nor in the following few days), but I'd like to be informed
> anyway and maybe others will comment.

The thing is that taskstats' way of gathering process' information
includes registering a "hook" via netlink socket.  When any process
exits, taskstats code enumerates registered hookers and sends all
information about exited process via the sockets.  It is handled in the
context of exiting task.  So, to know whether the hooker may gather
process' information or no (whether exiting task should send info via
the socket), I need a function answering whether *another task* may
ptrace *current task* (ptrace_may_access does the reverse) as the last
check in procinfo_task_may_stat_current() (reversed proc_may_access() in
the past).

The changes are relatively simple (the patch look huge, though) as the
patch touches many functions (including LSM and user namespaces) adding
new explicit "task" argument instead of implicit "current" without
important functional changes.


Without ptrace changes HARDEN_PROC is unlikely to be consistently
working because of taskstats.

Also you might want to read my another mail where I've clarified why
I've rejected (temporarily, I hope) hidepid=2:

http://www.openwall.com/lists/kernel-hardening/2011/06/18/2


Thanks,

-- 
Vasiliy
