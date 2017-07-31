Date: Mon, 31 Jul 2017 15:38:34 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170731133834.GA6947@openwall.com>
References: <CAGXu5j+nB-0B9UNWV_u+xdWtmLnUQewfGXi2Kd=KjSLrcQu=NQ@mail.gmail.com> <5913BD53.14417.3F7C9BC9@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5913BD53.14417.3F7C9BC9@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] It looks like there will be no more public versions of PaX and Grsec.
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

I've just re-read PaX Team's lengthy message from May (back then, I only
skimmed it).  I felt I owed PaX/grsecurity at least as much to hopefully
understand their position better, which I admit I still don't understand
very well.  But that's not why I post this belated reply.  Rather, I
found in the message a detail I feel I have to correct as the issue is
partially my responsibility and I want to share the lessons learned:

On Thu, May 11, 2017 at 03:24:35AM +0200, PaX Team wrote:
> > It does underscore the critical need to upstream stuff, though.
> > Forks of projects might disappear at any time. :(
[...]

> as another counterexample to why that 'critical need' can be
> overrated, one can also look to the unprivileged ping code
> (somewhat ironically, it's a security related feature, not
> unlike the topic here), introduced on this very same list
> years ago by Vasiliy Kulikov via a Google Summer of Code
> project. it was later maintained by upstream developers who
> then introduced several exploitable vulnerabilities in it.

The exploitable vulnerabilities that I think PaX Team is referring to
were introduced during forward-porting of the patch prior to it getting
accepted upstream.  Thus, in one way yes the bugs were part of the
upstreaming effort, but in another way no they were not by upstream
developers.  Rather, in hindsight neither Vasiliy nor I (his GSoC
mentor) were familiar enough with the target kernel version's APIs (the
forward-porting was from 2.4.32 to 3.0), and we didn't perform enough
testing (not of obscure cases not occurring in ping(1), such as
disconnecting and reconnecting the same ping socket).

Those bugs were found by different third-parties through fuzzing, and
fixed by upstream kernel developers.

Lessons (re-)learned include:

1. Tough to make non-trivial contributions to the kernel (especially by
"outsiders" or/and after having been "on hiatus") without introducing
bugs.  Even if tests appear to pass at first (ping(1) worked fine via
the new sockets, including if invoked repeatedly and concurrently).

2. Kernel APIs are very brittle, locking conventions are non-obvious.

3. Kernel hardening efforts should include making the APIs less brittle
or/and to have things fail in less dangerous or at least less likely
exploitable ways.  In fact, in the aftermath of one of these bugs the
list pointer poison values have been adjusted not to be valid addresses
(which I think had been done in grsecurity before).  The refcount
overflow work is also relevant.

4. Forward-ports (and perhaps distro vendors' back-ports too?) tend to
receive less scrutiny than brand new code, but bugs are just as easily
introduced (or even easier if the porting isn't by the original author).
Patch made to apply and the feature works, so we're OK?  No, we are not.

5. One thing we did right was making the feature unavailable to non-root
by default.  We knew we'd be increasing the attack surface otherwise,
and instead we wanted to introduce this layer of privsep - having ping
SGID to a group (instead of SUID root), and having it use the new ping
sockets, without exposing those sockets to potential exploits directly.
This caution paid off.

6. As expected, some systems ended up exposing the sockets to users
other than host root anyway.  I expected this in container setups, where
container root would have access (can't do much about this while also
keeping root as powerful in their container as root would normally be on
a Unix system).  I didn't expect it, but Android also exposed the
sockets to all users.

7. The advances in kernel syscall fuzzing are great.  These days, if
similar bugs get in I hope most would be found by someone running a
fuzzer sooner (the ping socket bugs were found over quite a long period
of time).  Preferably, contributors themselves should run focused
fuzzing efforts on the syscalls, socket types, etc. they add or modify.
And non-focused too, so that interactions with other calls are exposed.

Alexander
