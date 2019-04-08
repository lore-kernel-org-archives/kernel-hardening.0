Subject: Re: [PATCH v3 1/2] initmem: introduce CONFIG_INIT_ALL_MEMORY and
 CONFIG_INIT_ALL_STACK
References: <20190408170418.148554-1-glider@google.com>
 <20190408170418.148554-2-glider@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <adb23353-2e02-ecd2-7506-50f4db814b25@infradead.org>
Date: Mon, 8 Apr 2019 15:15:40 -0700
MIME-Version: 1.0
In-Reply-To: <20190408170418.148554-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>, yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/8/19 10:04 AM, Alexander Potapenko wrote:
> diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> new file mode 100644
> index 000000000000..5e49a55382ad
> --- /dev/null
> +++ b/security/Kconfig.initmem
> @@ -0,0 +1,29 @@
> +menu "Initialize all memory"
> +
> +config CC_HAS_AUTO_VAR_INIT
> +	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
> +
> +config INIT_ALL_MEMORY
> +	bool "Initialize all memory"
> +	default n
> +	help
> +	  Enforce memory initialization to mitigate infoleaks and make
> +	  the control-flow bugs depending on uninitialized values more
> +	  deterministic.
> +
> +if INIT_ALL_MEMORY
> +
> +config INIT_ALL_STACK
> +	bool "Initialize all stack"
> +	depends on INIT_ALL_MEMORY

This "depends on" is redundant with the "if INIT_ALL_MEMORY" above it.

Similar comment for patch 2/2 and INIT_ALL_HEAP.

> +	depends on CC_HAS_AUTO_VAR_INIT || (HAVE_GCC_PLUGINS && PLUGIN_HOSTCC != "")
> +	select GCC_PLUGINS if !CC_HAS_AUTO_VAR_INIT
> +	select GCC_PLUGIN_STRUCTLEAK if !CC_HAS_AUTO_VAR_INIT
> +	select GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if !CC_HAS_AUTO_VAR_INIT
> +	default y
> +	help
> +	  Initialize uninitialized stack data with a fixed pattern
> +	  (0x00 in GCC, 0xAA in Clang).
> +
> +endif # INIT_ALL_MEMORY
> +endmenu


-- 
~Randy
