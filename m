From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv3] drm/amdkfd: Remove vla
Date: Fri, 13 Apr 2018 14:24:12 -0700
Message-Id: <20180413212412.18205-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Felix Kuehling <felix.kuehling@amd.com>
Cc: Laura Abbott <labbott@redhat.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. Switch to a constant value that covers all hardware.

[1] https://lkml.org/lkml/2018/3/7/621

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v3: Introduced a #define for the max value, switched to pr_err_once to
avoid log flood, switched to sizeof(array) per private suggestion.
---
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h      | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
index 035c351f47c5..db6d9336b80d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
@@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
 {
 	struct kfd_dev *dev = container_of(work, struct kfd_dev,
 						interrupt_work);
+	uint32_t ih_ring_entry[KFD_MAX_RING_ENTRY_SIZE];
 
-	uint32_t ih_ring_entry[DIV_ROUND_UP(
-				dev->device_info->ih_ring_entry_size,
-				sizeof(uint32_t))];
+	if (dev->device_info->ih_ring_entry_size > sizeof(ih_ring_entry)) {
+		dev_err_once(kfd_chardev(), "Ring entry too small\n");
+		return;
+	}
 
 	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
 		dev->device_info->event_interrupt_class->interrupt_wq(dev,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 96a9cc0f02c9..a90db05dfe61 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -39,6 +39,8 @@
 
 #include "amd_shared.h"
 
+#define KFD_MAX_RING_ENTRY_SIZE	8
+
 #define KFD_SYSFS_FILE_MODE 0444
 
 #define KFD_MMAP_DOORBELL_MASK 0x8000000000000ull
-- 
2.14.3
