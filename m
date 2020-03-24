Return-Path: <SRS0=pyEX=5J=lists.openwall.com=kernel-hardening-return-18179-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE68C54EEB
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:21:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE8C02073E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTjWpNCM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE8C02073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18179-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5648 invoked by uid 550); 24 Mar 2020 16:21:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5613 invoked from network); 24 Mar 2020 16:21:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WetC+OTmoa1F/pStOSsShJDamwm3VA4jd3O6GhechcE=;
        b=FTjWpNCMWZ7J/cDwT7gbDhaA/pRp8gQKYkbFQhUW5wQAwOKIkaV9G2GVjhPz9xJ4tA
         Kqzf5dD0Bajzl9EAEO4f6whv4NX8eA/FfzF5DTYIsBFQs32Vo06qDD+4aYIPP+wZumbj
         BtfvrTbCVZZ1N4vPaWdLH7zdwuQkpdZ2yntOgDeJv4/KlxlFSrsd1tKdM1mWD0oZXN5/
         gIw5KlVo84WVEfvqL8mbjG/xa9GwOOgQg1D5gcT+KIEZq5KG+lUn+BMBhtz1F+dLdXy+
         0asjvCtYt2SJ8j7qH3/9ytFMTBFOVcN6qjyKRejvO1oBZzfl9y+G6DEm/7UXe6gOUMMf
         lYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WetC+OTmoa1F/pStOSsShJDamwm3VA4jd3O6GhechcE=;
        b=qky0hHKXEv7OlfmAQzoc3o/PT9xgy1SwIlKdLUwjK+ldTxm/FgRYH9cQ7tFPCjcphN
         4gzunrctR0YbkyGwuDdEKZL92fFv0PnJNQZwd96KA/B4FuFi0QeNC0Y0HmuSWlHSITVM
         0N8cZ1E16LNHFRcc36y1IVRvvETx8bFywIsrnW9jxINv3eWvgDt1bhaIfS3ciAktf54l
         jKII7WxtG6QToQyS39GewS9H6iQ5JNTf5SzCMIOvUW2m1vGX+XJqrcaaa1haWn3GiiaO
         c+onwMiyswQZ91EBUWanlYrmEDrFKoSmgE7bJe8QCF38jkchNHgMY9+SS20Lc4R813WQ
         NFvQ==
X-Gm-Message-State: ANhLgQ2WSAgy1mlYPGG1wrz8TgWWk1r9RBi9RiTGkM1cy3CLdNLBuYnp
	euL88BjDtlao+8yUlaZDeKrNHt4dteFrZ9y3aMCOOg==
X-Google-Smtp-Source: ADFU+vsIaFGO8U2u+5T6NEUSVlkwvNy3vb/rzExWYbBWUtjl3LTGNE4yAktxsqZ1htd8qJcgVZ6qZl15lC8/QyT6pjA=
X-Received: by 2002:a2e:89c1:: with SMTP id c1mr16656055ljk.215.1585066872395;
 Tue, 24 Mar 2020 09:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200324153643.15527-1-will@kernel.org> <20200324153643.15527-4-will@kernel.org>
In-Reply-To: <20200324153643.15527-4-will@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 24 Mar 2020 17:20:45 +0100
Message-ID: <CAG48ez1yTbbXn__Kf0csf8=LCFL+0hR0EyHNZsryN8p=SsLp5Q@mail.gmail.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
To: Will Deacon <will@kernel.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Kees Cook <keescook@chromium.org>, Maddie Stone <maddiestone@google.com>, 
	Marco Elver <elver@google.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 4:37 PM Will Deacon <will@kernel.org> wrote:
> Some list predicates can be used locklessly even with the non-RCU list
> implementations, since they effectively boil down to a test against
> NULL. For example, checking whether or not a list is empty is safe even
> in the presence of a concurrent, tearing write to the list head pointer.
> Similarly, checking whether or not an hlist node has been hashed is safe
> as well.
>
> Annotate these lockless list predicates with data_race() and READ_ONCE()
> so that KCSAN and the compiler are aware of what's going on. The writer
> side can then avoid having to use WRITE_ONCE() in the non-RCU
> implementation.
[...]
>  static inline int list_empty(const struct list_head *head)
>  {
> -       return READ_ONCE(head->next) == head;
> +       return data_race(READ_ONCE(head->next) == head);
>  }
[...]
>  static inline int hlist_unhashed(const struct hlist_node *h)
>  {
> -       return !READ_ONCE(h->pprev);
> +       return data_race(!READ_ONCE(h->pprev));
>  }

This is probably valid in practice for hlist_unhashed(), which
compares with NULL, as long as the most significant byte of all kernel
pointers is non-zero; but I think list_empty() could realistically
return false positives in the presence of a concurrent tearing store?
This could break the following code pattern:

/* optimistic lockless check */
if (!list_empty(&some_list)) {
  /* slowpath */
  mutex_lock(&some_mutex);
  list_for_each(tmp, &some_list) {
    ...
  }
  mutex_unlock(&some_mutex);
}

(I'm not sure whether patterns like this appear commonly though.)
