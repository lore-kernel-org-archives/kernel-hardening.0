Return-Path: <SRS0=OccV=UZ=lists.openwall.com=kernel-hardening-return-16259-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9027BC48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:01:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E22FD20645
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DK/n2Vrq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E22FD20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16259-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15654 invoked by uid 550); 26 Jun 2019 15:01:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15636 invoked from network); 26 Jun 2019 15:01:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zoBpYP6DnaC2e4XaW1/B4gA/As2GEKNd5dW1F1ry1DA=;
        b=DK/n2VrqOoEDzclYHyq2tl89y1S1BefzXcCfPYtMbncmdAEousuPD4nlrlFXjn1yAf
         0UZ2zw7aNcVImRdErGoO1CbC7dXKUVSHtuP/yzBJwyIo0zemDC+R1hWnWRVjgVrAnU/G
         cvK2xJ+dmRwfI/NlGzWTm84i2qOlJR71o3B40rbm5P6vctgPwQKEgs1Tg5/t6YaLCHdC
         NspZwHSWueky8RI+rBqgzac4hPLgVsWXreGq8arKJv49UONak6A2T0SZgr27vzlXESkF
         A2h4u/1rIlOtZdFXckVdzyVlUD6I+t5bFeMa4UmxkyNAZS24W5IdZKhDlhFU8RIuBuk/
         acXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zoBpYP6DnaC2e4XaW1/B4gA/As2GEKNd5dW1F1ry1DA=;
        b=QbOUJuwdsJBHzXUbXrXjdy0aKbg2mBCEtxeEO0Iz4vMFnjxOy8ygWqT61TiFtl9xDe
         3Pjju0rhK+9ma8ctZqgWxG5Uyd7o1U84aCgd1Pp6w1WFOWQCx6g8twq2lHDLmApwEJvm
         CmQUjyZ4h/9R7eSr2Chvne4KDYfqIQtd3qOdkCC3bNbtnpSFzZdKz052PMdaefUnqZeo
         +ewtPv67ZAqlKqVrmLfhIdyUsJHqmHjdp3PoQiA5zlDRSOdNvLfk+eGGIjzr9mJ4S2Ix
         UeUpbu39rbvLUsusBU9okYd1F8f0RE/3LWfrx2aTlbt/2hNuC86KfEQWWzM7rms0w6C1
         Ejmw==
X-Gm-Message-State: APjAAAX9z3QEOhiZDr7l5y25ijIJZht22edNhW11li8FBEGh3cCLALyB
	pU2BxouEhzCoCioMQHJIeaDykGX3DnvQTxFtbC8aig==
X-Google-Smtp-Source: APXvYqxOM1Qhb4bYwyr4BHkaaqPHuZq394nkXxdn6QI/Fj8/wCimkp9o3YMPWPV8de9K2LGJFGbIpbZSCKxhz9J77fk=
X-Received: by 2002:ab0:3d2:: with SMTP id 76mr2748402uau.12.1561561255636;
 Wed, 26 Jun 2019 08:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com> <20190626121943.131390-2-glider@google.com>
 <20190626144943.GY17798@dhcp22.suse.cz>
In-Reply-To: <20190626144943.GY17798@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 26 Jun 2019 17:00:43 +0200
Message-ID: <CAG_fn=Xf5yEuz7JyOt-gmNx1uSM6mmM57_jFxCi+9VPZ4PSwJQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 4:49 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 26-06-19 14:19:42, Alexander Potapenko wrote:
> [...]
> > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > index 8c94c89a6f7e..fe5d33060415 100644
> > --- a/mm/dmapool.c
> > +++ b/mm/dmapool.c
> [...]
> > @@ -428,6 +428,8 @@ void dma_pool_free(struct dma_pool *pool, void *vad=
dr, dma_addr_t dma)
> >       }
> >
> >       offset =3D vaddr - page->vaddr;
> > +     if (want_init_on_free())
> > +             memset(vaddr, 0, pool->size);
>
> any reason why this is not in DMAPOOL_DEBUG else branch? Why would you
> want to both zero on free and poison on free?
This makes sense, thanks.

> >  #ifdef       DMAPOOL_DEBUG
> >       if ((dma - page->dma) !=3D offset) {
> >               spin_unlock_irqrestore(&pool->lock, flags);
>
> [...]
>
> > @@ -1142,6 +1200,8 @@ static __always_inline bool free_pages_prepare(st=
ruct page *page,
> >       }
> >       arch_free_page(page, order);
> >       kernel_poison_pages(page, 1 << order, 0);
> > +     if (want_init_on_free())
> > +             kernel_init_free_pages(page, 1 << order);
>
> same here. If you don't want to make this exclusive then you have to
> zero before poisoning otherwise you are going to blow up on the poison
> check, right?
Note that we disable initialization if page poisoning is on.
As I mentioned on another thread we can eventually merge this code
with page poisoning, but right now it's better to make the user decide
which of the features they want instead of letting them guess how the
combination of the two is going to work.
> >       if (debug_pagealloc_enabled())
> >               kernel_map_pages(page, 1 << order, 0);
> >
> --
> Michal Hocko
> SUSE Labs



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
