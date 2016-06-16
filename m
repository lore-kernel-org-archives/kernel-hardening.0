Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Jun 2016 10:33:39 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160616153339.xvlsnhksqmkeusn4@treble>
References: <cover.1466036668.git.luto@kernel.org>
 <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 04/13] mm: Track NR_KERNEL_STACK in pages instead of
 number of stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 05:28:26PM -0700, Andy Lutomirski wrote:
> Currently, NR_KERNEL_STACK tracks the number of kernel stacks in a
> zone.  This only makes sense if each kernel stack exists entirely in
> one zone, and allowing vmapped stacks could break this assumption.
> 
> It turns out that the code for tracking kernel stack allocations in
> units of pages is slightly simpler, so just switch to counting
> pages.
> 
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  fs/proc/meminfo.c | 2 +-
>  kernel/fork.c     | 3 ++-
>  mm/page_alloc.c   | 3 +--
>  3 files changed, 4 insertions(+), 4 deletions(-)

You missed another usage of NR_KERNEL_STACK in drivers/base/node.c.


-- 
Josh
