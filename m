From: Alexander Popov <alex.popov@linux.com>
Subject: Investigating a stack state mismatch in Linux kernel
Message-ID: <b7aad232-76e1-241f-00e2-77783ce30f87@linux.com>
Date: Wed, 14 Nov 2018 21:24:28 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Alexei Starovoitov <ast@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S . Miller" <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Florian Weimer <fweimer@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, gcc-bugs@gcc.gnu.org, gcc-help@gcc.gnu.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello everyone!

I'm investigating an interesting issue with gcc-5 compilation of Linux kernel,
which is triggered by stackleak gcc plugin.

I would really appreciate any help (especially from gcc experts)!


The kbuild test robot reported a build warning for some special kernel config:
https://lists.01.org/pipermail/kbuild-all/2018-November/054567.html

drivers/acpi/acpi_processor.o: warning: objtool:
acpi_duplicate_processor_id()+0x49: stack state mismatch: cfa1=7+8 cfa2=6+16

The compiler misses pop instructions at the end of the function for some
execution path. That makes the frame pointer state inconsistent.

I can reproduce this issue for gcc 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.10). The
newer gcc 7.3.0 (Ubuntu 7.3.0-16ubuntu3) doesn't make this mistake.

This bug happens after stackleak gcc plugin worked with RTL representation of
the code. This plugin registers the 'stackleak_cleanup' pass after the 'reload'
pass, when the stack frame size is final. The plugin does a simple thing: it
removes the stackleak_track_stack() call from the functions with a small stack
frame, it uses delete_insn_and_edges() to do that.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d6bb6adb714b133db92ccd4bfc9c20f75f71f3f

But after this CALL insn is deleted, gcc-5 misses the pop instruction during RTL
optimization :/


The compiled C function is not complicated:

bool acpi_duplicate_processor_id(int proc_id)
{
	int i;

	/*
	 * compare the proc_id with duplicate IDs, if the proc_id is already
	 * in the duplicate IDs, return true, otherwise, return false.
	 */
	for (i = 0; i < nr_duplicate_ids; i++) {
		if (duplicate_processor_ids[i] == proc_id)
			return true;
	}
	return false;
}


Let me show you asm listings.

1. GCC-5: without removing stackleak_track_stack() call, stack frame pointer is
consistent.

ffffffff8144a170 <acpi_duplicate_processor_id>:
ffffffff8144a170:	53                   	push   %rbx
ffffffff8144a171:	89 fb                	mov    %edi,%ebx
ffffffff8144a173:	e8 88 33 d2 ff       	callq  ffffffff8116d500
ffffffff8144a178:	8b 15 e6 68 46 02    	mov    0x24668e6(%rip),%edx
ffffffff8144a17e:	48 83 05 9a 68 46 02 	addq   $0x1,0x246689a(%rip)
ffffffff8144a185:	01
ffffffff8144a186:	85 d2                	test   %edx,%edx
ffffffff8144a188:	7e 32                	jle    ffffffff8144a1bc
ffffffff8144a18a:	48 8b 05 9f 68 46 02 	mov    0x246689f(%rip),%rax
ffffffff8144a191:	3b 1d d1 99 19 01    	cmp    0x11999d1(%rip),%ebx
ffffffff8144a197:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffffffff8144a19b:	48 89 0d 8e 68 46 02 	mov    %rcx,0x246688e(%rip)
ffffffff8144a1a2:	74 1c                	je     ffffffff8144a1c0
ffffffff8144a1a4:	48 83 05 7c 68 46 02 	addq   $0x1,0x246687c(%rip)
ffffffff8144a1ab:	01
ffffffff8144a1ac:	83 fa 01             	cmp    $0x1,%edx
ffffffff8144a1af:	74 0b                	je     ffffffff8144a1bc
ffffffff8144a1b1:	48 83 c0 02          	add    $0x2,%rax
ffffffff8144a1b5:	48 89 05 74 68 46 02 	mov    %rax,0x2466874(%rip)
ffffffff8144a1bc:	31 c0                	xor    %eax,%eax
ffffffff8144a1be:	5b                   	pop    %rbx
ffffffff8144a1bf:	c3                   	retq
ffffffff8144a1c0:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff8144a1c5:	5b                   	pop    %rbx
ffffffff8144a1c6:	c3                   	retq

2. GCC-5: with removed stackleak_track_stack() call, stack frame pointer IS NOT
consistent.

ffffffff8144a170 <acpi_duplicate_processor_id>:
ffffffff8144a170:	8b 15 ee 68 46 02    	mov    0x24668ee(%rip),%edx
ffffffff8144a176:	48 83 05 a2 68 46 02 	addq   $0x1,0x24668a2(%rip)
ffffffff8144a17d:	01
ffffffff8144a17e:	85 d2                	test   %edx,%edx
ffffffff8144a180:	7e 33                	jle    ffffffff8144a1b5
ffffffff8144a182:	48 8b 05 a7 68 46 02 	mov    0x24668a7(%rip),%rax
ffffffff8144a189:	3b 3d d9 99 19 01    	cmp    0x11999d9(%rip),%edi
ffffffff8144a18f:	53                   	push   %rbx
ffffffff8144a190:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffffffff8144a194:	48 89 0d 95 68 46 02 	mov    %rcx,0x2466895(%rip)
ffffffff8144a19b:	74 1f                	je     ffffffff8144a1bc
ffffffff8144a19d:	48 83 05 83 68 46 02 	addq   $0x1,0x2466883(%rip)
ffffffff8144a1a4:	01
ffffffff8144a1a5:	83 fa 01             	cmp    $0x1,%edx
ffffffff8144a1a8:	74 0e                	je     ffffffff8144a1b8
ffffffff8144a1aa:	48 83 c0 02          	add    $0x2,%rax
ffffffff8144a1ae:	48 89 05 7b 68 46 02 	mov    %rax,0x246687b(%rip)
ffffffff8144a1b5:	31 c0                	xor    %eax,%eax
ffffffff8144a1b7:	c3                   	retq # BUG HERE! POP IS ABSENT!
ffffffff8144a1b8:	31 c0                	xor    %eax,%eax
ffffffff8144a1ba:	5b                   	pop    %rbx
ffffffff8144a1bb:	c3                   	retq
ffffffff8144a1bc:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff8144a1c1:	5b                   	pop    %rbx
ffffffff8144a1c2:	c3                   	retq

3. GCC-7: with removed stackleak_track_stack() call, stack frame pointer is
consistent, NO BUG.

ffffffff8144be60 <acpi_duplicate_processor_id>:
ffffffff8144be60:	8b 15 3e d5 44 02    	mov    0x244d53e(%rip),%edx
ffffffff8144be66:	48 83 05 f2 d4 44 02 	addq   $0x1,0x244d4f2(%rip)
ffffffff8144be6d:	01
ffffffff8144be6e:	85 d2                	test   %edx,%edx
ffffffff8144be70:	7e 3e                	jle    ffffffff8144beb0
ffffffff8144be72:	48 8b 05 f7 d4 44 02 	mov    0x244d4f7(%rip),%rax
ffffffff8144be79:	3b 3d e9 79 19 01    	cmp    0x11979e9(%rip),%edi
ffffffff8144be7f:	53                   	push   %rbx
ffffffff8144be80:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffffffff8144be84:	48 89 0d e5 d4 44 02 	mov    %rcx,0x244d4e5(%rip)
ffffffff8144be8b:	74 1c                	je     ffffffff8144bea9
ffffffff8144be8d:	48 83 05 d3 d4 44 02 	addq   $0x1,0x244d4d3(%rip)
ffffffff8144be94:	01
ffffffff8144be95:	83 fa 01             	cmp    $0x1,%edx
ffffffff8144be98:	74 0b                	je     ffffffff8144bea5
ffffffff8144be9a:	48 83 c0 02          	add    $0x2,%rax
ffffffff8144be9e:	48 89 05 cb d4 44 02 	mov    %rax,0x244d4cb(%rip)
ffffffff8144bea5:	31 c0                	xor    %eax,%eax
ffffffff8144bea7:	5b                   	pop    %rbx
ffffffff8144bea8:	c3                   	retq
ffffffff8144bea9:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff8144beae:	5b                   	pop    %rbx
ffffffff8144beaf:	c3                   	retq
ffffffff8144beb0:	31 c0                	xor    %eax,%eax
ffffffff8144beb2:	c3                   	retq


Of course, there is a naive solution for this issue -- just skip stackleak
instrumentation for acpi_duplicate_processor_id(). But it would be great to find
out the reasons behind this compiler behavior. It might help to create a better
solution.

Right now I don't have answers for the following questions:
  1. Which gcc patch fixed this error in RTL optimization?
  2. What is so special about acpi_duplicate_processor_id(), that triggers this
bug? Maybe we can determine that particular feature of C code and skip the
instrumentation for all similar functions?
  3. Can stackleak plugin mitigate this bug in gcc-5? Maybe we can register this
pass to work with RTL later, after the buggy optimization?


I would really appreciate your help!

Best regards,
Alexander
