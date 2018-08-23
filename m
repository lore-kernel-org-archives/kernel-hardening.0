MIME-Version: 1.0
In-Reply-To: <CAG48ez0c0L+WyfjDcfx=3wDwOQDOSJM-2JSVUBoWJCaKDVEfbw@mail.gmail.com>
References: <20180807012257.20157-1-jannh@google.com> <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
 <CAG48ez0c0L+WyfjDcfx=3wDwOQDOSJM-2JSVUBoWJCaKDVEfbw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Aug 2018 17:28:24 -0700
Message-ID: <CALCETrU6gUBiTkpAUKh97y2R1cSftbMcfSTnSYxhZFRKf7vGWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 22, 2018 at 4:53 PM, Jann Horn <jannh@google.com> wrote:
> On Tue, Aug 7, 2018 at 4:55 AM Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
>> > There have been multiple kernel vulnerabilities that permitted userspace to
>> > pass completely unchecked pointers through to userspace accessors:
>> >
>> > - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>> >  access_ok() checks")
>> > - the sg/bsg read/write APIs
>> > - the infiniband read/write APIs
>> >
>> > These don't happen all that often, but when they do happen, it is hard to
>> > test for them properly; and it is probably also hard to discover them with
>> > fuzzing. Even when an unmapped kernel address is supplied to such buggy
>> > code, it just returns -EFAULT instead of doing a proper BUG() or at least
>> > WARN().
>> >
>> > This patch attempts to make such misbehaving code a bit more visible by
>> > WARN()ing in the pagefault handler code when a userspace accessor causes
>> > #PF on a kernel address and the current context isn't whitelisted.
>>
>> I like this a lot, and, in fact, I once wrote a patch to do something similar. It was before the fancy extable code, though, so it was a mess.  Here are some thoughts:
>>
>> - It should be three patches. One patch to add the _UA annotations, one to improve the info passes to the handlers, and one to change behavior.
>>
>> - You should pass the vector, the error code, and the address to the handler.
>
> I'm polishing the patch a bit, and I've noticed that to plumb the
> error code and address through properly, I might need significantly
> more code churn because of kprobes - I want to make sure I'm not going
> down the completely wrong path here.
>
> I'm extending fixup_exception() to take two extra args "unsigned long
> error_code, unsigned long fault_addr". Most callers of
> fixup_exception() are fairly straightforward, but
> kprobe_fault_handler() has a dozen callchains from different exception
> handlers, and most of them are coming via notify_die().

KILL IT WITH FIRE!!!!!!!!

More seriously, kill kprobe_exceptions_notify() and just fold the
contents into do_general_protection().  This notifier chain crap is
incomprehensible.  I would love to see notify_die() removed entirely,
and crap like this is just more reason to want it gone.

> I think there's also some inconsistency between #PF and #GP in the
> ordering of error handling:

It's probably a bug.  It's also probably irrelevant, but maybe not.
