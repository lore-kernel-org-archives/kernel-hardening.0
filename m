References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
 <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
 <20171030173216.72y673m32gra4b55@hirez.programming.kicks-ass.net>
 <586ee584-df0d-3c82-a254-16ac1573255a@linux.com>
 <69522d43-f1b9-48ac-6235-a237c0298a04@linux.com>
 <CALCETrUYADqoZLYxC=uMVTvSU_R5Vg_uXzs_DUZBAC_O5Wybxg@mail.gmail.com>
 <20171114163306.3pr4a4s36t7mbj2f@salmiak>
 <0bf24e38-c26a-baca-c54d-1bb0aa7b01e4@linux.com>
 <CALCETrVF4_acCKvK4C+4gNk08sQ5VrBhNFcO1agATNDuOebstQ@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <dd370e28-fc68-ef6c-3c2e-3d75051140f8@linux.com>
Date: Wed, 15 Nov 2017 01:03:58 +0300
MIME-Version: 1.0
In-Reply-To: <CALCETrVF4_acCKvK4C+4gNk08sQ5VrBhNFcO1agATNDuOebstQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: Andy Lutomirski <luto@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 15.11.2017 00:17, Andy Lutomirski wrote:
> On Tue, Nov 14, 2017 at 1:09 PM, Alexander Popov <alex.popov@linux.com> wrote:
>> Thanks, Mark!
>>
>> Please see my comments below.
>>
>> On 14.11.2017 19:33, Mark Rutland wrote:
>>> On Tue, Nov 14, 2017 at 08:13:43AM -0800, Andy Lutomirski wrote:
>>>> What does the STEAKLACK plugin actually do?  I haven't followed this enough.
>>>
>>> The plugin adds instrumentation to track the maximum stack depth, though only
>>> functions with a sufficiently large stackframe are instrumented.
>>
>> Yes. Functions with a big stack frame call track_stack() to update the
>> lowest_stack value. If CONFIG_VMAP_STACK is disabled, track_stack() is compiled
>> with a check for detecting stack depth overflow. This check is what I'm asking
>> about.
> 
> Then you'll probably have to do something like what I did in the
> VMAP_STACK code.

Yes!

> That being said, I don't entirely see the point.  If you want a
> hardened kernel, you're going to enable VMAP_STACK.  Are there really
> users of hardened 32-bit kernels?

You know, STACKLEAK already supports x86_32. It's a pity for me to make
STACKLEAK dependent on VMAP_STACK and hence to drop STACKLEAK support for this
platform.

I hope there is a way to add a good-looking check to track_stack() and have at
least some profit (although it will not catch all overflow cases).

Best regards,
Alexander
