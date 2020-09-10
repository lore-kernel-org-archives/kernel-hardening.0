Return-Path: <SRS0=sD/m=CT=lists.openwall.com=kernel-hardening-return-19865-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C64C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:28:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E281B20BED
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C/Nbbf4T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E281B20BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19865-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32631 invoked by uid 550); 10 Sep 2020 20:28:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32611 invoked from network); 10 Sep 2020 20:28:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOtT3N7XbGpRxpxc8ChGzc7KDQ9tSEwlVL00HtmCks8=;
        b=C/Nbbf4T5rPk5brkoe050E2pcKCOvUasKnRCCFebyKdoxklwvBx0WXCmqjsDrbtpQV
         jR6WiarrGjbLiEQkOEZuNuB/YvertASUjGXTd4haT9x7o9clqXR3JKVcu0UMmGqYZUmU
         VAsc6ulw4hGipMG2uE+lsgPcKmNCYpytB/IHs6Oxg8HuAoZWBCKBvclBqizD+4L+LwfK
         nsSI43tbcdKmURrSC9zJfS5oLkDHyWRaABxsMPLIICw+pxAgpBCM5dVXdO+OuZg2E//b
         2h5kExRMIJy0tPvpHdEeBK6feABcxtN2G01klGZ6ScnLzyaR3hPS/Of9tc91a739PUWU
         5RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOtT3N7XbGpRxpxc8ChGzc7KDQ9tSEwlVL00HtmCks8=;
        b=PspFHlIGUP1Ye+KkgCQrsYhqRyocuLyc9KJePEoXxTi+A/wDqqDZliV6LTxm0Ol3FN
         1/bUnLYCdKAGPyZBt3FxN+S5mKqPQmJcBl/Z3RfPFgErL0X8jYzLQgR4lSTmJxjw5YxS
         KKMUWl8V9Aq5yIHhNKwFG6X1h2LLkgiT9ellsg+JFVOcySu/1K/RJveP9LZ+iMnvGNLT
         JtyHqVSpEwI0Vk/3SGg4yDY2Yh7QJZH8EP3T2SeKuGxzyJftBscwh1zfqoINVYhkxwng
         8kUt/wL3Sjxa1OLhqbei/8D1BzbxDZa0Wu2YaAmgd5Cs0xhIcyjfnfsh8E1LQdbxPmzZ
         vj7w==
X-Gm-Message-State: AOAM532VNh7Q3uy5gj/mPEf0YPhDs9iH8Xag5tSfunmw40Ri3MXOLUPo
	YocWmj67ZKHzoIFlKawfjBdZi+aYXXPG64ZDSDh5EQ==
X-Google-Smtp-Source: ABdhPJw5R/5Ez4aDdMGu21cR5k0AUCPks8j2VqSHJM0t1OaVkhoHiaB7U2J+4k9K0u43oPA3YLYttkRf9QTiPALFrsk=
X-Received: by 2002:a50:fe98:: with SMTP id d24mr11069998edt.223.1599769681295;
 Thu, 10 Sep 2020 13:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org> <20200910202107.3799376-4-keescook@chromium.org>
In-Reply-To: <20200910202107.3799376-4-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 10 Sep 2020 22:27:35 +0200
Message-ID: <CAG48ez3om6tRSjZhq4RBtbRCZaupTPJewEYbtN9Q-NCUzDjkqA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] security/fbfam: Use the api to manage statistics
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, John Wood <john.wood@gmx.com>, 
	Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 10, 2020 at 10:21 PM Kees Cook <keescook@chromium.org> wrote:
> Use the previous defined api to manage statistics calling it accordingly
> when a task forks, calls execve or exits.

You defined functions that return error codes in the previous patch,
but here you ignore the return values. That's a bad idea.

You should probably check the return value in execve() (and fail the
execution in the case where memory allocation fails), and make it so
that the other functions always succeed.
