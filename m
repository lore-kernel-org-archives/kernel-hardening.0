Return-Path: <SRS0=ef45=ZU=lists.openwall.com=kernel-hardening-return-17447-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CBAC432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Nov 2019 16:15:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 736F6217BC
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Nov 2019 16:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="GE+oxFtg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 736F6217BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lca.pw
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17447-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11849 invoked by uid 550); 28 Nov 2019 16:14:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11815 invoked from network); 28 Nov 2019 16:14:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=swAWjg0mWyZStjQq/JoheoQkEGMMdPmGAhVcEaoY9Xg=;
        b=GE+oxFtgNAcg6ATJOcfNRJ0lYQnf+CYQZpnNvAGWVvLlUMMm1ZBE0v2LoaG8Sv5gVx
         TQ7KDT/FmW8ULozZHKpdmQCCD7H87rs5XpLvQ0OJoUtrmEczrh0XUs1KkB5FAKUbeJ4m
         l31UyKZ7ZQYOb/TXZS07ah9oVgMfi/Wr1JngN75TOCq2pVOlbqGsj5MrAMyRANP21c65
         0mV3BniwOvi1nuc4BbZU9lw6T/7WQQKPBQsgKyDIgLG01XYKRCPpJfubIv4/CXCYceyb
         QpaybOq3bVONNtF/zn42GQcvuabSgrhPbVD50XQ/BHBf/MHV/875GCgDLLK4SHhAWzjI
         26aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=swAWjg0mWyZStjQq/JoheoQkEGMMdPmGAhVcEaoY9Xg=;
        b=LWvsMAbLNYo1Ioa8c0PkK2aVSPJEZlmXTFXJxIUcUCwVA34+9sJ6iiL1wzg7BSieQ6
         PaFOKUZDQKDyaokUR+DI6mOxFu2V/B1xEjy/yGY4GYyKk3fYGSwN1aqnWk9DL7jSDWE+
         SWOCce/VD6RFwKVWDu2ZUaqXP5pzqtEEWLK3gpiRNcS4KDxmZr5ZR3fS5XJW/M7OEY/m
         kNj2dn/zR/fCG2l7Gq8bDRwX7m/nG5PozbuVZ6SlzIE6Gxe3RHvhTxCm8JHUraU23jVF
         mwqGF5o8yYCzpXNFVK8wvhDGAnM8TkH5GG1Wt4PWyC0jKMxy4eyw+1DQvlQmeWlJXhmI
         FOMw==
X-Gm-Message-State: APjAAAXiVGflCp45HuNWXT6uH3IMFA/WPUxWMESspar7dZ8Di5JsPPQz
	SAJrTYYJK3WZOLlKiEZpTsfUyw==
X-Google-Smtp-Source: APXvYqwmn1ld2Vuf1VCvbx1/sMMTG95qkXhxsIXLZuBxGTgd524dbZVKZj5tWKroDxg56BukvcLyAA==
X-Received: by 2002:a05:620a:13cf:: with SMTP id g15mr10594494qkl.195.1574957679840;
        Thu, 28 Nov 2019 08:14:39 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From: Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
Date: Thu, 28 Nov 2019 11:14:38 -0500
Message-Id: <4B3C1889-DE01-43A5-B0BD-0CFC33A5315A@lca.pw>
References: <CACT4Y+a-0ZqGj0hQhOW=aUcjeQpf_487ASnnzdm_M2N7+z17Lg@mail.gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Elena Petrova <lenaptr@google.com>,
 Alexander Potapenko <glider@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Dan Carpenter <dan.carpenter@oracle.com>,
 "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 kasan-dev <kasan-dev@googlegroups.com>,
 LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com,
 syzkaller <syzkaller@googlegroups.com>
In-Reply-To: <CACT4Y+a-0ZqGj0hQhOW=aUcjeQpf_487ASnnzdm_M2N7+z17Lg@mail.gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
X-Mailer: iPhone Mail (17A878)



> On Nov 28, 2019, at 5:39 AM, 'Dmitry Vyukov' via kasan-dev <kasan-dev@goog=
legroups.com> wrote:
>=20
> But also LOCKDEP, KMEMLEAK, ODEBUG, FAULT_INJECTS, etc, all untested
> too. Nobody knows what they produce, and if they even still detect
> bugs, report false positives, etc.
> But that's the kernel testing story...

Yes, those work except PROVE_LOCKING where there are existing potential dead=
locks are almost impossible to fix them properly now. I have been running th=
ose for linux-next daily with all those debugging on where you can borrow th=
e configs etc.

https://github.com/cailca/linux-mm=
