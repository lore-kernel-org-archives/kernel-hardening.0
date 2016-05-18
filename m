Reply-To: kernel-hardening@lists.openwall.com
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
 <20160513015725.30223ee16a2a3860b4392b90@gmail.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Message-ID: <573C2CFE.8060305@au1.ibm.com>
Date: Wed, 18 May 2016 18:51:10 +1000
MIME-Version: 1.0
In-Reply-To: <20160513015725.30223ee16a2a3860b4392b90@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 13/05/16 09:57, Emese Revfy wrote:
> This patch allows to build the whole kernel with GCC plugins. It was ported from
> grsecurity/PaX. The infrastructure supports building out-of-tree modules and
> building in a separate directory. Cross-compilation is supported too.
> Currently the x86, arm, arm64 and uml architectures enable plugins.
>
> The directory of the gcc plugins is scripts/gcc-plugins. You can use a file or a directory
> there. The plugins compile with these options:
>   * -fno-rtti: gcc is compiled with this option so the plugins must use it too
>   * -fno-exceptions: this is inherited from gcc too
>   * -fasynchronous-unwind-tables: this is inherited from gcc too
>   * -ggdb: it is useful for debugging a plugin (better backtrace on internal
>      errors)
>   * -Wno-narrowing: to suppress warnings from gcc headers (ipa-utils.h)
>   * -Wno-unused-variable: to suppress warnings from gcc headers (gcc_version
>      variable, plugin-version.h)
>
> The infrastructure introduces a new Makefile target called gcc-plugins. It
> supports all gcc versions from 4.5 to 6.0. The scripts/gcc-plugin.sh script
> chooses the proper host compiler (gcc-4.7 can be built by either gcc or g++).
> This script also checks the availability of the included headers in
> scripts/gcc-plugins/gcc-common.h.
>
> The gcc-common.h header contains frequently included headers for GCC plugins
> and it has a compatibility layer for the supported gcc versions.
>
> The gcc-generate-*-pass.h headers automatically generate the registration
> structures for GIMPLE, SIMPLE_IPA, IPA and RTL passes.
>
> Note that 'make clean' keeps the *.so files (only the distclean or mrproper
> targets clean all) because they are needed for out-of-tree modules.
>
> The arm and arm64 architectures were tested by David Brown <david.brown@linaro.org>.
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

I've done some basic sanity testing on powerpc with the cyclomatic 
complexity plugin (with LE native + cross-compilers) and it seems to 
work with the patch below.

Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a18a0dc..0cfed5b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -97,6 +97,7 @@ config PPC
         select HAVE_DYNAMIC_FTRACE_WITH_REGS if MPROFILE_KERNEL
         select HAVE_FUNCTION_TRACER
         select HAVE_FUNCTION_GRAPH_TRACER
+       select HAVE_GCC_PLUGINS
         select SYSCTL_EXCEPTION_TRACE
         select ARCH_WANT_OPTIONAL_GPIOLIB
         select VIRT_TO_BUS if !PPC64

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
