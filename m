Return-Path: <SRS0=VTAP=U2=lists.openwall.com=kernel-hardening-return-16289-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB04C48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 13:17:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2462E2086D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 13:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OC1UYhpB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2462E2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16289-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11933 invoked by uid 550); 27 Jun 2019 13:17:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11915 invoked from network); 27 Jun 2019 13:17:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vy9qWbldNZVn/tHHwiK7Of/LXRmbGzfYDFquQFBj1LU=;
        b=OC1UYhpBFS959lMOYt/IcpryLBaWsNxeZVjDmulenf6LUHVyIdy908unuOq9TESJxu
         /jkJrUavVPEjsBXhsHduYzVOFoca0ZCd4/4qS+y7GeZOz2qnbNZ6yE2ezvymUQUwMXnR
         1VBmCcxbiwfi2K6u4ZxvPrSSuN3Y9Ij2zo7Bae2jaObMlfvrnv5Ov4dPgNdHTK+qdcws
         Xt7uk5cQg4hAD3lWE8r3HMBcfVDD3YNIQ0V1yLsVqZXyx0KXXdvzjV0oKSwobxrX9bD6
         jVZoIO6OtjAntp/8ckwjiNzV+G7Xru+qFaE5KcbKor98V1qhpmDHM3UagK4fo3NvTHvd
         Qs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vy9qWbldNZVn/tHHwiK7Of/LXRmbGzfYDFquQFBj1LU=;
        b=t/0ziwrWMnuX/XCD6PipfZsRx/0BMK6mwJYJFNULNN8/KoiF7cN1Z/cmZQaWrDDUcP
         CDq4TukNlIeGK4cqYZk4PfbLZlDYo+KuxvzuzUx/3qpWxmuyAo/RIw//KoErqFlVk7cw
         wbzANw93e/dgD4qrj4WXNpaw0i/+K/79/4/qAx484R2iaWp5lWp9bojXPYDKhtVk74Up
         a9gVRX9Z5ZO7UzvTyxZ2GCroA3O4VP8HBa1tBAN57KW2e5dZzSkDLwHTQ0BqAo3Y7Kne
         EoJV3+a7hDA/v6ay/yAOcVwn4pTrbt2fNYluGtz1s/VNE51WXh2id/wtHrXcuQqvrz3a
         WepQ==
X-Gm-Message-State: APjAAAUqFNxbq3W40TKSO++WowbrDoZ/EiT7Em93ga/+PAXAibPRLnXI
	VtENeAXd34zlc5bvJtqzOHEEkhuBa2LZs2+kGK6K3w==
X-Google-Smtp-Source: APXvYqztRBRUmdw5LT1ObTf3jCkBOxfHFV2ozeQLBqAbyAIQTUUdoZukbB+6Skv3+6Fb/xNGQlqQRi+6N5axxh0px5w=
X-Received: by 2002:ab0:308c:: with SMTP id h12mr2232235ual.72.1561641432229;
 Thu, 27 Jun 2019 06:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com> <20190626121943.131390-2-glider@google.com>
 <20190626162835.0947684d36ef01639f969232@linux-foundation.org>
In-Reply-To: <20190626162835.0947684d36ef01639f969232@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 27 Jun 2019 15:17:00 +0200
Message-ID: <CAG_fn=WM_x9wUQNCwGB7BnKJqSpTMZGcf1Jxae-PHij8E9igjg@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, 
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

On Thu, Jun 27, 2019 at 1:28 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Wed, 26 Jun 2019 14:19:42 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> >  v8:
> >   - addressed comments by Michal Hocko: revert kernel/kexec_core.c and
> >     apply initialization in dma_pool_free()
> >   - disable init_on_alloc/init_on_free if slab poisoning or page
> >     poisoning are enabled, as requested by Qian Cai
> >   - skip the redzone when initializing a freed heap object, as requeste=
d
> >     by Qian Cai and Kees Cook
> >   - use s->offset to address the freeptr (suggested by Kees Cook)
> >   - updated the patch description, added Signed-off-by: tag
>
> v8 failed to incorporate
>
> https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_a=
lloc=3D1-and-init_on_free=3D1-boot-options-fix.patch
> and
> https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_a=
lloc=3D1-and-init_on_free=3D1-boot-options-fix-2.patch
>
> it's conventional to incorporate such fixes when preparing a new
> version of a patch.
>
v9 contains these patches (I've also exported init_on_free), so should
now be fine to drop them.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
