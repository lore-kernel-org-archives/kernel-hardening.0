Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Jun 2016 12:46:25 +0300
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Message-ID: <20160621094625.GA15970@esperanza>
References: <cover.1466466093.git.luto@kernel.org>
 <053517e55aaf7ab1bbb7424abd89a1ac5535aa64.1466466093.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <053517e55aaf7ab1bbb7424abd89a1ac5535aa64.1466466093.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v3 04/13] mm: Track NR_KERNEL_STACK in KiB instead of
 number of stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2016 at 04:43:34PM -0700, Andy Lutomirski wrote:
> Currently, NR_KERNEL_STACK tracks the number of kernel stacks in a
> zone.  This only makes sense if each kernel stack exists entirely in
> one zone, and allowing vmapped stacks could break this assumption.
> 
> Since frv has THREAD_SIZE < PAGE_SIZE, we need to track kernel stack
> allocations in a unit that divides both THREAD_SIZE and PAGE_SIZE on
> all architectures.  Keep it simple and use KiB.
> 
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
