Return-Path: <SRS0=Qow0=GV=lists.openwall.com=kernel-hardening-return-20664-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D88C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Jan 2021 19:15:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D2F0D21D42
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Jan 2021 19:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2F0D21D42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20664-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13760 invoked by uid 550); 18 Jan 2021 19:15:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13740 invoked from network); 18 Jan 2021 19:15:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/nyXt2BwkLcSSRby7WCMrmE+WdBMXZvF9/GDTDgxsVY=;
        b=FgEuPeyIPamZN1Ti5cyla9+JQiWchG5usHW0nz7RiFfN4ZG12cH4uk+0GptG8B/IWA
         J+9VHvATxzV0qZoPxsaWt52OJ2WeDAZZ0Ey4l9G4Byauek/KmFoS0wtarV9C1U/vQhcp
         zDcDF/LIEdOs4AuBkR07AWCI6pKVrt2L/RMZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nyXt2BwkLcSSRby7WCMrmE+WdBMXZvF9/GDTDgxsVY=;
        b=RSIYbGJrFfNxUzuae38/kMsdI9s44PFwRMFXDJct5b7DLIqaI69rBhsf0Tyd7U9Olj
         gHHQmoZNt6Mq3vHlqcwCRocP116KdYlG2uh/ORI18b4F+rC8fF0sJZYaPwFAxqJc0WUq
         3jstlwG5BDgEK3qA1aQOF9WylS8kwpDzW2/nQsJqcvDFElOYuU2U7fxU4LXj6el0g1i/
         BhepspZJ4IrPVxBoWkWPjLiw1Gv1uI2ldZG/otLEsF7aLOScrSwR/4qhKzXmeS/jz2Tk
         Z4w1raYuB7EpNsCwVs2F8xZe8RZqy3KyqagQK++6QQ0EBrnMWTgqPeVNG2cOAYIVZv9a
         0itQ==
X-Gm-Message-State: AOAM531MflJ0v0Z9ASbZifR7Xb4lqx8evu6hjMLb6MsLy98GyKiK6IHM
	4qen81W+iN3Dqo59W6654TU3kmVrrvy9pQ==
X-Google-Smtp-Source: ABdhPJzGvBNkcsXH8aTOLuHsOgPR/nVRmm3xwbZWSG73iOp9Cs5Zlw9WjLjB3SnFoBONR76oc5wTBw==
X-Received: by 2002:a19:4f09:: with SMTP id d9mr231666lfb.629.1610997306222;
        Mon, 18 Jan 2021 11:15:06 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr234936lfu.253.1610997304440;
 Mon, 18 Jan 2021 11:15:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com> <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
In-Reply-To: <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jan 2021 11:14:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
Message-ID: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Alexey Gladkov <legion@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 15, 2021 at 6:59 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> @@ -152,10 +153,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>                         ucounts = new;
>                 }
>         }
> -       if (ucounts->count == INT_MAX)
> -               ucounts = NULL;
> -       else
> -               ucounts->count += 1;
> +       refcount_inc(&ucounts->count);
>         spin_unlock_irq(&ucounts_lock);
>         return ucounts;
>  }

This is wrong.

It used to return NULL when the count saturated.

Now it just silently saturates.

I'm not sure how many people care, but that NULL return ends up being
returned quite widely (through "inc_uncount()" and friends).

The fact that this has no commit message at all to explain what it is
doing and why is also a grounds for just NAK.

           Linus
