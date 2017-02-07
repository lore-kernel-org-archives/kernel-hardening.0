MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486427518-14819-1-git-send-email-labbott@redhat.com>
References: <1486427518-14819-1-git-send-email-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Feb 2017 13:06:22 -0800
Message-ID: <CAGXu5jKrUOhpvBye6TeZ38Rw28iZtXRNWuBd7DVBKUHYvq5H_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv3 0/2] Hardening configs refactor/rename
To: Laura Abbott <labbott@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 6, 2017 at 4:31 PM, Laura Abbott <labbott@redhat.com> wrote:
> Hi,
>
> This is v3 of my series to rename/refactor CONFIG_DEBUG_RODATA
> and CONFIG_DEBUG_SET_MODULE_RONX. Among other objections, there shouldn't
> be 'debug' in the name since these provide necessary kernel protection.
>
> v3 mostly focuses on changing how the Kconfig dependencies work for the
> refactor. Russell King requested that these options be deselectable for arm.
> I also threw in some documentation on this under kernel hardening in case other
> arches decide to follow suit.
>
> The plan is for this to go through the KSPP tree so if people are okay with
> this, please give Acks. I didn't take Mark Rutland's ack from before since
> there's been a bit of refactoring.

Thanks! I've added this to my KSPP -next tree. It should appear shortly...

-Kees

>
> Thanks,
> Laura
>
> Laura Abbott (2):
>   arch: Move CONFIG_DEBUG_RODATA and CONFIG_SET_MODULE_RONX to be common
>   arch: Rename CONFIG_DEBUG_RODATA and CONFIG_DEBUG_MODULE_RONX
>
>  Documentation/DocBook/kgdb.tmpl            |  8 +++----
>  Documentation/security/self-protection.txt | 10 +++++++--
>  arch/Kconfig                               | 34 ++++++++++++++++++++++++++++++
>  arch/arm/Kconfig                           |  4 ++++
>  arch/arm/Kconfig.debug                     | 11 ----------
>  arch/arm/configs/aspeed_g4_defconfig       |  4 ++--
>  arch/arm/configs/aspeed_g5_defconfig       |  4 ++--
>  arch/arm/include/asm/cacheflush.h          |  2 +-
>  arch/arm/kernel/patch.c                    |  4 ++--
>  arch/arm/kernel/vmlinux.lds.S              |  8 +++----
>  arch/arm/mm/Kconfig                        | 14 +-----------
>  arch/arm/mm/init.c                         |  4 ++--
>  arch/arm64/Kconfig                         |  5 ++---
>  arch/arm64/Kconfig.debug                   | 13 +-----------
>  arch/arm64/kernel/insn.c                   |  2 +-
>  arch/parisc/Kconfig                        |  1 +
>  arch/parisc/Kconfig.debug                  | 11 ----------
>  arch/parisc/configs/712_defconfig          |  1 -
>  arch/parisc/configs/c3000_defconfig        |  1 -
>  arch/parisc/mm/init.c                      |  2 +-
>  arch/s390/Kconfig                          |  5 ++---
>  arch/s390/Kconfig.debug                    |  3 ---
>  arch/x86/Kconfig                           |  5 ++---
>  arch/x86/Kconfig.debug                     | 11 ----------
>  include/linux/filter.h                     |  4 ++--
>  include/linux/init.h                       |  4 ++--
>  include/linux/module.h                     |  2 +-
>  init/main.c                                |  4 ++--
>  kernel/configs/android-recommended.config  |  2 +-
>  kernel/module.c                            |  6 +++---
>  kernel/power/hibernate.c                   |  2 +-
>  kernel/power/power.h                       |  4 ++--
>  kernel/power/snapshot.c                    |  4 ++--
>  33 files changed, 90 insertions(+), 109 deletions(-)
>
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
