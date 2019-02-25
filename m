Date: Mon, 25 Feb 2019 13:11:38 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v2 5/6] rcuwait: Annotate task_struct with __rcu
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-6-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223063434.6793-6-joel@joelfernandes.org>
Message-Id: <20190225211138.GZ4072@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 23, 2019 at 01:34:33AM -0500, Joel Fernandes (Google) wrote:
> This suppresses sparse error generated due to the recently added
> rcu_assign_pointer sparse check.
> 
> percpu-rwsem.c:162:9: sparse: error: incompatible types in comparison expression
> exit.c:316:16: sparse: error: incompatible types in comparison expression
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

>From an RCU perspective:

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  include/linux/rcuwait.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
> index 90bfa3279a01..563290fc194f 100644
> --- a/include/linux/rcuwait.h
> +++ b/include/linux/rcuwait.h
> @@ -18,7 +18,7 @@
>   * awoken.
>   */
>  struct rcuwait {
> -	struct task_struct *task;
> +	struct task_struct __rcu *task;
>  };
>  
>  #define __RCUWAIT_INITIALIZER(name)		\
> -- 
> 2.21.0.rc0.258.g878e2cd30e-goog
> 
