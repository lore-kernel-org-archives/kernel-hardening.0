Return-Path: <SRS0=Ngfw=AT=lists.openwall.com=kernel-hardening-return-19250-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE8AC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:48:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9674A20739
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9674A20739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19250-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11360 invoked by uid 550); 8 Jul 2020 07:48:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11325 invoked from network); 8 Jul 2020 07:48:02 -0000
X-Gm-Message-State: AOAM531kTteo0BDsHoomve+24KhuTO+fpfo81AJLc+k+vqhamvQkVJYx
	ffpd8BRZXwiJn+h7GOdTJCR8/Vb/cal4V1LKdB8=
X-Google-Smtp-Source: ABdhPJwJ7bU/Pv3kW4ZV6dqofAWrDLTCi8XHvPobkRXOzurHnagr3TngzbBTEHTIVieA5Q2mcy/tSnvloWa3hIIuPE8=
X-Received: by 2002:ac8:7587:: with SMTP id s7mr58818246qtq.304.1594194469018;
 Wed, 08 Jul 2020 00:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-10-mic@digikod.net>
 <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com> <8d2dab03-289e-2872-db66-ce80ce5c189f@digikod.net>
In-Reply-To: <8d2dab03-289e-2872-db66-ce80ce5c189f@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 8 Jul 2020 09:47:33 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Mf_+-MY5kdeY7sqwUgCUi=PksWz1pGDy+o0ZfgF93Zw@mail.gmail.com>
Message-ID: <CAK8P3a3Mf_+-MY5kdeY7sqwUgCUi=PksWz1pGDy+o0ZfgF93Zw@mail.gmail.com>
Subject: Re: [PATCH v19 09/12] arch: Wire up landlock() syscall
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, 
	Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WQJn0CovH0y0bqmHHVI7VMTq/adcTNOXZuj58zrlgGwUN0dXOIi
 gxhmV4LIl9S1Wzcq62TL12kuYqj1PXjGN5KTrxexJaF+UR243XUG1y8pwt7pu7GC9NRsPxs
 rpyUVsTPk9sMNZjI5+SLeo1IYk6iDShY8btHtgom/ZQ7pdjz/AG9XJ/U8Jyauw56+FJXD6W
 g2FlfTX0ImoS6pt8fi+5Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OgTAkc0JqcY=:3u9A7pzkKRKMIbamBnAqd7
 kPrRK14XGNOyhbY5wNp9OXv6uZ7cVZvfBGd1cIydzhPM5u4332Kd5aQ+On8gE3E5jALaRMpld
 Xln70UfOZvQQi5ZzyXenDBMExRLK6oDSoLWv/teQcOsr/4KJLh7FMysWil3SN6Y/h+CRkxT5R
 Lz/aWFdSSrBApoKrP7ygDpsGR1022tEM7qVaFL+z92ZCp4o5uHScc4g9x20yNbTwf2QWRUah2
 IPVNUZv+9YREZllucK6+gC9aq4/10pXoP62WRPDSlARvvDfzo5Skny/yPRB64iJ6Jnv8XjZtf
 qXqZtNjrcQ4xjpIwlqoBLNkKNJ8mLeSV8U5dZrFsxA8Wc3AxN0oDPq2sSyU7S1VW9abBzWZTA
 e7xiK69Zo7OXiqER0pazddCwHj+iyDRymeJ1JZv0yoC5jYAHl/PyencolVDjXFJ3Nen/AKITn
 iQpoPaCD/lUgU9dGiXYcRpoOQiHtzrFJGE0n0VO4XYgEd2YH4NRLtqUlvzqzCGY1iPuYtU1Ym
 09n/uraCeQXuqApt6JhOJAkENAkJrt4/ZCxIMBBVADmsNZAAjCGg2YDSkMVh7RU+VwVs8HMcb
 Lxe083DW36ImatrhLZ8qUcSoEKn8WyfemZvn/kq+iKQEsHp+9DlFsfHKlox8cHq7aA75kFg5c
 IVAMVgEL7Q/uSSH2L4KBGYeqioQ0vEI0CbTDKgIR0E21B2LTE9uqWxXobaa1oV75Kb2OI2rR7
 r9ZqTAKB7BXOUUAXqCBFfSjXxqA+wy4+gkbbDw84errW9xcc838n9pZNIUCF9SHhGW7RQBERy
 YCK4pkxAnF4Lq6ILbF5vtuocJ++ZqADLWS/o36k5yelsMyBVwLnb5/hqwSaNgDvmSk6cykjsG
 JaUJTZUyKOKnKbdJz/cO/RSofiiJknzUiWQZ2AbZX13Dvz7abB0gQOyoh234UDenUEPhp+tgA
 n9Mh4BygTwWOiHVXs6TwkNpxZK4HJdLlAZei2cykb0px4oCKox4WD

On Wed, Jul 8, 2020 at 9:31 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:
> On 08/07/2020 09:22, Arnd Bergmann wrote:
> > On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >
> >> index f4a01305d9a6..a63a411a74d5 100644
> >> --- a/include/uapi/asm-generic/unistd.h
> >> +++ b/include/uapi/asm-generic/unistd.h
>
> OK, I'll rebase the next series on linux-next.

Just change the number to the next free one, without actually rebasing.
It's always a bit messy to have multiple syscalls added, but I think that
causes the least confusion.

> Do you know if there is other syscalls on their way to linux-next?

None that I'm aware of.

> Are the other parts of arch/syscall OK for you?

The arch/* and include/uapi/asm-generic changes look ok to me.
I'll reply to the syscall implementation separately/

     Arnd
