Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 00:32:33 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311233233.GC10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <20120311172512.GA2729@redhat.com>
 <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 03:48:02PM -0700, Linus Torvalds wrote:
> On Sun, Mar 11, 2012 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > It should be per-process, signal_struct makes more sense. Or may be
> > mm_struct.
>
> I do wonder if we shouldn't just consider the "struct mm_struct"
> pointer to *be* the unique exec ID. It's what /proc/pid/mem does, and
> it works fine, and allows us to just use a normal pointer as the
> unique ID.
> 
> Just increment the mm_count for the thing, and hold a reference to it,
> and now you're all done.
Please Linus have you checked the:
[PATCH 9/9] proc: improve and clean up /proc/<pid>/mem protection

That keeping the mm struct wont work, since it will eat memory and the
OOM-killer will kill some innocent processes, and the abuse can only be
catched by the VFS.

What's your opinion on it ?


And if we do the same for all the /proc/<pid>/* files and even if you
clear the VM of the old process, some other information will still be
available, even if it is not useful, this is not consistent.

Is it ok if the code keeps different objects related to dead processes
alive ?


-- 
tixxdz
http://opendz.org
