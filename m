Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524B34B9.4020504@zytor.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-5-git-send-email-keescook@chromium.org>
	<524B34B9.4020504@zytor.com>
Date: Tue, 1 Oct 2013 14:18:22 -0700
Message-ID: <CAGXu5jJQQzWbRRWzHw_ZVuz2u8yAyON+-iECeskAEE_Y8Dqi8g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 4/7] x86, kaslr: select random base offset
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 1, 2013 at 1:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/01/2013 12:37 PM, Kees Cook wrote:
>> +
>> +#include <asm/archrandom.h>
>> +static inline int rdrand(unsigned long *v)
>> +{
>> +     int ok;
>> +     asm volatile("1: " RDRAND_LONG "\n\t"
>> +                  "jc 2f\n\t"
>> +                  "decl %0\n\t"
>> +                  "jnz 1b\n\t"
>> +                  "2:"
>> +                  : "=r" (ok), "=a" (*v)
>> +                  : "0" (RDRAND_RETRY_LOOPS));
>> +     return ok;
>> +}
>> +
>
> This looks just like rdrand_long() in arch/x86/kernel/cpu/rdrand.c and
> could move into the header file, no?

Yes, good idea. I'll move it into archrandom.h instead of this copy/paste.

-Kees

-- 
Kees Cook
Chrome OS Security
