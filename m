Return-Path: <SRS0=mnjl=32=lists.openwall.com=kernel-hardening-return-17708-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D99C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:26:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 37B38217BA
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKlSdrD3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37B38217BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17708-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13559 invoked by uid 550); 6 Feb 2020 14:26:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13539 invoked from network); 6 Feb 2020 14:26:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nR1RdUPrKU1WwIP4V69fKACRdVxj4e2JmV7Fy+KOsHg=;
        b=iKlSdrD3lo6OtojyUEGrQL6WfFjwDXw6CBH4yDsHk/vZyglgsRzMGmQm9QRe82Gcqt
         6ydlMwN39lMEcsqKlA6eFEdpfrAPMqtY/99M5KvMv39euvS6SouySMQpG15oNpy0xGZ3
         SX+SliTZaXVmC/w0916ORwisS7ODHwSP++18V6pb7q11JLFd19sEWdhdoZIIjusxc/Uw
         O1SeLxFKhYjNlojf69Fg9rxJoclCnMe3QEZpg+p6Lk/Kgr15Vp2/IJ1ilL/8PwCBRc+D
         nJqwwA4HeqY+5cXMODZ6Z9EG3pxwpoBrUsba2t7ycH99Ko07MqBV0JM0EmdRhjntcFma
         +OFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nR1RdUPrKU1WwIP4V69fKACRdVxj4e2JmV7Fy+KOsHg=;
        b=Mg7EgvyUZxPIWvfLoa9LjGaFuQCKMkILjLbnhcvRhC7OSj/DXxeThaxDddjVCLdoH+
         NGMGnA817dAHg6oH17jBDOY/oqh7/VFQ9OD/tRgY1HyilDefovCjDJknseCsJYuZJpL0
         6IcLFrTWWAFpayGgLtapnJunbFYfH+1sU1940ZQ1ry5pSQZxJ/FkgghvbY/4sC3fszXP
         1APMGrtXnraRKx8CalzS7cW66bCX867ptuiFANuD5+dUSg6bVNPJATYs1w6MtpctkazO
         RG5bLutOFzaLVTyAxGEuZpnjHr24EPSWUykxjCYuxtrtb2/TKyQTbCjIlq2oVpuLwqM0
         +/AQ==
X-Gm-Message-State: APjAAAWPA1fmo8SoF0x7xqoOnmF3d1xDN5D5Z8OH/qm34g2pDSyf0pSs
	uDnHICRXlKMkphf5vfbeV8A=
X-Google-Smtp-Source: APXvYqxjx0ABLMaUj/oIQcb1K6ul/jb3Sow74jaG+55IvLa1WfOGJ2YEoTXJ5dysG4KebO8hsa79Ew==
X-Received: by 2002:a05:620a:150e:: with SMTP id i14mr2718113qkk.273.1580999161521;
        Thu, 06 Feb 2020 06:26:01 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 6 Feb 2020 09:25:59 -0500
To: Kees Cook <keescook@chromium.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 11/11] x86/boot: Move "boot heap" out of .bss
Message-ID: <20200206142557.GA3033443@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-12-kristen@linux.intel.com>
 <20200206001103.GA220377@rani.riverdale.lan>
 <202002060251.681292DE63@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202002060251.681292DE63@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 03:13:12AM -0800, Kees Cook wrote:
> On Wed, Feb 05, 2020 at 07:11:05PM -0500, Arvind Sankar wrote:
> > From: Kees Cook <keescook@chromium.org>
> > > This seems to be a trivial change because head_{64,32}.S already only
> > > copies up to the start of the .bss section, so any growth in the .bss
> > > area was already not meaningful when placing the image in memory. The
> > > .bss size is, however, reflected in the boot params "init_size", so the
> > > memory range calculations included the "boot_heap" region. Instead of
> > > wasting the on-disk image size bytes, just account for this heap area
> > > when identifying the mem_avoid ranges, and leave it out of the .bss
> > > section entirely. For good measure, also zero initialize it, as this
> > > was already happening for when zeroing the entire .bss section.
> > 
> > I'm not sure I follow this: the reason the bzImage currently contains
> > .bss and a fix for it is in a patch I have out for review at
> > https://lore.kernel.org/lkml/20200109150218.16544-1-nivedita@alum.mit.edu
> 
> Ah! Thank you. Yes, that's _much_ cleaner. I could not figure out why
> the linker was actually keeping the .bss section allocated in the
> on-disk image. :) We've only had this bug for 10 years. ;)
> 
> > This alone shouldn't make much of a difference across compressors. The
> > entire .bss is just stored uncompressed as 0's in bzImage currently.
> > The only thing that gets compressed is the original kernel ELF file. Is
> > the difference above just from this patch, or is it including the
> > overhead of function-sections?
> 
> With bzip2, it's a 4MB heap in .bss. Other compressors are 64KB. With
> fg-kaslr, the heap is 64MB in .bss. It made the bzImage huge. ;) Another

Ah, I just saw that. Makes more sense now -- so my patch actually saves
~4MiB even now for bz2-compressed bzImages.

> thought I had to deal with the memory utilization in the fg-kaslr shuffle
> was to actually choose _two_ kernel locations in memory (via a refactoring
> of choose_random_location()). One to decompress into and the other to
> write out during the shuffle. Though the symbol table still needs to be
> reconstructed, etc, so probably just best to leave it all in the regular
> heap (or improve the ZO heap allocator which doesn't really implement
> free()).
> 
> > It is not necessary for it to contain .bss to get the correct init_size.
> > The latter is calculated (in x86/boot/header.S) based on the offset of
> > the _end symbol in the compressed vmlinux, so storing the .bss is just a
> > bug.
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/boot/header.S#n559
> 
> Yes, thank you for the reminder. I couldn't find the ZO_INIT_SIZE when I
> was staring at this, since I only looked around the compressed/ directory.
> :)
> 

There's another thing I noticed -- you would need to ensure that the
init_size in the header covers your boot heap even if you did split it
out. The reason is that the bootloader will only know to reserve enough
memory for init_size: it's possible it might put the initrd or something
else following the kernel, or theoretically there might be reserved
memory regions or the end of physical RAM immediately following, so you
can't assume that area will be available when you get to extract_kernel.
