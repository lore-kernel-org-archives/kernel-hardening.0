Date: Tue, 9 Apr 2019 22:41:03 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only post
 init
Message-ID: <20190410024103.GA104423@google.com>
References: <20190410011418.76408-1-joel@joelfernandes.org>
 <20190410011418.76408-2-joel@joelfernandes.org>
 <20190409223820.511e3671@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409223820.511e3671@oasis.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 09, 2019 at 10:38:20PM -0400, Steven Rostedt wrote:
> On Tue,  9 Apr 2019 21:14:18 -0400
> "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
> >  /*
> > - * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> > + * These are section names marked with SHF_RO_AFTER_INIT so that
> 
> I'm curious to this much of a change. Wouldn't just making "section"
> plural also work?
> 
>  "Mark ro_after_init sections with ..."

Yes, I will change it to that and actually this comment change should go in
the previous patch so I'll squash it into that.

> Other than that, the two patches look fine to me.

Could I add your Reviewed-by in the respin?

thanks,

 - Joel


> -- Steve
> 
> >   * layout_sections() can put it in the right place.
> >   * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
> >   */
> > @@ -3314,6 +3314,13 @@ static char *ro_after_init_sections[] = {
