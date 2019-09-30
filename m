Return-Path: <SRS0=5Gen=XZ=lists.openwall.com=kernel-hardening-return-16969-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E91C32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 18:29:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A61F2224ED
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 18:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ddO9Zvyg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A61F2224ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16969-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4030 invoked by uid 550); 30 Sep 2019 18:29:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4010 invoked from network); 30 Sep 2019 18:29:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GGW5YTXB7k7QAffkQ+fScbfTHXGGFiBFSDibbhauwME=;
        b=ddO9ZvygJD5jwLI0fO07174NlB0/rckqIoShTN/ebn3GwVz316fFEx2WakWKR5sYT1
         n1wUwL4TWIuKSmPK7EzKxoWzexpzPb8fvtxG0OWlv1rxrYwzi8mbbujhCqPMVfVfpAGB
         EiFhgPPdEASb6t7MJLkcrmY9zuDq/76TDIaqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GGW5YTXB7k7QAffkQ+fScbfTHXGGFiBFSDibbhauwME=;
        b=PyW/IIaV7elgxMWc//hWKwQasGlKI2yYp/lKEpimJyENz92QBJH+Qs1CJ8A3K2R842
         kvx4hkbGeoB9DXVw596E6H6S+4EK1YMmVmfNV+Vk8KIi+Ns7LegDH9fyYHdCAaHiasZY
         ql+S7d7PDpd5BRlZmyTqjxjxs5UbKbh6KBVgC7vX8pycj1K/n4SBGnLJnF06tfdbdgcW
         v4fXFlJ2+5RCXQ8x3U8htmqI+kdUhg2y8nYN7klRkytwAtB+b5ZD22xeTjjl/zx7/g54
         95XicJHyltj4FH4Dh3/Z/ZFJF1lgwoM6S8Lw2SruvZB81+D/6nv3MG1i8T/2nw18hSjl
         WZLA==
X-Gm-Message-State: APjAAAULQ9Aw+Jda9WdLY3xaUcFcZBKenLW3biMpJbX1AYbtHpl0tEuO
	7NnSYbmdJt1Ej3/dHtITpmtAwg==
X-Google-Smtp-Source: APXvYqzVvSQuFKi3OxDeHFdYnh9nwIIGKErryn+jU3ze4WyjYrcAVGpbNuJovH6XmCbtnOJ72fI7Mg==
X-Received: by 2002:a17:90a:ab85:: with SMTP id n5mr629907pjq.117.1569868143340;
        Mon, 30 Sep 2019 11:29:03 -0700 (PDT)
Date: Mon, 30 Sep 2019 11:29:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?J=E9r=E9mie?= Galarneau <jeremie.galarneau@efficios.com>,
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk,
	dan.carpenter@oracle.com, akpm@linux-foundation.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] audit: Report suspicious O_CREAT usage
Message-ID: <201909301128.5951C390@keescook>
References: <201909251348.A1542A52@keescook>
 <CAHC9VhRNmWw1__-haD1ZEekADTho3EJyXQMd6ETpOv4c8Qn9nw@mail.gmail.com>
 <2065829.xbNJnTdZ4q@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2065829.xbNJnTdZ4q@x2>

On Mon, Sep 30, 2019 at 09:50:00AM -0400, Steve Grubb wrote:
> On Thursday, September 26, 2019 11:31:32 AM EDT Paul Moore wrote:
> > On Wed, Sep 25, 2019 at 5:02 PM Kees Cook <keescook@chromium.org> wrote:
> > > This renames the very specific audit_log_link_denied() to
> > > audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> > > allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> > > report the fifo/regular file creation restrictions that were introduced
> > > in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> > > regular files"). Without this change, discovering that the restriction
> > > is enabled can be very challenging:
> > > https://lore.kernel.org/lkml/CA+jJMxvkqjXHy3DnV5MVhFTL2RUhg0WQ-XVFW3ngDQO
> > > dkFq0PA@mail.gmail.com
> > > 
> > > Reported-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > > This is not a complete fix because reporting was broken in commit
> > > 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> > > audit_dummy_context")
> > > which specifically goes against the intention of these records: they
> > > should _always_ be reported. If auditing isn't enabled, they should be
> > > ratelimited.
> > > 
> > > Instead of using audit, should this just go back to using
> > > pr_ratelimited()?
> > 
> > I'm going to ignore the rename and other aspects of this patch for the
> > moment so we can focus on the topic of if/when/how these records
> > should be emitted by the kernel.
> > 
> > Unfortunately, people tend to get very upset if audit emits *any*
> > records when they haven't explicitly enabled audit, the significance
> > of the record doesn't seem to matter, which is why you see patches
> > like 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> > audit_dummy_context").  We could consider converting some records to
> > printk()s, rate-limited or not, but we need to balance this with the
> > various security certifications which audit was created to satisfy.
> > In some cases a printk() isn't sufficient.
> > 
> > Steve is probably the only one who really keeps track of the various
> > auditing requirements of the different security certifications; what
> > say you Steve on this issue with ANOM_CREAT records?
> 
> Common Criteria and other security standards I track do not call out for 
> anomoly detection. So, there are no requirements on this. That said, we do 
> have other anomaly detections because they give early warning that something 
> strange is happening. I think adding this event is a nice improvement as long 
> as it obeys audit_enabled before emitting an event - for example, look at the 
> AUDIT_ANOM_ABEND event.

Okay, so the patch is good as-is? (The "report things always" issue I
will deal with separately. For now I'd just like to gain this anomaly
detection corner case...)

Paul, what do you see as next steps here?

-- 
Kees Cook
