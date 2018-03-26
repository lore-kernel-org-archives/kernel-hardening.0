Date: Mon, 26 Mar 2018 15:35:18 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/4] usercopy: reimplement arch_within_stack_frames
Message-ID: <20180326143518.GA9341@arm.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
To: kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hi Sahara,

On Thu, Mar 01, 2018 at 02:19:47PM +0400, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
> 
> This series of patches introduce the arm64 arch_within_stack_frames
> implementation using stacktrace functions. Also the base code is
> moved from thread_info.h to stacktrace.h. x86 code is reimplemented
> to use frame pointer unwinder functions.

What's the status on this series? I'm ok taking the arm64 patch from James
to bring us up to speed with x86, but it doesn't make sense without the
first patch in the series because the arch callback is out-of-line.

Will
