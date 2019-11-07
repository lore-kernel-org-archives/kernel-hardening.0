Return-Path: <SRS0=vbSP=Y7=lists.openwall.com=kernel-hardening-return-17325-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADA2C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 21:22:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B11E72087E
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 21:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ky5hD77i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B11E72087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17325-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28240 invoked by uid 550); 7 Nov 2019 21:22:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28206 invoked from network); 7 Nov 2019 21:22:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+qj3XLHt+SYTeocMUZeDhWvGmwBggOIPZFXl4NUMeQo=;
        b=Ky5hD77iYTRmc6UyBnOOlSZh4braSAQzKet/wLbXnCmURUQQYEXHyXtebq2mIH90pa
         S8qw53GnJRTk5d0lAsTEhre6Ibye9Wvqz/CHjPP2a1+uROphGs+ZQRScO9sbvcLtU6/0
         8zU5cRKSn76+0Eiluaw8+vuUrflA7DneRbOlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+qj3XLHt+SYTeocMUZeDhWvGmwBggOIPZFXl4NUMeQo=;
        b=PavqYumD3Vffs3gdEGWSYFYn1ItOxDqFTs2rzEKbnVU+IC9hu/Sy2oIXn/TglBVJqM
         HwLrwMf2IumEI/7Ix/BQBlmOwHHJzotKaiHYx1MHrqf6i89/2+nPrZuF09jJrZ3kwXIp
         2uHgPP5LSW4kMtnb1PnzNDbywMlsV5DLulMMMTUiWeCmQzDbMyI6CPX3egLJpiWPQDWc
         RL/m2UOWOL9z5hZfjyeVXX+kKvSjAeRFlwXZ8eJ6C/oWMKll1JAcSbWQki3yFksxNcOm
         xACsiOU5A8o/G9Wpga/GA6XWBcGvZZTL5Ujn0OvGfbmHi8af1umwbMc9yyFjJtgRhZAi
         JxLg==
X-Gm-Message-State: APjAAAVfHIIptid32ZwuApbsXUpItbN10HR99mfDge6HQmDytNEkTRKF
	+0GSrKHn0wkQUKby2ZrxtGSJOA==
X-Google-Smtp-Source: APXvYqzbb3c9TtEyDFSTUtqpT1SM6aU7Owbh+M+c5MOfB6ltxuhMjIcg741a+GZNZWN6ZrZCgl2qlw==
X-Received: by 2002:a63:2d81:: with SMTP id t123mr7262031pgt.306.1573161743398;
        Thu, 07 Nov 2019 13:22:23 -0800 (PST)
Date: Thu, 7 Nov 2019 13:22:21 -0800
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Allen <allen.lkml@gmail.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
Message-ID: <201911071321.8A2A664B4A@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <201909301552.4AAB4D4@keescook>
 <20191001174752.GD2748@debby.home>
 <201910101531.482D28315@keescook>
 <CAOMdWSKyAH80dp1JRZ70FarZ4H+=+c8hRDWVOtc=5CXfag9irw@mail.gmail.com>
 <CABgxDoLbEci9oS3sAmuiZdbBjgxEVbrnrpiqO64zfZDMCF9fvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgxDoLbEci9oS3sAmuiZdbBjgxEVbrnrpiqO64zfZDMCF9fvw@mail.gmail.com>

On Thu, Nov 07, 2019 at 08:29:40AM +0100, Romain Perier wrote:
> Le mer. 30 oct. 2019 à 09:21, Allen <allen.lkml@gmail.com> a écrit :
> >
> > Romain,
> > >
> >
> >  First of all Romain, nice work. I started working on this
> > set a few months back, but could only carve out limited time.
> >
> >   I sent out RFC for this sometime in May[1]. And my approach
> > was a little different when compared to what you have sent on the
> > list.
> >
> >  Well, I have pushed my work to github[2], only thing I could
> > think of as an improvement in your patch set it to break it down
> > into smaller chunk so that it's easier to review. I have made each
> > occurrence of tasklet_init() into a commit[3] which I thought would
> > make it easier to review. I'll leave that decision to you and kees.
> >
> > Let me know if I could help in any way.
> >
> > [1] https://www.openwall.com/lists/kernel-hardening/2019/05/06/1
> > [2] https://github.com/allenpais/tasklet
> > [3] Sample list of patches:
> > 5d0b728649b6 atm/solos-pci: Convert tasklets to use new tasklet_init API
> > e5144c3c16d8 atm: Convert tasklets to use new tasklet_init API
> > 71028976d3ed arch/um: Convert tasklets to use new tasklet_init API
> > c9a39c23b78c xfrm: Convert tasklets to use new tasklet_init API
> > 91d93fe12bbc mac80211: Convert tasklets to use new tasklet_init API
> > d68f1e9e4531 ipv4: Convert tasklets to use new tasklet_init API
> > 4f9379dcd8ad sound/timer: Convert tasklets to use new tasklet_init API
> > b4519111b75e drivers/usb: Convert tasklets to use new tasklet_init API
> > 52f04bf54a5a drivers:vt/keyboard: Convert tasklets to use new tasklet_init API
> > 295de7c9812c dma/virt-dma: Convert tasklets to use new tasklet_init API
> > 6c713c83b58f dma/dw: Convert tasklets to use new tasklet_init API
> > eaaaaba8a4a7 debug:Convert tasklets to use new tasklet_init API
> > b23f4ff5021b tasklet: prepare to change tasklet API
> 
> From experience, this is better to group bunch of commits like we
> currently do with Kees on this series, instead to have one commit per
> change (I mean for huge patchset)
> Mainly because you have too much replacements with this API change,
> and it will be really complicated to merge.
> 
> Last time I have proposed an API change for removing "pci_pool" , it
> was a patchset of 20 commits (something like this), it tooks 6 months
> to be merged :) (with a fine grain granularity on each commit)
> 
> This is better to be the more atomic as possible. If we split the "one
> massive tasklet_init replacement" commit into many commit, I am sure
> that we find old tasklet API for months in the kernel... it is not
> something we want , imho.  + treewide commits are common in the kernel
> tree, for important API changes :)
> 
> @Kees: agreed ?
> 
> I think that the timer_list approach is good. You can help by
> providing feedbacks and by testing if you want.

It worked well the last time. :)

I think splitting the non-mechanical changes and landing those first is
the right approach. Then we can land a massive treewide for all the
"easy" cases without trickling them in over months.

-Kees

-- 
Kees Cook
