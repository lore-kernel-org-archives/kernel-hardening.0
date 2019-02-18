Subject: Re: [PATCH v3 0/3] admin-guide: extend perf-security with resource
 control, data categories and privileged users
References: <784bbe0d-56c1-bd63-1879-b7db988e40c0@linux.intel.com>
 <20190217161428.6b43608a@lwn.net>
From: Alexey Budankov <alexey.budankov@linux.intel.com>
Message-ID: <c26bd0a2-f0a3-47d4-0ff8-620a677d7a91@linux.intel.com>
Date: Mon, 18 Feb 2019 11:56:30 +0300
MIME-Version: 1.0
In-Reply-To: <20190217161428.6b43608a@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


On 18.02.2019 2:14, Jonathan Corbet wrote:
> On Mon, 11 Feb 2019 16:32:33 +0300
> Alexey Budankov <alexey.budankov@linux.intel.com> wrote:
> 
>> The patch set extends the first version of perf-security.rst documentation
>> file [1], [2], [3] with the following topics:
>>
>> 1) perf_events/Perf resource limits and control management that describes
>>    RLIMIT_NOFILE and perf_event_mlock_kb settings for processes conducting
>>    performance monitoring;
>>
>> 2) categories of system and performance data that can be captured by
>>    perf_events/Perf with explicit designation of process sensitive data;
>>
>> 3) possible steps to create perf_event/Perf privileged users groups for 
>>    the current implementations of perf_events syscall API [4] and Perf tool;
> 
> I've applied the set, thanks.

Thanks a lot Jon!

~Alexey

> 
> jon
> 
