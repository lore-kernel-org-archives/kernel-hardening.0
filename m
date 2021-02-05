Return-Path: <SRS0=JYkn=HH=lists.openwall.com=kernel-hardening-return-20743-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFB2C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Feb 2021 20:27:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A4E164E02
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Feb 2021 20:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A4E164E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20743-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1867 invoked by uid 550); 5 Feb 2021 20:27:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9688 invoked from network); 5 Feb 2021 17:32:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dvsHRpyK2gR2E6CYrUqJHJLD6y3LObxnDnnFh4piZn0=;
        b=RVfxAZVuYfXiaTz4s66/6u1/MWxVNlUBcPhriYGi5Qklme6jdP3WJFXckKJJkYgVIO
         L4NRZhP8q+11pW8ORIx62QBbwcqNSL0WuBlh3aiFcL8O3Ldkk51MJtDfU8piHpnPVtKb
         BBQa2teS6LNklCTl+7AF6Q1KkqrFwy2njj0Z7EnDGH/k8uj5ues9ADZu70TgMMQThwVQ
         EczAzktjAlZnd9ZYTAfeHoiosfTe4dP7Us+rigfjUrnz0vqCoGvf7IjVHYgrceFR9JOi
         7bK9QUwvD4ubGSDrQ2pRpGdJNkhSq6cIWAte5dPFbrneO9RUF/ZztD2sLakm12Zq5Lix
         +5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dvsHRpyK2gR2E6CYrUqJHJLD6y3LObxnDnnFh4piZn0=;
        b=JFCRp4AjdLXSMAPFmyZemq21f2iaRrwHydGA6KhUjImC7suH8W9rht8uczdXR6k4o9
         WcQ+/JPxuy3safCi7CHhCwljD5ZNKsrl3hHq063Bi2YJoe6izjjPSPhMZcQCABEROWg9
         XlhZH4xyH2cwBhQEkCK/4tTnUja94IG7lM3Qbf3486z6ui5wnh7sRmug9JuudxpYEQQH
         Dpb3VQI0ESdKtKpkr4RPnT3izrp4gL5YapDS/31XbQLuSKjj4qid5uUdDlmseZEdnkWz
         zwow8kVmpSPkegoi9O988SGJOSVZzMaTJ9xH8hcK8hYxiTnXo5S/4wjXkvr/IAvCwXTV
         NjdQ==
X-Gm-Message-State: AOAM530FXb+deqgAaf/jJnqA1ynCxfZgUjT/BMw5nBIqV9sXYp3Fii8Z
	lA1J+AMYGRXR7Xr+sYXXbn6GNDQHxlA/QvhlZOOJDZoR
X-Google-Smtp-Source: ABdhPJwu68e3wQqh39vfIxnYWMIxdpPl4B8mYzQZeqxfSx11c6GIrPS4s6wctHVAr4AqgNY3PeXXLpwpGLL6z9zefXo=
X-Received: by 2002:aa7:d304:: with SMTP id p4mr4429495edq.144.1612546329474;
 Fri, 05 Feb 2021 09:32:09 -0800 (PST)
MIME-Version: 1.0
From: Guy L <guylevanon1@gmail.com>
Date: Fri, 5 Feb 2021 19:31:57 +0200
Message-ID: <CAGefsGhQxR-f5pgMnqDNYBE627F05WYaQAqH6fVjdyQz3k55rw@mail.gmail.com>
Subject: Joining the general Linux kernel hardening mailing list
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000026fa2005ba9a33d8"

--00000000000026fa2005ba9a33d8
Content-Type: text/plain; charset="UTF-8"

Hi,
I am a security researcher looking to learn more about the linux kernel in
general and its security subsystems in general.
I am a bit familiar with the kernel's code and would like to get to the
level of submitting patches to the kernel.

Thanks a lot,
Guy

--00000000000026fa2005ba9a33d8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi,<div dir=3D"auto">I am a security researcher looking t=
o learn more about the linux kernel in general and its security subsystems =
in general.</div><div dir=3D"auto">I am a bit familiar with the kernel&#39;=
s code and would like to get to the level of submitting patches to the kern=
el.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks a lot,</div><=
div dir=3D"auto">Guy</div></div>

--00000000000026fa2005ba9a33d8--
