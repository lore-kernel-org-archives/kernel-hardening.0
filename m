References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten>
 <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
 <20170816211636.4zwublkvpn6hbo5n@smitten>
 <CAGXu5j+qe052JAcZUe7mOBHAXNCdLT1z4U-2kRxoeJXyL6VxDQ@mail.gmail.com>
 <20170817175807.ejgsrfdgojgbtkwf@smitten>
 <1d0963e6-4a89-9859-5379-8575a925ef08@linux.com>
 <20170920141309.gbrx53xahjmyrv6c@docker>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <a2f61f3d-9c94-f44f-32e3-9563ecccee89@linux.com>
Date: Thu, 21 Sep 2017 16:26:03 +0300
MIME-Version: 1.0
In-Reply-To: <20170920141309.gbrx53xahjmyrv6c@docker>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 20.09.2017 17:13, Tycho Andersen wrote:
> On Wed, Sep 20, 2017 at 02:27:05PM +0300, Alexander Popov wrote:
>>> +/*
>>> + * Note that the way this test fails is kind of ugly; it hits the BUG() in
>>> + * track_stack, but then the BUG() handler blows the stack and hits the stack
>>> + * guard page.
>>> + */
>>
>> Yes, actually, the reason is deeper.
>>
>> When there are less than (THREAD_SIZE / 16) bytes left in the kernel stack, the
>> BUG() in track_stack() is hit. But do_error_trap(), which handles the invalid
>> opcode, has a big stack frame. So it is instrumented by the STACKLEAK gcc plugin
>> and itself calls track_stack() at the beginning. Hence we have a recursive
>> BUG(), which eventually hits the guard page.
>>
>> I banned the instrumentation of do_error_trap() in the plugin, but it didn't
>> really help, since there are several other instrumented functions called during
>> BUG() handling.
>>
>> So it seems to me that this BUG() in track_stack() is really useless and can be
>> dropped. Moreover:
>>  - it is not a part of the PaX patch;
>>  - it never worked in Grsecurity kernel because of the error spotted by Tycho.
>>
>> What do you think about it?
> 
> We'll only have a stack guard page in the case of vmap stack, so maybe

Thanks, that's an important aspect.

> we can do:
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 8333c4dce59b..8351369cd1e4 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1960,7 +1960,8 @@ void __used track_stack(void)
>  		current->thread.lowest_stack = sp;
>  	}
>  
> -	if (unlikely((sp & (THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
> +	if (!IS_ENABLED(CONFIG_VMAP_STACK) &&
> +	    unlikely((sp & (THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
>  		BUG();
>  }
>  EXPORT_SYMBOL(track_stack);

In that case the recursive BUG() in track_stack() will happen anyway. You know,
I would better make CONFIG_GCC_PLUGIN_STACKLEAK depend on CONFIG_VMAP_STACK.

> Anyway, thanks for the reviews, I'll post an updated version shortly.

You're welcome.

Best regards,
Alexander
