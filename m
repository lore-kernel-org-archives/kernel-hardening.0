Return-Path: <SRS0=Obzv=YX=lists.openwall.com=kernel-hardening-return-17165-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B528CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 08:21:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 55BE22080F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 08:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AFqnnL5w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55BE22080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17165-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23971 invoked by uid 550); 30 Oct 2019 08:21:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23936 invoked from network); 30 Oct 2019 08:21:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0CvnRz9H7vuU+CzDp4n7/6qcSi7nIQfGUMM+Xn5Xxk=;
        b=AFqnnL5wSF6Ve82ShYSljdytR5wIUR4Mdl/qb5qqdn0MQpVW2EFVyCxnkxuwIyIREQ
         0hUIoJQEzK7vbP7VSxQ2bet8yOXodFKIhfiYuT2qaD5SLZIAyWrH0X6Y9zBm88AfDxI/
         QeVC5Qxq3VFxhcb9s8kMw3PZDzUITT46wCWw0hNYASVsLr7rtZXa0LyM07eYLrShn0iy
         bELZx9BE8AuY8y8GAycVabt3nN7npHo4EaYtGyG3aLY3BylUo5+FvYSfWT3CASDdFDu3
         lOlUNECP5XlXxOWQFIlwtd/t3hvvDOnF36n6mkXihYiGcsZPSb8aMvEHRkOLjtvsAvlP
         ix+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0CvnRz9H7vuU+CzDp4n7/6qcSi7nIQfGUMM+Xn5Xxk=;
        b=c91go0h8du8gD/nALbNvrGm3wK4GC6pvEJrFFpWrhlKNPKwubLC0G37ARUvp/2DBCG
         sY6PU06ORLb/DdBflI3+19doJANc166y2jR6g+5mX3jINYNEYv3Z75zx0ETNupeO97Ge
         5+aIPHBLVqAqkqVNpZNupmPeXjuaXgp9ueAOs4g0y7oatc6UzKCXBq9xfaVRCPAN2MHi
         ARMI9VZxLy+GjNu4vp6MNoQwN1EycWyMvUdUwnnoRogyVkclnWBUqNbchxpV1CRZNMMt
         oXhi7K8nCpmI8d9lWUb3b0jG/5pk7LJBNs+Oir73aHRfPyi67hBmdOET23V7CT3AFh4S
         +ITA==
X-Gm-Message-State: APjAAAWtiAUrgbLnCbAjSx5J2VUSmuasBhYfpmuj9eKP369Ry9w42hZs
	Qc7aRPviL/9JDV3hRKwvyXk0pQ8ycBbsehE6wRI=
X-Google-Smtp-Source: APXvYqx4kNXGn96ql0hinHufRZCHhVNDg2aLSwJ/Jb4N76qtESCq6uDZOXuW1CGOdZEu1CuNtd52y8djmoFoQjIJ570=
X-Received: by 2002:a05:6830:1e8a:: with SMTP id n10mr20925845otr.178.1572423665795;
 Wed, 30 Oct 2019 01:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <201909301552.4AAB4D4@keescook> <20191001174752.GD2748@debby.home> <201910101531.482D28315@keescook>
In-Reply-To: <201910101531.482D28315@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 30 Oct 2019 13:50:49 +0530
Message-ID: <CAOMdWSKyAH80dp1JRZ70FarZ4H+=+c8hRDWVOtc=5CXfag9irw@mail.gmail.com>
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
To: Kees Cook <keescook@chromium.org>
Cc: Romain Perier <romain.perier@gmail.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Romain,
>
> This is all a normally thankless set of patches, so I'll go out of my
> way to say again: thank you for working on this! I know how tedious it
> can be from when I did timer_struct. :)

 First of all Romain, nice work. I started working on this
set a few months back, but could only carve out limited time.

  I sent out RFC for this sometime in May[1]. And my approach
was a little different when compared to what you have sent on the
list.

 Well, I have pushed my work to github[2], only thing I could
think of as an improvement in your patch set it to break it down
into smaller chunk so that it's easier to review. I have made each
occurrence of tasklet_init() into a commit[3] which I thought would
make it easier to review. I'll leave that decision to you and kees.

Let me know if I could help in any way.

[1] https://www.openwall.com/lists/kernel-hardening/2019/05/06/1
[2] https://github.com/allenpais/tasklet
[3] Sample list of patches:
5d0b728649b6 atm/solos-pci: Convert tasklets to use new tasklet_init API
e5144c3c16d8 atm: Convert tasklets to use new tasklet_init API
71028976d3ed arch/um: Convert tasklets to use new tasklet_init API
c9a39c23b78c xfrm: Convert tasklets to use new tasklet_init API
91d93fe12bbc mac80211: Convert tasklets to use new tasklet_init API
d68f1e9e4531 ipv4: Convert tasklets to use new tasklet_init API
4f9379dcd8ad sound/timer: Convert tasklets to use new tasklet_init API
b4519111b75e drivers/usb: Convert tasklets to use new tasklet_init API
52f04bf54a5a drivers:vt/keyboard: Convert tasklets to use new tasklet_init API
295de7c9812c dma/virt-dma: Convert tasklets to use new tasklet_init API
6c713c83b58f dma/dw: Convert tasklets to use new tasklet_init API
eaaaaba8a4a7 debug:Convert tasklets to use new tasklet_init API
b23f4ff5021b tasklet: prepare to change tasklet API

Thanks,
- Allen
