MIME-Version: 1.0
In-Reply-To: <20170122221847.GA97816@yamori.belopuhov.com>
References: <20170121234105.GA22967@openwall.com> <CA+rthh-bH-A2Ya1CMfBMZm0fJ4+mnacHn58jaZrURTT9tu0PRA@mail.gmail.com>
 <20170122203158.GB25345@openwall.com> <20170122221847.GA97816@yamori.belopuhov.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Mon, 23 Jan 2017 11:47:26 +0100
Message-ID: <CA+rthh84oFJR1DEQM9cMByOcFpGbj6DZvhfQLMx=F+4sv70trg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Disable and lock Silicon Debug feature on
 modern Intel CPUs
To: Mike Belopuhov <mike@belopuhov.com>
Cc: Solar Designer <solar@openwall.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

[Re-adding kernel-hardening mailing list to Cc -- nothing to hide]

On 22 January 2017 at 23:18, Mike Belopuhov <mike@belopuhov.com> wrote:
> Thanks for bringing this to my attention, it's a pity this kind of
> discussion doesn't happen on the openbsd tech mailing list where I've
> posted the diff and asked for reviews, but no matter.

I'm not on that list, nor am I an OpenBSD user.

> I'll have to double check this information regarding whether or not
> it's possible to manipulate the Silicon Debug Enabled bit in the MSR
> after the OS is booted.  If my memory serves, there were no provisions
> in the description of the MSR itself.

The description of the IA32_DEBUG_INTERFACE MSR, bit 30 reads as follows:

"""
Lock (R/W): If 1, locks any further change
to the MSR. The lock bit is set automatically
on the first SMI assertion even if not
explicitly set by BIOS. Default is 0.
"""

Please notice the "set automatically on the first SMI" part.

> I would also like to know what
> the statement regarding "*every* firmware" is based on?  If such
> mechanism is optional we should not (IMO) make any strong assumptions
> regarding availability of broken firmware images.

The problem is, the reset state of the SMBASE register is 0x30000 --
not only on the BSP but on every AP as well. This creates a problem
for systems with more than a single core as SMIs may be served
simultaneously by multiple cores. The SMI specific register safe and
restore mechanism (see SDM chapter 34.4.1 SMRAM State Save Map) would
trash each others CPU register state if the SMBASE would be the same
on each of the cores. Therefore the firmware needs to reserve a
core-specific dedicated memory location for the SMI register save
state area. This, OTOH, requires writing to registers only available /
accessible in SMM on that specific core, thereby fulfilling the "on
the first SMI" condition of the lock bit of MSR
IA32_DEBUG_INTERFACE... So if that lock bit isn't set on a system,
it's messed up in so many ways, no need to care about SDBG ;)  Oh, and
no, the MSR doesn't get reset on #INIT (see SDM chapter 9.1.1
Processor State After Reset).

> The important part of the diff (which doesn't really cost us anything
> btw) is reporting the hardware that has Silicon Debug enabled and
> locked.

The reporting part is nice, actually.

> This would deter me from purchasing it and it should deter
> users as well.  Currently we're not aware of any hardware vendor who
> have released such hardware, but it's something the time will tell

IIRC the value depends on a PCH boot strap setting, so a firmware
update (or malicious user messing with the flash) may enable SDBG on a
system where it was disabled before. I might remember that one wrong,
though, so take it with a grain of salt... :/

> (CCC talk mentions that Skylake is the first platform that can make
> use of this anyways).

It was introduced with Haswell, actually.

> Unfortunately the OpenBSD dmesg collection [that would be the source
> of such information] is private and is accessible by active OpenBSD
> developers only, so there won't be any public release of such data
> unless it would be specifically organised.

For that to be slightly more useful (and to prove your point, that the
code can, in fact, make some systems More Secure(TM)), it would be
nice to have an additional message when the code succeeded in
disabling SDBG. However, as explained above, I don't think this code
path will ever be executed so...

Cheers,
Mathias

>
> With kind regards,
> Mike
