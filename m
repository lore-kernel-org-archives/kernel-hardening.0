Date: Wed, 31 May 2017 13:13:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170531111309.3kyfgxu5dkthu2dn@hirez.programming.kicks-ass.net>
References: <1496180392-98718-1-git-send-email-keescook@chromium.org>
 <1496180392-98718-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496180392-98718-3-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v5 2/3] x86/asm: Add suffix macro for GEN_*_RMWcc()
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 30, 2017 at 02:39:51PM -0700, Kees Cook wrote:
> The coming x86 refcount protection needs to be able to add trailing
> instructions to the GEN_*_RMWcc() operations. This extracts the
> difference between the goto/non-goto cases so the helper macros
> can be defined outside the #ifdef cases. Additionally adds argument
> naming to the resulting asm for referencing from suffixed
> instructions, and adds clobbers for "cc", and "cx" to let suffixes
> use _ASM_CX, and retain any set flags.

Another option is to simply require __GCC_ASM_FLAG_OUTPUT__ for the fast
refcount stuff. That would result in simpler and more readable code.
