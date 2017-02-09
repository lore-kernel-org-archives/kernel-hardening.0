Date: Wed, 8 Feb 2017 20:26:29 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170209042629.GB4311@zzz>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
 <1486613040-30555-2-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486613040-30555-2-git-send-email-hoeun.ryu@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v2 2/2] fork: make number of cached
 stacks (vmapped) configurable using Kbuild
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, Ingo Molnar <mingo@kernel.org>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Nicholas Piggin <npiggin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Michal Hocko <mhocko@suse.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 09, 2017 at 01:03:47PM +0900, Hoeun Ryu wrote:
> +config NR_VMAP_STACK_CACHE
> +	int "Number of cached stacks"
> +	default "2"
> +	depends on VMAP_STACK
> +	help
> +	  This determines how many stacks can be cached for virtually
> +	  mapped kernel stacks.
> +

Can you explain in the help text under what circumstances someone should change
this, and to what value?  As-is, it seems like somewhat of a useless config
option which no one will ever change.

- Eric
