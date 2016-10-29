Reply-To: kernel-hardening@lists.openwall.com
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc> <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc> <20161029210518.GC3827@amd>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <571c5ef8-ccce-0b7a-b506-c69a024276a0@gruss.cc>
Date: Sat, 29 Oct 2016 23:07:59 +0200
MIME-Version: 1.0
In-Reply-To: <20161029210518.GC3827@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 29.10.2016 23:05, Pavel Machek wrote:
> So far I did bzip2 and kernel compilation. I believe I can prevent
> flips in rowhammer-test with bzip2 going from 4 seconds to 5
> seconds... let me see.

can you prevent bitflips in this one? 
https://github.com/IAIK/rowhammerjs/tree/master/native

> Ok, let me try that. Problem is that the machine I'm testing on takes
> 20 minutes to produce bit flip...

will be lots faster with my code above ;)
