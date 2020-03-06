Return-Path: <SRS0=vEX6=4X=lists.openwall.com=kernel-hardening-return-18101-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341D0C10F25
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 11:46:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 88D5D2072A
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 11:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNrX6AM0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88D5D2072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18101-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7522 invoked by uid 550); 6 Mar 2020 11:46:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13874 invoked from network); 6 Mar 2020 07:54:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWIoMeEB2CUV9mwiKAX71h5fko7k2os2QipVNvf6bCo=;
        b=PNrX6AM0uaL/bBdobe7dNADUo+F4/G1hUMaxudkNpBcH04picEhD9scb8esJBu6Q8a
         A7NTB9tyLFjUqB0Vb41KIuF5FxaKvLvWhw+T3Vo62B3dpWk75cmacDwHBt3zF1aizmPG
         N6NQ0FxUXTlZL+gPZkCLmVzv/rkU2ShqN9g8ELn3yjtOxdhMkq8ZuTaMeuEEjZNG+KZj
         qPvK7hZhtn27i/JgwlrAdko9a3PCR3Eq7bYcoaTGUGV/FdXuzzbksDpnqZK+fe0HFbD5
         3bwKi8/YJ227AsaLnnoEwW575gt7UXxRPjLV4V8wyTXWk+4KsQFkWq2K8S72dKjhXnVV
         XQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWIoMeEB2CUV9mwiKAX71h5fko7k2os2QipVNvf6bCo=;
        b=M7OVV6XZYie3RGb7bNrQmBzmJ7FUzPf5t4u6nJiomKD8gBG/eiw7VWavt+mpGLMlgN
         Ta4VD78lZLa+Z2mS4fKJBuC7Jl9BRkbxjuR2a85HYUHksqtwFykM+gjAmq3QK+V61c7b
         Bb4NU06eEQI69UTkHcSy4hsPcc5CtJ4/Ufp6/JDVLz5OxMa65Iv8kwCT69iRX7GO/V2Y
         ujswWJxpaoRnaGOHES+AfrR6iBswbUFZ6jksXL4+wtVf3hH9W3snJT+f5kiksI9zr9qQ
         tuiJgQ+Qv92KgaXh8zc7iiDxzHtqTMvicjf/VSXIq4aww/R5jQ7K524AlFA9Y+pZDK1g
         2C+A==
X-Gm-Message-State: ANhLgQ3hmxCtXH8D3Y6zZpxn2EQybEqsuX3lfYrprv1007ub5F+UI5Xx
	V3s1hpgL8CbAbm514yNmgFRYNWTWYidwycfracI=
X-Google-Smtp-Source: ADFU+vvQFehPqcFAEG48yvZ7aCbXwYyl9wcrvV8Hrk3L/zkur4PN0je35ufuF1mZ6Z0WKNa8hjuWx2TxU5yX8MAX2j0=
X-Received: by 2002:a17:90a:d205:: with SMTP id o5mr2271425pju.46.1583481251417;
 Thu, 05 Mar 2020 23:54:11 -0800 (PST)
MIME-Version: 1.0
References: <202003021038.8F0369D907@keescook> <20200305151144.836824-1-nivedita@alum.mit.edu>
In-Reply-To: <20200305151144.836824-1-nivedita@alum.mit.edu>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Thu, 5 Mar 2020 23:54:00 -0800
Message-ID: <CAMo8BfKDF+6uw_jxMa2BuNScJS=PMiwFhb9YhH4DWD+jo4+dyg@mail.gmail.com>
Subject: Re: [PATCH] xtensa/mm: Stop printing the virtual memory layout
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, 
	kernel-hardening@lists.openwall.com, Chris Zankel <chris@zankel.net>, 
	"open list:TENSILICA XTENSA PORT (xtensa)" <linux-xtensa@linux-xtensa.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 5, 2020 at 7:11 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> For security, don't display the kernel's virtual memory layout.

Given that primary users of xtensa linux kernels are developers
removing this information, and even disabling it by default doesn't
sound reasonable to me.

-- 
Thanks.
-- Max
