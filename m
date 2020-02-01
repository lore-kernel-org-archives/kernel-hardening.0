Return-Path: <SRS0=62UN=3V=lists.openwall.com=kernel-hardening-return-17649-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4521C33CB3
	for <kernel-hardening@archiver.kernel.org>; Sat,  1 Feb 2020 17:57:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 039C02067C
	for <kernel-hardening@archiver.kernel.org>; Sat,  1 Feb 2020 17:57:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UbIWczwi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 039C02067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17649-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11945 invoked by uid 550); 1 Feb 2020 17:56:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11919 invoked from network); 1 Feb 2020 17:56:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rxiDiiWyy+RaaD0YllXb5sVbRbHdZvAaLoyASC1RHA=;
        b=UbIWczwiQvzV+o1/R62NbaP1lFCIW4J4I1Znu2jtuEVKVBfSBP0kAK6LdTGJ1ujZps
         /G0uyRiL+3/xM2Hvkwz1ZQhXsnR97q5ZnjDFj6XXbM/7HbkX4QGvl8Ij1VWRDdoVEVqI
         D9Ks/1wEw6tLdPvSdLg1Vw6B3NocqQ1gDZwAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rxiDiiWyy+RaaD0YllXb5sVbRbHdZvAaLoyASC1RHA=;
        b=sP3HbNlolekH6FRCFdZStdtpkVtN3o9ycO/DMiNvcY9nW6O42T3H7mkMA8ZxYS0e5d
         NiqGMcvojjZOPCgnCSMN3nQoUpWAosfvQYb6CZPmxYqK+Tw50O8f8/vUxFzqcZ5cD9Lk
         puRQEpL7hgWTKMhvRsBkHjGwR0gTrd5mw1/ltjn6GMMvi8lt7neOy+FcxDuHZjxjHhsm
         h2rgQg2JE7hu44yxX8u36wbtEbjNJx4H5ErhYhNNk56j3ubXm2O6jkvUvK7g26vIO5lS
         Pkiwe2rN0BIWiDtjOYQyInhG+usjp16H+6NZsW29fdTIvuL+mxkl8lP5YbygYPh8Psep
         inlw==
X-Gm-Message-State: APjAAAWiBw5TG6OYfKJ2mPQL5gmn9UbW8jRwUQf3EZKleQe1BWTldhGA
	AEZ2phvU+OcMubm+Ruz2S3/qaA==
X-Google-Smtp-Source: APXvYqxT3vOizdt1K5+VTatra4+LXkGQ2fpy4tPPX6L9duoaO3re51J2wolPrp+nN4BPCFA89zymvQ==
X-Received: by 2002:a17:902:9b93:: with SMTP id y19mr15780032plp.89.1580579803746;
        Sat, 01 Feb 2020 09:56:43 -0800 (PST)
Date: Sat, 1 Feb 2020 09:56:41 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Christopher Lameter <cl@linux.com>, Jiri Slaby <jslaby@suse.cz>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>,
	David Windsor <dave@nullcore.net>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
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
	Matthew Garrett <mjg59@google.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202002010952.ACDA7A81@keescook>
References: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>

On Fri, Jan 31, 2020 at 01:03:40PM +0100, Jann Horn wrote:
> I think dma-kmalloc slabs should be handled the same way as normal
> kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> just normal kernel memory - even if it might later be used for DMA -,
> and it should be perfectly fine to copy_from_user() into such
> allocations at that point, and to copy_to_user() out of them at the
> end. If you look at the places where such allocations are created, you
> can see things like kmemdup(), memcpy() and so on - all normal
> operations that shouldn't conceptually be different from usercopy in
> any relevant way.

I can't find where the address limit for dma-kmalloc is implemented.

As to whitelisting all of dma-kmalloc -- I guess I can be talked into
it. It still seems like the memory used for direct hardware
communication shouldn't be exposed to userspace, but it we're dealing
with packet data, etc, then it makes sense not to have to have bounce
buffers, etc.

-- 
Kees Cook
