MIME-Version: 1.0
In-Reply-To: <20170726182534.GQ31807@n2100.armlinux.org.uk>
References: <20170719175900.124074-1-thgarnie@google.com> <CAJcbSZFw9GhVvNfYi1oHhpintHSzGcHvGjg5LtRViNBPDzLHaA@mail.gmail.com>
 <1500978481.30745.10.camel@nxp.com> <20170725103828.GJ31807@n2100.armlinux.org.uk>
 <CAJcbSZF1ddWuQ-c2Xyr1Nvrjzg2TZZNHPfSo7R6Vqg2mnhiPOg@mail.gmail.com>
 <20170726120208.GB2115@arm.com> <CAJcbSZG6qsaVGY7Weh6n+xs5XaDg+=h8SDUYJfMUTWbdYOd7rA@mail.gmail.com>
 <20170726182534.GQ31807@n2100.armlinux.org.uk>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 26 Jul 2017 11:29:02 -0700
Message-ID: <CAJcbSZHrh_z1QGPe41OfbEFfR552FgK668JiP3xJjGRddF9AzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/3] arm/syscalls: Move address limit check in loop
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Leonard Crestez <leonard.crestez@nxp.com>, Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 26, 2017 at 11:25 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Jul 26, 2017 at 07:20:22AM -0700, Thomas Garnier wrote:
>> On Wed, Jul 26, 2017 at 5:02 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > I looked to see what you've done for x86, but it looks like you check/clear
>> > the flag before the work pending loop (exit_to_usermode_loop), which
>> > subsequently re-enables interrupts and exits when
>> > EXIT_TO_USERMODE_LOOP_FLAGS are all clear. Since TIF_FSCHECK isn't included
>> > in those flags, what stops it being set again by an irq and remaining set
>> > for the return to userspace?
>>
>> Nothing, I plan to improve the x86 logic later. I focused on ARM/ARM64
>> right now based on Leonard report.
>
> Hmm.  In this case, I'd suggest concentrating on x86 and getting the
> implementation correct there before porting it to other architectures.

I think the ARM architecture is different.

>
> If x86 were to check TIF_FSCHECK in the loop, and repeat until clear,
> would x86 also end up in these infinite loops that have been reported
> on ARM as well?

If for every loop set_fs was called. I think the idea is that at some
point only the TIF_FSCHECK remain. I don't think x86 suffers from the
same issue than ARM.

>
> I strongly suggest testing the behaviour with kprobes/tracing enabled
> for a function called from the work pending loop, and checking how
> that behaves.
>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.



-- 
Thomas
