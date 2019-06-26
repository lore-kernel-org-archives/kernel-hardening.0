Return-Path: <SRS0=PR/2=UZ=lists.openwall.com=kernel-hardening-return-16270-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94EAC48BD6
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 21:51:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3099D20665
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 21:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="gbrS0w+r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3099D20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16270-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1857 invoked by uid 550); 26 Jun 2019 21:50:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1836 invoked from network); 26 Jun 2019 21:50:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iYzcb55D5fDYZJpA77KyVzeZrChGfiSNXIH61s2NG04=;
        b=gbrS0w+rlg9zyEZINMY3HjVDCPGhz5MyqmTAjBg1Fbugu3dqmjIQmqAfYG67PejOX2
         f2eL+rJpn1hkPmMBhkUEOKPTjTDtGNyeCGt/4bNEXxS9n+NzQIoiEQ2gMhkVBzmvfbTe
         /gP3nGAQ4miAQjejoxT0d8OD9VmeEPBmMwSFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iYzcb55D5fDYZJpA77KyVzeZrChGfiSNXIH61s2NG04=;
        b=ehAYjGmy2MeUnWHhhwIhMJaJlCUoCr6G+DCZQriv15j7HSrbhY2hUq77dbUMdY0yVI
         vQ6uoFe3sOemdP4Lsa4Xv/GGtUyUO13isCSYqh34qP2zS2VyAqjFROPirEb+jJldtA1V
         CXsnOco1eeA5j3oL2XB4bgniIJhTRdCedXOPx7+wrOw5QP5NRsvNfz6hIGtkXisDFeSc
         ZUi5TkVAPRXkmpTGbEdHtpiz+8fcKvV77JsAKY7ulGWwinbS/O0Ii7mWuU1nf9XQAYOm
         SdfVuo2L8W3AwjbTP/XTHU8v629SlP2vFTuF84ilkDkltSw8sd5ViZlA4fnmSkY3y7U8
         8bRA==
X-Gm-Message-State: APjAAAWLFT5CeTdlhAM3+kkAcjDucyRioc+BU1BxxrfSS4hsCJDZxkp2
	FDHxfzFn1s5aUzeV6Ujq4H3kDA==
X-Google-Smtp-Source: APXvYqwfVAlFOB7s26jDV4AEoNGYTdz5In80RYc7g1IcpNe5bC/viaardLvXIqTJ6QQz/BYMRk/U6g==
X-Received: by 2002:a17:90a:b011:: with SMTP id x17mr1540506pjq.113.1561585843661;
        Wed, 26 Jun 2019 14:50:43 -0700 (PDT)
Date: Wed, 26 Jun 2019 17:50:41 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Matthew Wilcox <willy@infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Kees Cook <keescook@chromium.org>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Message-ID: <20190626215041.GA234202@google.com>
References: <20190624184534.209896-1-joel@joelfernandes.org>
 <20190624185214.GA211230@google.com>
 <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
 <20190625073407.GP3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625073407.GP3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 25, 2019 at 09:34:07AM +0200, Peter Zijlstra wrote:
> On Mon, Jun 24, 2019 at 09:10:15PM +0200, Jann Horn wrote:
> > That part of the documentation only talks about cases where you have a
> > control dependency on the return value of the refcount operation. But
> > refcount_inc() does not return a value, so this isn't relevant for
> > refcount_inc().
> > 
> > Also, AFAIU, the control dependency mentioned in the documentation has
> > to exist *in the caller* - it's just pointing out that if you write
> > code like the following, you have a control dependency between the
> > refcount operation and the write:
> > 
> >     if (refcount_inc_not_zero(&obj->refcount)) {
> >       WRITE_ONCE(obj->x, y);
> >     }
> > 
> > For more information on the details of this stuff, try reading the
> > section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.
> 
> IIRC the argument went as follows:
> 
>  - if you use refcount_inc(), you've already got a stable object and
>    have ACQUIRED it otherwise, typically through locking.
> 
>  - if you use refcount_inc_not_zero(), you have a semi stable object
>    (RCU), but you still need to ensure any changes to the object happen
>    after acquiring a reference, and this is where the control dependency
>    comes in as Jann already explained.
> 
> Specifically, it would be bad to allow STOREs to happen before we know
> the refcount isn't 0, as that would be a UaF.
> 
> Also see the comment in lib/refcount.c.
> 

Thanks a lot for the explanations and the pointers to the comment in
lib/refcount.c . It makes it really clearly.

Also, does this patch look good to you? If so and if ok with you, could you
Ack it? The patch is not really "RFC" but I still tagged it as such since I
wanted to have this discussion.

Thanks!

- Joel

