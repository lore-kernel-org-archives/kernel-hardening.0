Return-Path: <SRS0=aGid=DH=lists.openwall.com=kernel-hardening-return-20067-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA55FC4727E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 12:51:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B470120674
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 12:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L7X6TOpx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B470120674
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20067-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20104 invoked by uid 550); 30 Sep 2020 12:51:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20084 invoked from network); 30 Sep 2020 12:51:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=061+j+6egSPgQBxcQTsTW5phFlVIKpu1EERfRNYFm3I=;
        b=L7X6TOpxVSA1+/tKoz+lBrre35i6hykvaIsiSKRHazC1OEzRn8KvgpXAhkiiZiVegY
         hdXFas3bd8RElezjRN1Xeo7xyo7N2TkVLXtqU3NGt5Q8cVO3mr5kv+TEr1CYFZCRj4Z/
         NW5e/35SOVX/7oaogpcsuZY+pT2bwreoZd2XwBqQnwrCKrSePcNpSqJb0uFF/Id6AfFs
         KOYk8XjmATWuR/1g8kLMRJOhm10DPe9hbErIsERzBQXL30eRmJc/Lg9yUE0wgl2QU6er
         RnRvuI5XvMS9yKOd/4XI7PcEwBEw2l3rf/ujZ4+IWPrfSKuDeZm1cQ/nKtWd1HwBDjMP
         EdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=061+j+6egSPgQBxcQTsTW5phFlVIKpu1EERfRNYFm3I=;
        b=ISSX3jUhmjbMPKe3+E8+giDC5BDb9fvU6BmR08Sk5EazVrvojPbRVoIPp2vervqP/U
         2MTSnwyQuQ7tjQ47Bf26dS+BZePKuBTvMV76bCWPT8/Lvs0J1l5YeqIOjVk9XusW+7K/
         4iK+4RoTiFtvj8tEZzDtypPfk4UZFDNSjnoOMWsigb97tbEpu+VuV/H/TtKIq06iDRk8
         xgCB9tZz/ICFyAxpUYNlXsGmtbdJm8AKWpnloptO9Tj52xkGO3BL/VsD5t/ldFMPWTZO
         h/GQNctdps4IEBuJNu4VHQ0kSajA0cFV/S2aey25oYkkjcGCSLpvl691JHIO2cC2Iyh5
         uhMA==
X-Gm-Message-State: AOAM530KxfY3Qv4I7gcXWcQqdNyl2rXcii4WpxlWgut0Tdw8Y8mIlM6L
	acp3LN7yKg+5uQTsovN6itRy7nXxzT5VFhhY9EIIkA==
X-Google-Smtp-Source: ABdhPJzmy6011bRCaz/kYoxOSxfcZV6R3wEOIH1+eORfD6559vOkDZuINzOB4rqg9WTL3BgoD4kKzA3W5h9iSh2kySo=
X-Received: by 2002:a7b:cd93:: with SMTP id y19mr2785473wmj.112.1601470270876;
 Wed, 30 Sep 2020 05:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200929183513.380760-1-alex.popov@linux.com> <20200929183513.380760-3-alex.popov@linux.com>
In-Reply-To: <20200929183513.380760-3-alex.popov@linux.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 30 Sep 2020 14:50:59 +0200
Message-ID: <CAG_fn=WY9OFKuy6utMHOgyr+1DYNsuzVruGCGHMDnEnaLY6s9g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/6] mm/slab: Perform init_on_free earlier
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
	Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Patrick Bellasi <patrick.bellasi@arm.com>, David Howells <dhowells@redhat.com>, 
	Eric Biederman <ebiederm@xmission.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Micay <danielmicay@gmail.com>, 
	Andrey Konovalov <andreyknvl@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Pavel Machek <pavel@denx.de>, Valentin Schneider <valentin.schneider@arm.com>, 
	kasan-dev <kasan-dev@googlegroups.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2020 at 8:35 PM Alexander Popov <alex.popov@linux.com> wrot=
e:
>
> Currently in CONFIG_SLAB init_on_free happens too late, and heap
> objects go to the heap quarantine being dirty. Lets move memory
> clearing before calling kasan_slab_free() to fix that.
>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

> ---
>  mm/slab.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 3160dff6fd76..5140203c5b76 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3414,6 +3414,9 @@ static void cache_flusharray(struct kmem_cache *cac=
hep, struct array_cache *ac)
>  static __always_inline void __cache_free(struct kmem_cache *cachep, void=
 *objp,
>                                          unsigned long caller)
>  {
> +       if (unlikely(slab_want_init_on_free(cachep)))
> +               memset(objp, 0, cachep->object_size);
> +
>         /* Put the object into the quarantine, don't touch it for now. */
>         if (kasan_slab_free(cachep, objp, _RET_IP_))
>                 return;
> @@ -3432,8 +3435,6 @@ void ___cache_free(struct kmem_cache *cachep, void =
*objp,
>         struct array_cache *ac =3D cpu_cache_get(cachep);
>
>         check_irq_off();
> -       if (unlikely(slab_want_init_on_free(cachep)))
> -               memset(objp, 0, cachep->object_size);
>         kmemleak_free_recursive(objp, cachep->flags);
>         objp =3D cache_free_debugcheck(cachep, objp, caller);
>         memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
> --
> 2.26.2
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
