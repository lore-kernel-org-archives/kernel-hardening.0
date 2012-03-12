Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 15:01:20 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120312140120.GF10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <20120311172512.GA2729@redhat.com>
 <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
 <20120311233233.GC10787@dztty>
 <CA+55aFzVZLqnwiXqH4zm6Vn_2QgiRSTDP8uuY3rXyQhobRv63g@mail.gmail.com>
 <20120312002545.GE10787@dztty>
 <CA+55aFzdLEkzc4iE3J1CgYwuo_cCigsV9RTt-DF2nJniKm0k0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+55aFzdLEkzc4iE3J1CgYwuo_cCigsV9RTt-DF2nJniKm0k0A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2012 at 03:11:43AM -0700, Linus Torvalds wrote:
> On Sun, Mar 11, 2012 at 5:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Sun, Mar 11, 2012 at 04:42:37PM -0700, Linus Torvalds wrote:
> >> That's the point. I made the mistake of using mm_users initially, but
> >> ysing mm_count - which is what I said to use (and what Oleg fixed
> >> things to in commit 6d08f2c71397) should *not* have that problem. It
> >> just keeps the 'struct mm_struct' itself around.
> > And that mm_struct will explode and only the VFS will catch it.
> >
> > Given =A01024 processes * (RLIMIT_NOFILE 1024 - 3) =3D=3D ~1020000
> >
> > more than 1020000 mm structs (all of dead processes ?)
> >
> > A quick test on a default ubuntu:
> > cat /proc/sys/fs/file-max
> > 388411
> >
> > So we are able to keep around 388411 dead mm_struct in memory, just try=
 it.
>=20
> Umm.
>=20
> I think your argument is totally braindead and wrong.
>=20
> My counter-argument is very simple: "So what?"
I thought that keeping these dead bytes alive is not the best solution,
this is why we have all these counters...

My first solution to protect these files was to emulate what you are
currently suggesting, your patch + Olge's patch. I've written a similar
patch to protect /proc/<pid>/{maps,smaps} but later after more thoughts,
an atomic operation (which I'll re-work) and a comparison (without
allocations) seems more benefical if we achieve the same protection.

I must say that I'm confused here:
Sometimes we try to align structs and later we just ignore this ?

> Those mm_structs are small. They are something like a couple of
/sys/kernel/slab/mm_struct/object_size on 64bit gives:
1232

> hundred bytes. If you really worry about open files, you should worry
> about the size of the inode, and people using the "pipe()" system
> call. Then you have those open files with an inode, *and* several kB
> of data that can be trivially filled by the user with a simple
> "write()" that they never need read.
Ok, yes I see.

To clarify: I was worrying about the downsides of keeping dead data alive.

> So "struct mm_struct" is totally irrelevant, and not in any way a
> special thing. It's not the biggest, it's not the most interesting,
> and it's simply not interesting. You're barking up the wrong tree.
Yes it's not the biggest but it's related to the problem, any way here we
are not trying to fix mm_struct, yes we are protecting procfs files.

Perhaps another simple/clean patch will do the job, otherwise protecting
these files is the priority. Thank you for the reminder.

These files need protections and do not operate on mm:
/proc/<pid>/{syscall,stack}

And we need to add the open file operation to most of the /proc/<pid>/*
sensitive files.

> > Our embedded devices will suffer, serial login will be killed, getty, .=
=2E.
> > ssh root owned ... I've experienced this.
>=20
> None of it has anything to do with 'struct mm_struct', though, has it?
>=20
> I suspect the real thing to do is to just make the OOM killer look at
> how many files are open too. Make each open file count as 4kB (or
> more), and use it when deciding what to kill. Fix the actual real
> problem instead of trying to fix one small detail - and one that isn't
> even the right small detail.
With 64 processes or less OOM killer can start killing innocent processes.

(and what about legitimate open files ?)


Thanks for the comments.

>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
tixxdz
http://opendz.org
