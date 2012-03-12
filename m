Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20120312002545.GE10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
 <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
 <20120311233233.GC10787@dztty> <CA+55aFzVZLqnwiXqH4zm6Vn_2QgiRSTDP8uuY3rXyQhobRv63g@mail.gmail.com>
 <20120312002545.GE10787@dztty>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Mar 2012 03:11:43 -0700
Message-ID: <CA+55aFzdLEkzc4iE3J1CgYwuo_cCigsV9RTt-DF2nJniKm0k0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 5:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Sun, Mar 11, 2012 at 04:42:37PM -0700, Linus Torvalds wrote:
>> That's the point. I made the mistake of using mm_users initially, but
>> ysing mm_count - which is what I said to use (and what Oleg fixed
>> things to in commit 6d08f2c71397) should *not* have that problem. It
>> just keeps the 'struct mm_struct' itself around.
> And that mm_struct will explode and only the VFS will catch it.
>
> Given =A01024 processes * (RLIMIT_NOFILE 1024 - 3) =3D=3D ~1020000
>
> more than 1020000 mm structs (all of dead processes ?)
>
> A quick test on a default ubuntu:
> cat /proc/sys/fs/file-max
> 388411
>
> So we are able to keep around 388411 dead mm_struct in memory, just try i=
t.

Umm.

I think your argument is totally braindead and wrong.

My counter-argument is very simple: "So what?"

Those mm_structs are small. They are something like a couple of
hundred bytes. If you really worry about open files, you should worry
about the size of the inode, and people using the "pipe()" system
call. Then you have those open files with an inode, *and* several kB
of data that can be trivially filled by the user with a simple
"write()" that they never need read.

So "struct mm_struct" is totally irrelevant, and not in any way a
special thing. It's not the biggest, it's not the most interesting,
and it's simply not interesting. You're barking up the wrong tree.

> Our embedded devices will suffer, serial login will be killed, getty, ...
> ssh root owned ... I've experienced this.

None of it has anything to do with 'struct mm_struct', though, has it?

I suspect the real thing to do is to just make the OOM killer look at
how many files are open too. Make each open file count as 4kB (or
more), and use it when deciding what to kill. Fix the actual real
problem instead of trying to fix one small detail - and one that isn't
even the right small detail.

                   Linus
