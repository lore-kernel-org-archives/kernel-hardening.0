Reply-To: kernel-hardening@lists.openwall.com
From: Michael Leibowitz <michael.leibowitz@intel.com>
Date: Thu,  5 May 2016 10:21:09 -0700
Message-Id: <1462468869-6210-4-git-send-email-michael.leibowitz@intel.com>
In-Reply-To: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
References: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
Subject: [kernel-hardening] [RFC 3/3] Change initialization C99 style; tag no_ramdomize_layout structs
To: spender@grsecurity.net, kernel-hardening@lists.openwall.com, keescook@chromium.org, re.emese@gmail.com, pageexec@freemail.hu
Cc: michael.leibowitz@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Due to randomization of structs, the in order struct intialization
style is replaced with explicit field style.

struct foo_t my_foo = {
       one,
       two,
       three
};

becomes

struct foo_t my_foo = {
       .one = one,
       .two = two,
       .three = three
};

Additionally, tag paravirt related structures to explicitly not be
randomized, as the structure layout is important.

This feature is ported over from grsecurity.  This is largely
unchanged from the Original code written by the PaX Team and Spender.

Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>
---
 arch/x86/include/asm/floppy.h                   | 20 ++---
 arch/x86/include/asm/paravirt_types.h           | 18 +++--
 drivers/acpi/acpica/hwxfsleep.c                 | 11 +--
 drivers/block/cciss.h                           | 30 ++++----
 drivers/gpu/drm/nouveau/nouveau_ttm.c           | 28 +++----
 drivers/gpu/drm/ttm/ttm_bo_manager.c            | 10 +--
 drivers/gpu/drm/virtio/virtgpu_ttm.c            | 10 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c   | 10 +--
 drivers/infiniband/hw/nes/nes_cm.c              | 22 +++---
 drivers/isdn/gigaset/bas-gigaset.c              | 32 ++++----
 drivers/isdn/gigaset/ser-gigaset.c              | 32 ++++----
 drivers/isdn/gigaset/usb-gigaset.c              | 32 ++++----
 drivers/isdn/i4l/isdn_concap.c                  |  6 +-
 drivers/isdn/i4l/isdn_x25iface.c                | 16 ++--
 drivers/media/pci/solo6x10/solo6x10-g723.c      |  2 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c     |  8 +-
 drivers/net/wan/lmc/lmc_media.c                 | 97 +++++++++++++------------
 drivers/scsi/bfa/bfa_fcs.c                      | 19 ++++-
 drivers/scsi/bfa/bfa_fcs_lport.c                | 29 +++++---
 drivers/scsi/bfa/bfa_modules.h                  | 12 +--
 drivers/scsi/hpsa.h                             | 40 +++++-----
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |  2 +-
 drivers/staging/lustre/lustre/libcfs/module.c   | 10 +--
 drivers/video/fbdev/matrox/matroxfb_DAC1064.c   | 10 ++-
 drivers/video/fbdev/matrox/matroxfb_Ti3026.c    |  5 +-
 fs/reiserfs/item_ops.c                          | 24 +++---
 include/linux/rbtree_augmented.h                |  4 +-
 lib/rbtree.c                                    |  4 +-
 mm/page_alloc.c                                 |  2 +-
 net/atm/lec.c                                   |  6 +-
 net/atm/mpoa_caches.c                           | 41 +++++------
 net/vmw_vsock/vmci_transport_notify.c           | 30 ++++----
 net/vmw_vsock/vmci_transport_notify_qstate.c    | 30 ++++----
 sound/synth/emux/emux_seq.c                     | 14 ++--
 34 files changed, 352 insertions(+), 314 deletions(-)

diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index 1c7eefe..d0e4702 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -229,18 +229,18 @@ static struct fd_routine_l {
 	int (*_dma_setup)(char *addr, unsigned long size, int mode, int io);
 } fd_routine[] = {
 	{
-		request_dma,
-		free_dma,
-		get_dma_residue,
-		dma_mem_alloc,
-		hard_dma_setup
+		._request_dma = request_dma,
+		._free_dma = free_dma,
+		._get_dma_residue = get_dma_residue,
+		._dma_mem_alloc = dma_mem_alloc,
+		._dma_setup = hard_dma_setup
 	},
 	{
-		vdma_request_dma,
-		vdma_nop,
-		vdma_get_dma_residue,
-		vdma_mem_alloc,
-		vdma_dma_setup
+		._request_dma = vdma_request_dma,
+		._free_dma = vdma_nop,
+		._get_dma_residue = vdma_get_dma_residue,
+		._dma_mem_alloc = vdma_mem_alloc,
+		._dma_setup = vdma_dma_setup
 	}
 };
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 77db561..927c396 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -89,7 +89,7 @@ struct pv_init_ops {
 	 */
 	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
 			  unsigned long addr, unsigned len);
-};
+} __no_randomize_layout;
 
 
 struct pv_lazy_ops {
@@ -97,12 +97,12 @@ struct pv_lazy_ops {
 	void (*enter)(void);
 	void (*leave)(void);
 	void (*flush)(void);
-};
+} __no_randomize_layout;
 
 struct pv_time_ops {
 	unsigned long long (*sched_clock)(void);
 	unsigned long long (*steal_clock)(int cpu);
-};
+} __no_randomize_layout;
 
 struct pv_cpu_ops {
 	/* hooks for various privileged instructions */
@@ -178,7 +178,7 @@ struct pv_cpu_ops {
 
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
-};
+} __no_randomize_layout;
 
 struct pv_irq_ops {
 	/*
@@ -201,7 +201,7 @@ struct pv_irq_ops {
 #ifdef CONFIG_X86_64
 	void (*adjust_exception_frame)(void);
 #endif
-};
+} __no_randomize_layout;
 
 struct pv_mmu_ops {
 	unsigned long (*read_cr2)(void);
@@ -296,7 +296,7 @@ struct pv_mmu_ops {
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
 			   phys_addr_t phys, pgprot_t flags);
-};
+} __no_randomize_layout;
 
 struct arch_spinlock;
 #ifdef CONFIG_SMP
@@ -322,7 +322,9 @@ struct pv_lock_ops {
 
 /* This contains all the paravirt structures: we get a convenient
  * number for each function using the offset which we use to indicate
- * what to patch. */
+ * what to patch.
+ * shouldn't be randomized due to the "NEAT TRICK" in paravirt.c
+ */
 struct paravirt_patch_template {
 	struct pv_init_ops pv_init_ops;
 	struct pv_time_ops pv_time_ops;
@@ -330,7 +332,7 @@ struct paravirt_patch_template {
 	struct pv_irq_ops pv_irq_ops;
 	struct pv_mmu_ops pv_mmu_ops;
 	struct pv_lock_ops pv_lock_ops;
-};
+} __no_randomize_layout;
 
 extern struct pv_info pv_info;
 extern struct pv_init_ops pv_init_ops;
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index f76e0ea..4b83315 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -70,11 +70,12 @@ static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
 /* Legacy functions are optional, based upon ACPI_REDUCED_HARDWARE */
 
 static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_sleep),
-	 acpi_hw_extended_sleep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake_prep),
-	 acpi_hw_extended_wake_prep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake), acpi_hw_extended_wake}
+	{.legacy_function = ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_sleep),
+	 .extended_function = acpi_hw_extended_sleep},
+	{.legacy_function = ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake_prep),
+	 .extended_function = acpi_hw_extended_wake_prep},
+	{.legacy_function = ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake),
+	 .extended_function = acpi_hw_extended_wake}
 };
 
 /*
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 7fda30e..428766d 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -402,27 +402,27 @@ static bool SA5_performant_intr_pending(ctlr_info_t *h)
 }
 
 static struct access_method SA5_access = {
-	SA5_submit_command,
-	SA5_intr_mask,
-	SA5_fifo_full,
-	SA5_intr_pending,
-	SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5B_access = {
-        SA5_submit_command,
-        SA5B_intr_mask,
-        SA5_fifo_full,
-        SA5B_intr_pending,
-        SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5B_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5B_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5_performant_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_fifo_full,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 struct board_type {
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index d2e7d20..7bbe51f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -107,10 +107,10 @@ nouveau_vram_manager_new(struct ttm_mem_type_manager *man,
 }
 
 const struct ttm_mem_type_manager_func nouveau_vram_manager = {
-	nouveau_vram_manager_init,
-	nouveau_vram_manager_fini,
-	nouveau_vram_manager_new,
-	nouveau_vram_manager_del,
+	.init = nouveau_vram_manager_init,
+	.takedown = nouveau_vram_manager_fini,
+	.get_node = nouveau_vram_manager_new,
+	.put_node = nouveau_vram_manager_del,
 };
 
 static int
@@ -183,11 +183,11 @@ nouveau_gart_manager_debug(struct ttm_mem_type_manager *man, const char *prefix)
 }
 
 const struct ttm_mem_type_manager_func nouveau_gart_manager = {
-	nouveau_gart_manager_init,
-	nouveau_gart_manager_fini,
-	nouveau_gart_manager_new,
-	nouveau_gart_manager_del,
-	nouveau_gart_manager_debug
+	.init = nouveau_gart_manager_init,
+	.takedown = nouveau_gart_manager_fini,
+	.get_node = nouveau_gart_manager_new,
+	.put_node = nouveau_gart_manager_del,
+	.debug = nouveau_gart_manager_debug
 };
 
 /*XXX*/
@@ -256,11 +256,11 @@ nv04_gart_manager_debug(struct ttm_mem_type_manager *man, const char *prefix)
 }
 
 const struct ttm_mem_type_manager_func nv04_gart_manager = {
-	nv04_gart_manager_init,
-	nv04_gart_manager_fini,
-	nv04_gart_manager_new,
-	nv04_gart_manager_del,
-	nv04_gart_manager_debug
+	.init = nv04_gart_manager_init,
+	.takedown = nv04_gart_manager_fini,
+	.get_node = nv04_gart_manager_new,
+	.put_node = nv04_gart_manager_del,
+	.debug = nv04_gart_manager_debug
 };
 
 int
diff --git a/drivers/gpu/drm/ttm/ttm_bo_manager.c b/drivers/gpu/drm/ttm/ttm_bo_manager.c
index aa0bd05..aea6a01 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_manager.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_manager.c
@@ -148,10 +148,10 @@ static void ttm_bo_man_debug(struct ttm_mem_type_manager *man,
 }
 
 const struct ttm_mem_type_manager_func ttm_bo_manager_func = {
-	ttm_bo_man_init,
-	ttm_bo_man_takedown,
-	ttm_bo_man_get_node,
-	ttm_bo_man_put_node,
-	ttm_bo_man_debug
+	.init = ttm_bo_man_init,
+	.takedown = ttm_bo_man_takedown,
+	.get_node = ttm_bo_man_get_node,
+	.put_node = ttm_bo_man_put_node,
+	.debug = ttm_bo_man_debug
 };
 EXPORT_SYMBOL(ttm_bo_manager_func);
diff --git a/drivers/gpu/drm/virtio/virtgpu_ttm.c b/drivers/gpu/drm/virtio/virtgpu_ttm.c
index 9fd924c..e5ec4ef 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ttm.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ttm.c
@@ -198,11 +198,11 @@ static void ttm_bo_man_debug(struct ttm_mem_type_manager *man,
 }
 
 static const struct ttm_mem_type_manager_func virtio_gpu_bo_manager_func = {
-	ttm_bo_man_init,
-	ttm_bo_man_takedown,
-	ttm_bo_man_get_node,
-	ttm_bo_man_put_node,
-	ttm_bo_man_debug
+	.init = ttm_bo_man_init,
+	.takedown = ttm_bo_man_takedown,
+	.get_node = ttm_bo_man_get_node,
+	.put_node = ttm_bo_man_put_node,
+	.debug = ttm_bo_man_debug
 };
 
 static int virtio_gpu_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
index 170b61b..fec7348 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
@@ -164,9 +164,9 @@ static void vmw_gmrid_man_debug(struct ttm_mem_type_manager *man,
 }
 
 const struct ttm_mem_type_manager_func vmw_gmrid_manager_func = {
-	vmw_gmrid_man_init,
-	vmw_gmrid_man_takedown,
-	vmw_gmrid_man_get_node,
-	vmw_gmrid_man_put_node,
-	vmw_gmrid_man_debug
+	.init = vmw_gmrid_man_init,
+	.takedown = vmw_gmrid_man_takedown,
+	.get_node = vmw_gmrid_man_get_node,
+	.put_node = vmw_gmrid_man_put_node,
+	.debug = vmw_gmrid_man_debug
 };
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index cb9f0f2..8b1f654 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -135,17 +135,17 @@ static void record_ird_ord(struct nes_cm_node *, u16, u16);
 /* instance of function pointers for client API */
 /* set address of this instance to cm_core->cm_ops at cm_core alloc */
 static const struct nes_cm_ops nes_cm_api = {
-	mini_cm_accelerated,
-	mini_cm_listen,
-	mini_cm_del_listen,
-	mini_cm_connect,
-	mini_cm_close,
-	mini_cm_accept,
-	mini_cm_reject,
-	mini_cm_recv_pkt,
-	mini_cm_dealloc_core,
-	mini_cm_get,
-	mini_cm_set
+	.accelerated = mini_cm_accelerated,
+	.listen = mini_cm_listen,
+	.stop_listener = mini_cm_del_listen,
+	.connect = mini_cm_connect,
+	.close = mini_cm_close,
+	.accept = mini_cm_accept,
+	.reject = mini_cm_reject,
+	.recv_pkt = mini_cm_recv_pkt,
+	.destroy_cm_core = mini_cm_dealloc_core,
+	.get = mini_cm_get,
+	.set = mini_cm_set
 };
 
 static struct nes_cm_core *g_cm_core;
diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index aecec6d..11e13c5 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2565,22 +2565,22 @@ static int gigaset_post_reset(struct usb_interface *intf)
 
 
 static const struct gigaset_ops gigops = {
-	gigaset_write_cmd,
-	gigaset_write_room,
-	gigaset_chars_in_buffer,
-	gigaset_brkchars,
-	gigaset_init_bchannel,
-	gigaset_close_bchannel,
-	gigaset_initbcshw,
-	gigaset_freebcshw,
-	gigaset_reinitbcshw,
-	gigaset_initcshw,
-	gigaset_freecshw,
-	gigaset_set_modem_ctrl,
-	gigaset_baud_rate,
-	gigaset_set_line_ctrl,
-	gigaset_isoc_send_skb,
-	gigaset_isoc_input,
+	.write_cmd = gigaset_write_cmd,
+	.write_room = gigaset_write_room,
+	.chars_in_buffer = gigaset_chars_in_buffer,
+	.brkchars = gigaset_brkchars,
+	.init_bchannel = gigaset_init_bchannel,
+	.close_bchannel = gigaset_close_bchannel,
+	.initbcshw = gigaset_initbcshw,
+	.freebcshw = gigaset_freebcshw,
+	.reinitbcshw = gigaset_reinitbcshw,
+	.initcshw = gigaset_initcshw,
+	.freecshw = gigaset_freecshw,
+	.set_modem_ctrl = gigaset_set_modem_ctrl,
+	.baud_rate = gigaset_baud_rate,
+	.set_line_ctrl = gigaset_set_line_ctrl,
+	.send_skb = gigaset_isoc_send_skb,
+	.handle_input = gigaset_isoc_input,
 };
 
 /* bas_gigaset_init
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index d1f8ab9..c0412f2 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -445,22 +445,22 @@ static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
 }
 
 static const struct gigaset_ops ops = {
-	gigaset_write_cmd,
-	gigaset_write_room,
-	gigaset_chars_in_buffer,
-	gigaset_brkchars,
-	gigaset_init_bchannel,
-	gigaset_close_bchannel,
-	gigaset_initbcshw,
-	gigaset_freebcshw,
-	gigaset_reinitbcshw,
-	gigaset_initcshw,
-	gigaset_freecshw,
-	gigaset_set_modem_ctrl,
-	gigaset_baud_rate,
-	gigaset_set_line_ctrl,
-	gigaset_m10x_send_skb,	/* asyncdata.c */
-	gigaset_m10x_input,	/* asyncdata.c */
+	.write_cmd = gigaset_write_cmd,
+	.write_room = gigaset_write_room,
+	.chars_in_buffer = gigaset_chars_in_buffer,
+	.brkchars = gigaset_brkchars,
+	.init_bchannel = gigaset_init_bchannel,
+	.close_bchannel = gigaset_close_bchannel,
+	.initbcshw = gigaset_initbcshw,
+	.freebcshw = gigaset_freebcshw,
+	.reinitbcshw = gigaset_reinitbcshw,
+	.initcshw = gigaset_initcshw,
+	.freecshw = gigaset_freecshw,
+	.set_modem_ctrl = gigaset_set_modem_ctrl,
+	.baud_rate = gigaset_baud_rate,
+	.set_line_ctrl = gigaset_set_line_ctrl,
+	.send_skb = gigaset_m10x_send_skb,	/* asyncdata.c */
+	.handle_input = gigaset_m10x_input,	/* asyncdata.c */
 };
 
 
diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index 5f306e2..eade36d 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -862,22 +862,22 @@ static int gigaset_pre_reset(struct usb_interface *intf)
 }
 
 static const struct gigaset_ops ops = {
-	gigaset_write_cmd,
-	gigaset_write_room,
-	gigaset_chars_in_buffer,
-	gigaset_brkchars,
-	gigaset_init_bchannel,
-	gigaset_close_bchannel,
-	gigaset_initbcshw,
-	gigaset_freebcshw,
-	gigaset_reinitbcshw,
-	gigaset_initcshw,
-	gigaset_freecshw,
-	gigaset_set_modem_ctrl,
-	gigaset_baud_rate,
-	gigaset_set_line_ctrl,
-	gigaset_m10x_send_skb,
-	gigaset_m10x_input,
+	.write_cmd = gigaset_write_cmd,
+	.write_room = gigaset_write_room,
+	.chars_in_buffer = gigaset_chars_in_buffer,
+	.brkchars = gigaset_brkchars,
+	.init_bchannel = gigaset_init_bchannel,
+	.close_bchannel = gigaset_close_bchannel,
+	.initbcshw = gigaset_initbcshw,
+	.freebcshw = gigaset_freebcshw,
+	.reinitbcshw = gigaset_reinitbcshw,
+	.initcshw = gigaset_initcshw,
+	.freecshw = gigaset_freecshw,
+	.set_modem_ctrl = gigaset_set_modem_ctrl,
+	.baud_rate = gigaset_baud_rate,
+	.set_line_ctrl = gigaset_set_line_ctrl,
+	.send_skb = gigaset_m10x_send_skb,
+	.handle_input = gigaset_m10x_input,
 };
 
 /*
diff --git a/drivers/isdn/i4l/isdn_concap.c b/drivers/isdn/i4l/isdn_concap.c
index 91d5730..336523e 100644
--- a/drivers/isdn/i4l/isdn_concap.c
+++ b/drivers/isdn/i4l/isdn_concap.c
@@ -80,9 +80,9 @@ static int isdn_concap_dl_disconn_req(struct concap_proto *concap)
 }
 
 struct concap_device_ops isdn_concap_reliable_dl_dops = {
-	&isdn_concap_dl_data_req,
-	&isdn_concap_dl_connect_req,
-	&isdn_concap_dl_disconn_req
+	.data_req = &isdn_concap_dl_data_req,
+	.connect_req = &isdn_concap_dl_connect_req,
+	.disconn_req = &isdn_concap_dl_disconn_req
 };
 
 /* The following should better go into a dedicated source file such that
diff --git a/drivers/isdn/i4l/isdn_x25iface.c b/drivers/isdn/i4l/isdn_x25iface.c
index e2d4e58..40cd045 100644
--- a/drivers/isdn/i4l/isdn_x25iface.c
+++ b/drivers/isdn/i4l/isdn_x25iface.c
@@ -53,14 +53,14 @@ static int isdn_x25iface_disconn_ind(struct concap_proto *);
 
 
 static struct concap_proto_ops ix25_pops = {
-	&isdn_x25iface_proto_new,
-	&isdn_x25iface_proto_del,
-	&isdn_x25iface_proto_restart,
-	&isdn_x25iface_proto_close,
-	&isdn_x25iface_xmit,
-	&isdn_x25iface_receive,
-	&isdn_x25iface_connect_ind,
-	&isdn_x25iface_disconn_ind
+	.proto_new = &isdn_x25iface_proto_new,
+	.proto_del = &isdn_x25iface_proto_del,
+	.restart = &isdn_x25iface_proto_restart,
+	.close = &isdn_x25iface_proto_close,
+	.encap_and_xmit = &isdn_x25iface_xmit,
+	.data_ind = &isdn_x25iface_receive,
+	.connect_ind = &isdn_x25iface_connect_ind,
+	.disconn_ind = &isdn_x25iface_disconn_ind
 };
 
 /* error message helper function */
diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 4a37a1c..7e82dfd 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 
 int solo_g723_init(struct solo_dev *solo_dev)
 {
-	static struct snd_device_ops ops = { NULL };
+	static struct snd_device_ops ops = { };
 	struct snd_card *card;
 	struct snd_kcontrol_new kctl;
 	char name[32];
diff --git a/drivers/net/ethernet/brocade/bna/bna_enet.c b/drivers/net/ethernet/brocade/bna/bna_enet.c
index 4e5c387..bba8173 100644
--- a/drivers/net/ethernet/brocade/bna/bna_enet.c
+++ b/drivers/net/ethernet/brocade/bna/bna_enet.c
@@ -1676,10 +1676,10 @@ bna_cb_ioceth_reset(void *arg)
 }
 
 static struct bfa_ioc_cbfn bna_ioceth_cbfn = {
-	bna_cb_ioceth_enable,
-	bna_cb_ioceth_disable,
-	bna_cb_ioceth_hbfail,
-	bna_cb_ioceth_reset
+	.enable_cbfn = bna_cb_ioceth_enable,
+	.disable_cbfn = bna_cb_ioceth_disable,
+	.hbfail_cbfn = bna_cb_ioceth_hbfail,
+	.reset_cbfn = bna_cb_ioceth_reset
 };
 
 static void bna_attr_init(struct bna_ioceth *ioceth)
diff --git a/drivers/net/wan/lmc/lmc_media.c b/drivers/net/wan/lmc/lmc_media.c
index 5920c99..ff2e4a5 100644
--- a/drivers/net/wan/lmc/lmc_media.c
+++ b/drivers/net/wan/lmc/lmc_media.c
@@ -95,62 +95,63 @@ static inline void write_av9110_bit (lmc_softc_t *, int);
 static void write_av9110(lmc_softc_t *, u32, u32, u32, u32, u32);
 
 lmc_media_t lmc_ds3_media = {
-  lmc_ds3_init,			/* special media init stuff */
-  lmc_ds3_default,		/* reset to default state */
-  lmc_ds3_set_status,		/* reset status to state provided */
-  lmc_dummy_set_1,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_ds3_set_100ft,		/* set cable length */
-  lmc_ds3_set_scram,		/* set scrambler */
-  lmc_ds3_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_ds3_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ds3_watchdog
+  .init = lmc_ds3_init,				/* special media init stuff */
+  .defaults = lmc_ds3_default,			/* reset to default state */
+  .set_status = lmc_ds3_set_status,		/* reset status to state provided */
+  .set_clock_source = lmc_dummy_set_1,		/* set clock source */
+  .set_speed = lmc_dummy_set2_1,		/* set line speed */
+  .set_cable_length = lmc_ds3_set_100ft,	/* set cable length */
+  .set_scrambler = lmc_ds3_set_scram,		/* set scrambler */
+  .get_link_status = lmc_ds3_get_link_status,	/* get link status */
+  .set_link_status = lmc_dummy_set_1,		/* set link status */
+  .set_crc_length = lmc_ds3_set_crc_length,	/* set CRC length */
+  .set_circuit_type = lmc_dummy_set_1,		/* set T1 or E1 circuit type */
+  .watchdog = lmc_ds3_watchdog
 };
 
 lmc_media_t lmc_hssi_media = {
-  lmc_hssi_init,		/* special media init stuff */
-  lmc_hssi_default,		/* reset to default state */
-  lmc_hssi_set_status,		/* reset status to state provided */
-  lmc_hssi_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_hssi_get_link_status,	/* get link status */
-  lmc_hssi_set_link_status,	/* set link status */
-  lmc_hssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_hssi_watchdog
+  .init = lmc_hssi_init,			/* special media init stuff */
+  .defaults = lmc_hssi_default,			/* reset to default state */
+  .set_status = lmc_hssi_set_status,		/* reset status to state provided */
+  .set_clock_source = lmc_hssi_set_clock,	/* set clock source */
+  .set_speed = lmc_dummy_set2_1,		/* set line speed */
+  .set_cable_length = lmc_dummy_set_1,		/* set cable length */
+  .set_scrambler = lmc_dummy_set_1,		/* set scrambler */
+  .get_link_status = lmc_hssi_get_link_status,	/* get link status */
+  .set_link_status = lmc_hssi_set_link_status,	/* set link status */
+  .set_crc_length = lmc_hssi_set_crc_length,	/* set CRC length */
+  .set_circuit_type = lmc_dummy_set_1,		/* set T1 or E1 circuit type */
+  .watchdog = lmc_hssi_watchdog
 };
 
-lmc_media_t lmc_ssi_media = { lmc_ssi_init,	/* special media init stuff */
-  lmc_ssi_default,		/* reset to default state */
-  lmc_ssi_set_status,		/* reset status to state provided */
-  lmc_ssi_set_clock,		/* set clock source */
-  lmc_ssi_set_speed,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_ssi_get_link_status,	/* get link status */
-  lmc_ssi_set_link_status,	/* set link status */
-  lmc_ssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ssi_watchdog
+lmc_media_t lmc_ssi_media = {
+  .init = lmc_ssi_init,				/* special media init stuff */
+  .defaults = lmc_ssi_default,			/* reset to default state */
+  .set_status = lmc_ssi_set_status,		/* reset status to state provided */
+  .set_clock_source = lmc_ssi_set_clock,	/* set clock source */
+  .set_speed = lmc_ssi_set_speed,		/* set line speed */
+  .set_cable_length = lmc_dummy_set_1,		/* set cable length */
+  .set_scrambler = lmc_dummy_set_1,		/* set scrambler */
+  .get_link_status = lmc_ssi_get_link_status,	/* get link status */
+  .set_link_status = lmc_ssi_set_link_status,	/* set link status */
+  .set_crc_length = lmc_ssi_set_crc_length,	/* set CRC length */
+  .set_circuit_type = lmc_dummy_set_1,		/* set T1 or E1 circuit type */
+  .watchdog = lmc_ssi_watchdog
 };
 
 lmc_media_t lmc_t1_media = {
-  lmc_t1_init,			/* special media init stuff */
-  lmc_t1_default,		/* reset to default state */
-  lmc_t1_set_status,		/* reset status to state provided */
-  lmc_t1_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_t1_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_t1_set_crc_length,	/* set CRC length */
-  lmc_t1_set_circuit_type,	/* set T1 or E1 circuit type */
-  lmc_t1_watchdog
+  .init = lmc_t1_init,				/* special media init stuff */
+  .defaults = lmc_t1_default,			/* reset to default state */
+  .set_status = lmc_t1_set_status,		/* reset status to state provided */
+  .set_clock_source = lmc_t1_set_clock,		/* set clock source */
+  .set_speed = lmc_dummy_set2_1,		/* set line speed */
+  .set_cable_length = lmc_dummy_set_1,		/* set cable length */
+  .set_scrambler = lmc_dummy_set_1,		/* set scrambler */
+  .get_link_status = lmc_t1_get_link_status,	/* get link status */
+  .set_link_status = lmc_dummy_set_1,		/* set link status */
+  .set_crc_length = lmc_t1_set_crc_length,	/* set CRC length */
+  .set_circuit_type = lmc_t1_set_circuit_type,	/* set T1 or E1 circuit type */
+  .watchdog = lmc_t1_watchdog
 };
 
 static void
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 1e7e139..c2031dd 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -39,10 +39,21 @@ struct bfa_fcs_mod_s {
 #define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
 
 static struct bfa_fcs_mod_s fcs_modules[] = {
-	{ bfa_fcs_port_attach, NULL, NULL },
-	{ bfa_fcs_uf_attach, NULL, NULL },
-	{ bfa_fcs_fabric_attach, bfa_fcs_fabric_modinit,
-	  bfa_fcs_fabric_modexit },
+	{
+		.attach = bfa_fcs_port_attach,
+		.modinit = NULL,
+		.modexit = NULL
+	},
+	{
+		.attach = bfa_fcs_uf_attach,
+		.modinit = NULL,
+		.modexit = NULL
+	},
+	{
+		.attach = bfa_fcs_fabric_attach,
+		.modinit = bfa_fcs_fabric_modinit,
+		.modexit = bfa_fcs_fabric_modexit
+	},
 };
 
 /*
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 7733ad5..e5edbce 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -90,15 +90,26 @@ static struct {
 	void		(*offline) (struct bfa_fcs_lport_s *port);
 } __port_action[] = {
 	{
-	bfa_fcs_lport_unknown_init, bfa_fcs_lport_unknown_online,
-			bfa_fcs_lport_unknown_offline}, {
-	bfa_fcs_lport_fab_init, bfa_fcs_lport_fab_online,
-			bfa_fcs_lport_fab_offline}, {
-	bfa_fcs_lport_n2n_init, bfa_fcs_lport_n2n_online,
-			bfa_fcs_lport_n2n_offline}, {
-	bfa_fcs_lport_loop_init, bfa_fcs_lport_loop_online,
-			bfa_fcs_lport_loop_offline},
-	};
+		.init = bfa_fcs_lport_unknown_init,
+		.online = bfa_fcs_lport_unknown_online,
+		.offline = bfa_fcs_lport_unknown_offline
+	},
+	{
+		.init = bfa_fcs_lport_fab_init,
+		.online = bfa_fcs_lport_fab_online,
+		.offline = bfa_fcs_lport_fab_offline
+	},
+	{
+		.init = bfa_fcs_lport_n2n_init,
+		.online = bfa_fcs_lport_n2n_online,
+		.offline = bfa_fcs_lport_n2n_offline
+	},
+	{
+		.init = bfa_fcs_lport_loop_init,
+		.online = bfa_fcs_lport_loop_online,
+		.offline = bfa_fcs_lport_loop_offline
+	},
+};
 
 /*
  *  fcs_port_sm FCS logical port state machine
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 53135f2..640621b 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -79,12 +79,12 @@ enum {
 									\
 	extern struct bfa_module_s hal_mod_ ## __mod;			\
 	struct bfa_module_s hal_mod_ ## __mod = {			\
-		bfa_ ## __mod ## _meminfo,				\
-		bfa_ ## __mod ## _attach,				\
-		bfa_ ## __mod ## _detach,				\
-		bfa_ ## __mod ## _start,				\
-		bfa_ ## __mod ## _stop,					\
-		bfa_ ## __mod ## _iocdisable,				\
+		.meminfo = bfa_ ## __mod ## _meminfo,			\
+		.attach = bfa_ ## __mod ## _attach,			\
+		.detach = bfa_ ## __mod ## _detach,			\
+		.start = bfa_ ## __mod ## _start,			\
+		.stop = bfa_ ## __mod ## _stop,				\
+		.iocdisable = bfa_ ## __mod ## _iocdisable,		\
 	}
 
 #define BFA_CACHELINE_SZ	(256)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fdd39fc..b734478 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -577,38 +577,38 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 }
 
 static struct access_method SA5_access = {
-	SA5_submit_command,
-	SA5_intr_mask,
-	SA5_intr_pending,
-	SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_intr_mask,
+	.intr_pending = SA5_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5_ioaccel_mode1_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_ioaccel_mode1_intr_pending,
-	SA5_ioaccel_mode1_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_ioaccel_mode1_intr_pending,
+	.command_completed = SA5_ioaccel_mode1_completed,
 };
 
 static struct access_method SA5_ioaccel_mode2_access = {
-	SA5_submit_command_ioaccel2,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command_ioaccel2,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 static struct access_method SA5_performant_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 static struct access_method SA5_performant_access_no_read = {
-	SA5_submit_command_no_read,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command_no_read,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 struct board_type {
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 4310154..605d035 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -147,7 +147,7 @@ static int ldlm_process_flock_lock(struct ldlm_lock *req, __u64 *flags,
 	int added = (mode == LCK_NL);
 	int overlaps = 0;
 	int splitted = 0;
-	const struct ldlm_callback_suite null_cbs = { NULL };
+	const struct ldlm_callback_suite null_cbs = { };
 
 	CDEBUG(D_DLMTRACE,
 	       "flags %#llx owner %llu pid %u mode %u start %llu end %llu\n",
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 329d78c..9756f9e 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -322,11 +322,11 @@ out:
 }
 
 struct cfs_psdev_ops libcfs_psdev_ops = {
-	libcfs_psdev_open,
-	libcfs_psdev_release,
-	NULL,
-	NULL,
-	libcfs_ioctl
+	.p_open = libcfs_psdev_open,
+	.p_close = libcfs_psdev_release,
+	.p_read = NULL,
+	.p_write = NULL,
+	.p_ioctl = libcfs_ioctl
 };
 
 static int proc_call_handler(void *data, int write, loff_t *ppos,
diff --git a/drivers/video/fbdev/matrox/matroxfb_DAC1064.c b/drivers/video/fbdev/matrox/matroxfb_DAC1064.c
index a01147f..5d896f8 100644
--- a/drivers/video/fbdev/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/fbdev/matrox/matroxfb_DAC1064.c
@@ -1088,14 +1088,20 @@ static void MGAG100_restore(struct matrox_fb_info *minfo)
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
 struct matrox_switch matrox_mystique = {
-	MGA1064_preinit, MGA1064_reset, MGA1064_init, MGA1064_restore,
+	.preinit = MGA1064_preinit,
+	.reset = MGA1064_reset,
+	.init = MGA1064_init,
+	.restore = MGA1064_restore,
 };
 EXPORT_SYMBOL(matrox_mystique);
 #endif
 
 #ifdef CONFIG_FB_MATROX_G
 struct matrox_switch matrox_G100 = {
-	MGAG100_preinit, MGAG100_reset, MGAG100_init, MGAG100_restore,
+	.preinit = MGAG100_preinit,
+	.reset = MGAG100_reset,
+	.init = MGAG100_init,
+	.restore = MGAG100_restore,
 };
 EXPORT_SYMBOL(matrox_G100);
 #endif
diff --git a/drivers/video/fbdev/matrox/matroxfb_Ti3026.c b/drivers/video/fbdev/matrox/matroxfb_Ti3026.c
index 195ad7c..09743fc 100644
--- a/drivers/video/fbdev/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/fbdev/matrox/matroxfb_Ti3026.c
@@ -738,7 +738,10 @@ static int Ti3026_preinit(struct matrox_fb_info *minfo)
 }
 
 struct matrox_switch matrox_millennium = {
-	Ti3026_preinit, Ti3026_reset, Ti3026_init, Ti3026_restore
+	.preinit = Ti3026_preinit,
+	.reset = Ti3026_reset,
+	.init = Ti3026_init,
+	.restore = Ti3026_restore
 };
 EXPORT_SYMBOL(matrox_millennium);
 #endif
diff --git a/fs/reiserfs/item_ops.c b/fs/reiserfs/item_ops.c
index aca73dd..e3c558d 100644
--- a/fs/reiserfs/item_ops.c
+++ b/fs/reiserfs/item_ops.c
@@ -724,18 +724,18 @@ static void errcatch_print_vi(struct virtual_item *vi)
 }
 
 static struct item_operations errcatch_ops = {
-	errcatch_bytes_number,
-	errcatch_decrement_key,
-	errcatch_is_left_mergeable,
-	errcatch_print_item,
-	errcatch_check_item,
-
-	errcatch_create_vi,
-	errcatch_check_left,
-	errcatch_check_right,
-	errcatch_part_size,
-	errcatch_unit_num,
-	errcatch_print_vi
+	.bytes_number = errcatch_bytes_number,
+	.decrement_key = errcatch_decrement_key,
+	.is_left_mergeable = errcatch_is_left_mergeable,
+	.print_item = errcatch_print_item,
+	.check_item = errcatch_check_item,
+
+	.create_vi = errcatch_create_vi,
+	.check_left = errcatch_check_left,
+	.check_right = errcatch_check_right,
+	.part_size = errcatch_part_size,
+	.unit_num = errcatch_unit_num,
+	.print_vi = errcatch_print_vi
 };
 
 #if ! (TYPE_STAT_DATA == 0 && TYPE_INDIRECT == 1 && TYPE_DIRECT == 2 && TYPE_DIRENTRY == 3)
diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index 14d7b83..a1edf56 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -90,7 +90,9 @@ rbname ## _rotate(struct rb_node *rb_old, struct rb_node *rb_new)	\
 	old->rbaugmented = rbcompute(old);				\
 }									\
 rbstatic const struct rb_augment_callbacks rbname = {			\
-	rbname ## _propagate, rbname ## _copy, rbname ## _rotate	\
+	.propagate = rbname ## _propagate,				\
+	.copy = rbname ## _copy,					\
+	.rotate = rbname ## _rotate					\
 };
 
 
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 1356454..70ce6c6 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -412,7 +412,9 @@ static inline void dummy_copy(struct rb_node *old, struct rb_node *new) {}
 static inline void dummy_rotate(struct rb_node *old, struct rb_node *new) {}
 
 static const struct rb_augment_callbacks dummy_callbacks = {
-	dummy_propagate, dummy_copy, dummy_rotate
+	.propagate = dummy_propagate,
+	.copy = dummy_copy,
+	.rotate = dummy_rotate
 };
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 838ca8bb..7432a90 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -561,7 +561,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 		__mod_zone_freepage_state(zone, (1 << order), migratetype);
 }
 #else
-struct page_ext_operations debug_guardpage_ops = { NULL, };
+struct page_ext_operations debug_guardpage_ops = { .need = NULL, .init = NULL };
 static inline void set_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype) {}
 static inline void clear_page_guard(struct zone *zone, struct page *page,
diff --git a/net/atm/lec.c b/net/atm/lec.c
index cd3b379..977a3c9 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -111,9 +111,9 @@ static inline void lec_arp_put(struct lec_arp_table *entry)
 }
 
 static struct lane2_ops lane2_ops = {
-	lane2_resolve,		/* resolve,             spec 3.1.3 */
-	lane2_associate_req,	/* associate_req,       spec 3.1.4 */
-	NULL			/* associate indicator, spec 3.1.5 */
+	.resolve = lane2_resolve,
+	.associate_req = lane2_associate_req,
+	.associate_indicator = NULL
 };
 
 static unsigned char bus_mac[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
diff --git a/net/atm/mpoa_caches.c b/net/atm/mpoa_caches.c
index 9e60e74..637c96e 100644
--- a/net/atm/mpoa_caches.c
+++ b/net/atm/mpoa_caches.c
@@ -535,30 +535,29 @@ static void eg_destroy_cache(struct mpoa_client *mpc)
 
 
 static const struct in_cache_ops ingress_ops = {
-	in_cache_add_entry,               /* add_entry       */
-	in_cache_get,                     /* get             */
-	in_cache_get_with_mask,           /* get_with_mask   */
-	in_cache_get_by_vcc,              /* get_by_vcc      */
-	in_cache_put,                     /* put             */
-	in_cache_remove_entry,            /* remove_entry    */
-	cache_hit,                        /* cache_hit       */
-	clear_count_and_expired,          /* clear_count     */
-	check_resolving_entries,          /* check_resolving */
-	refresh_entries,                  /* refresh         */
-	in_destroy_cache                  /* destroy_cache   */
+	.add_entry = in_cache_add_entry,
+	.get = in_cache_get,
+	.get_with_mask = in_cache_get_with_mask,
+	.get_by_vcc = in_cache_get_by_vcc,
+	.put = in_cache_put,
+	.remove_entry = in_cache_remove_entry,
+	.cache_hit = cache_hit,
+	.clear_count = clear_count_and_expired,
+	.check_resolving = check_resolving_entries,
+	.refresh = refresh_entries,
 };
 
 static const struct eg_cache_ops egress_ops = {
-	eg_cache_add_entry,               /* add_entry        */
-	eg_cache_get_by_cache_id,         /* get_by_cache_id  */
-	eg_cache_get_by_tag,              /* get_by_tag       */
-	eg_cache_get_by_vcc,              /* get_by_vcc       */
-	eg_cache_get_by_src_ip,           /* get_by_src_ip    */
-	eg_cache_put,                     /* put              */
-	eg_cache_remove_entry,            /* remove_entry     */
-	update_eg_cache_entry,            /* update           */
-	clear_expired,                    /* clear_expired    */
-	eg_destroy_cache                  /* destroy_cache    */
+	.add_entry = eg_cache_add_entry,
+	.get_by_cache_id = eg_cache_get_by_cache_id,
+	.get_by_tag = eg_cache_get_by_tag,
+	.get_by_vcc = eg_cache_get_by_vcc,
+	.get_by_src_ip = eg_cache_get_by_src_ip,
+	.put = eg_cache_put,
+	.remove_entry = eg_cache_remove_entry,
+	.update = update_eg_cache_entry,
+	.clear_expired = clear_expired,
+	.destroy_cache = eg_destroy_cache
 };
 
 
diff --git a/net/vmw_vsock/vmci_transport_notify.c b/net/vmw_vsock/vmci_transport_notify.c
index fd8cf02..1406db4 100644
--- a/net/vmw_vsock/vmci_transport_notify.c
+++ b/net/vmw_vsock/vmci_transport_notify.c
@@ -662,19 +662,19 @@ static void vmci_transport_notify_pkt_process_negotiate(struct sock *sk)
 
 /* Socket control packet based operations. */
 const struct vmci_transport_notify_ops vmci_transport_notify_pkt_ops = {
-	vmci_transport_notify_pkt_socket_init,
-	vmci_transport_notify_pkt_socket_destruct,
-	vmci_transport_notify_pkt_poll_in,
-	vmci_transport_notify_pkt_poll_out,
-	vmci_transport_notify_pkt_handle_pkt,
-	vmci_transport_notify_pkt_recv_init,
-	vmci_transport_notify_pkt_recv_pre_block,
-	vmci_transport_notify_pkt_recv_pre_dequeue,
-	vmci_transport_notify_pkt_recv_post_dequeue,
-	vmci_transport_notify_pkt_send_init,
-	vmci_transport_notify_pkt_send_pre_block,
-	vmci_transport_notify_pkt_send_pre_enqueue,
-	vmci_transport_notify_pkt_send_post_enqueue,
-	vmci_transport_notify_pkt_process_request,
-	vmci_transport_notify_pkt_process_negotiate,
+	.socket_init = vmci_transport_notify_pkt_socket_init,
+	.socket_destruct = vmci_transport_notify_pkt_socket_destruct,
+	.poll_in = vmci_transport_notify_pkt_poll_in,
+	.poll_out = vmci_transport_notify_pkt_poll_out,
+	.handle_notify_pkt = vmci_transport_notify_pkt_handle_pkt,
+	.recv_init = vmci_transport_notify_pkt_recv_init,
+	.recv_pre_block = vmci_transport_notify_pkt_recv_pre_block,
+	.recv_pre_dequeue = vmci_transport_notify_pkt_recv_pre_dequeue,
+	.recv_post_dequeue = vmci_transport_notify_pkt_recv_post_dequeue,
+	.send_init = vmci_transport_notify_pkt_send_init,
+	.send_pre_block = vmci_transport_notify_pkt_send_pre_block,
+	.send_pre_enqueue = vmci_transport_notify_pkt_send_pre_enqueue,
+	.send_post_enqueue = vmci_transport_notify_pkt_send_post_enqueue,
+	.process_request = vmci_transport_notify_pkt_process_request,
+	.process_negotiate = vmci_transport_notify_pkt_process_negotiate,
 };
diff --git a/net/vmw_vsock/vmci_transport_notify_qstate.c b/net/vmw_vsock/vmci_transport_notify_qstate.c
index 21e591d..f3a0afc 100644
--- a/net/vmw_vsock/vmci_transport_notify_qstate.c
+++ b/net/vmw_vsock/vmci_transport_notify_qstate.c
@@ -420,19 +420,19 @@ vmci_transport_notify_pkt_send_pre_enqueue(
 
 /* Socket always on control packet based operations. */
 const struct vmci_transport_notify_ops vmci_transport_notify_pkt_q_state_ops = {
-	vmci_transport_notify_pkt_socket_init,
-	vmci_transport_notify_pkt_socket_destruct,
-	vmci_transport_notify_pkt_poll_in,
-	vmci_transport_notify_pkt_poll_out,
-	vmci_transport_notify_pkt_handle_pkt,
-	vmci_transport_notify_pkt_recv_init,
-	vmci_transport_notify_pkt_recv_pre_block,
-	vmci_transport_notify_pkt_recv_pre_dequeue,
-	vmci_transport_notify_pkt_recv_post_dequeue,
-	vmci_transport_notify_pkt_send_init,
-	vmci_transport_notify_pkt_send_pre_block,
-	vmci_transport_notify_pkt_send_pre_enqueue,
-	vmci_transport_notify_pkt_send_post_enqueue,
-	vmci_transport_notify_pkt_process_request,
-	vmci_transport_notify_pkt_process_negotiate,
+	.socket_init = vmci_transport_notify_pkt_socket_init,
+	.socket_destruct = vmci_transport_notify_pkt_socket_destruct,
+	.poll_in = vmci_transport_notify_pkt_poll_in,
+	.poll_out = vmci_transport_notify_pkt_poll_out,
+	.handle_notify_pkt = vmci_transport_notify_pkt_handle_pkt,
+	.recv_init = vmci_transport_notify_pkt_recv_init,
+	.recv_pre_block = vmci_transport_notify_pkt_recv_pre_block,
+	.recv_pre_dequeue = vmci_transport_notify_pkt_recv_pre_dequeue,
+	.recv_post_dequeue = vmci_transport_notify_pkt_recv_post_dequeue,
+	.send_init = vmci_transport_notify_pkt_send_init,
+	.send_pre_block = vmci_transport_notify_pkt_send_pre_block,
+	.send_pre_enqueue = vmci_transport_notify_pkt_send_pre_enqueue,
+	.send_post_enqueue = vmci_transport_notify_pkt_send_post_enqueue,
+	.process_request = vmci_transport_notify_pkt_process_request,
+	.process_negotiate = vmci_transport_notify_pkt_process_negotiate,
 };
diff --git a/sound/synth/emux/emux_seq.c b/sound/synth/emux/emux_seq.c
index a020920..55579f6 100644
--- a/sound/synth/emux/emux_seq.c
+++ b/sound/synth/emux/emux_seq.c
@@ -33,13 +33,13 @@ static int snd_emux_unuse(void *private_data, struct snd_seq_port_subscribe *inf
  * MIDI emulation operators
  */
 static struct snd_midi_op emux_ops = {
-	snd_emux_note_on,
-	snd_emux_note_off,
-	snd_emux_key_press,
-	snd_emux_terminate_note,
-	snd_emux_control,
-	snd_emux_nrpn,
-	snd_emux_sysex,
+	.note_on = snd_emux_note_on,
+	.note_off = snd_emux_note_off,
+	.key_press = snd_emux_key_press,
+	.note_terminate = snd_emux_terminate_note,
+	.control = snd_emux_control,
+	.nrpn = snd_emux_nrpn,
+	.sysex = snd_emux_sysex,
 };
 
 
-- 
1.9.1
