Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5179A797.9040200@zytor.com>
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
	<1366926860-26776-3-git-send-email-keescook@chromium.org>
	<5179A797.9040200@zytor.com>
Date: Fri, 26 Apr 2013 08:28:51 -0700
Message-ID: <CAGXu5jLT494F_jM3Q6GFaestU0cg-=bx_+g-1v2myTsCmnVH5A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 25, 2013 at 3:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/25/2013 02:54 PM, Kees Cook wrote:
>> Since has_eflag() and has_fpu() are 32-bit only, short-circuit the
>> routines on 64-bit when they are built without -m32. This also refactors
>> the calls to cpuid to make them PIC-safe on 32-bit.
>
> These functions can trivially be made 32- and 64-bit agnostic by
> changing "u32" to "unsigned long" and drop the -l suffixes in the
> assembly code.

Ah, good call. I found what was stopping me earlier. The u32 argument
needed to be switched to unsigned long too. Duh. :)

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
