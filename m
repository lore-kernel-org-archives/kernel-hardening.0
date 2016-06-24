Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 10:22:12 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160624152212.5uutwkvfmj6sr24c@treble>
References: <cover.1466741835.git.luto@kernel.org>
 <b8a5aad2ee4ac1302227348b7a59a8b69e322fbb.1466741835.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b8a5aad2ee4ac1302227348b7a59a8b69e322fbb.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 07/16] mm: Fix memcg stack accounting for sub-page
 stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 09:23:02PM -0700, Andy Lutomirski wrote:
> We should account for stacks regardless of stack size, and we need
> to account in sub-page units if THREAD_SIZE < PAGE_SIZE.  Change the
> units to kilobytes and Move it into account_kernel_stack().
> 
> Fixes: 12580e4b54ba8 ("mm: memcontrol: report kernel stack usage in cgroup2 memory.stat")
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: linux-mm@kvack.org
> Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
