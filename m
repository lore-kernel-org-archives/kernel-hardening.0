From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] drm/amdkfd: Remove vla
Date: Mon,  9 Apr 2018 14:06:20 -0700
Message-Id: <20180409210620.3647-1-labbott@redhat.com>
To: Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Cc: Laura Abbott <labbott@redhat.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. The single VLA usage in the amdkfd driver is actually
constant across all current platforms. Switch to a constant size array
instead.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
index 035c351f47c5..c9863858f343 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
@@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
 {
 	struct kfd_dev *dev = container_of(work, struct kfd_dev,
 						interrupt_work);
+	uint32_t ih_ring_entry[4];
 
-	uint32_t ih_ring_entry[DIV_ROUND_UP(
-				dev->device_info->ih_ring_entry_size,
-				sizeof(uint32_t))];
+	if (dev->device_info->ih_ring_entry_size > (4 * sizeof(uint32_t))) {
+		dev_err(kfd_chardev(), "Ring entry too small\n");
+		return;
+	}
 
 	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
 		dev->device_info->event_interrupt_class->interrupt_wq(dev,
-- 
2.14.3
