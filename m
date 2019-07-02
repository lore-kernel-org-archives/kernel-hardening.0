Return-Path: <SRS0=HPEf=U7=lists.openwall.com=kernel-hardening-return-16335-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1182C5B57D
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Jul 2019 21:04:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0384D218B6
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Jul 2019 21:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZMFtd4fn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0384D218B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16335-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21547 invoked by uid 550); 2 Jul 2019 21:04:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21512 invoked from network); 2 Jul 2019 21:04:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a6DSR9zMVNSIPOHutOGYYowzxyygnNjjAgHH6t/fH3Q=;
        b=ZMFtd4fnwBhjqDgEcmMPYqwTfM3scvxup6E9ES0eTl1QBLbkm4L+EYQQqrUrDt7I0f
         1W7i7K4qFAKEM9FkLZbBvOwEPA2KShqct0FnQuEtwjRtbN+49uyAwET1ta2fkPFntUdL
         d1HKAJ/XrkEjycdCCsfgQI1lqoOc8poLOC7Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a6DSR9zMVNSIPOHutOGYYowzxyygnNjjAgHH6t/fH3Q=;
        b=GCRr6m1xt1rLkrUdJn9DqOr9oe4wbOJKSvheiRqp0qqMVrb1GVvjxiPkBLhDv0wIjd
         JNDEKObVrJGbk1bg8iClgmWBu8gP/OOfM5/xsIv4iG9SP9FUVJQsFLJxeLa8kci5N96x
         obsdrqcewer/9IZxows8GF5Q95zW2Ed4Cr+m7c4lDRWrA904sa6I0aoRi0ejOlTlBI2b
         zn/RaeClm4yhL3wWL0pYnCkWNt53maiI0mxHXmNKv0QHyhF/2TxCmVd0fLxY49w6rkGA
         I/AWtv8swjneVSsda8b2g1JZyOPelUwm0h3DIU0J91uDBertd3Ep3g+VNJcHpSxkufzI
         C3Pg==
X-Gm-Message-State: APjAAAVtaZT96AzBPXXiN3eMvsLoZpFjEYYjZ8dD9tT++STiWP0NFnjf
	zBoerJ0cAXSbBSwb6ORBpNxKgw==
X-Google-Smtp-Source: APXvYqxbnDf0epA4zxEVMf+KQtiS47h5ZVi4HVl0lxeY8pfHVzHmCshNhotvWTcEjEQC+XEnSbkkRg==
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr7901348pjr.94.1562101447970;
        Tue, 02 Jul 2019 14:04:07 -0700 (PDT)
Date: Tue, 2 Jul 2019 09:33:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shyam Saini <shyam.saini@amarulasolutions.com>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	devel@lists.orangefs.org, linux-mm@kvack.org,
	linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
	kvm@vger.kernel.org, mayhs11saini@gmail.com
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-ID: <201907020931.2170BAB@keescook>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
 <20190629142510.GA10629@avx2>
 <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>

On Sat, Jun 29, 2019 at 09:45:10AM -0700, Joe Perches wrote:
> On Sat, 2019-06-29 at 17:25 +0300, Alexey Dobriyan wrote:
> > On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> > > On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:
> > > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > > is about 30x, and SIZEOF_FIELD() is only about 5x.
> > > 
> > > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > > which it is closely related, but is also closer to the original "sizeof()".
> > > 
> > > Since this is a rather trivial change, it can be split into a number of
> > > patches to get approval/landing via subsystem maintainers, and there is no
> > > huge urgency to remove the original macros until the users are gone.  It
> > > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > > whittled away as the patches come through the maintainer trees.
> > 
> > The signature should be
> > 
> > 	sizeof_member(T, m)
> > 
> > it is proper English,
> > it is lowercase, so is easier to type,
> > it uses standard term (member, not field),
> > it blends in with standard "sizeof" operator,
> 
> yes please.
> 
> Also, a simple script conversion applied
> immediately after an rc1 might be easiest
> rather than individual patches.

This seems reasonable to me. I think the patch steps would be:

1) implement sizeof_member(T, m) as a stand-alone macro
2) do a scripted replacement of all identical macros.
3) remove all the identical macros.

Step 2 can be a patch that includes the script used to do the
replacement. That way Linus can choose to just run the script instead of
taking the patch.

-- 
Kees Cook
