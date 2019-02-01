Date: Fri, 1 Feb 2019 10:12:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v6 15/27] compiler: Option to default to hidden symbols
Message-ID: <20190201071259.GB14343@kadam>
References: <20190131192533.34130-1-thgarnie@chromium.org>
 <20190131192533.34130-16-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131192533.34130-16-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Thomas Garnier <thgarnie@google.com>, Jordan Borgner <mail@jordan-borgner.de>, Masami Hiramatsu <mhiramat@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jan Beulich <JBeulich@suse.com>, Song Liu <songliubraving@fb.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 11:24:22AM -0800, Thomas Garnier wrote:
> Provide an option to default visibility to hidden except for key
> symbols.

It took me a while to figure out the verb in this sentence...  :P

It's weird that we're annotating things to be default.  What visibility
are they we leave off the annotation?

regards,
dan carpenter
