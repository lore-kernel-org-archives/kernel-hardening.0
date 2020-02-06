Return-Path: <SRS0=pFzL=32=lists.openwall.com=kernel-hardening-return-17684-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CD5C35247
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 01:11:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E2FD420730
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 01:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="PBOdW00h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2FD420730
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17684-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23810 invoked by uid 550); 6 Feb 2020 01:11:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23786 invoked from network); 6 Feb 2020 01:11:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=UCRNExBMsOtU0oIwXR+9QPpYzB1pJyX23z+yt89SIvY=;
        b=PBOdW00hNYnAcAtisWPDsTyLSlrwwxvZxMWOuXA0YlHRsasQYg9RukrWzd0xAbN71M
         Y5/ywedIcTrHkzZ8xduxdUAOUPohBbNuDN4RcXV5tHCaG9yMq5megx3AOrWhOVGn9NiE
         VNZNwNWKnH/8vgGOpOd0XCsdQyGFNL6FG3Rp4en7NzhWOXMbqW72j+kqCrcxrApuocg4
         mOJIATXNSrMrK4UtjtnxCv+pQSdj5IuLprfHhWXVZu3w7GmloEzSw/fCgmhReUX1NfsV
         iyY68eDUTiq11mZECSXeV39rmcDxV9goQIF3LjID6lnlpKC2+gBPICApqp0ZaHAukhRp
         266A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=UCRNExBMsOtU0oIwXR+9QPpYzB1pJyX23z+yt89SIvY=;
        b=TCtf+yrmsanOrq+EOZvqmkNIhLeNkuJDpFY07j1v4kd3TCuU2cUkZq1Um3KScQVq1P
         1ZuiMUoSObtZuDAg7Jf4E/fsI6TfIZgimgFuAJpNQ/hwA40bIsSqqOW+tv/Ua+OLzemd
         RDyp0hikQOBBPASU0zTcHNM4TdQPzHL+PH3LHY8MQn+wyzao5NamFkoqBnbZRj+wCp3L
         4cvOyEVYF1cUakUjC8RSG97qBLAkCah7YkiiySHvL6VkcsOtKeMzSdGkGW95Mg9D5xVg
         1S2+xQIseTwMbI1sOO4eUd/9Dfy4iX64FOtLW5Fzbr5qF/yAujZveuCbOb9bU9yt/x0T
         WdGQ==
X-Gm-Message-State: APjAAAViHP0y+mOP3ZRE086+XtSJrbPSIQTiVYP2P/neMy0y/QV6eV2M
	yPmjvXBCIL+t7i38CkJ1auiCgw==
X-Google-Smtp-Source: APXvYqxQvt7onbyWIXPZYbJ9Zk+iEscpiHVrXWuXQiKpT3YA3gTmCCRuY3uJDiZBJhFpTTirzeNztg==
X-Received: by 2002:a63:3487:: with SMTP id b129mr787103pga.320.1580951473379;
        Wed, 05 Feb 2020 17:11:13 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 04/11] x86/boot/KASLR: Introduce PRNG for faster shuffling
Date: Wed, 5 Feb 2020 17:11:11 -0800
Message-Id: <487F8A1B-3FBC-4A0E-B6EC-5FE0F70D18DD@amacapital.net>
References: <20200205223950.1212394-5-kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 arjan@linux.intel.com, keescook@chromium.org, rick.p.edgecombe@intel.com,
 x86@kernel.org, linux-kernel@vger.kernel.org,
 kernel-hardening@lists.openwall.com
In-Reply-To: <20200205223950.1212394-5-kristen@linux.intel.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
X-Mailer: iPhone Mail (17C54)



> On Feb 5, 2020, at 2:39 PM, Kristen Carlson Accardi <kristen@linux.intel.c=
om> wrote:
>=20
> =EF=BB=BFFrom: Kees Cook <keescook@chromium.org>
>=20
> This *might* improve shuffling speed at boot. Possibly only marginally.
> This has not yet been tested, and would need to have some performance
> tests run to determine if it helps before merging.

Ugh, don=E2=80=99t do this. Use a real DRBG.  Someone is going to break the c=
onstruction in your patch just to prove they can.

ChaCha20 is a good bet.

>=20
> (notes from Kristen) - initial performance tests suggest that any
> improvement is indeed marginal. However, this code is useful
> for using a known seed.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
> arch/x86/boot/compressed/kaslr.c |  4 +--
> arch/x86/include/asm/kaslr.h     |  3 +-
> arch/x86/lib/kaslr.c             | 50 +++++++++++++++++++++++++++++++-
> arch/x86/mm/init.c               |  2 +-
> arch/x86/mm/kaslr.c              |  2 +-
> 5 files changed, 55 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/k=
aslr.c
> index d7408af55738..ae4dce76a9bd 100644
> --- a/arch/x86/boot/compressed/kaslr.c
> +++ b/arch/x86/boot/compressed/kaslr.c
> @@ -598,7 +598,7 @@ static unsigned long slots_fetch_random(void)
>    if (slot_max =3D=3D 0)
>        return 0;
>=20
> -    slot =3D kaslr_get_random_long("Physical") % slot_max;
> +    slot =3D kaslr_get_random_seed("Physical") % slot_max;
>=20
>    for (i =3D 0; i < slot_area_index; i++) {
>        if (slot >=3D slot_areas[i].num) {
> @@ -880,7 +880,7 @@ static unsigned long find_random_virt_addr(unsigned lo=
ng minimum,
>    slots =3D (KERNEL_IMAGE_SIZE - minimum - image_size) /
>         CONFIG_PHYSICAL_ALIGN + 1;
>=20
> -    random_addr =3D kaslr_get_random_long("Virtual") % slots;
> +    random_addr =3D kaslr_get_random_seed("Virtual") % slots;
>=20
>    return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
> }
> diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
> index db7ba2feb947..47d5b25e5b11 100644
> --- a/arch/x86/include/asm/kaslr.h
> +++ b/arch/x86/include/asm/kaslr.h
> @@ -2,7 +2,8 @@
> #ifndef _ASM_KASLR_H_
> #define _ASM_KASLR_H_
>=20
> -unsigned long kaslr_get_random_long(const char *purpose);
> +unsigned long kaslr_get_random_seed(const char *purpose);
> +unsigned long kaslr_get_prandom_long(void);
>=20
> #ifdef CONFIG_RANDOMIZE_MEMORY
> void kernel_randomize_memory(void);
> diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
> index 2b3eb8c948a3..41b5610855a3 100644
> --- a/arch/x86/lib/kaslr.c
> +++ b/arch/x86/lib/kaslr.c
> @@ -46,7 +46,7 @@ static inline u16 i8254(void)
>    return timer;
> }
>=20
> -unsigned long kaslr_get_random_long(const char *purpose)
> +unsigned long kaslr_get_random_seed(const char *purpose)
> {
> #ifdef CONFIG_X86_64
>    const unsigned long mix_const =3D 0x5d6008cbf3848dd3UL;
> @@ -96,3 +96,51 @@ unsigned long kaslr_get_random_long(const char *purpose=
)
>=20
>    return random;
> }
> +
> +/*
> + * 64bit variant of Bob Jenkins' public domain PRNG
> + * 256 bits of internal state
> + */
> +struct prng_state {
> +    u64 a, b, c, d;
> +};
> +
> +static struct prng_state state;
> +static bool initialized;
> +
> +#define rot(x, k) (((x)<<(k))|((x)>>(64-(k))))
> +static u64 prng_u64(struct prng_state *x)
> +{
> +    u64 e;
> +
> +    e =3D x->a - rot(x->b, 7);
> +    x->a =3D x->b ^ rot(x->c, 13);
> +    x->b =3D x->c + rot(x->d, 37);
> +    x->c =3D x->d + e;
> +    x->d =3D e + x->a;
> +
> +    return x->d;
> +}
> +
> +static void prng_init(struct prng_state *state)
> +{
> +    int i;
> +
> +    state->a =3D kaslr_get_random_seed(NULL);
> +    state->b =3D kaslr_get_random_seed(NULL);
> +    state->c =3D kaslr_get_random_seed(NULL);
> +    state->d =3D kaslr_get_random_seed(NULL);
> +
> +    for (i =3D 0; i < 30; ++i)
> +        (void)prng_u64(state);
> +
> +    initialized =3D true;
> +}
> +
> +unsigned long kaslr_get_prandom_long(void)
> +{
> +    if (!initialized)
> +        prng_init(&state);
> +
> +    return prng_u64(&state);
> +}
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e7bb483557c9..c974dbab2293 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -722,7 +722,7 @@ void __init poking_init(void)
>     */
>    poking_addr =3D TASK_UNMAPPED_BASE;
>    if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
> -        poking_addr +=3D (kaslr_get_random_long("Poking") & PAGE_MASK) %
> +        poking_addr +=3D (kaslr_get_random_seed("Poking") & PAGE_MASK) %
>            (TASK_SIZE - TASK_UNMAPPED_BASE - 3 * PAGE_SIZE);
>=20
>    if (((poking_addr + PAGE_SIZE) & ~PMD_MASK) =3D=3D 0)
> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
> index dc6182eecefa..b30bd1db7543 100644
> --- a/arch/x86/mm/kaslr.c
> +++ b/arch/x86/mm/kaslr.c
> @@ -123,7 +123,7 @@ void __init kernel_randomize_memory(void)
>    for (i =3D 0; i < ARRAY_SIZE(kaslr_regions); i++)
>        remain_entropy -=3D get_padding(&kaslr_regions[i]);
>=20
> -    prandom_seed_state(&rand_state, kaslr_get_random_long("Memory"));
> +    prandom_seed_state(&rand_state, kaslr_get_random_seed("Memory"));
>=20
>    for (i =3D 0; i < ARRAY_SIZE(kaslr_regions); i++) {
>        unsigned long entropy;
> --=20
> 2.24.1
>=20
