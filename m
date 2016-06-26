Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <576F1BB5.24129.6C9A3386@pageexec.freemail.hu>
References: <1466817192-9586-1-git-send-email-jannh@google.com>
 <1466817192-9586-2-git-send-email-jannh@google.com> <576F1BB5.24129.6C9A3386@pageexec.freemail.hu>
From: Jann Horn <jannh@google.com>
Date: Sun, 26 Jun 2016 06:07:49 +0200
Message-ID: <CAG48ez3ofHW-G4in_A0EY+iw2O9PV+ztxGu9Zmy44PQQGxqGwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] kref: pin objects with dangerously high reference count
To: pageexec@freemail.hu
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@google.com>, Jann Horn <jann@thejh.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 2:03 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 25 Jun 2016 at 3:13, Jann Horn wrote:
>
>> Since 2009 or so, PaX had reference count overflow mitigation code. My main
>> reasons for reinventing the wheel are:
>>
>>  - PaX adds arch-specific code, both in the atomic_t operations and in
>>    exception handlers. I'd like to keep the code as
>>    architecture-independent as possible, especially without adding
>>    complexity to assembler code, to make it more maintainable and
>>    auditable.
>
> complexity is a few simple lines of asm insns in what is already asm, hardly
> a big deal ;). in exchange you'd lose on code density, performance

Yes. It would probably be hard to get an interrupt instruction instead
of a (longer) call instruction without arch-specific code, and the cmp
operation probably can't be removed without putting the conditional
jump into assembly. I guess the main impact of this is higher
instruction cache pressure, leading to more cache faults? (Since
executing an extra cmp should afaik be really fast? But I don't know
much about optimization.)

Now I'm wondering how often atomic ops actually occur in the kernel...
in some grsec build I have here, I see 3687 "int 4" calls in a vmlinux
file that is 25MB big. In the optimal case of 8 additional bytes (3
for call instead of int, 5 for cmp) compared to PaX, that's about 30KB
more compared to assembly... hm, a ~0.1% increase in kernel size is
quite a lot. I guess one remaining question is how many overflow
checks have to happen in hot code paths.

(One of the hottest overflow checks in PaX is probably the one for
f_count in get_file_rcu() - in a multithreaded process, that's called
for every read() or write() -, and inlined copies of get_file()
probably account for a bunch of overflow checks. I believe that all of
these could be removed on 64bit because f_count is an atomic_long_t.
Why does PaX have overflow checks explicitly for atomic64_t? At least
for reference counters, I think that 64bit overflows shouldn't matter;
even the unrealistic worst-case (2^64)/(4GHz) is still over 100
years.)

I guess you might be right about inline asm being a better choice.

> and race windows.

Oh? I thought my code was race-free.

>>  - The refcounting hardening from PaX does not handle the "simple reference
>>    count overflow" case when just the refcounting hardening code is used as
>>    a standalone patch.
>
> i don't think that this is quite true as stated as handling this case depends
> on the exact sequencing of events. there're 3 cases in practice:
[...]
> 2. non-local use, safe sequence
>
>   inc_refcount -> object reference escapes to non-local memory
>
>   same as above, this case is not exploitable because the reference wouldn't
>   escape to non-local memory on overflow.

Ah, true. I somewhat dislike having to oops here, but I guess it's
safe; the only way to exploit oopses that I know of is to abuse them
for a very slow and ugly refcount overincrement, and with refcount
hardening, that shouldn't be an issue.

> 3. non-local use, unsafe sequence
>
>    object reference escapes to non-local memory -> inc_refcount
>
>    this case may already be a logic bug (the object could be freed between these
>    two actions if there's no other synchronization mechanism protecting them) and
>    a reference would escape even though the refcount itself wouldn't actually be
>    incremented. further decrements could then trigger the overdecrement case and
>    be exploitable as a use-after-free bug.
>
>    the REFCOUNT feature in PaX wasn't designed to handle this case because it's
>    too rare to be worth the additional code and performance impact it'd require
>    to saturate the refcount in this case as well.

True, this sequence probably doesn't occur very often since acquiring
the new reference first is more obviously safe, and I don't remember
seeing it anywhere.

That said: I think that this sequence would usually be safe: As long
as the thread that makes the object globally available eventually
increments the reference counter (while still having a valid reference
to the object; but that's implicitly true, since otherwise a refcount
increment would be obviously unsafe), the object won't go away before
the refcount increment.

The case where the existing reference to the object is via RCU is an
exception because the current refcount can be zero and the refcount
increment can fail.

But yes, this sequence is less safe than the others because if an oops
happens before the increment, the reference count would end up being
too low.
