Date: Tue, 9 Apr 2019 22:38:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only
 post init
Message-ID: <20190409223820.511e3671@oasis.local.home>
In-Reply-To: <20190410011418.76408-2-joel@joelfernandes.org>
References: <20190410011418.76408-1-joel@joelfernandes.org>
	<20190410011418.76408-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue,  9 Apr 2019 21:14:18 -0400
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

>  /*
> - * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> + * These are section names marked with SHF_RO_AFTER_INIT so that

I'm curious to this much of a change. Wouldn't just making "section"
plural also work?

 "Mark ro_after_init sections with ..."

Other than that, the two patches look fine to me.

-- Steve

>   * layout_sections() can put it in the right place.
>   * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
>   */
> @@ -3314,6 +3314,13 @@ static char *ro_after_init_sections[] = {
