Return-Path: <SRS0=yaIK=EJ=lists.openwall.com=kernel-hardening-return-20331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F56C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 15:28:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A7B022226
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 15:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqXQFUGx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A7B022226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12120 invoked by uid 550); 3 Nov 2020 15:28:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12091 invoked from network); 3 Nov 2020 15:28:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vxNgOQvQzQD1y7rtzGi+GT8dfHZ/R+vwp6DNWXHP+vE=;
        b=jqXQFUGx3VlYxUOMhmR5gJfjoaqEGWaK5mUIDBDB/tdIadAYMPjEoZTxw5wgnKHMqy
         MOC3GURBn1BRFjBgNFBlcA/wVrDm+EH5DOAtaqEdKIbQV3hYdkeMoOXOQT69W1hc8spN
         Mrk29ebYkwy84a690nCxRRAOuBTAsjt83a2Ds+MUKZQIeq1toCZxiTwFNQLkAqCdZ2Il
         l+JFlT22l61AkxG31ShaC0Qw1oYQLWteXY+34as661ZjgCOZxVZ4d0zuTjR/G127u4UX
         JbIKX0/2p+TczVDqr4LHqCb3uXkUMhdun2IoI7AWx+/DSq3jntw3iR2acEB6PXyKr30Z
         6OSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vxNgOQvQzQD1y7rtzGi+GT8dfHZ/R+vwp6DNWXHP+vE=;
        b=PvT/rMhB9SZdWq1Xf/FobQ6HxkSWzKR0Xbu/Ys/+WVo2LQzb2Wuwq1H2J+Hge4OHWt
         dhtCzYv+nJRf3HVM5v9Jvbh6itMu6tnyONDKe2NLgdTrkfQPer7DkPDQSFlXcFajxWmf
         6XJXprKc3eHvVYeNZJb82kjvlSm0JffmhwcWSlk1o7AppHv2x5DSjcNcvD6zymdMXrU6
         EzI2BPh9144qhl9Xb0OnA1CXtq7G9mXrjDat7z/O8zC5PNmrkAgJfB9WtxMue8f1E7a3
         KH18IZ9vMbZUEASclHMauhvMKhHphNYJRRoU25k/XxlQ+LHWYj1Fghsqkb4iLptuCu+I
         TsJg==
X-Gm-Message-State: AOAM532WFlxwipfq1NihfUE2s2/EXEMYxZRpGaXXDt6BUqYY91dA/8Y7
	EOx9W0MwLVLVLv8PyjNL4vck6WMcf7jPkHaIHPE=
X-Google-Smtp-Source: ABdhPJwGf6FEVyrEXjFf9t9cigS6rbgz0ERQiGUrPDsmdeMbF27OaQ5ITy8dCxdVHxMqP6aMsG6w0X53iN/Yb2aDnYo=
X-Received: by 2002:a9d:4703:: with SMTP id a3mr16366490otf.179.1604417286824;
 Tue, 03 Nov 2020 07:28:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1604393169.git.szabolcs.nagy@arm.com> <7b008fd34f802456db3731a043ff56683b569ff7.1604393169.git.szabolcs.nagy@arm.com>
 <87r1pabu9g.fsf@oldenburg2.str.redhat.com> <CAMe9rOpmiiBEZqLz-94_MEwgRky+EUsfd=X6Ue30H2c9R=dSKQ@mail.gmail.com>
 <20201103150412.GA24704@arm.com>
In-Reply-To: <20201103150412.GA24704@arm.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Tue, 3 Nov 2020 07:27:30 -0800
Message-ID: <CAMe9rOpOn7YgarNf5R1x6DFKC5fsnQBJX7--yQWjP4x=jBMmjQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] elf: Move note processing after l_phdr is updated [BZ #26831]
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, 
	Jeremy Linton <jeremy.linton@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, 
	Mark Brown <broonie@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Salvatore Mesoraca <s.mesoraca16@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, 
	Topi Miettinen <toiwoton@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 3, 2020 at 7:04 AM Szabolcs Nagy <szabolcs.nagy@arm.com> wrote:
>
> The 11/03/2020 04:36, H.J. Lu wrote:
> > On Tue, Nov 3, 2020 at 2:38 AM Florian Weimer <fweimer@redhat.com> wrote:
> > > * Szabolcs Nagy:
> > >
> > > > Program headers are processed in two pass: after the first pass
> > > > load segments are mmapped so in the second pass target specific
> > > > note processing logic can access the notes.
> > > >
> > > > The second pass is moved later so various link_map fields are
> > > > set up that may be useful for note processing such as l_phdr.
> > > > ---
> > > >  elf/dl-load.c | 30 +++++++++++++++---------------
> > > >  1 file changed, 15 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/elf/dl-load.c b/elf/dl-load.c
> > > > index ceaab7f18e..673cf960a0 100644
> > > > --- a/elf/dl-load.c
> > > > +++ b/elf/dl-load.c
> > > > @@ -1259,21 +1259,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
> > > >                                 maplength, has_holes, loader);
> > > >      if (__glibc_unlikely (errstring != NULL))
> > > >        goto call_lose;
> > > > -
> > > > -    /* Process program headers again after load segments are mapped in
> > > > -       case processing requires accessing those segments.  Scan program
> > > > -       headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > > > -       exits.  */
> > > > -    for (ph = &phdr[l->l_phnum]; ph != phdr; --ph)
> > > > -      switch (ph[-1].p_type)
> > > > -     {
> > > > -     case PT_NOTE:
> > > > -       _dl_process_pt_note (l, fd, &ph[-1]);
> > > > -       break;
> > > > -     case PT_GNU_PROPERTY:
> > > > -       _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > > > -       break;
> > > > -     }
> > > >    }
> > > >
> > > >    if (l->l_ld == 0)
> > > > @@ -1481,6 +1466,21 @@ cannot enable executable stack as shared object requires");
> > > >      /* Assign the next available module ID.  */
> > > >      l->l_tls_modid = _dl_next_tls_modid ();
> > > >
> > > > +  /* Process program headers again after load segments are mapped in
> > > > +     case processing requires accessing those segments.  Scan program
> > > > +     headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > > > +     exits.  */
> > > > +  for (ph = &l->l_phdr[l->l_phnum]; ph != l->l_phdr; --ph)
> > > > +    switch (ph[-1].p_type)
> > > > +      {
> > > > +      case PT_NOTE:
> > > > +     _dl_process_pt_note (l, fd, &ph[-1]);
> > > > +     break;
> > > > +      case PT_GNU_PROPERTY:
> > > > +     _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > > > +     break;
> > > > +      }
> > > > +
> > > >  #ifdef DL_AFTER_LOAD
> > > >    DL_AFTER_LOAD (l);
> > > >  #endif
> > >
> > > Is this still compatible with the CET requirements?
> > >
> > > I hope it is because the CET magic happens in _dl_open_check, so after
> > > the the code in elf/dl-load.c has run.
>
> i believe the note processing and later cet magic
> are not affected by this code move.
>
> but i did not test this with cet.
>
> >
> > _dl_process_pt_note and _dl_process_pt_gnu_property may call
> > _dl_signal_error.  Are we prepared to clean more things up when it
> > happens?  I am investigating:
>
> yeah, this is difficult to reason about.
>
> it seems to me that after _dl_map_object returns there
> may be _dl_map_object_deps which can fail in a way that
> all of dlopen has to be rolled back, so if i move things
> around in _dl_map_object that should not introduce new
> issues.

I haven't investigated it in detail.  But there are

1314   if (l->l_phdr == NULL)
1315     {
1316       /* The program header is not contained in any of the segments.
1317          We have to allocate memory ourself and copy it over from out
1318          temporary place.  */
1319       ElfW(Phdr) *newp = (ElfW(Phdr) *) malloc (header->e_phnum
1320                                                 * sizeof (ElfW(Phdr)));
1321       if (newp == NULL)
1322         {
1323           errstring = N_("cannot allocate memory for program header");
1324           goto call_lose_errno;
1325         }
1326
1327       l->l_phdr = memcpy (newp, phdr,
1328                           (header->e_phnum * sizeof (ElfW(Phdr))));
1329       l->l_phdr_allocated = 1;
1330     }

When _dl_process_pt_gnu_property is moved after it, will l_phdr be
free on _dl_signal_error?

> but it is not clear to me how robust the dlopen code is
> against arbitrary failure in dl_open_worker.

I think we are mostly OK, except for some corner cases.   Delay
_dl_process_pt_gnu_property may introduce more corner cases.

> >
> > https://sourceware.org/bugzilla/show_bug.cgi?id=26825
> >
> > I don't think cleanup of _dl_process_pt_gnu_property failure is done
> > properly.
> >
> > --
> > H.J.
>
> --



-- 
H.J.
