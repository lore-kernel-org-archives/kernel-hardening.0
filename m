Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5179A797.9040200@zytor.com>
Date: Thu, 25 Apr 2013 15:00:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1366926860-26776-1-git-send-email-keescook@chromium.org> <1366926860-26776-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/25/2013 02:54 PM, Kees Cook wrote:
> Since has_eflag() and has_fpu() are 32-bit only, short-circuit the
> routines on 64-bit when they are built without -m32. This also refactors
> the calls to cpuid to make them PIC-safe on 32-bit.

These functions can trivially be made 32- and 64-bit agnostic by
changing "u32" to "unsigned long" and drop the -l suffixes in the
assembly code.

	-hpa
