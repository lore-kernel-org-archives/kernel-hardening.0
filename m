Date: Tue, 9 Apr 2019 22:48:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only
 post init
Message-ID: <20190409224826.308b12a4@oasis.local.home>
In-Reply-To: <20190410024103.GA104423@google.com>
References: <20190410011418.76408-1-joel@joelfernandes.org>
	<20190410011418.76408-2-joel@joelfernandes.org>
	<20190409223820.511e3671@oasis.local.home>
	<20190410024103.GA104423@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 9 Apr 2019 22:41:03 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> > Other than that, the two patches look fine to me.  
> 
> Could I add your Reviewed-by in the respin?

You can add an Acked-by, as I haven't spent enough time to offer a
Reviewed-by tag. ;-)

Maybe I'll get some time to vet it a bit more tomorrow, and then
upgrade the ack to a review.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
