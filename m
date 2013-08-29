Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20130829091127.GA2635@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty>
	<20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
	<20130828211116.GA22184@dztty>
	<87sixt735b.fsf@xmission.com>
	<20130829091127.GA2635@dztty>
Date: Thu, 29 Aug 2013 15:14:32 -0700
Message-ID: <CAGXu5jJtiji1KPPLSr5SXKXGwBbb8McWZY3DqCZFWXKtP=KEzA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 29, 2013 at 2:11 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> Hi Eric,
>
> On Wed, Aug 28, 2013 at 05:26:56PM -0700, Eric W. Biederman wrote:
>>
>> I have take a moment and read this thread, and have been completely
>> unenlightend.  People are upset but it is totally unclear why.
>>
>> There is no explanation why it is ok to ignore the suid-exec case, as
>> the posted patches do.  Which ultimately means the patches provide
> Please, did you take a look at the patches ?
> -       INF("syscall",    S_IRUGO, proc_pid_syscall),
> +       INF("syscall",    S_IRUSR, proc_pid_syscall),
>
> Can you please tell me how did you come to the conclusion that the
> patches "ignore the suid-exec case as the posted patches do" ?

There are a few conditions that need to be handled. The original fix
that Al landed was to stop this:

create IPC
fork child
child opens /proc/self/syscall
child sends fd to parent over IPC
child execs setuid process
parent reads setuid process's "syscall" file

The solution was to check perms of reader (in this case parent wasn't
privileged, so it gets denied).

The new problem is:

open /proc/$target/syscall
dup to stdin
exec setuid process that reports contents of stdin

So, changing perms to 0400 doesn't actually fix what we want to fix,
since it can still by bypassed under more limited situations:

open /proc/self/syscall
dup to stdin
exec setuid process that reports contents of stdin

So, changing to 0400 means only setuid programs that aren't already
running will have their ASLR leaked.

>
> I just did s/0444/0400/ which is pretty obvious and did not remove
> that ptrace check at read() added by Al.
>
>> little to no security benefit, and that the posted patches as written
>> are broken.
> They are correct. Perhaps you didn't take a closer look

Maybe I'm lacking imagination, but changing to 0400 does reduce the
scope of the leak from all processes to "just" what was execed. This
still needs to be addressed, but I don't see a way to handle this
without explicitly invalidating the /proc handle across exec.

-Kees

-- 
Kees Cook
Chrome OS Security
