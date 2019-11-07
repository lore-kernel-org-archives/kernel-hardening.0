Return-Path: <SRS0=441M=Y7=lists.openwall.com=kernel-hardening-return-17322-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF01C5DF61
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 07:30:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A382C2187F
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 07:30:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOxiMcdD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A382C2187F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17322-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30128 invoked by uid 550); 7 Nov 2019 07:30:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30094 invoked from network); 7 Nov 2019 07:30:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j9qPcLC3XJcMt8r8uz4qYlErk9ILRTu/rJI6OW5PhYM=;
        b=mOxiMcdDlGxe07nH9pkXd2fEGOvMVxz55gBSQUMdJTxhWAkHa3G3w4OieNMuzVY7mk
         IlntwMkyL8mC8dY8tVhTAED1sRa1eCx6VJ4qfWkNnyktU+gbgmn/jHlEH9DVVSJhteQm
         YP+5DdLsWdl38jw8prWeuLDn6cHGBOoSENXqzYDrx4a9J7DqGwhGZjhz5OC54eCMxxVG
         9IDgCoKYUztyaDwRDoc2IOsJ8qNKCBLSljOtLskbolao/R7/MxmYAK4+oxazD5nOsBfu
         CxioqN+ZkCMmmJ5Da4uTqZ76GpVXkumL5vBp9d96Y4psXznuWOU3/oiR+oaIXx0Y1mse
         +gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j9qPcLC3XJcMt8r8uz4qYlErk9ILRTu/rJI6OW5PhYM=;
        b=I3tg5E1XGVfSfVQrSd6G21RjgJ9f0FD9gONZ/CKBods6kRnjHjF3imLqczccJ5Lhj2
         eKc8otLLEHqUkTaBmTXD1HUVAIBviH2rBjwHCCZz5G8LVN87LsKp0Jlk4VuXwCxM1t/G
         P8s2jlZLjWrCfIjEYf/kZp6Eh6roDHqmgn+y4PSTgN+AwreOxJjdJ8QCU+t9B2N5A1Ii
         2P0f7SniIxiLL7knQ4ErEogGdB4140pMGqWnXrVIQCRa/fdgkA2OsJ47jQQIqnkxUA6T
         nbNk3iOBr76E6sPE0eGEjtVs4mlbw8XKSssSjTMl4eSyXOIllnZC+GceYSjNBOETZq+A
         MrYQ==
X-Gm-Message-State: APjAAAWHPz82Oid479YZTzIRYkgz5eKt2E8QyphZFPQY3pLUkSCoTCTG
	FsvtN1kpsM3Z+VQ7tk//vKzQeoJwbgvRn/kRqLs=
X-Google-Smtp-Source: APXvYqxd1Y67LiRutTeJOGSWVnApvG11YX3b7o2lWxnSEBVgM6OjJf/kfqa/4JFPpeDbCK+JB7YXkyCu/ydA2VMAxl0=
X-Received: by 2002:a5d:8987:: with SMTP id m7mr2063496iol.104.1573111791998;
 Wed, 06 Nov 2019 23:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <201909301552.4AAB4D4@keescook> <20191001174752.GD2748@debby.home>
 <201910101531.482D28315@keescook> <CAOMdWSKyAH80dp1JRZ70FarZ4H+=+c8hRDWVOtc=5CXfag9irw@mail.gmail.com>
In-Reply-To: <CAOMdWSKyAH80dp1JRZ70FarZ4H+=+c8hRDWVOtc=5CXfag9irw@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Thu, 7 Nov 2019 08:29:40 +0100
Message-ID: <CABgxDoLbEci9oS3sAmuiZdbBjgxEVbrnrpiqO64zfZDMCF9fvw@mail.gmail.com>
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
To: Allen <allen.lkml@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mer. 30 oct. 2019 =C3=A0 09:21, Allen <allen.lkml@gmail.com> a =C3=A9cri=
t :
>
> Romain,
> >
>
>  First of all Romain, nice work. I started working on this
> set a few months back, but could only carve out limited time.
>
>   I sent out RFC for this sometime in May[1]. And my approach
> was a little different when compared to what you have sent on the
> list.
>
>  Well, I have pushed my work to github[2], only thing I could
> think of as an improvement in your patch set it to break it down
> into smaller chunk so that it's easier to review. I have made each
> occurrence of tasklet_init() into a commit[3] which I thought would
> make it easier to review. I'll leave that decision to you and kees.
>
> Let me know if I could help in any way.
>
> [1] https://www.openwall.com/lists/kernel-hardening/2019/05/06/1
> [2] https://github.com/allenpais/tasklet
> [3] Sample list of patches:
> 5d0b728649b6 atm/solos-pci: Convert tasklets to use new tasklet_init API
> e5144c3c16d8 atm: Convert tasklets to use new tasklet_init API
> 71028976d3ed arch/um: Convert tasklets to use new tasklet_init API
> c9a39c23b78c xfrm: Convert tasklets to use new tasklet_init API
> 91d93fe12bbc mac80211: Convert tasklets to use new tasklet_init API
> d68f1e9e4531 ipv4: Convert tasklets to use new tasklet_init API
> 4f9379dcd8ad sound/timer: Convert tasklets to use new tasklet_init API
> b4519111b75e drivers/usb: Convert tasklets to use new tasklet_init API
> 52f04bf54a5a drivers:vt/keyboard: Convert tasklets to use new tasklet_ini=
t API
> 295de7c9812c dma/virt-dma: Convert tasklets to use new tasklet_init API
> 6c713c83b58f dma/dw: Convert tasklets to use new tasklet_init API
> eaaaaba8a4a7 debug:Convert tasklets to use new tasklet_init API
> b23f4ff5021b tasklet: prepare to change tasklet API

From experience, this is better to group bunch of commits like we
currently do with Kees on this series, instead to have one commit per
change (I mean for huge patchset)
Mainly because you have too much replacements with this API change,
and it will be really complicated to merge.

Last time I have proposed an API change for removing "pci_pool" , it
was a patchset of 20 commits (something like this), it tooks 6 months
to be merged :) (with a fine grain granularity on each commit)

This is better to be the more atomic as possible. If we split the "one
massive tasklet_init replacement" commit into many commit, I am sure
that we find old tasklet API for months in the kernel... it is not
something we want , imho.  + treewide commits are common in the kernel
tree, for important API changes :)

@Kees: agreed ?

I think that the timer_list approach is good. You can help by
providing feedbacks and by testing if you want.


Regards,
Romain




>
> Thanks,
> - Allen
