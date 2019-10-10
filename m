Return-Path: <SRS0=Wxir=YD=lists.openwall.com=kernel-hardening-return-17006-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34408C10F14
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 18:31:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C6DF218AC
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 18:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lYrWOGIc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C6DF218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17006-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28101 invoked by uid 550); 10 Oct 2019 18:31:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28063 invoked from network); 10 Oct 2019 18:31:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RbekH147dua5Dd1lch6rIFPjdtcIuElZMa7BuQ3UCS4=;
        b=lYrWOGIcN/3CexWx1z3M87oDunAzZi6T5PqXRnDSae2Bxe+tm8cEPn5YIXFx5NniPJ
         a6D7IXR3/ZXmYSAxjJMhwf14+Rge+B5Qxw1MMEDTNh3jZbo38a+SqwabW7iYNsgIpV1N
         QM3V3J47n4GDCBgz4rTAqVwKMJPQFbAAPLuOM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RbekH147dua5Dd1lch6rIFPjdtcIuElZMa7BuQ3UCS4=;
        b=pHwS5u9w0Xe2UyEWYXk1kjL2wIeOHOUwtnVZk9J+tYWynk/CN92phg5Zc8TKV66OoD
         4eI8QvCUEUuWJd7aVWA3fksrLCSS7hJfPl+BcEOLs57A+bjx5df1zE8e5D2s9e7ryb3j
         6Gq283qrUrABK9Bv+0ZyztsD4LfWH/a0eVk5mR83XVDsrsbwqCIt6A8SZohfqza9pYYt
         G3jn8MVsyNh03z+YGU7FC7nXikoNemS56nqhovGnlO5HZc9lLOkgDM/uz9r4dZDsuu1y
         GjRRWMowLR10xYHP11ZI0D3/FI3d6VT4pmcsOD9GplCUmK6EKI1qFh1tL48paVDwH2Pt
         lZmg==
X-Gm-Message-State: APjAAAUilg2ctjNx6mdk51Vb9D7sxX0VB3KIkKQkG8GbQGoePV8NanGZ
	4IIrKFZgkA3qOjwvUHen3yErDg==
X-Google-Smtp-Source: APXvYqwVdN/AdjdjtihVsgz9HopFUwRHlziTWx5nq1i3SqtMsiWyaJ7T/OkUvr2I7+1FFsrKoAkRbw==
X-Received: by 2002:a17:90a:fd83:: with SMTP id cx3mr12847413pjb.64.1570732289784;
        Thu, 10 Oct 2019 11:31:29 -0700 (PDT)
Date: Thu, 10 Oct 2019 11:31:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <201910101106.9ACB5DB@keescook>
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook>
 <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook>
 <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
 <201910100950.5179A62E2@keescook>
 <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>

On Thu, Oct 10, 2019 at 10:45:21PM +0530, Muni Sekhar wrote:
> I'm using Ubuntu distro, ran "reboot" command but after reboot
> console-ramoops-0 is not present in /sys/fs/pstore

Hmpf. Well, then, I guess your boot firmware is pretty aggressive about
wiping RAM across boots. :(

There was a patch set to store to disk, but I haven't seen a recent
version of it, if you want to go that route[1].

-Kees

[1] https://lore.kernel.org/lkml/1551922630-27548-1-git-send-email-liaoweixiong@allwinnertech.com/

-- 
Kees Cook
