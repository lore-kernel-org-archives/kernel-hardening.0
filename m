Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Apr 2016 20:23:53 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160422202353.5e12aca6e8f8392444ebc770@gmail.com>
In-Reply-To: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v7 3/6] The GCC plugin infrastructure supports the arm and
 arm64 architectures too
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

The GCC plugin infrastructure supports the arm and arm64 architectures too

Signed-off-by: David Brown <david.brown@linaro.org>
---
 arch/arm/Kconfig   | 1 +
 arch/arm64/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0846026..8f57eb6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -55,6 +55,7 @@ config ARM
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c8762f4..33f30f6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -76,6 +76,7 @@ config ARM64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-- 
2.4.1
