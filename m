Return-Path: <SRS0=9pv1=5L=lists.openwall.com=kernel-hardening-return-18233-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AB9C43331
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 15:49:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 53AFB20737
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 15:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S/kSykVL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53AFB20737
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18233-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15687 invoked by uid 550); 26 Mar 2020 15:49:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15655 invoked from network); 26 Mar 2020 15:49:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tnn7KHY4eWHTo8zdroLBrOpWxVoG9chHd2LE7rb+g4c=;
        b=S/kSykVLIzOW+bMtz28j9SL0IboXQaDEabZEPluAQ/jdTHKWYG9FhojaUl0Fmq4B1P
         r3AOSY0O8LRBGxIut4Bs4gZXoJioXnt3PtNqTi1ystbqUw6iLFXcpAkXhOpGcigUixPy
         S3ncz6t/Ez10hkmDVMtK4taf2eL2L8Yc7N/mCu2LeWk2BMUaqKLjXQbdxJxM3t7p01vm
         DO4BwnJI29K3mRmETdN4mZCqxfiDdPigj1O7hrw7LtCoGHzH9Iu/dAy3ZkDdaeonu93N
         4HIrT4yneg3HIAFtgQYxod4eIlZMNQiUgoqjN9wVmdZ8fghCzcV0kAEEByfR9Je738JZ
         MdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tnn7KHY4eWHTo8zdroLBrOpWxVoG9chHd2LE7rb+g4c=;
        b=GWurk49PalwfMhSpMGijoKG0XjHROGdWi3INxvAnJj9mYYPpzy61yHxh+nLRUCg7V/
         xVys9mkRzVKGciAB2ZKfpfXHxqz5Dy/LmlGopCY9i/ScF9Sgc/UJURVc5nwJcyFaXvwX
         eKivkZ/O3wnKt/d8SJVSm9317DCvUEECH8l7GPtsBQaAYR8r9TgvZ5mzNdLTB+8EDuZh
         so69L+9BAcoLLjkAK0afyHmRP592vVaqOZ1YfcQ3CsH+a9M6mivgm6sYnEFadPyrW1VJ
         a8LCdI2vSf757rKMY0kRcDX2qI5/eKbiWhZKQuOWkxOXk9Qru+5wUkm8pEXRXjh3KHtI
         I4Jg==
X-Gm-Message-State: ANhLgQ1Sf6o6g1NkZUsf6rsnUCqzjGlPpsgsLPqfuaJnNJAyb6o3yLca
	yK9nD/OJp0ZQK945ztA0wpnbxsoucuqUmc1mB8V6ZA==
X-Google-Smtp-Source: ADFU+vv6nSdJKaQuPkAMrcUtKm8kmac0YVBKRQ4HyVrhEfsZEMMr7tcXI64Kt8igxgOVmda0hFaoxYzxjJIM+XsxhHA=
X-Received: by 2002:a05:600c:22c1:: with SMTP id 1mr518314wmg.29.1585237733584;
 Thu, 26 Mar 2020 08:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200324203231.64324-1-keescook@chromium.org> <20200324203231.64324-3-keescook@chromium.org>
In-Reply-To: <20200324203231.64324-3-keescook@chromium.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 26 Mar 2020 16:48:41 +0100
Message-ID: <CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] init_on_alloc: Unpessimize default-on builds
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Jann Horn <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2020 at 9:32 PM Kees Cook <keescook@chromium.org> wrote:
>
> Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
> ...ON_FREE...) did not change the assembly ordering of the static branch
> tests. Use the new jump_label macro to check CONFIG settings to default
> to the "expected" state, unpessimizes the resulting assembly code.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/mm.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 059658604dd6..64e911159ffa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2665,7 +2665,8 @@ static inline void kernel_poison_pages(struct page =
*page, int numpages,
>  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc)=
;
>  static inline bool want_init_on_alloc(gfp_t flags)
>  {
> -       if (static_branch_unlikely(&init_on_alloc) &&
> +       if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
> +                               &init_on_alloc) &&
>             !page_poisoning_enabled())
>                 return true;
>         return flags & __GFP_ZERO;
> @@ -2674,7 +2675,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
>  DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
>  static inline bool want_init_on_free(void)
>  {
> -       return static_branch_unlikely(&init_on_free) &&
> +       return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
> +                                  &init_on_free) &&
>                !page_poisoning_enabled();
>  }
>
> --
> 2.20.1
>
Reviewed-by: Alexander Potapenko <glider@google.com>

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
