Date: Tue, 19 Dec 2017 08:16:14 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171218211614.GC19604@eros>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
 <1513554812-13014-4-git-send-email-me@tobin.cc>
 <20171218114947.2c11211a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218114947.2c11211a@gandalf.local.home>
Subject: [kernel-hardening] Re: [PATCH 3/3] trace: print address if symbol not found
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 18, 2017 at 11:49:47AM -0500, Steven Rostedt wrote:
> On Mon, 18 Dec 2017 10:53:32 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > Fixes behaviour modified by: commit bd6b239cdbb2 ("kallsyms: don't leak
> > address when symbol not found")
> > 
> > Previous patch changed behaviour of kallsyms function sprint_symbol() to
> > return an error code instead of printing the address if a symbol was not
> > found. Ftrace relies on the original behaviour. We should not break
> > tracing when applying the previous patch. We can maintain the original
> > behaviour by checking the return code on calls to sprint_symbol() and
> > friends.
> > 
> > Check return code and print actual address on error (i.e symbol not
> > found).
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> >  kernel/trace/trace.h             | 24 ++++++++++++++++++++++++
> >  kernel/trace/trace_events_hist.c |  6 +++---
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 2a6d0325a761..881b1a577d75 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -1814,4 +1814,28 @@ static inline void trace_event_eval_update(struct trace_eval_map **map, int len)
> >  
> >  extern struct trace_iterator *tracepoint_print_iter;
> >  
> > +static inline int
> > +trace_sprint_symbol(char *buffer, unsigned long address)
> > +{
> > +	int ret;
> > +
> > +	ret = sprint_symbol(buffer, address);
> > +	if (ret == -1)
> > +		ret = sprintf(buffer, "0x%lx", address);
> > +
> > +	return ret;
> > +}
> > +
> > +static inline int
> > +trace_sprint_symbol_no_offset(char *buffer, unsigned long address)
> > +{
> > +	int ret;
> > +
> > +	ret = sprint_symbol_no_offset(buffer, address);
> > +	if (ret == -1)
> > +		ret = sprintf(buffer, "0x%lx", address);
> > +
> > +	return ret;
> > +}
> > +
> >  #endif /* _LINUX_KERNEL_TRACE_H */
> > diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> > index 1e1558c99d56..3e28522a76f4 100644
> > --- a/kernel/trace/trace_events_hist.c
> > +++ b/kernel/trace/trace_events_hist.c
> > @@ -982,7 +982,7 @@ static void hist_trigger_stacktrace_print(struct seq_file *m,
> >  			return;
> >  
> >  		seq_printf(m, "%*c", 1 + spaces, ' ');
> > -		sprint_symbol(str, stacktrace_entries[i]);
> > +		trace_sprint_symbol_addr(str, stacktrace_entries[i]);
> 
> Hmm, where is trace_sprint_symbol_addr() defined?

Gee, seems I can't build a kernel and I can't read a diff - epic
fail. Sorry for wasting your time Steve I'll try to be more careful.

FTR This should have been 

-		sprint_symbol(str, stacktrace_entries[i]);
+		trace_sprint_symbol(str, stacktrace_entries[i]);

If you have the time to give me some brief pointers on how I should go
about testing this I'd love to test it before the next version. I know
very little about ftrace.

thanks,
Tobin.
