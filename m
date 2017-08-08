MIME-Version: 1.0
In-Reply-To: <20170807175533.GA20805@n2100.armlinux.org.uk>
References: <20170726170051.28328-1-thgarnie@google.com> <20170726170051.28328-2-thgarnie@google.com>
 <CAGXu5jLbJuokv+B_Nn8uRDVadi05ywJM7FSgpOr+maO2pQrd0w@mail.gmail.com>
 <CAJcbSZHfoHNPv3tk11iCj49UkLGU-QdeyMj2BS60wng5z5L4pg@mail.gmail.com> <20170807175533.GA20805@n2100.armlinux.org.uk>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 8 Aug 2017 09:06:13 -0700
Message-ID: <CAJcbSZHkWXeLwBj+HOzmEhZCqgyawytgn8PMseTvtb-he5nq6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 2/3] arm/syscalls: Optimize address limit check
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, Leonard Crestez <leonard.crestez@nxp.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 7, 2017 at 10:55 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
>
> It's better in so far as it avoids the problems previously highlighted.
>
> However, it depends how efficient we want these paths to be - the
> difference between your assembly and the assembly I've previously
> supplied is that mine fills in any delay slots with some useful work
> and avoids adding extra delay slots in this path.

The previous assembly implementation we did was design as you
described but all checks were done after the pending work was managed.
I would like the address limit check to be done before, especially if
we move from panic to a SIGKILL approach.

>
> Arguably, the system call exit path is as important as the system
> call entry path for OS performance, so I think we should strive to
> make it as efficient as possible - much as I already did when I
> posted code on this topic previously.

How do you think it could improve while keeping the check before pending work?

>
> I think that code can simply be adapted to call your C function
> instead of the assembly "addr_limit_fail" label.

I don't use the label anymore on this version.

>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> According to speedtest.net: 8.21Mbps down 510kbps up



-- 
Thomas
