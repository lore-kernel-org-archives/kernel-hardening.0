MIME-Version: 1.0
In-Reply-To: <babc5b86-f625-bb28-d49e-9f34c3ca6726@linux.com>
References: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
 <0bb962c4-92fb-156b-cee3-df48aff0552d@redhat.com> <53E66B61-665C-48A3-B266-863C5BAA6B6A@amacapital.net>
 <babc5b86-f625-bb28-d49e-9f34c3ca6726@linux.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Oct 2017 10:26:40 -0700
Message-ID: <CALCETrVF0-bz3A_8T-nghD_h8rs0N6NJBOM04scjMJdQq9ZLCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v4 0/3] Introduce the STACKLEAK feature and a test for it
To: Alexander Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 9:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
> On 11.10.2017 05:31, Andy Lutomirski wrote:
>>
>>
>>> On Oct 10, 2017, at 6:19 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>
>>>> On 10/04/2017 03:55 PM, Alexander Popov wrote:
>>>> This is the 4th version of the patch introducing STACKLEAK to the mainline
>>>> kernel. STACKLEAK is a security feature developed by Grsecurity/PaX (kudos
>>>> to them), which:
>>>> - reduces the information that can be revealed by some kernel stack leak bugs
>>>>    (e.g. CVE-2016-4569 and CVE-2016-4578);
>>>> - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>>> - introduces some runtime checks for kernel stack overflow detection.
>>>>
>>>> Further work:
>>>> - think of erasing the kernel stack after invoking EFI runtime services;
>>>> - try to port STACKLEAK to arm64 (Laura Abbott is working on it).
>>>>
>>>> Changes in v4
>>>>
>>>> 1. Introduced the CONFIG_STACKLEAK_TRACK_MIN_SIZE parameter instead of
>>>>   hard-coded track-lowest-sp.
>>>>
>>>> 2. Carefully looked into the assertions in track_stack() and check_alloca().
>>>>    - Fixed the incorrect BUG() condition in track_stack(), thanks to Tycho
>>>>       Andersen. Also disabled that check if CONFIG_VMAP_STACK is enabled.
>>>>    - Fixed the surplus and erroneous code for calculating stack_left in
>>>>       check_alloca() on x86_64. That code repeats the work which is already
>>>>       done in get_stack_info() and it misses the fact that different
>>>>       exception stacks on x86_64 have different size.
>>>>
>>>> 3. Introduced two lkdtm tests for the STACKLEAK feature (developed together
>>>>   with Tycho).
>>>>
>>>> 4. Added info about STACKLEAK to Documentation/security/self-protection.rst.
>>>>
>>>> 5. Improved the comments.
>>>>
>>>> 6. Decided not to change "unsigned long sp = (unsigned long)&sp" to
>>>>   current_stack_pointer. The original variant is more platform independent
>>>>   since current_stack_pointer has different type on x86 and arm.
>>>>
>>>> Changes in v3
>>>>
>>>> 1. Added the detailed comments describing the STACKLEAK gcc plugin.
>>>>   Read the plugin from bottom up, like you do for Linux kernel drivers.
>>>>   Additional information:
>>>>    - gcc internals documentation, which is available from gcc sources;
>>>>    - wonderful slides by Diego Novillo
>>>>       https://www.airs.com/dnovillo/200711-GCC-Internals/
>>>>    - nice introduction to gcc plugins at LWN
>>>>       https://lwn.net/Articles/457543/
>>>>
>>>> 2. Improved the commit message and Kconfig description according the
>>>>   feedback from Kees Cook. Also added the original notice describing
>>>>   the performance impact of the STACKLEAK feature.
>>>>
>>>> 3. Removed arch-specific ix86_cmodel check from stackleak_track_stack_gate().
>>>>   It caused skipping the kernel code instrumentation for i386.
>>>>
>>>> 4. Fixed a minor mistake in stackleak_tree_instrument_execute().
>>>>   First versions of the plugin used ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb
>>>>   to get the basic block with the function prologue. That was not correct
>>>>   since the control flow graph edge from the ENTRY_BLOCK_PTR doesn't always
>>>>   go to that basic block.
>>>>
>>>>   So later it was changed it to single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)),
>>>>   but not completely. next_bb was still used for entry_bb assignment,
>>>>   which could cause the wrong value of the prologue_instrumented variable.
>>>>
>>>>   I've reported this issue to Grsecurity and proposed the fix for it, but
>>>>   unfortunately didn't get any reply.
>>>>
>>>> 5. Introduced the STACKLEAK_POISON macro and renamed the config option
>>>>   according the feedback from Kees Cook.
>>>>
>>>>
>>>> Alexander Popov (3):
>>>>  gcc-plugins: Add STACKLEAK erasing the kernel stack at the end of
>>>>    syscalls
>>>>  lkdtm: Add a test for STACKLEAK
>>>>  doc: self-protection: Add information about STACKLEAK feature
>>>>
>>>> Documentation/security/self-protection.rst |  23 +-
>>>> arch/Kconfig                               |  39 +++
>>>> arch/x86/Kconfig                           |   1 +
>>>> arch/x86/entry/common.c                    |  17 +-
>>>> arch/x86/entry/entry_32.S                  |  69 +++++
>>>> arch/x86/entry/entry_64.S                  |  95 +++++++
>>>> arch/x86/entry/entry_64_compat.S           |   8 +
>>>> arch/x86/include/asm/processor.h           |   4 +
>>>> arch/x86/kernel/asm-offsets.c              |   9 +
>>>> arch/x86/kernel/dumpstack_32.c             |  12 +
>>>> arch/x86/kernel/dumpstack_64.c             |  15 ++
>>>> arch/x86/kernel/process_32.c               |   5 +
>>>> arch/x86/kernel/process_64.c               |   5 +
>>>> drivers/misc/Makefile                      |   3 +
>>>> drivers/misc/lkdtm.h                       |   4 +
>>>> drivers/misc/lkdtm_core.c                  |   2 +
>>>> drivers/misc/lkdtm_stackleak.c             | 139 ++++++++++
>>>> fs/exec.c                                  |  30 +++
>>>> include/linux/compiler.h                   |   4 +
>>>> scripts/Makefile.gcc-plugins               |   3 +
>>>> scripts/gcc-plugins/stackleak_plugin.c     | 397 +++++++++++++++++++++++++++++
>>>> 21 files changed, 872 insertions(+), 12 deletions(-)
>>>> create mode 100644 drivers/misc/lkdtm_stackleak.c
>>>> create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
>>>>
>>>
>>> I tried this series with CVE-2017-14954 . That particular bug
>>> is not helped here because the poisoning has already been
>>> overwritten by other leaf functions. Given the call stack this
>>> may be a particularly bad case but I'm wondering how common
>>> this might be if we're only erasing at the end of a system
>>> call. One previous copy_to_user which has to go through the
>>> fault path can get fairly deep.
>
> Laura, thanks for your observation. I've tested Brad's PoC with STACKLEAK too
> and see similar results. There is only one STACKLEAK_POISON value in the leaked
> data. Other leaked data is put on the stack by the current syscall.
>
> I don't know any statistics on infoleaks and I can't say how many of them would
> be neutralized by STACKLEAK. But, anyway, it is be better than nothing for those
> who accept the STACKLEAK performance penalty.
>
>> On x86, the bad guys can force this is using 32-bit fast syscalls for *any*
>> syscall.  I suppose we could wipe the stack on the way out of exception
>> handlers, too...
>
> Andy, excuse me, could you elaborate on that? Do you mean that there are some
> more cases when erase_kstack() should be called?

Kinda.  I was thinking that certain exception handlers should erase
their portion of the stack (i.e. from their entry frame to the bottom)
when they return back to *kernel* mode.  On x86, this should include
at least #PF and probably #GP and #DB, too.  #DB is weird, so it might
not actually be needed.

>
>> OTOH, I think we should consider KASLR to be worthless against local
>> attackers in general.  See all the papers on TSX timing leaks, etc.  It's a
>> nice defense against a limited class of remote attack.  And the plugin is
>> still plausibly useful to protect more serious  secrets.
>
> Thanks for that remark! Could you give some examples of such secrets which
> should not leak to the userspace?

Crypto secrets.  Stuff in /dev/urandom, for example.  Keys, too.

>
> Best regards,
> Alexander



-- 
Andy Lutomirski
AMA Capital Management, LLC
