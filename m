Date: Wed, 10 Apr 2019 16:29:02 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 3/3] module: Make __tracepoints_ptrs as read-only
Message-ID: <20190410202902.GA167446@google.com>
References: <20190410195708.162185-1-joel@joelfernandes.org>
 <20190410195708.162185-3-joel@joelfernandes.org>
 <20190410161112.540017d9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410161112.540017d9@gandalf.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, mathieu.desnoyers@efficios.com, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 04:11:12PM -0400, Steven Rostedt wrote:
> On Wed, 10 Apr 2019 15:57:08 -0400
> "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
> > This series hardens the tracepoints in modules by making the array of
> > pointers referring to the tracepoints as read-only. This array is needed
> > during module unloading to verify that the tracepoint is quiescent.
> > There is no reason for the array to be to be writable after init, and
> > can cause security or other hidden bugs. Mark these as ro_after_init.
> > 
> > Suggested-by: paulmck@linux.vnet.ibm.com
> > Suggested-by: keescook@chromium.org
> > Suggested-by: mathieu.desnoyers@efficios.com
> > Cc: rostedt@goodmis.org
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  kernel/module.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 8b9631e789f0..be980aaa8804 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -3320,6 +3320,12 @@ static const char * const ro_after_init_sections[] = {
> >  	 * by the SRCU notifiers
> >  	 */
> >  	"___srcu_struct_ptrs",
> > +
> > +	/*
> > +	 * Array of tracepoint pointers used for checking if tracepoints are
> > +	 * quiescent during unloading.
> > +	 */
> > +	"__tracepoints_ptrs",
> 
> Do we ever modify the __tracepoint_ptrs section? I know the jump_label
> sections are sorted on load, which means they need to be writable
> during init, but if __tracepoint_ptrs is not sorted or touched during
> load, why not just put them in the rodata section to begin with?
> 
> -- Steve

The srcu structure pointer array is modified at module load time because the
array is fixed up by the module loader at load-time with the final locations
of the tracepoints right?  Basically relocation fixups. At compile time, I
believe it is not know what the values in the ptr array are. I believe same
is true for the tracepoint ptrs array.

Also it needs to be in a separate __tracepoint_ptrs so that this code works:


#ifdef CONFIG_TRACEPOINTS
	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
					     sizeof(*mod->tracepoints_ptrs),
					     &mod->num_tracepoints);
#endif

Did I  miss some point? Thanks,

 - Joel
