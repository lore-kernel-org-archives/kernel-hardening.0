Return-Path: <SRS0=2ZoG=H5=lists.openwall.com=kernel-hardening-return-20859-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B939C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Feb 2021 18:47:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9AD0E64E76
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Feb 2021 18:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AD0E64E76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20859-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15421 invoked by uid 550); 27 Feb 2021 18:47:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15389 invoked from network); 27 Feb 2021 18:47:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1614451609;
	bh=J/2b6NEYhEHBGcmytB/YTbgIH5/VXzloVXnWUStq1M4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=As5Uu47gsXR4tZZ/erDuXq1HoXroXexuc0bzMPjp3SRoSnF2xg6b4VtERW6j56FXD
	 bTAuRqTXtaWYCpoRoe1jXRPa2fki1tRn4WfOKhnFx/OnqN+9zPGEmTBwoq6or2LJXj
	 NTRLbXC8asAWglMxFpX4/tu129ohhO++8Ff87ki4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 27 Feb 2021 19:46:46 +0100
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 0/8] Fork brute force attack mitigation
Message-ID: <20210227184646.GB9641@ubuntu>
References: <20210227150956.6022-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210227150956.6022-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:SJwNcWrWbYXbNCBYNMBy4exbK5hFoif3xaEWjQVjyL073jTJhl6
 WObAEsvgABv/Fhh2/eqdE2Yj1+f2Sy4NaFZy9u+weiugOqPHWEGwcKC+oeGiaTxa7v9oUYO
 efv+ggc3tpOSjd0Ukjo8zJ3YkoQKxlkeiHGMxOBpik+G1FmYnsHevV7VSVwLtvtSqLVsHcb
 NGHwE8ljEiVLTL2jngk0w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ShESOMNlNjI=:naVNAx9F4lNCq5p0LzpgrA
 P5Ojg/56wmthBB1B8JsfIbPJwp+GQJzKgoOU0zDkT+88VXLssYwLL28EYy5CwQsikmEN6b5Kp
 xY0lyyTp6W+vBVkwMtZPcfhOMCSXno4vviqRkpNhouohAW9sbN5Eu33UvkMqmKE74LIiNJI7+
 GqdTQfbeVQLttM6tTWJV69qQVfcTEKddPAA/FR5MzuHmCj+2iDTnf0e956bd6FZkawxOhawa+
 YSJPE8dG4yHLIx5QpEeBTkU62xMPsFVuykAKu+lF+7fagY0UA9RL9WAe/3zASzqj+T7VBbPFX
 OkxqCW11Uwky5kR+/RUH19WbTTG0FUGVfGEbQKpo5Uw5yHZt7kGZO7dnBcJqnsmGNkWNqV2xl
 ljoQCnL3aqx+JBtNF9e6wwbGOM52yh65C53kR+shnuhCo6wW7cgft3SYlvyz0dVliOeZglm9J
 xdSS0M6o5iAUAyRtU7VW+wOEmGZTxj90YssvM41LutFqADVscf3ttkoBLck5j4P1ypbhhJqhH
 PjinG64J/eQJiKGxFB+HeUl3J0AEXfQSghKMEIHoq/+05i/BPQ9+rjx8+3tJO5g0oAXpF7wvN
 5OI8LlsgMLH3jsqvqLaCl9ua/XFizmAnngrAznO0YY6rNbuOuifgXYV6/um1+9xxoJEKtJQXN
 mAf7goEq62024sRaQO01Qnnu6TbGG9JKUXtineSquDDuu9FZno9AXvVTH20bGGWCPkRRpmKJH
 H4k6bQ1dzuLXSguZ99a7dS3M4U/EYnND7QrfUGe0d2tdo89zNZhk7T0QDKAtIEbX+5NE7DQin
 ixcbhgpya7o75m1xch2fy97K1xu/of92BHukKUaQT6eabYfOZAqOhm6MiQ/rcmnVfysl0VJKy
 9JwtKnOzt0io9AsCnWVA==

Sorry. Drop this patch serie.

Thanks,
John Wood
