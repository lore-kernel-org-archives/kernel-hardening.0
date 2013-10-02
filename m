Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524B7179.7040104@jp.fujitsu.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-7-git-send-email-keescook@chromium.org>
	<524B6AEE.90301@jp.fujitsu.com>
	<524B7179.7040104@jp.fujitsu.com>
Date: Wed, 2 Oct 2013 00:51:28 -0700
Message-ID: <CAGXu5jLZw-D7vnsKV8U27o+XWL7gfqbF0AUSmBvjV6JBLJk85w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 1, 2013 at 6:06 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/10/02 9:38), HATAYAMA Daisuke wrote:
>> (2013/10/02 4:37), Kees Cook wrote:
> <cut>
>>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>>    }
>>>
>>>    #endif /* CONFIG_X86_32 */
>>> +
>>> +static struct notifier_block kernel_offset_notifier = {
>>> +    .notifier_call = dump_kernel_offset
>>> +};
>>> +
>>> +static int __init register_kernel_offset_dumper(void)
>>> +{
>>> +    atomic_notifier_chain_register(&panic_notifier_list,
>>> +                                    &kernel_offset_notifier);
>>> +    return 0;
>>> +}
>>> +__initcall(register_kernel_offset_dumper);
>>>
>>
>> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
>> kdump? Anyway, kdump related tools now calculate phys_base from memory map
>> information passed as ELF PT_LOAD entries like below.
>
> Another simpler way is to print this information at boot time, not at panic.

No, since a dump may happen temporally far enough away from boot time
that the offset would not be contained in the dmesg buffers any more.
The offset report needs to be part of the panic message, especially
for those using pstore (e.g. Chrome OS0 for crash reporting (which
includes only the panic log contents).

-Kees

-- 
Kees Cook
Chrome OS Security
