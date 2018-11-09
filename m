Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: afaef01c00 ("x86/entry: Add STACKLEAK erasing the kernel stack .."): double fault: 0000 [#1]
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAG48ez2xSLFGjMYSYJTLwEnZoZJuXUfdoCp6_vGrywBU4SQNkQ@mail.gmail.com>
Date: Fri, 9 Nov 2018 12:46:29 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B681F10-752C-4327-9960-3987CE17A619@amacapital.net>
References: <5be58a6e.w0IbLdKsiRknTygq%lkp@intel.com> <CAG48ez2xSLFGjMYSYJTLwEnZoZJuXUfdoCp6_vGrywBU4SQNkQ@mail.gmail.com>
To: Jann Horn <jannh@google.com>, Joerg Roedel <joro@8bytes.org>
Cc: alex.popov@linux.com, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, lkp@01.org, lkp@intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-doc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>



> On Nov 9, 2018, at 12:06 PM, Jann Horn <jannh@google.com> wrote:
>=20
> +Andy, Thomas, Ingo
>=20
>> On Fri, Nov 9, 2018 at 2:24 PM kernel test robot <lkp@intel.com> wrote:
>> 0day kernel testing robot got the below dmesg and the first bad commit is=

>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master=

>>=20
>> commit afaef01c001537fa97a25092d7f54d764dc7d8c1
>> Author:     Alexander Popov <alex.popov@linux.com>
>> AuthorDate: Fri Aug 17 01:16:58 2018 +0300
>> Commit:     Kees Cook <keescook@chromium.org>
>> CommitDate: Tue Sep 4 10:35:47 2018 -0700
>>=20
>>    x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscal=
ls
> [...]
>> [  127.808225] double fault: 0000 [#1]
>> [  127.808695] CPU: 0 PID: 414 Comm: trinity-main Tainted: G             =
   T 4.19.0-rc2-00001-gafaef01 #1
>> [  127.809799] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.10.2-1 04/01/2014
>> [  127.810760] RIP: 0010:ftrace_ops_test+0x27/0xa0
>> [  127.811289] Code: eb 9a 90 41 54 55 49 89 f4 53 48 89 d3 48 89 fd 48 8=
1 ec b0 00 00 00 65 48 8b 04 25 28 00 00 00 48 89 84 24 a8 00 00 00 31 c0 <e=
8> 54 df ff ff 48 85 db 74 57 e8 4a df ff ff 48 8b 85 d0 00 00 00
>> [  127.813385] RSP: 0018:fffffe0000001fb8 EFLAGS: 00010046
> [...]
>> [  127.819762] CR2: fffffe0000001fa8 CR3: 000000001579a000 CR4: 000000000=
00006b0
> [...]
>> [  127.822234] Call Trace:
>> [  127.822530]  <ENTRY_TRAMPOLINE>
>> [  127.822914]  ? __ia32_sys_rseq+0x2f0/0x2f0
>> [  127.823395]  ftrace_ops_list_func+0xa5/0x1b0
>> [  127.823922]  ftrace_call+0x5/0x34
>> [  127.824318]  ? stackleak_erase+0x5/0xf0
>> [  127.824789]  ? stackleak_erase+0x43/0xf0
>> [  127.825260]  stackleak_erase+0x5/0xf0
>> [  127.825699]  syscall_return_via_sysret+0x61/0x81
>> [  127.826238] WARNING: stack recursion on stack type 4
>> [  127.826243] WARNING: can't dereference registers at (____ptrval____) f=
or ip syscall_return_via_sysret+0x61/0x81
>> [  127.826246]  </ENTRY_TRAMPOLINE>
>> [  127.828342] ---[ end trace e9f96d3f45575499 ]---
>> [  127.828911] RIP: 0010:ftrace_ops_test+0x27/0xa0
>=20
> CR2: fffffe0000001fa8, RSP: 0018:fffffe0000001fb8; this is a pagefault
> on the stack. fffffe0000000000 is CPU_ENTRY_AREA_RO_IDT;
> fffffe0000001000 is CPU_ENTRY_AREA_PER_CPU; so fffffe0000002000 is the
> page with the entry stack for cpu 0, and you overflowed from that into
> the readonly gdt at fffffe0000001000, which doubles as a guard page
> for the entry stack:
>=20
> struct cpu_entry_area {
>        char gdt[PAGE_SIZE];
>=20
>        /*
>         * The GDT is just below entry_stack and thus serves (on x86_64) as=

>         * a a read-only guard page.
>         */
>        struct entry_stack_page entry_stack_page;
> [...]
> };
>=20
> In other words: You're calling C code on the entry trampoline stack;
> this C code can call into ftrace; and the entry trampoline stack isn't
> big enough for ftrace shenanigans. I think you probably shouldn't be
> calling C code on the entry stack, but maybe one of the X86 folks has
> a different opinion?

My opinion was that, on x86_32, the entry stack ought to be fairly large so t=
hat NMIs could execute on the entry stack.  I don=E2=80=99t remember what th=
e code actually does, though.

But stackleak_erase should probably not run on the entry stack. That seems l=
ike it=E2=80=99s just asking for trouble.=
