Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 16 Jun 2011 12:47:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110616084720.GA2897@albatros>
References: <1308163906-6054-1-git-send-email-segoon@openwall.com>
 <4DF96953.8090002@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DF96953.8090002@jp.fujitsu.com>
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, gregkh@suse.de, davem@davemloft.net, arnd@arndb.de, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, daniel.lezcano@free.fr, ebiederm@xmission.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi KOSAKI,

On Thu, Jun 16, 2011 at 11:24 +0900, KOSAKI Motohiro wrote:
> Maybe I missed patch [0/5] or I haven't got it. Anyway I haven't see it.

0/5: https://lkml.org/lkml/2011/6/15/172 As 0's description doesn't go
into "git log", I didn't put exhaustive explaination there.

Documentation: https://lkml.org/lkml/2011/6/15/176


> Can you please describe your use case? Why do we need two new hidepid mode?

It can be used everywhere where a confidence is an issue.  The most
visible part is cmdline and comm hiding, which forbids learning what
binaries other users run.  status, perhaps io, stat and sched may be
indirectly used for the same purpose.  These and other files may be used
for gaining indirect infomation about what kinds (and/or what amount) of
computations were performed.

Changing all these files' permissions is arguable (it's not obvious what
files are sources of potential infoleaks and in what cases), it might
lead to compatibility issues.


> Moreover, if we use hidepid=[12], it may break some procps tools. What do
> you think about compatibility issue?

Good question :)  In times of -ow patch there was a pstree patch to show
independent process trees:

http://cvsweb.openwall.com/cgi/cvsweb.cgi/Owl/packages/psmisc/psmisc-21.5-owl-restricted-proc.diff?rev=1.2;content-type=text%2Fplain

It is simple to port it to the latest version of pstree.  Current
version of pstree prints only one tree:

?─┬─bonobo-activati───{bonobo-activat}
  ├─clock-applet
  ├─cpufreq-applet
  ├─dbus-daemon
  ├─dbus-launch
[...]


I didn't spot any visibility issues with other process related tools - 
ps and similar just print accessible processes' information skipping
nonaccessible ones.


> And, why don't you use just pid namespace?

Pid namespaces are somewhat good, but it is already possible to use
different security domains (uid and gid) inside of pid_namespace without
any trust between them (OK, root is an exception :)).  Hidepid enhances
already implemented separation.   Sometimes pid namespace's separation
may be too strong (no process-related communications between processes
of different namespaces unless they are parent and child namespaces).
Besides, namespaces are very expensive resource in sense of memory.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
