From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:17 -0700
Message-Id: <1495829844-69341-14-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 13/20] drm/amdgpu: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The randstruct plugin requires structures that are entirely function
pointers be initialized using designated initializers.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index a4831fe0223b..a2c59a08b2bd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -220,9 +220,9 @@ static void amdgpu_vram_mgr_debug(struct ttm_mem_type_manager *man,
 }
 
 const struct ttm_mem_type_manager_func amdgpu_vram_mgr_func = {
-	amdgpu_vram_mgr_init,
-	amdgpu_vram_mgr_fini,
-	amdgpu_vram_mgr_new,
-	amdgpu_vram_mgr_del,
-	amdgpu_vram_mgr_debug
+	.init		= amdgpu_vram_mgr_init,
+	.takedown	= amdgpu_vram_mgr_fini,
+	.get_node	= amdgpu_vram_mgr_new,
+	.put_node	= amdgpu_vram_mgr_del,
+	.debug		= amdgpu_vram_mgr_debug
 };
-- 
2.7.4
