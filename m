Return-Path: <SRS0=8mS0=3Q=lists.openwall.com=kernel-hardening-return-17616-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7506DC2D0DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jan 2020 23:20:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C6FA624679
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jan 2020 23:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XawkCOgE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6FA624679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17616-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26235 invoked by uid 550); 27 Jan 2020 23:20:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26215 invoked from network); 27 Jan 2020 23:20:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QT8O29qq6UX2ERtfMZtIcpjsnZ2zWwc1vGjIRRz0cAI=;
        b=XawkCOgE5DXMC5T4UMCWjNatVuCxPXGElKDJzkypz39qHzpJzBQm4Kjg2Wyc74N8XU
         ae0RNb4v9jld0zCxnKtoZyL8qTh3A+57E2UqJ/UgP52rejOuyEYKSTX+2MbIBdIK8wvO
         WFe7hDDB9CBICJzlBnEvr5cP0Jna4twh3KH9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QT8O29qq6UX2ERtfMZtIcpjsnZ2zWwc1vGjIRRz0cAI=;
        b=Njel1ih2uIQHnCrNm36u6m1FtVq3EyYTSMy3fTJrc/3sd03FEYo+iW5gh0OJZjiwMZ
         4i5JNrMnpLTtoP8f0/b8KdlCLGOxgKUawboRkM16ig8kkY47kCmuCX7octFpBWt3ggXd
         4WCuNG9kvu7EnW+deYN36FuZYauofQ3m9Qb0rzjPQZWOJVz8/anZB8TTTtzH32lkmGvx
         O1ZVdYpSkc69AF3XyL0ExdKi/nxly37IWPs79/uUr95wQfPbLdK9bLimigkS9ykTiazp
         7shBA2ileeHJvF3OAR6Xx4Oe2BVEXPQ1SGnriVTkFCVvtcI4hWuxm0V7ZinTJ5lAbZM4
         b3eQ==
X-Gm-Message-State: APjAAAWLT049/DIbeuCOGxN4XSxpTFh+o7y66GIocQsq3GezDX64tbhT
	BDT6YadwRTO+7fcXySNfWtO4nw==
X-Google-Smtp-Source: APXvYqyXDQEpPXM0xicaJgXWD5GwCMvtHrO2YWSFefSzTu/QuqyGJhGs+kmBUEZGJW1pcHmWRN4ELQ==
X-Received: by 2002:aa7:934a:: with SMTP id 10mr1028171pfn.233.1580167201197;
        Mon, 27 Jan 2020 15:20:01 -0800 (PST)
Date: Mon, 27 Jan 2020 15:19:59 -0800
From: Kees Cook <keescook@chromium.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	David Windsor <dave@nullcore.net>,
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
Message-ID: <202001271519.AA6ADEACF0@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>

On Thu, Jan 23, 2020 at 09:14:20AM +0100, Jiri Slaby wrote:
> On 14. 11. 19, 22:27, Kees Cook wrote:
> > On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> >> How is iucv the only network protocol that has run into this? Do others
> >> use a bounce buffer?
> > 
> > Another solution would be to use a dedicated kmem cache (instead of the
> > shared kmalloc dma one)?
> 
> Has there been any conclusion to this thread yet? For the time being, we
> disabled HARDENED_USERCOPY on s390...
> 
> https://lore.kernel.org/kernel-hardening/9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz/

I haven't heard anything new. What did people think of a separate kmem
cache?

-- 
Kees Cook
