Return-Path: <SRS0=upLr=LT=lists.openwall.com=kernel-hardening-return-21317-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E22C2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 04:09:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D03C6613FD
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 04:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D03C6613FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21317-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5504 invoked by uid 550); 25 Jun 2021 04:09:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5465 invoked from network); 25 Jun 2021 04:09:08 -0000
Date: Fri, 25 Jun 2021 00:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 ying.xue@windriver.com, ps-ccm-rr@windriver.com
Subject: Re: [PATCH] seq_buf: let seq_buf_putmem_hex support len larger than
 8
Message-ID: <20210625000854.36ed6f2d@gandalf.local.home>
In-Reply-To: <32276a16-b893-bdbb-e552-7f5ecaaec5f1@windriver.com>
References: <20210624131646.17878-1-yun.zhou@windriver.com>
	<20210624105422.5c8aaf4d@oasis.local.home>
	<32276a16-b893-bdbb-e552-7f5ecaaec5f1@windriver.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jun 2021 11:41:35 +0800
Yun Zhou <yun.zhou@windriver.com> wrote:

> Hi Steve,
>=20
> Thanks very much for your friendly and clear feedback.
>=20
> Although in current kernel trace_seq_putmem_hex() is only used for=20
> single word,
>=20
> I think it should/need support longer data. These are my arguments:
>=20
> 1. The design of double loop is used to process more data. If only=20
> supports single word,
>=20
>  =C2=A0=C2=A0=C2=A0 the inner loop is enough, and the outer loop and the =
following=20
> lines are no longer needed.
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len -=3D j / 2;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hex[j++] =3D ' ';
>=20
> 2. The last line above try to split two words/dwords with space. If only=
=20
> supports single word,
>=20
>  =C2=A0=C2=A0=C2=A0 this strange behavior is hard to understand.
>=20
> 3. If it only supports single word, I think parameter 'len' is redundant.

Not really, we have to differentiate char, short, int and long long.

>=20
> 4. The comments of both seq_buf_putmem_hex() and trace_seq_putmem_hex()=20
> have not
>=20
>  =C2=A0=C2=A0=C2=A0 indicated the scope of 'len'.
>=20
> 5. If it only supports single word, we need to design a new function to=20
> support bigger block of data.
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 I think it is redundant since the current funct=
ion can perfectly=20
> deal with.
>=20
> 6. If follow my patch, it can support any length of data, including the=20
> single word.
>=20
> How do you think?

First, since you found a real bug, we need to just fix that first (single
word as is done currently). Because this needs to go to stable, and what
you are explaining above is an enhancement, and not something that needs to
be backported.

Second, is there a use case? Honestly, I never use the "hex" version of the
output. That was only pulled in because it was implemented in the original
code that was in the rt patch. I wish we could just get rid of it.

Thus, if there's a use case for handling more than one word, then I'm fine
with adding that enhancement. But if it is being done just because it can
be, then I don't think we should bother.

What use case do you have in mind?

Anyway, please send just a fix patch, and then we can discuss the merits of
this update later. I'd like the fix to be in ASAP.

Thanks!

-- Steve
