Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87twb8xpyb.fsf@concordia.ellerman.id.au>
References: <1479207422-6535-1-git-send-email-mpe@ellerman.id.au>
 <CAGXu5j+3pD7Ss_PBY9H_A6B5-Ers2wYqFJ1y4iryKzqc=jCxXg@mail.gmail.com> <87twb8xpyb.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 15 Nov 2016 16:08:13 -0800
Message-ID: <CAGXu5jKPWBsj=tYxv7BsPw3oWvtwkqaz5SefQXT4QoOjzMUo-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 15, 2016 at 3:50 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Tue, Nov 15, 2016 at 2:57 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> POISON_POINTER_DELTA is defined in poison.h, and is intended to be used
>>> to shift poison values so that they don't alias userspace.
>>>
>>> We should add it to ZERO_SIZE_PTR so that attackers can't use
>>> ZERO_SIZE_PTR as a way to get a pointer to userspace.
>>
>> Ah, when dealing with a 0-sized malloc or similar?
>
> Yeah as returned by a 0-sized kmalloc for example.
>
>> Do you have pointers to exploits that rely on this?
>
> Not real ones, it was used in the StringIPC challenge:
>
> https://poppopret.org/2015/11/16/csaw-ctf-2015-kernel-exploitation-challenge/
>
> Though that included the ability to seek to an arbitrary offset from the
> zero size pointer, so this wouldn't have helped.
>
>> Regardless, normally PAN/SMAP-like things should be sufficient to
>> protect against this.
>
> True. Not everyone has PAN/SMAP though :)

Right, mostly just thinking out loud about the threat model and the
existing results.

>> Additionally, on everything but x86_64 and arm64, POISON_POINTER_DELTA
>> == 0, if I'm reading correctly:
>
> You are reading correctly. All 64-bit arches should be able to define it
> to something though.
>
>> Is the plan to add ILLEGAL_POINTER_VALUE for powerpc too?
>
> Yep. I should have CC'ed you on the patch :)

I suspected I was missing something. ;)

>> And either way, this patch, IIUC, will break the ZERO_OR_NULL_PTR()
>> check, since suddenly all of userspace will match it. (Though maybe
>> that's okay?)
>
> Yeah I wasn't sure what to do with that.

Yeah, though there are shockingly few callers of that macro. I think
building with HARDENED_USERCOPY would totally break the kernel,
though, since check_bogus_address() is looking at ZERO_OR_NULL even
for things destined for userspace.

> I don't think it breaks it, but it does become a bit fishy because as
> you say all of userspace (and more) will now match.
>
> It should probably just become two separate tests, though that
> potentially has issues with double evaluation of the argument. AFAICS
> none of the callers pass an expression though.

That shouldn't be a problem. I think we can use fancy magic like:

#define ZERO_OR_NULL_PTR(x) \
 ({ \
    unsigned long p = (unsigned long)(x); \
    (p == NULL || p == ZERO_SIZE_PTR); \
   })

Though this technically loses the check for values 1 through 15...

-Kees

-- 
Kees Cook
Nexus Security
