Date: Mon, 12 Nov 2018 11:52:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] stackleak: Disable ftrace for stackleak.c
Message-ID: <20181112115228.1c747426@vmware.local.home>
In-Reply-To: <97842534.3842.1542034409326.JavaMail.zimbra@efficios.com>
References: <1541887530-16610-1-git-send-email-alex.popov@linux.com>
	<20181110183011.2290fc20@gandalf.local.home>
	<eeb7f5ee-1e2e-d37b-cca2-e0a29826e8eb@linux.com>
	<20181111205351.1874bb1e@vmware.local.home>
	<20181112115058.39e98750750c91eeb349cfdf@kernel.org>
	<97842534.3842.1542034409326.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 12 Nov 2018 09:53:29 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> Just to clarify: AFAIU you guys are recommending to add _both_ a "notrace"
> annotation to stackleak_erase() _and_ a NOKPROBE_SYMBOL(stackleak_erase),
> so neither function tracing nor kprobes can hook on that function.

Correct.

-- Steve
