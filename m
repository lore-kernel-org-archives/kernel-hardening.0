Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 11:33:05 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160111183305.GA27217@davidb.org>
References: <20151209172101.GA70633@davidb.org>
 <CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
 <20151210000005.GA99337@davidb.org>
 <CAGXu5jLLXK3N6pbZOie5uj276x=dtc_tuTz312rnhF8yrmxHYQ@mail.gmail.com>
 <20151210002651.GC99337@davidb.org>
 <CAGXu5jJYRCZ1-frx3+pUPabm3XRFFU8T4gsCQaSc73aA4Q--3g@mail.gmail.com>
 <CAB9W1A0veUktvSrdwMSaN=kqypGdE6_RLXFGkD79scfkPPevpw@mail.gmail.com>
 <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
 <20151210184211.GH26759@e104818-lin.cambridge.arm.com>
 <CAGXu5j+LHBaZ12+zsiK+tt3R83+uTHKO_og3AJRhWP+tHDxUOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5j+LHBaZ12+zsiK+tt3R83+uTHKO_og3AJRhWP+tHDxUOA@mail.gmail.com>
Subject: Re: [kernel-hardening] Self Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 03:52:16PM -0800, Kees Cook wrote:

>> I haven't done any further improvements to them, nor have I received any
>> feedback. I'll rebase them against latest kernel if anyone else is
>> willing to test. I had a plan to run some benchmarks and see how
>> performance is affected (including the CPU_SW_DOMAIN_PAN) before pushing
>> again for upstreaming but I haven't had the time.
>
>David, getting back to something that might good to get your help
>with: would you be able to test Catalin's LPAE TTBR0 PAN series on
>real hardware? (Are you familiar with the LKDTM tests for this[1]?)

Sorry for the delay in getting back to you.  Been both moving and
taking vacation.

I'd like to test this.  I'm just trying to see if I can track down
some hardware that'll boot LPAE.

Thanks,
David
