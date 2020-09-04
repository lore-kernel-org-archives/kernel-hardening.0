Return-Path: <SRS0=zr1m=CN=lists.openwall.com=kernel-hardening-return-19784-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035AEC43461
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 09:09:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 406EE207EA
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 09:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uerSpXIe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 406EE207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19784-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32177 invoked by uid 550); 4 Sep 2020 09:09:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32145 invoked from network); 4 Sep 2020 09:09:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=B1F8lj9Fqbo8dezZg1rybU9KGFv88k33ECwbjR1JZPg=;
        b=uerSpXIeuW8egdvhrBOxgSI4H2+MkV6nfqmwsSTgZe47kr+R4dT9esdHyC+dIzFWew
         7S+NReQ4tqsuASIVsTid6SoMhFv18Dm09UPS/qI9ygjssIKXTsOtlwtyAblWnz+QXIgA
         XQQyxE3czHKcKJKUZ38sgdUxKt0maQcuOKpyq2SZKMU/7x+b94LGhX1XcsxaCNmnRvOl
         nPRurPAzNxzekagJqkvPL+Ofo0aliDeqFYpMz7bAYCg64CVXz5kDbgHqmkKjkI2jPB7P
         rZSI8t3k4BggoJ7slMx/Y6IRXo20nj5bsW+eHMiIiwKCsAiMbBD1Pc5EydUQO1BwRsTd
         /ISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=B1F8lj9Fqbo8dezZg1rybU9KGFv88k33ECwbjR1JZPg=;
        b=cR++VTOyEZPMZwLgSz00sz0Ii5bxcz8B2nBJDLr8sVT0LMqrG7I2gnWq81eEU45YrV
         zIzzVtbiQh1eF2p0i99eZQXo3qUIKUd/4v9JipGLJfZuLEPHKU0LTv0PQcs/0+T1+77i
         Chk4aQMIgQyGH8LMpyORVGUi5huj8L35A74KjB+8i7Xmh3OnHpCfUfaxDiaKK/1GMtaY
         X3/OashVAfRO6DMXcGvav/+3nvfIrQTRFcIVFNNvSD0w8aW+47YDyAnpo6SWk6WHPKZa
         CUQJs9Da6kDMsRBxk/hlMpeSXicHmVicLqf4FPVX/UDfW9K0n4H8k+Mg6RyflH1yO2Bl
         JOzw==
X-Gm-Message-State: AOAM533/F+W4XtyUCP3NrREt1syg5bYgov7Pfxl8qVMOZPxvAytkKVEz
	N0ZC3ZPhTbzDrD64qcOs3ot5DgOVk1dTr5dvnuQ=
X-Google-Smtp-Source: ABdhPJzj5BSTE3f88vS3BroKAd3o5SJIpsD68NdbolonePhBudgEeFDjp+JjeTdgozVDGzH6QYZ+34EfW5ujOYGl078=
X-Received: by 2002:aca:d409:: with SMTP id l9mr4407752oig.70.1599210545701;
 Fri, 04 Sep 2020 02:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com> <20200904085520.GN2674@hirez.programming.kicks-ass.net>
In-Reply-To: <20200904085520.GN2674@hirez.programming.kicks-ass.net>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Fri, 4 Sep 2020 11:08:54 +0200
Message-ID: <CA+icZUVzWZZ=CCKEWiwsaMXM2Xy1F1NLNRS_2D15NeNZUGqquA@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
To: peterz@infradead.org
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 4, 2020 at 10:55 AM <peterz@infradead.org> wrote:
>
>
> Please don't nest series!
>
> Start a new thread for every posting.
>

You are right Peter, my apologies.

- Sedat -
