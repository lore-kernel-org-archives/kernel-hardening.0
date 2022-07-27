Return-Path: <kernel-hardening-return-21570-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1A76DC19F2B
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Jul 2022 16:31:56 +0000 (UTC)
Received: (qmail 11818 invoked by uid 550); 27 Jul 2022 16:31:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11798 invoked from network); 27 Jul 2022 16:31:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HLpauEQ5M+lWRIlS3PcwqsZWVTFiAvj2+32FpHGOhBk=;
        b=klS/6ZXoSeM0uv5HT7/w1pRROtMu2SFyiAGZpuVTlKfCMmZO+NVgryshOQKXZ3mRwO
         aCapBXgciK6e8ZLoA0VmgIdcFIShZvj3yTsNZAVCWrgAfnyA1QH0nmrIVsxq906pdmc0
         hmwXJXpwp0IwAbDiWt5D++aDEST91D1pWaKsHwWFDLX494ZYqaluBT3sHd8k0UTlRBI2
         jEfCfG3Cu4m+fuqo+JGBOr/N1asAZoHTfyfmGqch2N4qoAxdB4As1OnAQTKzEjYhm7vg
         3XTBjSn/35ULRdJL1A6mahAfA9wsliZ8gk/LfZ5hmyy9h93oqA8sg161qx782ugJASrw
         dWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLpauEQ5M+lWRIlS3PcwqsZWVTFiAvj2+32FpHGOhBk=;
        b=sWRihaJdPKKTSXQgjkm1d3SHniItMBSnJ+scOsNvcreo1SvsdY659rfLMX8YMyCx9R
         GbFR8mn30844IiTN4z/OVRSVt6Jhp1yAoP7E+jJljOmU/N1ScuDJ0Nda0Kkh2DCdzBUB
         0EGubRPdmstGQNj+umDdCNy/XC/zUR3vqB3agapqgaJdoAEj0oFB+VGoqV6uQvAqF7gX
         +0HP6h7or7DgsdWnwgJzx1+MmE65fNorqq30yfnjAZCUUqXLKyw4fSsBvO8EiNDlw7hm
         kxKduAOS2q7u690nThR62/2ZLNyYPnL/Me2PRTIJme8vw3NetYmaiCUOWEDLPHtlGus9
         55yQ==
X-Gm-Message-State: AJIora+/7+GuVNZ8VB2Cq7zVNdi4ktqK/vvwhkD4HSbd5BE4fLO6fYRK
	XZ/vwCrRyDpa6Zu4GHxZNF2Ee9eqPotSzd+xe3laoA==
X-Google-Smtp-Source: AGRyM1vzxJdX05n48cDiHKWT4UyZZ4xthB7HHUEb5MIzbitr5xn078iGRk5ZiOqwPRiIpO312Lx7K0+ksI9j1fyn3gg=
X-Received: by 2002:a02:a68c:0:b0:33f:46d4:918e with SMTP id
 j12-20020a02a68c000000b0033f46d4918emr8580458jam.58.1658939495323; Wed, 27
 Jul 2022 09:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210929185823.499268-1-alex.popov@linux.com> <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
 <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com> <7c567acd-1cc1-a480-ca5a-d50a9c5a69ef@ispras.ru>
In-Reply-To: <7c567acd-1cc1-a480-ca5a-d50a9c5a69ef@ispras.ru>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Jul 2022 18:30:59 +0200
Message-ID: <CAG48ez2Sh-kngNVeCF9-X550PQMaNnQaEvS+EAiWaDjWnmoHOg@mail.gmail.com>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Popov <alex.popov@linux.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, 
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>, 
	Muchun Song <songmuchun@bytedance.com>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Garnier <thgarnie@google.com>, 
	Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Laura Abbott <labbott@redhat.com>, David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 27, 2022 at 6:17 PM Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> On 01.10.2021 22:59, Linus Torvalds wrote:
> Coming back to the discussion of WARN_ON()/pr_warn("WARNING:") semantics.
>
> We see a number of cases where WARNING is used to inform userspace that
> it is doing something wrong, e.g.
> https://elixir.bootlin.com/linux/v5.19-rc8/source/net/can/j1939/socket.c#L181
> https://elixir.bootlin.com/linux/v5.19-rc8/source/drivers/video/fbdev/core/fbmem.c#L1023
>
> It is definitely useful, but it does not make sense in case of fuzzing
> when the userspace should do wrong things and check if kernel behaves
> correctly.
>
> As a result we have warnings with two different intentions:
> - warn that something wrong happens in kernel, but we are able to continue;
> - warn userspace that it is doing something wrong.
>
> During fuzzing we would like to report the former and to ignore the
> latter. Are any ideas how these intentions can be recognized automatically?

https://elixir.bootlin.com/linux/v5.19-rc8/source/include/asm-generic/bug.h#L74
says:

 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
 * significant kernel issues that need prompt attention if they should ever
 * appear at runtime.
 *
 * Do not use these macros when checking for invalid external inputs
 * (e.g. invalid system call arguments, or invalid data coming from
 * network/devices), and on transient conditions like ENOMEM or EAGAIN.
 * These macros should be used for recoverable kernel issues only.
 * For invalid external inputs, transient conditions, etc use
 * pr_err[_once/_ratelimited]() followed by dump_stack(), if necessary.
 * Do not include "BUG"/"WARNING" in format strings manually to make these
 * conditions distinguishable from kernel issues.

So if you see drivers intentionally using WARN() or printing
"WARNING:" on codepaths that are reachable with bogus inputs from
userspace, those codepaths should be fixed to log warnings in a
different format.
