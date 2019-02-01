MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-16-thgarnie@chromium.org>
 <3a2bdc07-e8c4-c340-dde7-516ab0de66f2@intel.com>
In-Reply-To: <3a2bdc07-e8c4-c340-dde7-516ab0de66f2@intel.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 1 Feb 2019 09:35:00 -0800
Message-ID: <CAJcbSZEkc2Rc7uemA0Qw2uJhvNciLRxPrMVSQV_-O_N8zozZ_Q@mail.gmail.com>
Subject: Re: [PATCH v6 15/27] compiler: Option to default to hidden symbols
Content-Type: text/plain; charset="UTF-8"
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Thomas Garnier <thgarnie@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Jordan Borgner <mail@jordan-borgner.de>, Masami Hiramatsu <mhiramat@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jan Beulich <JBeulich@suse.com>, Song Liu <songliubraving@fb.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 1, 2019 at 12:24 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 31/01/19 9:24 PM, Thomas Garnier wrote:
> > Provide an option to default visibility to hidden except for key
> > symbols. This option is disabled by default and will be used by x86_64
> > PIE support to remove errors between compilation units.
> >
> > The default visibility is also enabled for external symbols that are
> > compared as they maybe equals (start/end of sections). In this case,
> > older versions of GCC will remove the comparison if the symbols are
> > hidden. This issue exists at least on gcc 4.9 and before.
>
> What does this mean, if anything, for what/how symbols appear in /proc/kallsyms?

No, they will still appear in kallsyms. Some symbols are not absolute
anymore or moved sections but still present.

-- 
Thomas
