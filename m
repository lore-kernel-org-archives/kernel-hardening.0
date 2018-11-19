Subject: Re: [PATCH v1 2/2]: Documentation/admin-guide: introduce
 perf-security.rst file
References: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
 <a44df303-d962-c1a4-4fe0-6bad887ebcdc@linux.intel.com>
 <aDN4nC6p93nK7ILVP3EH-Y4RcKK4KH0ppQKFkIgxTVxkfbOHWjAYJXdTeuq39nbPkySKItZ_8VHN2PfQS_T08GBzeooD5cvc2Xd8oZxSp9s=@protonmail.ch>
 <20181119104646.GB9761@hirez.programming.kicks-ass.net>
 <n06wPuXrWqZEywcNe2BID7GP8dShJlE4L4oLpxO9__duA3noKJO_maOemZwZGC7EHCW7Ur14war-RqLo5pco9uruYaGJMCPOyRVzPJrZyz4=@protonmail.ch>
From: Alexey Budankov <alexey.budankov@linux.intel.com>
Message-ID: <fa11032d-5260-651a-0d39-a1353ae898ad@linux.intel.com>
Date: Mon, 19 Nov 2018 18:19:03 +0300
MIME-Version: 1.0
In-Reply-To: <n06wPuXrWqZEywcNe2BID7GP8dShJlE4L4oLpxO9__duA3noKJO_maOemZwZGC7EHCW7Ur14war-RqLo5pco9uruYaGJMCPOyRVzPJrZyz4=@protonmail.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jordan Glover <Golden_Miller83@protonmail.ch>, Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 19.11.2018 13:49, Jordan Glover wrote:
> On Monday, November 19, 2018 11:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Mon, Nov 19, 2018 at 10:35:59AM +0000, Jordan Glover wrote:
>>
>>> On Monday, November 19, 2018 6:42 AM, Alexey Budankov alexey.budankov@linux.intel.com wrote:
>>>
>>>> +>=3:
>>>>
>>>> -         Restrict *access* to PCL performance monitoring for unprivileged processes.
>>>>
>>>>
>>>> -         This is the default on Debian and Android [7]_ , [8]_ .
>>>>
>>>>
>>>
>>> AFAIK there is no support for '+>=3' in mainline kernel[1].
>>> Debian and Android use out-of-tree patch for that[2].
>>> Maybe someone should upstream it?
>>
>> NAK still stands on that. Alternative's have been proposed but so far
>> nobody that cared seems to care enough to implement those.
> 
> So, I guess we can't document NAKed patches :)

Please stay tuned for v2.

Thanks,
Alexey

> 
> Jordan
> 
> 
