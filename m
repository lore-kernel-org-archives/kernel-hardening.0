Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
References: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
Date: Thu, 5 May 2016 11:26:26 -0700
Message-ID: <CAGXu5j+dw6GjN3piMurBkz7Q6O3XFqsTXP4qfn4LgTtwOoLw6Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 0/3] Add struct randomization plugin
To: Michael Leibowitz <michael.leibowitz@intel.com>
Cc: Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 5, 2016 at 10:21 AM, Michael Leibowitz
<michael.leibowitz@intel.com> wrote:
> This patch set ports over grsecurity's structure randomization
> feature.  The plugin is largely unchanged from grsecurity, with some
> porting to go over Emese Revfy's v7 patch set for gcc plugin
> infrastructure.  This is an RFC.

Very cool, thanks for sending this out!

> Although this set of changes does not directly make exploitation
> harder, when a number of structures are randomized, it will make it
> difficult to splat many relevant structures without knowing the exact
> build of the kernel the target is using.  While for one structure,
> there are limited number of guesses required, in aggregate, this can
> be a large obstacle for exploitation.

Yeah, this is very powerful for people that build their own kernels
(it's a blinding defense that requires many more leaks before most
write attacks can happen). This is handy for distro kernels too, since
it forces attackers to handle all the built versions of a released
kernels.

To that end, if the kernel version changes, it seems like it would
make sense to invalidate the rand seed. It doesn't look like that's
happening, but I might be missing something in the modversioning.

> Patch 3 is a grab bag that probably needs to be broken up, although
> I'm not sure of the best way to do so.  Breaking by subsystem would
> seem to make an unwieldy patch set.

I'm hoping Julia will have some ideas about this. I think it makes
sense to get this fixed on its own, regardless of this feature.

> Known TODO that is not addressed as part of this patch set:
>   * tag security relevant structures for randomization

Does the plugin detect which structures it can randomize, or does it
require this hinting?

>   * add checkpatch checking for non-C99 initialization

Yeah, this would be very nice.

>   * automated testing of randomization

What do you have in mind for this?

>   * better description and examples of exploits effectively mitigated
>     by this feature

Basically everything that uses manual cred writing would be rendered
more difficult by this.

I'd also be curious to see some benchmark examples to identify the
true effect of enabling this and comparing it to the cacheline aware
option, etc.

> Tagging of structures to be randomized will come in subsequent series
> of patches.

Thanks!

-Kees

>
> --
>
>  arch/Kconfig                                    |  35 +
>  arch/x86/include/asm/floppy.h                   |  20 +-
>  arch/x86/include/asm/paravirt_types.h           |  18 +-
>  drivers/acpi/acpica/hwxfsleep.c                 |  11 +-
>  drivers/block/cciss.h                           |  30 +-
>  drivers/gpu/drm/nouveau/nouveau_ttm.c           |  28 +-
>  drivers/gpu/drm/ttm/ttm_bo_manager.c            |  10 +-
>  drivers/gpu/drm/virtio/virtgpu_ttm.c            |  10 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c   |  10 +-
>  drivers/infiniband/hw/nes/nes_cm.c              |  22 +-
>  drivers/isdn/gigaset/bas-gigaset.c              |  32 +-
>  drivers/isdn/gigaset/ser-gigaset.c              |  32 +-
>  drivers/isdn/gigaset/usb-gigaset.c              |  32 +-
>  drivers/isdn/i4l/isdn_concap.c                  |   6 +-
>  drivers/isdn/i4l/isdn_x25iface.c                |  16 +-
>  drivers/media/pci/solo6x10/solo6x10-g723.c      |   2 +-
>  drivers/net/ethernet/brocade/bna/bna_enet.c     |   8 +-
>  drivers/net/wan/lmc/lmc_media.c                 |  97 +--
>  drivers/scsi/bfa/bfa_fcs.c                      |  19 +-
>  drivers/scsi/bfa/bfa_fcs_lport.c                |  29 +-
>  drivers/scsi/bfa/bfa_modules.h                  |  12 +-
>  drivers/scsi/hpsa.h                             |  40 +-
>  drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |   2 +-
>  drivers/staging/lustre/lustre/libcfs/module.c   |  10 +-
>  drivers/video/fbdev/matrox/matroxfb_DAC1064.c   |  10 +-
>  drivers/video/fbdev/matrox/matroxfb_Ti3026.c    |   5 +-
>  fs/reiserfs/item_ops.c                          |  24 +-
>  include/linux/compiler-gcc.h                    |   5 +
>  include/linux/compiler.h                        |   9 +
>  include/linux/rbtree_augmented.h                |   4 +-
>  include/linux/vermagic.h                        |   9 +-
>  kernel/module.c                                 |  27 +
>  lib/rbtree.c                                    |   4 +-
>  mm/page_alloc.c                                 |   2 +-
>  net/atm/lec.c                                   |   6 +-
>  net/atm/mpoa_caches.c                           |  41 +-
>  net/vmw_vsock/vmci_transport_notify.c           |  30 +-
>  net/vmw_vsock/vmci_transport_notify_qstate.c    |  30 +-
>  scripts/Makefile.gcc-plugins                    |  11 +-
>  scripts/gcc-plugins/.gitignore                  |   1 +
>  scripts/gcc-plugins/Makefile                    |  12 +
>  scripts/gcc-plugins/gen-random-seed.sh          |   8 +
>  scripts/gcc-plugins/randomize_layout_plugin.c   | 935 ++++++++++++++++++++++++
>  sound/synth/emux/emux_seq.c                     |  14 +-
>  44 files changed, 1402 insertions(+), 316 deletions(-)
>



-- 
Kees Cook
Chrome OS & Brillo Security
