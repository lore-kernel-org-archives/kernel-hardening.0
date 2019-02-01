Subject: Re: [PATCH v6 15/27] compiler: Option to default to hidden symbols
References: <20190131192533.34130-1-thgarnie@chromium.org>
 <20190131192533.34130-16-thgarnie@chromium.org>
From: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <3a2bdc07-e8c4-c340-dde7-516ab0de66f2@intel.com>
Date: Fri, 1 Feb 2019 10:22:22 +0200
MIME-Version: 1.0
In-Reply-To: <20190131192533.34130-16-thgarnie@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@chromium.org>, kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Thomas Garnier <thgarnie@google.com>, Jordan Borgner <mail@jordan-borgner.de>, Masami Hiramatsu <mhiramat@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jan Beulich <JBeulich@suse.com>, Song Liu <songliubraving@fb.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 31/01/19 9:24 PM, Thomas Garnier wrote:
> Provide an option to default visibility to hidden except for key
> symbols. This option is disabled by default and will be used by x86_64
> PIE support to remove errors between compilation units.
> 
> The default visibility is also enabled for external symbols that are
> compared as they maybe equals (start/end of sections). In this case,
> older versions of GCC will remove the comparison if the symbols are
> hidden. This issue exists at least on gcc 4.9 and before.

What does this mean, if anything, for what/how symbols appear in /proc/kallsyms?
