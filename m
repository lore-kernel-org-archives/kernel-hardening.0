Return-Path: <SRS0=8tN5=5J=lists.openwall.com=kernel-hardening-return-18214-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FE8C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:34:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96F39206F6
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXKz/8wy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96F39206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18214-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3495 invoked by uid 550); 24 Mar 2020 21:34:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3458 invoked from network); 24 Mar 2020 21:34:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585085638;
	bh=YSucMrRxtrynGJ/g9tDph2k08nv6kh3kh3Hl7TdUQPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iXKz/8wy8p4KltD7XQjmmy52F9817kzLNOiw4klkv30Lpg690Ck3BR5pWPmOXvYTT
	 65/iPl6FiQNrWy8nDWzCtOh2lHQ2VCBp4DyOQADo7k+1qlTqsStcT0HN3HVZNR7MfY
	 HZQqGk2p5wW29XzFJBh2XzyQ0tSzpezK2TzFy72Q=
Date: Tue, 24 Mar 2020 21:33:53 +0000
From: Will Deacon <will@kernel.org>
To: Marco Elver <elver@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200324213352.GB21176@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 05:23:30PM +0100, Marco Elver wrote:
> On Tue, 24 Mar 2020 at 16:37, Will Deacon <will@kernel.org> wrote:
> >
> > Some list predicates can be used locklessly even with the non-RCU list
> > implementations, since they effectively boil down to a test against
> > NULL. For example, checking whether or not a list is empty is safe even
> > in the presence of a concurrent, tearing write to the list head pointer.
> > Similarly, checking whether or not an hlist node has been hashed is safe
> > as well.
> >
> > Annotate these lockless list predicates with data_race() and READ_ONCE()
> > so that KCSAN and the compiler are aware of what's going on. The writer
> > side can then avoid having to use WRITE_ONCE() in the non-RCU
> > implementation.
> >
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Marco Elver <elver@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  include/linux/list.h       | 10 +++++-----
> >  include/linux/list_bl.h    |  5 +++--
> >  include/linux/list_nulls.h |  6 +++---
> >  include/linux/llist.h      |  2 +-
> >  4 files changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/list.h b/include/linux/list.h
> > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > --- a/include/linux/list.h
> > +++ b/include/linux/list.h
> > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> >   */
> >  static inline int list_empty(const struct list_head *head)
> >  {
> > -       return READ_ONCE(head->next) == head;
> > +       return data_race(READ_ONCE(head->next) == head);
> 
> Double-marking should never be necessary, at least if you want to make
> KCSAN happy. From what I gather there is an unmarked write somewhere,
> correct? In that case, KCSAN will still complain because if it sees a
> race between this read and the other write, then at least one is still
> plain (the write).
> 
> Then, my suggestion would be to mark the write with data_race() and
> just leave this as a READ_ONCE(). Having a data_race() somewhere only
> makes KCSAN stop reporting the race if the paired access is also
> marked (be it with data_race() or _ONCE, etc.).
> 
> Alternatively, if marking the write is impossible, you can surround
> the access with kcsan_disable_current()/kcsan_enable_current(). Or, as
> a last resort, just leaving as-is is fine too, because KCSAN's default
> config (still) has KCSAN_ASSUME_PLAIN_WRITES_ATOMIC selected.

Right, it looks like this is a bit of a smoking gun and we need to decide
on whether list_empty() is actually usable without synchronisation first.
Based on the outcome of that discussion, I'll update this patch accordingly.

The main thing I want to avoid is marking parts of the non-RCU list
implementation with data_race() or {READ,WRITE}_ONCE() because that's a
sure-fire way to hide real bugs.

Cheers,

Will
