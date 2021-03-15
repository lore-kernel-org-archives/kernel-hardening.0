Return-Path: <SRS0=tjLG=IN=lists.openwall.com=kernel-hardening-return-20943-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C74C433E6
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:03:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 696A264F07
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 696A264F07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20943-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9362 invoked by uid 550); 15 Mar 2021 22:03:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9339 invoked from network); 15 Mar 2021 22:03:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pM/cP6/Lz3nYNB1A2BCPvDYZL5Nv+dU7p0YG5FmdOHs=;
        b=i+Pu5UNw/TgHu/fQEXmZOHFShdZNm0HYjuktOVvh43UQqWK9OXoxwTL0KfkLH1Lh3o
         Mkcv0D3zl4D39+93TZwtmfQnzTN3Fg40p8XufRexRcM6m8VQsn9YV4Kt6YovAUS/J0Qh
         oZNwlAoLttJ/w9GIdPY7BRwFC7DF52oYAgWR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pM/cP6/Lz3nYNB1A2BCPvDYZL5Nv+dU7p0YG5FmdOHs=;
        b=UzUWrm1KQtiBsEewX3q3OjhYsjkEu67gvZ5z4PwtkvYL0SxvGy/5JhByGkGAJFNtns
         lqHQVbuEDvfn5Hkk8A3kcBXR3lFUXYWiUNopAN7t7zHjXOVFi9d+1gpxwFMmA9GBJ7S5
         WDOOdTXdZ7HwNO5yi8jiNrRuNyTj+DJsjTOwWIsq+/TBBDOeMKW1V+GdF7leh9h9WFeW
         zIn/EhqrauikkwKUa1pwrsSBxHvv+pM1ZUN9zvPjWvyPOjjireEQxfAsQ+72DDVYt1+V
         0z8j7L5W/t7YtzV7cxrqQTWZD8JqUDSGhNxh/3U2459Y6QfklniLJBtRY+IqrEpnZGf5
         b7tw==
X-Gm-Message-State: AOAM531fPsN2u6RFgczEWyhuL7vOcYJNmJuvf55grxAbr3BsGsO+Eiv0
	22R4I1kun+xd7O2XDk3aomXvvg==
X-Google-Smtp-Source: ABdhPJy8q9F/S8HF2FiROpt7pJm13akaXdXmtXbP3bYKMQOOiCIYaDmmj4n4Edotx3q4QzWSMo2peA==
X-Received: by 2002:a63:f808:: with SMTP id n8mr995720pgh.115.1615845780563;
        Mon, 15 Mar 2021 15:03:00 -0700 (PDT)
Date: Mon, 15 Mar 2021 15:02:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org, Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
Message-ID: <202103151426.ED27141@keescook>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>

On Wed, Mar 10, 2021 at 01:01:28PM +0100, Alexey Gladkov wrote:
> The current implementation of the ucounts reference counter requires the
> use of spin_lock. We're going to use get_ucounts() in more performance
> critical areas like a handling of RLIMIT_SIGPENDING.

This really looks like it should be refcount_t. I read the earlier
thread[1] on this, and it's not clear to me that this is a "normal"
condition. I think there was a bug in that version (This appeared
to *instantly* crash at boot with mnt_init() calling alloc_mnt_ns()
calling inc_ucount()). The current code looks like just a "regular"
reference counter of the allocated struct ucounts. Overflow should be
very unexpected, yes? And operating on a "0" ucounts should be a bug
too, right?

> [...]
> +/* 127: arbitrary random number, small enough to assemble well */
> +#define refcount_zero_or_close_to_overflow(ucounts) \
> +	((unsigned int) atomic_read(&ucounts->count) + 127u <= 127u)

Regardless, this should absolutely not have "refcount" as a prefix. I
realize it's only used here, but that's needlessly confusing with regard
to it being atomic_t not refcount_t.

> +struct ucounts *get_ucounts(struct ucounts *ucounts)
> +{
> +	if (ucounts) {
> +		if (refcount_zero_or_close_to_overflow(ucounts)) {
> +			WARN_ONCE(1, "ucounts: counter has reached its maximum value");
> +			return NULL;
> +		}
> +		atomic_inc(&ucounts->count);
> +	}
> +	return ucounts;
> +}

I feel like this should just be:

	refcount_inc_not_zero(&ucounts->count);

Or, to address Linus's comment in the v3 series, change get_ucounts to
not return NULL first -- I can't see why that can ever happen in v8.

-Kees

[1] https://lore.kernel.org/lkml/116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com/

-- 
Kees Cook
