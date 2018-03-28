MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180328205554.929111847@linutronix.de>
References: <20180328205138.301218351@linutronix.de> <20180328205554.929111847@linutronix.de>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Mar 2018 14:14:25 -0700
Message-ID: <CAGXu5j+UUsR8=G93UHktjUSX3N8LsRvARNDRmNTiQGLzAAm=yw@mail.gmail.com>
Subject: Re: [patch 8/8] rslib: Allocate decoder buffers to avoid VLAs
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 1:51 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> To get rid of the variable length arrays on stack in the RS decoder it's
> necessary to allocate the decoder buffers per control structure instance.
>
> All usage sites have been checked for potential parallel decoder usage and
> fixed where necessary. Kees confirmed that the pstore decoding is strictly
> single threaded so there should be no surprises.

For posterity: pstore ecc decode happens during probe and during read.
The read (pstore_get_backend_records()) has an explicit read_mutex.

I was pondering, though, since we have a common control structure now,
maybe we should just add a spinlock too to avoid future surprises?

> Allocate them in the rs control structure sized depending on the number of
> roots for the chosen codec and adapt the decoder code to make use of them.
>
> Document the fact that decode operations based on a particular rs control
> instance cannot run in parallel and the caller has to ensure that as it's
> not possible to provide a proper locking construct which fits all use
> cases.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Regardless:

Acked-by: Kees Cook <keescook@chromium.org>

Thanks for doing this!

-Kees

-- 
Kees Cook
Pixel Security
