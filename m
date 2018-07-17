Subject: Re: [PATCH] arm64: Clear the stack
References: <20180629190553.7282-1-labbott@redhat.com>
 <9733d929-3c6a-40e1-6110-8f79975323d3@linux.com>
 <1b97aa7d-2b6c-a5df-0caa-1cd16e18a816@redhat.com>
 <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <06dd55e6-d39e-7617-b644-bdd04fa3c030@redhat.com>
Date: Tue, 17 Jul 2018 15:58:19 -0700
MIME-Version: 1.0
In-Reply-To: <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>, will.deacon@arm.com, catalin.marinas@arm.com
Cc: alex.popov@linux.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, james.morse@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/03/2018 05:14 AM, Mark Rutland wrote:
>> It might be cleaner just to use on_accessible_stack and then another
>> function to get the top of stack. This also might just be
>> reimplementing what x86 already has? (Mark, Ard?)
> It looks like we could build a get_stack_info() as they have.
> 
> We could probably clean up our stack traced atop of that, too.

So I spent some time looking at this and I'm not 100% clear
if there would actually be much benefit to re-writing with
get_stack_info. Most of that design seems to come from x86
needing to handle multiple unwind options which arm64 doesn't
need to worry about. Any rework ended up with roughly
the same code without any notable benefit that I could see.
It's possible I'm missing what kind of cleanup you're suggesting
but I think just going with a tweaked version of on_accessible_stack
would be fine.

Thanks,
Laura
