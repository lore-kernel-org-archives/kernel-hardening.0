Date: Sun, 25 Nov 2018 12:47:32 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 1/2] Documentation/admin-guide: introduce
 perf-security.rst file
Message-ID: <20181125124732.6c1807de@lwn.net>
In-Reply-To: <4d95341d-d1f4-fc48-f173-a6fedfc70d33@linux.intel.com>
References: <259a9cd2-5c56-4f8d-57c4-cabaeaa774bc@linux.intel.com>
	<4d95341d-d1f4-fc48-f173-a6fedfc70d33@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 21 Nov 2018 12:14:14 +0300
Alexey Budankov <alexey.budankov@linux.intel.com> wrote:

> +For the purpose of performing security checks Linux implementation splits
> +processes into two categories [6]_ : a) privileged processes (whose effective
> +user ID is 0, referred to as superuser or root), and b) unprivileged processes
> +(whose effective UID is nonzero).

Is that really what's going on here?  If I understand things correctly,
it's looking for CAP_SYS_PTRACE rather than a specific UID; am I missing
something here?

(Also, you would want "*the* Linux implementation" in the first sentence
above).

One other thing:

> +(whose effective UID is nonzero). Privileged processes bypass all kernel
> +security permission checks so perf_events performance monitoring is fully
> +available to privileged processes without *access*, *scope* and *resource*
> +restrictions.

Could I ask for a slight toning down of the markup here?  There's a lot of
*emphasis* here that isn't really needed and tends to get in the way.

Thanks,

jon
