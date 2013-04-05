Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <515F4B60.60302@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<20130405071144.GB26889@gmail.com>
	<CAKyRK=h0sDFn6vqdKwmWds4EubqwnqVYG4JgKk=5-EDV7dJ36g@mail.gmail.com>
	<515F4B60.60302@zytor.com>
Date: Fri, 5 Apr 2013 15:13:37 -0700
Message-ID: <CAKyRK=j2UyqQFT2AEX5QqEA335n7r2pgJmK52in924x8LFNbTA@mail.gmail.com>
From: Julien Tinnes <jln@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 5, 2013 at 3:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/05/2013 03:06 PM, Julien Tinnes wrote:
>>
>> Speaking of IDT, and to capture some off-thread discussion here, we
>> should remember that the "SGDT" and "SIDT" instructions aren't
>> privileged on x86, so user-land can leak these out without any way for
>> the kernel to intercept that.
>>
>> Adding their own random offsets to these two tables would be very
>> useful. This could be done in a later patchset of course.
>>
>
> Yes, if the GDT or IDT position is at all correlated to the kernel
> position this is pointless.

Let's say it's less useful :) Remote attacks and from-inside-a-VM
attack would still be mitigated.

Julien
