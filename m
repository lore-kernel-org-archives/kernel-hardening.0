Date: Tue, 13 Jun 2017 23:27:04 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170613212704.GA16726@openwall.com>
References: <20170608034349.31876-1-matt@nmatt.com> <20170608034349.31876-2-matt@nmatt.com> <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com> <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Matt,

I removed most CC's like before, as I don't want my voice on this to be
too loud.

On Thu, Jun 08, 2017 at 11:50:32PM -0400, Matt Brown wrote:
> On 06/08/2017 10:38 PM, Kees Cook wrote:
> >On Wed, Jun 7, 2017 at 8:43 PM, Matt Brown <matt@nmatt.com> wrote:
> >>*  Issues:
> >>   *  Can be bypassed by interpreted languages such as python. You can run
> >>      malicious code by doing: python -c 'evil code'
> >
> >What's the recommendation for people interested in using TPE but
> >having interpreters installed?
> 
> If you don't need a given interpreter installed, uninstall it. While
> this is common sense system hardening it especially would make a
> difference under the TPE threat model.
> 
> I don't have a knock down answer for this. Interpreters are a hard
> problem for TPE.

Interpreters are only a tip of the iceberg.

With TPE, every program invocation becomes similar to a SUID/SGID one as
it relates to TPE's newly introduced security barrier.  However, the
dynamic linker and libc have no idea of this, and will happily grant
arbitrary code execution in context of those programs via LD_PRELOAD and
such.  Even if this is somehow dealt with (how would you do that in the
kernel alone? filter typical env var names? it quickly becomes way too
hackish and blacklistish, thus imperfect), then there's still:

I think many, and maybe most, binaries on a system will contain buffer
overflows and such that also allow for arbitrary code execution.  Those
programs were not written as carefully as SUID/SGID ones are supposed to
be.  They don't treat their input and environment as untrusted.

Closer to the topic of interpreters, there's also this old trick:

$ strace -e execve /lib/ld-linux.so.2 /bin/uname -ms
execve("/lib/ld-linux.so.2", ["/lib/ld-linux.so.2", "/bin/uname", "-ms"], [/* 28 vars */]) = 0
Linux i686
+++ exited with 0 +++

As you can see, the only execve(2) is of the dynamic linker.  Will /lib
or/and /lib64 be among trusted paths in a typical setup?  Well, maybe
not, although not including them will break ldd(1) on the more security
conscious distros, where it uses a similar trick of invoking the dynamic
linker explicitly (rather than the historical unsafe way of invoking the
binary being ldd'ed with some env vars set to tell its dynamic linker to
do the magic rather than proceed to execute the program).

But this last one is relatively minor.  The real big issue is that TPE
is either inherently fairly easily bypassable (and should be documented
as such) via many of the installed programs (by far not just explicit
interpreters, but also any programs containing "weird machines", which
is probably most non-trivial programs out there, and some trivial ones),
or it relies on all programs in the trusted paths being written as if
they were SUID/SGID (unrealistic for non-trivial systems).

Just so that you know what you're getting into, and so that you don't
mislead your users.

Alexander
