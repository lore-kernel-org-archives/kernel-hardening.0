MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1511998718-4158-1-git-send-email-me@tobin.cc>
References: <1511998718-4158-1-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Nov 2017 15:56:16 -0800
Message-ID: <CAGXu5jKG7FD_wGbeGtATLA4h3eAwvV5P+74T=DKAN58XLqGhEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/2] replace %pK with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 3:38 PM, Tobin C. Harding <me@tobin.cc> wrote:
> We are now hashing addresses printed with %pK (when
> kptr_restrict==0). Perhaps we can get rid of %pK (and kptr_restrict)
> entirely. Instead of rushing ahead and doing so let's replace all printk
> format strings that use %pK with %p.

NAK. Real people use kptr_restrict -- removing %pK is a regression for
them. Setting kptr_restrict should zero the values marked with %pK.
There is still a risk of correlating information leaks to at least
select a target. If we add a knob for the %p hashing to switch to
zeroing, then we could drop %pK, IMO.

-Kees

>
> It is a nice time to do this now while we are prepared for breakages
> from applying the pointer hashing patch series.
>
> The patch to remove kptr_restrict entirely should then be a non-event.
>
> Second patch adds printk specifier %pz to display zeroed address. This
> may be useful for fixing things that break during the fallout from
> hashing and replacing %pK. We can always revert this patch if it turns
> out to be worthless, right?
>
> Patch 1 was created using
>
> for file in $(git grep -l '%pK')
> do
>         perl -pi -e 's/%pK/%p/g' $file
> done
>
> thanks,
> Tobin.
>
> Tobin C. Harding (2):
>   tree-wide: replace all users of %pK with %p
>   printk: add specifier %pz, for zeroed address
>
>  Documentation/printk-formats.txt                   | 11 +++
>  arch/arm/mm/physaddr.c                             |  2 +-
>  arch/arm64/mm/physaddr.c                           |  2 +-
>  arch/mips/kernel/relocate.c                        | 10 +--
>  arch/mips/kvm/mips.c                               |  2 +-
>  arch/powerpc/perf/hv-24x7.c                        |  8 +--
>  arch/s390/kvm/intercept.c                          |  2 +-
>  arch/s390/kvm/kvm-s390.c                           | 10 +--
>  arch/s390/kvm/trace-s390.h                         |  4 +-
>  drivers/android/binder.c                           |  2 +-
>  drivers/android/binder_alloc.c                     | 28 ++++----
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  4 +-
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gem.c            |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c            | 22 +++---
>  drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  2 +-
>  drivers/gpu/drm/i915/i915_debugfs.c                |  2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c           |  2 +-
>  drivers/net/wireless/ath/ath10k/ahb.c              |  2 +-
>  drivers/net/wireless/ath/ath10k/bmi.c              |  4 +-
>  drivers/net/wireless/ath/ath10k/ce.c               |  4 +-
>  drivers/net/wireless/ath/ath10k/core.c             |  4 +-
>  drivers/net/wireless/ath/ath10k/htc.c              |  6 +-
>  drivers/net/wireless/ath/ath10k/htt_rx.c           |  2 +-
>  drivers/net/wireless/ath/ath10k/mac.c              | 22 +++---
>  drivers/net/wireless/ath/ath10k/pci.c              |  2 +-
>  drivers/net/wireless/ath/ath10k/testmode.c         |  4 +-
>  drivers/net/wireless/ath/ath10k/txrx.c             |  2 +-
>  drivers/net/wireless/ath/ath10k/usb.c              |  4 +-
>  drivers/net/wireless/ath/ath10k/wmi.c              |  4 +-
>  drivers/spi/spi-loopback-test.c                    | 12 ++--
>  drivers/staging/ccree/ssi_buffer_mgr.c             | 54 +++++++-------
>  drivers/staging/ccree/ssi_cipher.c                 |  4 +-
>  drivers/staging/ccree/ssi_hash.c                   | 30 ++++----
>  .../interface/vchiq_arm/vchiq_2835_arm.c           |  6 +-
>  .../vc04_services/interface/vchiq_arm/vchiq_arm.c  | 16 ++---
>  .../vc04_services/interface/vchiq_arm/vchiq_core.c | 84 +++++++++++-----------
>  .../interface/vchiq_arm/vchiq_kern_lib.c           |  4 +-
>  drivers/usb/core/devio.c                           | 14 ++--
>  drivers/usb/core/hcd.c                             |  4 +-
>  drivers/usb/core/urb.c                             |  2 +-
>  drivers/usb/dwc3/dwc3-st.c                         |  2 +-
>  drivers/usb/dwc3/gadget.c                          |  4 +-
>  include/linux/filter.h                             |  2 +-
>  kernel/cgroup/debug.c                              |  8 +--
>  kernel/module.c                                    |  2 +-
>  kernel/time/timer_list.c                           |  4 +-
>  lib/vsprintf.c                                     | 26 +++++--
>  mm/vmalloc.c                                       |  4 +-
>  net/atm/proc.c                                     |  4 +-
>  net/bluetooth/af_bluetooth.c                       |  2 +-
>  net/can/bcm.c                                      |  6 +-
>  net/can/proc.c                                     |  4 +-
>  net/ipv4/ping.c                                    |  2 +-
>  net/ipv4/raw.c                                     |  2 +-
>  net/ipv4/tcp_ipv4.c                                |  6 +-
>  net/ipv4/udp.c                                     |  2 +-
>  net/ipv6/datagram.c                                |  2 +-
>  net/ipv6/tcp_ipv6.c                                |  6 +-
>  net/key/af_key.c                                   |  2 +-
>  net/netlink/af_netlink.c                           |  2 +-
>  net/packet/af_packet.c                             |  2 +-
>  net/phonet/socket.c                                |  2 +-
>  net/unix/af_unix.c                                 |  2 +-
>  sound/soc/bcm/cygnus-pcm.c                         |  2 +-
>  66 files changed, 269 insertions(+), 240 deletions(-)
>
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
