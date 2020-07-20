Return-Path: <SRS0=jxJQ=A7=lists.openwall.com=kernel-hardening-return-19397-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01ECBC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jul 2020 16:53:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 55C92207DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jul 2020 16:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aKi09317"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55C92207DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19397-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25740 invoked by uid 550); 20 Jul 2020 16:53:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25718 invoked from network); 20 Jul 2020 16:53:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjwIKDNMRO86HLiza3ekP7Z4qpEbwmULQ/L4/V4YUtE=;
        b=aKi09317EgbufEHdPz6ybPx9SBQ3iXd5Qr1oxjOv5QrJguwLfk+bp9TvU+POgEqNC8
         E9WJUEpjgUVnd4A6HMqkPY1IIekaq1PzTfjnSMhOysWqSQHFxU2VpsbyaAfBSvi55tCf
         OsQMetqysDIjWPonv8j8aSyT8PHbE2MY4MEap62x4hEwJiTGeKO4UE/AqW6CYkuqHJFK
         +jNk4cgc5ueo3XySM27EJlzHTQmL7o1dFCUGkubIzjmwWtHygQSqOr7J4KrirT0N5ii5
         6jmz3r9OZwZaSF0lhj6qB061kySusc6q4saf79ctFwnqDim1fh9xHMNQHSN4aeXTLI+e
         WmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjwIKDNMRO86HLiza3ekP7Z4qpEbwmULQ/L4/V4YUtE=;
        b=o7GY3mR8AZg8QpjyYTmDiZ2sQ4TyD+u2W9rjnG0vTVgcvx2slqF/W/L+Lma06tmwB+
         wx4xeb3OM7ObSyBTGcmB97A8V7nv7JTJoRq6xhHJxYLXX+ALadx5sER6/C5z15J9lwCI
         eKvDvUFyob/nsljJvUmBAOm7d8j2l2j2caVLby1bsA1hb7f6O7acB6XGqSuh0ae+7kOg
         Ofzoj1ZpIngCU3UouHSrO7fhRkYyt+nzO76VRmXkIN/mHgJJFsw1YY5mA+X14waNi0zf
         FhZ2Xaup+/N35pZ1+kOBcJieiBjhyuNUCB3ZtbKaFZC3oEhYk74Jlv8m6zwDOYu7IIPm
         /BOw==
X-Gm-Message-State: AOAM530AQ6iostxtf14GG2M/T/xgs7nS8QgRFyWSbJ69B0ow19I4nl7R
	kk1z0Lwb7lcLpXMWig+BLIxvIidFjggsf4mVg2ru7Q==
X-Google-Smtp-Source: ABdhPJwXfmksCBX85u+pwB/9F5hgtRX4ZE8Dkw8qbJ6G2uTpNqzPbNioN4uT7/TWkHbxi+iplWhAeGWkg23vKqV2cIc=
X-Received: by 2002:a17:906:6959:: with SMTP id c25mr21009671ejs.375.1595263968366;
 Mon, 20 Jul 2020 09:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com> <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com> <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com> <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com> <20200626112931.GF4817@hirez.programming.kicks-ass.net>
 <CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
 <20200717133645.7816c0b6@oasis.local.home> <CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
 <20200717140545.6f008208@oasis.local.home>
In-Reply-To: <20200717140545.6f008208@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 20 Jul 2020 09:52:37 -0700
Message-ID: <CABCJKucDrS9wNZLjtmN5qMbZBTHLvB1Z7WqTwT3b11-K4kNcyg@mail.gmail.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Matt Helsley <mhelsley@vmware.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 17, 2020 at 11:05 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 17 Jul 2020 10:47:51 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
> > > Someone just submitted a patch for arm64 for this:
> > >
> > > https://lore.kernel.org/r/20200717143338.19302-1-gregory.herrero@oracle.com
> > >
> > > Is that what you want?
> >
> > That looks like the same issue, but we need to fix this on x86 instead.
>
> Does x86 have a way to differentiate between the two that record mcount
> can check?

I'm not sure if looking at the relocation alone is sufficient on x86,
we might also have to decode the instruction, which is what objtool
does. Did you have any thoughts on Peter's patch, or my initial
suggestion, which adds a __nomcount attribute to affected functions?

Sami
