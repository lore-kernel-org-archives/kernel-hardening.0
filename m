Return-Path: <SRS0=yJ9h=H2=lists.openwall.com=kernel-hardening-return-20822-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DC2C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 19:11:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A29E564E24
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 19:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A29E564E24
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20822-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32659 invoked by uid 550); 24 Feb 2021 19:11:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32636 invoked from network); 24 Feb 2021 19:11:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsetPJB5m47FCg13KC6GjSTLKBsPDI7MuzXhPKMTnS4=;
        b=g0wCVRLuZhRAZSx2tZaeQKkHmjHJt6HcVeX1wF81XK3ID/P21CzwT5FyHF6bzyJiaK
         7Wbpg65iES9Lwj24IG8yT/fkKOgtfPxfvdKC+qXihnsfhzxP5qlnVz0sgNHOO9KXWCV6
         eIoO/wnpUtMRNAs14sprZgujgxrvqBNk1ASSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsetPJB5m47FCg13KC6GjSTLKBsPDI7MuzXhPKMTnS4=;
        b=KhqBTuypGLJxqh6yMwcuQyMlNwBLHZ63JEpXWi3+FZy4SFfxyOHtO2GeRdDMPr6M9g
         Ju2I4MKHEb0TwKBiL4iDHfbGaOpr2I6KzWzk3oNNqWASA4YZgQ/YPjehO3E/BDgHtJsS
         qPAgjYrn1r8pM8nwkM/3KMtaqRUKaXf3QhRK76O+Zrj7MjvVXtxtwbldRVsU6xAEdHRN
         MM94i/Fsyb3Ho74jRSzyv32yuI5k/ByY3HlyfhjbMBzRgiQOlGju0qcmUPsk87fXy596
         4zroJ0YQqhOd7dqxeE0jLxIw7s4By5YvZI+Ghc4rHeG9DB19KlC6ThH+6Q6ln0uyekSa
         vBHw==
X-Gm-Message-State: AOAM533Z+imVNcKlka88GMUdIhjiR+FJ+3sqUeldou2iYr7P2LqvX5gL
	TTbnlEYiGl5NWLLPvn54trga1K9DwrLKmQ==
X-Google-Smtp-Source: ABdhPJwLUFHCMpmevTtaBij20uZMaYbEwyRmteWuPY/DLGDPCMTzkX3oPr5fslxhM0EsHLT3iB+sMg==
X-Received: by 2002:a19:910e:: with SMTP id t14mr21404415lfd.282.1614193862432;
        Wed, 24 Feb 2021 11:11:02 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr20000602lfu.253.1614193859813;
 Wed, 24 Feb 2021 11:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20210224051845.GB6114@xsang-OptiPlex-9020> <m1czwpl83q.fsf@fess.ebiederm.org>
 <20210224183828.j6uut6sholeo2fzh@example.org>
In-Reply-To: <20210224183828.j6uut6sholeo2fzh@example.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Feb 2021 11:10:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3wVpx97e=n2D98W+PSDWUkQrX3O+c7n7MGRbn_k9JMg@mail.gmail.com>
Message-ID: <CAHk-=wh3wVpx97e=n2D98W+PSDWUkQrX3O+c7n7MGRbn_k9JMg@mail.gmail.com>
Subject: Re: d28296d248: stress-ng.sigsegv.ops_per_sec -82.7% regression
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kernel test robot <oliver.sang@intel.com>, 
	0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org, 
	"Huang, Ying" <ying.huang@intel.com>, Feng Tang <feng.tang@intel.com>, zhengjun.xing@intel.com, 
	io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Jann Horn <jannh@google.com>, 
	Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 24, 2021 at 10:38 AM Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
>
> One of the reasons for this is that I rolled back the patch that changed
> the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
> spin_lock to increase the reference count.

Yeah, that definitely should be an atomic type, since the extended use
of ucounts clearly puts way too much pressure on that ucount lock.

I remember complaining about one version of that patch, but my
complaint wasabout it changing semantics of the saturation logic (and
I think it was also wrong because it still kept the spinlock for
get_ucounts(), so it didn't even take advantage of the atomic
refcount).

Side note: I don't think a refcount_t" is necessarily the right thing
to do, since the ucount reference counter does its own saturation
logic, and the refcount_t version is imho not great.

So it probably just needs to use an atomic_t, and do the saturation
thing manually.

Side note: look at try_get_page(). That one actually does refcounting
with overflow protection better than refcount_t, in my opinion. But I
am obviously biased, since I wrote it ;)

See commits

    88b1a17dfc3e mm: add 'try_get_page()' helper function
    f958d7b528b1 mm: make page ref count overflow check tighter and
more explicit

with that "page->_recount" being just a regular atomic_t.

            Linus
