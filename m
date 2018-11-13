Date: Mon, 12 Nov 2018 20:49:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] stackleak: Disable function tracing and kprobes for
 stackleak_erase()
Message-ID: <20181112204918.2ba39252@vmware.local.home>
In-Reply-To: <1542056928-10917-1-git-send-email-alex.popov@linux.com>
References: <1542056928-10917-1-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 13 Nov 2018 00:08:48 +0300
Alexander Popov <alex.popov@linux.com> wrote:

> The stackleak_erase() function is called on the trampoline stack at the end
> of syscall. This stack is not big enough for ftrace and kprobes operations,
> e.g. it can be exhausted if we use kprobe_events for stackleak_erase().
> 
> So let's disable function tracing and kprobes for stackleak_erase().
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
