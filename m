Return-Path: <SRS0=KQHT=BB=lists.openwall.com=kernel-hardening-return-19402-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE990C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 09:27:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 28E15206D7
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 09:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28E15206D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19402-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5748 invoked by uid 550); 22 Jul 2020 09:27:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5724 invoked from network); 22 Jul 2020 09:27:42 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Wed, 22 Jul 2020 11:27:30 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
References: <20200717170008.5949-1-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Let me CC live-patching ML, because from a quick glance this is something 
which could impact live patching code. At least it invalidates assumptions 
which "sympos" is based on.

Miroslav

On Fri, 17 Jul 2020, Kristen Carlson Accardi wrote:

> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
> ---------------------------------------------------------------------
> 
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.

[...]

> Background
> ----------
> KASLR was merged into the kernel with the objective of increasing the
> difficulty of code reuse attacks. Code reuse attacks reused existing code
> snippets to get around existing memory protections. They exploit software bugs
> which expose addresses of useful code snippets to control the flow of
> execution for their own nefarious purposes. KASLR moves the entire kernel
> code text as a unit at boot time in order to make addresses less predictable.
> The order of the code within the segment is unchanged - only the base address
> is shifted. There are a few shortcomings to this algorithm.
> 
> 1. Low Entropy - there are only so many locations the kernel can fit in. This
>    means an attacker could guess without too much trouble.
> 2. Knowledge of a single address can reveal the offset of the base address,
>    exposing all other locations for a published/known kernel image.
> 3. Info leaks abound.
> 
> Finer grained ASLR has been proposed as a way to make ASLR more resistant
> to info leaks. It is not a new concept at all, and there are many variations
> possible. Function reordering is an implementation of finer grained ASLR
> which randomizes the layout of an address space on a function level
> granularity. We use the term "fgkaslr" in this document to refer to the
> technique of function reordering when used with KASLR, as well as finer grained
> KASLR in general.
> 
> Proposed Improvement
> --------------------
> This patch set proposes adding function reordering on top of the existing
> KASLR base address randomization. The over-arching objective is incremental
> improvement over what we already have. It is designed to work in combination
> with the existing solution. The implementation is really pretty simple, and
> there are 2 main area where changes occur:
> 
> * Build time
> 
> GCC has had an option to place functions into individual .text sections for
> many years now. This option can be used to implement function reordering at
> load time. The final compiled vmlinux retains all the section headers, which
> can be used to help find the address ranges of each function. Using this
> information and an expanded table of relocation addresses, individual text
> sections can be suffled immediately after decompression. Some data tables
> inside the kernel that have assumptions about order require re-sorting
> after being updated when applying relocations. In order to modify these tables,
> a few key symbols are excluded from the objcopy symbol stripping process for
> use after shuffling the text segments.
> 
> Some highlights from the build time changes to look for:
> 
> The top level kernel Makefile was modified to add the gcc flag if it
> is supported. Currently, I am applying this flag to everything it is
> possible to randomize. Anything that is written in C and not present in a
> special input section is randomized. The final binary segment 0 retains a
> consolidated .text section, as well as all the individual .text.* sections.
> Future work could turn off this flags for selected files or even entire
> subsystems, although obviously at the cost of security.
> 
> The relocs tool is updated to add relative relocations. This information
> previously wasn't included because it wasn't necessary when moving the
> entire .text segment as a unit. 
> 
> A new file was created to contain a list of symbols that objcopy should
> keep. We use those symbols at load time as described below.
> 
> * Load time
> 
> The boot kernel was modified to parse the vmlinux elf file after
> decompression to check for our interesting symbols that we kept, and to
> look for any .text.* sections to randomize. The consolidated .text section
> is skipped and not moved. The sections are shuffled randomly, and copied
> into memory following the .text section in a new random order. The existing
> code which updated relocation addresses was modified to account for
> not just a fixed delta from the load address, but the offset that the function
> section was moved to. This requires inspection of each address to see if
> it was impacted by a randomization. We use a bsearch to make this less
> horrible on performance. Any tables that need to be modified with new
> addresses or resorted are updated using the symbol addresses parsed from the
> elf symbol table.
> 
> In order to hide our new layout, symbols reported through /proc/kallsyms
> will be displayed in a random order.
> 
> Security Considerations
> -----------------------
> The objective of this patch set is to improve a technology that is already
> merged into the kernel (KASLR). This code will not prevent all attacks,
> but should instead be considered as one of several tools that can be used.
> In particular, this code is meant to make KASLR more effective in the presence
> of info leaks.
> 
> How much entropy we are adding to the existing entropy of standard KASLR will
> depend on a few variables. Firstly and most obviously, the number of functions
> that are randomized matters. This implementation keeps the existing .text
> section for code that cannot be randomized - for example, because it was
> assembly code. The less sections to randomize, the less entropy. In addition,
> due to alignment (16 bytes for x86_64), the number of bits in a address that
> the attacker needs to guess is reduced, as the lower bits are identical.

[...]

> Modules
> -------
> Modules are randomized similarly to the rest of the kernel by shuffling
> the sections at load time prior to moving them into memory. The module must
> also have been build with the -ffunction-sections compiler option.
> 
> Although fgkaslr for the kernel is only supported for the X86_64 architecture,
> it is possible to use fgkaslr with modules on other architectures. To enable
> this feature, select
> 
> CONFIG_MODULE_FG_KASLR=y
> 
> This option is selected automatically for X86_64 when CONFIG_FG_KASLR is set.
> 
> Disabling
> ---------
> Disabling normal KASLR using the nokaslr command line option also disables
> fgkaslr. It is also possible to disable fgkaslr separately by booting with
> fgkaslr=off on the commandline.
