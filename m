Return-Path: <SRS0=DCDC=5R=lists.openwall.com=kernel-hardening-return-18353-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2887C2D0E7
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 08:40:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1275A208FE
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 08:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTTk8b3G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1275A208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18353-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16195 invoked by uid 550); 1 Apr 2020 08:40:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16148 invoked from network); 1 Apr 2020 08:40:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585730419;
	bh=yOZ6t/Gl6Iy7HVC0u60CLMokCXrPywPPg/GEC4Tb6K8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rTTk8b3G6QIpfgO26cm3aA8BrUITT9Y4fB1u6SUaeS/clr7LIkwPxJuHpPqBgPZHn
	 GlDqC9tLDR8JRJltMeLXcNqXe7H7MY606DxVN2a7EqGogHa7wo7NjDH7O+keIQZHN9
	 bDBGIsrFgjnLSafMyMWS3zZAisL5LPN7wrkdGmPs=
Date: Wed, 1 Apr 2020 09:40:15 +0100
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
Message-ID: <20200401084014.GC16446@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
 <20200331131002.GA30975@willie-the-truck>
 <CANpmjNN-nN1OfGNXmsaTtM=11sth7YJTJMePzXgBRU73ohkBjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNN-nN1OfGNXmsaTtM=11sth7YJTJMePzXgBRU73ohkBjQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Apr 01, 2020 at 08:34:36AM +0200, Marco Elver wrote:
> On Tue, 31 Mar 2020 at 15:10, Will Deacon <will@kernel.org> wrote:
> > On Tue, Mar 24, 2020 at 05:23:30PM +0100, Marco Elver wrote:
> > > Then, my suggestion would be to mark the write with data_race() and
> > > just leave this as a READ_ONCE(). Having a data_race() somewhere only
> > > makes KCSAN stop reporting the race if the paired access is also
> > > marked (be it with data_race() or _ONCE, etc.).
> >
> > The problem with taking that approach is that it ends up much of the
> > list implementation annotated with either WRITE_ONCE() or data_race(),
> > meaning that concurrent, racy list operations will no longer be reported
> > by KCSAN. I think that's a pretty big deal and I'm strongly against
> > annotating the internals of library code such as this because it means
> > that buggy callers will largely go undetected.
> >
> > The situation we have here is that some calls, e.g. hlist_empty() are
> > safe even in the presence of a racy write and I'd like to suppress KCSAN
> > reports without annotating the writes at all.
> >
> > > Alternatively, if marking the write is impossible, you can surround
> > > the access with kcsan_disable_current()/kcsan_enable_current(). Or, as
> > > a last resort, just leaving as-is is fine too, because KCSAN's default
> > > config (still) has KCSAN_ASSUME_PLAIN_WRITES_ATOMIC selected.
> >
> > Hmm, I suppose some bright spark will want to change the default at the some
> > point though, no? ;) I'll look at using
> > kcsan_disable_current()/kcsan_enable_current(), thanks.
> 
> I think this will come up again (it did already come up in some other
> patch I reviewed, and Paul also mentioned it), so it seems best to
> change data_race() to match the intuitive semantics of just completely
> ignoring the access marked with it. I.e. marking accesses racing with
> accesses marked with data_race() is now optional:
>   https://lkml.kernel.org/r/20200331193233.15180-1-elver@google.com

/me goes look. Thanks!

> In which case, the original patch you had here works just fine.

Ah yes, so now data_race(READ_ONCE(...)) does make sense as a combination.
It's tempting to wrap that up as an accessor, but actually forcing people to
spell it out might not be a bad thing after all.

Will
