Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0iAuDYZhmXqG12ZtEpQ5FEzP9Wp4a=EqApwwCc1VBvbLg@mail.gmail.com>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <2010434.TyoHiO9eal@vostro.rjw.lan>
 <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm> <1779906.DOHeuFCiDy@vostro.rjw.lan>
 <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm> <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
 <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm> <20160810163500.GA9424@nazgul.tnic>
 <CAJZ5v0h_N5KvjUZjDDdoXMP3UoMmyYKOrHUpyGH14EYWMbxvPA@mail.gmail.com>
 <CAJZ5v0icnK4jBGkmHb7jJFEcusQyjJGYEG8yhOzMDa_hMQSj_w@mail.gmail.com>
 <alpine.LNX.2.00.1608102358320.22028@cbobk.fhfr.pm> <CAJZ5v0iAuDYZhmXqG12ZtEpQ5FEzP9Wp4a=EqApwwCc1VBvbLg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 10 Aug 2016 18:17:06 -0700
Message-ID: <CAJcbSZGCL90OygKhSsox_xzQ0xmNV=Jv2WnVT8vEV7UcqgKWTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 5:35 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Wed, Aug 10, 2016 at 11:59 PM, Jiri Kosina <jikos@kernel.org> wrote:
>> On Wed, 10 Aug 2016, Rafael J. Wysocki wrote:
>>
>>> So I used your .config to generate one for my test machine and with
>>> that I can reproduce.
>>
>> Was that the config I've sent, or did Boris provide one as well? Which one
>> are you able to reproduce with please?
>
> It's the Boris' one.
>
> Moreover, I have found the options that make the difference: unsetting
> CONFIG_PROVE_LOCKING and CONFIG_DEBUG_LOCK_ALLOC (which also will
> unset CONFIG_LOCKDEP AFAICS) in it makes hibernation work again with
> CONFIG_RANDOMIZE_MEMORY set and with the $subject patch applied.
>
> Unbelievable, but that's what I'm seeing.

Nice find!

>
> Now, that leads to a few questions:
>
> - How does lockdep change the picture so it matters for hibernation?
> - Why is hibernation the only piece that's affected?
> - Why is RANDOMIZE_MEMORY necessary to make this breakage show up?
>
> Thomas, any ideas?

No idea so far. I will investigate though.

We had an unrelated issue with CONFIG_DEBUG_PAGEALLOC on early boot. I
don't think it was related because it was on early boot and with
certain e820 memory layout (and PUD randomization that I disabled on
the previous patch test). The fix is on tip:
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=fb754f958f8e46202c1efd7f66d5b3db1208117d

>
> Thanks,
> Rafael
