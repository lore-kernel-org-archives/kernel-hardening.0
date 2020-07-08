Return-Path: <SRS0=HeIL=AT=lists.openwall.com=kernel-hardening-return-19248-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C29C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:23:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D8BC20771
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D8BC20771
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19248-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25775 invoked by uid 550); 8 Jul 2020 07:23:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25737 invoked from network); 8 Jul 2020 07:23:08 -0000
X-Gm-Message-State: AOAM531frzPlL+5U4yDzmHmkl8d+3t5q02RlQzgb0Qrxu7S2z4I5bfOm
	JdJ1Ez80Aj802XjuV2iLPJ2hHl3EEEl9pcpNY2k=
X-Google-Smtp-Source: ABdhPJwUBcG/1BpiC+qdY+LuFzWvg9XDNkC9mO5dIZPmuPnsoF/bIile11NCgXsXdn50Udu/UrGJ9q4uKoPO8k6xQnA=
X-Received: by 2002:a05:620a:1654:: with SMTP id c20mr48812583qko.138.1594192975528;
 Wed, 08 Jul 2020 00:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-10-mic@digikod.net>
In-Reply-To: <20200707180955.53024-10-mic@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 8 Jul 2020 09:22:39 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com>
Message-ID: <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com>
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
X-Provags-ID: V03:K1:ZkpT9mPoFqnUsxY6Dd4Mgew6P79u/cG4YhReoEMTLsFfE5nHpv0
 wif4DLgsfYMnY8BBVecBW9u1DJ9MCTWRaasLlR237VzRYgLL12iNTI4hOoPUmtyYEAS3u7I
 jckBzpDAq+Ifp4uW19jXQ2iCnxY6DGZE11ewjlPBjgWYQKUb0IJYj5BE7eRVVPnpljHbczE
 JGt94HcTx5WMk4OvV8low==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kkygn4MIoNU=:5Ou6JEItSwlNGRu3Y6838B
 sDr859AbUQry3pja4Q0wBqjCbd+/9nLOz+4nJFWXrVQVxCmgljvRLi9LVf/Vhud0RkVsi7e7a
 4gyD2n7jJkm8e5JcT/yUzGBdeEkDd8/RR6eb6acLyvLHfuaBstDI4+lnEMqTbAUc1uc/MJIei
 jlndPhVG0KRHEbYs3ZpPxYAkIecpEAwDXt3g2Gis4kY5cUDqX+knNTDBf5gC9R5nMq1bPuD0A
 fc945zacVrN9drUro6mUwgoJVVBicBVXQFiEPNP2XbPjHzXLVeTkffGXZ4QL3l5wEug8smL10
 dBvbn9XI6y8Zxb4j8r6bx6JApEh4rY3afL9fcgFriBYHFaTexuqZXYR3tAb3kAuSKHVB+MOJo
 /IwC8aHtM+jUjKukIWWC8cVp8Foz1XCFPs1l1UGpN4Bz3vErAhU2fP6vjQdkVaY3ZA1na2L4i
 i5pYkiJNgEqlU3aWYso41bwurHMxLQY4OkcWZ1HRLyFT/IkBFkX6eYc4DzuCccdCR7SRa0XtU
 SqdmaWKRTRtSwfiVn4Xz2NOCSg3IU0DM4yjnzZmCW0BV+6LH+grsnWUVYZ1850Itn+oqVTJQo
 AP1/KH0xdn/DS+bbK4W4VHxt+9gxssZn+iXFfmFPrqdc8GQrJuqUZkchXoghN3cGvpISVlCKs
 zEqHNymRbz8ypNDCkjhqtV0h+06l1SQ2gep/kihgNQODr/0oQ5Ky71jrIws9hNRYeH4+cDTkF
 niOBbwju66G4CSy5c/GVAWpjEp0yQJwln5Ejk+7ADlmnLi2UX8rPwK75bbalCPLP59RRaOJjq
 JkDxa6GoAhvpTG2D4EThVEGhnR2kxcbrKYJ19aUHCigGfJuE+F08mG7rjgB5fQWCZ5bwHTlut
 aHPNmVseRWx05lt9Tr3OGjLYuJu3lANJayHwxezgrIaqks/8zho9jU1hZoA8MMQQurfcLmrVz
 Fd6VVM31zEIHEQS4w7bSRRRuywKXbOQiod0jJpwqRka93lbjmm2Tb

On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:

> index f4a01305d9a6..a63a411a74d5 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -857,9 +857,11 @@ __SYSCALL(__NR_openat2, sys_openat2)
>  __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
>  #define __NR_faccessat2 439
>  __SYSCALL(__NR_faccessat2, sys_faccessat2)
> +#define __NR_landlock 440
> +__SYSCALL(__NR_landlock, sys_landlock)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 440
> +#define __NR_syscalls 441

In linux-next, we already have:

+#define __NR_watch_mount 440
+#define __NR_watch_sb 441
+#define __NR_fsinfo 442
+#define __NR_process_madvise 443

You may want to increase the number again.

      Arnd
