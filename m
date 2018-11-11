Subject: Re: [PATCH 1/1] stackleak: Disable ftrace for stackleak.c
References: <1541887530-16610-1-git-send-email-alex.popov@linux.com>
 <20181110183011.2290fc20@gandalf.local.home>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <eeb7f5ee-1e2e-d37b-cca2-e0a29826e8eb@linux.com>
Date: Sun, 11 Nov 2018 13:19:45 +0300
MIME-Version: 1.0
In-Reply-To: <20181110183011.2290fc20@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 11.11.2018 2:30, Steven Rostedt wrote:
> On Sun, 11 Nov 2018 01:05:30 +0300
> Alexander Popov <alex.popov@linux.com> wrote:
> 
>> The stackleak_erase() function is called on the trampoline stack at the
>> end of syscall. This stack is not big enough for ftrace operations,
>> e.g. it can be overflowed if we enable kprobe_events for stackleak_erase().
> 
> Is the issue with kprobes or with function tracing? Because this stops
> function tracing which I only want disabled if function tracing itself
> is an issue, not for other things that may use the function tracing
> infrastructure.

Hello Steven,

I believe that stackleak erasing is not compatible with function tracing itself.
That's what the kernel testing robot has hit:
https://www.openwall.com/lists/kernel-hardening/2018/11/09/1

I used kprobe_events just to reproduce the problem:
https://www.openwall.com/lists/kernel-hardening/2018/11/09/4

Best regards,
Alexander
