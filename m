Return-Path: <SRS0=3Gkx=EJ=lists.openwall.com=kernel-hardening-return-20329-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F3DC388F7
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 12:37:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0CF6E22243
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 12:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XD7mAyth"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CF6E22243
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20329-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3296 invoked by uid 550); 3 Nov 2020 12:37:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3274 invoked from network); 3 Nov 2020 12:37:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrbagZwNW9slCt6d/AW8rMDwMZtrFWYw7alPEHvkmb4=;
        b=XD7mAythtfRoMdczS5VWBLhyjc7jTlavZz1aVCztraJAEromDAsGVN2YLNSbWrhI8m
         QJAJ+ra69zL0lDZxUQJesUh91Q2B82zivVUoFqa/tUWzRJeDhEp+Tko0/5rU3DCqD1QU
         u3GxNhasdzl/iL9iR2J2JR0JVKKiVQVA9mdTBYNzWmWCJqCKgX6KIBREHBksolSjLptU
         4dVSjoml5xDkIa6S5ONv6595yfQ1j1IigtUI78jmegtrtWvgX0Dzu2LE5FQ06VZMnDEq
         bBMk8WdZwFHTR3UKA0o3rINViXNQNSNWtH58O4NxyVLPTUAahVyJEVvkp5y64dANxo30
         9fIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrbagZwNW9slCt6d/AW8rMDwMZtrFWYw7alPEHvkmb4=;
        b=OR/ommkQ9cEg0TkYyEJ+YsjMIYyzcSzRX9M2zpjMkWQlFvrNP/670vjhiLCp7cKgEF
         Xqw26dDINkOdzjKjo/lWHL7ZM+mfP+pbvdj4GE/RnXHNnsB8Guj2cmgUN7EeGuuXlc5F
         PU2Bzi5WiO1/k21aIpw5nHtQXIDaXRZR2Kc9KGUOsJE5n4pDBK0sqYKvMADf2B/wrqcw
         T4Xq0lwAhCeplqq0ou7QY/FMf7qXPNnpTm+nnVr3mMENCIDrWGYMJFV9YscFY51JFaJ7
         T5ClyXPZdIlV467ooz6OIOhprqQ9wMtCgHwLRQ2Gt6pBb+s9ygSFuwIYcW+UGNMNJGap
         YpEw==
X-Gm-Message-State: AOAM5325iRtNsTh17NQZnUWo3wQUoMBmGgaLbRKMUbtucmle/n1CymK1
	lSa/QhUggH8hyb8nXBbTnLb+XUGCbiuHB+irDXc=
X-Google-Smtp-Source: ABdhPJyiy3o8C1TgEne1rTFHQu9/FF6LUkyCqxhXYUWuyQK4hEgSdw24cCTFKp2kv+fiAqnSzMITpQ8pDGqPeuVJmVI=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr14654958ots.90.1604407038742;
 Tue, 03 Nov 2020 04:37:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1604393169.git.szabolcs.nagy@arm.com> <7b008fd34f802456db3731a043ff56683b569ff7.1604393169.git.szabolcs.nagy@arm.com>
 <87r1pabu9g.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87r1pabu9g.fsf@oldenburg2.str.redhat.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Tue, 3 Nov 2020 04:36:42 -0800
Message-ID: <CAMe9rOpmiiBEZqLz-94_MEwgRky+EUsfd=X6Ue30H2c9R=dSKQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] elf: Move note processing after l_phdr is updated [BZ #26831]
To: Florian Weimer <fweimer@redhat.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>, GNU C Library <libc-alpha@sourceware.org>, 
	Jeremy Linton <jeremy.linton@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, 
	Mark Brown <broonie@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Salvatore Mesoraca <s.mesoraca16@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, 
	Topi Miettinen <toiwoton@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 3, 2020 at 2:38 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Szabolcs Nagy:
>
> > Program headers are processed in two pass: after the first pass
> > load segments are mmapped so in the second pass target specific
> > note processing logic can access the notes.
> >
> > The second pass is moved later so various link_map fields are
> > set up that may be useful for note processing such as l_phdr.
> > ---
> >  elf/dl-load.c | 30 +++++++++++++++---------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/elf/dl-load.c b/elf/dl-load.c
> > index ceaab7f18e..673cf960a0 100644
> > --- a/elf/dl-load.c
> > +++ b/elf/dl-load.c
> > @@ -1259,21 +1259,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
> >                                 maplength, has_holes, loader);
> >      if (__glibc_unlikely (errstring != NULL))
> >        goto call_lose;
> > -
> > -    /* Process program headers again after load segments are mapped in
> > -       case processing requires accessing those segments.  Scan program
> > -       headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > -       exits.  */
> > -    for (ph = &phdr[l->l_phnum]; ph != phdr; --ph)
> > -      switch (ph[-1].p_type)
> > -     {
> > -     case PT_NOTE:
> > -       _dl_process_pt_note (l, fd, &ph[-1]);
> > -       break;
> > -     case PT_GNU_PROPERTY:
> > -       _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > -       break;
> > -     }
> >    }
> >
> >    if (l->l_ld == 0)
> > @@ -1481,6 +1466,21 @@ cannot enable executable stack as shared object requires");
> >      /* Assign the next available module ID.  */
> >      l->l_tls_modid = _dl_next_tls_modid ();
> >
> > +  /* Process program headers again after load segments are mapped in
> > +     case processing requires accessing those segments.  Scan program
> > +     headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > +     exits.  */
> > +  for (ph = &l->l_phdr[l->l_phnum]; ph != l->l_phdr; --ph)
> > +    switch (ph[-1].p_type)
> > +      {
> > +      case PT_NOTE:
> > +     _dl_process_pt_note (l, fd, &ph[-1]);
> > +     break;
> > +      case PT_GNU_PROPERTY:
> > +     _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > +     break;
> > +      }
> > +
> >  #ifdef DL_AFTER_LOAD
> >    DL_AFTER_LOAD (l);
> >  #endif
>
> Is this still compatible with the CET requirements?
>
> I hope it is because the CET magic happens in _dl_open_check, so after
> the the code in elf/dl-load.c has run.
>
>

_dl_process_pt_note and _dl_process_pt_gnu_property may call
_dl_signal_error.  Are we prepared to clean more things up when it
happens?  I am investigating:

https://sourceware.org/bugzilla/show_bug.cgi?id=26825

I don't think cleanup of _dl_process_pt_gnu_property failure is done
properly.

-- 
H.J.
