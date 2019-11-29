Return-Path: <SRS0=yBy0=ZV=lists.openwall.com=kernel-hardening-return-17448-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63004C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 08:43:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B58F7217AB
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 08:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uodPN27A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B58F7217AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17448-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3829 invoked by uid 550); 29 Nov 2019 08:42:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27962 invoked from network); 29 Nov 2019 04:39:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=K+u/LiQ3cpbkmdZHIvcPiIKTKppdsGy7REIP819lmgc=;
        b=uodPN27A5it0jCjR7C9UJ5SonADWkOhvDlDjLOTdi/HtDFriWhao00MxzlEHDKD41m
         BLZl6fBoNdqKCr9DLb9lFrPvBdiG5yQ8lUerN1R2VqnbCcvVKUB1CCf+Q6SFW406wx4J
         OGB7v7Qj5vVK1qodSxlG00Tf4nkHn7bqrG3AgkPYqRpV2HxPmpJaturTXH6QmZc/uUWS
         Vqr4he73kNtbMQdwqc/Zi/rje32m9q4EgWXL9xd3fXXPbHKt/w5E094ru7ljvRrclEQp
         E+nQ+IfjxyL19H4SVfha/FGfWpLLaeDtT7wR6ly6XDxwa6t8AVKy8NW56+RlXlAUz/VZ
         McUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=K+u/LiQ3cpbkmdZHIvcPiIKTKppdsGy7REIP819lmgc=;
        b=nwJUh0q4xIbV7hNFR0QelirwNE2GaIcZcGGiEDsM83sYWrWSFAV7u5uXxuLzYYgNL0
         iCS34KXfKbkRsq+HCX5wJVLtYPxzRozHenTcMIDxd+LJ+U8uO4Ze0b1aaVl+CKtjY/nB
         hrqV3/Y5SXPO76UKB3XSYAZT/MTdE49HHXB91EEtImEokZkK2wQ2CLTCkDRVsQ6tZowo
         +XubjZs4mDoaXL87AHEWHAh4+lGLT2Le6LJTFFIxXwxLtSrTqKjUArmn39q8INzg5AWm
         0hHVQ3FfE3/vxbLJt6tGtxwyTZ2+NADVJ6ZNs5zbbCr9U4wlAcNyjxkkWpcyaFknxJvh
         L9/A==
X-Gm-Message-State: APjAAAUa9lFBl6v81mGoo+hi+vc15C6SkxBr2FEB0RZdXExYkeqPMTfT
	9EmtMBYF0crp2QtEqUjAWT4/nnEgWEYAIf7fFaePp2lG
X-Google-Smtp-Source: APXvYqyrvEQOH6029NITMKuJ85dYHnbsDpVeR30GqOyKY2k/h857ykXGL9YzLL7COiU98kmIksX2JhZVKeGR2byxzPE=
X-Received: by 2002:a05:6830:1501:: with SMTP id k1mr5037218otp.209.1575002362336;
 Thu, 28 Nov 2019 20:39:22 -0800 (PST)
MIME-Version: 1.0
From: Kassad <aashad940@gmail.com>
Date: Thu, 28 Nov 2019 23:39:11 -0500
Message-ID: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
Subject: Contributing to KSPP newbie
To: kernel-hardening@lists.openwall.com, keescook@chromium.org
Content-Type: multipart/alternative; boundary="00000000000053d8aa059874d0c8"

--00000000000053d8aa059874d0c8
Content-Type: text/plain; charset="UTF-8"

Hey Kees,

I'm 3rd university student interested in learning more about the linux
kernel. I'm came across this subsystem, since it aligns with my interest in
security. Do you think as a newbie this task
https://github.com/KSPP/linux/issues/11 will be a good starting point?

Thanks

--00000000000053d8aa059874d0c8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hey Kees,</div><div><br></div><div>I&#39;m 3rd univer=
sity student interested in learning more about the linux kernel. I&#39;m ca=
me across this subsystem, since it aligns with my interest in security. Do =
you think as a newbie this task <a href=3D"https://github.com/KSPP/linux/is=
sues/11">https://github.com/KSPP/linux/issues/11</a> will be a good startin=
g point?</div><div><br></div><div>Thanks</div></div>

--00000000000053d8aa059874d0c8--
