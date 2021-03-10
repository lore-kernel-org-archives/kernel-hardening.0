Return-Path: <SRS0=ydbm=II=lists.openwall.com=kernel-hardening-return-20907-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF02EC433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 12:52:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA7D864FE0
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 12:52:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA7D864FE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20907-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30315 invoked by uid 550); 10 Mar 2021 12:52:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30290 invoked from network); 10 Mar 2021 12:52:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BK42rEfZDnxMm7tn7QJoRMRkMDyVR3i3bNbcPekdIg=;
        b=h3fEZUkobZr1jCHE1WazBNRG4q6cvgfOa2N+PfxLN8F7RZJkzgxy8/c570n7v1gsgE
         wSVCeFTC/83l9s7h3AlU7OrKC5RGtvsuxScUqY6IJhXjcghZQ8EL07clpakh4MTYsG7o
         6KoC27yoGboGzxYaB+5W8my72cxKXJZYwPWTh6e8c4ZfV+hRQj3DRwvP3l72LQhNw298
         sOkfAxTRzwbtQwEezjar0b8cKncz7NqR60/GEO5Od0xr52s3xXhE73SXrE4cXBPxJIlS
         lmmdDl8v0ikLdUjBpWCTlgfWxaqXztaooul2c927TtNy00/RKZdi/4PbDlNVnuRV13n1
         rroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BK42rEfZDnxMm7tn7QJoRMRkMDyVR3i3bNbcPekdIg=;
        b=raC68YxtpVXTvYeuMf7S+BUN37mLw+/GfilfkPcyIx7tEryksgH+T9AwsfA/bexRoj
         9sX4u+9cgSvQ32zvxKDH3+LWckdOIH7STOQeCM9FmZOUXoydfn6TR8eJHJfFzhDlk9QL
         u6iCq6WI5a6ASuH16Lv7w9Ty1+kzYCR+p2iEHS5OyRzxP0VrN63SO1+q/la5WaKvkJpt
         cqnzF2CYE31UoXYgjaPe8WoJkO/Xu3aTazZ4DK9+ItHiuV7n6R2Eq2d7I3LiSf6p7dPb
         3p60dxDOj5dqsBLp1kKe46KpePP/QO85CyngFfmacRHVMfH1QjYOo/sWtx99PSZsDSxb
         xorw==
X-Gm-Message-State: AOAM533HA5LNHiA9zPPf2/Db438x7MhrJcCpOMSR4MR5DGz2deRdR7Wb
	MP7Qb0vMlmQfjettU5mCx3MEUqQr6xvdBiSSaDhcUQ==
X-Google-Smtp-Source: ABdhPJz6Al6cQ9o2Jkic0AM6aT+uI8HXaIO3FGRdEqDpDV6bZgYd+QRynVKdHFUIi1JAN2QCB/oYogOY84k0cBj6NyQ=
X-Received: by 2002:a63:455d:: with SMTP id u29mr2647321pgk.286.1615380735994;
 Wed, 10 Mar 2021 04:52:15 -0800 (PST)
MIME-Version: 1.0
References: <20210309214301.678739-1-keescook@chromium.org> <20210309214301.678739-4-keescook@chromium.org>
In-Reply-To: <20210309214301.678739-4-keescook@chromium.org>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 10 Mar 2021 13:52:04 +0100
Message-ID: <CAAeHK+xog8-DP1o=1qqKgSP7Hii2Yjah6oyowNE3zSNVW5pRSw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] init_on_alloc: Unpessimize default-on builds
To: Kees Cook <keescook@chromium.org>, Alexander Potapenko <glider@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Popov <alex.popov@linux.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 9, 2021 at 10:43 PM Kees Cook <keescook@chromium.org> wrote:
>
> Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
> ...ON_FREE...) did not change the assembly ordering of the static branch
> tests. Use the new jump_label macro to check CONFIG settings to default
> to the "expected" state, unpessimizes the resulting assembly code.
>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Link: https://lore.kernel.org/lkml/CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com/
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/mm.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bf341a9bfe46..2ccd856ac0d1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2874,7 +2874,8 @@ static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
>  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
>  static inline bool want_init_on_alloc(gfp_t flags)
>  {
> -       if (static_branch_unlikely(&init_on_alloc))
> +       if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
> +                               &init_on_alloc))
>                 return true;
>         return flags & __GFP_ZERO;
>  }
> @@ -2882,7 +2883,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
>  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
>  static inline bool want_init_on_free(void)
>  {
> -       return static_branch_unlikely(&init_on_free);
> +       return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
> +                                  &init_on_free);
>  }
>
>  extern bool _debug_pagealloc_enabled_early;

Should we also update slab_want_init_on_alloc() and slab_want_init_on_free()?
