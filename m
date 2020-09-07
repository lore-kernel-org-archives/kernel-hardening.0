Return-Path: <SRS0=4xOh=CQ=lists.openwall.com=kernel-hardening-return-19798-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2AEC433E2
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 20:24:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A0F93215A4
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 20:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Vf9HxRnj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0F93215A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19798-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9320 invoked by uid 550); 7 Sep 2020 20:23:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26289 invoked from network); 7 Sep 2020 18:07:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1599502059;
	bh=7zF5NpWcH8s21/87X/Ym+6fJSfQf2cvf0ytrQcgPlcY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vf9HxRnjoi1CmjydjRcaBBL0vJheixiX9wqMHcDv4UuoZZOhsfNALRandZGDQgAd1
	 kEbHGY2J98vTCwAl/Uj/kFGRFwj8h+KcFKNXR/Md6o1otMOlS4N73YyAYMWmZTqVBa
	 pWARMSNopZ0y6w89mW0AfaKTCaA/xd/fDCtExbcs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Mon, 7 Sep 2020 20:07:26 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>
Cc: kernel-hardening@lists.openwall.com, John Wood <john.wood@gmx.com>
Subject: Re: [RFC PATCH 0/9] Fork brute force attack mitigation (fbfam)
Message-ID: <20200907180726.GA3243@ubuntu>
References: <20200906142029.6348-1-john.wood@gmx.com>
 <202009061323.75C4EC509F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009061323.75C4EC509F@keescook>
X-Provags-ID: V03:K1:r20XgpBZGGlIYes1JuwUvIHb52ySfa/yF/3UAxfqvL2afg8psFP
 Q2mdi/dIifErvkekdX/r27PqHn9vVWRRZqvHeD+kZ6QQPpOdjXgYxO4rfDIrruhxCPxGqUC
 FgR3vavJSJD+kjPayfRt4xpjr31ih/1SpW2einud3Vg9dxK2M7JkWjjc9nhSPgGnjsY3S8Y
 AF7vKqLeCowcMlJIgP7bQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mY5cKOoYAE4=:3EtrUYuFG0mSVvaFhHLttC
 OxzNV6qBxB6rQMqNvU7YcfTXIxRVpjLHqu9VS/59HfV92/RoLI7LtPrl/DDtpb3Nc99zkCT0Z
 cmJ22c3gAOKFm3+tU4YyZqMUGa5HtCWuwL9F09d3t43r4oIdXD+j+KIAmYZBq+pgxmHiB/dT9
 y8joW4JfRfLqiOdh2OixoZdGdJpx4RG04WiGAkjBnbOGGgdXIJQcCIIN+Wz6wYg2l3VLThkjY
 pj8/gq/VZibPNtaO9/rdg6oep3nHBzAfrDJoeGJaeEqT/ZiI3kEU3HQVhf/PdRZw0va0slrMx
 iZNhGYxTfF1Z43Z8LTPgQFSU8EMZ4SkiOd/twmFmClKe3Hixu51vVz9yBUh1EyUcvgzb1K2Ab
 PmsiwLxoSmoH381aBOpAbqjndRhwW4eMxMJaVmxXWC+VX8VwQyLI4wELvolJLpRdwiIYCajG2
 eebV62XPDSQg3gpngCvlS8E+GfKE6YioxWz4ScPv8BgFUdigx64+0sENH34Vc4GmJccQmqJDH
 NZG2M9N0ja0ikRvBPeGWQtLR4UYavCPfRk8CKZAcahIDxAcX54pIjmfPJJ4PVAblkcvQK46uO
 Ru1q2Y/RVTw9iP5u4nbocaNGdcnAK6KM/8yhpe8wrhrqeTIdi1U4gk5pkA+JYIkcXDbHFf77F
 jFh4uPshXB1iGQFWcpRj/rUX2NSNQt45qA4oiVb7J63IodkmCb1H6WYt8haHEiGv/yqtIoWV+
 OZ2UUp7UrqnO0TF6gGILSh9+XrT1yuUUXv9AoB6k7Wp05gvheuQY9C4S1BTeCoO1gEOLogl5M
 4cqCWzoydMWvwe6wtieju+2FPxvr6Ac/4YTMM8itvRRdeGQ96hAEotvCawGZcUG2qVAzQIYcu
 rZ6dZY20xew/72bahztc11MdcfoBAtl4LmBpan6MVolTbu/VcTeaQu2nWBw1MarR7BNcdqopW
 totm52hwdUhIoyMp7oAw86L9gAHIZ9uzJo6KOVIO3AQcaUQDhk6VrywxpSUkAuJM/5oqKXjt/
 UuUyf3skbmst/dVCOUOIFtLXkIuUt+pW/STcU93K3FoGevdTDJC8I1uyxPI5XiPYEvZD6abgd
 EYAQRVuC4Rf9gYeEuegpicsFJQS4L26ESSnVknis8eZID27j80f6EoUz61MR3WwZUAhuJhYf9
 RiPkTIFECkZSrpSHGWRLjFR4bP0HsQj66mIbCFcmdvEo9K6zus7oUlOffBdyggcBtI90KM4hK
 0B4xKeNcYjyn03xheJeWswxHuwS6pvkzPOds3Uw==
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Sep 06, 2020 at 01:25:47PM -0700, Kees Cook wrote:
> On Sun, Sep 06, 2020 at 04:20:20PM +0200, John Wood wrote:
> > The goal of this patch serie is to detect and mitigate a fork brute fo=
rce
> > attack.
>
> I look forward to reviewing it on the list! :) In the meantime, you
> could try adding this series as a branch on github (or whatever git
> host) tree you have access to. That would allow contextual commenting
> there too, if email continues to be a blocker.

I've added this series as a branch on github. The branch's name is "fbfam"=
.

https://github.com/johwood/linux

I hope this can allow a first review until Matthew send the series to the
mailing list and I resolve the problems with my email account.
Apologies.

>
> --
> Kees Cook

Regards
John Wood

