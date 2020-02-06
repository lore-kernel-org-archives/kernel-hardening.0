Return-Path: <SRS0=0ziS=32=lists.openwall.com=kernel-hardening-return-17697-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED7DC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:52:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B658C206CC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZm3loSm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B658C206CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17697-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7203 invoked by uid 550); 6 Feb 2020 11:52:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28340 invoked from network); 6 Feb 2020 00:11:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lgPcWN6p4BNWezBrExW07TYU0pjpDkLuT/nBxzOZrKA=;
        b=FZm3loSmtEtdI+DdMSAgDRDm+Jd48ZowxczIdHgOH5dA0c83sDS1FoMpCvBqy0NUqA
         EmRu9QAJnbtcLKy7nXG5UD53hxuphg34JWubJG0bvLpAPGflkb/c5J7A1jKIrAMaYy5Z
         RsY0Ye5PqCWkfct+8jOZ4kZ0L0D9A34dXt9oIU7RLz5QoWJgAc6LRew87bvMWfeQlFu2
         20r3KwqcBwuytwRx7bZwHh9Yb0yuuIR4L5JUS/7UTjfrAKv3YbHxvtdS3lAExTFejDOO
         JvIzkW1ETXFyEhZcdyNT/7SsUScT9+vr6+8K+DNWkYVh3EmBBFZKFsIR2zWILfvxTZv6
         Nq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lgPcWN6p4BNWezBrExW07TYU0pjpDkLuT/nBxzOZrKA=;
        b=fhmF5k/5KMAZXWcxD1LN44jj+RCx7KyVru6h4pnkBC/ppPMHPDKnnJYBYvk7hnfmHU
         wb2jG81f1HX9YrQYDdmDfvUpJ1NZHKyyPZ4gPXZMYgMU88/bXWcgN0hIWWQZRNEyq6Xx
         rEOAhwUC0BsSVwIOumRmeY4dVSZp5EvqAMMgKpZ9/HPO4T61I4P7eVwH0jOg92bkVN9l
         6ZwZTjV5vJsBiiFaFIAJ50jPDz7KINPL6/InS4ZIM8ssZ0C9piCdaMkD2k8hjzFxrzDb
         aHvoTQTRU3kah7wM7Mqt4AHGKHWU1ckK3EIlbptu383KhFf5w1EEO3UOmU3TBgrExnfK
         cfzQ==
X-Gm-Message-State: APjAAAWCJuSEgSKqONS2P7JTEuisgNUjz8PkU2ytn/PpEb1I/qyi55e5
	T/myzBkZTAbLWHSQCzuX/Mg=
X-Google-Smtp-Source: APXvYqwDez+Un50bofg+Wk1zEled7Z4nrnGOfoeixEFm5urAG/JQsfgr2621Qql8DOqVbaEr6SZBhQ==
X-Received: by 2002:ac8:7443:: with SMTP id h3mr342700qtr.202.1580947867401;
        Wed, 05 Feb 2020 16:11:07 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Wed, 5 Feb 2020 19:11:05 -0500
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 11/11] x86/boot: Move "boot heap" out of .bss
Message-ID: <20200206001103.GA220377@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-12-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-12-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2020 at 02:39:50PM -0800, Kristen Carlson Accardi wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> Currently the on-disk decompression image includes the "dynamic" heap
> region that is used for malloc() during kernel extraction, relocation,
> and decompression ("boot_heap" of BOOT_HEAP_SIZE bytes in the .bss
> section). It makes no sense to balloon the bzImage with "boot_heap"
> as it is zeroed at boot, and acts much more like a "brk" region.
> 
> This seems to be a trivial change because head_{64,32}.S already only
> copies up to the start of the .bss section, so any growth in the .bss
> area was already not meaningful when placing the image in memory. The
> .bss size is, however, reflected in the boot params "init_size", so the
> memory range calculations included the "boot_heap" region. Instead of
> wasting the on-disk image size bytes, just account for this heap area
> when identifying the mem_avoid ranges, and leave it out of the .bss
> section entirely. For good measure, also zero initialize it, as this
> was already happening for when zeroing the entire .bss section.
> 
> While the bzImage size is dominated by the compressed vmlinux, the
> difference removes 64KB for all compressors except bzip2, which removes
> 4MB. For example, this is less than 1% under CONFIG_KERNEL_XZ:
> 
> -rw-r--r-- 1 kees kees 7813168 Feb  2 23:39 arch/x86/boot/bzImage.stock-xz
> -rw-r--r-- 1 kees kees 7747632 Feb  2 23:42 arch/x86/boot/bzImage.brk-xz
> 
> but much more pronounced under CONFIG_KERNEL_BZIP2 (~27%):
> 
> -rw-r--r-- 1 kees kees 15231024 Feb  2 23:44 arch/x86/boot/bzImage.stock-bzip2
> -rw-r--r-- 1 kees kees 11036720 Feb  2 23:47 arch/x86/boot/bzImage.brk-bzip2
> 
> For the future fine-grain KASLR work, this will avoid significant pain,
> as the ELF section parser will use much more memory during boot and
> filling the bzImage with megabytes of zeros seemed like a poor idea. :)
> 

I'm not sure I follow this: the reason the bzImage currently contains
.bss and a fix for it is in a patch I have out for review at
https://lore.kernel.org/lkml/20200109150218.16544-1-nivedita@alum.mit.edu

This alone shouldn't make much of a difference across compressors. The
entire .bss is just stored uncompressed as 0's in bzImage currently.
The only thing that gets compressed is the original kernel ELF file. Is
the difference above just from this patch, or is it including the
overhead of function-sections?

It is not necessary for it to contain .bss to get the correct init_size.
The latter is calculated (in x86/boot/header.S) based on the offset of
the _end symbol in the compressed vmlinux, so storing the .bss is just a
bug.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/boot/header.S#n559

From the cover letter:
> Image Size
> ----------
> Adding additional section headers as a result of compiling with
> -ffunction-sections will increase the size of the vmlinux ELF file. In
> addition, the vmlinux.bin file generated in arch/x86/boot/compressed by
> objcopy grows significantly with the current POC implementation. This is
> because the boot heap size must be dramatically increased to support shuffling
> the sections and re-sorting kallsyms. With a sample kernel compilation using a
> stock Fedora config, bzImage grew about 7.5X when CONFIG_FG_KASLR was enabled.
> This is because the boot heap area is included in the image itself.
> 
> It is possible to mitigate this issue by moving the boot heap out of .bss.
> Kees Cook has a prototype of this working, and it is included in this
> patchset.

I am also confused by this -- the boot heap is not part of the
vmlinux.bin in arch/x86/boot/compressed: that's a stripped copy of the
decompressed kernel, just before we apply the selected compression to it
and vmlinux.relocs.

Do you mean arch/x86/boot/vmlinux.bin? That is an objcopy of
compressed/vmlinux, and it grows in size with increasing .bss for the
same reason as above (rather it's the cause of bzImage growing).
