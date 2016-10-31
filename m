Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon, 31 Oct 2016 13:43:32 +0200
Message-Id: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v3 PATCH 00/13] HARDENING_ATOMIC feature
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Changes since RFC v2:

 - function coverage added for atomic64 and local
 - lkdtm tests are now fully under macros
 - lkdtm tests are now covering also atomic64 and local
 - local_wrap_t and corresponding functions are now
   defined properly to support all architectures
 - HARDENED_ATOMIC depends on !CONFIG_GENERIC_ATOMIC64
 - performance measuments were done and no visible
   implications
 - small fixes and corrections

Open items:

 - none identified

Compilation and testing results:

 - CONFIG_HARDENED_ATOMIC=y, arch=x86_64 or x86_32,
   full x86 coverage implementation: compiles, all lkdtm atomic tests PASS
 - CONFIG_HARDENED_ATOMIC=n, arch=x86_64 or x86_32, 
   full x86 coverage implementation: compiles, feature not enabled, so tests not run   
 - CONFIG_HARDENED_ATOMIC=n, arch=x86_64 or x86_32, with x86 hardening implementation removed
   (simulate not implemented for arch. case): compiles, feature not enabled, so tests not run 

This series brings the PaX/Grsecurity PAX_REFCOUNT
feature support to the upstream kernel. All credit for the
feature goes to the feature authors.

The name of the upstream feature is HARDENED_ATOMIC
and it is configured using CONFIG_HARDENED_ATOMIC and
HAVE_ARCH_HARDENED_ATOMIC.

This series only adds x86 support; other architectures are expected
to add similar support gradually.

More information about the feature can be found in the following
commit messages.

Special thank you goes to Kees Cook for pre-reviwing this feature
and all the valuable feedback he provided to us.

David Windsor (7):
  kernel: identify wrapping atomic usage
  mm: identify wrapping atomic usage
  fs: identify wrapping atomic usage
  net: identify wrapping atomic usage
  security: identify wrapping atomic usage
  drivers: identify wrapping atomic usage (part 1/2)
  drivers: identify wrapping atomic usage (part 2/2)

Elena Reshetova (3):
  Add architecture independent hardened atomic base
  x86: implementation for HARDENED_ATOMIC
  lkdtm: add tests for atomic over-/underflow

Hans Liljestrand (3):
  percpu-refcount: leave atomic counter unprotected
  net: atm: identify wrapping atomic usage
  x86: identify wrapping atomic usage

 Documentation/security/hardened-atomic.txt       | 146 ++++++++++
 arch/alpha/include/asm/local.h                   |   2 +
 arch/m32r/include/asm/local.h                    |   2 +
 arch/mips/include/asm/local.h                    |   2 +
 arch/powerpc/include/asm/local.h                 |   2 +
 arch/x86/Kconfig                                 |   1 +
 arch/x86/include/asm/atomic.h                    | 304 +++++++++++++++++++-
 arch/x86/include/asm/atomic64_32.h               | 180 +++++++++++-
 arch/x86/include/asm/atomic64_64.h               | 207 +++++++++++++-
 arch/x86/include/asm/bitops.h                    |   8 +-
 arch/x86/include/asm/cmpxchg.h                   |  39 +++
 arch/x86/include/asm/hw_irq.h                    |   4 +-
 arch/x86/include/asm/local.h                     | 149 +++++++++-
 arch/x86/include/asm/preempt.h                   |   2 +-
 arch/x86/include/asm/rmwcc.h                     |  82 +++++-
 arch/x86/include/asm/rwsem.h                     |  50 ++++
 arch/x86/kernel/apic/apic.c                      |   2 +-
 arch/x86/kernel/apic/io_apic.c                   |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c                 |  12 +-
 arch/x86/kernel/i8259.c                          |   2 +-
 arch/x86/kernel/irq.c                            |   8 +-
 arch/x86/kernel/kgdb.c                           |   6 +-
 arch/x86/kernel/pvclock.c                        |   8 +-
 arch/x86/kernel/tboot.c                          |   8 +-
 arch/x86/kernel/traps.c                          |   4 +
 arch/x86/lib/atomic64_386_32.S                   | 135 +++++++++
 arch/x86/lib/atomic64_cx8_32.S                   |  78 ++++-
 arch/x86/mm/mmio-mod.c                           |   4 +-
 drivers/acpi/apei/ghes.c                         |   4 +-
 drivers/ata/libata-core.c                        |   5 +-
 drivers/ata/libata-scsi.c                        |   2 +-
 drivers/ata/libata.h                             |   2 +-
 drivers/atm/adummy.c                             |   2 +-
 drivers/atm/ambassador.c                         |   8 +-
 drivers/atm/atmtcp.c                             |  14 +-
 drivers/atm/eni.c                                |  10 +-
 drivers/atm/firestream.c                         |   8 +-
 drivers/atm/fore200e.c                           |  14 +-
 drivers/atm/he.c                                 |  18 +-
 drivers/atm/horizon.c                            |   4 +-
 drivers/atm/idt77252.c                           |  36 +--
 drivers/atm/iphase.c                             |  34 +--
 drivers/atm/lanai.c                              |  12 +-
 drivers/atm/nicstar.c                            |  47 +--
 drivers/atm/solos-pci.c                          |   4 +-
 drivers/atm/suni.c                               |   5 +-
 drivers/atm/uPD98402.c                           |  16 +-
 drivers/atm/zatm.c                               |   7 +-
 drivers/base/power/wakeup.c                      |   8 +-
 drivers/block/drbd/drbd_bitmap.c                 |   2 +-
 drivers/block/drbd/drbd_int.h                    |   9 +-
 drivers/block/drbd/drbd_main.c                   |  15 +-
 drivers/block/drbd/drbd_nl.c                     |  16 +-
 drivers/block/drbd/drbd_receiver.c               |  34 +--
 drivers/block/drbd/drbd_worker.c                 |   8 +-
 drivers/char/ipmi/ipmi_msghandler.c              |   8 +-
 drivers/char/ipmi/ipmi_si_intf.c                 |   8 +-
 drivers/crypto/hifn_795x.c                       |   4 +-
 drivers/edac/edac_device.c                       |   4 +-
 drivers/edac/edac_pci.c                          |   4 +-
 drivers/edac/edac_pci_sysfs.c                    |  20 +-
 drivers/firewire/core-card.c                     |   4 +-
 drivers/firmware/efi/cper.c                      |   8 +-
 drivers/gpio/gpio-vr41xx.c                       |   2 +-
 drivers/gpu/drm/i810/i810_drv.h                  |   4 +-
 drivers/gpu/drm/mga/mga_drv.h                    |   4 +-
 drivers/gpu/drm/mga/mga_irq.c                    |   9 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                    |  12 +-
 drivers/gpu/drm/qxl/qxl_debugfs.c                |   8 +-
 drivers/gpu/drm/qxl/qxl_drv.h                    |   8 +-
 drivers/gpu/drm/qxl/qxl_irq.c                    |  16 +-
 drivers/gpu/drm/r128/r128_cce.c                  |   2 +-
 drivers/gpu/drm/r128/r128_drv.h                  |   4 +-
 drivers/gpu/drm/r128/r128_irq.c                  |   4 +-
 drivers/gpu/drm/r128/r128_state.c                |   4 +-
 drivers/gpu/drm/via/via_drv.h                    |   4 +-
 drivers/gpu/drm/via/via_irq.c                    |  18 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h              |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c             |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c              |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c           |   2 +-
 drivers/hid/hid-core.c                           |   4 +-
 drivers/hv/channel.c                             |   4 +-
 drivers/hv/hv_balloon.c                          |  19 +-
 drivers/hv/hyperv_vmbus.h                        |   2 +-
 drivers/hwmon/sht15.c                            |  12 +-
 drivers/infiniband/core/cm.c                     |  52 ++--
 drivers/infiniband/core/fmr_pool.c               |  23 +-
 drivers/infiniband/hw/cxgb4/mem.c                |   4 +-
 drivers/infiniband/hw/mlx4/mad.c                 |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c                 |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h             |   2 +-
 drivers/infiniband/hw/nes/nes.c                  |   4 +-
 drivers/infiniband/hw/nes/nes.h                  |  40 +--
 drivers/infiniband/hw/nes/nes_cm.c               |  62 ++--
 drivers/infiniband/hw/nes/nes_mgt.c              |   8 +-
 drivers/infiniband/hw/nes/nes_nic.c              |  40 +--
 drivers/infiniband/hw/nes/nes_verbs.c            |  10 +-
 drivers/input/gameport/gameport.c                |   4 +-
 drivers/input/input.c                            |   4 +-
 drivers/input/misc/ims-pcu.c                     |   4 +-
 drivers/input/serio/serio.c                      |   4 +-
 drivers/input/serio/serio_raw.c                  |   4 +-
 drivers/isdn/capi/capi.c                         |  11 +-
 drivers/md/dm-core.h                             |   4 +-
 drivers/md/dm-raid.c                             |   3 +-
 drivers/md/dm-raid1.c                            |  18 +-
 drivers/md/dm-stripe.c                           |  11 +-
 drivers/md/dm.c                                  |  12 +-
 drivers/md/md.c                                  |  32 ++-
 drivers/md/md.h                                  |  15 +-
 drivers/md/raid1.c                               |   8 +-
 drivers/md/raid10.c                              |  20 +-
 drivers/md/raid5.c                               |  17 +-
 drivers/media/pci/ivtv/ivtv-driver.c             |   2 +-
 drivers/media/pci/solo6x10/solo6x10-p2m.c        |   3 +-
 drivers/media/pci/solo6x10/solo6x10.h            |   2 +-
 drivers/media/pci/tw68/tw68-core.c               |   2 +-
 drivers/media/radio/radio-maxiradio.c            |   2 +-
 drivers/media/radio/radio-shark.c                |   2 +-
 drivers/media/radio/radio-shark2.c               |   2 +-
 drivers/media/radio/radio-si476x.c               |   2 +-
 drivers/media/v4l2-core/v4l2-device.c            |   4 +-
 drivers/misc/lis3lv02d/lis3lv02d.c               |   8 +-
 drivers/misc/lis3lv02d/lis3lv02d.h               |   2 +-
 drivers/misc/lkdtm.h                             |  46 ++-
 drivers/misc/lkdtm_bugs.c                        | 127 +++++++--
 drivers/misc/lkdtm_core.c                        |  20 +-
 drivers/misc/sgi-gru/gruhandles.c                |   4 +-
 drivers/misc/sgi-gru/gruprocfs.c                 |   8 +-
 drivers/misc/sgi-gru/grutables.h                 | 158 +++++-----
 drivers/net/hyperv/hyperv_net.h                  |   2 +-
 drivers/net/hyperv/rndis_filter.c                |   4 +-
 drivers/net/ipvlan/ipvlan_core.c                 |   2 +-
 drivers/net/macvlan.c                            |   2 +-
 drivers/net/usb/sierra_net.c                     |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   4 +-
 drivers/oprofile/buffer_sync.c                   |   8 +-
 drivers/oprofile/event_buffer.c                  |   2 +-
 drivers/oprofile/oprof.c                         |   2 +-
 drivers/oprofile/oprofile_stats.c                |  10 +-
 drivers/oprofile/oprofile_stats.h                |  10 +-
 drivers/oprofile/oprofilefs.c                    |   8 +-
 drivers/regulator/core.c                         |   4 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                   |  12 +-
 drivers/scsi/libfc/fc_exch.c                     |  54 ++--
 drivers/scsi/lpfc/lpfc.h                         |   8 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                 |  18 +-
 drivers/scsi/lpfc/lpfc_scsi.c                    |  10 +-
 drivers/scsi/pmcraid.c                           |  24 +-
 drivers/scsi/pmcraid.h                           |   8 +-
 drivers/scsi/qla4xxx/ql4_def.h                   |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c                    |   7 +-
 drivers/scsi/scsi_lib.c                          |   8 +-
 drivers/scsi/scsi_sysfs.c                        |   2 +-
 drivers/scsi/scsi_transport_fc.c                 |   6 +-
 drivers/scsi/scsi_transport_iscsi.c              |   7 +-
 drivers/scsi/scsi_transport_srp.c                |   6 +-
 drivers/scsi/sd.c                                |   2 +-
 drivers/target/sbp/sbp_target.c                  |   4 +-
 drivers/tty/hvc/hvsi.c                           |  12 +-
 drivers/tty/hvc/hvsi_lib.c                       |   4 +-
 drivers/tty/serial/ioc4_serial.c                 |   6 +-
 drivers/tty/serial/msm_serial.c                  |   4 +-
 drivers/uio/uio.c                                |  13 +-
 drivers/usb/atm/usbatm.c                         |  24 +-
 drivers/usb/core/devices.c                       |   6 +-
 drivers/usb/core/hcd.c                           |   4 +-
 drivers/usb/core/sysfs.c                         |   2 +-
 drivers/usb/core/usb.c                           |   2 +-
 drivers/usb/host/ehci-hub.c                      |   4 +-
 drivers/usb/misc/appledisplay.c                  |   4 +-
 drivers/usb/usbip/vhci.h                         |   2 +-
 drivers/usb/usbip/vhci_hcd.c                     |   6 +-
 drivers/usb/usbip/vhci_rx.c                      |   2 +-
 drivers/usb/wusbcore/wa-hc.h                     |   4 +-
 drivers/usb/wusbcore/wa-xfer.c                   |   2 +-
 drivers/video/fbdev/hyperv_fb.c                  |   4 +-
 drivers/video/fbdev/udlfb.c                      |  32 +--
 fs/afs/inode.c                                   |   4 +-
 fs/btrfs/delayed-inode.c                         |   6 +-
 fs/btrfs/delayed-inode.h                         |   4 +-
 fs/cachefiles/daemon.c                           |   4 +-
 fs/cachefiles/internal.h                         |  16 +-
 fs/cachefiles/namei.c                            |   6 +-
 fs/cachefiles/proc.c                             |  12 +-
 fs/ceph/super.c                                  |   4 +-
 fs/cifs/cifs_debug.c                             |  14 +-
 fs/cifs/cifsfs.c                                 |   4 +-
 fs/cifs/cifsglob.h                               |  55 ++--
 fs/cifs/misc.c                                   |   4 +-
 fs/cifs/smb1ops.c                                |  80 +++---
 fs/cifs/smb2ops.c                                |  84 +++---
 fs/coda/cache.c                                  |  10 +-
 fs/coredump.c                                    |   6 +-
 fs/ext4/ext4.h                                   |  20 +-
 fs/ext4/mballoc.c                                |  44 +--
 fs/fscache/cookie.c                              |  40 +--
 fs/fscache/internal.h                            | 202 ++++++-------
 fs/fscache/object.c                              |  26 +-
 fs/fscache/operation.c                           |  38 +--
 fs/fscache/page.c                                | 110 +++----
 fs/fscache/stats.c                               | 348 +++++++++++------------
 fs/inode.c                                       |   5 +-
 fs/kernfs/file.c                                 |  12 +-
 fs/lockd/clntproc.c                              |   4 +-
 fs/namespace.c                                   |   4 +-
 fs/nfs/inode.c                                   |   6 +-
 fs/notify/notification.c                         |   4 +-
 fs/ocfs2/localalloc.c                            |   2 +-
 fs/ocfs2/ocfs2.h                                 |  10 +-
 fs/ocfs2/suballoc.c                              |  12 +-
 fs/ocfs2/super.c                                 |  20 +-
 fs/proc/meminfo.c                                |   2 +-
 fs/quota/netlink.c                               |   4 +-
 fs/reiserfs/do_balan.c                           |   2 +-
 fs/reiserfs/procfs.c                             |   2 +-
 fs/reiserfs/reiserfs.h                           |   4 +-
 include/asm-generic/atomic-long.h                | 260 ++++++++++++++---
 include/asm-generic/atomic.h                     |  67 +++++
 include/asm-generic/atomic64.h                   |  16 ++
 include/asm-generic/bug.h                        |   7 +
 include/asm-generic/local.h                      |  20 ++
 include/asm-generic/local_wrap.h                 |  89 ++++++
 include/linux/atmdev.h                           |   2 +-
 include/linux/atomic.h                           | 133 +++++++++
 include/linux/blktrace_api.h                     |   2 +-
 include/linux/fscache-cache.h                    |   2 +-
 include/linux/genhd.h                            |   2 +-
 include/linux/irqdesc.h                          |   2 +-
 include/linux/kgdb.h                             |   2 +-
 include/linux/mm.h                               |   2 +-
 include/linux/mmzone.h                           |   4 +-
 include/linux/netdevice.h                        |   8 +-
 include/linux/oprofile.h                         |   2 +-
 include/linux/padata.h                           |   2 +-
 include/linux/percpu-refcount.h                  |  18 +-
 include/linux/perf_event.h                       |  10 +-
 include/linux/sched.h                            |   2 +-
 include/linux/slab_def.h                         |   8 +-
 include/linux/sonet.h                            |   2 +-
 include/linux/sunrpc/svc_rdma.h                  |  18 +-
 include/linux/swapops.h                          |  10 +-
 include/linux/types.h                            |  17 ++
 include/linux/uio_driver.h                       |   2 +-
 include/linux/usb.h                              |   2 +-
 include/linux/vmstat.h                           |  38 +--
 include/media/v4l2-device.h                      |   2 +-
 include/net/bonding.h                            |   2 +-
 include/net/caif/cfctrl.h                        |   4 +-
 include/net/flow.h                               |   2 +-
 include/net/gro_cells.h                          |   2 +-
 include/net/inetpeer.h                           |   3 +-
 include/net/ip_fib.h                             |   2 +-
 include/net/ip_vs.h                              |   4 +-
 include/net/iucv/af_iucv.h                       |   2 +-
 include/net/net_namespace.h                      |  12 +-
 include/net/netns/ipv4.h                         |   4 +-
 include/net/netns/ipv6.h                         |   4 +-
 include/net/netns/xfrm.h                         |   2 +-
 include/net/sock.h                               |   8 +-
 include/net/tcp.h                                |   2 +-
 include/net/xfrm.h                               |   2 +-
 include/scsi/scsi_device.h                       |   6 +-
 include/video/udlfb.h                            |  12 +-
 kernel/audit.c                                   |   8 +-
 kernel/auditsc.c                                 |   4 +-
 kernel/debug/debug_core.c                        |  16 +-
 kernel/events/core.c                             |  27 +-
 kernel/irq/manage.c                              |   2 +-
 kernel/irq/spurious.c                            |   2 +-
 kernel/locking/lockdep.c                         |   2 +-
 kernel/padata.c                                  |   4 +-
 kernel/panic.c                                   |  11 +
 kernel/profile.c                                 |  14 +-
 kernel/rcu/rcutorture.c                          |  61 ++--
 kernel/rcu/tree.c                                |  36 +--
 kernel/rcu/tree.h                                |  18 +-
 kernel/rcu/tree_exp.h                            |   6 +-
 kernel/rcu/tree_plugin.h                         |  12 +-
 kernel/rcu/tree_trace.c                          |  14 +-
 kernel/sched/auto_group.c                        |   4 +-
 kernel/time/timer_stats.c                        |  11 +-
 kernel/trace/blktrace.c                          |   6 +-
 kernel/trace/ftrace.c                            |   4 +-
 kernel/trace/ring_buffer.c                       |  99 +++----
 kernel/trace/trace_clock.c                       |   4 +-
 kernel/trace/trace_functions_graph.c             |   4 +-
 kernel/trace/trace_mmiotrace.c                   |   8 +-
 lib/percpu-refcount.c                            |  12 +-
 lib/show_mem.c                                   |   3 +-
 mm/backing-dev.c                                 |   4 +-
 mm/memory-failure.c                              |   2 +-
 mm/slab.c                                        |  16 +-
 mm/sparse.c                                      |   2 +-
 mm/swapfile.c                                    |  12 +-
 mm/vmstat.c                                      |  26 +-
 net/atm/atm_misc.c                               |   8 +-
 net/atm/proc.c                                   |   8 +-
 net/atm/resources.c                              |   4 +-
 net/batman-adv/bat_iv_ogm.c                      |   8 +-
 net/batman-adv/fragmentation.c                   |   3 +-
 net/batman-adv/soft-interface.c                  |   6 +-
 net/batman-adv/types.h                           |   6 +-
 net/caif/cfctrl.c                                |  11 +-
 net/ceph/messenger.c                             |   4 +-
 net/core/datagram.c                              |   2 +-
 net/core/dev.c                                   |  18 +-
 net/core/flow.c                                  |   9 +-
 net/core/net-sysfs.c                             |   2 +-
 net/core/netpoll.c                               |   4 +-
 net/core/rtnetlink.c                             |   2 +-
 net/core/sock.c                                  |  14 +-
 net/core/sock_diag.c                             |   8 +-
 net/ipv4/devinet.c                               |   4 +-
 net/ipv4/fib_frontend.c                          |   6 +-
 net/ipv4/fib_semantics.c                         |   2 +-
 net/ipv4/inet_connection_sock.c                  |   4 +-
 net/ipv4/inet_timewait_sock.c                    |   3 +-
 net/ipv4/inetpeer.c                              |   2 +-
 net/ipv4/ip_fragment.c                           |   2 +-
 net/ipv4/ping.c                                  |   2 +-
 net/ipv4/raw.c                                   |   5 +-
 net/ipv4/route.c                                 |  12 +-
 net/ipv4/tcp_input.c                             |   2 +-
 net/ipv4/udp.c                                   |  10 +-
 net/ipv6/addrconf.c                              |   7 +-
 net/ipv6/af_inet6.c                              |   2 +-
 net/ipv6/datagram.c                              |   2 +-
 net/ipv6/ip6_fib.c                               |   4 +-
 net/ipv6/raw.c                                   |   6 +-
 net/ipv6/udp.c                                   |   6 +-
 net/iucv/af_iucv.c                               |   5 +-
 net/key/af_key.c                                 |   4 +-
 net/l2tp/l2tp_eth.c                              |  38 +--
 net/netfilter/ipvs/ip_vs_conn.c                  |   6 +-
 net/netfilter/ipvs/ip_vs_core.c                  |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                   |  12 +-
 net/netfilter/ipvs/ip_vs_sync.c                  |   6 +-
 net/netfilter/ipvs/ip_vs_xmit.c                  |   4 +-
 net/netfilter/nfnetlink_log.c                    |   4 +-
 net/netfilter/xt_statistic.c                     |   9 +-
 net/netlink/af_netlink.c                         |   4 +-
 net/packet/af_packet.c                           |   4 +-
 net/phonet/pep.c                                 |   6 +-
 net/phonet/socket.c                              |   2 +-
 net/rds/cong.c                                   |   6 +-
 net/rds/ib.h                                     |   2 +-
 net/rds/ib_cm.c                                  |   2 +-
 net/rds/ib_recv.c                                |   4 +-
 net/rxrpc/af_rxrpc.c                             |   2 +-
 net/rxrpc/ar-internal.h                          |   4 +-
 net/rxrpc/call_object.c                          |   2 +-
 net/rxrpc/conn_event.c                           |   4 +-
 net/rxrpc/conn_object.c                          |   2 +-
 net/rxrpc/local_object.c                         |   2 +-
 net/rxrpc/output.c                               |   6 +-
 net/rxrpc/peer_object.c                          |   2 +-
 net/rxrpc/proc.c                                 |   2 +-
 net/rxrpc/rxkad.c                                |   4 +-
 net/sched/sch_generic.c                          |   4 +-
 net/sctp/sctp_diag.c                             |   2 +-
 net/sunrpc/auth_gss/svcauth_gss.c                |   4 +-
 net/sunrpc/sched.c                               |   4 +-
 net/sunrpc/xprtrdma/svc_rdma.c                   |  36 +--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c          |   8 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c            |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c         |   2 +-
 net/xfrm/xfrm_policy.c                           |  11 +-
 net/xfrm/xfrm_state.c                            |   4 +-
 security/Kconfig                                 |  20 ++
 security/integrity/ima/ima.h                     |   4 +-
 security/integrity/ima/ima_api.c                 |   2 +-
 security/integrity/ima/ima_fs.c                  |   4 +-
 security/integrity/ima/ima_queue.c               |   2 +-
 security/selinux/avc.c                           |   7 +-
 security/selinux/include/xfrm.h                  |   2 +-
 378 files changed, 4120 insertions(+), 2067 deletions(-)
 create mode 100644 Documentation/security/hardened-atomic.txt
 create mode 100644 include/asm-generic/local_wrap.h

-- 
2.7.4
