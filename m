Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524B3538.9010406@zytor.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-2-git-send-email-keescook@chromium.org>
	<524B3538.9010406@zytor.com>
Date: Tue, 1 Oct 2013 14:09:12 -0700
Message-ID: <CAGXu5jLiGoc+=xDpXRRCNneVOWKezTAz2WxjpwtpTt8LXTVK2Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/7] x86, kaslr: move CPU flags out of cpucheck
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 1, 2013 at 1:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/01/2013 12:37 PM, Kees Cook wrote:
>> Refactor the CPU flags handling out of the cpucheck routines so that
>> they can be reused by the future ASLR routines (in order to detect CPU
>> features like RDRAND and RDTSC).
>>
>> This reworks has_eflag() and has_fpu() to be used on both 32-bit and
>> 64-bit, and refactors the calls to cpuid to make them PIC-safe on 32-bit.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Please flag the ones that specifically touch the boot code so that is
> clear.  Neither the title or the description makes that at all clear,
> and at first reading is fairly confusing as a result.

Yes, good point. Patch 1/7 should be named "x86, boot: ..."

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
