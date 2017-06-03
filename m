Message-ID: <1496510200.29378.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 03 Jun 2017 13:16:40 -0400
In-Reply-To: <20170603162231.GA20590@openwall.com>
References: <20170603055351.16080-1-matt@nmatt.com>
	 <20170603154707.GA19161@openwall.com> <20170603155920.GA25740@kroah.com>
	 <20170603162231.GA20590@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as
 a stackable LSM
To: Solar Designer <solar@openwall.com>, Greg KH <greg@kroah.com>
Cc: Matt Brown <matt@nmatt.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 2017-06-03 at 18:22 +0200, Solar Designer wrote:
> On Sat, Jun 03, 2017 at 05:59:20PM +0200, Greg KH wrote:
> > But for those systems, and this feature as well, can't a "simple"
> > apparmor policy do the exact same thing?  Also, I'm sure the SELinux
> > can
> > do this as well, but I don't know the config language there as well.
> > 
> > So I think this is already a feature that is supported, it just
> > takes a
> > bit more configuration work on the admin.
> 
> Yes, that's "a bit" more effort up to the point where almost(?) no one
> would bother.  Sometimes simple features can reasonably co-exist with
> more general frameworks that could also be used to achieve the effect.
> So I don't view this as a sufficiently good argument against TPE as a
> feature on its own.
> 
> Alexander

Some thoughts on this, veering a bit into some loosely related topics:

SELinux can cover the same kind of stuff as PaX MPROTECT (execmem,
execheap, execstack, execmod) and grsecurity TPE (execute and
execute_no_trans). Android uses it to enforce comparable rules for most
of the SELinux domains in the base system, but the Android Runtime JIT
and Chromium JIT (particularly in the WebView) block the equivalent to
MPROTECT for much of the app layer and Play Services violates rules
comparable to TPE in the app layer too. In CopperheadOS, it's taken to
completion because the WebView sandbox is force enabled and the Android
Runtime is set to use full ahead-of-time compilation without the JIT.
Nothing violates the equivalent to the TPE rules in the Android Open
Source Project. The domain for the Chromium sandbox is the only one with
execmem and only the privileged base system really violates the TPE
style guarantees (system_server/installd can install an app and run it
in one of the app domains at the very least).

Beyond these features, there's also a distinction between code from
verified/trusted partitions (i.e. covered by dm-verity) and from
partitions that hold persistent state rather than being pristine
verified OS partitions. There's more to "trust" than just whether only
root or root / current user can write there. Android *mostly* forbids
the base system from executing code from outside of those verified
partitions too, but it falls a bit short and that's something else
that's finished off in CopperheadOS. I wouldn't go as far as to say it
makes verified boot work well for anything beyond the usual guarantees
for factory resets though. There's still a lot of trust in persistent
state, just not code executed from it by the base system. The SELinux
label usage also needs to be audited to make sure that an attacker can't
persist unverified SELinux labels that are not replaced. Verified boot
is really hard to do in a meaningful way. ChromeOS weakened it via
having an Android userspace in a container since the guarantees dropped
to those of Android there.

I see why people want lightweight, independent implementations of these
features but I don't have a use for it anymore. I'm used to having great
full system SELinux policies as a baseline from the Android Open Source
Project and being able to tweak those existing policies to accomplish
targeted goals like these. It provides much finer-grained control so it
can do a lot more and compatibility is easier. The one thing it isn't
capable of dealing with on Android is a dynamic toggle because Android
uses a static SELinux policy. It's not possible to have a toggle for
things like debugging features exposed via toggles over ADB that doesn't
at least require respawning processes to get them into a different debug
domain. That's why perf_event_paranoid=3 is needed for Android even if
an LSM hook is added there and why ptrace_scope=2 in CopperheadOS does
something that SELinux (on Android) and seccomp-bpf can't accomplish. On
the other hand, I don't really have any use for TPE since doing it with
SELinux doesn't interfere with debugging so a toggle isn't needed.

There's always the option of making a stub SELinux policy used for
little more than covering similar ground to MPROTECT and TPE if that is
really all someone wants. The policy would be tiny. There can be one
domain for nearly everything and one for an exception from the rules.
The labelling would be simple too. I'm curious how minimal that could
be, but focusing on only those specific micro issues is probably not
something people are going to do in practice.
