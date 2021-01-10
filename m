Return-Path: <SRS0=wfMD=GN=lists.openwall.com=kernel-hardening-return-20634-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E87EC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 18:46:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8E709227BF
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 18:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E709227BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20634-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6042 invoked by uid 550); 10 Jan 2021 18:46:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6004 invoked from network); 10 Jan 2021 18:46:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQXV1o093eVpYrQ6SjYKMkYU2gxMAjF5N9e9XTlzNEE=;
        b=ZeHp/DLnTCjx/1ndzrrdXLbs+ofveQ60Mwd9VBFVezBZLlHfmdd3j2voOnqpw8488y
         HaLlr1rUwDJNnpcMRpAOAtKBNTqrWuGc2WNSPVEBGtVTzQC0Vzx8mbTatpAO5uM8+7wD
         /TrltXUH7SyNTMyWDX+1SlvDZZeSfzqrCwLlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQXV1o093eVpYrQ6SjYKMkYU2gxMAjF5N9e9XTlzNEE=;
        b=tcvjWmx9N1wKiBjGUXSApRA0PgIw7MPLDYsOjiLL9WSA1kqpNC9z3nBs2RY3P5HBSz
         6ifaU3prtglp7sZ930sXSZWzMg0uNb1WQIg2csLm8kY+YwLpLWe1UyHFi/c75lFExh8W
         VNnxB5SH6DJOeATg/bTSvq9WpNzsuJe2ajJIKy6WvwKj1PGJDYJpoHt7O4e0NmxfEGIe
         awXm7G62yCUpj4vSaSHVKBPFiu2Tyly7HSDnAe1zWGkBmufsuNrJnnfTfZc3P0PaFcco
         wRVg6Fjp9+OB+/e+7kVkSHzm4n+dlvaJmaMQ9DLqnamHO2giTW4CUKOJ4luMtDTicYzg
         G2KQ==
X-Gm-Message-State: AOAM530d9IezsqUxyZaZVtXAzTqoOc0zYkN6xr6FTreYDhwpIQr1Tzww
	SWN6Q2ToMEPhd30/bFEDObscGYRYEkasoQ==
X-Google-Smtp-Source: ABdhPJzdG1lQEM4ZNNnW8IhUhPRMydOqKG11f7gSDwLQtLtLOrJNLSYp9P6Qg8eTr3ul0nwQ/lsDHg==
X-Received: by 2002:a05:6512:14f:: with SMTP id m15mr2235562lfo.328.1610304384386;
        Sun, 10 Jan 2021 10:46:24 -0800 (PST)
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr5614023lji.48.1610304382840;
 Sun, 10 Jan 2021 10:46:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
In-Reply-To: <cover.1610299857.git.gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Jan 2021 10:46:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgXZmRu762bjSeK80+T_LTo+UP9y5rP-uvym1vquSxmBw@mail.gmail.com>
Message-ID: <CAHk-=wgXZmRu762bjSeK80+T_LTo+UP9y5rP-uvym1vquSxmBw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] Count rlimits in each user namespace
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Containers <containers@lists.linux-foundation.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, 
	Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"

On Sun, Jan 10, 2021 at 9:34 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> To address the problem, we bind rlimit counters to each user namespace. The
> result is a tree of rlimit counters with the biggest value at the root (aka
> init_user_ns). The rlimit counter increment/decrement occurs in the current and
> all parent user namespaces.

I'm not seeing why this is necessary.

Maybe it's the right approach, but none of the patches (or this cover
letter email) really explain it to me.

I understand why you might want the _limits_ themselves would form a
tree like this - with the "master limit" limiting the limits in the
user namespaces under it.

But I don't understand why the _counts_ should do that. The 'struct
user_struct' should be shared across even user namespaces for the same
user.

IOW, the very example of the problem you quote seems to argue against this:

> For example, there are two containers (A and B) created by one user. The
> container A sets RLIMIT_NPROC=1 and starts one process. Everything is fine, but
> when container B tries to do the same it will fail because the number of
> processes is counted globally for each user and user has one process already.

Note how the problem was _not_ that the _count_ was global. That part
was fine and all good.

No, the problem was that the _limit_ in container A also ended up
affecting container B.

So to me, that says that it would make sense to continue to use the
resource counts in 'struct user_struct' (because if user A has a hard
limit of X, then creating a new namespace shouldn't expand that
limit), but then have the ability to make per-container changes to the
resource limits (as long as they are within the bounds of the parent
user namespace resource limit).

Maybe there is some reason for this ucounts approach, but if so, I
feel it was not explained at all.

             Linus
