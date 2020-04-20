Return-Path: <SRS0=1WwL=6E=lists.openwall.com=kernel-hardening-return-18570-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C048C3815B
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 17:44:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 49D67206DD
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 17:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jQBTeSx5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49D67206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18570-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32651 invoked by uid 550); 20 Apr 2020 17:43:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32625 invoked from network); 20 Apr 2020 17:43:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UbWvOzsjdwKmCuURzqakr712Hwz970Vkw5PGIrntIJg=;
        b=jQBTeSx5RVM7KT1U22GJEb3DH2uZPfcy8Q8n8Z4yMQbR4xX77sT7UNorH68BHXQklv
         iqyP+lyhtbiw1Z8E6mrIAOVUfrKDbExPTw1eCNreicq7+fmKaKDC0t3L5Z68emnhhiQY
         F68qqIHfXsfIWhK8AMTQ6lJSl/wFSmFVqe+Fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UbWvOzsjdwKmCuURzqakr712Hwz970Vkw5PGIrntIJg=;
        b=NGzs2Tn4Cem4gc5PmI7clAauCeYUMhrp1NDnRat+5VZzNwhzP80Gi3r9IIkAp5UBNX
         asxDAjPplZpciTFIw7H8r/53r1wacwSsAQK2o2f+HIsXV+7G7C9Piw6vMPVJdm9oe7rr
         gDWTs5wKRBkaIMwtrfmpoahNsK2zZC26TcKxSbtOpVhV7DKsiyyFaSrQaoU829o0Lg6A
         Dfg71EH5fAdg6Utet6VhQHUYMQ+bQCV1KDb7e6L4fkBwBudkeLAHgQaXYb3k8MZCY++3
         qOl+fbtuXRA5d8I8cbUNTn6eI/8ohjpl35WQkytLpSv6kkvScHSVaI04I5Qhbf3lshfT
         jVMg==
X-Gm-Message-State: AGi0PuYCNwKOnf2K5jJw41Tc9ZP9xMnZw6rbUvCRc3wqxtJJMLURJK9e
	kB2fTn+qZhgTkakLNpUiQpjvQQ==
X-Google-Smtp-Source: APiQypLBX8wx/oUkDoqkb/2Bm8ippA2jak1OrscI29iIv8/MVYRimaZ8XN8jTccr1R5iuIwy3W5LTA==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr18181334plk.100.1587404619781;
        Mon, 20 Apr 2020 10:43:39 -0700 (PDT)
Date: Mon, 20 Apr 2020 10:43:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Christopher Lameter <cl@linux.com>,
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
	Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202004201043.538A7B3F2@keescook>
References: <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
 <7d810f6d-8085-ea2f-7805-47ba3842dc50@suse.cz>
 <548e6212-7b3c-5925-19f2-699af451fd16@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548e6212-7b3c-5925-19f2-699af451fd16@suse.cz>

On Mon, Apr 20, 2020 at 09:53:20AM +0200, Jiri Slaby wrote:
> On 07. 04. 20, 10:00, Vlastimil Babka wrote:
> > From d5190e4e871689a530da3c3fd327be45a88f006a Mon Sep 17 00:00:00 2001
> > From: Vlastimil Babka <vbabka@suse.cz>
> > Date: Tue, 7 Apr 2020 09:58:00 +0200
> > Subject: [PATCH] usercopy: Mark dma-kmalloc caches as usercopy caches
> > 
> > We have seen a "usercopy: Kernel memory overwrite attempt detected to SLUB
> > object 'dma-kmalloc-1 k' (offset 0, size 11)!" error on s390x, as IUCV uses
> > kmalloc() with __GFP_DMA because of memory address restrictions.
> > The issue has been discussed [2] and it has been noted that if all the kmalloc
> > caches are marked as usercopy, there's little reason not to mark dma-kmalloc
> > caches too. The 'dma' part merely means that __GFP_DMA is used to restrict
> > memory address range.
> > 
> > As Jann Horn put it [3]:
> > 
> > "I think dma-kmalloc slabs should be handled the same way as normal
> > kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> > just normal kernel memory - even if it might later be used for DMA -,
> > and it should be perfectly fine to copy_from_user() into such
> > allocations at that point, and to copy_to_user() out of them at the
> > end. If you look at the places where such allocations are created, you
> > can see things like kmemdup(), memcpy() and so on - all normal
> > operations that shouldn't conceptually be different from usercopy in
> > any relevant way."
> > 
> > Thus this patch marks the dma-kmalloc-* caches as usercopy.
> > 
> > [1] https://bugzilla.suse.com/show_bug.cgi?id=1156053
> > [2] https://lore.kernel.org/kernel-hardening/bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz/
> > [3] https://lore.kernel.org/kernel-hardening/CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com/
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Friendly ping.
> 
> Acked-by: Jiri Slaby <jslaby@suse.cz>

Should this go via -mm?

-Kees

> 
> > ---
> >  mm/slab_common.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 5282f881d2f5..ae9486160594 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1303,7 +1303,8 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> >  				kmalloc_info[i].name[KMALLOC_DMA],
> >  				kmalloc_info[i].size,
> > -				SLAB_CACHE_DMA | flags, 0, 0);
> > +				SLAB_CACHE_DMA | flags, 0,
> > +				kmalloc_info[i].size);
> >  		}
> >  	}
> >  #endif
> > 
> 
> thanks,
> -- 
> js
> suse labs

-- 
Kees Cook
