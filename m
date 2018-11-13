Date: Tue, 13 Nov 2018 10:21:45 -0800
From: Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 1/1] stackleak: Disable ftrace for stackleak.c
Message-Id: <20181113102145.2274aedc6f9edaba681bfd3a@kernel.org>
In-Reply-To: <20181112122148.0fab4c7f@vmware.local.home>
References: <1541887530-16610-1-git-send-email-alex.popov@linux.com>
	<20181110183011.2290fc20@gandalf.local.home>
	<eeb7f5ee-1e2e-d37b-cca2-e0a29826e8eb@linux.com>
	<20181111205351.1874bb1e@vmware.local.home>
	<20181112115058.39e98750750c91eeb349cfdf@kernel.org>
	<31b45d77-7b49-3984-a1e5-17993f50eee3@linux.com>
	<20181112122148.0fab4c7f@vmware.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexander Popov <alex.popov@linux.com>, Masami Hiramatsu <mhiramat@kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 12 Nov 2018 12:21:48 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 12 Nov 2018 19:51:00 +0300
> Alexander Popov <alex.popov@linux.com> wrote:
> 
> > By the way, are there any other tracing/instrumentation mechanisms that should
> > be disabled?
> 
> ftrace and kprobes are pretty much the only ones that currently do self
> modification of code all over the kernel. Kprobes even more so than
> ftrace.

Right, since kprobes uses int3 or sw breakpoint exception for hooking into
the code, it consumes stack much more.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
