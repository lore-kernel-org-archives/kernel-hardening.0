Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 01:25:45 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120312002545.GE10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <20120311172512.GA2729@redhat.com>
 <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
 <20120311233233.GC10787@dztty>
 <CA+55aFzVZLqnwiXqH4zm6Vn_2QgiRSTDP8uuY3rXyQhobRv63g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzVZLqnwiXqH4zm6Vn_2QgiRSTDP8uuY3rXyQhobRv63g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 04:42:37PM -0700, Linus Torvalds wrote:
> On Sun, Mar 11, 2012 at 4:32 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >>
> >> Just increment the mm_count for the thing, and hold a reference to it,
> >> and now you're all done.
> > Please Linus have you checked the:
> > [PATCH 9/9] proc: improve and clean up /proc/<pid>/mem protection
> >
> > That keeping the mm struct wont work, since it will eat memory and the
> > OOM-killer will kill some innocent processes, and the abuse can only be
> > catched by the VFS.
> 
> That's the point. I made the mistake of using mm_users initially, but
> ysing mm_count - which is what I said to use (and what Oleg fixed
> things to in commit 6d08f2c71397) should *not* have that problem. It
> just keeps the 'struct mm_struct' itself around.
And that mm_struct will explode and only the VFS will catch it.

Given  1024 processes * (RLIMIT_NOFILE 1024 - 3) == ~1020000

more than 1020000 mm structs (all of dead processes ?)


A quick test on a default ubuntu:
cat /proc/sys/fs/file-max
388411

So we are able to keep around 388411 dead mm_struct in memory, just try it.

Our embedded devices will suffer, serial login will be killed, getty, ...
ssh root owned ... I've experienced this.

I'll try to post more numbers.


> > What's your opinion on it ?
> 
> What's the advantage? You replace it with *another* allocation, and a
That allocation is much smaller and it can be used to protect all
/proc/<pid>/* files in a unified way. Consistency seems the right thing
to do, even the /proc/<pid>/{syscall,stack,...} that do not operate on mm
structs will be protected. I don't know how you will protect these files ?


We can even remove the allocation and just reference the exec_id or use
other fields of the file struct.

I'm must admit that grsecurity just did the check in the seq files, they
did not add anything, this can leave some other files unprotected, but it
is cheaper.

> 64-bit thing that is much less useful.
Well, it protect as from wraps.
>From the previous discussions it seems that perhaps we can work around it
or have an agreement.

> The size of the patch also speaks for itself:
> 
>  fs/proc/base.c |   99 ++++++++++++++++++++++++++++++++++++++++++++------------
That's not fair since most of the logic of /proc/<pid>/* files is in
fs/proc/base.c and we can clean the code, there are some duplicated
functions in my patch, which we can improve.

> and it's more complex and uses more memory on average (the refcount
> thing is *free* for usual cases).
> 
> I do agree that it would be nicer if mm_struct was a bit smaller, but
> at the same time, I really don't see the advantage of replacing it
> with another allocation entirely that makes the code just more
> complicated.
As I've said we can improve it.

I'll take all the feedback I got and re-work the patches, in the meantime
some of these sensitive files need to be protected especially the
/proc/<pid>/{maps,smaps,numa_maps}

I'll re-submit.

Thanks for the feedback.

>                  Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
