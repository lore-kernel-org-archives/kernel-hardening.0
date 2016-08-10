Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2016 23:59:32 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <CAJZ5v0icnK4jBGkmHb7jJFEcusQyjJGYEG8yhOzMDa_hMQSj_w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1608102358320.22028@cbobk.fhfr.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <2010434.TyoHiO9eal@vostro.rjw.lan> <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm> <1779906.DOHeuFCiDy@vostro.rjw.lan> <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm>
 <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com> <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm> <20160810163500.GA9424@nazgul.tnic> <CAJZ5v0h_N5KvjUZjDDdoXMP3UoMmyYKOrHUpyGH14EYWMbxvPA@mail.gmail.com>
 <CAJZ5v0icnK4jBGkmHb7jJFEcusQyjJGYEG8yhOzMDa_hMQSj_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Thomas Garnier <thgarnie@google.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 10 Aug 2016, Rafael J. Wysocki wrote:

> So I used your .config to generate one for my test machine and with
> that I can reproduce.

Was that the config I've sent, or did Boris provide one as well? Which one 
are you able to reproduce with please?

> The hardware configuration doesn't matter, then, the issue is config-related.

How big is the diff between the two configs? Could you please share it?

Thanks,

-- 
Jiri Kosina
SUSE Labs
