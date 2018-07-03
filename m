Subject: Re: [PATCH] arm64: Clear the stack
References: <20180629190553.7282-1-labbott@redhat.com>
 <9733d929-3c6a-40e1-6110-8f79975323d3@linux.com>
 <1b97aa7d-2b6c-a5df-0caa-1cd16e18a816@redhat.com>
 <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
 <20180703150349.fndcq7h5hl3mtain@armageddon.cambridge.arm.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <6ca7144a-2659-3877-b208-ce043d1393dc@linux.com>
Date: Tue, 3 Jul 2018 23:38:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180703150349.fndcq7h5hl3mtain@armageddon.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, will.deacon@arm.com, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, james.morse@arm.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On 03.07.2018 18:03, Catalin Marinas wrote:
> On Tue, Jul 03, 2018 at 01:14:41PM +0100, Mark Rutland wrote:
>> On Mon, Jul 02, 2018 at 11:48:05AM -0700, Laura Abbott wrote:
>>> On 07/02/2018 06:02 AM, Alexander Popov wrote:
>>>> Could you rename the macro to STACKLEAK_ERASE for similarity with x86?
>>>
>>> Mark Rutland had previously asked for this to be lowercase.
>>> I really don't care one way or the other so I'll defer to
>>> someone else to have the final word.
>>
>> Will, Catalin, could you chime in either way?
>>
>> I'd previously asked for lower-case for consistency with our other
>> assembly macros.
> 
> I'd keep it lowercase as the other arm64 macros in this file.

Ok, thanks, I'm fine with it.

Best regards,
Alexander
