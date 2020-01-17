Return-Path: <SRS0=3Gcq=3G=lists.openwall.com=kernel-hardening-return-17586-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E039C33C9E
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jan 2020 21:20:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 700902082F
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jan 2020 21:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IjpQ6Aru"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 700902082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17586-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21639 invoked by uid 550); 17 Jan 2020 21:20:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21602 invoked from network); 17 Jan 2020 21:20:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ov/MSAN6f4SPopx5kOpmENhTI+79DbFyHl+2GkJMEA=;
        b=IjpQ6AruYOQXtDxHd+zKg5GsKnESXxpMZo+UVz/wmImaZBIE8VKhbVzLt2LoklC5bD
         l9h3c2KcYAhdV9hV9YOSoz+vrrcgb6HYYAfoqYyQcq4NzvKbdOmBgQtBZ8VIsv4SWiyq
         XINwdMI5Yig58QPf0z8GIetXCQQjMGEz/8v98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ov/MSAN6f4SPopx5kOpmENhTI+79DbFyHl+2GkJMEA=;
        b=bxYebTeAcgp8vd1OTACWP2AUFusllf5kqnjOdz8VV74P+lh/RUez+6ZL079X5Jlb5k
         m046uX0EoPuH+YAVp7NdZMybLPhDtWPw40RukpAO3Jgj3e463Nai9z7qrUJhpMFAxYJN
         Ichn4urRs0PkJk70PxCO53Hnj+I6O3VPzZTqmrMQ42KgJlXfPuzdlQco55JCpmvpHjwT
         LDOPHE0V4sm4HlEy6Mi73T38dzc0pphb6heoYej2zxD8DprrmttDao0xJdugnovT937r
         HzUGCfiN2vzoPyN5KREDIk63SPvOvgLne6GWVWOiWiQC/JgAcoKHyZ6ZXUy/1icK3WEV
         +TvQ==
X-Gm-Message-State: APjAAAVX5fJ5nEZXHoqH3OtoalmiNyg0Q3rlQ95noLfXNjHxg8QW5M66
	DrMJZrYmtRDKk/1pU573upp/+g==
X-Google-Smtp-Source: APXvYqy3GM8G96xZEmnB/alOHFkZv4nSmr+HVZwvtwVaFU/LFlURsKL++MNAsUwSkHdtG7mGhpS4tw==
X-Received: by 2002:a17:902:b401:: with SMTP id x1mr1280965plr.326.1579296002758;
        Fri, 17 Jan 2020 13:20:02 -0800 (PST)
Date: Fri, 17 Jan 2020 13:20:00 -0800
From: Kees Cook <keescook@chromium.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev <kasan-dev@googlegroups.com>,
	Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v3 5/6] kasan: Unset panic_on_warn before calling panic()
Message-ID: <202001171317.5E3C106F@keescook>
References: <20200116012321.26254-1-keescook@chromium.org>
 <20200116012321.26254-6-keescook@chromium.org>
 <CACT4Y+batRaj_PaDnfzLjpLDOCChhpiayKeab-rNLx5LAj1sSQ@mail.gmail.com>
 <202001161548.9E126B774F@keescook>
 <CACT4Y+Z9o4B37-sNU2582FBv_2+evgyKVbVo-OAufLrsney=wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z9o4B37-sNU2582FBv_2+evgyKVbVo-OAufLrsney=wA@mail.gmail.com>

On Fri, Jan 17, 2020 at 10:54:36AM +0100, Dmitry Vyukov wrote:
> On Fri, Jan 17, 2020 at 12:49 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Jan 16, 2020 at 06:23:01AM +0100, Dmitry Vyukov wrote:
> > > On Thu, Jan 16, 2020 at 2:24 AM Kees Cook <keescook@chromium.org> wrote:
> > > >
> > > > As done in the full WARN() handler, panic_on_warn needs to be cleared
> > > > before calling panic() to avoid recursive panics.
> > > >
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  mm/kasan/report.c | 10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> > > > index 621782100eaa..844554e78893 100644
> > > > --- a/mm/kasan/report.c
> > > > +++ b/mm/kasan/report.c
> > > > @@ -92,8 +92,16 @@ static void end_report(unsigned long *flags)
> > > >         pr_err("==================================================================\n");
> > > >         add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
> > > >         spin_unlock_irqrestore(&report_lock, *flags);
> > > > -       if (panic_on_warn)
> > > > +       if (panic_on_warn) {
> > > > +               /*
> > > > +                * This thread may hit another WARN() in the panic path.
> > > > +                * Resetting this prevents additional WARN() from panicking the
> > > > +                * system on this thread.  Other threads are blocked by the
> > > > +                * panic_mutex in panic().
> > >
> > > I don't understand part about other threads.
> > > Other threads are not necessary inside of panic(). And in fact since
> > > we reset panic_on_warn, they will not get there even if they should.
> > > If I am reading this correctly, once one thread prints a warning and
> > > is going to panic, other threads may now print infinite amounts of
> > > warning and proceed past them freely. Why is this the behavior we
> > > want?
> >
> > AIUI, the issue is the current thread hitting another WARN and blocking
> > on trying to call panic again. WARNs encountered during the execution of
> > panic() need to not attempt to call panic() again.
> 
> Yes, but the variable is global and affects other threads and the
> comment talks about other threads, and that's the part I am confused
> about (for both comment wording and the actual behavior). For the
> "same thread hitting another warning" case we need a per-task flag or
> something.

This is duplicating the common panic-on-warn logic (see the generic bug
code), so I'd like to just have the same behavior between the three
implementations of panic-on-warn (generic bug, kasan, ubsan), and then
work to merge them into a common handler, and then perhaps fix the
details of the behavior. I think it's more correct to allow the panicing
thread to complete than to care about what the other threads are doing.
Right now, a WARN within the panic code will either a) hang the machine,
or b) not panic, allowing the rest of the threads to continue, maybe
then hitting other WARNs and hanging. The generic bug code does not
suffer from this.

-Kees

> 
> > -Kees
> >
> > >
> > > > +                */
> > > > +               panic_on_warn = 0;
> > > >                 panic("panic_on_warn set ...\n");
> > > > +       }
> > > >         kasan_enable_current();
> > > >  }
> >
> > --
> > Kees Cook

-- 
Kees Cook
