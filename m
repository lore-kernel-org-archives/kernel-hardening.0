Date: Thu, 30 Nov 2017 17:30:06 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171130163006.GA2391@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop> <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com> <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com> <20171127002641.GA14743@openwall.com> <CAJHCu1+yjSCReBGG4=K2Kx-iTjVxbSTqacM9bNVPNdg74pGoow@mail.gmail.com> <1512053826.26048.8.camel@hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512053826.26048.8.camel@hellion.org.uk>
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, David Laight <David.Laight@aculab.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replying to Salvatore and Ian at once, and CC'ing H. Peter Anvin and
Karel Zak for util-linux flock(1).

On Thu, Nov 30, 2017 at 02:57:06PM +0000, Ian Campbell wrote:
> On Thu, 2017-11-30 at 15:39 +0100, Salvatore Mesoraca wrote:
> > 2017-11-27 1:26 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > Why would "shared lock files based on flock()" need O_CREAT without
> > > O_EXCL?  Where specifically are they currently used that way?
> > 
> > I don't think that they *need* to act like this, but this is how
> > util-linux's flock(1) currently works.

Oh, but you never referred to flock(1) in there, so I read flock() as
implying flock(2).  I think util-linux's flock(1) is relatively obscure,
and as far as I can tell it isn't documented anywhere whether it may be
used on untrusted lock file directories or not.  A revision of the
flock(1) man page seen on RHEL7 gives really weird examples using /tmp.
The current util-linux-2.31/sys-utils/flock.1 is similar.  strace'ing
those examples, I see flock(1) literally uses the /tmp directory itself
(not a file inside) as the lock, which surprisingly appears to work.
Checking the util-linux tree, it looks like this was added as a feature.
I suppose the good news is this doesn't appear to allow for worse than a
DoS against the script using flock(1) (since a different user can also
take that lock), unless any of the upper level directories are also
untrusted.  The man page as seen at https://linux.die.net/man/1/flock
currently only lists a more complex example with /var/lock/mylockfile,
where flock(1) itself is asked to access it via a pre-opened fd.
Permissions on /var/lock vary between distros (e.g., a RHEL6'ish system
I just checked has it as 775 root:lock, whereas a RHEL7'ish has it as
symlink to ../run/lock, which is 755 root:root).  Anyway, these are just
examples.  The reality is people will use flock(1) in various directories,
some of them trusted and some not.  If our proposed policy can detect and
optionally break some uses in untrusted directories, that's good since
such uses are currently unsafe (see below).

> > And it doesn't seem an unreasonable behavior from their perspective,
> 
> I thought that too, specifically I reasoned that using O_EXCL would
> defeat the purpose of the _shared_ flock(), wouldn't it?

No.  O_EXCL means the attempt to O_CREAT will fail, at which point the
program can retry without both of these flags.  (The actual lock is
obtained later via flock(2) or fcntl(2) anyway.)  In fact, flock(1)
already does something similar, as tested using the very first example
from the man page on a RHEL7'ish system:

$ strace flock /tmp -c cat
[...]
open("/tmp", O_RDONLY|O_CREAT|O_NOCTTY, 0666) = -1 EISDIR (Is a directory)
open("/tmp", O_RDONLY|O_NOCTTY)         = 3
flock(3, LOCK_EX)                       = 0

As you can see, when O_CREAT failed, the program retried without that
flag.  It could just as easily have tried O_CREAT|O_EXCL, then dropped
both at once.  Testing with a lock file (rather than lock directory):

$ strace flock /tmp/lockfile -c cat
[...]
open("/tmp/lockfile", O_RDONLY|O_CREAT|O_NOCTTY, 0666) = 3
flock(3, LOCK_EX)                       = 0

This use of flock(1) would be a worse vulnerability, not limited to DoS
against the script itself but also allowing for privilege escalation
unless (sym)link restrictions are enabled in the kernel.  Adding O_EXCL
would help (reduce the impact back to DoS against itself), and would
require that the retry logic (like what is seen in the lock directory
example above) be present.

On Thu, Nov 30, 2017 at 03:39:48PM +0100, Salvatore Mesoraca wrote:
> so maybe other programs do that too.

Maybe, and they would be similarly vulnerable if they do that in
untrusted directories, and they would also need to be fixed.

A subtle case is when something like this is technically done in a
directory writable by someone else, but is not necessarily crossing
what the program's author or the sysadmin recognize as a privilege
boundary.  Maybe they have accepted that this one pseudo-user can
attack that other one anyway, such as because under a certain daemon's
privsep model the would-be attacking pseudo-user is necessarily more
privileged anyway.  This is why we shouldn't by default extend this
policy to all directories writable by someone else, but instead we
consider introducing a sysctl with varying policy levels - initially
focusing on sticky directories writable by someone else and only later
optionally extending to non-sticky directories writable by someone else.
The latter mode would have even greater focus on development and
debugging rather than on production use, although I imagine that
specific systems could eventually afford it in production as well.

> I was citing that case just to make it clear that, if someone gets
> a warning because of flock(1), they shouldn't be worried about it.

Checking the util-linux-2.31/sys-utils/flock.c, I see that it in fact
doesn't retry without O_CREAT in the non-directory case.  That would
need to be corrected, along with introduction of O_EXCL.

> That behavior can be certainly avoided, but of course it isn't a
> security problem per se.

I think it is a security problem per se, except in the "subtle case"
above, and it's great that our proposed policy would catch it.

Perhaps flock(1) should be extended as follows:

> > If a program does
> > that, we could want to find out and revise it (if O_CREAT|O_EXCL fails,
> > retry without these to open the existing file, then flock() either way).
> 
> Yes, this would probably be the best thing to do, good idea.

util-linux-2.31/sys-utils/flock.c currently has:

static int open_file(const char *filename, int *flags)
{

	int fd;
	int fl = *flags == 0 ? O_RDONLY : *flags;

	errno = 0;
	fl |= O_NOCTTY | O_CREAT;
	fd = open(filename, fl, 0666);

	/* Linux doesn't like O_CREAT on a directory, even though it
	 * should be a no-op; POSIX doesn't allow O_RDWR or O_WRONLY
	 */
	if (fd < 0 && errno == EISDIR) {
		fl = O_RDONLY | O_NOCTTY;
		fd = open(filename, fl);
	}

I think this should be revised to:

	fl |= O_NOCTTY | O_CREAT | O_EXCL;
	fd = open(filename, fl, 0666);

	/* Linux doesn't like O_CREAT on a directory, even though it
	 * should be a no-op; POSIX doesn't allow O_RDWR or O_WRONLY
	 */
	if (fd < 0) {
		if (errno == EISDIR)
			fl = O_RDONLY | O_NOCTTY;
		else
			fl &= ~(O_CREAT | O_EXCL);
		fd = open(filename, fl);
	}

This adds O_EXCL and retry without O_CREAT|O_EXCL for non-directories.

[ The pre-umask permissions of 0666 are also a potential concern since
many users have a relaxed umask as distro default, but changing these to
0600 would break some otherwise valid uses where a lock file may be
shared between different users on purpose.  Maybe a future major version
of flock(1) could default to 0600 and/or accept a "-m" option to set the
lock file's mode in case a new file gets created.  mktemp(1) may be
viewed as precedent: it uses pre-umask permissions of 0600.  Lock files
are arguably somewhat similar to temporary files.  This is beyond scope
of this thread and LKML, though, and should be discussed elsewhere. ]

Alexander
