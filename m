Return-Path: <SRS0=LCAb=HX=lists.openwall.com=kernel-hardening-return-20767-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59FAC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Feb 2021 22:20:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92D1264DC3
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Feb 2021 22:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92D1264DC3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20767-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28138 invoked by uid 550); 21 Feb 2021 22:20:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28115 invoked from network); 21 Feb 2021 22:20:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1qgd2CaVptvTGUhKDlRkh0Z0LDGRbgbRYJVc77psjI0=;
        b=fQbjNDMH2LW1wJ6/r4mnToB2sVMQoAqDNnIZC0tTft5RHW4oL4vhaTeQgpZVKMxF30
         nT/00d78iK839oXEHN4u+yaZt1zEu/r+rdbRCiRpFFQ0sRSQ1Q8kcb6WJ03qin0IMNCZ
         KtNASVw7j3Rywzu1pVAHxoAg6F7vA+1EvIbPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1qgd2CaVptvTGUhKDlRkh0Z0LDGRbgbRYJVc77psjI0=;
        b=JHK7M9CvRxpsldvs8g43vK94LJ6ZdZudS97XLu8u/KJCpSfJz5nOY35IEisg2TRIBD
         ok5DQTj8vTD+K57JzLl2VQwpWTo9KhhAnmkZfPpoxcXH2dCsuVvICUVeh3k2HgW8cjrq
         yoI/J1WmALQt3XIPhPrtvH8p6e9xGAjfhWiDSJUuWCAh4Qm/OgkKmj+GYOyS0t4woJqM
         nOAKLmGygBI925+TAV6TWBQU86+Y0JDh0QkR6SSiOSdl3Xbyw2EmQADLoFkTuMdWLvLe
         CZQnaQM5Y03F1TSnMEVJpmzN480ke6z1tDVFX2RO54ryzySw/lqjVRY549GdViFHBvG1
         MXxA==
X-Gm-Message-State: AOAM532ZsqY7VcaZQwha9SpnQ92d1dNhGzyYYOd7WRtAF3c6zL9kN9Ho
	jdPRoEiE9UWlmBI3Kl4e3scvrjtX3NPrNA==
X-Google-Smtp-Source: ABdhPJyYrcTOMvf1bMZXUTiaIdxaRmJNC08Q+FBIVNWd+Z8dBj4stMJNUU7Lz76hQJ+Y/ISr3ttJ8A==
X-Received: by 2002:a2e:850a:: with SMTP id j10mr13126359lji.491.1613946018284;
        Sun, 21 Feb 2021 14:20:18 -0800 (PST)
X-Received: by 2002:ac2:4acd:: with SMTP id m13mr6041704lfp.201.1613946016272;
 Sun, 21 Feb 2021 14:20:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
In-Reply-To: <cover.1613392826.git.gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Feb 2021 14:20:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Message-ID: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Alexey Gladkov <legion@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> These patches are for binding the rlimit counters to a user in user namespace.

So this is now version 6, but I think the kernel test robot keeps
complaining about them causing KASAN issues.

The complaints seem to change, so I'm hoping they get fixed, but it
does seem like every version there's a new one. Hmm?

            Linus
