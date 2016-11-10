Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110211310.GX3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Nov 2016 13:23:49 -0800
Message-ID: <CAGXu5jJpOxewaYTOFRKBS-YmzAGDY++guVFYdQh8vsJLU4zJzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 1:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 10, 2016 at 08:48:38PM +0000, Will Deacon wrote:
>> > That said, I still don't much like this.
>> >
>> > I would much rather you make kref useful and use that. It still means
>> > you get to audit all refcounts in the kernel, but hey, you had to do
>> > that anyway.
>>
>> What needs to happen to kref to make it useful? Like many others, I've
>> been guilty of using atomic_t for refcounts in the past.
>
> As it stands kref is a pointless wrapper. If it were to provide
> something actually useful, like wrap protection, then it might actually
> make sense to use it.

An example of opt-in vs opt-out was the kernel's handling of format
strings. For many years, %n was part of the recognized format strings,
which meant that every time there was a format string error, the
kernel had a write-anything-anywhere primitive exposed to an attacker.
I, along with others, watched the kernel for format string errors, an
there were _always_ newly added misuses. It took too much time to
review, and burned lots of people's time. Instead, %n was removed
(again) from the kernel's format processor, and the entire class of
bugs switched from arbitrary writes to simple info leaks.

If we don't use opt-out for atomics, we're going to be in the same
situation where we have to constantly review every commit with an
atomic for exploitable refcount flaws. Kicking this down from
"privilege escalation" to "DoS" is a significant change in the
kernel's weaknesses.

-Kees

-- 
Kees Cook
Nexus Security
