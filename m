Reply-To: kernel-hardening@lists.openwall.com
References: <20161028172710.GA10309@amd>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
Date: Sat, 29 Oct 2016 15:06:02 +0200
MIME-Version: 1.0
In-Reply-To: <20161028172710.GA10309@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

I think that this idea to mitigate Rowhammer is not a good approach.

I wrote Rowhammer.js (we published a paper on that) and I had the first 
reproducible bit flips on DDR4 at both, increased and default refresh 
rates (published in our DRAMA paper).

We have researched the number of cache misses induced from different 
applications in the past and there are many applications that cause more 
cache misses than Rowhammer (published in our Flush+Flush paper) they 
just cause them on different rows.
Slowing down a system surely works, but you could also, as a mitigation 
just make this CPU core run at the lowest possible frequency. That would 
likely be more effective than the solution you suggest.

Now, every Rowhammer attack exploits not only the DRAM effects but also 
the way the operating system organizes memory.

Some papers exploit page deduplication and disabling page deduplication 
should be the default also for other reasons, such as information 
disclosure attacks. If page deduplication is disabled, attacks like 
Dedup est Machina and Flip Feng Shui are inherently not possible anymore.

Most other attacks target page tables (the Google exploit, Rowhammer.js, 
Drammer). Now in Rowhammer.js we suggested a very simple fix, that is 
just an extension of what Linux already does.
Unless out of memory page tables and user pages are not placed in the 
same 2MB region. We suggested that this behavior should be more strict 
even in memory pressure situations. If the OS can only find a page table 
that resides in the same 2MB region as a user page, the request should 
fail instead and the process requesting it should go out of memory. More 
generally, the attack surface is gone if the OS never places a page 
table in proximity of less than 2MB to a user page.
That is a simple fix that does not cost any runtime performance. It 
mitigates all these scary attacks and won't even incur a memory cost in 
most situation.
