Return-Path: <kernel-hardening-return-21940-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 46749C0219B
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2025 02:16:58 +0000 (UTC)
Received: (qmail 3731 invoked by uid 550); 10 Feb 2025 02:16:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3706 invoked from network); 10 Feb 2025 02:16:46 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51A2Fa0Q1936056
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025011701; t=1739153739;
	bh=OonBsXVcqw16AkZT/JvRk7VH9bQnPgHVTelt+TYvzWs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Qc6GgwihV10i/7iazZlJA9de3OWWVwwezsmDbahCRSGSF/fy+K3tCR/3FaKyLCsei
	 rUt6+42N2gWeJe/slRPW4qi4hVCcnLwgbDbm/HqMCUuByHAFIeJuJSvaj022R+hRP4
	 xbNgbAWQQJiKjraN8//YXCHE3XSlmHczw7ylhpNz0JzGIguW9FRcUU2HlEL+WoTVyF
	 69oDbl/RiaKs3aPskzcedIu7tOhKjmDb/+5GYk+ol3XtOo6IWHTWQRYN7cngOMt5E9
	 uwa8JNmeidCmOCv2ODKFcJnWt2iVtYuNbaLcAN3jyw2OD3xHmG3jvlKx6W7JyqiR89
	 B74KZOx7gH4oA==
Date: Sun, 09 Feb 2025 18:15:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-arch@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
        "Paul E.McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 1/1] x86: In x86-64 barrier_nospec can always be lfence
User-Agent: K-9 Mail for Android
In-Reply-To: <15734b32cecddde7905d3a97005a0c883383cc74.camel@surriel.com>
References: <20250209191008.142153-1-david.laight.linux@gmail.com> <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com> <20250209214047.4552e806@pumpkin> <CAHk-=wiSnNEWsvDariBQ4O-mz7Nc7LbkdKUQntREVCFWiMe9zw@mail.gmail.com> <15734b32cecddde7905d3a97005a0c883383cc74.camel@surriel.com>
Message-ID: <119B5F1F-7319-4C28-8A91-EB570BF5ABEB@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On February 9, 2025 5:09:51 PM PST, Rik van Riel <riel@surriel=2Ecom> wrote=
:
>On Sun, 2025-02-09 at 13:57 -0800, Linus Torvalds wrote:
>>=20
>> So on x86, both read and write barriers are complete no-ops, because
>> all reads are ordered, and all writes are ordered=2E
>
>Given that this thread started with a reference
>to rdtsc, it may be worth keeping in mind that
>rdtsc reads themselves do not always appear to
>be ordered=2E
>
>Paul and I spotted some occasionaly "backwards
>TSC values" from the CSD lock instrumentation code,=C2=A0
>which went away when using ordered TSC reads:
>
>https://lkml=2Eiu=2Eedu/hypermail/linux/kernel/2410=2E1/03202=2Ehtml
>
>I guess maybe a TSC read does not follow all the same
>rules as a memory read, sometimes?
>

It probably doesn't, at least on uarches=2E
