Return-Path: <SRS0=KN6T=3X=lists.openwall.com=kernel-hardening-return-17656-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6029AC35249
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:20:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE6672080D
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE6672080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17656-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11335 invoked by uid 550); 3 Feb 2020 17:20:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11313 invoked from network); 3 Feb 2020 17:20:14 -0000
Date: Mon, 3 Feb 2020 17:20:02 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Kees Cook <keescook@chromium.org>
cc: Jann Horn <jannh@google.com>, 
    Christian Borntraeger <borntraeger@de.ibm.com>, 
    Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jslaby@suse.cz>, 
    Julian Wiedmann <jwi@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    kernel list <linux-kernel@vger.kernel.org>, 
    David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
    linux-xfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
    Andy Lutomirski <luto@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
    Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Christoffer Dall <christoffer.dall@linaro.org>, 
    Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, 
    Luis de Bethencourt <luisbg@kernel.org>, 
    Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, 
    Matthew Garrett <mjg59@google.com>, 
    linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
    linux-arch <linux-arch@vger.kernel.org>, 
    Network Development <netdev@vger.kernel.org>, 
    Kernel Hardening <kernel-hardening@lists.openwall.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
In-Reply-To: <202002010952.ACDA7A81@keescook>
Message-ID: <alpine.DEB.2.21.2002031716440.1668@www.lameter.com>
References: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz> <202001271519.AA6ADEACF0@keescook> <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com> <202001281457.FA11CC313A@keescook> <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com> <20200129170939.GA4277@infradead.org> <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com> <202001300945.7D465B5F5@keescook> <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
 <202002010952.ACDA7A81@keescook>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 1 Feb 2020, Kees Cook wrote:
>
> I can't find where the address limit for dma-kmalloc is implemented.

include/linux/mmzones.h

enum zone_type {
        /*
         * ZONE_DMA and ZONE_DMA32 are used when there are peripherals not able
         * to DMA to all of the addressable memory (ZONE_NORMAL).
         * On architectures where this area covers the whole 32 bit address
         * space ZONE_DMA32 is used. ZONE_DMA is left for the ones with smaller
         * DMA addressing constraints. This distinction is important as a 32bit
         * DMA mask is assumed when ZONE_DMA32 is defined. Some 64-bit
         * platforms may need both zones as they support peripherals with
         * different DMA addressing limitations.
         *
         * Some examples:
         *
         *  - i386 and x86_64 have a fixed 16M ZONE_DMA and ZONE_DMA32 for the
         *    rest of the lower 4G.
         *
         *  - arm only uses ZONE_DMA, the size, up to 4G, may vary depending on
         *    the specific device.
         *
         *  - arm64 has a fixed 1G ZONE_DMA and ZONE_DMA32 for the rest of the
         *    lower 4G.
         *
         *  - powerpc only uses ZONE_DMA, the size, up to 2G, may vary
         *    depending on the specific device.
         *
         *  - s390 uses ZONE_DMA fixed to the lower 2G.
         *
         *  - ia64 and riscv only use ZONE_DMA32.
         *
         *  - parisc uses neither.
         */
#ifdef CONFIG_ZONE_DMA
        ZONE_DMA,
#endif
#ifdef CONFIG_ZONE_DMA32
        ZONE_DMA32,
#endif
        /*
         * Normal addressable memory is in ZONE_NORMAL. DMA operations can
be
         * performed on pages in ZONE_NORMAL if the DMA devices support
         * transfers to all addressable memory.
         */
        ZONE_NORMAL,
#ifdef CONFIG_HIGHMEM
        /*
         * A memory area that is only addressable by the kernel through
         * mapping portions into its own address space. This is for example
         * used by i386 to allow the kernel to address the memory beyond
         * 900MB. The kernel will set up special mappings (page
         * table entries on i386) for each page that the kernel needs to
         * access.
         */
        ZONE_HIGHMEM,
#endif
        ZONE_MOVABLE,
#ifdef CONFIG_ZONE_DEVICE
        ZONE_DEVICE,
#endif
        __MAX_NR_ZONES

};

