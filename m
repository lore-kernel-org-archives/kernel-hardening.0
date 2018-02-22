Subject: Re: [PATCH 2/2] arm64: Clear the stack
From: Laura Abbott <labbott@redhat.com>
References: <20180221011303.20392-1-labbott@redhat.com>
 <20180221011303.20392-3-labbott@redhat.com>
 <20180221153850.ywpzsigfnz3etoun@salmiak>
 <3b76d238-e10a-9abf-c9cb-6d3738eb7896@redhat.com>
Message-ID: <572af610-c20f-e826-f124-8df47680795b@redhat.com>
Date: Wed, 21 Feb 2018 17:35:24 -0800
MIME-Version: 1.0
In-Reply-To: <3b76d238-e10a-9abf-c9cb-6d3738eb7896@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/21/2018 03:53 PM, Laura Abbott wrote:
>> I *think* this should happen in finish_ret_to_user a few lines down, since we
>> can call C code if we branch to work_pending, dirtying the stack.
>>
> 
> I think you're right but this didn't immediately work when I tried it.
> I'll have to dig into this some more.

Okay I figured this out. Not corrupting registers works wonders.
