Date: Fri, 23 Nov 2018 17:06:38 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
Subject: Re: Investigating a stack state mismatch in Linux kernel
In-Reply-To: <57225f38-3f6d-4029-8f89-4b6eba97c3c1@linux.com>
Message-ID: <alpine.LNX.2.20.13.1811231634330.6732@monopod.intra.ispras.ru>
References: <b7aad232-76e1-241f-00e2-77783ce30f87@linux.com> <875zwyabac.fsf@oldenburg.str.redhat.com> <2a2b1181-2175-7e4e-189c-12630f43d10d@linux.com> <57225f38-3f6d-4029-8f89-4b6eba97c3c1@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexander Popov <alex.popov@linux.com>
Cc: Florian Weimer <fweimer@redhat.com>, Richard Sandiford <richard.sandiford@arm.com>, Segher Boessenkool <segher@kernel.crashing.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Alexei Starovoitov <ast@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S . Miller" <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Jann Horn <jannh@google.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, gcc@gcc.gnu.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, 21 Nov 2018, Alexander Popov wrote:

> Hello everyone!
> 
> At irc.freenode.org/#gcc people told me that I should CC gcc@gcc.gnu.org to get
> some attention of gcc developers.
> 
> Link to previous discussion:
>  https://www.openwall.com/lists/kernel-hardening/2018/11/14/1

So just for information, it isn't a plugin bug. I'll elaborate below, but in
short, objtool was complaining about unreachable code.  To be fair though,
gcc could have made the problem easier to spot.

Now for the details.

The repro uses an unusual (randomized) kernel config, in particular gcov is
enabled and NR_CPUS is 1. Thus we have

static int duplicate_processor_ids[] = {
        [0 ... 1 - 1] = -1,
};

and the compiler deduces that the loop in acpi_duplicate_processor_id does not
iterate:

bool acpi_duplicate_processor_id(int proc_id)
{
        int i;

        for (i = 0; i < nr_duplicate_ids; i++) {
                if (duplicate_processor_ids[i] == proc_id)
                        return true;
        }
        return false;
}

However as gcov is enabled, loop backedge remains, followed by gcov counter
increment and __builtin_unreachable() (on GIMPLE). On RTL, however, the basic
block with the increment ends with a barrier rtx, which is not visible in
assembly and looks just as if control flow falls through to a function exit.
Since the exit in question corresponds to a shrink-wrapped early exit that
does not push/pop registers, objtool complains.

Ultimately this is poor luck, if gcc optimized the code better or terminated
the block that-should-not-be-reached with ud2, it would not arise.

Alexander
