Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160620130232.GC9892@dhcp22.suse.cz>
References: <cover.1466192946.git.luto@kernel.org> <8a17889a9d47b7b4deb41f2fcccada8bf54d4b6f.1466192946.git.luto@kernel.org>
 <20160620130232.GC9892@dhcp22.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Jun 2016 09:05:24 -0700
Message-ID: <CALCETrUhiFdNeE8BOcOYPDVLcDO6aq412iDT+Lf_9QHdmsY6Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 05/13] mm: Move memcg stack accounting to account_kernel_stack
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Brian Gerst <brgerst@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, Vladimir Davydov <vdavydov@virtuozzo.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Jun 20, 2016 6:02 AM, "Michal Hocko" <mhocko@kernel.org> wrote:
>
> On Fri 17-06-16 13:00:41, Andy Lutomirski wrote:
> > We should account for stacks regardless of stack size.  Move it into
> > account_kernel_stack.
> >
> > Fixes: 12580e4b54ba8 ("mm: memcontrol: report kernel stack usage in cgroup2 memory.stat")
> > Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Andy Lutomirski <luto@kernel.org>
>
> Acked-by: Michal Hocko <mhocko@suse.com>
>

This needs the same kilobyte treatment as the other accounting patch,
so I'm going to send v3 without your ack.

--Andy
