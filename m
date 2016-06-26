Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jun 2016 17:34:51 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160626173451.c8406cd0c7a87cc3f94d9753@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH] powerpc/kernel: Disable the latent entropy plugin
 unconditionally
To: keescook@chromium.org
Cc: mmarek@suse.com, linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/kernel/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 01935b8..e9ef44f 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -14,11 +14,12 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o         += -fPIC
 endif
 
-ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
 CFLAGS_REMOVE_cputable.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_prom_init.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
-- 
2.8.1
