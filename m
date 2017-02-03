Date: Fri, 3 Feb 2017 18:15:01 +0100
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170203171444.GJ19325@dhcp22.suse.cz>
References: <1486135892-27249-1-git-send-email-hoeun.ryu@gmail.com>
 <20170203153914.GI19325@dhcp22.suse.cz>
 <CABeRdtp9ERutdeKLpztyLpV=8VOqiJPnES_3c_V4aLS_dZ_-jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeRdtp9ERutdeKLpztyLpV=8VOqiJPnES_3c_V4aLS_dZ_-jg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/3] fork: dynamically allocate cache array for vmapped
 stacks using cpuhp
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat 04-02-17 01:42:56, Hoeun Ryu wrote:
> On Sat, Feb 4, 2017 at 12:39 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Sat 04-02-17 00:30:05, Hoeun Ryu wrote:
> >>  Using virtually mapped stack, kernel stacks are allocated via vmalloc.
> >> In the current implementation, two stacks per cpu can be cached when
> >> tasks are freed and the cached stacks are used again in task duplications.
> >> but the array for the cached stacks is statically allocated by per-cpu api.
> >>  In this new implementation, the array for the cached stacks are dynamically
> >> allocted and freed by cpu hotplug callbacks and the cached stacks are freed
> >> when cpu is down. setup for cpu hotplug is established in fork_init().
> >
> > Why do we want this? I can see that the follow up patch makes the number
> > configurable but the changelog doesn't describe the motivation for that.
> > Which workload would benefit from a higher value?
> >
> 
> The key difference of this implementation, the cached stacks for a cpu
> is freed when a cpu is down.
> so the cached stacks are no longer wasted.
> In the current implementation, the cached stacks for a cpu still
> remain on the system when a cpu is down.

Yes, that is true but cpu offline operation is just too rare for this to
matter all that much I believe. More importantly, though, the current
implementation could be easily fixed as well without reworking how
the caching works. If there are workloads where the wastage really
matters then please try to fix it with the current caching scheme before
extending it for larger caches. This would make it easier to backport to
older kernels.

> I think we could imagine what if a machine has many cpus and someone
> wants to have bigger size of stack caches.

Without being more specific who might want the bigger caches and why
this sounds like an insufficient justification to replace the current
(simpler) caching.
-- 
Michal Hocko
SUSE Labs
