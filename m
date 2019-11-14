Return-Path: <SRS0=2WWq=ZH=lists.openwall.com=kernel-hardening-return-17364-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E659C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AB72A20729
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="atnC2AMF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB72A20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17364-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32376 invoked by uid 550); 15 Nov 2019 05:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32349 invoked from network); 15 Nov 2019 05:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=atnC2AMFzcg/i0Mp01bQtIoCfLx+HHbTWM8nHw4lKY3bvK8sTjwuuQEAzd/5lBqjg8
         S2gVzJA/HwmQYtqs72pyRN1J6FXkXvof9go4CmLgmO38QZr4HfrNVAzeJS6EmIVf0Xon
         frtfStys716GXGZIcxrtKpwu1jAmCujAqb+64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=IeP8cji3EkpguK8xYmqejEcFBT6WryY4GuHC2nAzRL/JhkJ+Ip16pflLbFEmX3+d2V
         6o4w8SkuQRV4Si8cnWFO/oBauMEuH/6b80EcQXTkr2LZR9qitE7TL3Z6mbXo9PLcSqj8
         xmS/W8ZM3L0TI5ztrAbOR47LQbsKEHpoX33Hfu9fKlehFoxlgri8h0j4Z4nL4/lZoB3F
         gUjNNAK8AwnDAMeWSG42iu3wi4Na/Zg8pRyhWaVMYwcOFAPYQyURJnzaHc1Uveod1btV
         thT13PIKga9O+k3ey76P1Lx6Ico4zn1mKfiEBLthmk5xxGjs0FnUVm+yYWH4Jf5YBEyO
         gF9w==
X-Gm-Message-State: APjAAAUlhCNPAh43RdvD43MzZ+f14vebcfspQNG6PEO/JhFcpWc+2iFg
	bdnmry/5nIHNoL+sXklI/wZ+gA==
X-Google-Smtp-Source: APXvYqwt4zb0Je/V6IpxbO3fLLPDi96nB5JTyVu+Y5Gk5ifcWF6G9mnVci2ds1rUWNSyZ5xoFyc++Q==
X-Received: by 2002:a62:7c52:: with SMTP id x79mr15159448pfc.18.1573795780005;
        Thu, 14 Nov 2019 21:29:40 -0800 (PST)
Date: Thu, 14 Nov 2019 13:27:48 -0800
From: Kees Cook <keescook@chromium.org>
To: Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	"David S. Miller" <davem@davemloft.net>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
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
Message-ID: <201911141327.4DE6510@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911121313.1097D6EE@keescook>

On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> How is iucv the only network protocol that has run into this? Do others
> use a bounce buffer?

Another solution would be to use a dedicated kmem cache (instead of the
shared kmalloc dma one)?

-- 
Kees Cook
