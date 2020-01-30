Return-Path: <SRS0=pkZG=3T=lists.openwall.com=kernel-hardening-return-17641-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2EBC2D0DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jan 2020 19:24:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 46E81205F4
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jan 2020 19:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jqYeVsah"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46E81205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17641-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10000 invoked by uid 550); 30 Jan 2020 19:23:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9968 invoked from network); 30 Jan 2020 19:23:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=STfgILZYJSeHL29PKr26PXRGNaaOXbLTCRy3jhx8noU=;
        b=jqYeVsahhF99yBrSGAvuHdMSc2W97p/s3hZt9gt9YFSuOjK3g3byaqJC2nQE+QDIfI
         Z8NqxNikaMbSwQW2aQmx4Z02ThbSexr8D1XYxdrnXThBpe0rcHGSppH4YG+Li4+wqP63
         2itQvwz4W2zBZh2IImAm5jdwB75aiWKl25l50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=STfgILZYJSeHL29PKr26PXRGNaaOXbLTCRy3jhx8noU=;
        b=IUuIHGUjUUyP57YduCyRlLmw+tz5lkkkFth+HDHlgGnyaIwFY4J+WJ4nSAzVkwu3Ir
         QRIUAufwLqMakbxPo0ZCkpvdrOEYD5KdabIP/JakxV9s1jzAMY1qflLOtZaV9VGu5LGX
         TtSWbgNQMNI6OSXulNeK4m74u6t3vIlF5/Fqgb1ClQBdzK5nbmdS81vkRGvKqUODz+V4
         XCzeFTzAPQnyKzh6C5QGcZZQ99PqudUJ7Ip8LpjIiHHrsDdz1mVoauYHiReqAE4XZTk3
         sbV/J2LI7ubDl5vPhPJUkyJqQFGR98xVUZ91vcIZXwNQgIM/hIoiqMcu1LmWvwQxNFbj
         M14Q==
X-Gm-Message-State: APjAAAViimpG+Ihms2ZzL7AzgT4/Y1LgwCmFxmwjbk9GO8NS9vhlABzm
	q++HFW4UktDPMi1HE5iNGsKG3w==
X-Google-Smtp-Source: APXvYqw7tzrE450ZfccVZjN7IiTuW4qM2cwf555Gxth2MtTA6Fx8D7q2y+CnyzGujglJaRni3OFJmQ==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr7802031pjk.134.1580412220763;
        Thu, 30 Jan 2020 11:23:40 -0800 (PST)
Date: Thu, 30 Jan 2020 11:23:38 -0800
From: Kees Cook <keescook@chromium.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christopher Lameter <cl@linux.com>, Jiri Slaby <jslaby@suse.cz>,
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
Message-ID: <202001300945.7D465B5F5@keescook>
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

On Wed, Jan 29, 2020 at 06:19:56PM +0100, Christian Borntraeger wrote:
> On 29.01.20 18:09, Christoph Hellwig wrote:
> > On Wed, Jan 29, 2020 at 06:07:14PM +0100, Christian Borntraeger wrote:
> >>> DMA can be done to NORMAL memory as well.
> >>
> >> Exactly. 
> >> I think iucv uses GFP_DMA because z/VM needs those buffers to reside below 2GB (which is ZONA_DMA for s390).
> > 
> > The normal way to allocate memory with addressing limits would be to
> > use dma_alloc_coherent and friends.  Any chance to switch iucv over to
> > that?  Or is there no device associated with it?
> 
> There is not necessarily a device for that. It is a hypervisor interface (an
> instruction that is interpreted by z/VM). We do have the netiucv driver that
> creates a virtual nic, but there is also AF_IUCV which works without a device.
> 
> But back to the original question: If we mark kmalloc caches as usercopy caches,
> we should do the same for DMA kmalloc caches. As outlined by Christoph, this has
> nothing to do with device DMA.

Hm, looks like it's allocated from the low 16MB. Seems like poor naming!
:) There seems to be a LOT of stuff using GFP_DMA, and it seems unlikely
those are all expecting low addresses?

Since this has only been a problem on s390, should just s390 gain the
weakening of the usercopy restriction?  Something like:


diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1907cb2903c7..c5bbc141f20b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1303,7 +1303,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
 			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
 				kmalloc_info[i].name[KMALLOC_DMA],
 				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0, 0);
+				SLAB_CACHE_DMA | flags, 0,
+				IS_ENABLED(CONFIG_S390) ?
+					kmalloc_info[i].size : 0);
 		}
 	}
 #endif



-- 
Kees Cook
