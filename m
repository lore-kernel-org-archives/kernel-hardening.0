MIME-Version: 1.0
In-Reply-To: <20170725103828.GJ31807@n2100.armlinux.org.uk>
References: <20170719175900.124074-1-thgarnie@google.com> <CAJcbSZFw9GhVvNfYi1oHhpintHSzGcHvGjg5LtRViNBPDzLHaA@mail.gmail.com>
 <1500978481.30745.10.camel@nxp.com> <20170725103828.GJ31807@n2100.armlinux.org.uk>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 25 Jul 2017 13:01:17 -0700
Message-ID: <CAJcbSZF1ddWuQ-c2Xyr1Nvrjzg2TZZNHPfSo7R6Vqg2mnhiPOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/3] arm/syscalls: Move address limit check in loop
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Leonard Crestez <leonard.crestez@nxp.com>, Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <Dave.Martin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 3:38 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Tue, Jul 25, 2017 at 01:28:01PM +0300, Leonard Crestez wrote:
>> On Mon, 2017-07-24 at 10:07 -0700, Thomas Garnier wrote:
>> > On Wed, Jul 19, 2017 at 10:58 AM, Thomas Garnier <thgarnie@google.com
>> > > wrote:
>> > >
>> > > The work pending loop can call set_fs after addr_limit_user_check
>> > > removed the _TIF_FSCHECK flag. To prevent the infinite loop, move
>> > > the addr_limit_user_check call at the beginning of the loop.
>> > >
>> > > Fixes: 73ac5d6a2b6a ("arm/syscalls: Check address limit on user-
>> > > mode return")
>> > > Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
>> > > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>
>> > Any comments on this patch set?
>>
>> Tested-by: Leonard Crestez <leonard.crestez@nxp.com>
>>
>> This appears to fix the original issue of failing to boot from NFS when
>> there are lots of alignment faults. But this is a very basic test
>> relative to the reach of this change.
>>
>> However the original patch has been in linux-next for a while and
>> apparently nobody else noticed system calls randomly hanging on arm.
>>
>> I assume maintainers need to give their opinion.
>
> I've already stated my opinion, which is different from what Linus has
> requested of Thomas.  IMHO, the current approach is going to keep on
> causing problems along the lines that I've already pointed out.

I understand. Do you think this problem apply to arm64 as well?

>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.



-- 
Thomas
