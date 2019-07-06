Return-Path: <SRS0=1LKi=VD=lists.openwall.com=kernel-hardening-return-16364-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FE9C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 14:33:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 87E6020856
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 14:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="HQzIhk8P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87E6020856
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=protonmail.ch
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16364-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8156 invoked by uid 550); 6 Jul 2019 14:33:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8121 invoked from network); 6 Jul 2019 14:33:17 -0000
Date: Sat, 06 Jul 2019 14:33:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
	s=default; t=1562423586;
	bh=haA5wvB0xh+dZtWZGeuep4dEUXcEIlBy0xdSwX483iI=;
	h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
	 Feedback-ID:From;
	b=HQzIhk8PxKYt36ErbKPrQMJqON9fHmTQ3PYtYZqeFvsD1zSHVwbkoGWN0bzw7aR8K
	 ARMyt0tMl0YH2vDYzZbyJiNYKRjCOTq+GXhhio/qQiJlEQqHfHCkqYGRG+bPNFvlhE
	 1q+18riMHNgpRcuVQ6PozQhMO2ct7zAiMwLG2T2M=
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
From: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, "Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 00/12] S.A.R.A. a new stacked LSM
Message-ID: <HJktY5gtjje4zNNpxEQx_tBd_TRDsjz0-7kL29cMNXFvB_t6KSgOHHXFQef04GQFqCi1Ie3oZFh9DS9_m-70pJtnunZ2XS0UlGxXwK9UcYo=@protonmail.ch>
In-Reply-To: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Saturday, July 6, 2019 10:54 AM, Salvatore Mesoraca <s.mesoraca16@gmail.=
com> wrote:

> S.A.R.A. is meant to be stacked but it needs cred blobs and the procattr
> interface, so I temporarily implemented those parts in a way that won't
> be acceptable for upstream, but it works for now. I know that there
> is some ongoing work to make cred blobs and procattr stackable, as soon
> as the new interfaces will be available I'll reimplement the involved
> parts.

I thought all stacking pieces for minor LSM were merged in Linux 5.1.
Is there still something missing or is this comment out-fo-date?

Jordan
