Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 9 Mar 2016 02:01:15 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160309090115.GA6964@davidb.org>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
 <20160307000427.c82f18670568e1e656fc9532@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20160307000427.c82f18670568e1e656fc9532@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v5 2/5] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 07, 2016 at 12:04:27AM +0100, Emese Revfy wrote:

>This patch allows to build the whole kernel with GCC plugins. It was ported from
>grsecurity/PaX. The infrastructure supports building out-of-tree modules and
>building in a separate directory. Cross-compilation is supported too but
>currently only the x86 architecture enables plugins.

I've tested this with both ARM and ARM64.  There are some missing
headers in the arm64 gcc, reported here:
https://bugs.linaro.org/show_bug.cgi?id=2123 (also upstream), but this
should work once that is fixed.

Feel free to fold these into your patch, or, if you prefer, I can send
out separate patches for them.

Signed-off-by: David Brown <david.brown@linaro.org>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4f799e5..67ee8e3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -54,6 +54,7 @@ config ARM
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8cc6228..6d6e4f8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -70,6 +70,7 @@ config ARM64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-- 
