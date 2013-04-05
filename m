Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <515E2425.6080601@zytor.com>
Date: Thu, 04 Apr 2013 18:08:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DE0C9.3030709@zytor.com> <CAG7+5M2qKL4PhHhfw-mnw9cBnWnq-2PjVUrqJX03Ma8yR=xYRA@mail.gmail.com>
In-Reply-To: <CAG7+5M2qKL4PhHhfw-mnw9cBnWnq-2PjVUrqJX03Ma8yR=xYRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Eric Northup <digitaleric@google.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/04/2013 01:47 PM, Eric Northup wrote:
>>
>> 1. actually compose the kernel of multiple independently relocatable
>>    pieces (maybe chunk it on 2M boundaries or something.)
> 
> Without increasing the entropy bits, does this actually increase the #
> of tries necessary for an attacker to guess correctly?  It
> dramatically increases the number of possible configurations of kernel
> address space, but for any given piece there are only 256 possible
> locations.
> 

The 2M chunk was a red herring; one would of course effectively pack
blocks together, probably packed back to back, in random order.

>> 2. compile the kernel as one of the memory models which can be executed
>>    anywhere in the 64-bit address space.  The cost of this would have
>>    to be quantified, of course.
> 
> I attempted to do this, but was limited by my knowledge of the
> toolchain.  I would welcome help or suggestions!

Start by looking at the ABI document.  I suspect what we need is some
variant of the small PIC model.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
