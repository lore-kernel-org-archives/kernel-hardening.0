MIME-Version: 1.0
In-Reply-To: <e902f017-43f3-2532-69ad-3cdfca6d75c8@linux.com>
References: <5be58a6e.w0IbLdKsiRknTygq%lkp@intel.com> <CAG48ez2xSLFGjMYSYJTLwEnZoZJuXUfdoCp6_vGrywBU4SQNkQ@mail.gmail.com>
 <2B681F10-752C-4327-9960-3987CE17A619@amacapital.net> <e902f017-43f3-2532-69ad-3cdfca6d75c8@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 9 Nov 2018 17:21:56 -0600
Message-ID: <CAGXu5jKZf7-E1SQArgZKVp716OdJmUB2_h5=ZiJXO=Y0C0UBsg@mail.gmail.com>
Subject: Re: afaef01c00 ("x86/entry: Add STACKLEAK erasing the kernel stack
 .."): double fault: 0000 [#1]
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, LKP <lkp@01.org>, kbuild test robot <lkp@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 9, 2018 at 5:09 PM, Alexander Popov <alex.popov@linux.com> wrot=
e:
>
> On 09.11.2018 23:46, Andy Lutomirski wrote:
>>> On Nov 9, 2018, at 12:06 PM, Jann Horn <jannh@google.com> wrote:
>>>
>>> +Andy, Thomas, Ingo
>>>
>>>> On Fri, Nov 9, 2018 at 2:24 PM kernel test robot <lkp@intel.com> wrote=
:
>>>> 0day kernel testing robot got the below dmesg and the first bad commit=
 is
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git mas=
ter
>>>>
>>>> commit afaef01c001537fa97a25092d7f54d764dc7d8c1
>>>> Author:     Alexander Popov <alex.popov@linux.com>
>>>> AuthorDate: Fri Aug 17 01:16:58 2018 +0300
>>>> Commit:     Kees Cook <keescook@chromium.org>
>>>> CommitDate: Tue Sep 4 10:35:47 2018 -0700
>>>>
>>>>    x86/entry: Add STACKLEAK erasing the kernel stack at the end of sys=
calls
>>> [...]
>>>> [  127.808225] double fault: 0000 [#1]
>>>> [  127.808695] CPU: 0 PID: 414 Comm: trinity-main Tainted: G          =
      T 4.19.0-rc2-00001-gafaef01 #1
>>>> [  127.809799] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS 1.10.2-1 04/01/2014
>>>> [  127.810760] RIP: 0010:ftrace_ops_test+0x27/0xa0
>>>> [  127.811289] Code: eb 9a 90 41 54 55 49 89 f4 53 48 89 d3 48 89 fd 4=
8 81 ec b0 00 00 00 65 48 8b 04 25 28 00 00 00 48 89 84 24 a8 00 00 00 31 c=
0 <e8> 54 df ff ff 48 85 db 74 57 e8 4a df ff ff 48 8b 85 d0 00 00 00
>>>> [  127.813385] RSP: 0018:fffffe0000001fb8 EFLAGS: 00010046
>>> [...]
>>>> [  127.819762] CR2: fffffe0000001fa8 CR3: 000000001579a000 CR4: 000000=
00000006b0
>>> [...]
>>>> [  127.822234] Call Trace:
>>>> [  127.822530]  <ENTRY_TRAMPOLINE>
>>>> [  127.822914]  ? __ia32_sys_rseq+0x2f0/0x2f0
>>>> [  127.823395]  ftrace_ops_list_func+0xa5/0x1b0
>>>> [  127.823922]  ftrace_call+0x5/0x34
>>>> [  127.824318]  ? stackleak_erase+0x5/0xf0
>>>> [  127.824789]  ? stackleak_erase+0x43/0xf0
>>>> [  127.825260]  stackleak_erase+0x5/0xf0
>>>> [  127.825699]  syscall_return_via_sysret+0x61/0x81
>>>> [  127.826238] WARNING: stack recursion on stack type 4
>>>> [  127.826243] WARNING: can't dereference registers at (____ptrval____=
) for ip syscall_return_via_sysret+0x61/0x81
>>>> [  127.826246]  </ENTRY_TRAMPOLINE>
>>>> [  127.828342] ---[ end trace e9f96d3f45575499 ]---
>>>> [  127.828911] RIP: 0010:ftrace_ops_test+0x27/0xa0
>>>
>>> CR2: fffffe0000001fa8, RSP: 0018:fffffe0000001fb8; this is a pagefault
>>> on the stack. fffffe0000000000 is CPU_ENTRY_AREA_RO_IDT;
>>> fffffe0000001000 is CPU_ENTRY_AREA_PER_CPU; so fffffe0000002000 is the
>>> page with the entry stack for cpu 0, and you overflowed from that into
>>> the readonly gdt at fffffe0000001000, which doubles as a guard page
>>> for the entry stack:
>>>
>>> struct cpu_entry_area {
>>>        char gdt[PAGE_SIZE];
>>>
>>>        /*
>>>         * The GDT is just below entry_stack and thus serves (on x86_64)=
 as
>>>         * a a read-only guard page.
>>>         */
>>>        struct entry_stack_page entry_stack_page;
>>> [...]
>>> };
>>>
>>> In other words: You're calling C code on the entry trampoline stack;
>>> this C code can call into ftrace; and the entry trampoline stack isn't
>>> big enough for ftrace shenanigans. I think you probably shouldn't be
>>> calling C code on the entry stack, but maybe one of the X86 folks has
>>> a different opinion?
>>
>> My opinion was that, on x86_32, the entry stack ought to be fairly large=
 so
>> that NMIs could execute on the entry stack.  I don=E2=80=99t remember wh=
at the code
>> actually does, though.
>>
>> But stackleak_erase should probably not run on the entry stack. That see=
ms
>> like it=E2=80=99s just asking for trouble.
>
> Hello Jann and Andy,
>
>
> The stackleak_erase() function is called on the trampoline stack at the e=
nd of
> syscall, it erases the used part of the kernel thread stack after the sys=
call is
> handled.
>
>
> I've reproduced such a double fault with function tracing for stackleak_e=
rase():
>
>   # mount -t tracefs nodev /sys/kernel/tracing
>   # echo 'p:myprobe stackleak_erase' > /sys/kernel/debug/tracing/kprobe_e=
vents
>   # echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable
>
>
> I think we should simply not allow function tracing for stackleak_*() fun=
ctions:
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 7343b3a..0906f6d 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_MULTIUSER) +=3D groups.o
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace internal ftrace files
>  CFLAGS_REMOVE_irq_work.o =3D $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_stackleak.o =3D $(CC_FLAGS_FTRACE)
>  endif

Yeah, that's what I was suspecting on IRC. This looks like the right
fix. Can you send that to me as a "regular" patch with changelog, etc,
and I'll send it up to Linus.

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for everyone's attention on this! I've been travelling this
week, so I've been a little slow. :)

-Kees

>
>
> With this patch setting kprobe event for stackleak_erase() is not allowed=
. This
> is the corresponding dmesg output:
>   [   75.660478] trace_kprobe: Could not probe notrace function stackleak=
_erase
>
>
> If you agree, I'll prepare the patch for LKML.
>
> Best regards,
> Alexander



--=20
Kees Cook
