From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu, 30 Nov 2017 10:38:37 +1100
Message-Id: <1511998718-4158-2-git-send-email-me@tobin.cc>
In-Reply-To: <1511998718-4158-1-git-send-email-me@tobin.cc>
References: <1511998718-4158-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 1/2] tree-wide: replace all users of %pK with %p
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Krcm=C3=A1r?= <rkrcmar@redhat.com>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

%p is now hashed, it is therefore more secure than %p (with
 kptr_restrict==0). We may be able to remove %pK and kptr_restrict
 altogether now. First, let's replace all in tree users of %pK. We can
 give this a while in the wild to see what breaks. Then if things play
 nicely we can remove %pK  (and kptr_restrict).

Search and replace all uses of %pK with %p.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 arch/arm/mm/physaddr.c                             |  2 +-
 arch/arm64/mm/physaddr.c                           |  2 +-
 arch/mips/kernel/relocate.c                        | 10 +--
 arch/mips/kvm/mips.c                               |  2 +-
 arch/powerpc/perf/hv-24x7.c                        |  8 +--
 arch/s390/kvm/intercept.c                          |  2 +-
 arch/s390/kvm/kvm-s390.c                           | 10 +--
 arch/s390/kvm/trace-s390.h                         |  4 +-
 drivers/android/binder.c                           |  2 +-
 drivers/android/binder_alloc.c                     | 28 ++++----
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            | 22 +++---
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  2 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |  2 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |  4 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  4 +-
 drivers/net/wireless/ath/ath10k/core.c             |  4 +-
 drivers/net/wireless/ath/ath10k/htc.c              |  6 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c              | 22 +++---
 drivers/net/wireless/ath/ath10k/pci.c              |  2 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |  4 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |  2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |  4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  4 +-
 drivers/spi/spi-loopback-test.c                    | 12 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c             | 54 +++++++-------
 drivers/staging/ccree/ssi_cipher.c                 |  4 +-
 drivers/staging/ccree/ssi_hash.c                   | 30 ++++----
 .../interface/vchiq_arm/vchiq_2835_arm.c           |  6 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  | 16 ++---
 .../vc04_services/interface/vchiq_arm/vchiq_core.c | 84 +++++++++++-----------
 .../interface/vchiq_arm/vchiq_kern_lib.c           |  4 +-
 drivers/usb/core/devio.c                           | 14 ++--
 drivers/usb/core/hcd.c                             |  4 +-
 drivers/usb/core/urb.c                             |  2 +-
 drivers/usb/dwc3/dwc3-st.c                         |  2 +-
 drivers/usb/dwc3/gadget.c                          |  4 +-
 include/linux/filter.h                             |  2 +-
 kernel/cgroup/debug.c                              |  8 +--
 kernel/module.c                                    |  2 +-
 kernel/time/timer_list.c                           |  4 +-
 lib/vsprintf.c                                     |  8 +--
 mm/vmalloc.c                                       |  4 +-
 net/atm/proc.c                                     |  4 +-
 net/bluetooth/af_bluetooth.c                       |  2 +-
 net/can/bcm.c                                      |  6 +-
 net/can/proc.c                                     |  4 +-
 net/ipv4/ping.c                                    |  2 +-
 net/ipv4/raw.c                                     |  2 +-
 net/ipv4/tcp_ipv4.c                                |  6 +-
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/datagram.c                                |  2 +-
 net/ipv6/tcp_ipv6.c                                |  6 +-
 net/key/af_key.c                                   |  2 +-
 net/netlink/af_netlink.c                           |  2 +-
 net/packet/af_packet.c                             |  2 +-
 net/phonet/socket.c                                |  2 +-
 net/unix/af_unix.c                                 |  2 +-
 sound/soc/bcm/cygnus-pcm.c                         |  2 +-
 65 files changed, 240 insertions(+), 240 deletions(-)

diff --git a/arch/arm/mm/physaddr.c b/arch/arm/mm/physaddr.c
index cf75819e4c13..3147984ca70b 100644
--- a/arch/arm/mm/physaddr.c
+++ b/arch/arm/mm/physaddr.c
@@ -38,7 +38,7 @@ static inline bool __virt_addr_valid(unsigned long x)
 phys_addr_t __virt_to_phys(unsigned long x)
 {
 	WARN(!__virt_addr_valid(x),
-	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
+	     "virt_to_phys used for non-linear address: %p (%pS)\n",
 	     (void *)x, (void *)x);
 
 	return __virt_to_phys_nodebug(x);
diff --git a/arch/arm64/mm/physaddr.c b/arch/arm64/mm/physaddr.c
index 67a9ba9eaa96..355321333634 100644
--- a/arch/arm64/mm/physaddr.c
+++ b/arch/arm64/mm/physaddr.c
@@ -10,7 +10,7 @@
 phys_addr_t __virt_to_phys(unsigned long x)
 {
 	WARN(!__is_lm_address(x),
-	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
+	     "virt_to_phys used for non-linear address: %p (%pS)\n",
 	      (void *)x,
 	      (void *)x);
 
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index cbf4cc0b0b6c..0010e2af01c6 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -151,7 +151,7 @@ int __init do_relocations(void *kbase_old, void *kbase_new, long offset)
 
 		if (reloc_handlers_rel[type] == NULL) {
 			/* Unsupported relocation */
-			pr_err("Unhandled relocation type %d at 0x%pK\n",
+			pr_err("Unhandled relocation type %d at 0x%p\n",
 			       type, loc_orig);
 			return -ENOEXEC;
 		}
@@ -413,10 +413,10 @@ void show_kernel_relocation(const char *level)
 
 	if (IS_ENABLED(CONFIG_RELOCATABLE) && offset > 0) {
 		printk(level);
-		pr_cont("Kernel relocated by 0x%pK\n", (void *)offset);
-		pr_cont(" .text @ 0x%pK\n", _text);
-		pr_cont(" .data @ 0x%pK\n", _sdata);
-		pr_cont(" .bss  @ 0x%pK\n", __bss_start);
+		pr_cont("Kernel relocated by 0x%p\n", (void *)offset);
+		pr_cont(" .text @ 0x%p\n", _text);
+		pr_cont(" .data @ 0x%p\n", _sdata);
+		pr_cont(" .bss  @ 0x%p\n", __bss_start);
 	}
 }
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index d535edc01434..79735da62d55 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -334,7 +334,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	 * we allocate is out of range, just give up now.
 	 */
 	if (!cpu_has_ebase_wg && virt_to_phys(gebase) >= 0x20000000) {
-		kvm_err("CP0_EBase.WG required for guest exception base %pK\n",
+		kvm_err("CP0_EBase.WG required for guest exception base %p\n",
 			gebase);
 		err = -ENOMEM;
 		goto out_free_gebase;
diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 72238eedc360..522f02167f97 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -654,12 +654,12 @@ static ssize_t catalog_event_len_validate(struct hv_24x7_event_data *event,
 	ev_len = be16_to_cpu(event->length);
 
 	if (ev_len % 16)
-		pr_info("event %zu has length %zu not divisible by 16: event=%pK\n",
+		pr_info("event %zu has length %zu not divisible by 16: event=%p\n",
 				event_idx, ev_len, event);
 
 	ev_end = (__u8 *)event + ev_len;
 	if (ev_end > end) {
-		pr_warn("event %zu has .length=%zu, ends after buffer end: ev_end=%pK > end=%pK, offset=%zu\n",
+		pr_warn("event %zu has .length=%zu, ends after buffer end: ev_end=%p > end=%p, offset=%zu\n",
 				event_idx, ev_len, ev_end, end,
 				offset);
 		return -1;
@@ -667,14 +667,14 @@ static ssize_t catalog_event_len_validate(struct hv_24x7_event_data *event,
 
 	calc_ev_end = event_end(event, end);
 	if (!calc_ev_end) {
-		pr_warn("event %zu has a calculated length which exceeds buffer length %zu: event=%pK end=%pK, offset=%zu\n",
+		pr_warn("event %zu has a calculated length which exceeds buffer length %zu: event=%p end=%p, offset=%zu\n",
 			event_idx, event_data_bytes, event, end,
 			offset);
 		return -1;
 	}
 
 	if (calc_ev_end > ev_end) {
-		pr_warn("event %zu exceeds it's own length: event=%pK, end=%pK, offset=%zu, calc_ev_end=%pK\n",
+		pr_warn("event %zu exceeds it's own length: event=%p, end=%p, offset=%zu, calc_ev_end=%p\n",
 			event_idx, event, ev_end, offset, calc_ev_end);
 		return -1;
 	}
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 8fe034beb623..78c3c13db2a0 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -121,7 +121,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
-	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
+	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%p)", viwhy,
 		  current->pid, vcpu->kvm);
 
 	/* do not warn on invalid runtime instrumentation mode */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 98ad8b9e0360..d270eec5f71f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -696,7 +696,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
-		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
+		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
 			 (void *) kvm->arch.gmap->asce);
 		break;
 	}
@@ -1976,7 +1976,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	spin_lock_init(&kvm->arch.start_stop_lock);
 	kvm_s390_vsie_init(kvm);
-	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
+	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
 
 	return 0;
 out_err:
@@ -2048,7 +2048,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		vfree(kvm->arch.migration_state->pgste_bitmap);
 		kfree(kvm->arch.migration_state);
 	}
-	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
+	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
@@ -2161,7 +2161,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 
 	free_page((unsigned long)old_sca);
 
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
+	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
 	return 0;
 }
@@ -2508,7 +2508,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
 		goto out_free_sie_block;
-	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
+	VM_EVENT(kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p", id, vcpu,
 		 vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 6f0209d45164..9c5f546a2e1a 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -56,7 +56,7 @@ TRACE_EVENT(kvm_s390_create_vcpu,
 		    __entry->sie_block = sie_block;
 		    ),
 
-	    TP_printk("create cpu %d at 0x%pK, sie block at 0x%pK",
+	    TP_printk("create cpu %d at 0x%p, sie block at 0x%p",
 		      __entry->id, __entry->vcpu, __entry->sie_block)
 	);
 
@@ -255,7 +255,7 @@ TRACE_EVENT(kvm_s390_enable_css,
 		    __entry->kvm = kvm;
 		    ),
 
-	    TP_printk("enabling channel I/O support (kvm @ %pK)\n",
+	    TP_printk("enabling channel I/O support (kvm @ %p)\n",
 		      __entry->kvm)
 	);
 
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index a73596a4f804..53516ba3d9d0 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5068,7 +5068,7 @@ static void print_binder_ref_olocked(struct seq_file *m,
 				     struct binder_ref *ref)
 {
 	binder_node_lock(ref->node);
-	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %pK\n",
+	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
 		   ref->data.debug_id, ref->data.desc,
 		   ref->node->proc ? "" : "dead ",
 		   ref->node->debug_id, ref->data.strong,
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 6f6f745605af..9fdc768629b0 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -84,7 +84,7 @@ static void binder_insert_free_buffer(struct binder_alloc *alloc,
 	new_buffer_size = binder_alloc_buffer_size(alloc, new_buffer);
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %pK\n",
+		     "%d: add free buffer, size %zd, at %p\n",
 		      alloc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -196,7 +196,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 	bool need_mm = false;
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: %s pages %pK-%pK\n", alloc->pid,
+		     "%d: %s pages %p-%p\n", alloc->pid,
 		     allocate ? "allocate" : "free", start, end);
 
 	if (end <= start)
@@ -255,7 +255,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 					    __GFP_HIGHMEM |
 					    __GFP_ZERO);
 		if (!page->page_ptr) {
-			pr_err("%d: binder_alloc_buf failed for page at %pK\n",
+			pr_err("%d: binder_alloc_buf failed for page at %p\n",
 				alloc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -268,7 +268,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		flush_cache_vmap((unsigned long)page_addr,
 				(unsigned long)page_addr + PAGE_SIZE);
 		if (ret != 1) {
-			pr_err("%d: binder_alloc_buf failed to map page at %pK in kernel\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
 			       alloc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -426,7 +426,7 @@ struct binder_buffer *binder_alloc_new_buf_locked(struct binder_alloc *alloc,
 	}
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
 		      alloc->pid, size, buffer, buffer_size);
 
 	has_page_addr =
@@ -461,7 +461,7 @@ struct binder_buffer *binder_alloc_new_buf_locked(struct binder_alloc *alloc,
 	buffer->free_in_progress = 0;
 	binder_insert_allocated_buffer_locked(alloc, buffer);
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got %pK\n",
+		     "%d: binder_alloc_buf size %zd got %p\n",
 		      alloc->pid, size, buffer);
 	buffer->data_size = data_size;
 	buffer->offsets_size = offsets_size;
@@ -533,7 +533,7 @@ static void binder_delete_free_buffer(struct binder_alloc *alloc,
 	if (prev_buffer_end_page(prev) == buffer_start_page(buffer)) {
 		to_free = false;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				   "%d: merge free, buffer %pK share page with %pK\n",
+				   "%d: merge free, buffer %p share page with %p\n",
 				   alloc->pid, buffer->data, prev->data);
 	}
 
@@ -542,7 +542,7 @@ static void binder_delete_free_buffer(struct binder_alloc *alloc,
 		if (buffer_start_page(next) == buffer_start_page(buffer)) {
 			to_free = false;
 			binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-					   "%d: merge free, buffer %pK share page with %pK\n",
+					   "%d: merge free, buffer %p share page with %p\n",
 					   alloc->pid,
 					   buffer->data,
 					   next->data);
@@ -551,14 +551,14 @@ static void binder_delete_free_buffer(struct binder_alloc *alloc,
 
 	if (PAGE_ALIGNED(buffer->data)) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				   "%d: merge free, buffer start %pK is page aligned\n",
+				   "%d: merge free, buffer start %p is page aligned\n",
 				   alloc->pid, buffer->data);
 		to_free = false;
 	}
 
 	if (to_free) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				   "%d: merge free, buffer %pK do not share page with %pK or %pK\n",
+				   "%d: merge free, buffer %p do not share page with %p or %p\n",
 				   alloc->pid, buffer->data,
 				   prev->data, next ? next->data : NULL);
 		binder_update_page_range(alloc, 0, buffer_start_page(buffer),
@@ -580,7 +580,7 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
 		ALIGN(buffer->extra_buffers_size, sizeof(void *));
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
 		      alloc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
@@ -681,7 +681,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR(
 				(vma->vm_start ^ (uint32_t)alloc->buffer))) {
-			pr_info("%s: %d %lx-%lx maps %pK bad alignment\n",
+			pr_info("%s: %d %lx-%lx maps %p bad alignment\n",
 				__func__, alloc->pid, vma->vm_start,
 				vma->vm_end, alloc->buffer);
 			vma->vm_start += PAGE_SIZE;
@@ -778,7 +778,7 @@ void binder_alloc_deferred_release(struct binder_alloc *alloc)
 					      &alloc->pages[i].lru);
 			page_addr = alloc->buffer + i * PAGE_SIZE;
 			binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%s: %d: page %d at %pK %s\n",
+				     "%s: %d: page %d at %p %s\n",
 				     __func__, alloc->pid, i, page_addr,
 				     on_lru ? "on lru" : "active");
 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
@@ -800,7 +800,7 @@ void binder_alloc_deferred_release(struct binder_alloc *alloc)
 static void print_binder_buffer(struct seq_file *m, const char *prefix,
 				struct binder_buffer *buffer)
 {
-	seq_printf(m, "%s %d: %pK size %zd:%zd:%zd %s\n",
+	seq_printf(m, "%s %d: %p size %zd:%zd:%zd %s\n",
 		   prefix, buffer->debug_id, buffer->data,
 		   buffer->data_size, buffer->offsets_size,
 		   buffer->extra_buffers_size,
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 7904ffa9abfb..b110fc509c50 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -965,7 +965,7 @@ static void exynos_dsi_send_to_fifo(struct exynos_dsi *dsi,
 	bool first = !xfer->tx_done;
 	u32 reg;
 
-	dev_dbg(dev, "< xfer %pK: tx len %u, done %u, rx len %u, done %u\n",
+	dev_dbg(dev, "< xfer %p: tx len %u, done %u, rx len %u, done %u\n",
 		xfer, length, xfer->tx_done, xfer->rx_len, xfer->rx_done);
 
 	if (length > DSI_TX_FIFO_SIZE)
@@ -1163,7 +1163,7 @@ static bool exynos_dsi_transfer_finish(struct exynos_dsi *dsi)
 	spin_unlock_irqrestore(&dsi->transfer_lock, flags);
 
 	dev_dbg(dsi->dev,
-		"> xfer %pK, tx_len %zu, tx_done %u, rx_len %u, rx_done %u\n",
+		"> xfer %p, tx_len %zu, tx_done %u, rx_len %u, rx_done %u\n",
 		xfer, xfer->packet.payload_length, xfer->tx_done, xfer->rx_len,
 		xfer->rx_done);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 5b18b5c5fdf2..95871577015d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1695,7 +1695,7 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_put_clk;
 	}
 
-	DRM_DEBUG_KMS("id[%d]ippdrv[%pK]\n", ctx->id, ippdrv);
+	DRM_DEBUG_KMS("id[%d]ippdrv[%p]\n", ctx->id, ippdrv);
 
 	spin_lock_init(&ctx->lock);
 	platform_set_drvdata(pdev, ctx);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index 077de014d610..cf884612b81c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -219,7 +219,7 @@ static struct exynos_drm_gem *exynos_drm_gem_init(struct drm_device *dev,
 		return ERR_PTR(ret);
 	}
 
-	DRM_DEBUG_KMS("created file object = %pK\n", obj->filp);
+	DRM_DEBUG_KMS("created file object = %p\n", obj->filp);
 
 	return exynos_gem;
 }
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 0506b2b17ac1..bef57987759d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1723,7 +1723,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	DRM_DEBUG_KMS("id[%d]ippdrv[%pK]\n", ctx->id, ippdrv);
+	DRM_DEBUG_KMS("id[%d]ippdrv[%p]\n", ctx->id, ippdrv);
 
 	mutex_init(&ctx->lock);
 	platform_set_drvdata(pdev, ctx);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 3edda18cc2d2..9c84ee76f18a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -208,7 +208,7 @@ static struct exynos_drm_ippdrv *ipp_find_drv_by_handle(u32 prop_id)
 	 * e.g PAUSE state, queue buf, command control.
 	 */
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
-		DRM_DEBUG_KMS("count[%d]ippdrv[%pK]\n", count++, ippdrv);
+		DRM_DEBUG_KMS("count[%d]ippdrv[%p]\n", count++, ippdrv);
 
 		mutex_lock(&ippdrv->cmd_lock);
 		list_for_each_entry(c_node, &ippdrv->cmd_list, list) {
@@ -388,7 +388,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 	}
 	property->prop_id = ret;
 
-	DRM_DEBUG_KMS("created prop_id[%d]cmd[%d]ippdrv[%pK]\n",
+	DRM_DEBUG_KMS("created prop_id[%d]cmd[%d]ippdrv[%p]\n",
 		property->prop_id, property->cmd, ippdrv);
 
 	/* stored property information and ippdrv in private data */
@@ -518,7 +518,7 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
 {
 	int i;
 
-	DRM_DEBUG_KMS("node[%pK]\n", m_node);
+	DRM_DEBUG_KMS("node[%p]\n", m_node);
 
 	if (!m_node) {
 		DRM_ERROR("invalid dequeue node.\n");
@@ -562,7 +562,7 @@ static struct drm_exynos_ipp_mem_node
 	m_node->buf_id = qbuf->buf_id;
 	INIT_LIST_HEAD(&m_node->list);
 
-	DRM_DEBUG_KMS("m_node[%pK]ops_id[%d]\n", m_node, qbuf->ops_id);
+	DRM_DEBUG_KMS("m_node[%p]ops_id[%d]\n", m_node, qbuf->ops_id);
 	DRM_DEBUG_KMS("prop_id[%d]buf_id[%d]\n", qbuf->prop_id, m_node->buf_id);
 
 	for_each_ipp_planar(i) {
@@ -659,7 +659,7 @@ static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
 
 	mutex_lock(&c_node->event_lock);
 	list_for_each_entry_safe(e, te, &c_node->event_list, base.link) {
-		DRM_DEBUG_KMS("count[%d]e[%pK]\n", count++, e);
+		DRM_DEBUG_KMS("count[%d]e[%p]\n", count++, e);
 
 		/*
 		 * qbuf == NULL condition means all event deletion.
@@ -750,7 +750,7 @@ static struct drm_exynos_ipp_mem_node
 
 	/* find memory node from memory list */
 	list_for_each_entry(m_node, head, list) {
-		DRM_DEBUG_KMS("count[%d]m_node[%pK]\n", count++, m_node);
+		DRM_DEBUG_KMS("count[%d]m_node[%p]\n", count++, m_node);
 
 		/* compare buffer id */
 		if (m_node->buf_id == qbuf->buf_id)
@@ -767,7 +767,7 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 	struct exynos_drm_ipp_ops *ops = NULL;
 	int ret = 0;
 
-	DRM_DEBUG_KMS("node[%pK]\n", m_node);
+	DRM_DEBUG_KMS("node[%p]\n", m_node);
 
 	if (!m_node) {
 		DRM_ERROR("invalid queue node.\n");
@@ -1232,7 +1232,7 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 			m_node = list_first_entry(head,
 				struct drm_exynos_ipp_mem_node, list);
 
-			DRM_DEBUG_KMS("m_node[%pK]\n", m_node);
+			DRM_DEBUG_KMS("m_node[%p]\n", m_node);
 
 			ret = ipp_set_mem_node(ippdrv, c_node, m_node);
 			if (ret) {
@@ -1601,7 +1601,7 @@ static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
 		}
 		ippdrv->prop_list.ipp_id = ret;
 
-		DRM_DEBUG_KMS("count[%d]ippdrv[%pK]ipp_id[%d]\n",
+		DRM_DEBUG_KMS("count[%d]ippdrv[%p]ipp_id[%d]\n",
 			count++, ippdrv, ret);
 
 		/* store parent device for node */
@@ -1659,7 +1659,7 @@ static int ipp_subdrv_open(struct drm_device *drm_dev, struct device *dev,
 
 	file_priv->ipp_dev = dev;
 
-	DRM_DEBUG_KMS("done priv[%pK]\n", dev);
+	DRM_DEBUG_KMS("done priv[%p]\n", dev);
 
 	return 0;
 }
@@ -1676,7 +1676,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		mutex_lock(&ippdrv->cmd_lock);
 		list_for_each_entry_safe(c_node, tc_node,
 			&ippdrv->cmd_list, list) {
-			DRM_DEBUG_KMS("count[%d]ippdrv[%pK]\n",
+			DRM_DEBUG_KMS("count[%d]ippdrv[%p]\n",
 				count++, ippdrv);
 
 			if (c_node->filp == file) {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index 79282a820ecc..6591e406084c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -748,7 +748,7 @@ static int rotator_probe(struct platform_device *pdev)
 		goto err_ippdrv_register;
 	}
 
-	DRM_DEBUG_KMS("ippdrv[%pK]\n", ippdrv);
+	DRM_DEBUG_KMS("ippdrv[%p]\n", ippdrv);
 
 	platform_set_drvdata(pdev, rot);
 
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index c65e381b85f3..b56af47e57e0 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -160,7 +160,7 @@ describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 
 	lockdep_assert_held(&obj->base.dev->struct_mutex);
 
-	seq_printf(m, "%pK: %c%c%c%c%c %8zdKiB %02x %02x %s%s%s",
+	seq_printf(m, "%p: %c%c%c%c%c %8zdKiB %02x %02x %s%s%s",
 		   &obj->base,
 		   get_active_flag(obj),
 		   get_pin_flag(obj),
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 4381c0a9a873..9f45ccf63c80 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -70,7 +70,7 @@ static int usnic_uiom_dma_fault(struct iommu_domain *domain,
 				unsigned long iova, int flags,
 				void *token)
 {
-	usnic_err("Device %s iommu fault domain 0x%pK va 0x%lx flags 0x%x\n",
+	usnic_err("Device %s iommu fault domain 0x%p va 0x%lx flags 0x%x\n",
 		dev_name(dev),
 		domain, iova, flags);
 	return -ENOSYS;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index ff6815e95684..f259af5f9e9c 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -523,7 +523,7 @@ static int ath10k_ahb_resource_init(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "irq: %d\n", ar_ahb->irq);
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "mem: 0x%pK mem_len: %lu gcc mem: 0x%pK tcsr_mem: 0x%pK\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "mem: 0x%p mem_len: %lu gcc mem: 0x%p tcsr_mem: 0x%p\n",
 		   ar_ahb->mem, ar_ahb->mem_len,
 		   ar_ahb->gcc_mem, ar_ahb->tcsr_mem);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 2d3a2f31123d..a699ed3a1689 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -364,7 +364,7 @@ int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length)
 	u32 txlen;
 	int ret;
 
-	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz data buffer 0x%pK length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz data buffer 0x%p length %d\n",
 		   buffer, length);
 
 	if (ar->bmi.done_sent) {
@@ -430,7 +430,7 @@ int ath10k_bmi_fast_download(struct ath10k *ar,
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BMI,
-		   "bmi fast download address 0x%x buffer 0x%pK length %d\n",
+		   "bmi fast download address 0x%x buffer 0x%p length %d\n",
 		   address, buffer, length);
 
 	ret = ath10k_bmi_lz_stream_start(ar, address);
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index a8afd690290f..44a6eba7f707 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -917,7 +917,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot init ce src ring id %d entries %d base_addr %pK\n",
+		   "boot init ce src ring id %d entries %d base_addr %p\n",
 		   ce_id, nentries, src_ring->base_addr_owner_space);
 
 	return 0;
@@ -951,7 +951,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot ce dest ring id %d entries %d base_addr %pK\n",
+		   "boot ce dest ring id %d entries %d base_addr %p\n",
 		   ce_id, nentries, dest_ring->base_addr_owner_space);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b29fdbd21ead..272c5701d166 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -878,7 +878,7 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	if (!ar->running_fw->fw_file.otp_data ||
 	    !ar->running_fw->fw_file.otp_len) {
-		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %pK otp_len %zd)!\n",
+		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
 			    ar->running_fw->fw_file.otp_data,
 			    ar->running_fw->fw_file.otp_len);
 		return 0;
@@ -937,7 +937,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot uploading firmware image %pK len %d\n",
+		   "boot uploading firmware image %p len %d\n",
 		   data, data_len);
 
 	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index e5c80f582ff5..2a458f312163 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -44,7 +44,7 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 	skb_cb = ATH10K_SKB_CB(skb);
 	memset(skb_cb, 0, sizeof(*skb_cb));
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: skb %pK\n", __func__, skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: skb %p\n", __func__, skb);
 	return skb;
 }
 
@@ -62,7 +62,7 @@ void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 {
 	struct ath10k *ar = ep->htc->ar;
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %pK\n", __func__,
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %p\n", __func__,
 		   ep->eid, skb);
 
 	ath10k_htc_restore_tx_skb(ep->htc, skb);
@@ -464,7 +464,7 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		/* zero length packet with trailer data, just drop these */
 		goto out;
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %pK\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %p\n",
 		   eid, skb);
 	ep->ep_ops.ep_rx_complete(ar, skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7d295ee71534..40bf5f7e41b4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -986,7 +986,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	*status = *rx_status;
 
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
-		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
 		   ieee80211_get_SA(hdr),
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a947eef348d..ee3097e4c10e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -841,7 +841,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 		 */
 		for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
 			if (ar->peer_map[i] == peer) {
-				ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %pK idx %d)\n",
+				ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %p idx %d)\n",
 					    peer->addr, peer, i);
 				ar->peer_map[i] = NULL;
 			}
@@ -3655,7 +3655,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %pK\n",
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
 				   skb);
 
 			skb_queue_tail(&ar->offchan_tx_queue, skb);
@@ -3718,7 +3718,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %p\n",
 			   skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -3775,7 +3775,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
 		if (time_left == 0)
-			ath10k_warn(ar, "timed out waiting for offchannel skb %pK\n",
+			ath10k_warn(ar, "timed out waiting for offchannel skb %p\n",
 				    skb);
 
 		if (!peer && tmp_peer_created) {
@@ -6198,7 +6198,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		 * Existing station deletion.
 		 */
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac vdev %d peer delete %pM sta %pK (sta gone)\n",
+			   "mac vdev %d peer delete %pM sta %p (sta gone)\n",
 			   arvif->vdev_id, sta->addr, sta);
 
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
@@ -6215,7 +6215,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				continue;
 
 			if (peer->sta == sta) {
-				ath10k_warn(ar, "found sta peer %pM (ptr %pK id %d) entry on vdev %i after it was supposedly removed\n",
+				ath10k_warn(ar, "found sta peer %pM (ptr %p id %d) entry on vdev %i after it was supposedly removed\n",
 					    sta->addr, peer, i, arvif->vdev_id);
 				peer->sta = NULL;
 
@@ -7346,7 +7346,7 @@ ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx add freq %hu width %d ptr %pK\n",
+		   "mac chanctx add freq %hu width %d ptr %p\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -7370,7 +7370,7 @@ ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx remove freq %hu width %d ptr %pK\n",
+		   "mac chanctx remove freq %hu width %d ptr %p\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -7435,7 +7435,7 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx change freq %hu width %d ptr %pK changed %x\n",
+		   "mac chanctx change freq %hu width %d ptr %p changed %x\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx, changed);
 
 	/* This shouldn't really happen because channel switching should use
@@ -7493,7 +7493,7 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx assign ptr %pK vdev_id %i\n",
+		   "mac chanctx assign ptr %p vdev_id %i\n",
 		   ctx, arvif->vdev_id);
 
 	if (WARN_ON(arvif->is_started)) {
@@ -7561,7 +7561,7 @@ ath10k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx unassign ptr %pK vdev_id %i\n",
+		   "mac chanctx unassign ptr %p vdev_id %i\n",
 		   ctx, arvif->vdev_id);
 
 	WARN_ON(!arvif->is_started);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ffea348b2190..dcb38a6612ef 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3113,7 +3113,7 @@ static int ath10k_pci_claim(struct ath10k *ar)
 		goto err_master;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot pci_mem 0x%pK\n", ar_pci->mem);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
 	return 0;
 
 err_master:
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 9d3eb258ac2f..8409984ce277 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -46,7 +46,7 @@ bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb)
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-		   "testmode event wmi cmd_id %d skb %pK skb->len %d\n",
+		   "testmode event wmi cmd_id %d skb %p skb->len %d\n",
 		   cmd_id, skb, skb->len);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", skb->data, skb->len);
@@ -393,7 +393,7 @@ static int ath10k_tm_cmd_wmi(struct ath10k *ar, struct nlattr *tb[])
 	cmd_id = nla_get_u32(tb[ATH10K_TM_ATTR_WMI_CMDID]);
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-		   "testmode cmd wmi cmd_id %d buf %pK buf_len %d\n",
+		   "testmode cmd wmi cmd_id %d buf %p buf_len %d\n",
 		   cmd_id, buf, buf_len);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", buf, buf_len);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index d4986f626c35..1f8098af2110 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -45,7 +45,7 @@ static void ath10k_report_offchan_tx(struct ath10k *ar, struct sk_buff *skb)
 	complete(&ar->offchan_tx_completed);
 	ar->offchan_tx_skb = NULL; /* just for sanity */
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "completed offchannel skb %pK\n", skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "completed offchannel skb %p\n", skb);
 out:
 	spin_unlock_bh(&ar->data_lock);
 }
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index d4803ff5a78a..d61b236824e3 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -134,7 +134,7 @@ static void ath10k_usb_recv_complete(struct urb *urb)
 	int status = 0;
 
 	ath10k_dbg(ar, ATH10K_DBG_USB_BULK,
-		   "usb recv pipe %d stat %d len %d urb 0x%pK\n",
+		   "usb recv pipe %d stat %d len %d urb 0x%p\n",
 		   pipe->logical_pipe_num, urb->status, urb->actual_length,
 		   urb);
 
@@ -233,7 +233,7 @@ static void ath10k_usb_post_recv_transfers(struct ath10k *ar,
 				  ath10k_usb_recv_complete, urb_context);
 
 		ath10k_dbg(ar, ATH10K_DBG_USB_BULK,
-			   "usb bulk recv submit %d 0x%x ep 0x%2.2x len %d buf 0x%pK\n",
+			   "usb bulk recv submit %d 0x%x ep 0x%2.2x len %d buf 0x%p\n",
 			   recv_pipe->logical_pipe_num,
 			   recv_pipe->usb_pipe_handle, recv_pipe->ep_address,
 			   ATH10K_USB_RX_BUFFER_SIZE, urb_context->skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cad2e42dcef6..73963e599f61 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1907,7 +1907,7 @@ ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 	ether_addr_copy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr));
 	memcpy(cmd->buf, msdu->data, msdu->len);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %pK len %d ftype %02x stype %02x\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   msdu, skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
 	trace_ath10k_tx_hdr(ar, skb->data, skb->len);
@@ -2399,7 +2399,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_mac_handle_beacon(ar, skb);
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
-		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
+		   "event mgmt rx skb %p len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
 		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE);
 
diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index bed7403bb6b3..5f9e576951d6 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -412,7 +412,7 @@ static void spi_test_dump_message(struct spi_device *spi,
 	int i;
 	u8 b;
 
-	dev_info(&spi->dev, "  spi_msg@%pK\n", msg);
+	dev_info(&spi->dev, "  spi_msg@%p\n", msg);
 	if (msg->status)
 		dev_info(&spi->dev, "    status:        %i\n",
 			 msg->status);
@@ -422,15 +422,15 @@ static void spi_test_dump_message(struct spi_device *spi,
 		 msg->actual_length);
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		dev_info(&spi->dev, "    spi_transfer@%pK\n", xfer);
+		dev_info(&spi->dev, "    spi_transfer@%p\n", xfer);
 		dev_info(&spi->dev, "      len:    %i\n", xfer->len);
-		dev_info(&spi->dev, "      tx_buf: %pK\n", xfer->tx_buf);
+		dev_info(&spi->dev, "      tx_buf: %p\n", xfer->tx_buf);
 		if (dump_data && xfer->tx_buf)
 			spi_test_print_hex_dump("          TX: ",
 						xfer->tx_buf,
 						xfer->len);
 
-		dev_info(&spi->dev, "      rx_buf: %pK\n", xfer->rx_buf);
+		dev_info(&spi->dev, "      rx_buf: %p\n", xfer->rx_buf);
 		if (dump_data && xfer->rx_buf)
 			spi_test_print_hex_dump("          RX: ",
 						xfer->rx_buf,
@@ -523,7 +523,7 @@ static int spi_check_rx_ranges(struct spi_device *spi,
 		/* if still not found then something has modified too much */
 		/* we could list the "closest" transfer here... */
 		dev_err(&spi->dev,
-			"loopback strangeness - rx changed outside of allowed range at: %pK\n",
+			"loopback strangeness - rx changed outside of allowed range at: %p\n",
 			addr);
 		/* do not return, only set ret,
 		 * so that we list all addresses
@@ -661,7 +661,7 @@ static int spi_test_translate(struct spi_device *spi,
 	}
 
 	dev_err(&spi->dev,
-		"PointerRange [%pK:%pK[ not in range [%pK:%pK[ or [%pK:%pK[\n",
+		"PointerRange [%p:%p[ not in range [%p:%p[ or [%p:%p[\n",
 		*ptr, *ptr + len,
 		RX(0), RX(SPI_TEST_MAX_SIZE),
 		TX(0), TX(SPI_TEST_MAX_SIZE));
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 1f8a225530a8..02325ae15e98 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -252,7 +252,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	/* Set MLLI size for the bypass operation */
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
-	dev_dbg(dev, "MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+	dev_dbg(dev, "MLLI params: virt_addr=%p dma_addr=%pad mlli_len=0x%X\n",
 		mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
 		mlli_params->mlli_len);
 
@@ -293,7 +293,7 @@ static inline void ssi_buffer_mgr_add_scatterlist_entry(
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
-	dev_dbg(dev, "index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
+	dev_dbg(dev, "index=%u nents=%u sgl=%p data_len=0x%08X is_last=%d\n",
 		index, nents, sgl, data_len, is_last_table);
 	sgl_data->nents[index] = nents;
 	sgl_data->entry[index].sgl = sgl;
@@ -350,7 +350,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 			dev_err(dev, "dma_map_sg() single buffer failed\n");
 			return -ENOMEM;
 		}
-		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%p offset=%u length=%u\n",
 			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
 			sg->offset, sg->length);
 		*lbytes = nbytes;
@@ -409,7 +409,7 @@ ssi_aead_handle_config_buf(struct device *dev,
 		dev_err(dev, "dma_map_sg() config buffer failed\n");
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%p offset=%u length=%u\n",
 		&sg_dma_address(&areq_ctx->ccm_adata_sg),
 		sg_page(&areq_ctx->ccm_adata_sg),
 		sg_virt(&areq_ctx->ccm_adata_sg),
@@ -438,7 +438,7 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 		dev_err(dev, "dma_map_sg() src buffer failed\n");
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%p offset=%u length=%u\n",
 		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
 		sg_virt(areq_ctx->buff_sg), areq_ctx->buff_sg->offset,
 		areq_ctx->buff_sg->length);
@@ -476,11 +476,11 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 	}
 
 	dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
-	dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
+	dev_dbg(dev, "Unmapped req->src=%p\n", sg_virt(src));
 
 	if (src != dst) {
 		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped req->dst=%pK\n", sg_virt(dst));
+		dev_dbg(dev, "Unmapped req->dst=%p\n", sg_virt(dst));
 	}
 }
 
@@ -516,11 +516,11 @@ int ssi_buffer_mgr_map_blkcipher_request(
 				       DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev,
 					       req_ctx->gen_ctx.iv_dma_addr))) {
-			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping iv %u B at va=%p for DMA failed\n",
 				ivsize, info);
 			return -ENOMEM;
 		}
-		dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped iv %u B at va=%p to dma=%pad\n",
 			ivsize, info, &req_ctx->gen_ctx.iv_dma_addr);
 	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
@@ -650,7 +650,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	 *allocated and should be released
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%p\n",
 			&areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
@@ -658,7 +658,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
+	dev_dbg(dev, "Unmapping src sgl: req->src=%p areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		req->assoclen, req->cryptlen);
 	size_to_unmap = req->assoclen + req->cryptlen;
@@ -672,7 +672,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 						  &dummy, &chained),
 		     DMA_BIDIRECTIONAL);
 	if (unlikely(req->src != req->dst)) {
-		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
+		dev_dbg(dev, "Unmapping dst sgl: req->dst=%p\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
 			     ssi_buffer_mgr_get_sgl_nents(dev, req->dst,
@@ -767,13 +767,13 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv, hw_iv_size,
 						       DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
-		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping iv %u B at va=%p for DMA failed\n",
 			hw_iv_size, req->iv);
 		rc = -ENOMEM;
 		goto chain_iv_exit;
 	}
 
-	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped iv %u B at va=%p to dma=%pad\n",
 		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
 	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -1319,7 +1319,7 @@ int ssi_buffer_mgr_map_aead_request(
 						    MAX_MAC_SIZE,
 						    DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
-		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping mac_buf %u B at va=%p for DMA failed\n",
 			MAX_MAC_SIZE, areq_ctx->mac_buf);
 		rc = -ENOMEM;
 		goto aead_map_failure;
@@ -1332,7 +1332,7 @@ int ssi_buffer_mgr_map_aead_request(
 							    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
-			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping mac_buf %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE,
 				(areq_ctx->ccm_config +
 				 CCM_CTR_COUNT_0_OFFSET));
@@ -1355,7 +1355,7 @@ int ssi_buffer_mgr_map_aead_request(
 							 AES_BLOCK_SIZE,
 							 DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
-			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping hkey %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1366,7 +1366,7 @@ int ssi_buffer_mgr_map_aead_request(
 								  AES_BLOCK_SIZE,
 								  DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
-			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_len_block %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1378,7 +1378,7 @@ int ssi_buffer_mgr_map_aead_request(
 								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
-			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
 			rc = -ENOMEM;
@@ -1391,7 +1391,7 @@ int ssi_buffer_mgr_map_aead_request(
 								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
-			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
 			rc = -ENOMEM;
@@ -1499,7 +1499,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	dev_dbg(dev, "final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
+	dev_dbg(dev, "final params : curr_buff=%p curr_buff_cnt=0x%X nbytes = 0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
@@ -1593,7 +1593,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
+	dev_dbg(dev, " update params : curr_buff=%p curr_buff_cnt=0x%X nbytes=0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
@@ -1603,7 +1603,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 	areq_ctx->in_nents = 0;
 
 	if (unlikely(total_in_len < block_size)) {
-		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
+		dev_dbg(dev, " less than one block: curr_buff=%p *curr_buff_cnt=0x%X copy_to=%p\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
 			ssi_buffer_mgr_get_sgl_nents(dev, src, nbytes, &dummy,
@@ -1624,7 +1624,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 
 	/* Copy the new residue to next buffer */
 	if (*next_buff_cnt != 0) {
-		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
+		dev_dbg(dev, " handle residue: next buff %p skip data %u residue %u\n",
 			next_buff, (update_data_len - *curr_buff_cnt),
 			*next_buff_cnt);
 		ssi_buffer_mgr_copy_scatterlist_portion(dev, next_buff, src,
@@ -1706,7 +1706,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	 *allocated and should be released
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%p\n",
 			&areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
@@ -1715,14 +1715,14 @@ void ssi_buffer_mgr_unmap_hash_request(
 	}
 
 	if ((src) && likely(areq_ctx->in_nents != 0)) {
-		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
+		dev_dbg(dev, "Unmapped sg src: virt=%p dma=%pad len=0x%X\n",
 			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
 	}
 
 	if (*prev_len != 0) {
-		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
+		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%p dma=%pad len 0x%X\n",
 			sg_virt(areq_ctx->buff_sg),
 			&sg_dma_address(areq_ctx->buff_sg),
 			sg_dma_len(areq_ctx->buff_sg));
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index ee85cbf7c9ae..9589f5c5c6c6 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -205,11 +205,11 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 						  max_key_buf_size,
 						  DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
-		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping Key %u B at va=%p for DMA failed\n",
 			max_key_buf_size, ctx_p->user.key);
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped key %u B at va=%p to dma=%pad\n",
 		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index d79090ed7f9c..e1f6fe2a4640 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -138,7 +138,7 @@ static int ssi_hash_map_result(struct device *dev,
 			digestsize);
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest result buffer %u B at va=%p to dma=%pad\n",
 		digestsize, state->digest_result_buff,
 		&state->digest_result_dma_addr);
 
@@ -194,11 +194,11 @@ static int ssi_hash_map_request(struct device *dev,
 
 	state->digest_buff_dma_addr = dma_map_single(dev, (void *)state->digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping digest len %d B at va=%p for DMA failed\n",
 			ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
-	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest %d B at va=%p to dma=%pad\n",
 		ctx->inter_digestsize, state->digest_buff,
 		&state->digest_buff_dma_addr);
 
@@ -243,11 +243,11 @@ static int ssi_hash_map_request(struct device *dev,
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
 		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
-			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping digest len %u B at va=%p for DMA failed\n",
 				HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
-		dev_dbg(dev, "Mapped digest len %u B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped digest len %u B at va=%p to dma=%pad\n",
 			HASH_LEN_SIZE, state->digest_bytes_len,
 			&state->digest_bytes_len_dma_addr);
 	} else {
@@ -257,12 +257,12 @@ static int ssi_hash_map_request(struct device *dev,
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
 		state->opad_digest_dma_addr = dma_map_single(dev, (void *)state->opad_digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
-			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping opad digest %d B at va=%p for DMA failed\n",
 				ctx->inter_digestsize,
 				state->opad_digest_buff);
 			goto fail5;
 		}
-		dev_dbg(dev, "Mapped opad digest %d B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped opad digest %d B at va=%p to dma=%pad\n",
 			ctx->inter_digestsize, state->opad_digest_buff,
 			&state->opad_digest_dma_addr);
 	} else {
@@ -347,7 +347,7 @@ static void ssi_hash_unmap_result(struct device *dev,
 				 state->digest_result_dma_addr,
 				 digestsize,
 				  DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
+		dev_dbg(dev, "unmpa digest result buffer va (%p) pa (%pad) len %u\n",
 			state->digest_result_buff,
 			&state->digest_result_dma_addr, digestsize);
 		memcpy(result,
@@ -362,7 +362,7 @@ static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __i
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
 	req->base.complete(&req->base, 0);
@@ -376,7 +376,7 @@ static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __i
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
 	ssi_hash_unmap_result(dev, state, digestsize, req->result);
@@ -392,7 +392,7 @@ static void ssi_hash_complete(struct device *dev, void *ssi_req, void __iomem *c
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
 	ssi_hash_unmap_result(dev, state, digestsize, req->result);
@@ -1296,22 +1296,22 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 
 	ctx->digest_buff_dma_addr = dma_map_single(dev, (void *)ctx->digest_buff, sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %zu B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping digest len %zu B at va=%p for DMA failed\n",
 			sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
-	dev_dbg(dev, "Mapped digest %zu B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest %zu B at va=%p to dma=%pad\n",
 		sizeof(ctx->digest_buff), ctx->digest_buff,
 		&ctx->digest_buff_dma_addr);
 
 	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
-		dev_err(dev, "Mapping opad digest %zu B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping opad digest %zu B at va=%p for DMA failed\n",
 			sizeof(ctx->opad_tmp_keys_buff),
 			ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
-	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%p to dma=%pad\n",
 		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
 		&ctx->opad_tmp_keys_dma_addr);
 
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
index 315b49c1de3b..45dcef6a6e92 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -191,7 +191,7 @@ int vchiq_platform_init(struct platform_device *pdev, VCHIQ_STATE_T *state)
 
 	g_dev = dev;
 	vchiq_log_info(vchiq_arm_log_level,
-		"vchiq_init - done (slots %pK, phys %pad)",
+		"vchiq_init - done (slots %p, phys %pad)",
 		vchiq_slot_zero, &slot_phys);
 
 	vchiq_call_connected_callbacks();
@@ -423,7 +423,7 @@ create_pagelist(char __user *buf, size_t count, unsigned short type)
 				       &dma_addr,
 				       GFP_KERNEL);
 
-	vchiq_log_trace(vchiq_arm_log_level, "%s - %pK", __func__, pagelist);
+	vchiq_log_trace(vchiq_arm_log_level, "%s - %p", __func__, pagelist);
 
 	if (!pagelist)
 		return NULL;
@@ -582,7 +582,7 @@ free_pagelist(struct vchiq_pagelist_info *pagelistinfo,
 	struct page **pages    = pagelistinfo->pages;
 	unsigned int num_pages = pagelistinfo->num_pages;
 
-	vchiq_log_trace(vchiq_arm_log_level, "free_pagelist - %pK, %d",
+	vchiq_log_trace(vchiq_arm_log_level, "free_pagelist - %p, %d",
 			pagelistinfo->pagelist, actual);
 
 	/*
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 411539f8ff8c..cefcbb2d728f 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -523,7 +523,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	DEBUG_INITIALISE(g_state.local)
 
 	vchiq_log_trace(vchiq_arm_log_level,
-		"vchiq_ioctl - instance %pK, cmd %s, arg %lx",
+		"vchiq_ioctl - instance %p, cmd %s, arg %lx",
 		instance,
 		((_IOC_TYPE(cmd) == VCHIQ_IOC_MAGIC) &&
 		(_IOC_NR(cmd) <= VCHIQ_IOC_MAX)) ?
@@ -822,7 +822,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				break;
 			}
 			vchiq_log_info(vchiq_arm_log_level,
-				"found bulk_waiter %pK for pid %d", waiter,
+				"found bulk_waiter %p for pid %d", waiter,
 				current->pid);
 			args.userdata = &waiter->bulk_waiter;
 		}
@@ -852,7 +852,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			list_add(&waiter->list, &instance->bulk_waiter_list);
 			mutex_unlock(&instance->bulk_waiter_list_mutex);
 			vchiq_log_info(vchiq_arm_log_level,
-				"saved bulk_waiter %pK for pid %d",
+				"saved bulk_waiter %p for pid %d",
 				waiter, current->pid);
 
 			if (copy_to_user((void __user *)
@@ -939,7 +939,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 					if (args.msgbufsize < msglen) {
 						vchiq_log_error(
 							vchiq_arm_log_level,
-							"header %pK: msgbufsize %x < msglen %x",
+							"header %p: msgbufsize %x < msglen %x",
 							header, args.msgbufsize,
 							msglen);
 						WARN(1, "invalid message "
@@ -1097,7 +1097,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				ret = -EFAULT;
 		} else {
 			vchiq_log_error(vchiq_arm_log_level,
-				"header %pK: bufsize %x < size %x",
+				"header %p: bufsize %x < size %x",
 				header, args.bufsize, header->size);
 			WARN(1, "invalid size\n");
 			ret = -EMSGSIZE;
@@ -1838,7 +1838,7 @@ vchiq_release(struct inode *inode, struct file *file)
 					list);
 				list_del(pos);
 				vchiq_log_info(vchiq_arm_log_level,
-					"bulk_waiter - cleaned up %pK for pid %d",
+					"bulk_waiter - cleaned up %p for pid %d",
 					waiter, waiter->pid);
 				kfree(waiter);
 			}
@@ -1941,7 +1941,7 @@ vchiq_dump_platform_instances(void *dump_context)
 			instance = service->instance;
 			if (instance && !instance->mark) {
 				len = snprintf(buf, sizeof(buf),
-					"Instance %pK: pid %d,%s completions %d/%d",
+					"Instance %p: pid %d,%s completions %d/%d",
 					instance, instance->pid,
 					instance->connected ? " connected, " :
 						"",
@@ -1970,7 +1970,7 @@ vchiq_dump_platform_service_state(void *dump_context, VCHIQ_SERVICE_T *service)
 	char buf[80];
 	int len;
 
-	len = snprintf(buf, sizeof(buf), "  instance %pK", service->instance);
+	len = snprintf(buf, sizeof(buf), "  instance %p", service->instance);
 
 	if ((service->base.callback == service_callback) &&
 		user_service->is_vchi) {
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index ecff92bae200..7caf20e90a31 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -392,7 +392,7 @@ make_service_callback(VCHIQ_SERVICE_T *service, VCHIQ_REASON_T reason,
 {
 	VCHIQ_STATUS_T status;
 
-	vchiq_log_trace(vchiq_core_log_level, "%d: callback:%d (%s, %pK, %pK)",
+	vchiq_log_trace(vchiq_core_log_level, "%d: callback:%d (%s, %p, %p)",
 		service->state->id, service->localport, reason_names[reason],
 		header, bulk_userdata);
 	status = service->base.callback(reason, header, service->handle,
@@ -648,7 +648,7 @@ process_free_queue(VCHIQ_STATE_T *state)
 		 */
 		rmb();
 
-		vchiq_log_trace(vchiq_core_log_level, "%d: pfq %d=%pK %x %x",
+		vchiq_log_trace(vchiq_core_log_level, "%d: pfq %d=%p %x %x",
 			state->id, slot_index, data,
 			local->slot_queue_recycle, slot_queue_available);
 
@@ -683,7 +683,7 @@ process_free_queue(VCHIQ_STATE_T *state)
 					up(&service_quota->quota_event);
 				else if (count == 0) {
 					vchiq_log_error(vchiq_core_log_level,
-						"service %d message_use_count=%d (header %pK, msgid %x, header->msgid %x, header->size %x)",
+						"service %d message_use_count=%d (header %p, msgid %x, header->msgid %x, header->size %x)",
 						port,
 						service_quota->message_use_count,
 						header, msgid, header->msgid,
@@ -708,14 +708,14 @@ process_free_queue(VCHIQ_STATE_T *state)
 						up(&service_quota->quota_event);
 						vchiq_log_trace(
 							vchiq_core_log_level,
-							"%d: pfq:%d %x@%pK - slot_use->%d",
+							"%d: pfq:%d %x@%p - slot_use->%d",
 							state->id, port,
 							header->size, header,
 							count - 1);
 					} else {
 						vchiq_log_error(
 							vchiq_core_log_level,
-								"service %d slot_use_count=%d (header %pK, msgid %x, header->msgid %x, header->size %x)",
+								"service %d slot_use_count=%d (header %p, msgid %x, header->msgid %x, header->size %x)",
 							port, count, header,
 							msgid, header->msgid,
 							header->size);
@@ -729,7 +729,7 @@ process_free_queue(VCHIQ_STATE_T *state)
 			pos += calc_stride(header->size);
 			if (pos > VCHIQ_SLOT_SIZE) {
 				vchiq_log_error(vchiq_core_log_level,
-					"pfq - pos %x: header %pK, msgid %x, header->msgid %x, header->size %x",
+					"pfq - pos %x: header %p, msgid %x, header->msgid %x, header->size %x",
 					pos, header, msgid, header->msgid,
 					header->size);
 				WARN(1, "invalid slot position\n");
@@ -933,7 +933,7 @@ queue_message(VCHIQ_STATE_T *state, VCHIQ_SERVICE_T *service,
 		int slot_use_count;
 
 		vchiq_log_info(vchiq_core_log_level,
-			"%d: qm %s@%pK,%zx (%d->%d)",
+			"%d: qm %s@%p,%zx (%d->%d)",
 			state->id, msg_type_str(VCHIQ_MSG_TYPE(msgid)),
 			header, size, VCHIQ_MSG_SRCPORT(msgid),
 			VCHIQ_MSG_DSTPORT(msgid));
@@ -994,7 +994,7 @@ queue_message(VCHIQ_STATE_T *state, VCHIQ_SERVICE_T *service,
 		VCHIQ_SERVICE_STATS_ADD(service, ctrl_tx_bytes, size);
 	} else {
 		vchiq_log_info(vchiq_core_log_level,
-			"%d: qm %s@%pK,%zx (%d->%d)", state->id,
+			"%d: qm %s@%p,%zx (%d->%d)", state->id,
 			msg_type_str(VCHIQ_MSG_TYPE(msgid)),
 			header, size, VCHIQ_MSG_SRCPORT(msgid),
 			VCHIQ_MSG_DSTPORT(msgid));
@@ -1089,7 +1089,7 @@ queue_message_sync(VCHIQ_STATE_T *state, VCHIQ_SERVICE_T *service,
 	}
 
 	vchiq_log_info(vchiq_sync_log_level,
-		       "%d: qms %s@%pK,%x (%d->%d)", state->id,
+		       "%d: qms %s@%p,%x (%d->%d)", state->id,
 		       msg_type_str(VCHIQ_MSG_TYPE(msgid)),
 		       header, size, VCHIQ_MSG_SRCPORT(msgid),
 		       VCHIQ_MSG_DSTPORT(msgid));
@@ -1416,7 +1416,7 @@ resolve_bulks(VCHIQ_SERVICE_T *service, VCHIQ_BULK_QUEUE_T *queue)
 				"Send Bulk to" : "Recv Bulk from";
 			if (bulk->actual != VCHIQ_BULK_ACTUAL_ABORTED)
 				vchiq_log_info(SRVTRACE_LEVEL(service),
-					"%s %c%c%c%c d:%d len:%d %pK<->%pK",
+					"%s %c%c%c%c d:%d len:%d %p<->%p",
 					header,
 					VCHIQ_FOURCC_AS_4CHARS(
 						service->base.fourcc),
@@ -1425,7 +1425,7 @@ resolve_bulks(VCHIQ_SERVICE_T *service, VCHIQ_BULK_QUEUE_T *queue)
 			else
 				vchiq_log_info(SRVTRACE_LEVEL(service),
 					"%s %c%c%c%c d:%d ABORTED - tx len:%d,"
-					" rx len:%d %pK<->%pK",
+					" rx len:%d %p<->%p",
 					header,
 					VCHIQ_FOURCC_AS_4CHARS(
 						service->base.fourcc),
@@ -1568,7 +1568,7 @@ parse_open(VCHIQ_STATE_T *state, VCHIQ_HEADER_T *header)
 
 		fourcc = payload->fourcc;
 		vchiq_log_info(vchiq_core_log_level,
-			"%d: prs OPEN@%pK (%d->'%c%c%c%c')",
+			"%d: prs OPEN@%p (%d->'%c%c%c%c')",
 			state->id, header, localport,
 			VCHIQ_FOURCC_AS_4CHARS(fourcc));
 
@@ -1746,7 +1746,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 					remoteport);
 				if (service)
 					vchiq_log_warning(vchiq_core_log_level,
-						"%d: prs %s@%pK (%d->%d) - found connected service %d",
+						"%d: prs %s@%p (%d->%d) - found connected service %d",
 						state->id, msg_type_str(type),
 						header, remoteport, localport,
 						service->localport);
@@ -1754,7 +1754,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 
 			if (!service) {
 				vchiq_log_error(vchiq_core_log_level,
-					"%d: prs %s@%pK (%d->%d) - invalid/closed service %d",
+					"%d: prs %s@%p (%d->%d) - invalid/closed service %d",
 					state->id, msg_type_str(type),
 					header, remoteport, localport,
 					localport);
@@ -1785,7 +1785,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 		if (((unsigned long)header & VCHIQ_SLOT_MASK) +
 		    calc_stride(size) > VCHIQ_SLOT_SIZE) {
 			vchiq_log_error(vchiq_core_log_level,
-				"header %pK (msgid %x) - size %x too big for slot",
+				"header %p (msgid %x) - size %x too big for slot",
 				header, (unsigned int)msgid,
 				(unsigned int)size);
 			WARN(1, "oversized for slot\n");
@@ -1805,7 +1805,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 				service->peer_version = payload->version;
 			}
 			vchiq_log_info(vchiq_core_log_level,
-				"%d: prs OPENACK@%pK,%x (%d->%d) v:%d",
+				"%d: prs OPENACK@%p,%x (%d->%d) v:%d",
 				state->id, header, size, remoteport, localport,
 				service->peer_version);
 			if (service->srvstate ==
@@ -1823,7 +1823,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 			WARN_ON(size != 0); /* There should be no data */
 
 			vchiq_log_info(vchiq_core_log_level,
-				"%d: prs CLOSE@%pK (%d->%d)",
+				"%d: prs CLOSE@%p (%d->%d)",
 				state->id, header, remoteport, localport);
 
 			mark_service_closing_internal(service, 1);
@@ -1840,7 +1840,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 			break;
 		case VCHIQ_MSG_DATA:
 			vchiq_log_info(vchiq_core_log_level,
-				"%d: prs DATA@%pK,%x (%d->%d)",
+				"%d: prs DATA@%p,%x (%d->%d)",
 				state->id, header, size, remoteport, localport);
 
 			if ((service->remoteport == remoteport)
@@ -1864,7 +1864,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 			break;
 		case VCHIQ_MSG_CONNECT:
 			vchiq_log_info(vchiq_core_log_level,
-				"%d: prs CONNECT@%pK", state->id, header);
+				"%d: prs CONNECT@%p", state->id, header);
 			state->version_common = ((VCHIQ_SLOT_ZERO_T *)
 						 state->slot_data)->version;
 			up(&state->connect);
@@ -1899,7 +1899,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 				wmb();
 
 				vchiq_log_info(vchiq_core_log_level,
-					"%d: prs %s@%pK (%d->%d) %x@%pK",
+					"%d: prs %s@%p (%d->%d) %x@%p",
 					state->id, msg_type_str(type),
 					header, remoteport, localport,
 					bulk->remote_size, bulk->remote_data);
@@ -1955,7 +1955,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 				if ((int)(queue->remote_insert -
 					queue->local_insert) >= 0) {
 					vchiq_log_error(vchiq_core_log_level,
-						"%d: prs %s@%pK (%d->%d) "
+						"%d: prs %s@%p (%d->%d) "
 						"unexpected (ri=%d,li=%d)",
 						state->id, msg_type_str(type),
 						header, remoteport, localport,
@@ -1979,7 +1979,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 				queue->remote_insert++;
 
 				vchiq_log_info(vchiq_core_log_level,
-					"%d: prs %s@%pK (%d->%d) %x@%pK",
+					"%d: prs %s@%p (%d->%d) %x@%p",
 					state->id, msg_type_str(type),
 					header, remoteport, localport,
 					bulk->actual, bulk->data);
@@ -2004,13 +2004,13 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 			break;
 		case VCHIQ_MSG_PADDING:
 			vchiq_log_trace(vchiq_core_log_level,
-				"%d: prs PADDING@%pK,%x",
+				"%d: prs PADDING@%p,%x",
 				state->id, header, size);
 			break;
 		case VCHIQ_MSG_PAUSE:
 			/* If initiated, signal the application thread */
 			vchiq_log_trace(vchiq_core_log_level,
-				"%d: prs PAUSE@%pK,%x",
+				"%d: prs PAUSE@%p,%x",
 				state->id, header, size);
 			if (state->conn_state == VCHIQ_CONNSTATE_PAUSED) {
 				vchiq_log_error(vchiq_core_log_level,
@@ -2034,7 +2034,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 			break;
 		case VCHIQ_MSG_RESUME:
 			vchiq_log_trace(vchiq_core_log_level,
-				"%d: prs RESUME@%pK,%x",
+				"%d: prs RESUME@%p,%x",
 				state->id, header, size);
 			/* Release the slot mutex */
 			mutex_unlock(&state->slot_mutex);
@@ -2056,7 +2056,7 @@ parse_rx_slots(VCHIQ_STATE_T *state)
 
 		default:
 			vchiq_log_error(vchiq_core_log_level,
-				"%d: prs invalid msgid %x@%pK,%x",
+				"%d: prs invalid msgid %x@%p,%x",
 				state->id, msgid, header, size);
 			WARN(1, "invalid message\n");
 			break;
@@ -2219,7 +2219,7 @@ sync_func(void *v)
 
 		if (!service) {
 			vchiq_log_error(vchiq_sync_log_level,
-				"%d: sf %s@%pK (%d->%d) - invalid/closed service %d",
+				"%d: sf %s@%p (%d->%d) - invalid/closed service %d",
 				state->id, msg_type_str(type),
 				header, remoteport, localport, localport);
 			release_message_sync(state, header);
@@ -2251,7 +2251,7 @@ sync_func(void *v)
 				service->peer_version = payload->version;
 			}
 			vchiq_log_info(vchiq_sync_log_level,
-				"%d: sf OPENACK@%pK,%x (%d->%d) v:%d",
+				"%d: sf OPENACK@%p,%x (%d->%d) v:%d",
 				state->id, header, size, remoteport, localport,
 				service->peer_version);
 			if (service->srvstate == VCHIQ_SRVSTATE_OPENING) {
@@ -2266,7 +2266,7 @@ sync_func(void *v)
 
 		case VCHIQ_MSG_DATA:
 			vchiq_log_trace(vchiq_sync_log_level,
-				"%d: sf DATA@%pK,%x (%d->%d)",
+				"%d: sf DATA@%p,%x (%d->%d)",
 				state->id, header, size, remoteport, localport);
 
 			if ((service->remoteport == remoteport) &&
@@ -2285,7 +2285,7 @@ sync_func(void *v)
 
 		default:
 			vchiq_log_error(vchiq_sync_log_level,
-				"%d: sf unexpected msgid %x@%pK,%x",
+				"%d: sf unexpected msgid %x@%p,%x",
 				state->id, msgid, header, size);
 			release_message_sync(state, header);
 			break;
@@ -2364,7 +2364,7 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 	int i;
 
 	vchiq_log_warning(vchiq_core_log_level,
-		"%s: slot_zero = %pK, is_master = %d",
+		"%s: slot_zero = %p, is_master = %d",
 		__func__, slot_zero, is_master);
 
 	if (vchiq_states[0]) {
@@ -2377,7 +2377,7 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 	if (slot_zero->magic != VCHIQ_MAGIC) {
 		vchiq_loud_error_header();
 		vchiq_loud_error("Invalid VCHIQ magic value found.");
-		vchiq_loud_error("slot_zero=%pK: magic=%x (expected %x)",
+		vchiq_loud_error("slot_zero=%p: magic=%x (expected %x)",
 			slot_zero, slot_zero->magic, VCHIQ_MAGIC);
 		vchiq_loud_error_footer();
 		return VCHIQ_ERROR;
@@ -2386,7 +2386,7 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 	if (slot_zero->version < VCHIQ_VERSION_MIN) {
 		vchiq_loud_error_header();
 		vchiq_loud_error("Incompatible VCHIQ versions found.");
-		vchiq_loud_error("slot_zero=%pK: VideoCore version=%d (minimum %d)",
+		vchiq_loud_error("slot_zero=%p: VideoCore version=%d (minimum %d)",
 			slot_zero, slot_zero->version, VCHIQ_VERSION_MIN);
 		vchiq_loud_error("Restart with a newer VideoCore image.");
 		vchiq_loud_error_footer();
@@ -2396,7 +2396,7 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 	if (VCHIQ_VERSION < slot_zero->version_min) {
 		vchiq_loud_error_header();
 		vchiq_loud_error("Incompatible VCHIQ versions found.");
-		vchiq_loud_error("slot_zero=%pK: version=%d (VideoCore minimum %d)",
+		vchiq_loud_error("slot_zero=%p: version=%d (VideoCore minimum %d)",
 			slot_zero, VCHIQ_VERSION, slot_zero->version_min);
 		vchiq_loud_error("Restart with a newer kernel.");
 		vchiq_loud_error_footer();
@@ -2409,19 +2409,19 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 		 (slot_zero->max_slots_per_side != VCHIQ_MAX_SLOTS_PER_SIDE)) {
 		vchiq_loud_error_header();
 		if (slot_zero->slot_zero_size != sizeof(VCHIQ_SLOT_ZERO_T))
-			vchiq_loud_error("slot_zero=%pK: slot_zero_size=%d (expected %d)",
+			vchiq_loud_error("slot_zero=%p: slot_zero_size=%d (expected %d)",
 				slot_zero, slot_zero->slot_zero_size,
 				(int)sizeof(VCHIQ_SLOT_ZERO_T));
 		if (slot_zero->slot_size != VCHIQ_SLOT_SIZE)
-			vchiq_loud_error("slot_zero=%pK: slot_size=%d (expected %d)",
+			vchiq_loud_error("slot_zero=%p: slot_size=%d (expected %d)",
 				slot_zero, slot_zero->slot_size,
 				VCHIQ_SLOT_SIZE);
 		if (slot_zero->max_slots != VCHIQ_MAX_SLOTS)
-			vchiq_loud_error("slot_zero=%pK: max_slots=%d (expected %d)",
+			vchiq_loud_error("slot_zero=%p: max_slots=%d (expected %d)",
 				slot_zero, slot_zero->max_slots,
 				VCHIQ_MAX_SLOTS);
 		if (slot_zero->max_slots_per_side != VCHIQ_MAX_SLOTS_PER_SIDE)
-			vchiq_loud_error("slot_zero=%pK: max_slots_per_side=%d (expected %d)",
+			vchiq_loud_error("slot_zero=%p: max_slots_per_side=%d (expected %d)",
 				slot_zero, slot_zero->max_slots_per_side,
 				VCHIQ_MAX_SLOTS_PER_SIDE);
 		vchiq_loud_error_footer();
@@ -2798,14 +2798,14 @@ release_service_messages(VCHIQ_SERVICE_T *service)
 				if ((port == service->localport) &&
 					(msgid & VCHIQ_MSGID_CLAIMED)) {
 					vchiq_log_info(vchiq_core_log_level,
-						"  fsi - hdr %pK", header);
+						"  fsi - hdr %p", header);
 					release_slot(state, slot_info, header,
 						NULL);
 				}
 				pos += calc_stride(header->size);
 				if (pos > VCHIQ_SLOT_SIZE) {
 					vchiq_log_error(vchiq_core_log_level,
-						"fsi - pos %x: header %pK, msgid %x, header->msgid %x, header->size %x",
+						"fsi - pos %x: header %p, msgid %x, header->msgid %x, header->size %x",
 						pos, header, msgid,
 						header->msgid, header->size);
 					WARN(1, "invalid slot position\n");
@@ -3377,7 +3377,7 @@ vchiq_bulk_transfer(VCHIQ_SERVICE_HANDLE_T handle,
 	wmb();
 
 	vchiq_log_info(vchiq_core_log_level,
-		"%d: bt (%d->%d) %cx %x@%pK %pK",
+		"%d: bt (%d->%d) %cx %x@%p %p",
 		state->id, service->localport, service->remoteport, dir_char,
 		size, bulk->data, userdata);
 
@@ -3726,7 +3726,7 @@ vchiq_dump_state(void *dump_context, VCHIQ_STATE_T *state)
 	vchiq_dump(dump_context, buf, len + 1);
 
 	len = snprintf(buf, sizeof(buf),
-		"  tx_pos=%x(@%pK), rx_pos=%x(@%pK)",
+		"  tx_pos=%x(@%p), rx_pos=%x(@%p)",
 		state->local->tx_pos,
 		state->tx_data + (state->local_tx_pos & VCHIQ_SLOT_MASK),
 		state->rx_pos,
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_kern_lib.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_kern_lib.c
index 34f746db19cd..a48df1912a04 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_kern_lib.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_kern_lib.c
@@ -157,7 +157,7 @@ VCHIQ_STATUS_T vchiq_shutdown(VCHIQ_INSTANCE_T instance)
 					list);
 			list_del(pos);
 			vchiq_log_info(vchiq_arm_log_level,
-					"bulk_waiter - cleaned up %pK for pid %d",
+					"bulk_waiter - cleaned up %p for pid %d",
 					waiter, waiter->pid);
 			kfree(waiter);
 		}
@@ -453,7 +453,7 @@ vchiq_blocking_bulk_transfer(VCHIQ_SERVICE_HANDLE_T handle, void *data,
 		list_add(&waiter->list, &instance->bulk_waiter_list);
 		mutex_unlock(&instance->bulk_waiter_list_mutex);
 		vchiq_log_info(vchiq_arm_log_level,
-				"saved bulk_waiter %pK for pid %d",
+				"saved bulk_waiter %p for pid %d",
 				waiter, current->pid);
 	}
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 705c573d0257..8f8567035442 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -465,11 +465,11 @@ static void snoop_urb(struct usb_device *udev,
 
 	if (userurb) {		/* Async */
 		if (when == SUBMIT)
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %p, ep%d %s-%s, "
 					"length %u\n",
 					userurb, ep, t, d, length);
 		else
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %p, ep%d %s-%s, "
 					"actual_length %u status %d\n",
 					userurb, ep, t, d, length,
 					timeout_or_status);
@@ -1900,7 +1900,7 @@ static int proc_reapurb(struct usb_dev_state *ps, void __user *arg)
 	if (as) {
 		int retval;
 
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %p\n", as->userurb);
 		retval = processcompl(as, (void __user * __user *)arg);
 		free_async(as);
 		return retval;
@@ -1917,7 +1917,7 @@ static int proc_reapurbnonblock(struct usb_dev_state *ps, void __user *arg)
 
 	as = async_getcompleted(ps);
 	if (as) {
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %p\n", as->userurb);
 		retval = processcompl(as, (void __user * __user *)arg);
 		free_async(as);
 	} else {
@@ -2043,7 +2043,7 @@ static int proc_reapurb_compat(struct usb_dev_state *ps, void __user *arg)
 	if (as) {
 		int retval;
 
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %p\n", as->userurb);
 		retval = processcompl_compat(as, (void __user * __user *)arg);
 		free_async(as);
 		return retval;
@@ -2060,7 +2060,7 @@ static int proc_reapurbnonblock_compat(struct usb_dev_state *ps, void __user *ar
 
 	as = async_getcompleted(ps);
 	if (as) {
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %p\n", as->userurb);
 		retval = processcompl_compat(as, (void __user * __user *)arg);
 		free_async(as);
 	} else {
@@ -2485,7 +2485,7 @@ static long usbdev_do_ioctl(struct file *file, unsigned int cmd,
 #endif
 
 	case USBDEVFS_DISCARDURB:
-		snoop(&dev->dev, "%s: DISCARDURB %pK\n", __func__, p);
+		snoop(&dev->dev, "%s: DISCARDURB %p\n", __func__, p);
 		ret = proc_unlinkurb(ps, p);
 		break;
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index fc32391a34d5..e9b80e730bcc 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1722,7 +1722,7 @@ int usb_hcd_unlink_urb (struct urb *urb, int status)
 		if (retval == 0)
 			retval = -EINPROGRESS;
 		else if (retval != -EIDRM && retval != -EBUSY)
-			dev_dbg(&udev->dev, "hcd_unlink_urb %pK fail %d\n",
+			dev_dbg(&udev->dev, "hcd_unlink_urb %p fail %d\n",
 					urb, retval);
 		usb_put_dev(udev);
 	}
@@ -1889,7 +1889,7 @@ void usb_hcd_flush_endpoint(struct usb_device *udev,
 		/* kick hcd */
 		unlink1(hcd, urb, -ESHUTDOWN);
 		dev_dbg (hcd->self.controller,
-			"shutdown urb %pK ep%d%s%s\n",
+			"shutdown urb %p ep%d%s%s\n",
 			urb, usb_endpoint_num(&ep->desc),
 			is_in ? "in" : "out",
 			({	char *s;
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 9fdf137c4865..f854f6795a88 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -360,7 +360,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 	if (!urb || !urb->complete)
 		return -EINVAL;
 	if (urb->hcpriv) {
-		WARN_ONCE(1, "URB %pK submitted while active\n", urb);
+		WARN_ONCE(1, "URB %p submitted while active\n", urb);
 		return -EBUSY;
 	}
 
diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
index 16081383c401..afccc79081fd 100644
--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -226,7 +226,7 @@ static int st_dwc3_probe(struct platform_device *pdev)
 
 	dwc3_data->syscfg_reg_off = res->start;
 
-	dev_vdbg(&pdev->dev, "glue-logic addr 0x%pK, syscfg-reg offset 0x%x\n",
+	dev_vdbg(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
 		 dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
 
 	dwc3_data->rstc_pwrdn =
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 981fd986cf82..667a6aa602a9 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1288,7 +1288,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 		return -ESHUTDOWN;
 	}
 
-	if (WARN(req->dep != dep, "request %pK belongs to '%s'\n",
+	if (WARN(req->dep != dep, "request %p belongs to '%s'\n",
 				&req->request, req->dep->name))
 		return -EINVAL;
 
@@ -1448,7 +1448,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			}
 			goto out1;
 		}
-		dev_err(dwc->dev, "request %pK was not queued to %s\n",
+		dev_err(dwc->dev, "request %p was not queued to %s\n",
 				request, ep->name);
 		ret = -EINVAL;
 		goto out0;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 80b5b482cb46..da230b556d95 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -770,7 +770,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 5f780d8f6a9d..cd314106b3e4 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -52,7 +52,7 @@ static int current_css_set_read(struct seq_file *seq, void *v)
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
 	refcnt = refcount_read(&cset->refcount);
-	seq_printf(seq, "css_set %pK %d", cset, refcnt);
+	seq_printf(seq, "css_set %p %d", cset, refcnt);
 	if (refcnt > cset->nr_tasks)
 		seq_printf(seq, " +%d", refcnt - cset->nr_tasks);
 	seq_puts(seq, "\n");
@@ -129,10 +129,10 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		 * Print out the proc_cset and threaded_cset relationship
 		 * and highlight difference between refcount and task_count.
 		 */
-		seq_printf(seq, "css_set %pK", cset);
+		seq_printf(seq, "css_set %p", cset);
 		if (rcu_dereference_protected(cset->dom_cset, 1) != cset) {
 			threaded_csets++;
-			seq_printf(seq, "=>%pK", cset->dom_cset);
+			seq_printf(seq, "=>%p", cset->dom_cset);
 		}
 		if (!list_empty(&cset->threaded_csets)) {
 			struct css_set *tcset;
@@ -141,7 +141,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 			list_for_each_entry(tcset, &cset->threaded_csets,
 					    threaded_csets_node) {
 				seq_puts(seq, idx ? "," : "<=");
-				seq_printf(seq, "%pK", tcset);
+				seq_printf(seq, "%p", tcset);
 				idx++;
 			}
 		} else {
diff --git a/kernel/module.c b/kernel/module.c
index dea01ac9cb74..79b69315041a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1472,7 +1472,7 @@ static ssize_t module_sect_show(struct module_attribute *mattr,
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
-	return sprintf(buf, "0x%pK\n", (void *)sattr->address);
+	return sprintf(buf, "0x%p\n", (void *)sattr->address);
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 0ed768b56c60..a16c941a1a7a 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -54,7 +54,7 @@ static void print_name_offset(struct seq_file *m, void *sym)
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
-		SEQ_printf(m, "<%pK>", sym);
+		SEQ_printf(m, "<%p>", sym);
 	else
 		SEQ_printf(m, "%s", symname);
 }
@@ -118,7 +118,7 @@ print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
-	SEQ_printf(m, "  .base:       %pK\n", base);
+	SEQ_printf(m, "  .base:       %p\n", base);
 	SEQ_printf(m, "  .index:      %d\n", base->index);
 
 	SEQ_printf(m, "  .resolution: %u nsecs\n", hrtimer_resolution);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 01c3957b2de6..81e9ce8f52f9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1360,7 +1360,7 @@ char *restricted_pointer(char *buf, char *end, const void *ptr,
 
 	switch (kptr_restrict) {
 	case 0:
-		/* Always print %pK values */
+		/* Always print %p values */
 		break;
 	case 1: {
 		const struct cred *cred;
@@ -1376,10 +1376,10 @@ char *restricted_pointer(char *buf, char *end, const void *ptr,
 		 * Only print the real pointer value if the current
 		 * process has CAP_SYSLOG and is running with the
 		 * same credentials it started with. This is because
-		 * access to files is checked at open() time, but %pK
+		 * access to files is checked at open() time, but %p
 		 * checks permission at read() time. We don't want to
 		 * leak pointer values if a binary opens a file using
-		 * %pK and then elevates privileges before reading it.
+		 * %p and then elevates privileges before reading it.
 		 */
 		cred = current_cred();
 		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
@@ -1390,7 +1390,7 @@ char *restricted_pointer(char *buf, char *end, const void *ptr,
 	}
 	case 2:
 	default:
-		/* Always print 0's for %pK */
+		/* Always print 0's for %p */
 		ptr = NULL;
 		break;
 	}
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 673942094328..911139f70223 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2698,7 +2698,7 @@ static int s_show(struct seq_file *m, void *p)
 	 * behalf of vmap area is being tear down or vm_map_ram allocation.
 	 */
 	if (!(va->flags & VM_VM_AREA)) {
-		seq_printf(m, "0x%pK-0x%pK %7ld %s\n",
+		seq_printf(m, "0x%p-0x%p %7ld %s\n",
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start,
 			va->flags & VM_LAZY_FREE ? "unpurged vm_area" : "vm_map_ram");
@@ -2708,7 +2708,7 @@ static int s_show(struct seq_file *m, void *p)
 
 	v = va->vm;
 
-	seq_printf(m, "0x%pK-0x%pK %7ld",
+	seq_printf(m, "0x%p-0x%p %7ld",
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller)
diff --git a/net/atm/proc.c b/net/atm/proc.c
index 642f9272ab95..b0f323186a44 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -192,7 +192,7 @@ static void vcc_info(struct seq_file *seq, struct atm_vcc *vcc)
 {
 	struct sock *sk = sk_atm(vcc);
 
-	seq_printf(seq, "%pK ", vcc);
+	seq_printf(seq, "%p ", vcc);
 	if (!vcc->dev)
 		seq_printf(seq, "Unassigned    ");
 	else
@@ -219,7 +219,7 @@ static void svc_info(struct seq_file *seq, struct atm_vcc *vcc)
 {
 	if (!vcc->dev)
 		seq_printf(seq, sizeof(void *) == 4 ?
-			   "N/A@%pK%10s" : "N/A@%pK%2s", vcc, "");
+			   "N/A@%p%10s" : "N/A@%p%2s", vcc, "");
 	else
 		seq_printf(seq, "%3d %3d %5d         ",
 			   vcc->dev->number, vcc->vpi, vcc->vci);
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 91e3ba280706..74013159ad4c 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -655,7 +655,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 		struct bt_sock *bt = bt_sk(sk);
 
 		seq_printf(seq,
-			   "%pK %-6d %-6u %-6u %-6u %-6lu %-6lu",
+			   "%p %-6d %-6u %-6u %-6u %-6lu %-6lu",
 			   sk,
 			   refcount_read(&sk->sk_refcnt),
 			   sk_rmem_alloc_get(sk),
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 13690334efa3..fd23639470a9 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -174,9 +174,9 @@ static int bcm_proc_show(struct seq_file *m, void *v)
 	struct bcm_sock *bo = bcm_sk(sk);
 	struct bcm_op *op;
 
-	seq_printf(m, ">>> socket %pK", sk->sk_socket);
-	seq_printf(m, " / sk %pK", sk);
-	seq_printf(m, " / bo %pK", bo);
+	seq_printf(m, ">>> socket %p", sk->sk_socket);
+	seq_printf(m, " / sk %p", sk);
+	seq_printf(m, " / bo %p", bo);
 	seq_printf(m, " / dropped %lu", bo->dropped_usr_msgs);
 	seq_printf(m, " / bound %s", bcm_proc_getifname(net, ifname, bo->ifindex));
 	seq_printf(m, " <<<\n");
diff --git a/net/can/proc.c b/net/can/proc.c
index 0c59f876fe6f..a3b47c22c065 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -190,8 +190,8 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
 
 	hlist_for_each_entry_rcu(r, rx_list, list) {
 		char *fmt = (r->can_id & CAN_EFF_FLAG)?
-			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
-			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
+			"   %-5s  %08x  %08x  %p  %p  %8ld  %s\n" :
+			"   %-5s     %03x    %08x  %p  %p  %8ld  %s\n";
 
 		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
 				r->func, r->data, r->matches, r->ident);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b8f0db54b197..6e1a2e389674 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1120,7 +1120,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %p %d",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 33b70bfd1122..aac2d774c390 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1062,7 +1062,7 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 	      srcp  = inet->inet_num;
 
 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d\n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %p %d\n",
 		i, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c6bc0c4d19c6..af1a569f4c14 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2210,7 +2210,7 @@ static void get_openreq4(const struct request_sock *req,
 	long delta = req->rsk_timer.expires - jiffies;
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %p",
 		i,
 		ireq->ir_loc_addr,
 		ireq->ir_num,
@@ -2270,7 +2270,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
-			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
+			"%08X %5u %8d %lu %d %p %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
 		tp->write_seq - tp->snd_una,
 		rx_queue,
@@ -2303,7 +2303,7 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
 	srcp  = ntohs(tw->tw_sport);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
+		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %p",
 		i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
 		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
 		refcount_read(&tw->tw_refcnt), tw);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e4ff25c947c5..7368c5a31ded 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2708,7 +2708,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp	  = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %p %d",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index a1f918713006..c28a92beb0b8 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1028,7 +1028,7 @@ void ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
 	src   = &sp->sk_v6_rcv_saddr;
 	seq_printf(seq,
 		   "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %p %d\n",
 		   bucket,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 6bb98c93edfe..740abb9169aa 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1740,7 +1740,7 @@ static void get_openreq6(struct seq_file *seq,
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d %pK\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d %p\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3],
@@ -1805,7 +1805,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %lu %lu %u %u %d\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %p %lu %lu %u %u %d\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
@@ -1845,7 +1845,7 @@ static void get_timewait6_sock(struct seq_file *seq,
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %p\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 3dffb892d52c..845c97837638 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3735,7 +3735,7 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
 	if (v == SEQ_START_TOKEN)
 		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
 	else
-		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6lu\n",
+		seq_printf(f, "%p %-6d %-6u %-6u %-6u %-6lu\n",
 			       s,
 			       refcount_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b9e0ee4e22f5..8fe15a7fa6ab 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2568,7 +2568,7 @@ static int netlink_seq_show(struct seq_file *seq, void *v)
 		struct sock *s = v;
 		struct netlink_sock *nlk = nlk_sk(s);
 
-		seq_printf(seq, "%pK %-3d %-6u %08x %-8d %-8d %d %-8d %-8d %-8lu\n",
+		seq_printf(seq, "%p %-3d %-6u %08x %-8d %-8d %d %-8d %-8d %-8lu\n",
 			   s,
 			   s->sk_protocol,
 			   nlk->portid,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 737092ca9b4e..36975b9a761b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4508,7 +4508,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 		const struct packet_sock *po = pkt_sk(s);
 
 		seq_printf(seq,
-			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
+			   "%p %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
 			   s,
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 1b050dd17393..9f2a84a72012 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -608,7 +608,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 		struct pn_sock *pn = pn_sk(sk);
 
 		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu "
-			"%d %pK %d",
+			"%d %p %d",
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a9ee634f3c42..399c838e0525 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2821,7 +2821,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 		struct unix_sock *u = unix_sk(s);
 		unix_state_lock(s);
 
-		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
+		seq_printf(seq, "%p: %08X %08X %08X %04X %02X %5lu",
 			s,
 			refcount_read(&s->sk_refcnt),
 			0,
diff --git a/sound/soc/bcm/cygnus-pcm.c b/sound/soc/bcm/cygnus-pcm.c
index d616e096462e..554107d79cf1 100644
--- a/sound/soc/bcm/cygnus-pcm.c
+++ b/sound/soc/bcm/cygnus-pcm.c
@@ -740,7 +740,7 @@ static int cygnus_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 	buf->area = dma_alloc_coherent(pcm->card->dev, size,
 			&buf->addr, GFP_KERNEL);
 
-	dev_dbg(rtd->cpu_dai->dev, "%s: size 0x%zx @ %pK\n",
+	dev_dbg(rtd->cpu_dai->dev, "%s: size 0x%zx @ %p\n",
 				__func__, size, buf->area);
 
 	if (!buf->area) {
-- 
2.7.4
