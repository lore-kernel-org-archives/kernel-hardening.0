Return-Path: <SRS0=I8Pb=BQ=lists.openwall.com=kernel-hardening-return-19567-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF27BC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 15:33:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 64FB723110
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 15:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1kms1Jb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64FB723110
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19567-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2033 invoked by uid 550); 6 Aug 2020 15:33:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2010 invoked from network); 6 Aug 2020 15:33:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BJRVvbJ27WTMdqqsxMOJteTWJIZ1QhBp8oNNmFI81Ts=;
        b=J1kms1Jb+DBdy5tnRvsQhyY5wCNWWMDZ5UhkCcv51jnBWIEP44sPwLQU49f/DZ+UqN
         ATRIAgR5nrdJESlIXlZA9JZ6VKqbSeiFL/eDWjrZ17nG2Ziot8JbxvgwwSIkH01rc0cR
         nOhlq03lA6XNLqBreq14AIiCB/cp+NF6DbLjLsfX5U5bLr7cNzGSD//gmVIJ5O6Q/Lqy
         RoMZp0mSuIgDbjVFKx6NfBplUOIYCKTKQSn3FN7/iAu0Vztf8okVp2gwU+ed5xee6l8o
         qi87urfH+G2reTX5kcSC/y7C4xYkqmssnH6WMScQbUXpQbs8N1doCrUy1DBsHjTXOgZb
         7kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BJRVvbJ27WTMdqqsxMOJteTWJIZ1QhBp8oNNmFI81Ts=;
        b=cFDFBAQ1vWNx9SS079rmnYxHN929Bp62Q1Z2o8ICZliU61AVhYM6jhYThn9DB9MHnZ
         0jrKCVdqP1qaXos0QazRQcb3vpu76flqNOJuk8D8SCz9oTj3nDw9rtd7Nm3VZrUX27wi
         G51SZCXDJrXpLP/bjIs0Et7e9BUeU1i6dpaI7JGpGTG5yn1tquVTAivZ8xkdWJZn37xl
         yz1xjpTEtwvRfbkdRKuAW1DX26HHzVT0KiqAc9Ty44x6XZHXz4SC5gjTRSN3ENo6OYZY
         /yr2WaoYzDkjYX6W56xpatvMFRc0hkLjG9iVf7mqIP6vtYQf0OQIxJ4c0YaRGo/ZdVLT
         TDFQ==
X-Gm-Message-State: AOAM530r/L1ci6j3QPGVA8EKXGQ+UTRnvfhSCzjhO/5qmL2cJMVCvrtV
	dYQkMM0DnaeyHWOlMtIjyoM=
X-Google-Smtp-Source: ABdhPJzKadYqu9DuxT6yEhY+yLfMI17678fAKsD2zLmixlazR3kmBiWq46Lgd5M0wGB4iVXxcsq0vA==
X-Received: by 2002:a17:907:10d9:: with SMTP id rv25mr4656328ejb.264.1596727984179;
        Thu, 06 Aug 2020 08:33:04 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 6 Aug 2020 17:32:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200806153258.GB2131635@gmail.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>


* Kristen Carlson Accardi <kristen@linux.intel.com> wrote:

> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
> ---------------------------------------------------------------------
> 
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.

This is a very nice feature IMO, and it should be far more effective 
at randomizing the kernel, due to the sheer number of randomization 
bits that kernel function granular randomization presents.

If this is a good approximation of fg-kaslr randomization depth:

  thule:~/tip> grep ' [tT] ' /proc/kallsyms  | wc -l
  88488

... then that's 80K bits of randomization instead of the mere handful 
of kaslr bits we have today. Very nice!

> In order to hide our new layout, symbols reported through 
> /proc/kallsyms will be displayed in a random order.

Neat. :-)

> Performance Impact
> ------------------

> * Run time
> The performance impact at run-time of function reordering varies by workload.
> Using kcbench, a kernel compilation benchmark, the performance of a kernel
> build with finer grained KASLR was about 1% slower than a kernel with standard
> KASLR. Analysis with perf showed a slightly higher percentage of 
> L1-icache-load-misses. Other workloads were examined as well, with varied
> results. Some workloads performed significantly worse under FGKASLR, while
> others stayed the same or were mysteriously better. In general, it will
> depend on the code flow whether or not finer grained KASLR will impact
> your workload, and how the underlying code was designed. Because the layout
> changes per boot, each time a system is rebooted the performance of a workload
> may change.

I'd guess that the biggest performance impact comes from tearing apart 
'groups' of functions that particular workloads are using.

In that sense it might be worthwile to add a '__kaslr_group' function 
tag to key functions, which would keep certain performance critical 
functions next to each other.

This shouldn't really be a problem, as even with generous amount of 
grouping the number of randomization bits is incredibly large.

> Future work could identify hot areas that may not be randomized and either
> leave them in the .text section or group them together into a single section
> that may be randomized. If grouping things together helps, one other thing to
> consider is that if we could identify text blobs that should be grouped together
> to benefit a particular code flow, it could be interesting to explore
> whether this security feature could be also be used as a performance
> feature if you are interested in optimizing your kernel layout for a
> particular workload at boot time. Optimizing function layout for a particular
> workload has been researched and proven effective - for more information
> read the Facebook paper "Optimizing Function Placement for Large-Scale
> Data-Center Applications" (see references section below).

I'm pretty sure the 'grouping' solution would address any real 
slowdowns.

I'd also suggest allowing the passing in of a boot-time pseudo-random 
generator seed number, which would allow the creation of a 
pseudo-randomized but repeatable layout across reboots.

> Image Size
> ----------
> Adding additional section headers as a result of compiling with
> -ffunction-sections will increase the size of the vmlinux ELF file.
> With a standard distro config, the resulting vmlinux was increased by
> about 3%. The compressed image is also increased due to the header files,
> as well as the extra relocations that must be added. You can expect fgkaslr
> to increase the size of the compressed image by about 15%.

What is the increase of the resulting raw kernel image? Additional 
relocations might increase its size (unless I'm missing something) - 
it would be nice to measure this effect. I'd expect this to be really 
low.

vmlinux or compressed kernel size doesn't really matter on x86-64, 
it's a boot time only expense well within typical system resource 
limits.

> Disabling
> ---------
> Disabling normal KASLR using the nokaslr command line option also disables
> fgkaslr. It is also possible to disable fgkaslr separately by booting with
> fgkaslr=off on the commandline.

I'd suggest to also add a 'nofgkaslr' boot option if it doesn't yet 
exist, to keep usage symmetric with kaslr.

Likewise, there should probably be a 'kaslr=off' option as well.

The less random our user interfaces are, the better ...

>  arch/x86/boot/compressed/Makefile             |   9 +-
>  arch/x86/boot/compressed/fgkaslr.c            | 811 ++++++++++++++++++
>  arch/x86/boot/compressed/kaslr.c              |   4 -
>  arch/x86/boot/compressed/misc.c               | 157 +++-
>  arch/x86/boot/compressed/misc.h               |  30 +
>  arch/x86/boot/compressed/utils.c              |  11 +
>  arch/x86/boot/compressed/vmlinux.symbols      |  17 +
>  arch/x86/include/asm/boot.h                   |  15 +-
>  arch/x86/kernel/vmlinux.lds.S                 |  17 +-
>  arch/x86/lib/kaslr.c                          |  18 +-
>  arch/x86/tools/relocs.c                       | 143 ++-
>  arch/x86/tools/relocs.h                       |   4 +-
>  arch/x86/tools/relocs_common.c                |  15 +-
>  include/asm-generic/vmlinux.lds.h             |  18 +-
>  include/linux/decompress/mm.h                 |  12 +-
>  include/uapi/linux/elf.h                      |   1 +
>  init/Kconfig                                  |  26 +
>  kernel/kallsyms.c                             | 163 +++-
>  kernel/module.c                               |  81 ++
>  tools/objtool/elf.c                           |   8 +-
>  26 files changed, 1670 insertions(+), 85 deletions(-)
>  create mode 100644 Documentation/security/fgkaslr.rst
>  create mode 100644 arch/x86/boot/compressed/fgkaslr.c
>  create mode 100644 arch/x86/boot/compressed/utils.c
>  create mode 100644 arch/x86/boot/compressed/vmlinux.symbols

This looks surprisingly lean overall.

Thanks,

	Ingo
