Return-Path: <SRS0=Fp/t=JF=lists.openwall.com=kernel-hardening-return-21179-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC485C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Apr 2021 16:23:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 025DE610CF
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Apr 2021 16:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 025DE610CF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21179-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5382 invoked by uid 550); 8 Apr 2021 16:23:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5360 invoked from network); 8 Apr 2021 16:23:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6G3+OZqQp9tJwJbpfeOs5bop8D+dStV4QMNjNUA2tCA=;
        b=TtHskSvLyj69vK1NCJTAi43mfhUPjOkxPD6JbyziSbl7SJzch4R+8xG013pZQnNkeo
         MCi+JyVnrfhl3zL7fyFATmJrEoh6L3MqxEHNYC3Ir+EOyZhzDUDXGuKQ5QhVSoNnyyH1
         PoXSkpV6XJTxGofaxbR4HFXQygQ82aFV+tUZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6G3+OZqQp9tJwJbpfeOs5bop8D+dStV4QMNjNUA2tCA=;
        b=rWXg8v6igTCQQgU/92FTF+E/XBreIkUE6ldfYwMVHu8yddQalBisu6jonIquV+9Ksd
         72/yyKDRyTJrAOrvB7y1c09dJBmYu3MlR6BG/qb8NBEe6QzEAdeG2MVa7oPQ8ogigZyu
         mq67XcssBBhZ0mIKXuec2QVeauNS2VLYSXKfsYqpKsBBRrr4I/MYs32/YdATrB061UiV
         VOukCkk4E/hjj0MiCtbhVyHvW8e9iarT3tiAcTlUR56x3gqCdZpCLzrj3yNpuEznLEgK
         ixrOL3QaYY/8r8l6COQXloJ9C2p/O95SbTRfeUcEncaZwm0XBbKzly+2O9GCV4/HIgG4
         hRJg==
X-Gm-Message-State: AOAM531C3ynZrvydnzSzVVqKokYfaxeltR4D+bD/Ver5ESANDTzpbWYw
	ximFSRpKhZ1P0BtBVGMP4yKebflGPryi1w==
X-Google-Smtp-Source: ABdhPJyg+A+7BQ/qcQR13NfwG+a7uPoQBqWSUy/QGQbm5EMHADpOid76I0sctW3/3tECFhKohBMAMQ==
X-Received: by 2002:a05:6512:38d2:: with SMTP id p18mr7374811lft.323.1617898979202;
        Thu, 08 Apr 2021 09:22:59 -0700 (PDT)
X-Received: by 2002:a2e:a306:: with SMTP id l6mr4543789lje.251.1617898977209;
 Thu, 08 Apr 2021 09:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <7abe5ab608c61fc2363ba458bea21cf9a4a64588.1617814298.git.gladkov.alexey@gmail.com>
 <20210408083026.GE1696@xsang-OptiPlex-9020>
In-Reply-To: <20210408083026.GE1696@xsang-OptiPlex-9020>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Apr 2021 09:22:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
Message-ID: <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
Subject: Re: 08ed4efad6: stress-ng.sigsegv.ops_per_sec -41.9% regression
To: kernel test robot <oliver.sang@intel.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, 0day robot <lkp@intel.com>, 
	LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org, 
	"Huang, Ying" <ying.huang@intel.com>, Feng Tang <feng.tang@intel.com>, zhengjun.xing@intel.com, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Alexey Gladkov <legion@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 8, 2021 at 1:32 AM kernel test robot <oliver.sang@intel.com> wr=
ote:
>
> FYI, we noticed a -41.9% regression of stress-ng.sigsegv.ops_per_sec due =
to commit
> 08ed4efad684 ("[PATCH v10 6/9] Reimplement RLIMIT_SIGPENDING on top of uc=
ounts")

Ouch.

I *think* this test may be testing "send so many signals that it
triggers the signal queue overflow case".

And I *think* that the performance degradation may be due to lots of
unnecessary allocations, because ity looks like that commit changes
__sigqueue_alloc() to do

        struct sigqueue *q =3D kmem_cache_alloc(sigqueue_cachep, flags);

*before* checking the signal limit, and then if the signal limit was
exceeded, it will just be free'd instead.

The old code would check the signal count against RLIMIT_SIGPENDING
*first*, and if there were m ore pending signals then it wouldn't do
anything at all (including not incrementing that expensive atomic
count).

Also, the old code was very careful to only do the "get_user()" for
the *first* signal it added to the queue, and do the "put_user()" for
when removing the last signal. Exactly because those atomics are very
expensive.

The new code just does a lot of these atomics unconditionally.

I dunno. The profile data in there is a bit hard to read, but there's
a lot more cachee misses, and a *lot* of node crossers:

>    5961544          +190.4%   17314361        perf-stat.i.cache-misses
>   22107466          +119.2%   48457656        perf-stat.i.cache-reference=
s
>     163292 =C4=85  3%   +4582.0%    7645410        perf-stat.i.node-load-=
misses
>     227388 =C4=85  2%   +3708.8%    8660824        perf-stat.i.node-loads

and (probably as a result) average instruction costs have gone up enormousl=
y:

>       3.47           +66.8%       5.79        perf-stat.overall.cpi
>      22849           -65.6%       7866        perf-stat.overall.cycles-be=
tween-cache-misses

and it does seem to be at least partly about "put_ucounts()":

>       0.00            +4.5        4.46        perf-profile.calltrace.cycl=
es-pp.put_ucounts.__sigqueue_free.get_signal.arch_do_signal_or_restart.exit=
_to_user_mode_prepare

and a lot of "get_ucounts()".

But it may also be that the new "get sigpending" is just *so* much
more expensive than it used to be.

               Linus
