Reply-To: kernel-hardening@lists.openwall.com
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd> <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd> <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd> <20161101063359.GA27822@gmail.com>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <e0d4e02b-2256-0b32-a1e5-d03c0862db49@gruss.cc>
Date: Tue, 1 Nov 2016 08:53:55 +0100
MIME-Version: 1.0
In-Reply-To: <20161101063359.GA27822@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: kernel-hardening@lists.openwall.com, Pavel Machek <pavel@ucw.cz>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 01.11.2016 07:33, Ingo Molnar wrote:
> Can you suggest a method to find heavily rowhammer affected hardware? Only by
> testing it, or are there some chipset IDs ranges or dmidecode info that will
> pinpoint potentially affected machines?

I have worked with many different systems both on running rowhammer 
attacks and testing defense mechanisms. So far, every Ivy Bridge i5 
(DDR3) that I had access to was susceptible to bit flips - you will have 
highest chances with Ivy Bridge i5...
