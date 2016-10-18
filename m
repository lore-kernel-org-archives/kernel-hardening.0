Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161017130412.GG29095@leverpostej>
References: <1472221903-31181-1-git-send-email-mark.rutland@arm.com>
 <CAGXu5jKdu+8zf+NM6nFMwWgs=AVcAE5c0tiq+AvADqCAVL4BFg@mail.gmail.com> <20161017130412.GG29095@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Oct 2016 13:49:28 -0700
Message-ID: <CAGXu5jJ65F0p7TBoAMXbLP=VAYr2ZBPy6K96F7KcNbLLd38GBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] lib: harden strncpy_from_user
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 17, 2016 at 6:04 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Aug 26, 2016 at 02:57:58PM -0400, Kees Cook wrote:
>> On Fri, Aug 26, 2016 at 10:31 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > The strncpy_from_user() accessor is effectively a copy_from_user()
>> > specialised to copy strings, terminating early at a NUL byte if
>> > possible. In other respects it is identical, and can be used to copy an
>> > arbitrarily large buffer from userspace into the kernel. Conceptually,
>> > it exposes a similar attack surface.
>> >
>> > As with copy_from_user(), we check the destination range when the kernel
>> > is built with KASAN, but unlike copy_from_user() we do not check the
>> > destination buffer when using HARDENED_USERCOPY. As strncpy_from_user()
>> > calls get_user() in a loop, we must call check_object_size() explicitly.
>> >
>> > This patch adds this instrumentation to strncpy_from_user(), per the
>> > same rationale as with the regular copy_from_user(). In the absence of
>> > hardened usercopy this will have no impact as the instrumentation
>> > expands to an empty static inline function.
>
> [...]
>
>> Ah, yes, good catch! (And to repeat what you mentioned to me in
>> passing in the hall: there appear to be other users of get_user() in a
>> loop in other places in the kernel that will likely need some
>> attention too.)
>
> I was reminded of this as it just hit mainline; is it worth dropping a
> TODO on the KSPP wiki? I suspect I won't have the time to delve much
> further into this in the near term, and it might be a good intro task
> for someone.

Ah, right. I've updated the kernserc TODO list with this (recently the
csum_* routines were pointed out), and added a bunch more TODOs that
were in my notes.

-Kees

-- 
Kees Cook
Nexus Security
