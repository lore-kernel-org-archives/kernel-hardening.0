Return-Path: <SRS0=0HaS=CP=lists.openwall.com=kernel-hardening-return-19793-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B0DC43461
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 20:04:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7030208B3
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 20:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="d63SpY7C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7030208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19793-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28259 invoked by uid 550); 6 Sep 2020 20:04:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1992 invoked from network); 6 Sep 2020 16:12:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1599408717;
	bh=/amjMUg2T1BdbWScM72zHHWYjzjVJC1FUA/mTT3/DgU=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d63SpY7C2aplAFROugxxwA0ZJtrtqo4fAr++xvPw4XpOF/a6sjCIgXAcU3eC/qnhS
	 T0S/2BgLUTzhj2RxT1ufikRFQ797A/vYLou4BWT3qcNem4bfAxcoMSieBzGZQBHoPq
	 8Gq86DQ61HfJgieDI9sXvadbssOLRyrf1CeBFAik=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sun, 6 Sep 2020 18:11:54 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 0/9] Fork brute force attack mitigation (fbfam)
Message-ID: <20200906142542.GV4823@ubuntu>
References: <20200906142029.6348-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906142029.6348-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:cFfmXAADgWihEeWQxGJdQeMo2AS4YN8IHsVcdTzDsfWdfgHX+4t
 tL15lO4SLR5ADpf++yFIEbw1zyeTgadmf3S0aJ7lN+KVXLAVt3rDldZ8e9MLb7p7sPk9f6U
 etZEychi3ToMu2azNaQOeElXoW9og7Avaq9peZEvZpQXnGgyfMPC5aRbe813ypQvQ+8qig2
 DP4owoRgQhS6KK6vY4D0A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nBxAs2xYUB4=:AGjHlzhMsCq0p6p3kz2EGM
 bNuhDaUU0zKPSf3p4cvwVOmuGepfuaKm+apIx8twc02tveML5EP7W3z1ULkIln6GXjMiALcCx
 19PAH51iFMuwmCfs8h+Lz2OOAmkrwLUtQmzCdxpdyfLW7zmijGPPwk78y5PNQJcpRFu0r52vm
 ywGyb4+w3OCSBcbkanceB16LjS0erVcRY5ceSlrh6PLHnWMkveARuAE+jQWp4N2JNqdohyurB
 opoVj3nm3rFVYIiGP5XDWVx9vY10MyXHEb2uHXBangcICPkeDuSVB8pQnVpd43mNOTp1w+Gb3
 C28nfiKZG+iZvBfzX65oOJFoEYTDXvu+z8LOYsYxMr8ufh3Dq/t9p8ei1U2hXlxefF20ynh2W
 Lu25jDCLuyPLUMCWy07gGog7OH8+mIQ/ZkkyHOc3GIyS87n5yFVaf/djH7umWFKDx989wZaY7
 Ee4SWFNKQ+TbPuZggDMI8+NIy8Rf3ucpREFnVP4zENhwPXCSUER+aSv8JaXf0gcEe68sDrXp8
 k6UMEoIBRh/B9qixRYyDPdb3gUkAIpMK7yANoGFa/ecm1o7gAXh85OjZDZetAwp7BDyHF8Sw+
 Xcq9yTpR572tCQXC/ya/e/OQkMF3jHk7A/uTSZ8uCKcUqnsdFgUM5TARc86F/2X7nC+Nd8zzk
 bc45rlIQiCsfXDYwcSla/YmVADUD5F+K2E2IG7jUD+VHoGYk0KNK00Hs7+5EDQGVruKBjZulT
 /lnIXUKJzW2gi2E1npqZtmWcEqKqFx4EnHYECINnlg+woD/kOt6NlUvfGR1gTPN90ork3mPuf
 CPNsyTsOnvvivRcDqvHB3VJl5v1aLwiEUEFfP0OAOXr4U5+530/1uZD4kl2Bzz+iTF1Cfd/qu
 o3PGKGnf/Lg4MrAzF6rZRBIWxcwwAlBSy8JFOaLOM9IyyutqCRx4uUtKy7lIsggJW1AXhCnc7
 /YiokHPf44aGEpIB2OaY45TTUtyPHLN9wYESMn+bsIMsYKfuR/tmN10Pfe3sz1ru+wVxOcjKb
 d9h8SIJMi0ki0E4lDlRhJhp4X50R7VKt4QudT37ZumcANNj2QIe/+bTRxx91wRZUHNge4gAWX
 PQFI/hKOzmRjoX7n+DQdCQtu/HogAPfj6TvDtGxFlhqdNHXQpuQvWvghUSnfxGsel+SPlIC31
 VmCCN7CymQvRAtRWgXo87y7bP9MWzF6mJ6u1Gw9sds3K1DNw46n0rwi2OtZR4SWn9qtqoWbJH
 3sZLjZfObWjKzXBX/Mr1dfxhmcJKPdnPQwnalDw==

Sorry, but the problems with me email account are not resolved.
Please, don't reply to this message.
Apologies.

I try to send the full patch serie as soon as possible.
For now Matthew Wilcox <willy@infradead.org> will sent the serie.

Thanks.
John Wood
