Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jul 2011 19:06:58 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110723150658.GA11156@openwall.com>
References: <20110718194803.GA5337@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718194803.GA5337@albatros>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy, Eugene -

I started looking into this, and here's what I found in RHEL 5 kernels:

kernel/sysctl.c:

int exec_shield = (1<<0);
/* exec_shield is a bitmask:
          0: off; vdso at STACK_TOP, 1 page below TASK_SIZE
   (1<<0) 1: on [also on if !=0]
   (1<<1) 2: force noexecstack regardless of PT_GNU_STACK
   The old settings
   (1<<2) 4: vdso just below .text of main (unless too low)
   (1<<3) 8: vdso just below .text of PT_INTERP (unless too low)
   are ignored because the vdso is placed completely randomly
*/

fs/binfmt_elf.c:

	if (current->personality == PER_LINUX && (exec_shield & 2)) {
		executable_stack = EXSTACK_DISABLE_X;
		current->flags |= PF_RANDOMIZE;
	}
[...]
	if (!(exec_shield & 2) &&
			elf_read_implies_exec(loc->elf_ex, executable_stack))
		current->personality |= READ_IMPLIES_EXEC;

So it appears that setting exec_shield to 3 on these kernels would do
almost what we need.  It could make sense to consider this existing
configuration mechanism for whatever patch we propose for mainline.

(I was not aware of this feature in RHEL 5 before.)

Thanks,

Alexander
