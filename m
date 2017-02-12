Date: Sun, 12 Feb 2017 16:23:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1486904770-30653-1-git-send-email-hoeun.ryu@gmail.com>
Message-ID: <alpine.DEB.2.20.1702121623231.3734@nanos>
References: <1486904770-30653-1-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v6] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 12 Feb 2017, Hoeun Ryu wrote:

>  Using virtually mapped stack, kernel stacks are allocated via vmalloc.
> In the current implementation, two stacks per cpu can be cached when
> tasks are freed and the cached stacks are used again in task duplications.
> but the cached stacks may remain unfreed even when cpu are offline.
>  By adding a cpu hotplug callback to free the cached stacks when a cpu
> goes offline, the pages of the cached stacks are not wasted.
> 
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
