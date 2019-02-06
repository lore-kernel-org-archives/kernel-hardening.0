Date: Wed, 6 Feb 2019 11:23:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 16/17] Plug in new special vfree flag
Message-ID: <20190206112356.64cc5f0d@gandalf.local.home>
In-Reply-To: <20190117003259.23141-17-rick.p.edgecombe@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	<20190117003259.23141-17-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <mhiramat@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Jessica Yu <jeyu@kernel.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 16 Jan 2019 16:32:58 -0800
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> Add new flag for handling freeing of special permissioned memory in vmalloc
> and remove places where memory was set RW before freeing which is no longer
> needed.
> 
> In kprobes, bpf and ftrace this just adds the flag, and removes the now
> unneeded set_memory_ calls before calling vfree.
> 
> In modules, the freeing of init sections is moved to a work queue, since
> freeing of RO memory is not supported in an interrupt by vmalloc.
> Instead of call_rcu, it now uses synchronize_rcu() in the work queue.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.ibm.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/ftrace.c       |  6 +--

For the ftrace code.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

>  arch/x86/kernel/kprobes/core.c |  7 +---
>  include/linux/filter.h         | 16 ++-----
>  kernel/bpf/core.c              |  1 -
>  kernel/module.c                | 77 +++++++++++++++++-----------------
>  5 files changed, 45 insertions(+), 62 deletions(-)
>
