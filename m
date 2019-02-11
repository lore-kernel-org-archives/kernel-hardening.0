Subject: Re: [PATCH v2 1/4] perf-security: document perf_events/Perf resource
 control
References: <fd896eec-7833-f23a-ad2f-95005dca5fff@linux.intel.com>
 <a108c800-d6c1-fac1-b73b-e390e579e6ef@linux.intel.com>
 <alpine.DEB.2.21.1902102300210.8784@nanos.tec.linutronix.de>
 <969b6ea5-a5bf-70b7-7031-38b07538f744@linux.intel.com>
 <alpine.DEB.2.21.1902111514550.3197@nanos.tec.linutronix.de>
From: Alexey Budankov <alexey.budankov@linux.intel.com>
Message-ID: <b202708c-1967-f673-16a2-005a67dffebe@linux.intel.com>
Date: Mon, 11 Feb 2019 17:22:28 +0300
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1902111514550.3197@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonatan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


On 11.02.2019 17:15, Thomas Gleixner wrote:
> On Mon, 11 Feb 2019, Alexey Budankov wrote:
>> On 11.02.2019 1:34, Thomas Gleixner wrote:
>>> On Thu, 7 Feb 2019, Alexey Budankov wrote:
>>>
>>> General note: Please stay in the 80 char limit for all of the text.
>>
>> Yes, sure. [PATCH v2 4/4] implements wrapping at 72 columns.
> 
> So you provide crappy formatted stuff first, just to reformat it at the
> end. I'm missing the logic behind that.

The logic is not to mix new content review with the whole doc 
formatting in the end.

Thanks,
Alexey

> 
> Thanks,
> 
> 	tglx
> 
