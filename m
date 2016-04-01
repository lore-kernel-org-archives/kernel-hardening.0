Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Apr 2016 15:57:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
Message-ID: <20160401125746.GC2088@uranus.lan>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com>
 <56FAF571.3040802@eng.utah.edu>
 <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
 <CA+55aFzY0p5OyTfnajTz2SL9qni=0FyUT7SeqS0CuXnwRPHS5w@mail.gmail.com>
 <56FB0C65.4020602@eng.utah.edu>
 <87d1qafldd.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d1qafldd.fsf@x220.int.ebiederm.org>
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Scotty Bauer <sbauer@eng.utah.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, criu@openvz.org, Pavel Emelyanov <xemul@virtuozzo.com>, Andrey Vagin <avagin@virtuozzo.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 31, 2016 at 03:22:38PM -0500, Eric W. Biederman wrote:
> 
> Cc' the Criu list to attempt to give them a heads up.

Thanks Eric! I managed to miss this thread (I try to scan
lkml descussions one a day in my inbox, but this one somehow
escaped, thank you!)

> Scotty Bauer <sbauer@eng.utah.edu> writes:
...
> >> Because if it does break anything, it needs to be turned off by
> >> default. That's a hard rule. And since that would be largely defeating
> >> the whole point o fthe series, I think we really need to have made
> >> sure nothing breaks before a patch series like this can be accepted.
> >> 
> >> That said, if this is done right, I don't think it will break
> >> anything. CRIU may indeed be a special case, but CRIU isn't really a
> >> normal application, and the CRIU people may need to turn this off
> >> explicitly, if it does break.
> >> 
> >> But yes, dosemu needs to be tested, and needs to just continue
> >> working. But does dosemu actually create a signal stack, as opposed to
> >> just playing with one that has been created for it? I thought it was
> >> just the latter case, which should be ok even with a magic cookie in
> >> there.
...
> > For what it's worth this series is breaking CRIU, I just tested:
> >
> > root@node0:/mnt/criu# criu restore -vvvv -o restore.log --shell-job
> > root@node0:/mnt/criu# tail -3 /var/log/syslog
> > Mar 29 17:12:08 localhost kernel: [ 3554.625535] Possible exploit attempt or buggy program!
> > Mar 29 17:12:08 localhost kernel: [ 3554.625535] If you believe this is an error you can disable SROP  Protection by #echo 1 > /proc/sys/kernel/disable-srop-protection
> > Mar 29 17:12:08 localhost kernel: [ 3554.625545] test_[25305] bad frame in rt_sigreturn frame:000000000001e540 ip:7f561542cf20 sp:7ffe004ecfd8 orax:ffffffffffffffff in libc-2.19.so[7f561536c000+1bb0]
> > root@node0:/mnt/criu# echo 1 > /proc/sys/kernel/disable-srop-protection 
> > root@node0:/mnt/criu# criu restore -vvvv -o restore.log --shell-job
> > slept for one second
> > slept for one second
> > slept for one second
> > slept for one second
> > root@node0:/mnt/criu#
> 
> Which means that if checkpoint/restart is going to continue to be
> something that is possible in Linux it should be possible to
> save/restore the per process sig_cookie.  Perhaps with a prctl?

Yes please. Currently (together with other aims) we're trying to
remove "root-only" requirement from criu, so user would be able
to c/r non-privileged processes without sudo/su. Thus I presume
such prctl will be cap-sysadmin only and we will have to run some
suid'ed daemon for it or something.

> This should be addressed as part of this patchset as making that
> information too easily accessible/changable will defeat the security
> guarantees.  Making it too difficult to do destroys the ability to
> migrate a process from one kernel to another.  As the existence of CRIU
> attests it is desirable to have a checkpoint/restart capability in the
> kernel.

To change sigframe an attacked process must have had some code
already injected and this cookie guard will help but not _that_
much I think.

> > I'm working on getting dosemu up and running-- are there any other applications
> > off the top of your head that I should be testing with?
> 
> There are a set of POSIX functions setcontext, getcontext, makecontext
> and swapcontext that to the best of my knowledge deal in signal stacks.
> Although I don't know that they use sigreturn.  Anything that makes use
> of those is potentially affected.
> 
> Perhaps you can find binaries that care by looking for libraries and
> executables that import those elf symbols.  glibc certainly provides
> them.

	Cyrill
