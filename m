Reply-To: kernel-hardening@lists.openwall.com
From: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20161125054822.GA2793@packer-debian-8-amd64.digitalocean.com>
References: <20161114061505.15238-1-takahiro.akashi@linaro.org> <20161125054822.GA2793@packer-debian-8-amd64.digitalocean.com>
Date: Mon, 28 Nov 2016 10:30:53 +1030
Message-ID: <8760n88ocq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: module: extend 'rodata=off' boot cmdline parameter to module mappings
To: Jessica Yu <jeyu@redhat.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: mark.rutland@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jessica Yu <jeyu@redhat.com> writes:

> +++ AKASHI Takahiro [14/11/16 15:15 +0900]:
>>The current "rodata=off" parameter disables read-only kernel mappings
>>under CONFIG_DEBUG_RODATA:
>>    commit d2aa1acad22f ("mm/init: Add 'rodata=off' boot cmdline parameter
>>    to disable read-only kernel mappings")
>>
>>This patch is a logical extension to module mappings ie. read-only mappings
>>at module loading can be disabled even if CONFIG_DEBUG_SET_MODULE_RONX
>>(mainly for debug use). Please note, however, that it only affects RO/RW
>>permissions, keeping NX set.
>>
>>This is the first step to make CONFIG_DEBUG_SET_MODULE_RONX mandatory
>>(always-on) in the future as CONFIG_DEBUG_RODATA on x86 and arm64.
>>
>>Suggested-by: and Acked-by: Mark Rutland <mark.rutland@arm.com>
>>Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>Reviewed-by: Kees Cook <keescook@chromium.org>
>>Cc: Rusty Russell <rusty@rustcorp.com.au>
>
> Hi Rusty, could I get an (n)ack for this patch? :-)

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
