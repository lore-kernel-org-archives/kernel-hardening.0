From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Investigating a stack state mismatch in Linux kernel
References: <b7aad232-76e1-241f-00e2-77783ce30f87@linux.com>
Date: Thu, 15 Nov 2018 11:24:27 +0100
In-Reply-To: <b7aad232-76e1-241f-00e2-77783ce30f87@linux.com> (Alexander
	Popov's message of "Wed, 14 Nov 2018 21:24:28 +0300")
Message-ID: <875zwyabac.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Alexei Starovoitov <ast@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S . Miller" <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, gcc-bugs@gcc.gnu.org, gcc-help@gcc.gnu.org
List-ID: <kernel-hardening.lists.openwall.com>

* Alexander Popov:

> Of course, there is a naive solution for this issue -- just skip stackleak
> instrumentation for acpi_duplicate_processor_id(). But it would be great to find
> out the reasons behind this compiler behavior. It might help to create a better
> solution.

Please show us the RTL dumps with both compilers, both before and after
the plugin pass.

Thanks,
Florian
