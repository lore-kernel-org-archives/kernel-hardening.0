Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 13 Oct 2013 11:18:34 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131013101834.GA4404@dztty>
References: <20131004191113.GA3916@dztty>
 <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty>
 <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty>
 <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
 <20131005132337.GA4095@dztty>
 <CALCETrV2YZUQsFiahmcQECF37=sX6EMiEEjwXX_mcuPf-X3-yw@mail.gmail.com>
 <20131009105402.GA4810@dztty>
 <CALCETrUTppUmPVy-GZg1xBimb95Xq-vD6qkJFrkT4qUKx0-iSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUTppUmPVy-GZg1xBimb95Xq-vD6qkJFrkT4qUKx0-iSA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 09, 2013 at 06:27:22PM +0100, Andy Lutomirski wrote:
> On Wed, Oct 9, 2013 at 11:54 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Mon, Oct 07, 2013 at 02:41:33PM -0700, Andy Lutomirski wrote:
> >> On Sat, Oct 5, 2013 at 6:23 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > On Fri, Oct 04, 2013 at 03:17:08PM -0700, Andy Lutomirski wrote:
> >> >>
> >> >> Exactly.  Hence the NAK.
> >> > But Having two LSM Hooks there is really not practical!
> >>
> >> It'd doable *if* it turns out that it's the right solution.
> >>
> >> But revoke seems much more likely to be simple, comprehensible, and
> >> obviously correct to me.
> > Yes Andy, I agree, revoke is much better!
> >
> > But it will not handle or fix all the situations, as I've said what if
> > revoke is not invloved here? there is no an execve from the target task!
> >
> >
> > Remember:
> > /proc/*/{stat,maps} and perhaps others have 0444 and don't have ptrace
> > checks during ->open() to not break some userspace... especially
> > /proc/*/stat file
> 
> For /proc/*/stat: check permissions when opening.  If the opener
> passes the ptrace check, set a flag in file->private_data indicating
> that this struct file has permission.
That will fix it, but it will need some extra work since
file->private_data is already used to store seq_file structs!

> For /proc/*/maps: either fail the open if the check fails or set a
> flag that causes the resulting struct file to be useless.
Not sure about this, we need to inspect glibc


> >
> >
> > So you will have an fd on these privileged files!
> >
> > Current will execve a privileged process, and pass ptrace_may_access()
> > checks during ->read()...
> >
> > Here revoke is not involved at all! so it will not fix these files and
> > they will continue to be vulnerable.
> >
> > IMO to fix them, we must have the correct ptrace_may_access() check and
> > this involves: current doing an execve + current's cred
> >
> >
> >
> > BTW, Andy we already return 0 (end of file) for /proc/*/mem
> >   ->read()
> >     ->mem_read()
> >       ->mem_rw()
> >         if (!atomic_inc_not_zero(&mm->mm_users))
> >                 return 0
> >
> > So can this be considered some sort of simple revoke?
> >
> 
> Apparently not.  I haven't looked at the code, but I just tried it.
> The fd from /proc/<pid>/maps survives an exec of the process it's
> pointing at.  That means that either the mm changing has no effect on
> the struct file or that an unshared mm survives exec.
yes the old mm (during ->open()) will survive but not vma, ->read() will
return zero

In the mean time, to close some of these vulnerabilities, I'll submit
another patch to prevent open() arbitrary /proc/*/{stack,syscall}

1) Make them 0400
2) Add the ptrace_may_access() during ->open() for ptrace capabilities
   and LSM checks

It would be nice to get your Acked-by Andy!

-- 
Djalal Harouni
http://opendz.org
