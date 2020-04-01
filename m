Return-Path: <SRS0=ELQC=5R=lists.openwall.com=kernel-hardening-return-18346-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AFAC2D0E7
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 06:35:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 591AA2071A
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 06:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AI07kurl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 591AA2071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18346-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3405 invoked by uid 550); 1 Apr 2020 06:35:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3373 invoked from network); 1 Apr 2020 06:34:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QnA7EYCoVJYIWQO5uMLkeOEOdfqORaBrTcKNEc28yYY=;
        b=AI07kurlnG+uQ0Sas+oEYHAyqA3uaQjgSu+JcWAX6qnYsXMNTuByTN2lAKb0jPVUYW
         C4A+Jcz1I32aaxNjVY0aaN+20mWc102bWehMohu4mj6ACawVVeqjnh5C/qiQIT3Ievdx
         WNIBPU9w+Pl17fSIxFns6zEFF+EHfRgZTJRPN5EaHUegadb63A/Z+Ion1ihZoroyK2fV
         JnFdwLs3dws+nTVHxnWDYbXynDShMvhUkMjECxgFhKFsMxvoUsifRZBlzOf5gM/KarFx
         Z4h3n0aEBx/RcKXPRzyJICmpaORRQ/DslOiZyxLs7LdabZA5CO9HlpoRYX9SdfpCeBav
         tocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QnA7EYCoVJYIWQO5uMLkeOEOdfqORaBrTcKNEc28yYY=;
        b=B8WJ8bHLdyqDeKyygdAc/TF6c0vv439r2jt35we74ndud/Nrv2sKEyUTp9QaZfe4pd
         qhyuAxnAZFwpPaiVWQzGg6lpCVVM9Be7aEP4Kyt50qtehIYThBw1wKDSCS3doxOp/AHQ
         hKb+h75A7hvkMOtrhcWl2vKr60sUieAGSwrL7LsSFBslbzr22flNDHM6esNmOymdGCE9
         OB5RycM67GhAj16c6Qr8CxSfIdNtzV0oOuGrhwQctgOLPFg3m7I4Z9CFWKBmnRW+vMlg
         ooshgxRaQFsOrUQYu5WpH0elU9Ulev0qFHRdxwD4mUg31p5oYeoxIjz2LGEL+b54mVJZ
         aXTg==
X-Gm-Message-State: AGi0PuZoS3rJnYewqIGKjHGFwZ+VLtwIBLRykB1pxFQAbGPylQ3sKJrh
	e3uIloQPQrTFHbVMJFY/He+jfi2yBTnx9tk6rYZGYA==
X-Google-Smtp-Source: APiQypJfjS/kXYYGDaXryn4HsRwbBAV96lZ1gvez2EbUJtOV5YWRXj4Zda4APQHF8BW8uwiIYTGorQVuiQXbEq4zc8o=
X-Received: by 2002:a9d:4b84:: with SMTP id k4mr150225otf.233.1585722887489;
 Tue, 31 Mar 2020 23:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200324153643.15527-1-will@kernel.org> <20200324153643.15527-4-will@kernel.org>
 <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com> <20200331131002.GA30975@willie-the-truck>
In-Reply-To: <20200331131002.GA30975@willie-the-truck>
From: Marco Elver <elver@google.com>
Date: Wed, 1 Apr 2020 08:34:36 +0200
Message-ID: <CANpmjNN-nN1OfGNXmsaTtM=11sth7YJTJMePzXgBRU73ohkBjQ@mail.gmail.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
To: Will Deacon <will@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
	Maddie Stone <maddiestone@google.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 31 Mar 2020 at 15:10, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 24, 2020 at 05:23:30PM +0100, Marco Elver wrote:
> > On Tue, 24 Mar 2020 at 16:37, Will Deacon <will@kernel.org> wrote:
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
> > >
> > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Marco Elver <elver@google.com>
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  include/linux/list.h       | 10 +++++-----
> > >  include/linux/list_bl.h    |  5 +++--
> > >  include/linux/list_nulls.h |  6 +++---
> > >  include/linux/llist.h      |  2 +-
> > >  4 files changed, 12 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/include/linux/list.h b/include/linux/list.h
> > > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > > --- a/include/linux/list.h
> > > +++ b/include/linux/list.h
> > > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> > >   */
> > >  static inline int list_empty(const struct list_head *head)
> > >  {
> > > -       return READ_ONCE(head->next) == head;
> > > +       return data_race(READ_ONCE(head->next) == head);
> >
> > Double-marking should never be necessary, at least if you want to make
> > KCSAN happy. From what I gather there is an unmarked write somewhere,
> > correct? In that case, KCSAN will still complain because if it sees a
> > race between this read and the other write, then at least one is still
> > plain (the write).
>
> Ok, then I should drop the data_race() annotation and stick to READ_ONCE(),
> I think (but see below).
>
> > Then, my suggestion would be to mark the write with data_race() and
> > just leave this as a READ_ONCE(). Having a data_race() somewhere only
> > makes KCSAN stop reporting the race if the paired access is also
> > marked (be it with data_race() or _ONCE, etc.).
>
> The problem with taking that approach is that it ends up much of the
> list implementation annotated with either WRITE_ONCE() or data_race(),
> meaning that concurrent, racy list operations will no longer be reported
> by KCSAN. I think that's a pretty big deal and I'm strongly against
> annotating the internals of library code such as this because it means
> that buggy callers will largely go undetected.
>
> The situation we have here is that some calls, e.g. hlist_empty() are
> safe even in the presence of a racy write and I'd like to suppress KCSAN
> reports without annotating the writes at all.
>
> > Alternatively, if marking the write is impossible, you can surround
> > the access with kcsan_disable_current()/kcsan_enable_current(). Or, as
> > a last resort, just leaving as-is is fine too, because KCSAN's default
> > config (still) has KCSAN_ASSUME_PLAIN_WRITES_ATOMIC selected.
>
> Hmm, I suppose some bright spark will want to change the default at the some
> point though, no? ;) I'll look at using
> kcsan_disable_current()/kcsan_enable_current(), thanks.

I think this will come up again (it did already come up in some other
patch I reviewed, and Paul also mentioned it), so it seems best to
change data_race() to match the intuitive semantics of just completely
ignoring the access marked with it. I.e. marking accesses racing with
accesses marked with data_race() is now optional:
  https://lkml.kernel.org/r/20200331193233.15180-1-elver@google.com

In which case, the original patch you had here works just fine.

Thanks,
-- Marco
