Return-Path: <SRS0=OE8C=II=lists.openwall.com=kernel-hardening-return-20919-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB18C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 21:04:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C38C464FC8
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 21:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C38C464FC8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20919-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28232 invoked by uid 550); 10 Mar 2021 21:04:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28212 invoked from network); 10 Mar 2021 21:04:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kgZRDWg+E5eBmEuNfvh5FPMkh8S3VA4zLnMLimy3dco=;
        b=YN0Z/Vhtni4MgeYq5ZXFSPAnmyYH+lkZC+AUrGdL1FSjOP6FTEcki8jRb9CpsNidan
         bTf6DVBu9IZ9qccH7IA+cOlRe8qbtBRf7N3rHBrgr/zXFmg3FnjjA8PO7MJE/yIDO1/a
         qFVyvQ+I7V0ur72vLR6/jxgCfMQLRlBhrNqzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kgZRDWg+E5eBmEuNfvh5FPMkh8S3VA4zLnMLimy3dco=;
        b=tbq9JJxA1ihxLelphlQWBb9Tq4lbOXgUS4nP2QOjr+6ulvv9eyNWOMiAJ/7GPjclh5
         k4i5ziX4ccd2UgrPMk8brJhS48EvsF1BRThIzSgSUN3/vFUkVuGZ1TUx4YixIOsNTf3r
         EUjBF/SoHp20qx0dnipEAG7T9pnEndeMlNg5p01rygla0HQwYBrrhXO2ID839D9Wd3vC
         pmeAKtIutBASs4axbe+GaUos35SxXe+0fFHgzKSkxKTTtG0PB4Y3RM5P/ywTI4g/6/tw
         Px+/7NGJZzxqbqMi98/gA+K9EtqfTONStr8hDhh8V/hZIs1S9pYj8sDII9XPaS7d70MS
         2Vxw==
X-Gm-Message-State: AOAM5307+5LWAao+OjxEWovcNnXzBS1/NFnekEIIvulgdhAvZ6vfx8nQ
	dZ5GI+qzsU3uLi0PUAI9bNlEJg==
X-Google-Smtp-Source: ABdhPJx0EQbJUnNqWnWy4ORz94xOvLvvXICL3tLfic8hpJEypnFS58ssYytUjMkPtAFORl44nriB/w==
X-Received: by 2002:aa7:9154:0:b029:1ee:fa0d:24dd with SMTP id 20-20020aa791540000b02901eefa0d24ddmr4403109pfi.17.1615410232053;
        Wed, 10 Mar 2021 13:03:52 -0800 (PST)
Date: Wed, 10 Mar 2021 13:03:50 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 3/7] init_on_alloc: Unpessimize default-on builds
Message-ID: <202103101303.6E6569C1@keescook>
References: <20210309214301.678739-1-keescook@chromium.org>
 <20210309214301.678739-4-keescook@chromium.org>
 <CAAeHK+xog8-DP1o=1qqKgSP7Hii2Yjah6oyowNE3zSNVW5pRSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+xog8-DP1o=1qqKgSP7Hii2Yjah6oyowNE3zSNVW5pRSw@mail.gmail.com>

On Wed, Mar 10, 2021 at 01:52:04PM +0100, Andrey Konovalov wrote:
> On Tue, Mar 9, 2021 at 10:43 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
> > ...ON_FREE...) did not change the assembly ordering of the static branch
> > tests. Use the new jump_label macro to check CONFIG settings to default
> > to the "expected" state, unpessimizes the resulting assembly code.
> >
> > Reviewed-by: Alexander Potapenko <glider@google.com>
> > Link: https://lore.kernel.org/lkml/CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com/
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  include/linux/mm.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index bf341a9bfe46..2ccd856ac0d1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2874,7 +2874,8 @@ static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
> >  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
> >  static inline bool want_init_on_alloc(gfp_t flags)
> >  {
> > -       if (static_branch_unlikely(&init_on_alloc))
> > +       if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
> > +                               &init_on_alloc))
> >                 return true;
> >         return flags & __GFP_ZERO;
> >  }
> > @@ -2882,7 +2883,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
> >  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
> >  static inline bool want_init_on_free(void)
> >  {
> > -       return static_branch_unlikely(&init_on_free);
> > +       return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
> > +                                  &init_on_free);
> >  }
> >
> >  extern bool _debug_pagealloc_enabled_early;
> 
> Should we also update slab_want_init_on_alloc() and slab_want_init_on_free()?

Whoops! Thank you; I will update and resend. :)

-- 
Kees Cook
