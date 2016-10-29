Reply-To: kernel-hardening@lists.openwall.com
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc> <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc> <20161029210518.GC3827@amd>
 <571c5ef8-ccce-0b7a-b506-c69a024276a0@gruss.cc> <20161029214540.GD3827@amd>
 <c16d6b6c-608e-c711-cc18-34b8d0082183@gruss.cc> <20161029220133.GE3827@amd>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <b73caa1b-fde5-c10f-8c28-014027a55333@gruss.cc>
Date: Sun, 30 Oct 2016 00:02:46 +0200
MIME-Version: 1.0
In-Reply-To: <20161029220133.GE3827@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 30.10.2016 00:01, Pavel Machek wrote:
> Hmm, maybe I'm glad I don't have a new machine :-).
>
> I assume you still get _some_ bitflips with generic "rowhammer"?

1 or 2 every 20-30 minutes...
