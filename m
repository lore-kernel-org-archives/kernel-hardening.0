Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524B3538.9010406@zytor.com>
Date: Tue, 01 Oct 2013 13:48:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-2-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/7] x86, kaslr: move CPU flags out of cpucheck
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/01/2013 12:37 PM, Kees Cook wrote:
> Refactor the CPU flags handling out of the cpucheck routines so that
> they can be reused by the future ASLR routines (in order to detect CPU
> features like RDRAND and RDTSC).
> 
> This reworks has_eflag() and has_fpu() to be used on both 32-bit and
> 64-bit, and refactors the calls to cpuid to make them PIC-safe on 32-bit.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Please flag the ones that specifically touch the boot code so that is
clear.  Neither the title or the description makes that at all clear,
and at first reading is fairly confusing as a result.

	-hpa
