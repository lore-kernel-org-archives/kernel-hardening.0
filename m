Return-Path: <SRS0=NpKP=CF=lists.openwall.com=kernel-hardening-return-19687-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA13C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 12:29:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 159BF207CD
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 12:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QyauHyC1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 159BF207CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19687-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19730 invoked by uid 550); 27 Aug 2020 12:28:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15593 invoked from network); 27 Aug 2020 09:34:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=OPN019dv0ZwUErJy29rnKsWnH/b9Woj3nbMNGrhAC8c=;
        b=QyauHyC15viX8/8BETQHlA5pax/IjzY2rWvLVuAuDl/aesI3URhsEWV8La+UcF2aVm
         m6zW1XaCMrXpkMix02OjT9BelGbwB5kM1LV7nGw+onYgBfkOhl/NE6CTCBRofdXqL6+A
         19IcOKKtBV1dOQ6wXaWpYAG/z8wtS28hnixs8V4HiKzuVENEFpmnYlSrLlzRJIAGK7Ka
         fwlStZZUBm8wIffQaA9j/8d80xQB63VXetYk8UTIJX0Ava4YvK/QW1H7BYkCdkwYs/wu
         /jc6vpwc3osLgK3/HEFkDTlRVMKL/cpNloPS8Wd4o3iszmzY7jEpij2iumzvqffjt49H
         k3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=OPN019dv0ZwUErJy29rnKsWnH/b9Woj3nbMNGrhAC8c=;
        b=Zgc1MuDy27GfIfvfGL9OnOUrS9H8P140Lei18ry+E+11lD7RUlhf0lE8d6LFi6A7/t
         Z5KIVucfI0xbAT/DkQ4r4hNA3GQG5NBMAkbAGF+2lY9pJLnZ0Yo2Wz0STjFXL6p60DdE
         mbGJ0X+CQvyNSoefg0H3KArkTO0125gV4tSgYDoTyf6udaDI6A4qk1HdqikDr9FGzoBM
         sN4e4SrRgtjXUtqguBq2zXleADUDNYyAEad4pRb1wCyptL1z0MbIgvC3yoVBuTRiiEGP
         HEyZqOwaAXhGOM9BQjJznihSO0LHjH0xyEsjfupdjCRtloSIUOWpNpoFuwmwe8MO5WX/
         W+4A==
X-Gm-Message-State: AOAM531fCS0XPFHMcVzxfN4730ZXivhzeDtUObrVzirIjH9GoGbB+byz
	uV5agrWxBvz2eHZmffqRsvQ=
X-Google-Smtp-Source: ABdhPJzffUigmoS/TVvnVrsWqLpw6dP+dVGX9uIaZIdtyoo+ufdyWlLglYNyqstNFbsWvQVHH8RfgA==
X-Received: by 2002:a17:906:780f:: with SMTP id u15mr6347818ejm.259.1598520858899;
        Thu, 27 Aug 2020 02:34:18 -0700 (PDT)
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date: Thu, 27 Aug 2020 11:34:17 +0200 (CEST)
X-X-Sender: lukas@felia
To: Mrinal Pandey <mrinalmni@gmail.com>
cc: skhan@linuxfoundation.org, Linux-kernel-mentees@lists.linuxfoundation.org, 
    lukas.bulwahn@gmail.com, keescook@chromium.org, re.emese@gmail.com, 
    maennich@google.com, tglx@linutronix.de, gregkh@linuxfoundation.org, 
    akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, 
    linux-kernel@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
In-Reply-To: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
Message-ID: <alpine.DEB.2.21.2008271128540.25858@felia>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Thu, 27 Aug 2020, Mrinal Pandey wrote:

> commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> spdxcheck-test.sh to the repository without the executable flag and license
> information.
> 
> commit eb8305aecb95 ("scripts: Coccinelle script for namespace
> dependencies.") added the file nsdeps, commit 313dd1b62921 ("gcc-plugins:
> Add the randstruct plugin") added the file gcc-plugins/gen-random-seed.sh
> and commit 9b4ade226f74 ("xen: build infrastructure for generating
> hypercall depending symbols") added the file xen-hypercalls.sh without the
> executable bit.
> 
> Set to usual modes for these files and provide the SPDX license for
> spdxcheck-test.sh. No functional changes.
> 
> Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>

This is a contribution from a candidate of the Linux Kernel Onboarding 
Mentorship. If successful, the candidate will work on improving 
checkpatch.pl so that we get closer to a state where we can run it as a 
bot reporting on patch submissions to mailing lists.

This was clean-up work we came across looking at SPDX license warnings,
script shebangs, and executable modes of files.

Acked-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

> ---
> applies cleanly on next-20200827
> 
> Kees, Matthias, Thomas, please ack this patch.
> 
> Andrew, please pick this minor non-urgent cleanup patch once the
> mainainers ack.
> 
>  scripts/gcc-plugins/gen-random-seed.sh | 0
>  scripts/nsdeps                         | 0
>  scripts/spdxcheck-test.sh              | 1 +
>  scripts/xen-hypercalls.sh              | 0
>  4 files changed, 1 insertion(+)
>  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
>  mode change 100644 => 100755 scripts/nsdeps
>  mode change 100644 => 100755 scripts/spdxcheck-test.sh
>  mode change 100644 => 100755 scripts/xen-hypercalls.sh
> 
> diff --git a/scripts/gcc-plugins/gen-random-seed.sh b/scripts/gcc-plugins/gen-random-seed.sh
> old mode 100644
> new mode 100755
> diff --git a/scripts/nsdeps b/scripts/nsdeps
> old mode 100644
> new mode 100755
> diff --git a/scripts/spdxcheck-test.sh b/scripts/spdxcheck-test.sh
> old mode 100644
> new mode 100755
> index cfea6a0d1cc0..e2902520a081
> --- a/scripts/spdxcheck-test.sh
> +++ b/scripts/spdxcheck-test.sh
> @@ -1,4 +1,5 @@
>  #!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
>  
>  for PYTHON in python2 python3; do
>  	# run check on a text and a binary file
> diff --git a/scripts/xen-hypercalls.sh b/scripts/xen-hypercalls.sh
> old mode 100644
> new mode 100755
> -- 
> 2.25.1
> 
> 
