Return-Path: <SRS0=tPfG=U4=lists.openwall.com=kernel-hardening-return-16324-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5FBC4321A
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Jun 2019 14:25:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C2571214AF
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Jun 2019 14:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wmn42cCj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2571214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16324-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1619 invoked by uid 550); 29 Jun 2019 14:25:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1587 invoked from network); 29 Jun 2019 14:25:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tSfTfCg1RYrQS9+orWf92BVXcSGyjMupz270+2KJ+Us=;
        b=Wmn42cCjIZF370922nlT8XBZNT0vFC3qdUoivrJz5yLafRIjdx1Vw+bUvno+QUBVO5
         oMyQcmwqGx4DE3Y07CmSTM0IATWqZAW8kgg+hDEKwh+1CP4NznlAWonwVsCaGpQLaVCV
         I2vA/VdkUZjqS9WvauRGJBO3Xjdwe01bpXzqQP8wAMh3LJ6yI1E5Z9SfpRw+TuNVA5cx
         Mol2Xo2HUenKPsAtO6b1Hxjmm06+PdB0ii0cFoQihuSTWnRJjwjpf6NZuH7lsl3/21RK
         LnPOrpaBytkjll+vsC5zrv5VKacw2e2sTlF82+ldUSC/dM1uFOjAFEnxgQGkqlBXSG7l
         +TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tSfTfCg1RYrQS9+orWf92BVXcSGyjMupz270+2KJ+Us=;
        b=fapfdbivF3il0rWgxsG9Tg5fxo7l/Jtdw2n9SWgCRKjJjHFpay8oBZaVEgPoeIHOYN
         WNAQFwCBfxWuF/wjHS576jwlFXo0PC8UICGmCPhCM0lvygHapFb9M2t6JPfcb98tM4Do
         +ssZDudS8b8/XMAqgDpQ9g131BR/0ykR5GbaJHlZ6dPzXgHJT9rI8e4dYGID1KYInl2W
         nk8A5Rsd3uMypqrcmIg7CTYE/l29bOCqZ0cmA6pJoAw2j08HoQbZDEEsyO7qwwqKpdJ6
         83SJlUYhno8kxYTw9mutImzPgXC4xemDDrZQ+zpHfmyKPCXK4YGBuXxBEL72bwV8vG9d
         +BMg==
X-Gm-Message-State: APjAAAX+eHn5zZk+Gpdst9dg9KZ1w//QdWBbrBPOoXHg0yI8CAwxEPp3
	3xoCNwmcQzLIPAxz7HnQcA==
X-Google-Smtp-Source: APXvYqzYjeGlAIXCK0Otnr3tBdPOmwP6gFHgUXBBLaR5nRWD1D7mhQsGKJ7ZXMMjG4yeTA5UDqjZKg==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr9957034wmg.159.1561818328264;
        Sat, 29 Jun 2019 07:25:28 -0700 (PDT)
Date: Sat, 29 Jun 2019 17:25:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shyam Saini <shyam.saini@amarulasolutions.com>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	devel@lists.orangefs.org, linux-mm@kvack.org,
	linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
	kvm@vger.kernel.org, mayhs11saini@gmail.com
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-ID: <20190629142510.GA10629@avx2>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:

> I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> is about 30x, and SIZEOF_FIELD() is only about 5x.
> 
> That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> which it is closely related, but is also closer to the original "sizeof()".
> 
> Since this is a rather trivial change, it can be split into a number of
> patches to get approval/landing via subsystem maintainers, and there is no
> huge urgency to remove the original macros until the users are gone.  It
> would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> whittled away as the patches come through the maintainer trees.

The signature should be

	sizeof_member(T, m)

it is proper English,
it is lowercase, so is easier to type,
it uses standard term (member, not field),
it blends in with standard "sizeof" operator,
