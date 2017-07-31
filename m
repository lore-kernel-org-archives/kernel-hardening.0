MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu-TH6qeotkYF+w+KcVJ6pavOYYEkmLKEQTUiDVAcQ1REQ@mail.gmail.com>
References: <20170731192251.12491-1-ard.biesheuvel@linaro.org>
 <CAGXu5jLZw1aK_wqSiAi3ddxPavOC1i47q4ahnwVnja=gsrLs2w@mail.gmail.com> <CAKv+Gu-TH6qeotkYF+w+KcVJ6pavOYYEkmLKEQTUiDVAcQ1REQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 31 Jul 2017 14:36:04 -0700
Message-ID: <CAGXu5j+M3zVxZRXLw_e1yAS29=eB823+jeidiXX9eUbSR=ZePg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Li Kun <hw.likun@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 31, 2017 at 2:21 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 31 July 2017 at 22:16, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Jul 31, 2017 at 12:22 PM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> v4: Implement add-from-zero checking using a conditional compare rather than
>>>     a conditional branch, which I omitted from v3 due to the 10% performance
>>>     hit: this will result in the new refcount to be written back to memory
>>>     before invoking the handler, which is more in line with the other checks,
>>>     and is apparently much easier on the branch predictor, given that there
>>>     is no performance hit whatsoever.
>>
>> So refcount_inc() and refcount_add(n, ...) will write 1 and n
>> respectively, then hit the handler to saturate?
>
> Yes, but this is essentially what occurs on overflow and sub-to-zero
> as well: the result is always stored before hitting the handler. Isn't
> this the case for x86 as well?

On x86, there's no check for inc/add-from-zero. Double-free would be:

- refcount_dec_and_test() to 0, free
- refcount_inc() to 1,
- refcount_dec_and_test() to 0, free again

Compared to the atomic_t implementation, this risk is unchanged. Also
this case is an "over decrement" which we can't actually protect
against. If the refcount_inc() above happens that means something is
still tracking the object (but it's already been freed, so the
use-after-free has already happened).

x86 refcount_dec() to zero is checked, but this is mainly to find bad
counting in "over decrement" cases, when the code pattern around the
object is using unchecked refcount_dec() instead of
refcount_dec_and_test(). (Frankly, I'd like to see refcount_dec()
entirely removed from the refcount API...)

On overflow, though, no, since we haven't yet reached all the way
around to zero (i.e. it's caught before we can get all the way through
the negative space back through zero to 1 and have a
refcount_dec_and_test() trigger a free).

If I could find a fast way to do the precheck for zero on x86, though,
I'd like to have it, just to be extra-sure.

-Kees

-- 
Kees Cook
Pixel Security
