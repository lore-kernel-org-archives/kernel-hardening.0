Return-Path: <SRS0=HNla=CT=lists.openwall.com=kernel-hardening-return-19866-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4C1C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:39:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1CBAD20829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WH2gIvD2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CBAD20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19866-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10133 invoked by uid 550); 10 Sep 2020 20:39:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10109 invoked from network); 10 Sep 2020 20:39:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYmngQGxhwrP1IO10+U44hIuDR+Bh29FacWTWPCzifs=;
        b=WH2gIvD2kocNW47TzoJUq8vy8koxj0ikTiqTurIt6Osqva8P4NIsbGtJVGwywUIjkq
         xe3qkruoqIuEPaS3xmqhN2h7V3FGdVjN/fZNXtAtjbUs+ii6wOWOxYBwlihrbKA6Dsi2
         ZcxxkAAiqBfwAJnSmslWIncB3hpPqqLBsQnucMZPZcNa3susHR1gFRdjKlEQ6Zwl4evT
         Ngj6/THEyDfAL+bxEhBtLcLnD1Efcq5a03Byz8i2VKTt0P9PSzdVa+iwn8BOcmkqFZjj
         WKCR+bEgC/b8wFZGdDbKxyU2GcFt1zleojRTJ6mzpqrmZfP30xuKihxrC7oSbqE+O1e4
         z6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYmngQGxhwrP1IO10+U44hIuDR+Bh29FacWTWPCzifs=;
        b=WrJQGInKSdiFAYGqrW1W3NkuA3LAZ38wB67s7R6/Q6GX9O9WSMcFcvaptMVTTZ2Qhc
         F8AUZxgZOFITvpsnPSR3qiD9zjnX4SoXQcPZiBMQbKC5TQA1gT99oWMOcXCbYV3u2pgV
         1a0j3KLFIqX6xsrjsllTaPODu+a2phMQCJWmTomFTXIO470pzAGLXfkvNXc27/FtnxcF
         nLA/1uZb5rHxFsUvF5VdjCx4c2qSQVauYs38geTJPRTf/Ih7TDcHOQhM9jZbnvNUezxU
         UoF2Peqqp9nEDFWkDwX7lppb3p8BoOGem382dP+4W+8/+uoaJP0k3hqWSMHHxBoV4gL5
         ZD2w==
X-Gm-Message-State: AOAM530gfZdbaCZ+sd198dAE9bkAoDBo4CCy7Xo7kXA+mTB73/4pBM5E
	qzbsM8E4Y86a/xi/9wO7HkunREcFS49m5ipK6SqlAQ==
X-Google-Smtp-Source: ABdhPJzQ6i+tHlAxsWiND/QkNM3WvkTC+Ju6Mk1rDHZmgMyEa8UX1fZqVV5xbVt8ItiYrZl+V7nr/bCNAXGD3jgXwtk=
X-Received: by 2002:a05:6402:7d2:: with SMTP id u18mr11556708edy.69.1599770370678;
 Thu, 10 Sep 2020 13:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 10 Sep 2020 22:39:04 +0200
Message-ID: <CAG48ez0WzMpTqaTgtZwQ9MenCoWuyFn1yRhL9R0+s+=pbonTQA@mail.gmail.com>
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation (fbfam)
To: Kees Cook <keescook@chromium.org>, John Wood <john.wood@gmx.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
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
> [kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
> also visible at https://github.com/johwood/linux fbfam]
[...]
> The goal of this patch serie is to detect and mitigate a fork brute force
> attack.
>
> Attacks with the purpose to break ASLR or bypass canaries traditionaly use
> some level of brute force with the help of the fork system call. This is
> possible since when creating a new process using fork its memory contents
> are the same as those of the parent process (the process that called the
> fork system call). So, the attacker can test the memory infinite times to
> find the correct memory values or the correct memory addresses without
> worrying about crashing the application.

For the next version of this patchset, you may want to clarify that
this is intended to stop brute force attacks *against vulnerable
userspace processes* that fork off worker processes. I was halfway
through the patch series before I realized that.
