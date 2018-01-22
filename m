MIME-Version: 1.0
In-Reply-To: <151648236454.34747.93245075402067564.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236454.34747.93245075402067564.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 22 Jan 2018 20:00:40 +0100
Message-ID: <CAG48ez3SQNMKxMLNKCV4o8qAbqzB4d+EPo8a4wHzDgqkGAX8Dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4.1 01/10] Documentation: document array_ptr
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Rutland <mark.rutland@arm.com>, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 20, 2018 at 10:06 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Mark Rutland <mark.rutland@arm.com>
>
> Document the rationale and usage of the new array_ptr() helper.
[...]
> +A call to array_ptr(arr, idx, sz) returns a sanitized pointer to
> +arr[idx] only if idx falls in the [0, sz) interval. When idx < 0 or idx > sz,

"or idx >= sz"?
