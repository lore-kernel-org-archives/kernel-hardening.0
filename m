MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180221125914.dc95830eada5fb958c13e36b@linux-foundation.org>
References: <20180221021659.GA37073@beast> <20180221102933.GD2231@dhcp22.suse.cz>
 <20180221125914.dc95830eada5fb958c13e36b@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 21 Feb 2018 18:15:35 -0800
Message-ID: <CAGXu5j+dc=y+1M=unyvEvCo+QrX3MCW5Hm=2Z+q0a6iC3pgN6g@mail.gmail.com>
Subject: Re: [PATCH v2] fork: Unconditionally clear stack on fork
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Rasmus Villemoes <rasmus.villemoes@prevas.dk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 12:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 21 Feb 2018 11:29:33 +0100 Michal Hocko <mhocko@kernel.org> wrote:
>
>> On Tue 20-02-18 18:16:59, Kees Cook wrote:
>> > One of the classes of kernel stack content leaks[1] is exposing the
>> > contents of prior heap or stack contents when a new process stack is
>> > allocated. Normally, those stacks are not zeroed, and the old contents
>> > remain in place. In the face of stack content exposure flaws, those
>> > contents can leak to userspace.
>> >
>> > Fixing this will make the kernel no longer vulnerable to these flaws,
>> > as the stack will be wiped each time a stack is assigned to a new
>> > process. There's not a meaningful change in runtime performance; it
>> > almost looks like it provides a benefit.
>> >
>> > Performing back-to-back kernel builds before:
>> >     Run times: 157.86 157.09 158.90 160.94 160.80
>> >     Mean: 159.12
>> >     Std Dev: 1.54
>> >
>> > and after:
>> >     Run times: 159.31 157.34 156.71 158.15 160.81
>> >     Mean: 158.46
>> >     Std Dev: 1.46
>>
>> /bin/true or similar would be more representative for the worst case
>> but it is good to see that this doesn't have any visible effect on
>> a more real usecase.
>
> Yes, that's a pretty large memset.  And while it will populate the CPU
> cache with the stack contents, doing so will evict other things.
>
> So some quite careful quantitative testing is needed here, methinks.

Well, I did some more with perf and cycle counts on running 100,000
execs of /bin/true.

before:
Cycles: 218858861551 218853036130 214727610969 227656844122 224980542841
Mean:  221015379122.60
Std Dev: 4662486552.47

after:
Cycles: 213868945060 213119275204 211820169456 224426673259 225489986348
Mean:  217745009865.40
Std Dev: 5935559279.99

It continues to look like it's faster, though the deviation is rather
wide, but I'm not sure what I could do that would be less noisy. I'm
open to ideas!

-Kees

-- 
Kees Cook
Pixel Security
