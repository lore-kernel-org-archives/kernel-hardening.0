From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] drm/amdkfd: Remove vla
Date: Tue, 10 Apr 2018 18:02:43 -0700
Message-Id: <20180411010243.17771-1-labbott@redhat.com>
To: Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Felix Kuehling <felix.kuehling@amd.com>
Cc: Laura Abbott <labbott@redhat.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. Switch to a constant value that covers all hardware.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switch to a larger size to account for other hardware
---
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
index 035c351f47c5..c3a5a80e31ae 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
@@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
 {
 	struct kfd_dev *dev = container_of(work, struct kfd_dev,
 						interrupt_work);
+	uint32_t ih_ring_entry[8];
 
-	uint32_t ih_ring_entry[DIV_ROUND_UP(
-				dev->device_info->ih_ring_entry_size,
-				sizeof(uint32_t))];
+	if (dev->device_info->ih_ring_entry_size > (8 * sizeof(uint32_t))) {
+		dev_err(kfd_chardev(), "Ring entry too small\n");
+		return;
+	}
 
 	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
 		dev->device_info->event_interrupt_class->interrupt_wq(dev,
-- 
2.14.3
