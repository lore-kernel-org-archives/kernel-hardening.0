Reply-To: kernel-hardening@lists.openwall.com
References: <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd> <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd> <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd> <20161101063359.GA27822@gmail.com>
 <20161101081043.GA27659@amd>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <1edd96a2-b5fb-8131-4042-7410833dd0dd@gruss.cc>
Date: Tue, 1 Nov 2016 09:13:20 +0100
MIME-Version: 1.0
In-Reply-To: <20161101081043.GA27659@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 01.11.2016 09:10, Pavel Machek wrote:
> cpu family     : 6
> model	       	 : 23
> model name	 : Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz
> stepping	 : 10
> microcode	 : 0xa07
>
> so rowhammerjs/native is not available for this system. Bit mapping
> for memory hash functions would need to be reverse engineered for more
> effective attack.

By coincidence, we wrote a tool to do that in software: 
https://github.com/IAIK/drama ;)
