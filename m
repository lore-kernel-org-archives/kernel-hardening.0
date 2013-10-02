Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524B7179.7040104@jp.fujitsu.com>
Date: Wed, 02 Oct 2013 10:06:01 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-7-git-send-email-keescook@chromium.org> <524B6AEE.90301@jp.fujitsu.com>
In-Reply-To: <524B6AEE.90301@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

(2013/10/02 9:38), HATAYAMA Daisuke wrote:
> (2013/10/02 4:37), Kees Cook wrote:
<cut>
>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>    }
>>    
>>    #endif /* CONFIG_X86_32 */
>> +
>> +static struct notifier_block kernel_offset_notifier = {
>> +	.notifier_call = dump_kernel_offset
>> +};
>> +
>> +static int __init register_kernel_offset_dumper(void)
>> +{
>> +	atomic_notifier_chain_register(&panic_notifier_list,
>> +					&kernel_offset_notifier);
>> +	return 0;
>> +}
>> +__initcall(register_kernel_offset_dumper);
>>
> 
> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
> kdump? Anyway, kdump related tools now calculate phys_base from memory map
> information passed as ELF PT_LOAD entries like below.

Another simpler way is to print this information at boot time, not at panic.

-- 
Thanks.
HATAYAMA, Daisuke
