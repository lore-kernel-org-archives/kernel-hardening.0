Return-Path: <SRS0=BrgD=CN=lists.openwall.com=kernel-hardening-return-19780-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A34C43461
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 04:46:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2AABB206D4
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 04:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imcxwRTM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AABB206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19780-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14142 invoked by uid 550); 4 Sep 2020 04:46:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14109 invoked from network); 4 Sep 2020 04:46:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fIdJ8K/Aacee+RqsVt362vFjI3E8b1TV5wIaem+g4eE=;
        b=imcxwRTMETM0cNDplgxnaQdVf2B6VSeIH7ATE/OFuKBy0A9mNAXYDsR21twrokhGj+
         c7MI0oXYWdz+fqk/CNlw18DocIg46Oc7Od5SZGaUmde4lp3ELU96RK92Xe/zP2e2dTKm
         if30YnYO5YMHq9MmJMq+arnj6/uAf0z3ooBp8GDRSooQEQVURWEwtOudL+jwiqz3BXsr
         NQpcjWVwHycVVytbUObg6bjnFNd8Q7TswPjAifm7UJ1TLWNgHuuN63QPKuUYt5hZxnyU
         JC0uMh0d4LjEfiOTj/DR9yOQPI0F/lWvAQIKoNkidF33GJ+oTy7bm6SWvTC7jRiAz1Tu
         ekwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIdJ8K/Aacee+RqsVt362vFjI3E8b1TV5wIaem+g4eE=;
        b=cF8d/pTJ5btEbgP6hFy4KIDvIZzd6+pKtE3h1Px4tKSHjn6fAx5dnMjefSMs7DoQiS
         mmnZnyuvks0pk2vZmTbzEJLbttq8klKxqukAlcyVBkwdJ3IIJ2e2FY8z64ik1G5caKl7
         MZ7waFK/+t7j7LtuKkwxUbUkSgkK2ZSEvSBh26hM/YzfA7MkyNJTysmn8EwwIr7GcxVR
         M+0NGS7uHQt7+Tls4P2eswF4t3jnKGzMKyACKMJ9laFC40Ftrs/VZUkQZvtAp8BDVeB+
         2BpiqmtHDTnrSZkvif/Zbi+wB8MBLp6YY4mlGh3M9mEx8npv/7L/bTN4B5QxM+PmN9aZ
         fgeA==
X-Gm-Message-State: AOAM533/zRBZz+EK7iuszpcJPWn/Mq6gKoHwQLGATII4dlIXxIj4sO0/
	P457vgsX3cHBd9Gx1vawQ1Y=
X-Google-Smtp-Source: ABdhPJyVY/QnceVf6t1BnFLVgl5ErTIRweh4BrtmfbmPBrNdvUnbmBxehmWkmXRCx7fcf00x3AEhzQ==
X-Received: by 2002:ae9:e70b:: with SMTP id m11mr4069627qka.210.1599194761810;
        Thu, 03 Sep 2020 21:46:01 -0700 (PDT)
Date: Thu, 3 Sep 2020 21:45:59 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
Message-ID: <20200904044559.GA507165@ubuntu-n2-xlarge-x86>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <202009031557.4A233A17F1@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031557.4A233A17F1@keescook>

On Thu, Sep 03, 2020 at 04:34:09PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:25PM -0700, Sami Tolvanen wrote:
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> 
> Tested-by: Kees Cook <keescook@chromium.org>

Tested-by: Nathan Chancellor <natechancellor@gmail.com>

I have been continuously running this series on virtualized x86_64 (WSL2
on my home workstation) and bare metal arm64 (Raspberry Pi 4) with no
major issues or regressions noticed.

> FWIW, this gives me a happy booting x86 kernel:
> 
> # cat /proc/version 
> Linux version 5.9.0-rc3+ (kees@amarok) (clang version 12.0.0 (https://github.com/llvm/llvm-project.git db1ec04963cce70f2593e58cecac55f2e6accf52), LLD 12.0.0 (https://github.com/llvm/llvm-project.git db1ec04963cce70f2593e58cecac55f2e6accf52)) #1 SMP Thu Sep 3 15:54:14 PDT 2020
> # zgrep 'LTO[_=]' /proc/config.gz
> CONFIG_LTO=y
> CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
> CONFIG_ARCH_SUPPORTS_THINLTO=y
> CONFIG_THINLTO=y
> # CONFIG_LTO_NONE is not set
> CONFIG_LTO_CLANG=y
> 
> I'd like to find a way to get this series landing sanely. It has
> dependencies on fixes/features in a few trees, and it looks like
> it's been difficult to keep forward momentum on LTO while trying to
> simultaneously chase changes in those trees, especially since it means
> no one care carry LTO in -next without shared branches. To that end,
> I'd like to find a way forward where Sami doesn't have to keep carrying
> a couple dozen patches. :)
> 
> The fixes/features outside of, or partially overlapping, Masahiro's
> kbuild tree appear to be:
> 
> [PATCH v2 01/28] x86/boot/compressed: Disable relocation relaxation
> [PATCH v2 02/28] x86/asm: Replace __force_order with memory clobber
> [PATCH v2 03/28] lib/string.c: implement stpcpy
> [PATCH v2 04/28] RAS/CEC: Fix cec_init() prototype
> [PATCH v2 05/28] objtool: Add a pass for generating __mcount_loc
> [PATCH v2 06/28] objtool: Don't autodetect vmlinux.o
> [PATCH v2 07/28] kbuild: add support for objtool mcount
> [PATCH v2 08/28] x86, build: use objtool mcount
> [PATCH v2 17/28] PCI: Fix PREL32 relocations for LTO
> [PATCH v2 20/28] efi/libstub: disable LTO
> [PATCH v2 21/28] drivers/misc/lkdtm: disable LTO for rodata.o
> [PATCH v2 22/28] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
> [PATCH v2 23/28] arm64: vdso: disable LTO 
> [PATCH v2 24/28] KVM: arm64: disable LTO for the nVHE directory
> [PATCH v2 25/28] arm64: allow LTO_CLANG and THINLTO to be selected
> [PATCH v2 26/28] x86, vdso: disable LTO only for vDSO
> [PATCH v2 27/28] x86, relocs: Ignore L4_PAGE_OFFSET relocations
> [PATCH v2 28/28] x86, build: allow LTO_CLANG and THINLTO to be selected
> 
> The distinctly kbuild patches are:
> 
> [PATCH v2 09/28] kbuild: add support for Clang LTO
> [PATCH v2 10/28] kbuild: lto: fix module versioning
> [PATCH v2 11/28] kbuild: lto: postpone objtool
> [PATCH v2 12/28] kbuild: lto: limit inlining
> [PATCH v2 13/28] kbuild: lto: merge module sections
> [PATCH v2 14/28] kbuild: lto: remove duplicate dependencies from .mod files
> [PATCH v2 15/28] init: lto: ensure initcall ordering
> [PATCH v2 16/28] init: lto: fix PREL32 relocations
> [PATCH v2 18/28] modpost: lto: strip .lto from module names
> [PATCH v2 19/28] scripts/mod: disable LTO for empty.c
> 
> Patch 3 is in -mm and I expect it will land in the next rc (I hope,
> since it's needed universally for Clang builds).
> 
> Patch 4 is living in -tip, to appear shortly in -next, AFAICT?
> 
> I would expect 1 and 2 to appear in -tip soon, but I'm not sure?
> 
> For patches 5, 6, 7, and 8 I would expect them to normally go via -tip's
> objtool tree, but getting an Ack would let them land elsewhere.
> 
> Patch 17 I'd expect to normally go via Bjorn's tree, but he's given an
> Ack so it can live elsewhere without surprises. :)
> 
> Patches 19, 20, 21, 23, 24, 26 are all simple "just disable LTO"
> patches.
> 
> This leaves 9-16 and 18. Patches 10, 12, 14, 16, and 18 seem mostly
> "mechanical" in nature, leaving the bulk of the review on patches 9,
> 11, 13, and 15.
> 
> Masahiro, given the spread of dependent patches between 2 (or more?) -tip
> branches and -mm, how do you want to proceed? I wonder if it might
> be possible to create a shared branch to avoid merge headaches, and I
> (or -tip folks, or you) could carry patches 1-8 there so patches 9 and
> later could have a common base?
> 
> Thanks!
> 
> -- 
> Kees Cook
> 

For what it's worth, the static call series that is in -tip and about to
land in -next conflicts relatively heavy with this. There are fairly
innocuous conflicts in some objtool files but two contextual changes
are needed to keep things building. It probably makes sense for most if
not all of this to live in -tip with acks. Ideally, if the stpcpy patch
gets merged into an -rc, this can just be based on that.

check.c:556:80: error: too few arguments to function call, expected 5, have 4
        sec = elf_create_section(file->elf, "__mcount_loc", sizeof(unsigned long), idx);
              ~~~~~~~~~~~~~~~~~~                                                      ^
./elf.h:124:17: note: 'elf_create_section' declared here
struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
                ^
1 error generated.

kernel/static_call.c:438:16: error: returning 'void' from a function with incompatible result type 'int'
early_initcall(static_call_init);
~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
include/linux/init.h:268:47: note: expanded from macro 'early_initcall'
#define early_initcall(fn)              __define_initcall(fn, early)
                                        ~~~~~~~~~~~~~~~~~~^~~~~~~~~~
include/linux/init.h:261:54: note: expanded from macro '__define_initcall'
#define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
                                  ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
include/linux/init.h:259:20: note: expanded from macro '___define_initcall'
        __unique_initcall(fn, id, __sec, __initcall_id(fn))
        ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/init.h:253:22: note: expanded from macro '__unique_initcall'
        ____define_initcall(fn,                                 \
        ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/init.h:241:33: note: expanded from macro '____define_initcall'
        __define_initcall_stub(__stub, fn)                      \
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
include/linux/init.h:226:10: note: expanded from macro '__define_initcall_stub'
                return fn();                                    \
                       ^~~~
1 error generated.

Below is what I ended up with for fixes.

Cheers,
Nathan

diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index bfa2ba39be57..61034e9798d6 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -136,7 +136,7 @@ extern void arch_static_call_transform(void *site, void *tramp, void *func, bool
 
 #ifdef CONFIG_HAVE_STATIC_CALL_INLINE
 
-extern void __init static_call_init(void);
+extern int __init static_call_init(void);
 
 struct static_call_mod {
 	struct static_call_mod *next;
diff --git a/kernel/static_call.c b/kernel/static_call.c
index f8362b3f8fd5..84565c2a41b8 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -410,12 +410,12 @@ int static_call_text_reserved(void *start, void *end)
 	return __static_call_mod_text_reserved(start, end);
 }
 
-void __init static_call_init(void)
+int __init static_call_init(void)
 {
 	int ret;
 
 	if (static_call_initialized)
-		return;
+		return 0;
 
 	cpus_read_lock();
 	static_call_lock();
@@ -434,6 +434,7 @@ void __init static_call_init(void)
 #ifdef CONFIG_MODULES
 	register_module_notifier(&static_call_module_nb);
 #endif
+	return 0;
 }
 early_initcall(static_call_init);
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d31554adcf4e..34db58110f3d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -553,7 +553,7 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node)
 		idx++;
 
-	sec = elf_create_section(file->elf, "__mcount_loc", sizeof(unsigned long), idx);
+	sec = elf_create_section(file->elf, "__mcount_loc", 0, sizeof(unsigned long), idx);
 	if (!sec)
 		return -1;
 
