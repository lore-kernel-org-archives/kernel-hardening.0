Return-Path: <SRS0=+IkT=DQ=lists.openwall.com=kernel-hardening-return-20163-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AA5C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 20:51:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94EE522261
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 20:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqYQl09n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94EE522261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20163-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21702 invoked by uid 550); 9 Oct 2020 20:51:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21670 invoked from network); 9 Oct 2020 20:51:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTcVu4oETJELTBTO9Qx9E6QynJ2qRr0RMhI6Lss/kRo=;
        b=KqYQl09nzQc++fy4ixa3glsFIZci442nzrDG0fcwmUtpLC5GdJDecIntJaTr9BnU+k
         mHQV/FbLDSsp3LtFLsRl7T/zeVjv8Twr5lMP3mtNmGjMAycuhVQeNy6SxCfwNFW224a7
         0aTYXNZMa+jC7UhkQneYNe71rwlQlYDitPklTa97BhEb1m7+mN8rfc5c/j9aVJULK1tK
         kXqyUbQ8e7mPIF4Q1d2YHCkekuQkecmqoGoo0ONdt2lmrDHm6ydQldiw4prAm7vbUqOP
         n+GwBtayqaO7D2OKGp8MP+pmirMixqou37jYYe5EkC/YvLWRQkL0zC9bekBaZ8qVYuhi
         m9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTcVu4oETJELTBTO9Qx9E6QynJ2qRr0RMhI6Lss/kRo=;
        b=KnrZvBmCB2Gj4TStSkG726DNqVjVN3iLcLq8FT6boHXsADaRbnv2xXQ5hZPOruqMda
         OWK5ly1WYLiZMEp3HI2B8Mtzt6w6wtRZJcl8zoCdbBbJBP6ID2/apLExm5JnnhUhW5+G
         8ACubxT81zsAH4xYBHMgNf+yoRWpylSCUxnXlwU2WM8gTvpRcHnVTFhlcTG+ysgeu7ZQ
         gL2NKr/XGzsnGM/o2c7cE3W182czXoZXRJ6miVyNYf94nwOo+kMQc+cZ3Jm8SuPh7ByU
         Fckm9bDvUHAf5RmFOZ1neaOpG+Hbptf27eHB94Rqzl9jxpkroqr1zE4JTwKye9pCu6SL
         /pag==
X-Gm-Message-State: AOAM53066vCrJP88qN9MbcbWrKGvM8xN953WM2oNpz106qzdK+c2NEwv
	jYMsw6+Qn61r6if2dNnDqp/VyQ==
X-Google-Smtp-Source: ABdhPJxVwMwto7ILPuyT8ZZD/+7fv8lOOoXOE+RyXcVgFRqpvoLioQmgYU/5kPeWbujatJFVPXtviQ==
X-Received: by 2002:a17:90b:19c9:: with SMTP id nm9mr6551747pjb.6.1602276647984;
        Fri, 09 Oct 2020 13:50:47 -0700 (PDT)
Date: Fri, 9 Oct 2020 13:50:41 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v5 00/29] Add support for Clang LTO
Message-ID: <20201009205041.GA1448445@google.com>
References: <20201009161338.657380-1-samitolvanen@google.com>
 <CA+icZUVWdRWfhPhPy79Hpjmqbfw+n8xsgMKv_RU+hoh1bphXdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVWdRWfhPhPy79Hpjmqbfw+n8xsgMKv_RU+hoh1bphXdg@mail.gmail.com>

On Fri, Oct 09, 2020 at 06:30:24PM +0200, Sedat Dilek wrote:
> Will clang-cfi be based on this, too?

At least until the prerequisite patches are merged into mainline. In the
meanwhile, I have a CFI tree based on this series here:

  https://github.com/samitolvanen/linux/tree/tip/clang-lto

Sami
