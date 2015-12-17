Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 00:56:31 -0500
Message-Id: <1450331796-10329-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH 0/5] Add PAX_REFCOUNT overflow protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

These patches are in support of the kernel self-protection effort recently
proposed on kernel-hardening.

The Linux kernel can be better protected against use-after-free exploits.
This patch adds functionality originally found in the PaX project [1] to
protect the kernel against integer overflows affecting kernel reference
counters, a class of bugs that can lead to use-after-free exploits.

Problems arise when reference counters get overflowed.  The existence of a
kernel path in which a reference counter is incremented more than it is
decremented leads to an overflow bug.  This buggy path can be executed until
INT_MAX is reached, at which point further increments will cause the reference
counter to wrap around to 0.  At this point, the kernel will free the counted
object while it still has legitimate users, creating conditions for a
use-after-free exploit to occur.


Patch Details
----------------

These patches were taken from the PaX project's PAX_REFCOUNT feature.  It
applies cleanly to linux-stable/v4.2.6 [2].  I am in the process of rebasing
these patches to linux-next, but wanted to submit them now for general
comments, bikeshedding, etc.

Most of the changes involve users of atomic_t opting out of overflow protection:
many atomic_t users use the type not as a reference counter, but as some type
of statistical counter (packet counters, etc.).


Issues
---------

* The patch is currently based on linux-stable/v4.2.6.  I am in the process of
rebasing it to linux-next and will submit a follow-up patchset soon.

* PAX_REFCOUNT naming: I picked this naming scheme by default.  It will likely
need to change before going upstream.

* When an overflow is detected, SIGKILL is sent to the offending process.
This may be too drastic for an initial upstream submission.  WARN_ON may be
more appropriate until distros have some time to absorb it and report any
unaddressed overflows.

* 0003-pax-opt-out-of-PAX_REFCOUNT-protection.patch is very large.  I
have another patchset in which these patches are split more or less according
to maintainer (except for drivers/) [3].

[1] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
[2] git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
[3] https://github.com/dwindsor/linux-stable/tree/dwindsor-pax-refcount-split


David Windsor (5):
  x86: add PAX_REFCOUNT support
  percpu_ref: decrease per-CPU refcount bias
  pax: opt out of PAX_REFCOUNT protection
  security: add Kconfig options for PAX_REFCOUNT
  lkdtm: add test for atomic_t underflow/overflow

 arch/x86/include/asm/atomic.h             | 263 ++++++++++++++++++++--
 arch/x86/include/asm/atomic64_32.h        | 100 +++++++++
 arch/x86/include/asm/atomic64_64.h        | 164 +++++++++++++-
 arch/x86/include/asm/bitops.h             |   6 +-
 arch/x86/include/asm/cmpxchg.h            |  39 ++++
 arch/x86/include/asm/hw_irq.h             |   4 +-
 arch/x86/include/asm/local.h              | 106 ++++++++-
 arch/x86/include/asm/preempt.h            |   2 +-
 arch/x86/include/asm/rmwcc.h              |  84 +++++++-
 arch/x86/include/asm/rwsem.h              |  60 +++++-
 arch/x86/kernel/apic/apic.c               |   2 +-
 arch/x86/kernel/apic/io_apic.c            |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |  12 +-
 arch/x86/kernel/i8259.c                   |   2 +-
 arch/x86/kernel/irq.c                     |   8 +-
 arch/x86/kernel/kgdb.c                    |   6 +-
 arch/x86/kernel/pvclock.c                 |   8 +-
 arch/x86/kernel/tboot.c                   |   8 +-
 arch/x86/kernel/traps.c                   |   6 +
 arch/x86/lib/atomic64_386_32.S            | 164 ++++++++++++++
 arch/x86/lib/atomic64_cx8_32.S            |  94 +++++++-
 arch/x86/mm/mmio-mod.c                    |   4 +-
 drivers/acpi/apei/ghes.c                  |   4 +-
 drivers/ata/libata-core.c                 |   4 +-
 drivers/ata/libata-scsi.c                 |   2 +-
 drivers/ata/libata.h                      |   2 +-
 drivers/atm/adummy.c                      |   2 +-
 drivers/atm/ambassador.c                  |   8 +-
 drivers/atm/atmtcp.c                      |  14 +-
 drivers/atm/eni.c                         |  10 +-
 drivers/atm/firestream.c                  |   8 +-
 drivers/atm/fore200e.c                    |  14 +-
 drivers/atm/he.c                          |  18 +-
 drivers/atm/horizon.c                     |   4 +-
 drivers/atm/idt77252.c                    |  36 ++--
 drivers/atm/iphase.c                      |  34 +--
 drivers/atm/lanai.c                       |  12 +-
 drivers/atm/nicstar.c                     |  46 ++--
 drivers/atm/solos-pci.c                   |   4 +-
 drivers/atm/suni.c                        |   4 +-
 drivers/atm/uPD98402.c                    |  16 +-
 drivers/atm/zatm.c                        |   6 +-
 drivers/base/power/wakeup.c               |   8 +-
 drivers/block/drbd/drbd_bitmap.c          |   2 +-
 drivers/block/drbd/drbd_int.h             |   8 +-
 drivers/block/drbd/drbd_main.c            |  12 +-
 drivers/block/drbd/drbd_nl.c              |   4 +-
 drivers/block/drbd/drbd_receiver.c        |  30 +--
 drivers/block/drbd/drbd_worker.c          |   8 +-
 drivers/char/ipmi/ipmi_msghandler.c       |   8 +-
 drivers/char/ipmi/ipmi_si_intf.c          |   8 +-
 drivers/crypto/hifn_795x.c                |   4 +-
 drivers/edac/edac_device.c                |   4 +-
 drivers/edac/edac_pci.c                   |   4 +-
 drivers/edac/edac_pci_sysfs.c             |  20 +-
 drivers/firewire/core-card.c              |   4 +-
 drivers/firmware/efi/cper.c               |   8 +-
 drivers/gpio/gpio-vr41xx.c                |   2 +-
 drivers/gpu/drm/i810/i810_drv.h           |   4 +-
 drivers/gpu/drm/mga/mga_drv.h             |   4 +-
 drivers/gpu/drm/mga/mga_irq.c             |   8 +-
 drivers/gpu/drm/qxl/qxl_cmd.c             |  12 +-
 drivers/gpu/drm/qxl/qxl_debugfs.c         |   8 +-
 drivers/gpu/drm/qxl/qxl_drv.h             |   8 +-
 drivers/gpu/drm/qxl/qxl_irq.c             |  16 +-
 drivers/gpu/drm/r128/r128_cce.c           |   2 +-
 drivers/gpu/drm/r128/r128_drv.h           |   4 +-
 drivers/gpu/drm/r128/r128_irq.c           |   4 +-
 drivers/gpu/drm/r128/r128_state.c         |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.h       |   2 +-
 drivers/gpu/drm/radeon/radeon_irq.c       |   6 +-
 drivers/gpu/drm/via/via_drv.h             |   4 +-
 drivers/gpu/drm/via/via_irq.c             |  18 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c      |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c       |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c    |   2 +-
 drivers/hid/hid-core.c                    |   4 +-
 drivers/hv/channel.c                      |   2 +-
 drivers/hv/hv_balloon.c                   |  18 +-
 drivers/hv/hyperv_vmbus.h                 |   2 +-
 drivers/hwmon/sht15.c                     |  12 +-
 drivers/infiniband/core/cm.c              |  32 +--
 drivers/infiniband/core/fmr_pool.c        |  20 +-
 drivers/infiniband/hw/cxgb4/mem.c         |   4 +-
 drivers/infiniband/hw/ipath/ipath_rc.c    |   6 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c   |   6 +-
 drivers/infiniband/hw/mlx4/mad.c          |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c          |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   2 +-
 drivers/infiniband/hw/nes/nes.c           |   4 +-
 drivers/infiniband/hw/nes/nes.h           |  40 ++--
 drivers/infiniband/hw/nes/nes_cm.c        |  62 +++---
 drivers/infiniband/hw/nes/nes_mgt.c       |   8 +-
 drivers/infiniband/hw/nes/nes_nic.c       |  40 ++--
 drivers/infiniband/hw/nes/nes_verbs.c     |  10 +-
 drivers/input/gameport/gameport.c         |   4 +-
 drivers/input/input.c                     |   4 +-
 drivers/input/joystick/xpad.c             |   4 +-
 drivers/input/misc/ims-pcu.c              |   4 +-
 drivers/input/serio/serio.c               |   4 +-
 drivers/input/serio/serio_raw.c           |   4 +-
 drivers/isdn/capi/capi.c                  |  10 +-
 drivers/md/dm-raid1.c                     |  18 +-
 drivers/md/dm-stripe.c                    |  10 +-
 drivers/md/dm.c                           |  16 +-
 drivers/md/md.c                           |  26 +--
 drivers/md/md.h                           |   6 +-
 drivers/md/raid1.c                        |   4 +-
 drivers/md/raid10.c                       |  16 +-
 drivers/md/raid5.c                        |  10 +-
 drivers/media/pci/ivtv/ivtv-driver.c      |   2 +-
 drivers/media/pci/solo6x10/solo6x10-p2m.c |   2 +-
 drivers/media/pci/solo6x10/solo6x10.h     |   2 +-
 drivers/media/pci/tw68/tw68-core.c        |   2 +-
 drivers/media/radio/radio-maxiradio.c     |   2 +-
 drivers/media/radio/radio-shark.c         |   2 +-
 drivers/media/radio/radio-shark2.c        |   2 +-
 drivers/media/radio/radio-si476x.c        |   2 +-
 drivers/media/v4l2-core/v4l2-device.c     |   4 +-
 drivers/misc/lis3lv02d/lis3lv02d.c        |   8 +-
 drivers/misc/lis3lv02d/lis3lv02d.h        |   2 +-
 drivers/misc/lkdtm.c                      |  13 ++
 drivers/misc/sgi-gru/gruhandles.c         |   4 +-
 drivers/misc/sgi-gru/gruprocfs.c          |   8 +-
 drivers/misc/sgi-gru/grutables.h          | 158 +++++++-------
 drivers/net/hyperv/hyperv_net.h           |   2 +-
 drivers/net/hyperv/rndis_filter.c         |   4 +-
 drivers/net/ipvlan/ipvlan_core.c          |   2 +-
 drivers/net/macvlan.c                     |   2 +-
 drivers/net/usb/sierra_net.c              |   4 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   4 +-
 drivers/oprofile/buffer_sync.c            |   8 +-
 drivers/oprofile/event_buffer.c           |   2 +-
 drivers/oprofile/oprof.c                  |   2 +-
 drivers/oprofile/oprofile_stats.c         |  10 +-
 drivers/oprofile/oprofile_stats.h         |  10 +-
 drivers/oprofile/oprofilefs.c             |   6 +-
 drivers/regulator/core.c                  |   4 +-
 drivers/scsi/fcoe/fcoe_sysfs.c            |  12 +-
 drivers/scsi/hosts.c                      |   4 +-
 drivers/scsi/libfc/fc_exch.c              |  50 ++---
 drivers/scsi/lpfc/lpfc.h                  |   8 +-
 drivers/scsi/lpfc/lpfc_debugfs.c          |  18 +-
 drivers/scsi/lpfc/lpfc_scsi.c             |  10 +-
 drivers/scsi/pmcraid.c                    |  20 +-
 drivers/scsi/pmcraid.h                    |   8 +-
 drivers/scsi/qla4xxx/ql4_def.h            |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |   6 +-
 drivers/scsi/scsi_lib.c                   |   8 +-
 drivers/scsi/scsi_sysfs.c                 |   2 +-
 drivers/scsi/scsi_transport_fc.c          |   6 +-
 drivers/scsi/scsi_transport_iscsi.c       |   6 +-
 drivers/scsi/scsi_transport_srp.c         |   6 +-
 drivers/scsi/sd.c                         |   2 +-
 drivers/staging/android/timed_output.c    |   6 +-
 drivers/staging/octeon/ethernet-rx.c      |  12 +-
 drivers/staging/octeon/ethernet.c         |   8 +-
 drivers/target/sbp/sbp_target.c           |   4 +-
 drivers/target/target_core_device.c       |   2 +-
 drivers/target/target_core_transport.c    |   2 +-
 drivers/tty/hvc/hvsi.c                    |  12 +-
 drivers/tty/hvc/hvsi_lib.c                |   4 +-
 drivers/tty/serial/ioc4_serial.c          |   6 +-
 drivers/tty/serial/msm_serial.c           |   4 +-
 drivers/uio/uio.c                         |  12 +-
 drivers/usb/atm/usbatm.c                  |  24 +--
 drivers/usb/core/devices.c                |   6 +-
 drivers/usb/core/hcd.c                    |   4 +-
 drivers/usb/core/sysfs.c                  |   2 +-
 drivers/usb/core/usb.c                    |   2 +-
 drivers/usb/host/ehci-hub.c               |   4 +-
 drivers/usb/misc/appledisplay.c           |   4 +-
 drivers/usb/usbip/vhci.h                  |   2 +-
 drivers/usb/usbip/vhci_hcd.c              |   6 +-
 drivers/usb/usbip/vhci_rx.c               |   2 +-
 drivers/usb/wusbcore/wa-hc.h              |   4 +-
 drivers/usb/wusbcore/wa-xfer.c            |   2 +-
 drivers/video/fbdev/hyperv_fb.c           |   4 +-
 drivers/video/fbdev/udlfb.c               |  32 +--
 fs/afs/inode.c                            |   4 +-
 fs/btrfs/delayed-inode.c                  |   6 +-
 fs/btrfs/delayed-inode.h                  |   4 +-
 fs/cachefiles/internal.h                  |  12 +-
 fs/cachefiles/namei.c                     |   2 +-
 fs/cachefiles/proc.c                      |  12 +-
 fs/ceph/super.c                           |   4 +-
 fs/cifs/cifs_debug.c                      |  12 +-
 fs/cifs/cifsfs.c                          |   4 +-
 fs/cifs/cifsglob.h                        |  54 ++---
 fs/cifs/misc.c                            |   4 +-
 fs/cifs/smb1ops.c                         |  80 +++----
 fs/cifs/smb2ops.c                         |  84 ++++----
 fs/coda/cache.c                           |  10 +-
 fs/coredump.c                             |   6 +-
 fs/exec.c                                 |  23 ++
 fs/ext4/ext4.h                            |  20 +-
 fs/ext4/mballoc.c                         |  44 ++--
 fs/fscache/cookie.c                       |  40 ++--
 fs/fscache/internal.h                     | 202 ++++++++---------
 fs/fscache/object.c                       |  26 +--
 fs/fscache/operation.c                    |  38 ++--
 fs/fscache/page.c                         | 110 +++++-----
 fs/fscache/stats.c                        | 348 +++++++++++++++---------------
 fs/inode.c                                |   4 +-
 fs/kernfs/file.c                          |  12 +-
 fs/lockd/clntproc.c                       |   4 +-
 fs/namespace.c                            |   4 +-
 fs/nfs/inode.c                            |   6 +-
 fs/notify/notification.c                  |   4 +-
 fs/ocfs2/localalloc.c                     |   2 +-
 fs/ocfs2/ocfs2.h                          |  10 +-
 fs/ocfs2/suballoc.c                       |  12 +-
 fs/ocfs2/super.c                          |  20 +-
 fs/proc/meminfo.c                         |   2 +-
 fs/quota/netlink.c                        |   4 +-
 fs/reiserfs/do_balan.c                    |   2 +-
 fs/reiserfs/procfs.c                      |   2 +-
 fs/reiserfs/reiserfs.h                    |   4 +-
 include/asm-generic/atomic-long.h         | 210 ++++++++++++++++++
 include/asm-generic/atomic64.h            |  12 ++
 include/asm-generic/local.h               |  13 ++
 include/linux/atmdev.h                    |   2 +-
 include/linux/blktrace_api.h              |   2 +-
 include/linux/fscache-cache.h             |   2 +-
 include/linux/genhd.h                     |   2 +-
 include/linux/irqdesc.h                   |   2 +-
 include/linux/kgdb.h                      |   2 +-
 include/linux/netdevice.h                 |   6 +-
 include/linux/oprofile.h                  |   4 +-
 include/linux/padata.h                    |   2 +-
 include/linux/perf_event.h                |   8 +-
 include/linux/sched.h                     |  15 +-
 include/linux/sonet.h                     |   2 +-
 include/linux/sunrpc/svc_rdma.h           |  18 +-
 include/linux/types.h                     |  16 ++
 include/linux/uio_driver.h                |   2 +-
 include/linux/usb.h                       |   2 +-
 include/media/v4l2-device.h               |   2 +-
 include/net/bonding.h                     |   2 +-
 include/net/caif/cfctrl.h                 |   4 +-
 include/net/flow.h                        |   2 +-
 include/net/gro_cells.h                   |   2 +-
 include/net/inetpeer.h                    |   2 +-
 include/net/ip_fib.h                      |   2 +-
 include/net/ip_vs.h                       |   4 +-
 include/net/iucv/af_iucv.h                |   2 +-
 include/net/net_namespace.h               |  12 +-
 include/net/netns/ipv4.h                  |   4 +-
 include/net/netns/ipv6.h                  |   4 +-
 include/net/netns/xfrm.h                  |   2 +-
 include/net/sock.h                        |   6 +-
 include/net/xfrm.h                        |   2 +-
 include/scsi/scsi_device.h                |   6 +-
 include/target/target_core_base.h         |   2 +-
 include/video/udlfb.h                     |   8 +-
 kernel/audit.c                            |   8 +-
 kernel/auditsc.c                          |   4 +-
 kernel/debug/debug_core.c                 |  16 +-
 kernel/events/core.c                      |  22 +-
 kernel/irq/manage.c                       |   2 +-
 kernel/irq/spurious.c                     |   2 +-
 kernel/locking/lockdep.c                  |   2 +-
 kernel/locking/rtmutex-tester.c           |  24 +--
 kernel/padata.c                           |   4 +-
 kernel/profile.c                          |  14 +-
 kernel/rcu/rcutorture.c                   |  60 +++---
 kernel/rcu/tree.c                         |  64 +++---
 kernel/rcu/tree.h                         |  26 +--
 kernel/rcu/tree_plugin.h                  |  12 +-
 kernel/rcu/tree_trace.c                   |  22 +-
 kernel/sched/auto_group.c                 |   4 +-
 kernel/time/timer_stats.c                 |  10 +-
 kernel/trace/blktrace.c                   |   6 +-
 kernel/trace/ftrace.c                     |   4 +-
 kernel/trace/ring_buffer.c                |  96 ++++-----
 kernel/trace/trace_clock.c                |   4 +-
 kernel/trace/trace_functions_graph.c      |   4 +-
 kernel/trace/trace_mmiotrace.c            |   8 +-
 lib/percpu-refcount.c                     |   2 +-
 lib/show_mem.c                            |   2 +-
 net/atm/atm_misc.c                        |   8 +-
 net/atm/proc.c                            |   6 +-
 net/atm/resources.c                       |   4 +-
 net/batman-adv/bat_iv_ogm.c               |   8 +-
 net/batman-adv/fragmentation.c            |   2 +-
 net/batman-adv/soft-interface.c           |   6 +-
 net/batman-adv/types.h                    |   6 +-
 net/caif/cfctrl.c                         |  10 +-
 net/ceph/messenger.c                      |   4 +-
 net/core/datagram.c                       |   2 +-
 net/core/dev.c                            |  12 +-
 net/core/flow.c                           |   6 +-
 net/core/net-sysfs.c                      |   2 +-
 net/core/netpoll.c                        |   4 +-
 net/core/rtnetlink.c                      |   2 +-
 net/core/sock.c                           |  12 +-
 net/core/sock_diag.c                      |   6 +-
 net/ipv4/devinet.c                        |   4 +-
 net/ipv4/fib_frontend.c                   |   6 +-
 net/ipv4/fib_semantics.c                  |   2 +-
 net/ipv4/inet_connection_sock.c           |   4 +-
 net/ipv4/inet_timewait_sock.c             |   2 +-
 net/ipv4/inetpeer.c                       |   2 +-
 net/ipv4/ip_fragment.c                    |   2 +-
 net/ipv4/ping.c                           |   2 +-
 net/ipv4/raw.c                            |   4 +-
 net/ipv4/route.c                          |  10 +-
 net/ipv4/tcp_input.c                      |   2 +-
 net/ipv4/udp.c                            |  10 +-
 net/ipv6/addrconf.c                       |   6 +-
 net/ipv6/af_inet6.c                       |   2 +-
 net/ipv6/datagram.c                       |   2 +-
 net/ipv6/ip6_fib.c                        |   4 +-
 net/ipv6/raw.c                            |   6 +-
 net/ipv6/udp.c                            |   6 +-
 net/iucv/af_iucv.c                        |   4 +-
 net/key/af_key.c                          |   4 +-
 net/l2tp/l2tp_eth.c                       |  38 ++--
 net/netfilter/ipvs/ip_vs_conn.c           |   6 +-
 net/netfilter/ipvs/ip_vs_core.c           |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c            |  10 +-
 net/netfilter/ipvs/ip_vs_sync.c           |   6 +-
 net/netfilter/ipvs/ip_vs_xmit.c           |   4 +-
 net/netfilter/nfnetlink_log.c             |   4 +-
 net/netfilter/xt_statistic.c              |   8 +-
 net/netlink/af_netlink.c                  |   4 +-
 net/openvswitch/vport.c                   |  16 +-
 net/openvswitch/vport.h                   |   8 +-
 net/packet/af_packet.c                    |   4 +-
 net/phonet/pep.c                          |   6 +-
 net/phonet/socket.c                       |   2 +-
 net/rds/cong.c                            |   6 +-
 net/rds/ib.h                              |   2 +-
 net/rds/ib_cm.c                           |   2 +-
 net/rds/ib_recv.c                         |   4 +-
 net/rds/iw.h                              |   2 +-
 net/rds/iw_cm.c                           |   2 +-
 net/rds/iw_recv.c                         |   4 +-
 net/rxrpc/af_rxrpc.c                      |   2 +-
 net/rxrpc/ar-ack.c                        |  14 +-
 net/rxrpc/ar-call.c                       |   2 +-
 net/rxrpc/ar-connection.c                 |   2 +-
 net/rxrpc/ar-connevent.c                  |   2 +-
 net/rxrpc/ar-input.c                      |   4 +-
 net/rxrpc/ar-internal.h                   |   8 +-
 net/rxrpc/ar-local.c                      |   2 +-
 net/rxrpc/ar-output.c                     |   4 +-
 net/rxrpc/ar-peer.c                       |   2 +-
 net/rxrpc/ar-proc.c                       |   4 +-
 net/rxrpc/ar-transport.c                  |   2 +-
 net/rxrpc/rxkad.c                         |   4 +-
 net/sched/sch_generic.c                   |   4 +-
 net/sunrpc/auth_gss/svcauth_gss.c         |   4 +-
 net/sunrpc/sched.c                        |   4 +-
 net/sunrpc/xprtrdma/svc_rdma.c            |  36 ++--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c   |   8 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c     |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c  |  10 +-
 net/xfrm/xfrm_policy.c                    |  10 +-
 net/xfrm/xfrm_state.c                     |   4 +-
 security/Kconfig                          |  72 +++++++
 security/integrity/ima/ima.h              |   4 +-
 security/integrity/ima/ima_api.c          |   2 +-
 security/integrity/ima/ima_fs.c           |   4 +-
 security/integrity/ima/ima_queue.c        |   2 +-
 security/selinux/avc.c                    |   6 +-
 security/selinux/include/xfrm.h           |   2 +-
 sound/pci/ymfpci/ymfpci.h                 |   2 +-
 sound/pci/ymfpci/ymfpci_main.c            |  12 +-
 virt/kvm/kvm_main.c                       |   8 +-
 372 files changed, 3325 insertions(+), 1977 deletions(-)

-- 
2.5.0
