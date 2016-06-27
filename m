Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrXYtQUtLU-wF5YCxY9ZfNCDMZo1614Tg+FhcybPnCj4kw@mail.gmail.com>
References: <cover.1466974736.git.luto@kernel.org> <9eeb4be3c4e91d4155d0c4c234858f4259c5993d.1466974736.git.luto@kernel.org>
 <CAMzpN2hO-c+dKF+TnEn8GzWVton_=_5jKCU7g6bFb=SC=hfnoA@mail.gmail.com> <CALCETrXYtQUtLU-wF5YCxY9ZfNCDMZo1614Tg+FhcybPnCj4kw@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Sun, 26 Jun 2016 20:36:10 -0400
Message-ID: <CAMzpN2jAh4MTdRHfOmG7F7QWjyVeuWj8cjDpCWx8j7hYbQtSjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 22/29] x86/asm: Move 'status' from struct thread_info
 to struct thread_struct
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 8:23 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, Jun 26, 2016 at 4:55 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> On Sun, Jun 26, 2016 at 5:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> Becuase sched.h and thread_info.h are a tangled mess, I turned
>>> in_compat_syscall into a macro.  If we had current_thread_struct()
>>> or similar and we could use it from thread_info.h, then this would
>>> be a bit cleaner.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>> ---
>>>  arch/x86/entry/common.c            |  4 ++--
>>>  arch/x86/include/asm/processor.h   | 12 ++++++++++++
>>>  arch/x86/include/asm/syscall.h     | 23 +++++------------------
>>>  arch/x86/include/asm/thread_info.h | 23 ++++-------------------
>>>  arch/x86/kernel/asm-offsets.c      |  1 -
>>>  arch/x86/kernel/fpu/init.c         |  1 -
>>>  arch/x86/kernel/process_64.c       |  4 ++--
>>>  arch/x86/kernel/ptrace.c           |  2 +-
>>>  8 files changed, 26 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>>> index ec138e538c44..c4150bec7982 100644
>>> --- a/arch/x86/entry/common.c
>>> +++ b/arch/x86/entry/common.c
>>> @@ -271,7 +271,7 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
>>>          * syscalls.  The fixup is exercised by the ptrace_syscall_32
>>>          * selftest.
>>>          */
>>> -       ti->status &= ~TS_COMPAT;
>>> +       current->thread.status &= ~TS_COMPAT;
>>>  #endif
>>>
>>>         user_enter();
>>> @@ -369,7 +369,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
>>>         unsigned int nr = (unsigned int)regs->orig_ax;
>>>
>>>  #ifdef CONFIG_IA32_EMULATION
>>> -       ti->status |= TS_COMPAT;
>>> +       current->thread.status |= TS_COMPAT;
>>>  #endif
>>>
>>>         if (READ_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY) {
>>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>>> index a2e20d6d01fe..a75e720f6402 100644
>>> --- a/arch/x86/include/asm/processor.h
>>> +++ b/arch/x86/include/asm/processor.h
>>> @@ -388,6 +388,9 @@ struct thread_struct {
>>>         unsigned short          fsindex;
>>>         unsigned short          gsindex;
>>>  #endif
>>> +
>>> +       u32                     status;         /* thread synchronous flags */
>>> +
>>>  #ifdef CONFIG_X86_32
>>>         unsigned long           ip;
>>>  #endif
>>> @@ -437,6 +440,15 @@ struct thread_struct {
>>>  };
>>>
>>>  /*
>>> + * Thread-synchronous status.
>>> + *
>>> + * This is different from the flags in that nobody else
>>> + * ever touches our thread-synchronous status, so we don't
>>> + * have to worry about atomic accesses.
>>> + */
>>> +#define TS_COMPAT              0x0002  /* 32bit syscall active (64BIT)*/
>>> +
>>> +/*
>>>   * Set IOPL bits in EFLAGS from given mask
>>>   */
>>>  static inline void native_set_iopl_mask(unsigned mask)
>>> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
>>> index 999b7cd2e78c..17229e7e2a1c 100644
>>> --- a/arch/x86/include/asm/syscall.h
>>> +++ b/arch/x86/include/asm/syscall.h
>>> @@ -60,7 +60,7 @@ static inline long syscall_get_error(struct task_struct *task,
>>>          * TS_COMPAT is set for 32-bit syscall entries and then
>>>          * remains set until we return to user mode.
>>>          */
>>> -       if (task_thread_info(task)->status & TS_COMPAT)
>>> +       if (task->thread.status & TS_COMPAT)
>>>                 /*
>>>                  * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
>>>                  * and will match correctly in comparisons.
>>> @@ -116,7 +116,7 @@ static inline void syscall_get_arguments(struct task_struct *task,
>>>                                          unsigned long *args)
>>>  {
>>>  # ifdef CONFIG_IA32_EMULATION
>>> -       if (task_thread_info(task)->status & TS_COMPAT)
>>> +       if (task->thread.status & TS_COMPAT)
>>>                 switch (i) {
>>>                 case 0:
>>>                         if (!n--) break;
>>> @@ -177,7 +177,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
>>>                                          const unsigned long *args)
>>>  {
>>>  # ifdef CONFIG_IA32_EMULATION
>>> -       if (task_thread_info(task)->status & TS_COMPAT)
>>> +       if (task->thread.status & TS_COMPAT)
>>>                 switch (i) {
>>>                 case 0:
>>>                         if (!n--) break;
>>> @@ -234,21 +234,8 @@ static inline void syscall_set_arguments(struct task_struct *task,
>>>
>>>  static inline int syscall_get_arch(void)
>>>  {
>>> -#ifdef CONFIG_IA32_EMULATION
>>> -       /*
>>> -        * TS_COMPAT is set for 32-bit syscall entry and then
>>> -        * remains set until we return to user mode.
>>> -        *
>>> -        * TIF_IA32 tasks should always have TS_COMPAT set at
>>> -        * system call time.
>>> -        *
>>> -        * x32 tasks should be considered AUDIT_ARCH_X86_64.
>>> -        */
>>> -       if (task_thread_info(current)->status & TS_COMPAT)
>>> -               return AUDIT_ARCH_I386;
>>> -#endif
>>> -       /* Both x32 and x86_64 are considered "64-bit". */
>>> -       return AUDIT_ARCH_X86_64;
>>> +       /* x32 tasks should be considered AUDIT_ARCH_X86_64. */
>>> +       return in_ia32_syscall() ? AUDIT_ARCH_I386 : AUDIT_ARCH_X86_64;
>>>  }
>>>  #endif /* CONFIG_X86_32 */
>>>
>>> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
>>> index b45ffdda3549..7b42c1e462ac 100644
>>> --- a/arch/x86/include/asm/thread_info.h
>>> +++ b/arch/x86/include/asm/thread_info.h
>>> @@ -55,7 +55,6 @@ struct task_struct;
>>>  struct thread_info {
>>>         struct task_struct      *task;          /* main task structure */
>>>         __u32                   flags;          /* low level flags */
>>> -       __u32                   status;         /* thread synchronous flags */
>>>         __u32                   cpu;            /* current CPU */
>>>  };
>>>
>>> @@ -211,28 +210,14 @@ static inline unsigned long current_stack_pointer(void)
>>>
>>>  #endif
>>>
>>> -/*
>>> - * Thread-synchronous status.
>>> - *
>>> - * This is different from the flags in that nobody else
>>> - * ever touches our thread-synchronous status, so we don't
>>> - * have to worry about atomic accesses.
>>> - */
>>> -#define TS_COMPAT              0x0002  /* 32bit syscall active (64BIT)*/
>>> -
>>>  #ifndef __ASSEMBLY__
>>>
>>> -static inline bool in_ia32_syscall(void)
>>> -{
>>>  #ifdef CONFIG_X86_32
>>> -       return true;
>>> -#endif
>>> -#ifdef CONFIG_IA32_EMULATION
>>> -       if (current_thread_info()->status & TS_COMPAT)
>>> -               return true;
>>> +#define in_ia32_syscall() true
>>> +#else
>>> +#define in_ia32_syscall() (IS_ENABLED(CONFIG_IA32_EMULATION) && \
>>> +                          current->thread.status & TS_COMPAT)
>>>  #endif
>>> -       return false;
>>> -}
>>>
>>>  /*
>>>   * Force syscall return via IRET by making it look as if there was
>>> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
>>> index 2bd5c6ff7ee7..a91a6ead24a2 100644
>>> --- a/arch/x86/kernel/asm-offsets.c
>>> +++ b/arch/x86/kernel/asm-offsets.c
>>> @@ -30,7 +30,6 @@
>>>  void common(void) {
>>>         BLANK();
>>>         OFFSET(TI_flags, thread_info, flags);
>>> -       OFFSET(TI_status, thread_info, status);
>>
>> TI_status can be deleted.  It's last users were removed in commit ee08c6bd.
>
> Indeed.
>
> Just to double-check: are you saying that this patch is okay?

It looks OK to me, but I haven't tested it.  Another suggestion is to
change the compat flag to a bitfield, since there is only one TS_*
flag now and it's not referenced from asm.

--
Brian Gerst
