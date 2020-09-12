Return-Path: <SRS0=ebcc=CV=lists.openwall.com=kernel-hardening-return-19890-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09901C43461
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 20:49:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0580C207EA
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 20:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZKgzE0A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0580C207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19890-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5383 invoked by uid 550); 12 Sep 2020 20:49:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5363 invoked from network); 12 Sep 2020 20:49:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1599943738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJuHYlMJJGIC0qBjlrqnGCpyE1IZMKKDiH+/8N+tl5c=;
	b=JZKgzE0ANnh1ziJZ8nEipWdOpH38X7uqrovIGjVEPCZXwDBl0X43/4rPlwygQ/3VM4slkO
	O8O9a6Ff8dJkku0DQ/sr4lkoex0y0/NJjQG5jIrF8hitdJd45O7ygbDyQiLmFB4uLYQE3j
	k3LFFMHrygFcgJxJ7LZF0iphzYBgyhA=
X-MC-Unique: 9lsJY65bOTyNUuHOsL4AYw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJuHYlMJJGIC0qBjlrqnGCpyE1IZMKKDiH+/8N+tl5c=;
        b=f6AWkR2WNj8ztx3HmC/vOHzB1Y2PMkF4lwH/mMsFusN+xArLcu8yiCvex+iqvBiJ6B
         2kyFtkV8IfVAJCnKO95exN+VE6+gCHcseqCMYbvT/XL1LVxwZ7RXaRwPysh+1OCkHIni
         /AOLUVwHmOiaID31CI/YRe4xK4bNTe/wSZVz8KLppYA5r4HxU61j092D6B0IG8Uaq/55
         n54EQCP3/cb4780CIrtX5p8s7Xkmb/0B/00vhXNJ3UOFC3dHlIxsrEQ8/qo4EnpW5PgW
         CW0qyssfnYYjF9F+209ayQb1FwoDbfxMUBcyghJtRQ1hvl1VXzVVZPxZPiCNXY7FJ3f7
         cGZA==
X-Gm-Message-State: AOAM532HhqrUS+p68aRkw1T6lAI3l4dL2x6eppJ6Ob66ftg9amdr7tkM
	OUfnocExDA8SbENLidRSAuJEoUH/RV583Va2dy3qPWM5X6JXYbFV1Wz3YSLahtxm6xhoxcNVLhs
	I/Un1peClQ51ZYOzgx8Z4IXprCoo+sZVEVQBiWSLov1mKaBP2GA==
X-Received: by 2002:a2e:8046:: with SMTP id p6mr2567824ljg.372.1599943732617;
        Sat, 12 Sep 2020 13:48:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDE6x8wpSTW0zchyo7JE5ZtuT3H92rSVgfacoMie83rLd05GidX9QR1xfHp5MvqzE7vmFLBF7QNJ6Y0VNPIQs=
X-Received: by 2002:a2e:8046:: with SMTP id p6mr2567810ljg.372.1599943732385;
 Sat, 12 Sep 2020 13:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
 <alpine.LRH.2.21.2009121002100.17638@namei.org> <202009120055.F6BF704620@keescook>
 <20200912093652.GA3041@ubuntu> <20200912144722.GE3117@suse.de>
In-Reply-To: <20200912144722.GE3117@suse.de>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Sat, 12 Sep 2020 22:48:39 +0200
Message-ID: <CAFqZXNtwDpX+O69Jj3AmxMoiW7o6SE07SqDDFnGMObu8hLDQDg@mail.gmail.com>
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation (fbfam)
To: Mel Gorman <mgorman@suse.de>
Cc: John Wood <john.wood@gmx.com>, James Morris <jmorris@namei.org>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	Linux Security Module list <linux-security-module@vger.kernel.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=omosnace@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sat, Sep 12, 2020 at 4:51 PM Mel Gorman <mgorman@suse.de> wrote:
> On Sat, Sep 12, 2020 at 11:36:52AM +0200, John Wood wrote:
> > On Sat, Sep 12, 2020 at 12:56:18AM -0700, Kees Cook wrote:
> > > On Sat, Sep 12, 2020 at 10:03:23AM +1000, James Morris wrote:
> > > > On Thu, 10 Sep 2020, Kees Cook wrote:
> > > >
> > > > > [kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
> > > > >  also visible at https://github.com/johwood/linux fbfam]
> > > > >
> > > > > From: John Wood <john.wood@gmx.com>
> > > >
> > > > Why are you resending this? The author of the code needs to be able to
> > > > send and receive emails directly as part of development and maintenance.
> >
> > I tried to send the full patch serie by myself but my email got blocked. After
> > get support from my email provider it told to me that my account is young,
> > and due to its spam policie I am not allow, for now, to send a big amount
> > of mails in a short period. They also informed me that soon I will be able
> > to send more mails. The quantity increase with the age of the account.
> >
>
> If you're using "git send-email" then specify --confirm=always and
> either manually send a mail every few seconds or use an expect script
> like
>
> #!/bin/bash
> EXPECT_SCRIPT=
> function cleanup() {
>         if [ "$EXPECT_SCRIPT" != "" ]; then
>                 rm $EXPECT_SCRIPT
>         fi
> }
> trap cleanup EXIT
>
> EXPECT_SCRIPT=`mktemp`
> cat > $EXPECT_SCRIPT <<EOF
> spawn sh ./SEND
> expect {
>         "Send this email"   { sleep 10; exp_send y\\r; exp_continue }
> }
> EOF
>
> expect -f $EXPECT_SCRIPT
> exit $?
>
> This will work if your provider limits the rate mails are sent rather
> than the total amount.

...or you could keep it simple and just pass "--batch-size 1
--relogin-delay 10" to git send-email ;)

-- 
Ondrej Mosnacek
Software Engineer, Platform Security - SELinux kernel
Red Hat, Inc.

