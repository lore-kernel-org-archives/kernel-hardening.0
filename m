Date: Mon, 18 Dec 2017 18:51:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171218185143.4046a71b@gandalf.local.home>
In-Reply-To: <20171218211614.GC19604@eros>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
	<1513554812-13014-4-git-send-email-me@tobin.cc>
	<20171218114947.2c11211a@gandalf.local.home>
	<20171218211614.GC19604@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] trace: print address if symbol not found
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 19 Dec 2017 08:16:14 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> > >  #endif /* _LINUX_KERNEL_TRACE_H */
> > > diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> > > index 1e1558c99d56..3e28522a76f4 100644
> > > --- a/kernel/trace/trace_events_hist.c
> > > +++ b/kernel/trace/trace_events_hist.c
> > > @@ -982,7 +982,7 @@ static void hist_trigger_stacktrace_print(struct seq_file *m,
> > >  			return;
> > >  
> > >  		seq_printf(m, "%*c", 1 + spaces, ' ');
> > > -		sprint_symbol(str, stacktrace_entries[i]);
> > > +		trace_sprint_symbol_addr(str, stacktrace_entries[i]);  
> > 

> 
> If you have the time to give me some brief pointers on how I should go
> about testing this I'd love to test it before the next version. I know
> very little about ftrace.

For hitting the histogram stacktrace trigger (this code path), make
sure you have CONFIG_HIST_TRIGGERS enabled. And then do:

 # cd /sys/kernel/debug/tracing
 # echo 'hist:keys=common_pid.execname,stacktrace:vals=prev_state' > \
     events/sched/sched_switch/trigger
 # cat events/sched/sched_switch/hist

For the "sym" part, you can do (from the same directory):

 # echo 'hist:keys=call_site.sym:vals=bytes_req' > \
     events/kmem/kmalloc/trigger
 # cat events/kmem/kmalloc/hist


And for sym-offset:

 # echo 'hist:keys=call_site.sym-offset:vals=bytes_req' > \
    events/kmem/kmalloc/trigger
 # cat events/kmem/kmalloc/hist

-- Steve
