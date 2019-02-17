Date: Sun, 17 Feb 2019 16:14:28 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 0/3] admin-guide: extend perf-security with resource
 control, data categories and privileged users
Message-ID: <20190217161428.6b43608a@lwn.net>
In-Reply-To: <784bbe0d-56c1-bd63-1879-b7db988e40c0@linux.intel.com>
References: <784bbe0d-56c1-bd63-1879-b7db988e40c0@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 11 Feb 2019 16:32:33 +0300
Alexey Budankov <alexey.budankov@linux.intel.com> wrote:

> The patch set extends the first version of perf-security.rst documentation
> file [1], [2], [3] with the following topics:
> 
> 1) perf_events/Perf resource limits and control management that describes
>    RLIMIT_NOFILE and perf_event_mlock_kb settings for processes conducting
>    performance monitoring;
> 
> 2) categories of system and performance data that can be captured by
>    perf_events/Perf with explicit designation of process sensitive data;
> 
> 3) possible steps to create perf_event/Perf privileged users groups for 
>    the current implementations of perf_events syscall API [4] and Perf tool;

I've applied the set, thanks.

jon
