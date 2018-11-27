MIME-Version: 1.0
In-Reply-To: <abf0f0ec-15c5-59eb-8657-e1e0e1f396b6@linux.intel.com>
References: <feac7efa-df6f-cca1-e321-28d220bf0411@linux.intel.com> <abf0f0ec-15c5-59eb-8657-e1e0e1f396b6@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Nov 2018 09:23:49 -0800
Message-ID: <CAGXu5jJWTyEzXODmeKkko5A212TAe1KSWGuONRvF7Tt+RY+5Sw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Documentation/admin-guide: update admin-guide index.rst
Content-Type: text/plain; charset="UTF-8"
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Jonatan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 27, 2018 at 12:16 AM, Alexey Budankov
<alexey.budankov@linux.intel.com> wrote:
>
> Extend index.rst index file at admin-guide root directory with
> the reference to perf-security.rst file being introduced.
>
> Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
> ---
>  Documentation/admin-guide/index.rst | 1 +
>  1 file changed, 1 insertion(+)

Seems like this could just be folded into patch 1? I'm not sure Jon's
preference here, though.

-Kees

>
> diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
> index 965745d5fb9a..0a491676685e 100644
> --- a/Documentation/admin-guide/index.rst
> +++ b/Documentation/admin-guide/index.rst
> @@ -76,6 +76,7 @@ configure specific aspects of kernel behavior to your liking.
>     thunderbolt
>     LSM/index
>     mm/index
> +   perf-security
>
>  .. only::  subproject and html



-- 
Kees Cook
