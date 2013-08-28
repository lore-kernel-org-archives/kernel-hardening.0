Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 28 Aug 2013 21:11:42 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130828201141.GA21455@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
 <20130826172054.GE27005@ZenIV.linux.org.uk>
 <20130827172406.GA2664@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827172406.GA2664@dztty>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Cc'ed more people,

On Tue, Aug 27, 2013 at 06:24:06PM +0100, Djalal Harouni wrote:
> Hi Al,
> 
> On Mon, Aug 26, 2013 at 06:20:55PM +0100, Al Viro wrote:
> > On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:
> > 
> > > How does changing the permissions to S_IRUSR prevent someone from
> > > opening the file before, and reading the file after a suid exec?
> > > 
> > > > This patch restores the old mode which was 0400
> > > 
> > > Which seems to add no security whatsoever and obscure the fact that
> > > anyone who cares can read the file so what is the point?
> > 
> > Two words: "security sclerosis".  Both patches NAKed, of course.
> These particular tissues "are being hardened", no cure for them
> 
> 
> More seriously, Al your commit a9712bc12c40c172e393f85 closes the races
> during read() ok, but can you please share some light why the permission
> mode was changed ?
> 
> 1)
> The commit log states that all these files are "rw-r--r--" which was not
> correct, they were "r--------" before that commit.
> 
> 2)
> The commit log says also:
> "if you open a file before the target does suid-root exec, you'll be still
> able to access it." so you do the task is tracable check at read()
> 
> But what if you open a file of a privileged target or a target that does
> suid-root exec later, and pass the fd to a suid-root exec to read() from
> it later, you will still pass that tracable check.
> 
> And currently a non-privileged process can get an fd on all these
> /proc/*/stack files even root owned ones.
> 
> So why not restore the old behaviour and block a process from getting an
> fd on /proc/*/stack files that belong to other processes?
> 
> 
> The original thread that added the /proc/*/stack feature:
> https://lkml.org/lkml/2008/11/7/109
> 
> They noted that it should be under 0400 permissions
> 
> So why remove that, or why not restore the old safe behaviour ?
> 
> 
> Hope to get a response
> 
> Thanks Al

Hope this will convince.

Please not I'm just trying to help/contribute and get things right.
If there is something obvious that I'm missing let me know, will
be happy to learn


tixxdz@dztty-qemu:~$ id
uid=1000(tixxdz) gid=1000(tixxdz)
groups=1000(tixxdz),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev)

tixxdz@dztty-qemu:~$ ls -lha ./a.out 
-rwxr-xr-x 1 tixxdz tixxdz 8.0K Aug 28 20:26 ./a.out

tixxdz@dztty-qemu:~$ ls -lha /usr/bin/procmail 
-rwsr-sr-x 1 root mail 88K Apr 25  2010 /usr/bin/procmail

(procmail with -d needs setuid())

tixxdz@dztty-qemu:~$ for i in $(seq 1 10); do ./a.out /usr/bin/procmail
/proc/$i/stack ; done

tixxdz@dztty-qemu:~$ cat /var/mail/tixxdz 
[<ffffffff811b6537>] poll_schedule_timeout+0x57/0xe0
[<ffffffff811b70c7>] do_select+0x8b7/0x9a0
[<ffffffff811b766c>] core_sys_select+0x4bc/0x4f0
[<ffffffff811b7761>] SyS_select+0xc1/0x110
[<ffffffff81aef5e9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8108a6e1>] kthreadd+0xb1/0x150
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81081610>] worker_thread+0x2e0/0x370
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81081610>] worker_thread+0x2e0/0x370
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81081610>] worker_thread+0x2e0/0x370
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811020f3>] rcu_gp_kthread+0xe3/0x620
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811023b4>] rcu_gp_kthread+0x3a4/0x620
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
[<ffffffff8108a1b1>] kthread+0xd1/0xe0
[<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

You have mail in /var/mail/tixxdz


Thanks

-- 
Djalal Harouni
http://opendz.org
