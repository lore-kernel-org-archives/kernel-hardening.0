Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Jun 2016 14:10:53 +0300
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Message-ID: <20160616111053.GA13143@esperanza>
References: <cover.1466036668.git.luto@kernel.org>
 <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 04/13] mm: Track NR_KERNEL_STACK in pages instead of
 number of stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 05:28:26PM -0700, Andy Lutomirski wrote:
...
> @@ -225,7 +225,8 @@ static void account_kernel_stack(struct thread_info *ti, int account)
>  {
>  	struct zone *zone = page_zone(virt_to_page(ti));
>  
> -	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
> +	mod_zone_page_state(zone, NR_KERNEL_STACK,
> +			    THREAD_SIZE / PAGE_SIZE * account);

It won't work if THREAD_SIZE < PAGE_SIZE. Is there an arch with such a
thread size, anyway? If no, we should probably drop thread_info_cache.
