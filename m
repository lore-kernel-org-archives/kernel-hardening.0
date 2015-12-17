Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:48 -0500
Message-Id: <1450364270-12687-11-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 10/12] pax: opt out of PAX_REFCOUNT protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

These changes are those that did not fit categorically into any other of the
preceding "opt-out" patches.

Signed-off-by: David Windsor <dave@progbits.org>
---
 include/linux/genhd.h          |  2 +-
 lib/show_mem.c                 |  2 +-
 sound/pci/ymfpci/ymfpci.h      |  2 +-
 sound/pci/ymfpci/ymfpci_main.c | 12 ++++++------
 virt/kvm/kvm_main.c            |  8 ++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ec274e0..c183f10 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -194,7 +194,7 @@ struct gendisk {
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
+	atomic_unchecked_t sync_io;	/* RAID */
 	struct disk_events *ev;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
diff --git a/lib/show_mem.c b/lib/show_mem.c
index adc98e18..0ce83c2 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -49,6 +49,6 @@ void show_mem(unsigned int filter)
 		quicklist_total_size());
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
-	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+	printk("%lu pages hwpoisoned\n", atomic_long_read_unchecked(&num_poisoned_pages));
 #endif
 }
diff --git a/sound/pci/ymfpci/ymfpci.h b/sound/pci/ymfpci/ymfpci.h
index 149d4cb..7784769 100644
--- a/sound/pci/ymfpci/ymfpci.h
+++ b/sound/pci/ymfpci/ymfpci.h
@@ -358,7 +358,7 @@ struct snd_ymfpci {
 	spinlock_t reg_lock;
 	spinlock_t voice_lock;
 	wait_queue_head_t interrupt_sleep;
-	atomic_t interrupt_sleep_count;
+	atomic_unchecked_t interrupt_sleep_count;
 	struct snd_info_entry *proc_entry;
 	const struct firmware *dsp_microcode;
 	const struct firmware *controller_microcode;
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 4c26076..a13f370 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -204,8 +204,8 @@ static void snd_ymfpci_hw_stop(struct snd_ymfpci *chip)
 		if ((snd_ymfpci_readl(chip, YDSXGR_STATUS) & 2) == 0)
 			break;
 	}
-	if (atomic_read(&chip->interrupt_sleep_count)) {
-		atomic_set(&chip->interrupt_sleep_count, 0);
+	if (atomic_read_unchecked(&chip->interrupt_sleep_count)) {
+		atomic_set_unchecked(&chip->interrupt_sleep_count, 0);
 		wake_up(&chip->interrupt_sleep);
 	}
       __end:
@@ -789,7 +789,7 @@ static void snd_ymfpci_irq_wait(struct snd_ymfpci *chip)
 		 	continue;
 		init_waitqueue_entry(&wait, current);
 		add_wait_queue(&chip->interrupt_sleep, &wait);
-		atomic_inc(&chip->interrupt_sleep_count);
+		atomic_inc_unchecked(&chip->interrupt_sleep_count);
 		schedule_timeout_uninterruptible(msecs_to_jiffies(50));
 		remove_wait_queue(&chip->interrupt_sleep, &wait);
 	}
@@ -827,8 +827,8 @@ static irqreturn_t snd_ymfpci_interrupt(int irq, void *dev_id)
 		snd_ymfpci_writel(chip, YDSXGR_MODE, mode);
 		spin_unlock(&chip->reg_lock);
 
-		if (atomic_read(&chip->interrupt_sleep_count)) {
-			atomic_set(&chip->interrupt_sleep_count, 0);
+		if (atomic_read_unchecked(&chip->interrupt_sleep_count)) {
+			atomic_set_unchecked(&chip->interrupt_sleep_count, 0);
 			wake_up(&chip->interrupt_sleep);
 		}
 	}
@@ -2384,7 +2384,7 @@ int snd_ymfpci_create(struct snd_card *card,
 	spin_lock_init(&chip->reg_lock);
 	spin_lock_init(&chip->voice_lock);
 	init_waitqueue_head(&chip->interrupt_sleep);
-	atomic_set(&chip->interrupt_sleep_count, 0);
+	atomic_set_unchecked(&chip->interrupt_sleep_count, 0);
 	chip->card = card;
 	chip->pci = pci;
 	chip->irq = -1;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5a2a78a..f868724 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -81,7 +81,7 @@ LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
+static atomic_unchecked_t hardware_enable_failed;
 
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
@@ -2961,7 +2961,7 @@ static void hardware_enable_nolock(void *junk)
 
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
-		atomic_inc(&hardware_enable_failed);
+		atomic_inc_unchecked(&hardware_enable_failed);
 		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
 	}
 }
@@ -3016,10 +3016,10 @@ static int hardware_enable_all(void)
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
+		atomic_set_unchecked(&hardware_enable_failed, 0);
 		on_each_cpu(hardware_enable_nolock, NULL, 1);
 
-		if (atomic_read(&hardware_enable_failed)) {
+		if (atomic_read_unchecked(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
 			r = -EBUSY;
 		}
-- 
2.5.0
