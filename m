Date: Tue, 23 Apr 2019 10:31:48 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
Message-ID: <20190423083148.GF25106@dhcp22.suse.cz>
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-2-glider@google.com>
 <981d439a-1107-2730-f27e-17635ee4a125@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <981d439a-1107-2730-f27e-17635ee4a125@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 18-04-19 09:35:32, Dave Hansen wrote:
> On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> > This option adds the possibility to initialize newly allocated pages and
> > heap objects with zeroes. This is needed to prevent possible information
> > leaks and make the control-flow bugs that depend on uninitialized values
> > more deterministic.
> 
> Isn't it better to do this at free time rather than allocation time?  If
> doing it at free, you can't even have information leaks for pages that
> are in the allocator.

I would tend to agree here. Free path is usually less performance sensitive
than the allocation. Those really hot paths tend to defer the work.

I am also worried that an opt-out gfp flag would tend to be used
incorrectly as the history has shown for others - e.g. __GFP_TEMPORARY.
So I would rather see this robust without a fine tuning unless there is
real use case that would suffer from this and we can think of a
background scrubbing or something similar.

-- 
Michal Hocko
SUSE Labs
