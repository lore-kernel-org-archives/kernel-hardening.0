Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jun 2012 04:55:12 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120621005512.GB23049@openwall.com>
References: <20120612093812.GA24809@albatros> <alpine.LRH.2.02.1206130119370.32070@argo.troja.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1206130119370.32070@argo.troja.mff.cuni.cz>
Subject: Re: [kernel-hardening] RLIMIT_NPROC DoS fix
To: kernel-hardening@lists.openwall.com
Cc: Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Let's keep this on kernel-hardening only (dropping owl-dev, adding Pavel).

FWIW, in pre-2.6 kernels there was no RLIMIT_NPROC enforcement on
setuid() at all, so adding this check on execve() (like I did in -ow
patches for 2.0-2.4 kernels) made things strictly more restricted.
Now when we applied the same approach to mainline kernels, after
RLIMIT_NPROC enforcement had been added to setuid(), we made things more
relaxed in the way described by Vasily as compared to what they have
been in 2.6 kernels for a long while.  Yet I continue to think that the
RLIMIT_NPROC enforcement on setuid() that existed in 2.6 kernels was
wrong, and overall we're in a better state now.

On Wed, Jun 13, 2012 at 02:22:41AM +0200, Pavel Kankovsky wrote:
> On Tue, 12 Jun 2012, Vasily Kulikov wrote:
> 
> >There is a problem with RLIMIT_NPROC patch:
> >http://www.openwall.com/lists/kernel-hardening/2011/06/12/9
> 
> I'd like to point out there are at least two other ways setuid() et alii 
> can fail in recent kernels: LSM and memory allocation.

LSM can break lots of things. ;-)

As to memory allocation, we previously determined (in last year's
discussion on kernel-hardening) that it currently can't fail - yet I
proposed (and I continue to propose) that we make the code fail-close in
this respect (have the process killed if this currently impossible
condition does occur, such as in a future code revision or if we made an
error in our analysis).  (We already have it that way - with process
killing - in the patch applied on top of RHEL5/OpenVZ kernels in Owl.)

> >1) a root process sometimes does setrlimit()+setuid(U)+execve()/fork().
> >In this case U can do kill(pid, SIGSTOP) each time just after setuid(U).
> >U may store unlimited number of processes this way.
> >(Spender has learned this way.)
> 
> You could probably refuse to handle SIGSTOP sent by a nonprivileged user 
> when PF_NPROC_EXCEEDED is set. I do not thing it would break anything.
> But it would make things even dirtier.

Yes, and we'd need to disallow setpriority() as well.

> >2) there are nonroot users A and B.
> >A makes a binary ./loop which does setuid(A)+for(;;) {}
> >A does chmod u+s ./loop
> >B does 'while :; do ./loop &; done'
> 
> I think processes should count towards RLIMIT_NPROC of the user who forked 
> them (B in this example) for the rest of their CPU cycles. Even after they 
> exec a setuid program.

I think this is already the case, but the crucial detail about Vasily's
example above is that the process itself fully switches to the target
user with a setuid() call - and indeed we perform set_user() on setuid().
Should we start to treat setuid() from non-root real UID specially for
the purpose of RLIMIT_NPROC?  I think not.

Maybe we could postpone set_user() until execve() (which would never
happen in the example above, thereby leaving the process B's for the
purpose of RLIMIT_NPROC).  This would deal with the SIGSTOP attack too.

This needs further consideration.

Alexander
