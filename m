Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 21:48:10 +0000
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20161110214810.GH17134@arm.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-10-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478809488-18303-10-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 09/13] drivers: identify wrapping atomic usage
 (part 1/2)
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:44PM +0200, Elena Reshetova wrote:
> From: David Windsor <dwindsor@gmail.com>
> 
> In some cases atomic is not used for reference
> counting and therefore should be allowed to overflow.
> Identify such cases and make a switch to non-hardened
> atomic version.
> 
> This might need more fine-grained split between
> different drivers.
> 
> The copyright for the original PAX_REFCOUNT code:
>   - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
>   - various false positive fixes: Mathias Krause <minipli@googlemail.com>
> 
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  drivers/acpi/apei/ghes.c                  |   4 +-
>  drivers/ata/libata-core.c                 |   5 +-
>  drivers/ata/libata-scsi.c                 |   2 +-
>  drivers/ata/libata.h                      |   2 +-
>  drivers/base/power/wakeup.c               |   8 +-
>  drivers/block/drbd/drbd_bitmap.c          |   2 +-
>  drivers/block/drbd/drbd_int.h             |   9 +-
>  drivers/block/drbd/drbd_main.c            |  15 +--
>  drivers/block/drbd/drbd_nl.c              |  16 +--
>  drivers/block/drbd/drbd_receiver.c        |  34 +++----
>  drivers/block/drbd/drbd_worker.c          |   8 +-
>  drivers/char/ipmi/ipmi_msghandler.c       |   8 +-
>  drivers/char/ipmi/ipmi_si_intf.c          |   8 +-
>  drivers/crypto/hifn_795x.c                |   4 +-
>  drivers/edac/edac_device.c                |   4 +-
>  drivers/edac/edac_pci.c                   |   4 +-
>  drivers/edac/edac_pci_sysfs.c             |  20 ++--
>  drivers/firewire/core-card.c              |   4 +-
>  drivers/firmware/efi/cper.c               |   8 +-
>  drivers/gpio/gpio-vr41xx.c                |   2 +-
>  drivers/gpu/drm/i810/i810_drv.h           |   4 +-
>  drivers/gpu/drm/mga/mga_drv.h             |   4 +-
>  drivers/gpu/drm/mga/mga_irq.c             |   9 +-
>  drivers/gpu/drm/qxl/qxl_cmd.c             |  12 +--
>  drivers/gpu/drm/qxl/qxl_debugfs.c         |   8 +-
>  drivers/gpu/drm/qxl/qxl_drv.h             |   8 +-
>  drivers/gpu/drm/qxl/qxl_irq.c             |  16 +--
>  drivers/gpu/drm/r128/r128_cce.c           |   2 +-
>  drivers/gpu/drm/r128/r128_drv.h           |   4 +-
>  drivers/gpu/drm/r128/r128_irq.c           |   4 +-
>  drivers/gpu/drm/r128/r128_state.c         |   4 +-
>  drivers/gpu/drm/via/via_drv.h             |   4 +-
>  drivers/gpu/drm/via/via_irq.c             |  18 ++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |   2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c      |   6 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_irq.c       |   4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_marker.c    |   2 +-
>  drivers/hid/hid-core.c                    |   4 +-
>  drivers/hv/channel.c                      |   4 +-
>  drivers/hv/hv_balloon.c                   |  19 ++--
>  drivers/hv/hyperv_vmbus.h                 |   2 +-
>  drivers/hwmon/sht15.c                     |  12 +--
>  drivers/infiniband/core/cm.c              |  52 +++++-----
>  drivers/infiniband/core/fmr_pool.c        |  23 +++--
>  drivers/infiniband/hw/cxgb4/mem.c         |   4 +-
>  drivers/infiniband/hw/mlx4/mad.c          |   2 +-
>  drivers/infiniband/hw/mlx4/mcg.c          |   2 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h      |   2 +-
>  drivers/infiniband/hw/nes/nes.c           |   4 +-
>  drivers/infiniband/hw/nes/nes.h           |  40 ++++----
>  drivers/infiniband/hw/nes/nes_cm.c        |  62 ++++++------
>  drivers/infiniband/hw/nes/nes_mgt.c       |   8 +-
>  drivers/infiniband/hw/nes/nes_nic.c       |  40 ++++----
>  drivers/infiniband/hw/nes/nes_verbs.c     |  10 +-
>  drivers/input/gameport/gameport.c         |   4 +-
>  drivers/input/input.c                     |   4 +-
>  drivers/input/misc/ims-pcu.c              |   4 +-
>  drivers/input/serio/serio.c               |   4 +-
>  drivers/input/serio/serio_raw.c           |   4 +-
>  drivers/isdn/capi/capi.c                  |  11 ++-
>  drivers/md/dm-core.h                      |   4 +-
>  drivers/md/dm-raid.c                      |   3 +-
>  drivers/md/dm-raid1.c                     |  18 ++--
>  drivers/md/dm-stripe.c                    |  11 ++-
>  drivers/md/dm.c                           |  12 +--
>  drivers/md/md.c                           |  32 +++---
>  drivers/md/md.h                           |  15 +--
>  drivers/md/raid1.c                        |   8 +-
>  drivers/md/raid10.c                       |  20 ++--
>  drivers/md/raid5.c                        |  17 ++--
>  drivers/media/pci/ivtv/ivtv-driver.c      |   2 +-
>  drivers/media/pci/solo6x10/solo6x10-p2m.c |   3 +-
>  drivers/media/pci/solo6x10/solo6x10.h     |   2 +-
>  drivers/media/pci/tw68/tw68-core.c        |   2 +-
>  drivers/media/radio/radio-maxiradio.c     |   2 +-
>  drivers/media/radio/radio-shark.c         |   2 +-
>  drivers/media/radio/radio-shark2.c        |   2 +-
>  drivers/media/radio/radio-si476x.c        |   2 +-
>  drivers/media/v4l2-core/v4l2-device.c     |   4 +-
>  drivers/misc/lis3lv02d/lis3lv02d.c        |   8 +-
>  drivers/misc/lis3lv02d/lis3lv02d.h        |   2 +-
>  drivers/misc/sgi-gru/gruhandles.c         |   4 +-
>  drivers/misc/sgi-gru/gruprocfs.c          |   8 +-
>  drivers/misc/sgi-gru/grutables.h          | 158 +++++++++++++++---------------
>  drivers/net/hyperv/hyperv_net.h           |   2 +-
>  drivers/net/hyperv/rndis_filter.c         |   4 +-
>  include/linux/genhd.h                     |   2 +-
>  include/media/v4l2-device.h               |   2 +-
>  88 files changed, 491 insertions(+), 459 deletions(-)

Seriously, how is anybody supposed to review this, let alone test it?
You assert that the worst that happens is a DoS if you get this wrong,
but I don't see why that's the case for driver code. Why can't it result in
panics and data loss?

How did you decide that all of these need to wrap? Code inspection?

Will
