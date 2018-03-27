Date: Tue, 27 Mar 2018 15:10:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] exofs: Avoid VLA in structures
Message-Id: <20180327151053.c7c8df4135a5dc0bacea0a83@linux-foundation.org>
In-Reply-To: <20180327203904.GA1151@beast>
References: <20180327203904.GA1151@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Boaz Harrosh <ooo@electrozaur.com>, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Mar 2018 13:39:04 -0700 Kees Cook <keescook@chromium.org> wrote:

> On the quest to remove all VLAs from the kernel[1] this adjusts several
> cases where allocation is made after an array of structures that points
> back into the allocation. The allocations are changed to perform explicit
> calculations instead of using a Variable Length Array in a structure.
> Additionally, this lets Clang compile this code now, since Clang does not
> support VLAIS[2].
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> [2] https://lkml.org/lkml/2013/9/23/500
> 
> ...
>
> I not sure the best way to test this. Kconfig implies I need special hardware?

Yeah, I was wondering about that.  It's a tricky-looking patch.

Boaz, are you able to give it a spin?

Thanks.
