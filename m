Return-Path: <SRS0=2wHG=7D=lists.openwall.com=kernel-hardening-return-18850-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41500C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:33:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 582FC204EA
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ON7xsWQ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 582FC204EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18850-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16240 invoked by uid 550); 21 May 2020 21:33:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16217 invoked from network); 21 May 2020 21:33:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f7SOHt7sxysbQhISuJcL8sq3HGKnb8Oi+mcD6TRvFU0=;
        b=ON7xsWQ5i9dYvWU2OO54F/ZfavtKBw/51WPEks46T0Ud0ynraAJkqChU42w+tWjRLj
         lb/zWhD+/iN3A2S9vM2I2aUo/Nhvf5CtahLC1pRsFmoLlLBp76vNPaH+Lue2/EOzY3y9
         tWmTpTxVoYRZpvmUxSXAScutuF/nenCsIiRms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f7SOHt7sxysbQhISuJcL8sq3HGKnb8Oi+mcD6TRvFU0=;
        b=oh/u5NTjmk8ZAnZiAfjZxdlYWwJ1eADfECyN0UVHnR+EAMVeiqso/uUQ+iItplQ82V
         ItP0Yl/eYZ5CIOiWPS9x0eF66ik0jB4fhJJaSc3cY3ra/70wJMDu6HkZFfBULu3T2OAO
         Jk0QLbiNRCWx7/7Qyo0pn08QO/Uh/Loa1upI/bYXzCgUVS+UzHLXmn9lQcQjNLaBzTzY
         l9AFaEX6kxkOHhc3/85zn660RGdrfGDTnegpuKxC2zKJjGwlPofs5PVPV1PcfNizLzOc
         SrRuhLKEthek14IC+oReqCVxu71Xmrx7gxC17quCQahREWlYIYgTidUGM7Ehk2RQqySe
         vGPg==
X-Gm-Message-State: AOAM532VqNz3W4tMqQLZQIjF4VZ+ZSolbfCUK8X9SzZWAWjnWg7IpJBh
	Y9+aoHTIzaSDcZGNy0HU1W+J0w==
X-Google-Smtp-Source: ABdhPJwuoTJfwmQictWCcNULrGfSKV3uQsQu0LZOMukycdi47y0GpBRiBq/zJ7+nwPPAW13xpc9BmA==
X-Received: by 2002:a17:902:b217:: with SMTP id t23mr8920844plr.183.1590096805141;
        Thu, 21 May 2020 14:33:25 -0700 (PDT)
Date: Thu, 21 May 2020 14:33:22 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Ard Biesheuvel <ardb@kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 9/9] module: Reorder functions
Message-ID: <202005211415.5A1ECC638@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
 <20200521165641.15940-10-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521165641.15940-10-kristen@linux.intel.com>

On Thu, May 21, 2020 at 09:56:40AM -0700, Kristen Carlson Accardi wrote:
> Introduce a new config option to allow modules to be re-ordered
> by function. This option can be enabled independently of the
> kernel text KASLR or FG_KASLR settings so that it can be used
> by architectures that do not support either of these features.
> This option will be selected by default if CONFIG_FG_KASLR is
> selected.
> 
> If a module has functions split out into separate text sections
> (i.e. compiled with the -ffunction-sections flag), reorder the
> functions to provide some code diversification to modules.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Tested-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/Kconfig  |  1 +
>  arch/x86/Makefile |  3 ++
>  init/Kconfig      | 11 +++++++
>  kernel/module.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 96 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 50e83ea57d70..d0bdd5c8c432 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2187,6 +2187,7 @@ config FG_KASLR
>  	bool "Function Granular Kernel Address Space Layout Randomization"
>  	depends on $(cc-option, -ffunction-sections)
>  	depends on RANDOMIZE_BASE && X86_64
> +	select MODULE_FG_KASLR
>  	help
>  	  This option improves the randomness of the kernel text
>  	  over basic Kernel Address Space Layout Randomization (KASLR)
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index b65ec63c7db7..8c830c37c74c 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -51,6 +51,9 @@ ifdef CONFIG_X86_NEED_RELOCS
>          LDFLAGS_vmlinux := --emit-relocs --discard-none
>  endif
>  
> +ifdef CONFIG_MODULE_FG_KASLR
> +	KBUILD_CFLAGS_MODULE += -ffunction-sections
> +endif

With CONFIG_FG_KASLR=y, will -ffunction-sections appear twice on the
compiler command line?

>  #
>  # Prevent GCC from generating any FP code by mistake.
>  #
> diff --git a/init/Kconfig b/init/Kconfig
> index 74a5ac65644f..b19920413bcc 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2227,6 +2227,17 @@ config UNUSED_KSYMS_WHITELIST
>  	  one per line. The path can be absolute, or relative to the kernel
>  	  source tree.
>  
> +config MODULE_FG_KASLR

Oh, er, yes. I'd suggested moving 'config FG_KASLR' into arch/Kconfig,
but I think init/Kconfig is more correct.

> +	depends on $(cc-option, -ffunction-sections)

Oh! And I am reminded suddenly about CONFIG_FG_KASLR needing to interact
correctly with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION in that we do NOT
want the sections to be collapsed at link time:

#ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*

(I think I had fixed this in some earlier version?)

I think you want this (untested):


diff --git a/Makefile b/Makefile
index 04f5662ae61a..a0d9acd3b900 100644
--- a/Makefile
+++ b/Makefile
@@ -853,8 +853,11 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
+ifneq ($(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION)$(CONFIG_FG_KASLR),)
+KBUILD_CFLAGS_KERNEL += -ffunction-sections
+endif
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
-KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
+KBUILD_CFLAGS_KERNEL += -fdata-sections
 LDFLAGS_vmlinux += --gc-sections
 endif
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 71e387a5fe90..5f5c692751dd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -93,20 +93,31 @@
  * sections to be brought in with rodata.
  */
 #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
-#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
 #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
 #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
 #else
-#define TEXT_MAIN .text
 #define DATA_MAIN .data
 #define SDATA_MAIN .sdata
 #define RODATA_MAIN .rodata
 #define BSS_MAIN .bss
 #define SBSS_MAIN .sbss
 #endif
+/*
+ * Both LD_DEAD_CODE_DATA_ELIMINATION and CONFIG_FG_KASLR options enable
+ * -ffunction-sections, which produces separately named .text sections. In
+ * the case of CONFIG_FG_KASLR, they need to stay distinct so they can be
+ * separately randomized. Without CONFIG_FG_KASLR, the separate .text
+ * sections can be collected back into a common section, which makes the
+ * resulting image slightly smaller.
+ */
+#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) && !defined(CONFIG_FG_KASLR)
+#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
+#else
+#define TEXT_MAIN .text
+#endif
 
 /*
  * Align to a 32 byte boundary equal to the


> +	bool "Module Function Granular Layout Randomization"
> +	help
> +	  This option randomizes the module text section by reordering the text
> +	  section by function at module load time. In order to use this
> +	  feature, the module must have been compiled with the
> +	  -ffunction-sections compiler flag.
> +
> +	  If unsure, say N.
> +
>  endif # MODULES
>  
>  config MODULES_TREE_LOOKUP
> diff --git a/kernel/module.c b/kernel/module.c
> index 646f1e2330d2..e3cd619c60c2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -53,6 +53,7 @@
>  #include <linux/bsearch.h>
>  #include <linux/dynamic_debug.h>
>  #include <linux/audit.h>
> +#include <linux/random.h>
>  #include <uapi/linux/module.h>
>  #include "module-internal.h"
>  
> @@ -2370,6 +2371,83 @@ static long get_offset(struct module *mod, unsigned int *size,
>  	return ret;
>  }
>  
> +/*
> + * shuffle_text_list()
> + * Use a Fisher Yates algorithm to shuffle a list of text sections.
> + */
> +static void shuffle_text_list(Elf_Shdr **list, int size)
> +{
> +	int i;
> +	unsigned int j;
> +	Elf_Shdr *temp;
> +
> +	for (i = size - 1; i > 0; i--) {
> +		/*
> +		 * pick a random index from 0 to i
> +		 */
> +		get_random_bytes(&j, sizeof(j));
> +		j = j % (i + 1);
> +
> +		temp = list[i];
> +		list[i] = list[j];
> +		list[j] = temp;
> +	}
> +}
> +
> +/*
> + * randomize_text()
> + * Look through the core section looking for executable code sections.
> + * Store sections in an array and then shuffle the sections
> + * to reorder the functions.
> + */
> +static void randomize_text(struct module *mod, struct load_info *info)
> +{
> +	int i;
> +	int num_text_sections = 0;
> +	Elf_Shdr **text_list;
> +	int size = 0;
> +	int max_sections = info->hdr->e_shnum;
> +	unsigned int sec = find_sec(info, ".text");
> +
> +	if (sec == 0)
> +		return;
> +
> +	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
> +	if (!text_list)
> +		return;
> +
> +	for (i = 0; i < max_sections; i++) {
> +		Elf_Shdr *shdr = &info->sechdrs[i];
> +		const char *sname = info->secstrings + shdr->sh_name;
> +
> +		if (!(shdr->sh_flags & SHF_ALLOC) ||
> +		    !(shdr->sh_flags & SHF_EXECINSTR) ||
> +		    strstarts(sname, ".init"))
> +			continue;
> +
> +		text_list[num_text_sections] = shdr;
> +		num_text_sections++;
> +	}
> +
> +	shuffle_text_list(text_list, num_text_sections);
> +
> +	for (i = 0; i < num_text_sections; i++) {
> +		Elf_Shdr *shdr = text_list[i];
> +
> +		/*
> +		 * get_offset has a section index for it's last
> +		 * argument, that is only used by arch_mod_section_prepend(),
> +		 * which is only defined by parisc. Since this this type
> +		 * of randomization isn't supported on parisc, we can
> +		 * safely pass in zero as the last argument, as it is
> +		 * ignored.
> +		 */
> +		shdr->sh_entsize = get_offset(mod, &size, shdr, 0);
> +	}
> +
> +	kfree(text_list);
> +}
> +
>  /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
>     might -- code, read-only data, read-write data, small data.  Tally
>     sizes, and place the offsets into sh_entsize fields: high bit means it
> @@ -2460,6 +2538,9 @@ static void layout_sections(struct module *mod, struct load_info *info)
>  			break;
>  		}
>  	}
> +
> +	if (IS_ENABLED(CONFIG_MODULE_FG_KASLR))
> +		randomize_text(mod, info);
>  }
>  
>  static void set_license(struct module *mod, const char *license)
> -- 
> 2.20.1
> 

Everything else looks good.

-- 
Kees Cook
