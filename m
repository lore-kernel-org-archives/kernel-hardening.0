Return-Path: <SRS0=chWM=74=lists.openwall.com=kernel-hardening-return-18978-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B00FC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 10:28:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE7C020707
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 10:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kZswaULy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE7C020707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18978-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15775 invoked by uid 550); 15 Jun 2020 10:27:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15713 invoked from network); 15 Jun 2020 10:27:01 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:from:date:message-id:subject:to:cc:content-type; s=mail; bh=lRN
	65Oo0mc0F8r+DDWtw/MlluDk=; b=kZswaULynlWF7sUmn/S+Wf4vXyg4TwnY3od
	O5GhovqKcyRqGHxIJOJ9yNFmfnGMaWiNoKv6xs8QbvIwLDczGT6+CNi5gIgdtoX+
	qXfw+1VIROj31TKltcGorCqGsPNqevrneEZ/hFSwXlgoXpfdeJUKGqovJzsCTzzf
	I4gpHOJyES9f1nNEs00hqCwRXkuH8NPSHJwx8L5/shr1v/Vwi4weme+9OBZki7rO
	Mzu7YaruKWBmwypPdCcglUaOTNs5FBZaLLO9WSbnf7LAD7qU52LlGX71+/Cg7qAd
	vzqWdsmXG5jAw1t/Hh+PUCOh8Sma1rc4vELqQNkHUmFssGEmfRA==
X-Gm-Message-State: AOAM5319sE5+LpgOganxaOJiY/wlxAo7evku78x6/v3oFr2Uj7vqfyTL
	xEEmzbgVrzvNwQNAJN5tzqmgoxA4OqFwNTfFSIc=
X-Google-Smtp-Source: ABdhPJzSj8LwcKc9aY9w/6THuVZEOYoB+hlUyjHk6QP5O7EW9Yn2eEdLsBKYY2DjP/t7jJbqHTBjUDx25k5Bw9yRChs=
X-Received: by 2002:a6b:5a07:: with SMTP id o7mr26860787iob.67.1592216808485;
 Mon, 15 Jun 2020 03:26:48 -0700 (PDT)
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 15 Jun 2020 04:26:37 -0600
X-Gmail-Original-Message-ID: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
Message-ID: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
Subject: lockdown bypass on mainline kernel for loading unsigned modules
To: oss-security <oss-security@lists.openwall.com>
Cc: linux-security-module@vger.kernel.org, linux-acpi@vger.kernel.org, 
	Matthew Garrett <mjg59@srcf.ucam.org>, kernel-hardening@lists.openwall.com, 
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"

Hi everyone,

Yesterday, I found a lockdown bypass in Ubuntu 18.04's kernel using
ACPI table tricks via the efi ssdt variable [1]. Today I found another
one that's a bit easier to exploit and appears to be unpatched on
mainline, using acpi_configfs to inject an ACPI table. The tricks are
basically the same as the first one, but this one appears to be
unpatched, at least on my test machine. Explanation is in the header
of the PoC:

https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-language-2.sh

I need to get some sleep, but if nobody posts a patch in the
meanwhile, I'll try to post a fix tomorrow.

Jason

[1] https://www.openwall.com/lists/oss-security/2020/06/14/1
