Return-Path: <SRS0=SnUw=AT=lists.openwall.com=kernel-hardening-return-19253-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A09BC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 08:59:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F0592220C
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 08:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0592220C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19253-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30152 invoked by uid 550); 8 Jul 2020 08:59:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30117 invoked from network); 8 Jul 2020 08:59:18 -0000
X-Gm-Message-State: AOAM533EDTlWhEMjNTgTofhSM42bNcHW1KuzYgZk97ITAwBo0pxQmUyi
	x65jDD/9MU9CnKtwh9PZ/DCxB/rAjX2oAfC7KFw=
X-Google-Smtp-Source: ABdhPJzLaMHmQ+d0DaK1+93L/dR3MzlE080J2I9IddvGS9yPpAL+dL55hLQlLBZanWkIYCvrPgtE5STzlyI22smNJzI=
X-Received: by 2002:a05:620a:1654:: with SMTP id c20mr49067426qko.138.1594198745401;
 Wed, 08 Jul 2020 01:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-10-mic@digikod.net>
 <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com>
 <8d2dab03-289e-2872-db66-ce80ce5c189f@digikod.net> <CAK8P3a3Mf_+-MY5kdeY7sqwUgCUi=PksWz1pGDy+o0ZfgF93Zw@mail.gmail.com>
 <956a05c8-529b-bf97-99ac-8958cceb35f3@digikod.net>
In-Reply-To: <956a05c8-529b-bf97-99ac-8958cceb35f3@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 8 Jul 2020 10:58:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0RKEb0jcisgaXVd6wJU6GaEsDAJp+jDFyJBdMPDE__ZQ@mail.gmail.com>
Message-ID: <CAK8P3a0RKEb0jcisgaXVd6wJU6GaEsDAJp+jDFyJBdMPDE__ZQ@mail.gmail.com>
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
X-Provags-ID: V03:K1:dCZwDsQ38R7qsBVvIyf1CNxALNwgUsmmvbey30LG5iIqDysIR0O
 rUsLMDTAViKaK5b1sHWRKYwX7AEZDLAMVXTtanMB77uaSVksO7bXe9co1euEiEybksS78IH
 JcBu5KArlPfHZfQiFZjDoyxDy09x1uB5glfntavPFi4qSxj/RsDXIJ1GSR4TvM5PTU9J52Q
 F9dr2gvSxB6QF6LTUJLuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZM7SaRzQOGI=:Y1Uq08jHM1LWlsH7ZDdy8i
 EdzQxDBltjnbzgeBAjj1/Mi1ctKV1oTJdZCiVmqDneJZsdAbFPSoC4AJpXL42QToPLImmORZx
 yYcz8AMUl1TGeLovrd/ESeDupQ8tv18aI08Lg9O6RSksZx4IJG0i4L0G9XTERBvHezB8jpJ78
 BuBzDVG/h/Rt7IKr7SpRbb5wiQahXnDAJsqmjDJmR4pbH+B0ZYDOTeTuzRNsU8BCEcN8sDjIO
 SS2JSwZFk3HWDYxyCBoh/+uSL080gUCghaPnTwrND/DAs4UmuytTQrU6nmT+COl/oQ13e1DML
 8H3WsO2SIvllpv2mtSrq6wZAdLfZxwClOfLHohWGZ/6ZNBGqEfNe2ZYtrJlbFbTNtzTRrFqTV
 tf6EDv5TZXQInOnZdFBt/3KqPzEOziNJV7KNvd55bWw6mhixjzWST6dEnQSEivvvC7n3I3pWZ
 L787jsKlwJ+pwOgxLPm4SFpkHi+sS+ta6meiOzSabFj2dbvwK0czb6O6MKDwm6dFOqHzLeuhc
 MF5KtvJz53hkwRp+wYJHkpXeif18Si4ch/AA8fJJOod9sgEVFrVUabjQVWWqBBr/knA+GBd0p
 TQsrq64vkblfZG4Va7N6JsSqpd+R1ngavBKvAxS+WcKJcFqGmqepTrElEpWzZXLVkaOGIe/vO
 XD91my+Zg/UNQiS8YpUTSrGSQ0k5j0yxxr83Z5wV5K2Orml6ZURFFo1JbDSLyqCjRFW4a3MK3
 +jNEENxvK78pk1IPpCiCn+eRRNqHr8FUlmgSXq+Y+y790Eda8PuOQtE2R2GfttvHsVFhaj+KT
 ZdWibKU/AAVQrLN2fjsmhiw8pS3RLDjm6Qp1OYAOKmEe85LV74TYBR+WhdJ96R3WBmS5Bi7Rp
 lXaOMu5yKbmhbl7G4GUEbLYueqzG2oPhO0CDaLa/V8mLymZk0Ene5bc6KCeYqa9u+impFHBip
 dd0EWANaOiOICyDiI4K6Zt+5kFzbj/lYao14S56HncAk2LJFX8zAA

On Wed, Jul 8, 2020 at 10:23 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 08/07/2020 09:47, Arnd Bergmann wrote:
> > On Wed, Jul 8, 2020 at 9:31 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >> On 08/07/2020 09:22, Arnd Bergmann wrote:
> >>> On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
> >>>
> >>>> index f4a01305d9a6..a63a411a74d5 100644
> >>>> --- a/include/uapi/asm-generic/unistd.h
> >>>> +++ b/include/uapi/asm-generic/unistd.h
> >>
> >> OK, I'll rebase the next series on linux-next.
> >
> > Just change the number to the next free one, without actually rebasing.
> > It's always a bit messy to have multiple syscalls added, but I think th=
at
> > causes the least confusion.
>
> OK, but this will lead to two merge conflicts: patch 8 (asmlinkage) and
> patch 9 (tbl files).

Yes, there isn't really much one can do about that.

> Do you want me to update the tools/perf/arch/*.tbl too?

No, I would leave them unchanged.

     Arnd
