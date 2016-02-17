Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160217234306.GA59532@davidb.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	<20160216213659.GA47194@davidb.org>
	<CAGXu5j+H63jhcDpHpXK5aWvgUBz=5vB0FK_zRoc+wZEk32B2fg@mail.gmail.com>
	<20160217052010.GA49233@davidb.org>
	<CAGXu5jK22LfvLdMfWz_vbQsJ3bbjSdJrYAp=5yWzD4yRNTTGFQ@mail.gmail.com>
	<20160217234306.GA59532@davidb.org>
Date: Wed, 17 Feb 2016 15:48:21 -0800
Message-ID: <CAGXu5jJmpq_2mmTLD0VbnY1SBF5b5Rr04HKWfD1LEaGxnztFdQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] ARM: vdso: Mark vDSO code as read-only
To: David Brown <david.brown@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 17, 2016 at 3:43 PM, David Brown <david.brown@linaro.org> wrote:
> On Wed, Feb 17, 2016 at 03:00:52PM -0800, Kees Cook wrote:
>>
>> On Tue, Feb 16, 2016 at 9:20 PM, David Brown <david.brown@linaro.org>
>> wrote:
>>>
>>> On Tue, Feb 16, 2016 at 01:52:33PM -0800, Kees Cook wrote:
>>>>
>>>>
>>>> On Tue, Feb 16, 2016 at 1:36 PM, David Brown <david.brown@linaro.org>
>>>> wrote:
>>>>>
>>>>>
>>>>> Although the arm vDSO is cleanly separated by code/data with the code
>>>>> being read-only in userspace mappings, the code page is still writable
>>>>> from the kernel.  There have been exploits (such as
>>>>> http://itszn.com/blog/?p=21) that take advantage of this on x86 to go
>>>>> from a bad kernel write to full root.
>>>>>
>>>>> Prevent this specific exploit on arm by putting the vDSO code page in
>>>>> post-init read-only memory as well.
>>>>
>>>>
>>>>
>>>> Is the vdso dynamically built at init time like on x86, or can this
>>>> just use .rodata directly?
>>>
>>>
>>>
>>> On ARM, it is patched during init.  Arm64's is just plain read-only.
>>
>>
>> Okay, great. I've added this to my postinit-readonly series (which I
>> just refreshed and sent out again...)
>
>
> However, this distinction between .rodata and .data..ro_after_init is
> kind of fuzzy, anyway, since they both get made actually read-only at
> the same time (post init).  The patch actually does work fine with the
> vDSO page in .rodata, since the patching happens during init.

Yeah, in the ARM case, that's true. I think we should probably keep it
marked "correctly" though.

> Is there a possible future consideration to perhaps make .rodata read
> only much earlier?

Yeah, this will likely be a future improvement. Some architectures
already mark .rodata before the mark_rodata_ro() call. Once we start
to have more use of postinit-readonly, I suspect we'll see more
clarification of when those things happen.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
