Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4DF96953.8090002@jp.fujitsu.com>
Date: Thu, 16 Jun 2011 11:24:19 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
References: <1308163906-6054-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1308163906-6054-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: segoon@openwall.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, gregkh@suse.de, davem@davemloft.net, arnd@arndb.de, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, daniel.lezcano@free.fr, ebiederm@xmission.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

(2011/06/16 3:51), Vasiliy Kulikov wrote:
> This patch adds support of mount options to restrict access to
> /proc/PID/ directories.  The default backward-compatible 'relaxed'
> behaviour is left untouched.
> 
> The first mount option is called "hidepid" and its value defines how much
> info about processes we want to be available for non-owners:
> 
> hidepid=0 (default) means the current behaviour - anybody may read all
> world-readable /proc/PID/* files.
> 
> hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> protected against other users.  As permission checking done in
> proc_pid_permission() and files' permissions are left untouched,
> programs expecting specific files' permissions are not confused.
> 
> hidepid=2 means hidepid=1 plus all /proc/PID/ will be invisible to
> other users.  It doesn't mean that it hides a fact whether a process
> exists (it can be learned by other means, e.g. by sending signals), but
> it hides process' euid and egid.  It greatly compicates intruder's task of
> gathering info about running processes, whether some daemon runs with
> elevated privileges, whether other user runs some sensitive program,
> whether other users run any program at all, etc.
> 
> gid=XXX defines a group that will be able to gather all processes' info.

Hmm...

Maybe I missed patch [0/5] or I haven't got it. Anyway I haven't see it.
Can you please describe your use case? Why do we need two new hidepid mode?
Moreover, if we use hidepid=[12], it may break some procps tools. What do
you think about compatibility issue? And, why don't you use just pid namespace?

I'm sorry if you already answered.
