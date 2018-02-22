Subject: Re: [PATCH 1/2] stackleak: Update for arm64
References: <20180221011303.20392-1-labbott@redhat.com>
 <20180221011303.20392-2-labbott@redhat.com> <20180222165834.GC18421@arm.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <97090ca6-efad-7c03-6084-a97674ae61c7@linux.com>
Date: Thu, 22 Feb 2018 22:22:14 +0300
MIME-Version: 1.0
In-Reply-To: <20180222165834.GC18421@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, richard.sandiford@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello Will, Richard and GCC folks!

On 22.02.2018 19:58, Will Deacon wrote:
> On Tue, Feb 20, 2018 at 05:13:02PM -0800, Laura Abbott wrote:
>>
>> arm64 has another layer of indirection in the RTL.
>> Account for this in the plugin.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>  scripts/gcc-plugins/stackleak_plugin.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
>> index 6fc991c98d8b..7dfaa027423f 100644
>> --- a/scripts/gcc-plugins/stackleak_plugin.c
>> +++ b/scripts/gcc-plugins/stackleak_plugin.c
>> @@ -244,6 +244,11 @@ static unsigned int stackleak_final_execute(void)
>>  		 * that insn.
>>  		 */
>>  		body = PATTERN(insn);
>> +		/* arm64 is different */
>> +		if (GET_CODE(body) == PARALLEL) {
>> +			body = XEXP(body, 0);
>> +			body = XEXP(body, 0);
>> +		}
> 
> Like most kernel developers, I don't know the first thing about GCC internals
> so I asked our GCC team and Richard (CC'd) reckons this should be:
> 
> 	if (GET_CODE(body) == PARALLEL)
> 		body = XVECEXP(body, 0, 0);
> 
> instead of the hunk above. Can you give that a go instead, please?

Thanks a lot!

Would you be so kind to take a look at the whole STACKLEAK plugin?
http://www.openwall.com/lists/kernel-hardening/2018/02/16/4
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/stackleak&id=57a0a6763b12e82dd462593d0f42be610e93cdc9

It's not very big. I documented it in detail. I would be really grateful for the
review!

Best regards,
Alexander
