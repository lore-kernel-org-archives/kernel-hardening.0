Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20120311233233.GC10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
 <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com> <20120311233233.GC10787@dztty>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Mar 2012 16:42:37 -0700
Message-ID: <CA+55aFzVZLqnwiXqH4zm6Vn_2QgiRSTDP8uuY3rXyQhobRv63g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 4:32 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>>
>> Just increment the mm_count for the thing, and hold a reference to it,
>> and now you're all done.
> Please Linus have you checked the:
> [PATCH 9/9] proc: improve and clean up /proc/<pid>/mem protection
>
> That keeping the mm struct wont work, since it will eat memory and the
> OOM-killer will kill some innocent processes, and the abuse can only be
> catched by the VFS.

That's the point. I made the mistake of using mm_users initially, but
ysing mm_count - which is what I said to use (and what Oleg fixed
things to in commit 6d08f2c71397) should *not* have that problem. It
just keeps the 'struct mm_struct' itself around.

> What's your opinion on it ?

What's the advantage? You replace it with *another* allocation, and a
64-bit thing that is much less useful.

The size of the patch also speaks for itself:

 fs/proc/base.c |   99 ++++++++++++++++++++++++++++++++++++++++++++------------

and it's more complex and uses more memory on average (the refcount
thing is *free* for usual cases).

I do agree that it would be nicer if mm_struct was a bit smaller, but
at the same time, I really don't see the advantage of replacing it
with another allocation entirely that makes the code just more
complicated.

                 Linus
