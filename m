Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160930155814.GA1729@remoulade>
References: <20160929213257.30505-1-labbott@redhat.com> <20160929213257.30505-4-labbott@redhat.com>
 <20160930155814.GA1729@remoulade>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 30 Sep 2016 09:25:45 -0700
Message-ID: <CAGXu5jJHohnRBxQAY-S7_iccgjc6xNUdBGb67b1-cOATyO-q0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 3/3] arm64: dump: Add checking for writable and exectuable pages
To: Mark Rutland <mark.rutland@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 30, 2016 at 8:58 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Sep 29, 2016 at 02:32:57PM -0700, Laura Abbott wrote:
>> @@ -219,6 +223,15 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>>               unsigned long delta;
>>
>>               if (st->current_prot) {
>> +                     if (st->check_wx &&
>> +                     ((st->current_prot & PTE_RDONLY) != PTE_RDONLY) &&
>> +                     ((st->current_prot & PTE_PXN) != PTE_PXN)) {
>> +                             WARN_ONCE(1, "arm64/mm: Found insecure W+X mapping at address %p/%pS\n",
>> +                                      (void *)st->start_address,
>> +                                      (void *)st->start_address);
>> +                             st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
>> +                     }
>> +
>
> Would it be worth verifying that all kernel mappings are UXN, too?
>
> ARMv8 allows execute-only mappings, and a !UXN mapping could result in an info
> leak (e.g. pointers in MOVZ+MOVK sequences), or potential asynchronous issues
> (e.g. user instruction fetches accessing read-destructive device registers).
> All kernel mappings *should* be UXN.

I love this idea, but based on what came up with hardened usercopy,
there are a lot of readers of kernel memory still. I think the
expectations around UXN need to be clarified so we can reason about
things like perf that want to read the kernel text.

-Kees

-- 
Kees Cook
Nexus Security
