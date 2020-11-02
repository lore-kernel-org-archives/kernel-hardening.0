Return-Path: <SRS0=WQeK=EI=lists.openwall.com=kernel-hardening-return-20317-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D89FC388F2
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:10:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DEDF22071A
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HjoXjBTh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEDF22071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20317-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32176 invoked by uid 550); 2 Nov 2020 17:10:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32144 invoked from network); 2 Nov 2020 17:10:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iUhgKcjbc2s2EhhIkvemuRNHWDak5R9RJ9CGVBXgZ48=;
        b=HjoXjBTh/qMKF+PBX2unf6tg/4usdIKMSKAIxixFWbuZHeBxEiGMSat4Zh8HZSatkD
         yh34u2mi6GUPgEYC6XkEPYo9Jg3f2gJXkUFr9G4Vvun79vVX68OERc5TLzSyunRKdFDX
         dXic1qzf0FZGzvOWnm+oao39D40nWO8SbcQW9xGmSduixw6yzJAAWRiiCCgacbUftFDg
         CO3ynoaxLyFgWKeEvUBTvyhNfWfeINFsEGF0BpEt24j21pUMQmdXQoisKd5Nrev316TT
         QVVxu63+MfITJp0rNMsvdZHkgJ6zrk7DolMLGWJcPuz9HNC5O73afCtEwXRLxA/Cvp9z
         P+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUhgKcjbc2s2EhhIkvemuRNHWDak5R9RJ9CGVBXgZ48=;
        b=Uq+uyfq2WfjtcO5+CU3AVq08ZcaLtgN+aR7u8rQZwaFEU6YtJoi2ipZNZLzOlgLQsV
         34+YPEWWevhKd5h7u90ywxCHznbM0GUE2go7VXwxCpYTPhF0Gt44vzYHMSjoAe7bGNd5
         v1VYfWDxeuDDCOv3PbMQUy1XjzLo729T8ygbEyHJ2q0d5RJ+cuYNCy9BcSu50r3mLDIm
         XCwltG8rb7v6uoUPinqr3z/8VYAFrriS6UWwYAg59q59Uhz+/gD+8hHN/RPtpkxzd4Sv
         flaaXVBA+e1tFpWIQ5/oSCyFVUPhvdFihAXGxuAuMaPDEvs2FuP9rGO8hLZdRCpsaDJj
         vEew==
X-Gm-Message-State: AOAM5338BIKOn40xMzrwDwEmKvu1HU4c97gwpYZ8sy6vSRjZewq0veaY
	v3kVWA83W0XpBRNvuCDKIL1SEpN1wO3yQMXGyXEYbA==
X-Google-Smtp-Source: ABdhPJxkJnEbvYM5/968FpfLPAantffeO/sBABvh2n53Wp/IAlVp7pFGbWZ1wReq9yCdHL8ATpXRmVFjRmjODYdsmhc=
X-Received: by 2002:a19:c357:: with SMTP id t84mr5636062lff.34.1604337033294;
 Mon, 02 Nov 2020 09:10:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1604335819.git.gladkov.alexey@gmail.com> <2718f7b13189dfd159414efb68e3533552593140.1604335819.git.gladkov.alexey@gmail.com>
In-Reply-To: <2718f7b13189dfd159414efb68e3533552593140.1604335819.git.gladkov.alexey@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 2 Nov 2020 18:10:06 +0100
Message-ID: <CAG48ez0zGoB4Pr_+nLKaycCgEUtUrAvLJ89JG1ZbcbjKChMcng@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/4] Allow to change the user namespace in which
 user rlimits are counted
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Containers <containers@lists.linux-foundation.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, 
	Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 2, 2020 at 5:52 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> Add a new prctl to change the user namespace in which the process
> counter is located. A pointer to the user namespace is in cred struct
> to be inherited by all child processes.
[...]
> +       case PR_SET_RLIMIT_USER_NAMESPACE:
> +               if (!capable(CAP_SYS_RESOURCE))
> +                       return -EPERM;
> +
> +               switch (arg2) {
> +               case PR_RLIMIT_BIND_GLOBAL_USERNS:
> +                       error = set_rlimit_ns(&init_user_ns);
> +                       break;
> +               case PR_RLIMIT_BIND_CURRENT_USERNS:
> +                       error = set_rlimit_ns(current_user_ns());
> +                       break;
> +               default:
> +                       error = -EINVAL;
> +               }
> +               break;

I don't see how this can work. capable() requires that
current_user_ns()==&init_user_ns, so you can't use this API to bind
rlimits to any other user namespace.

Fundamentally, if it requires CAP_SYS_RESOURCE, this probably can't be
done as an API that a process uses to change its own rlimit scope. In
that case I would implement this as part of clone3() instead of
prctl(). (Then init_user_ns can set it if the caller has
CAP_SYS_RESOURCE. If you want to have support for doing the same thing
with nested namespaces, you'd also need a flag that the first-level
clone3() can set on the namespace to say "further rlimit splitting
should be allowed".)

Or alternatively, we could say that CAP_SYS_RESOURCE doesn't matter,
and instead you're allowed to move the rlimit scope if your current
hard rlimit is INFINITY. That might make more sense? Maybe?
