Return-Path: <SRS0=HTlC=5D=lists.openwall.com=kernel-hardening-return-18148-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025F5C10DCE
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Mar 2020 16:39:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F29120752
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Mar 2020 16:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRp1ExaK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F29120752
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18148-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13687 invoked by uid 550); 18 Mar 2020 16:39:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13655 invoked from network); 18 Mar 2020 16:39:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=caW/QunyOk5mz+Kj+0iK5Gu+F5vdx65w78WqgIIoRGs=;
        b=CRp1ExaKtofsBym2ELViLRmOazSCT0uBMeYDxgasLnK2wy5f957W4JO3EwUaCyC16v
         LrCKwkG/2bOZQCgG8mzzWoo9V3ojZXTvit7CqdsD66nY+vPCyA0uPwUpKaQ0s9wpCs4j
         xOT09v6h6z2IbqG5czbDcx+11DDwn0YFTNeto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :mime-version:content-disposition;
        bh=caW/QunyOk5mz+Kj+0iK5Gu+F5vdx65w78WqgIIoRGs=;
        b=PtGVVz9VfCusJhq7aVZky1Q9Bjw3utHaVz9+js2GP7stTbUrL6QZvoHVe+eQ1DJCz8
         hxEB9a/56ZbrP1Tnw0qqKbQYjlu7EajMLwvRg5FHuLSXtFWsHKag413ajOOZ1FgWnr3W
         tHjcKLE9SzpzOJ4j0CDBcpgb3h5Qxpb5NSS9UmfS5OjnJcmbfBPEmWct/ZKaxGrrzGP+
         gKVHuRHnZdQ+8opAu5aLCkv4qPYo08YBzTPpu4//uRJGLjH7n98FV9rSNkpDQZohp11v
         psi1gbJwjqI7ZYCTf3aUBhPRxD4DGbLcvt2yhtjVowV0oAzp0ykZMBCd7HFh+jKkMedD
         feag==
X-Gm-Message-State: ANhLgQ0QoS0bzBUMdZVuWLHM8KKrfeWa26VoGGby6gNP1U7pjmcfHBE5
	I9gUXyEHoidRMx1Tv1qMB1e3v/8ikOifbefZ
X-Google-Smtp-Source: ADFU+vvbYH4E1MZnefhEjCX23zXtMUCPEZiA2xwyARTDy+8Shnm+5KcjtTx03TVCONon2f9vtbWtQg==
X-Received: by 2002:a5d:5741:: with SMTP id q1mr6378640wrw.169.1584549576676;
        Wed, 18 Mar 2020 09:39:36 -0700 (PDT)
Date: Wed, 18 Mar 2020 12:39:30 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: kernel-hardening@lists.openwall.com
Subject: Looking for help testing patch attestation
Message-ID: <20200318163930.5n545jfsbenc5vyr@chatter.i7.local>
Mail-Followup-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

I'm reaching out to you because you're a security-oriented mailing list 
and would likely be among the folks most interested in end-to-end 
cryptographic patch attestation features -- or, at least, you're likely 
to be least indifferent about it. :)

In brief:

- the mechanism I propose uses an external mailing list for attestation 
  data, so list subscribers will see no changes to the mailing list 
  traffic at all (no proliferation of pgp signatures, extra junky 
  messages, etc)
- attestation can be submitted after the fact for patches/series that 
  were already sent to the list, so a maintainer can ask for attestation 
  to be provided post-fact before they apply the series to their git 
  tree
- a single attestation document is generated per series (or, in fact, 
  any collection of patches)

For technical details of the proposed scheme, please see the following 
LWN article:
https://lwn.net/Articles/813646/

The proposal is still experimental and requires more real-life testing 
before I feel comfortable inviting wider participation. This is why I am 
approaching individual lists that are likely to show interest in this 
idea.

If you are interested in participating, all you need to do is to install 
the "b4" tool and start submitting and checking patch attestation.  
Please see the following post for details:

https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation

With any feedback, please email the tools@linux.kernel.org list in order 
to minimize off-topic conversations on this list.

Thanks in advance,
-- 
Konstantin Ryabitsev
The Linux Foundation

