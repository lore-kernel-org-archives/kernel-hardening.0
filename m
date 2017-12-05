MIME-Version: 1.0
In-Reply-To: <20171130163006.GA2391@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop>
 <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com> <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
 <20171127002641.GA14743@openwall.com> <CAJHCu1+yjSCReBGG4=K2Kx-iTjVxbSTqacM9bNVPNdg74pGoow@mail.gmail.com>
 <1512053826.26048.8.camel@hellion.org.uk> <20171130163006.GA2391@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 5 Dec 2017 11:21:00 +0100
Message-ID: <CAJHCu1KkTevQNoVZF0qTVfUzJbWmQsegHkVZSEpbJZAZhNdoew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, David Laight <David.Laight@aculab.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-30 17:30 GMT+01:00 Solar Designer <solar@openwall.com>:
> Replying to Salvatore and Ian at once, and CC'ing H. Peter Anvin and
> Karel Zak for util-linux flock(1).
>
> On Thu, Nov 30, 2017 at 02:57:06PM +0000, Ian Campbell wrote:
> > On Thu, 2017-11-30 at 15:39 +0100, Salvatore Mesoraca wrote:
> > > 2017-11-27 1:26 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > > Why would "shared lock files based on flock()" need O_CREAT without
> > > > O_EXCL?  Where specifically are they currently used that way?
> > >
> > > I don't think that they *need* to act like this, but this is how
> > > util-linux's flock(1) currently works.
>
> Oh, but you never referred to flock(1) in there, so I read flock() as
> implying flock(2).

That's true, I observed that behavior in flock(1), but I didn't specify
it was flock(1) because I thought that there may be some other users of
flock(2) that works that way.

> I think util-linux's flock(1) is relatively obscure,
> and as far as I can tell it isn't documented anywhere whether it may be
> used on untrusted lock file directories or not.  A revision of the
> flock(1) man page seen on RHEL7 gives really weird examples using /tmp.
> The current util-linux-2.31/sys-utils/flock.1 is similar.  strace'ing
> those examples, I see flock(1) literally uses the /tmp directory itself
> (not a file inside) as the lock, which surprisingly appears to work.
> Checking the util-linux tree, it looks like this was added as a feature.
> I suppose the good news is this doesn't appear to allow for worse than a
> DoS against the script using flock(1) (since a different user can also
> take that lock), unless any of the upper level directories are also
> untrusted.  The man page as seen at https://linux.die.net/man/1/flock
> currently only lists a more complex example with /var/lock/mylockfile,
> where flock(1) itself is asked to access it via a pre-opened fd.
> Permissions on /var/lock vary between distros (e.g., a RHEL6'ish system
> I just checked has it as 775 root:lock, whereas a RHEL7'ish has it as
> symlink to ../run/lock, which is 755 root:root).  Anyway, these are just
> examples.  The reality is people will use flock(1) in various directories,
> some of them trusted and some not.  If our proposed policy can detect and
> optionally break some uses in untrusted directories, that's good since
> such uses are currently unsafe (see below).
>
> > > And it doesn't seem an unreasonable behavior from their perspective,
> >
> > I thought that too, specifically I reasoned that using O_EXCL would
> > defeat the purpose of the _shared_ flock(), wouldn't it?
>
> No.  O_EXCL means the attempt to O_CREAT will fail, at which point the
> program can retry without both of these flags.  (The actual lock is
> obtained later via flock(2) or fcntl(2) anyway.)  In fact, flock(1)
> already does something similar, as tested using the very first example
> from the man page on a RHEL7'ish system:
>
> $ strace flock /tmp -c cat
> [...]
> open("/tmp", O_RDONLY|O_CREAT|O_NOCTTY, 0666) = -1 EISDIR (Is a directory)
> open("/tmp", O_RDONLY|O_NOCTTY)         = 3
> flock(3, LOCK_EX)                       = 0
>
> As you can see, when O_CREAT failed, the program retried without that
> flag.  It could just as easily have tried O_CREAT|O_EXCL, then dropped
> both at once.  Testing with a lock file (rather than lock directory):
>
> $ strace flock /tmp/lockfile -c cat
> [...]
> open("/tmp/lockfile", O_RDONLY|O_CREAT|O_NOCTTY, 0666) = 3
> flock(3, LOCK_EX)                       = 0
>
> This use of flock(1) would be a worse vulnerability, not limited to DoS
> against the script itself but also allowing for privilege escalation
> unless (sym)link restrictions are enabled in the kernel.  Adding O_EXCL
> would help (reduce the impact back to DoS against itself), and would
> require that the retry logic (like what is seen in the lock directory
> example above) be present.
>
> On Thu, Nov 30, 2017 at 03:39:48PM +0100, Salvatore Mesoraca wrote:
> > so maybe other programs do that too.
>
> Maybe, and they would be similarly vulnerable if they do that in
> untrusted directories, and they would also need to be fixed.
>
> A subtle case is when something like this is technically done in a
> directory writable by someone else, but is not necessarily crossing
> what the program's author or the sysadmin recognize as a privilege
> boundary.  Maybe they have accepted that this one pseudo-user can
> attack that other one anyway, such as because under a certain daemon's
> privsep model the would-be attacking pseudo-user is necessarily more
> privileged anyway.  This is why we shouldn't by default extend this
> policy to all directories writable by someone else, but instead we
> consider introducing a sysctl with varying policy levels - initially
> focusing on sticky directories writable by someone else and only later
> optionally extending to non-sticky directories writable by someone else.
> The latter mode would have even greater focus on development and
> debugging rather than on production use, although I imagine that
> specific systems could eventually afford it in production as well.
>
> > I was citing that case just to make it clear that, if someone gets
> > a warning because of flock(1), they shouldn't be worried about it.
>
> Checking the util-linux-2.31/sys-utils/flock.c, I see that it in fact
> doesn't retry without O_CREAT in the non-directory case.  That would
> need to be corrected, along with introduction of O_EXCL.
>
> > That behavior can be certainly avoided, but of course it isn't a
> > security problem per se.
>
> I think it is a security problem per se, except in the "subtle case"
> above, and it's great that our proposed policy would catch it.

I agree on the DoS, though, at first, I didn't consider it a "bug" because
there isn't any open mode that can prevent the DoS in this case.
If you want to avoid it, you must avoid other-users-writable directories
at all. So, It think that, if you are using a sticky directory, it's
intended behavior to let someone else "lock" you.
But maybe many flock(1) users are not aware of the issue and so, sometimes,
it can be unintended.
I didn't consider privilege escalation as an issue because I always
looked at flock(1) under the assumption that the lockfile is never actually
read or modified in any way and so it shouldn't make too much difference if
it's an already existing regular file or a symlink etc.
Am I missing something?

Salvatore
