Return-Path: <SRS0=UCTB=3J=lists.openwall.com=kernel-hardening-return-17601-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C736C32771
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 22:52:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D068F22522
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 22:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="epC64Lfh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D068F22522
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17601-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31862 invoked by uid 550); 20 Jan 2020 22:52:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31819 invoked from network); 20 Jan 2020 22:52:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=w0zMfmjniH4zzHcGVzEyuTowhv2zMpn6uusMDHHpzZQ=;
        b=epC64LfhOt/+j38AGGJ1UuLq2UW9B2CyXRfcRTnaw89Udb+rexQXQ2/Z4fMSoOdT2U
         XJdh1SLFUcFFV/GO8+Hlec1oIA2TQ/t9/OWFpd74VQJvaWow/SOWQhIXJuzCgB8LUJJp
         bIe4XKDP0CmPZVDAn+zcRNZM9AdpE44Lt4eVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=w0zMfmjniH4zzHcGVzEyuTowhv2zMpn6uusMDHHpzZQ=;
        b=fCgIeDxkjAsJi3RSuPZPQcB+hUQ2KC9NinOvnEhWNlU0twrjuFP35dPp6l+QUZacz/
         +EUxJcPL6tspIpoVt2OJvQNBA6Yu2b6z4Po1Esu5P6ZTA9EArw5IJsLyNrHVaVx/VoiR
         gMHRDCu0vfaoOMPYg3Tn5YmmripB4+LqPq/rlRAk6qPN9XeTY3fzxU3R5HZ66JWEhwsU
         IccSgaUVeH8BBKYTWolUDBkPBR46pZM6fgidy5c8najh9ES2W+OnRLJsUCyLUEtZFOuA
         6hvzx2bwwNfKN4+Rg76knzKmfWkyTyQR0QY31hdSsa2U9Q1Un5jmaG5K/eA32WnLu+cY
         l2Uw==
X-Gm-Message-State: APjAAAWPDlrpiWMTJaBDJePtJZKfKHYnsAAUlxK+crwmkqKBDHq+SUiN
	oDNd0SlFPQAuJytTMMF3cwPKxw==
X-Google-Smtp-Source: APXvYqy/1x59yiJFYrOMghpFcNNE55t7k7m33lxIBZKtqS7BILoXWoJW6mXDP21Ecj+V3cPxMWr44Q==
X-Received: by 2002:a17:902:fe17:: with SMTP id g23mr2190434plj.42.1579560717171;
        Mon, 20 Jan 2020 14:51:57 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: Michal Hocko <mhocko@kernel.org>
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org, keescook@chromium.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/5] [VERY RFC] mm: kmalloc(_node): return NULL immediately for SIZE_MAX
In-Reply-To: <20200120111411.GX18451@dhcp22.suse.cz>
References: <20200120074344.504-1-dja@axtens.net> <20200120074344.504-5-dja@axtens.net> <20200120111411.GX18451@dhcp22.suse.cz>
Date: Tue, 21 Jan 2020 09:51:52 +1100
Message-ID: <87pnfdkagn.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Michal,

>> For example, struct_size(struct, array member, array elements) returns t=
he
>> size of a structure that has an array as the last element, containing a
>> given number of elements, or SIZE_MAX on overflow.
>>=20
>> However, struct_size operates in (arguably) unintuitive ways at compile =
time.
>> Consider the following snippet:
>>=20
>> struct foo {
>> 	int a;
>> 	int b[0];
>> };
>>=20
>> struct foo *alloc_foo(int elems)
>> {
>> 	struct foo *result;
>> 	size_t size =3D struct_size(result, b, elems);
>> 	if (__builtin_constant_p(size)) {
>> 		BUILD_BUG_ON(size =3D=3D SIZE_MAX);
>> 	}
>> 	result =3D kmalloc(size, GFP_KERNEL);
>> 	return result;
>> }
>>=20
>> I expected that size would only be constant if alloc_foo() was called
>> within that translation unit with a constant number of elements, and the
>> compiler had decided to inline it. I'd therefore expect that 'size' is o=
nly
>> SIZE_MAX if the constant provided was a huge number.
>>=20
>> However, instead, this function hits the BUILD_BUG_ON, even if never
>> called.
>>=20
>> include/linux/compiler.h:394:38: error: call to =E2=80=98__compiletime_a=
ssert_32=E2=80=99 declared with attribute error: BUILD_BUG_ON failed: size =
=3D=3D SIZE_MAX
>
> This sounds more like a bug to me. Have you tried to talk to compiler
> guys?

You're now the second person to suggest this to me, so I will do that
today.

>> This is with gcc 9.2.1, and I've also observed it with an gcc 8 series
>> compiler.
>>=20
>> My best explanation of this is:
>>=20
>>  - elems is a signed int, so a small negative number will become a very
>>    large unsigned number when cast to a size_t, leading to overflow.
>>=20
>>  - Then, the only way in which size can be a constant is if we hit the
>>    overflow case, in which 'size' will be 'SIZE_MAX'.
>>=20
>>  - So the compiler takes that value into the body of the if statement and
>>    blows up.
>>=20
>> But I could be totally wrong.
>>=20
>> Anyway, this is relevant to slab.h because kmalloc() and kmalloc_node()
>> check if the supplied size is a constant and take a faster path if so. A
>> number of callers of those functions use struct_size to determine the si=
ze
>> of a memory allocation. Therefore, at compile time, those functions will=
 go
>> down the constant path, specialising for the overflow case.
>>=20
>> When my next patch is applied, gcc will then throw a warning any time
>> kmalloc_large could be called with a SIZE_MAX size, as gcc deems SIZE_MAX
>> to be too big an allocation.
>>=20
>> So, make functions that check __builtin_constant_p check also against
>> SIZE_MAX in the constant path, and immediately return NULL if we hit it.
>
> I am not sure I am happy about an additional conditional path in the hot
> path of the allocator. Especially when we already have a check for
> KMALLOC_MAX_CACHE_SIZE.

It is guarded by __builtin_constant_p in both cases, so it should not
cause an additional runtime branch. But I'll check in with our friendly
local compiler folks and see where that leads first.

Regards,
Daniel

> --=20
> Michal Hocko
> SUSE Labs
