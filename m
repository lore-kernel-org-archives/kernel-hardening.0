MIME-Version: 1.0
In-Reply-To: <CACXcFm=9WzW4H+7u6M6QTF=LzYUx+GKMVndvPj+z2QhzJote3w@mail.gmail.com>
References: <CACXcFm=9WzW4H+7u6M6QTF=LzYUx+GKMVndvPj+z2QhzJote3w@mail.gmail.com>
From: Shawn <citypw@gmail.com>
Date: Thu, 7 Sep 2017 11:06:27 +0800
Message-ID: <CABniQZMHPmmSSQ7de7TtxuB24iqA8uH4Tn4UEsKnFs-=3RbVaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] ME and PSP
To: Sandy Harris <sandyinchina@gmail.com>
Cc: kernel-hardening@lists.openwall.com, coreboot <coreboot@coreboot.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Sandy,

On Thu, Sep 7, 2017 at 2:37 AM, Sandy Harris <sandyinchina@gmail.com> wrote:
> Recently a few things have been revealed about how to disable the
> Intel Management Engine (ME).
>
> http://blog.ptsecurity.com/2017/08/disabling-intel-me.html
> https://www.theregister.co.uk/2017/08/29/intel_management_engine_can_be_disabled/
>
> I have not seen anything on disabling the similar AMD feature called
> PSP. Either appears to be a huge security hazard -- a device you have
> little choice but to trust but that you have little control over, that
> operates below the level of the main CPU & OS, that has access to
> everything & that is Turing complete so it can do anything.
>
There's not much public research about AMD PSP yet. From the
SW/FW/HW's perspective, a hardened kernel is still important( that's
why PaX/Grsecurity matters a lot) to prevent some attack surfaces from
lower level( let's say Hypervisor( RING -1)/SMM( RING -2/ME( RING
-3)). But the lower level should be concerned as well. We've been
pushing this solution into our customer's production and it's looking
good so far:

https://github.com/hardenedlinux/hardenedlinux_profiles/blob/master/slide/hardening_the_core.pdf

> By the time a hardened kernel loads, it may be too late to prevent ME
> entirely, but are there other things the kernel could do? Issue a
> syslog warning? Monitor ME activity somehow? Restrict its access to
> the network so at least external attacks are blocked?
>
Intel ME has a OS kernel( ThreatdX/MINIX-based) running on a specific
CPU( < v11 is ARC, >=v12 is x86). There's not much kernel can do about
it except a few LKMs( mei/mei_me) can getting some info from the ME.

> There are several different utilities to reduce ME danger, though I
> have not looked at details & I have the impression most do not disable
> it completely. Will current hardened kernels run on a system with ME
> disabled? Is that tested?
>
There are two ways to "disable" ME:

1) Before Mark Ermolov and Maxim Goryachy disclosured this HAP
"secrects" to the public, what me_cleaner(
https://github.com/corna/me_cleaner/) does was removing more ME code
modules as possible and only keep those necessary ones( like
BUP/ROMP/etc). It's not 100% disable it but neutralization achieve the
similar goal. me_cleaner is a free/libre software, all you need to
prepare is a few cheap hardwares( external programmer):

https://hardenedlinux.github.io/firmware/2016/11/17/neutralize_ME_firmware_on_sandybridge_and_ivybridge.html

2) Thanks to Mark Ermolov and Maxim Goryachy, now me_cleaner added an
option( -s) can enabled the HAP bit but keep other code modules as
well. Plz note that some private OEM firmware implementation might
have some side-effects while coreboot is working perfectly( less SMIs
helps?) so far. There are some public test results you can find:

https://github.com/hardenedlinux/hardenedlinux_profiles/tree/master/coreboot
https://github.com/corna/me_cleaner/issues/53

> The best summary of the issue I have seen -- though it is neither
> up-to-date nor devoted to only the one issue is:
> https://blog.invisiblethings.org/papers/2015/x86_harmful.pdf
>
> There has been discussion on the Qubes users list:
> https://groups.google.com/forum/#!forum/qubes-users
>
More fw/ME info:

https://github.com/hardenedlinux/firmware-anatomy/blob/master/hack_ME/me_info.md
https://github.com/hardenedlinux/firmware-anatomy/blob/master/hack_ME/firmware_security.md

> The only plausible solutions suggested there boil down to not using
> recent x86 chips at all. Either use older Intel/AMD parts without the
> feature or go to IBM Power CPUs.
>
IMOHO, RISC-V will be the long-term solution in the future;-)

btw: this might a little bit off-topic on kernel-hardening( I could be
wrong if it weren't). Or feel free to ask question on coreboot's
mailinglist: coreboot@coreboot.org



-- 
GNU powered it...
GPL protect it...
God blessing it...

regards
Shawn
