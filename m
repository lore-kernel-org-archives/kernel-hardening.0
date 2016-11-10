Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110203749.GV3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com> <20161110203749.GV3117@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Nov 2016 12:56:09 -0800
Message-ID: <CAGXu5j+4uod4UFAZNj5K=At3x2MUODstfUVMbDFguh5FM_S7cA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 12:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 10, 2016 at 10:24:35PM +0200, Elena Reshetova wrote:
>> This series brings the PaX/Grsecurity PAX_REFCOUNT
>> feature support to the upstream kernel. All credit for the
>> feature goes to the feature authors.
>>
>> The name of the upstream feature is HARDENED_ATOMIC
>> and it is configured using CONFIG_HARDENED_ATOMIC and
>> HAVE_ARCH_HARDENED_ATOMIC.
>>
>> This series only adds x86 support; other architectures are expected
>> to add similar support gradually.
>>
>> More information about the feature can be found in the following
>> commit messages.
>
> No, this should be here. As it stands this is completely without
> content.
>
> In any case, NAK on this approach. Its the wrong way around.
>
> _IF_ you want to do a non-wrapping variant, it must not be the default.

Unfortunately, we have to do it this way because there are so many
misuses of atomic_t, and they just keep appearing. We can't do opt-in
protections for the kernel -- we need to protect atomic_t and opt OUT
of the protection where it's not needed.

We must change the kernel culture to making things secure-by-default.
Without this, we're wasting our time and continuing to leave people
vulnerable every time some new driver lands that refcounts with
atomic_t. Since education is proven to not work, we have to harden the
_infrastructure_ of the kernel, of which atomic_t is a part.

> Since you need to audit every single atomic_t user in the kernel anyway,
> it doesn't matter. But changing atomic_t to non-wrap by default is not
> robust, if you forgot one, you can then trivially dos the kernel.

Correct: everything must be audited in either case. However, making a
mistake using opt-out means a DoS. Making a mistake using opt-in means
an exploitable kernel escalation. We must have the courage to
recognize this distinction. Right now, every refcount mistake is an
exploitable kernel flaw. Reducing this to a DoS is a giant
improvement.

> That said, I still don't much like this.
>
> I would much rather you make kref useful and use that. It still means
> you get to audit all refcounts in the kernel, but hey, you had to do
> that anyway.

This has already been suggested in the past, and suffers from the same
opt-in problem. I'll let Greg comment on it, though, as he's agreed
with going opt-out in the past when reviewing this work.

-Kees

-- 
Kees Cook
Nexus Security
