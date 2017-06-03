MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Jun 2017 21:37:34 -0700
Message-ID: <CAGXu5jLfUj9TP6=nVcBy43-Etz6NAeA5kStEpwNRfNNLATEKjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 0/6] move mmap_area and PIE binaries
 away from the stack
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Daniel Micay <danielmicay@gmail.com>, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 8:20 AM,  <riel@redhat.com> wrote:
> There are a few bugs causing the kernel to sometimes map PIE
> binaries and the mmap_area where the stack is supposed to go.
>
> This series fixes them for x86, ARM64, and PPC.
> S390 seems to be ok.
>
> If people are fine with this approach, I can work my way
> through other architectures, too.

Andrew, I'd rather the ELF_ET_DYN_BASE changes not be in -mm yet. I
think it's the wrong approach. Patch 1 (comment update) is fine.
Patches 3 and 4 need some (minor?) adjustments, but the ELF_DYN_BASE
patches need much more thought, IMO (I've sent a separate email about
those.) And please add me to explicit the Cc list for this series.

-Kees

-- 
Kees Cook
Pixel Security
