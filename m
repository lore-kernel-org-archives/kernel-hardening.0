Return-Path: <SRS0=LUY9=YE=lists.openwall.com=kernel-hardening-return-17010-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB863ECE58C
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Oct 2019 14:04:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14C4B214E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Oct 2019 14:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMU//ZSO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14C4B214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17010-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32131 invoked by uid 550); 11 Oct 2019 14:04:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32094 invoked from network); 11 Oct 2019 14:04:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qLKPKRGYsWe2LV9feXXSxEVMb4o9FMaaiM9B0N1Xmkg=;
        b=ZMU//ZSO/ORdlfd+RmY9p6kVfciAI9jtv2PKCNwsuCYK/SXTxr3/qm7xCjI5oXl9RS
         Gv+TBdGCNnY/LWloGh9h6txsenW3VTUMI5QrYnAS1dhR+sC4Sg+ObOz9pY78fr8ZQkIP
         AX4jEiZ1++VJNYTdZrYy045YGmSn2uiowR0VkLVhwDDJVplCsQeN4qORGZpVmXAJwh5t
         udhKZMcwYbZkSjGIAAsPggg3ZJzB7cv/SiA7AlNR2vepPgu5ctumDeiXE7PmYW1TYgjb
         YxkXjdsxbtSVRLqEq8GWn2f1MlZbPtK97pd8PJMafNcWvAT22O9eY2rp/Qw/h2Tzu0pK
         6KEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qLKPKRGYsWe2LV9feXXSxEVMb4o9FMaaiM9B0N1Xmkg=;
        b=cIL6R96BZAyCblMP0IeZRPR7+a5i7RvanHmsyIOMbfrARHymELmsFQDkuT04TTwcz1
         lwax1dXR6UNrXRQ6i6yghyWsrcpTPmeo3q0+4MGT89yqkMJnDESg9XKG/QQ5X2+eZPQ7
         Y0tO/Yb2ETs6ZfRZzLrN1zZ67nDG3kgUpcuyAemclD8LYFLvbRKc+fZsZogqi+sO1z8w
         TweWaZXVuxmD4w2CKQPWazqKBB4o8E8Q4xQL6DugOjQ3almuqQ7bxP2jPuGseI2Q7//u
         N+tGtGAwoWqa1tyuflfb0qIdND+fMHweOhtfU+b4YvQWmFQQXI/WaDsHxpJAvUJKYvHn
         GZ6w==
X-Gm-Message-State: APjAAAUJ9ARI0Mrnlo2Vi8yVna0rR8cbcjih/Uf/Hoq0HvtQNcZHrpgR
	o2Vha1y8JXbuh3VEHQZo4p/NuCudr16R+wgCMdo=
X-Google-Smtp-Source: APXvYqy7r1uh0ASgmB4F0b6aSaWniIcpiEYPxQ6n979GmK5Aaxvjo8JAffurrAOCfBJye9jb/HY9ga6gM43upT2m/l0=
X-Received: by 2002:aca:dcd6:: with SMTP id t205mr12439954oig.128.1570802630804;
 Fri, 11 Oct 2019 07:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook> <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook> <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
 <201910100950.5179A62E2@keescook> <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>
 <201910101106.9ACB5DB@keescook>
In-Reply-To: <201910101106.9ACB5DB@keescook>
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Fri, 11 Oct 2019 19:33:38 +0530
Message-ID: <CAHhAz+hw251beDeaWRFV7oShngSQ_KAACXAzb45EZRBdZ3kbSg@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 11, 2019 at 12:01 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 10, 2019 at 10:45:21PM +0530, Muni Sekhar wrote:
> > I'm using Ubuntu distro, ran "reboot" command but after reboot
> > console-ramoops-0 is not present in /sys/fs/pstore
>
> Hmpf. Well, then, I guess your boot firmware is pretty aggressive about
> wiping RAM across boots. :(
>
> There was a patch set to store to disk, but I haven't seen a recent
> version of it, if you want to go that route[1].
>
> -Kees
>
> [1] https://lore.kernel.org/lkml/1551922630-27548-1-git-send-email-liaoweixiong@allwinnertech.com/
Thanks I will check it out.

While loading ramoops I see "persistent_ram: uncorrectable error in
header", is this harmful?

[  270.864969] ramoops: using module parameters
[  270.866651] persistent_ram: uncorrectable error in header
[  270.867252] persistent_ram: uncorrectable error in header
[  270.867728] persistent_ram: uncorrectable error in header
[  270.868067] persistent_ram: uncorrectable error in header
[  270.868492] persistent_ram: uncorrectable error in header
[  270.868839] persistent_ram: uncorrectable error in header
[  270.869209] persistent_ram: uncorrectable error in header
[  270.869681] persistent_ram: uncorrectable error in header
[  270.870026] persistent_ram: uncorrectable error in header
[  270.870430] persistent_ram: uncorrectable error in header
[  270.870774] persistent_ram: uncorrectable error in header
[  270.871110] persistent_ram: uncorrectable error in header
[  270.871687] persistent_ram: uncorrectable error in header
[  270.872055] persistent_ram: uncorrectable error in header
[  270.872567] persistent_ram: uncorrectable error in header
[  270.872910] persistent_ram: uncorrectable error in header
[  270.873243] persistent_ram: uncorrectable error in header
[  270.873592] persistent_ram: uncorrectable error in header
[  270.873932] persistent_ram: uncorrectable error in header
[  270.874267] persistent_ram: uncorrectable error in header
[  270.874614] persistent_ram: uncorrectable error in header
[  270.874958] persistent_ram: uncorrectable error in header
[  270.875300] persistent_ram: uncorrectable error in header
[  270.875686] persistent_ram: uncorrectable error in header
[  270.876028] persistent_ram: uncorrectable error in header
[  270.876462] persistent_ram: uncorrectable error in header
[  270.876808] persistent_ram: uncorrectable error in header
[  270.877144] persistent_ram: uncorrectable error in header
[  270.877519] persistent_ram: uncorrectable error in header
[  270.877860] persistent_ram: uncorrectable error in header
[  270.878199] persistent_ram: uncorrectable error in header
[  270.878565] persistent_ram: uncorrectable error in header
[  270.878916] persistent_ram: uncorrectable error in header
[  270.881129] console [pstore-1] enabled
[  270.884817] pstore: Registered ramoops as persistent store backend
[  270.885232] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0

>
> --
> Kees Cook



-- 
Thanks,
Sekhar
