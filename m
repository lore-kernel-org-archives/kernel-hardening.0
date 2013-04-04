Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <515DE0C9.3030709@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DE0C9.3030709@zytor.com>
Date: Thu, 4 Apr 2013 13:47:50 -0700
Message-ID: <CAG7+5M2qKL4PhHhfw-mnw9cBnWnq-2PjVUrqJX03Ma8yR=xYRA@mail.gmail.com>
From: Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 4, 2013 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I have to admit to being somewhat skeptical toward KASLR with only 8
> bits of randomness.

I agree that 8 bits is pretty low and more would be better.  However,
even 8 bits provides a < 1% chance that any particular guess will be
correct.  Combined with kernel crash monitoring, this amount of ASLR
means that brute-force attacks can't occur undetectably, even if they
can eventually be successful.  Having a signal that indicates an
attack-in-progress is a pretty big leg up from not.  Of course,
infoleaks would render this whole discussion moot, but I'm replying to
the "only 8 bits" part here.

> There are at least two potential ways of
> dramatically increasing the available randomness:
>
> 1. actually compose the kernel of multiple independently relocatable
>    pieces (maybe chunk it on 2M boundaries or something.)

Without increasing the entropy bits, does this actually increase the #
of tries necessary for an attacker to guess correctly?  It
dramatically increases the number of possible configurations of kernel
address space, but for any given piece there are only 256 possible
locations.

> 2. compile the kernel as one of the memory models which can be executed
>    anywhere in the 64-bit address space.  The cost of this would have
>    to be quantified, of course.

I attempted to do this, but was limited by my knowledge of the
toolchain.  I would welcome help or suggestions!
