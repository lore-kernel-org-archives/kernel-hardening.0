Return-Path: <SRS0=ixy2=GV=lists.openwall.com=kernel-hardening-return-20666-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01795C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Jan 2021 20:35:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB8EF22CAD
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Jan 2021 20:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB8EF22CAD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20666-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11874 invoked by uid 550); 18 Jan 2021 20:34:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11854 invoked from network); 18 Jan 2021 20:34:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/gRDfD8YrbS3XwFv+1aIqhbdQ3uhWKzz+1gnqOggXc=;
        b=bt+FYJOGP9ZQRnSTHuwQLcEHZRbKmiPtmHbNsgK244Ouf8inj+gEKeqwbkLMxBsORz
         9XqHiL4j09NQl2Hbu7Zqohe8R4Mcab9BZ0x5QNfz6nqunlYqEM100bLwpChO1ztnC/8t
         YuMK5vRxoxly7Ufn/H5ahy9EptvTtBt/Xd6mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/gRDfD8YrbS3XwFv+1aIqhbdQ3uhWKzz+1gnqOggXc=;
        b=n2vN33U8ubN554rZq+TFyVwqkz6yZBAU6nLXp1HTrS8Adqm30BbaTOPQVGItNFzO/i
         ATlaYqwaFYa/XDMhVCFaj7Dmtutj4yjr24ZeH5PoTKFho9YX/hqe4nwy4K4aJiU0d2wY
         XWk9L5romRkEs6ETbB4XQUZ3ocAIIBMchxgVpLcUS7iOkkXcJQsPuUUlpPrGcdbOVNC2
         Z3zHYTflmZ/XTEr51iKhpHcbUknDpnQpV+1Puy0oDOji+lss2YSe5i5NUZ+StGtvcTh9
         VUvi3tRkIuSLAlyxPowmKbW3Hd6EjNz7ClxnVdknNLpz/wwgSqIFBj+9Jo5/bpy3P5q7
         TKtg==
X-Gm-Message-State: AOAM530JcjPnTUAQzgk0ePTzjYQ47mGrjDiwJ2ww8/7wVa8haC9CFLrk
	4DlUJE15+1YJVUxXYhxoGu5e1Kr74bbzcw==
X-Google-Smtp-Source: ABdhPJzfxj1nCCQPsVRPL8JWR+hZaTU9McbRf96ZUim1bofTfY5FhV67yLG5+LDRKShNJR3QyoYHpw==
X-Received: by 2002:a2e:98cc:: with SMTP id s12mr567769ljj.325.1611002087162;
        Mon, 18 Jan 2021 12:34:47 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr336671lfd.201.1611002085703;
 Mon, 18 Jan 2021 12:34:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com> <20210118194551.h2hrwof7b3q5vgoi@example.org>
In-Reply-To: <20210118194551.h2hrwof7b3q5vgoi@example.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jan 2021 12:34:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
Message-ID: <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
>
> Sorry about that. I thought that this code is not needed when switching
> from int to refcount_t. I was wrong.

Well, you _may_ be right. I personally didn't check how the return
value is used.

I only reacted to "it certainly _may_ be used, and there is absolutely
no comment anywhere about why it wouldn't matter".

                 Linus
