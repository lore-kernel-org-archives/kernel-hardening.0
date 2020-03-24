Return-Path: <SRS0=ny6e=5J=lists.openwall.com=kernel-hardening-return-18185-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DADC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:39:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5FE942070A
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SqvC2kgm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FE942070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18185-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20413 invoked by uid 550); 24 Mar 2020 16:39:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20381 invoked from network); 24 Mar 2020 16:39:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZzkCQpPbdj2OFyiXSSy0aeIz5QRMq8qWJOYRKQeOTcc=;
        b=SqvC2kgmwRB6Tw4XKDcWiHvMeyI2C3KLquP94TtLNSUWZkmtCtSc82qScnzWqUkjtu
         GJ/VmxWlx42XrPVn7bvv1addkWv0DUTK/VlBqLttdTB8Ev+Y7bQtN0Gm7mqH89KBS50I
         zntcKww3mWjZjjU40cMN4+YEC8bzOjJOOr5U0cyL724nHMiBGyxXilBSE9P0iXs1uDDg
         EmzZHjPWcMIx86jXLdVgZY5v9fo/Lxos9aq8AFFYJqhPb/jr6fCGvpLL6BJe75NDiDag
         iVS/80LexsuCyT0i3tOMeoID5FSGXKrUONpM5mO/OBdn0IYRzTiegfj+htQoeOnBLp97
         +A9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZzkCQpPbdj2OFyiXSSy0aeIz5QRMq8qWJOYRKQeOTcc=;
        b=Pa0/UPsN/XpOUqJWgUDAdfUl1ro9HHsKNFNZE6qxdcidrMXaE+hQjIzn9Ejfz06cix
         FigINM6g8GOMr13QJi3sKLZs8lDUfNSexWrIhQ7IEHMxaxvMTKS80jKkrg9qKiTJ84CT
         h41mPGGS9jNuHnkhS827L1keaauU7IipSgACnlr+6xYDhT3a+eOyk3VJa7GocEXUeJuI
         Z7sZazZN27zO8LgWeborfoeXdy5+k4TDbEGup4kzGXV4uS+LfykZ9UXfn891jHJWLruK
         8q6UU6FB+oKdog8mwtlV9pRuqX9/wd6UPNjjOCmvwXKS4pnJXq21Blt912enVuhKEDTM
         88OA==
X-Gm-Message-State: ANhLgQ2T1eAtgSv/XjzEYIVb2OC3YAuXxOahzB/ZWKIHxrg5VDjuz0n+
	bE+9htQSu8KgdtjlXmsHYzyN13ILNeP1/i/2yrU2Mw==
X-Google-Smtp-Source: ADFU+vugN93Bdz0mI1Sdq6g6dBru8MHy0EA00/IQriSHlqEooPusYfp9U34c35lnJOebx/+jWACTgnIx5cdQ9k3QUGA=
X-Received: by 2002:a2e:b5d1:: with SMTP id g17mr4517795ljn.139.1585067937520;
 Tue, 24 Mar 2020 09:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200324153643.15527-1-will@kernel.org> <20200324153643.15527-4-will@kernel.org>
 <CAG48ez1yTbbXn__Kf0csf8=LCFL+0hR0EyHNZsryN8p=SsLp5Q@mail.gmail.com> <20200324162652.GA2518046@kroah.com>
In-Reply-To: <20200324162652.GA2518046@kroah.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 24 Mar 2020 17:38:30 +0100
Message-ID: <CAG48ez1c5Rjo+RZRW-qR7h40zT4mT8iQv5m3h0qTjfFpsckEsg@mail.gmail.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
To: Greg KH <greg@kroah.com>
Cc: Will Deacon <will@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Kees Cook <keescook@chromium.org>, 
	Maddie Stone <maddiestone@google.com>, Marco Elver <elver@google.com>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 5:26 PM Greg KH <greg@kroah.com> wrote:
> On Tue, Mar 24, 2020 at 05:20:45PM +0100, Jann Horn wrote:
> > On Tue, Mar 24, 2020 at 4:37 PM Will Deacon <will@kernel.org> wrote:
> > > Some list predicates can be used locklessly even with the non-RCU list
> > > implementations, since they effectively boil down to a test against
> > > NULL. For example, checking whether or not a list is empty is safe even
> > > in the presence of a concurrent, tearing write to the list head pointer.
> > > Similarly, checking whether or not an hlist node has been hashed is safe
> > > as well.
> > >
> > > Annotate these lockless list predicates with data_race() and READ_ONCE()
> > > so that KCSAN and the compiler are aware of what's going on. The writer
> > > side can then avoid having to use WRITE_ONCE() in the non-RCU
> > > implementation.
> > [...]
> > >  static inline int list_empty(const struct list_head *head)
> > >  {
> > > -       return READ_ONCE(head->next) == head;
> > > +       return data_race(READ_ONCE(head->next) == head);
> > >  }
> > [...]
> > >  static inline int hlist_unhashed(const struct hlist_node *h)
> > >  {
> > > -       return !READ_ONCE(h->pprev);
> > > +       return data_race(!READ_ONCE(h->pprev));
> > >  }
> >
> > This is probably valid in practice for hlist_unhashed(), which
> > compares with NULL, as long as the most significant byte of all kernel
> > pointers is non-zero; but I think list_empty() could realistically
> > return false positives in the presence of a concurrent tearing store?
> > This could break the following code pattern:
> >
> > /* optimistic lockless check */
> > if (!list_empty(&some_list)) {
> >   /* slowpath */
> >   mutex_lock(&some_mutex);
> >   list_for_each(tmp, &some_list) {
> >     ...
> >   }
> >   mutex_unlock(&some_mutex);
> > }
> >
> > (I'm not sure whether patterns like this appear commonly though.)
>
>
> I would hope not as the list could go "empty" before the lock is
> grabbed.  That pattern would be wrong.

If the list becomes empty in between, the loop just iterates over
nothing, and the effect is no different from what you'd get if you had
bailed out before. But sure, you have to be aware that that can
happen.
