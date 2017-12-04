Date: Mon, 4 Dec 2017 13:49:31 +0100
From: Andrew Jones <drjones@redhat.com>
Message-ID: <20171204124931.wg3wmgvzedayprql@kamzik.brq.redhat.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
 <20171127163806.31435-13-mark.rutland@arm.com>
 <20171128150726.xui5i23uigvfo52w@kamzik.brq.redhat.com>
 <20171204123932.pru4lw753xm7qlwb@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171204123932.pru4lw753xm7qlwb@lakrids.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCHv2 12/12] arm64: docs: document pointer authentication
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, cdall@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kvmarm@lists.cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 04, 2017 at 12:39:33PM +0000, Mark Rutland wrote:
> On Tue, Nov 28, 2017 at 04:07:26PM +0100, Andrew Jones wrote:
> > Hi Mark,
> 
> Hi Drew,
> 
> > On Mon, Nov 27, 2017 at 04:38:06PM +0000, Mark Rutland wrote:
> > > +Architecture overview
> > > +---------------------
> > > +
> > > +The ARMv8.3 Pointer Authentication extension adds primitives that can be
> > > +used to mitigate certain classes of attack where an attacker can corrupt
> > > +the contents of some memory (e.g. the stack).
> > > +
> > > +The extension uses a Pointer Authentication Code (PAC) to determine
> > > +whether pointers have been modified unexpectedly. A PAC is derived from
> > > +a pointer, another value (such as the stack pointer), and a secret key
> > > +held in system registers.
> > > +
> > > +The extension adds instructions to insert a valid PAC into a pointer,
> > > +and to verify/remove the PAC from a pointer. The PAC occupies a number
> > > +of high-order bits of the pointer, which varies dependent on the
> > > +configured virtual address size and whether pointer tagging is in use.
> > > +
> > > +A subset of these instructions have been allocated from the HINT
> > > +encoding space. In the absence of the extension (or when disabled),
> > > +these instructions behave as NOPs. Applications and libraries using
> > > +these instructions operate correctly regardless of the presence of the
> > > +extension.
> > 
> > Correctly, but obviously without the additional security. So I assume
> > it's expected that applications that demand this security to probe for
> > it themselves, presumably by the checking the HWCAP. Is that correct?
> 
> Yes. Applications which wish to mandate pointer authentication
> (presumably using instructions outside of the HINT space) must check the
> relevant HWCAP first.
> 
> [...]
> 
> > > +Virtualization
> > > +--------------
> > > +
> > > +When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and uniform HW
> > > +support is present, KVM will context switch all keys used by vCPUs.
> > > +Otherwise, the feature is disabled. When disabled, accesses to keys, or
> > > +use of instructions enabled within the guest will trap to EL2, and an
> > > +UNDEFINED exception will be injected into the guest.
> > 
> > If host applications will just run, with the instructions behaving like
> > NOPs, when the extension is either not present or not enabled, then
> > shouldn't guest applications also just run?
> 
> The enabled/disabled wording is probably the confusing bit here.
> 
> At EL1 we have conditional enables for instructions using
> AP{I,D}{A,B}Key, which behave as NOPs when disabled.
> 
> At EL2 we have a single conditional trap for all instructions using
> pointer authentication, that traps to EL2 when instructions are not
> NOP'd by EL1.
> 
> So "disabled by EL2" is actually "trapped by EL2", and "disabled by EL1"
> is "NOP'd by EL1".
> 
> > I.e. instead of injecting UNDEF, just treat the instructions as NOPs.
> > Or did I misunderstand the trapping?
> 
> I think the documentation explained it poorly. Did the above help?

Yes, both the above and the below have helped me understand. Thanks for
the clarification!

drew

> 
> > Does use of the instructions at EL0 trap to EL1 or EL2?
> 
> If disabled by EL1, the instructions behave as NOPs (regardless of the
> EL2 traps).
> 
> If enabled by EL1, but trapped by EL2, the instructions trap to EL2.
> 
> If enabled by EL1, and not trapped by EL2, the instructions work as
> usual.
> 
> I'll see if I can document this better.
> 
> Thanks,
> Mark.
