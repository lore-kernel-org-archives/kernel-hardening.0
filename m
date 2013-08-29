Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 29 Aug 2013 10:11:27 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130829091127.GA2635@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
 <20130826172054.GE27005@ZenIV.linux.org.uk>
 <20130827172406.GA2664@dztty>
 <20130828201141.GA21455@dztty>
 <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
 <20130828211116.GA22184@dztty>
 <87sixt735b.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sixt735b.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Wed, Aug 28, 2013 at 05:26:56PM -0700, Eric W. Biederman wrote:
> 
> I have take a moment and read this thread, and have been completely
> unenlightend.  People are upset but it is totally unclear why.
> 
> There is no explanation why it is ok to ignore the suid-exec case, as
> the posted patches do.  Which ultimately means the patches provide
Please, did you take a look at the patches ?
-       INF("syscall",    S_IRUGO, proc_pid_syscall),
+       INF("syscall",    S_IRUSR, proc_pid_syscall),

Can you please tell me how did you come to the conclusion that the
patches "ignore the suid-exec case as the posted patches do" ?

I just did s/0444/0400/ which is pretty obvious and did not remove
that ptrace check at read() added by Al.

> little to no security benefit, and that the posted patches as written
> are broken.
They are correct. Perhaps you didn't take a closer look

Thanks Eric

-- 
Djalal Harouni
http://opendz.org
