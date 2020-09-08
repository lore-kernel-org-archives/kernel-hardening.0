Return-Path: <SRS0=PNgy=CR=lists.openwall.com=kernel-hardening-return-19823-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D8EC433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 18:23:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80234207DE
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 18:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oo/DQrZC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80234207DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19823-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9566 invoked by uid 550); 8 Sep 2020 18:23:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9534 invoked from network); 8 Sep 2020 18:23:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mfB0S2TmcGDxX8xZkZ/chTU0dmPHOOO8nuKSmYrB2mM=;
        b=Oo/DQrZCB0KIovn2oIQvAUWTptWqamehVi+n9pOLZRf1yPmAlsDgequytTa8T71Hfc
         MnZ8qfVQW2q6h/Gb3s3xMzJv0ALrHyHScJJ+WdbP6brRxtmNudTvVWKGbUjfoC5KHF4b
         uGSGjTSSevWadA70wvgbB72exIK9HnLgQdo9pBIgjKkAOXHzO50M1u7BZGl1okDbUiqz
         czRJlEsh6kR0+ujAUZ5GoU2okMRHEd7MJeAWIce5U7hvYLvI/36yTxGrED/UXTfJN1Pp
         +8kHwWJ0fqPNtnwRBmLuZUKXP2wEoOXwXAgDcmvidR+BlAhYV4QFIECLoW9snCOd1lTW
         zkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mfB0S2TmcGDxX8xZkZ/chTU0dmPHOOO8nuKSmYrB2mM=;
        b=lkWOWyHni5AUes6AnjRPrZifsIQbhjx5vPyXLViH3Ugjph8cQctXI/7hW4qITGe7ky
         EQNCTQS8E3CZH4odTndsTPgRszcdgpunEjjllArsmaoOEZSQdutnhApj15bvyCEGHqni
         3BnlusKnS9wMpnhCBz2HHjs6OoPAgt3lO4Iob5A2Ve4RxydME/BkX0isLmMX8GBxbXHB
         hIU3uAlnb+dqOcnY50fmWW9CNl4Uvw+NORz7eH72zXknHPJmJ+/+kAqPybaiqt1KInuY
         V2S6VRY/5dZc6bA8ErnQewgPoxQBa7bIMYHiaO45WxcDnrsnVOYVEHmNRtKMf2c5kg4H
         aOug==
X-Gm-Message-State: AOAM531Y1M8DcLMxYNgzDb26jftUgOHhLFg+R+9Nd3QuudESe1FywvVv
	bkMSr1M9X1IA/UBbuOZNcHJUGg==
X-Google-Smtp-Source: ABdhPJwprY99iDi73Le2vnSOxXHnK9OCb6eXlfe519dNjZDsp0xdQH72w/MWOHjt+KXl9278n5yCtw==
X-Received: by 2002:a17:902:10f:: with SMTP id 15mr24890192plb.121.1599589394447;
        Tue, 08 Sep 2020 11:23:14 -0700 (PDT)
Date: Tue, 8 Sep 2020 11:23:08 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 10/28] kbuild: lto: fix module versioning
Message-ID: <20200908182308.GA1227805@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-11-samitolvanen@google.com>
 <202009031510.32523E45EC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031510.32523E45EC@keescook>

On Thu, Sep 03, 2020 at 03:11:54PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:35PM -0700, Sami Tolvanen wrote:
> > With CONFIG_MODVERSIONS, version information is linked into each
> > compilation unit that exports symbols. With LTO, we cannot use this
> > method as all C code is compiled into LLVM bitcode instead. This
> > change collects symbol versions into .symversions files and merges
> > them in link-vmlinux.sh where they are all linked into vmlinux.o at
> > the same time.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> The only thought I have here is I wonder if this change could be made
> universally instead of gating on LTO? (i.e. is it noticeably slower to
> do it this way under non-LTO?)

I don't think it's noticeably slower, but keeping the version information
in object files when possible is cleaner, in my opinion.

Sami
