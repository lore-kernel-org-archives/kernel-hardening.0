Date: Wed, 8 Feb 2017 20:22:29 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170209042229.GA4311@zzz>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v2 1/2] fork: free vmapped stacks in
 cache when cpus are offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Hoeun,

On Thu, Feb 09, 2017 at 01:03:46PM +0900, Hoeun Ryu wrote:
> +static int free_vm_stack_cache(unsigned int cpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_CACHED_STACKS; i++) {
> +		struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
> +		if (!vm_stack)
> +			continue;
> +
> +		vfree(vm_stack->addr);
> +		this_cpu_write(cached_stacks[i], NULL);
> +	}
> +
> +	return 0;
> +}

Doesn't this need to free the stacks for the 'cpu' that's passed in, instead of
"this" CPU?

- Eric
