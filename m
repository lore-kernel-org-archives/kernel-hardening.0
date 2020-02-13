Return-Path: <SRS0=GJ3U=4B=lists.openwall.com=kernel-hardening-return-17815-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0BCC352A3
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 21:37:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 777192168B
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 21:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BawgSQbY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 777192168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17815-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5972 invoked by uid 550); 13 Feb 2020 21:30:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5952 invoked from network); 13 Feb 2020 21:30:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfXM82VfoqeRc90gxFVeIWXJ41itdUqMd3xA0dVgW2Y=;
        b=BawgSQbYq1TbwSpri2I8yt8BLdW+yFwAYoE8dMiMSbSBq331xObis6ZCTB17z/2+pu
         BJ/TFbcNqMRECulsFRMIiMTcM/ovFgWzkJQC0Q8GiR94lJcnmNpi+fvP6UvLQSDrJh9R
         cMZLEUQ8JhCaHYaouGQIdPmwtosqiphyKcUZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfXM82VfoqeRc90gxFVeIWXJ41itdUqMd3xA0dVgW2Y=;
        b=Pqe4nIS0Fy/hCTPc9N2MHmkQVYG89x4xb9znDez9xtCk++W1WkfzRGf0TJEWczoi92
         VXnWRZc22jd1AWg8JiY5gIh/nBulsCxrKL1mAF8/hbbW8YXC7vFGSwPGXf1r1iYhBTN+
         fHRm0yvyJRYaZUNxq8u7VXR5Q54SVjb+3XRNmC77b9cIPtE8/QrBIv2pQZ/1MMQJEFJ9
         VvZpITCdrMIeLh32X9Yxnswz1QvYA1mNpf4ONnymQ/Mle1BGWH3gQyl22CPo4Lbz1pIR
         dz21xBGCehhw1MmKLtxqfWNIfEXCr/JSO9KLqLEX9WfMwPQp+CsJIJTnB/z12Cv6rdDB
         XELA==
X-Gm-Message-State: APjAAAXHt/6MFmX8Y4E874z6VFNs1X4nRfO2q5oEszwOWLgXAt+kUgbT
	5fsFr/k57TWZTpIhFy/Ya7CSd0TfwvM=
X-Google-Smtp-Source: APXvYqxg38nEtkN2LFB+a8NeTnW5hH3GP8YuHkbAhdBqoO2YbE5eP7jN//GpNV3iKOVhRmDVgorbAA==
X-Received: by 2002:a2e:809a:: with SMTP id i26mr12658486ljg.108.1581629431247;
        Thu, 13 Feb 2020 13:30:31 -0800 (PST)
X-Received: by 2002:a2e:580c:: with SMTP id m12mr12460727ljb.150.1581629427873;
 Thu, 13 Feb 2020 13:30:27 -0800 (PST)
MIME-Version: 1.0
References: <87v9obipk9.fsf@x220.int.ebiederm.org> <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
 <20200212200335.GO23230@ZenIV.linux.org.uk> <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk> <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org> <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org> <20200213055527.GS23230@ZenIV.linux.org.uk>
In-Reply-To: <20200213055527.GS23230@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Feb 2020 13:30:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgQnNHYxV7-SyRP=g9vTHyNAK9g1juLLB=eho4=DHVZEQ@mail.gmail.com>
Message-ID: <CAHk-=wgQnNHYxV7-SyRP=g9vTHyNAK9g1juLLB=eho4=DHVZEQ@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, 
	"Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 12, 2020 at 9:55 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What I don't understand is the insistence on getting those dentries
> via dcache lookups.

I don't think that's an "insistence", it's more of a "historical
behavior" together with "several changes over the years to deal with
dentry-level cleanups and updates".

> _IF_ we are willing to live with cacheline
> contention (on ->d_lock of root dentry, if nothing else), why not
> do the following:
>         * put all dentries of such directories ([0-9]* and [0-9]*/task/*)
> into a list anchored in task_struct; have non-counting reference to
> task_struct stored in them (might simplify part of get_proc_task() users,

Hmm.

Right now I don't think we actually create any dentries at all for the
short-lived process case.

Wouldn't your suggestion make fork/exit rather worse?

Or would you create the dentries dynamically still at lookup time, and
then attach them to the process at that point?

What list would you use for the dentry chaining? Would you play games
with the dentry hashing, and "hash" them off the process, and never
hit in the lookup cache?

Am I misunderstanding what you suggest?

            Linus
