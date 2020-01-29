Return-Path: <SRS0=Tyoc=3S=lists.openwall.com=kernel-hardening-return-17637-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8195C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jan 2020 16:43:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 404F720720
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jan 2020 16:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 404F720720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17637-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32023 invoked by uid 550); 29 Jan 2020 16:43:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32000 invoked from network); 29 Jan 2020 16:43:42 -0000
Date: Wed, 29 Jan 2020 16:43:30 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Kees Cook <keescook@chromium.org>
cc: Christian Borntraeger <borntraeger@de.ibm.com>, 
    Jiri Slaby <jslaby@suse.cz>, Julian Wiedmann <jwi@linux.ibm.com>, 
    Ursula Braun <ubraun@linux.ibm.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
    David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    linux-xfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
    Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
    "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, 
    Mark Rutland <mark.rutland@arm.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Christoffer Dall <christoffer.dall@linaro.org>, 
    Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, 
    Luis de Bethencourt <luisbg@kernel.org>, 
    Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, 
    Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org, 
    linux-arch@vger.kernel.org, netdev@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, Vlastimil Babka <vbabka@suse.cz>, 
    Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
In-Reply-To: <202001281457.FA11CC313A@keescook>
Message-ID: <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org> <1515636190-24061-10-git-send-email-keescook@chromium.org> <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz> <201911121313.1097D6EE@keescook> <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz> <202001271519.AA6ADEACF0@keescook> <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com> <202001281457.FA11CC313A@keescook>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 Jan 2020, Kees Cook wrote:

> > On the other hand not marking the DMA caches still seems questionable.
>
> My understanding is that exposing DMA memory to userspace copies can
> lead to unexpected results, especially for misbehaving hardware, so I'm
> not convinced this is a generically bad hardening choice.

"DMA" memory (and thus DMA caches) have nothing to do with DMA. Its a
legacy term. "DMA Memory" is memory limited to a certain
physical address boundary (old restrictions on certain devices only
supporting a limited number of address bits).

DMA can be done to NORMAL memory as well.

