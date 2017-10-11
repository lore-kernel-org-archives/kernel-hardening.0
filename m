Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <0bb962c4-92fb-156b-cee3-df48aff0552d@redhat.com>
Date: Tue, 10 Oct 2017 19:31:25 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <53E66B61-665C-48A3-B266-863C5BAA6B6A@amacapital.net>
References: <1507157703-14972-1-git-send-email-alex.popov@linux.com> <0bb962c4-92fb-156b-cee3-df48aff0552d@redhat.com>
Subject: [kernel-hardening] Re: [PATCH RFC v4 0/3] Introduce the STACKLEAK feature and a test for it
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



> On Oct 10, 2017, at 6:19 PM, Laura Abbott <labbott@redhat.com> wrote:
>=20
>> On 10/04/2017 03:55 PM, Alexander Popov wrote:
>> This is the 4th version of the patch introducing STACKLEAK to the mainlin=
e
>> kernel. STACKLEAK is a security feature developed by Grsecurity/PaX (kudo=
s
>> to them), which:
>> - reduces the information that can be revealed by some kernel stack leak b=
ugs
>>    (e.g. CVE-2016-4569 and CVE-2016-4578);
>> - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>> - introduces some runtime checks for kernel stack overflow detection.
>>=20
>> Further work:
>> - think of erasing the kernel stack after invoking EFI runtime services;
>> - try to port STACKLEAK to arm64 (Laura Abbott is working on it).
>>=20
>> Changes in v4
>>=20
>> 1. Introduced the CONFIG_STACKLEAK_TRACK_MIN_SIZE parameter instead of
>>   hard-coded track-lowest-sp.
>>=20
>> 2. Carefully looked into the assertions in track_stack() and check_alloca=
().
>>    - Fixed the incorrect BUG() condition in track_stack(), thanks to Tych=
o
>>       Andersen. Also disabled that check if CONFIG_VMAP_STACK is enabled.=

>>    - Fixed the surplus and erroneous code for calculating stack_left in
>>       check_alloca() on x86_64. That code repeats the work which is alrea=
dy
>>       done in get_stack_info() and it misses the fact that different
>>       exception stacks on x86_64 have different size.
>>=20
>> 3. Introduced two lkdtm tests for the STACKLEAK feature (developed togeth=
er
>>   with Tycho).
>>=20
>> 4. Added info about STACKLEAK to Documentation/security/self-protection.r=
st.
>>=20
>> 5. Improved the comments.
>>=20
>> 6. Decided not to change "unsigned long sp =3D (unsigned long)&sp" to
>>   current_stack_pointer. The original variant is more platform independen=
t
>>   since current_stack_pointer has different type on x86 and arm.
>>=20
>> Changes in v3
>>=20
>> 1. Added the detailed comments describing the STACKLEAK gcc plugin.
>>   Read the plugin from bottom up, like you do for Linux kernel drivers.
>>   Additional information:
>>    - gcc internals documentation, which is available from gcc sources;
>>    - wonderful slides by Diego Novillo
>>       https://www.airs.com/dnovillo/200711-GCC-Internals/
>>    - nice introduction to gcc plugins at LWN
>>       https://lwn.net/Articles/457543/
>>=20
>> 2. Improved the commit message and Kconfig description according the
>>   feedback from Kees Cook. Also added the original notice describing
>>   the performance impact of the STACKLEAK feature.
>>=20
>> 3. Removed arch-specific ix86_cmodel check from stackleak_track_stack_gat=
e().
>>   It caused skipping the kernel code instrumentation for i386.
>>=20
>> 4. Fixed a minor mistake in stackleak_tree_instrument_execute().
>>   First versions of the plugin used ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb=

>>   to get the basic block with the function prologue. That was not correct=

>>   since the control flow graph edge from the ENTRY_BLOCK_PTR doesn't alwa=
ys
>>   go to that basic block.
>>=20
>>   So later it was changed it to single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun))=
,
>>   but not completely. next_bb was still used for entry_bb assignment,
>>   which could cause the wrong value of the prologue_instrumented variable=
.
>>=20
>>   I've reported this issue to Grsecurity and proposed the fix for it, but=

>>   unfortunately didn't get any reply.
>>=20
>> 5. Introduced the STACKLEAK_POISON macro and renamed the config option
>>   according the feedback from Kees Cook.
>>=20
>>=20
>> Alexander Popov (3):
>>  gcc-plugins: Add STACKLEAK erasing the kernel stack at the end of
>>    syscalls
>>  lkdtm: Add a test for STACKLEAK
>>  doc: self-protection: Add information about STACKLEAK feature
>>=20
>> Documentation/security/self-protection.rst |  23 +-
>> arch/Kconfig                               |  39 +++
>> arch/x86/Kconfig                           |   1 +
>> arch/x86/entry/common.c                    |  17 +-
>> arch/x86/entry/entry_32.S                  |  69 +++++
>> arch/x86/entry/entry_64.S                  |  95 +++++++
>> arch/x86/entry/entry_64_compat.S           |   8 +
>> arch/x86/include/asm/processor.h           |   4 +
>> arch/x86/kernel/asm-offsets.c              |   9 +
>> arch/x86/kernel/dumpstack_32.c             |  12 +
>> arch/x86/kernel/dumpstack_64.c             |  15 ++
>> arch/x86/kernel/process_32.c               |   5 +
>> arch/x86/kernel/process_64.c               |   5 +
>> drivers/misc/Makefile                      |   3 +
>> drivers/misc/lkdtm.h                       |   4 +
>> drivers/misc/lkdtm_core.c                  |   2 +
>> drivers/misc/lkdtm_stackleak.c             | 139 ++++++++++
>> fs/exec.c                                  |  30 +++
>> include/linux/compiler.h                   |   4 +
>> scripts/Makefile.gcc-plugins               |   3 +
>> scripts/gcc-plugins/stackleak_plugin.c     | 397 ++++++++++++++++++++++++=
+++++
>> 21 files changed, 872 insertions(+), 12 deletions(-)
>> create mode 100644 drivers/misc/lkdtm_stackleak.c
>> create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
>>=20
>=20
> I tried this series with CVE-2017-14954 . That particular bug
> is not helped here because the poisoning has already been
> overwritten by other leaf functions. Given the call stack this
> may be a particularly bad case but I'm wondering how common
> this might be if we're only erasing at the end of a system
> call. One previous copy_to_user which has to go through the
> fault path can get fairly deep.
>=20

 On x86, the bad guys can force this is using 32-bit fast syscalls for *any*=
 syscall.  I suppose we could wipe the stack on the way out of exception han=
dlers, too...

OTOH, I think we should consider KASLR to be worthless against local attacke=
rs in general.  See all the papers on TSX timing leaks, etc.  It's a nice de=
fense against a limited class of remote attack.  And the plugin is still pla=
usibly useful to protect more serious  secrets.

> Thanks,
> Laura
