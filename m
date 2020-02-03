Return-Path: <SRS0=/bLU=3X=lists.openwall.com=kernel-hardening-return-17657-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45C3C35247
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:37:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14A6F2080C
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aRscgIH2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14A6F2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17657-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18408 invoked by uid 550); 3 Feb 2020 17:37:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18388 invoked from network); 3 Feb 2020 17:37:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M5ilNMr/HaOIF+l97HNJx/b4/Xm/SDuNMftzBAjQyhk=; b=aRscgIH2h0u4Rl1ejEyVb5K5cr
	UmN9OrjOYROKrgyw8lErle++lCLxJN1Yce9M6aMoTb6vqHWK/H8LiT0lF6w1L6tfCpihErVm1YMDe
	uFSh3RCwwzsuzL8Tb7xrpDaQY9GpyQjGCW2eZDhtzfIWOJePB3MedA6YJDv2AYc73eNsoZzC7YaKn
	bjou3GrF54S6T26jlG4BaVI9n22CIcPERlaVrqepPb4ER/SpFuRLtPJ+y0m6Zm8MgBvwEIjEPKV4o
	ACIsAcGyhfYY7eknHBb4LWnFgLRJf2IrWdsxeTQDhkxsBuHmJurPafJYqIbZsBK5iA7jsrR6PmbtJ
	sV96kmcg==;
Date: Mon, 3 Feb 2020 09:36:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jslaby@suse.cz>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>,
	Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Vlastimil Babka <vbabka@suse.cz>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <20200203173622.GA30011@infradead.org>
References: <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 29, 2020 at 06:19:56PM +0100, Christian Borntraeger wrote:
> There is not necessarily a device for that. It is a hypervisor interface (an
> instruction that is interpreted by z/VM). We do have the netiucv driver that
> creates a virtual nic, but there is also AF_IUCV which works without a device.
> 
> But back to the original question: If we mark kmalloc caches as usercopy caches,
> we should do the same for DMA kmalloc caches. As outlined by Christoph, this has
> nothing to do with device DMA.

Oh well, s/390 with its weird mix of cpu and I/O again.  Everywhere else
where we have addressing limits we do treat that as a DMA address.

We've also had a bit of a lose plan to force ZONE_DMA as a public
interface out, as it is generally the wrong thing to do for drivers.
A ZONE_32 and/or ZONE_31 makes some sense as the backing for the
dma allocator, but it mostly shouldn't be exposed, especially not to
the slab allocator.
