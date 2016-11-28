Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 28 Nov 2016 14:50:55 -0500
From: Jessica Yu <jeyu@redhat.com>
Message-ID: <20161128195055.GC24161@packer-debian-8-amd64.digitalocean.com>
References: <95e7fd98-c477-0c8a-7195-932e04bba9bb@fau.de>
 <20161128091830.GB23034@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20161128091830.GB23034@linaro.org>
Subject: [kernel-hardening] Re: module: extend 'rodata=off' boot cmdline parameter to module
 mappings
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Andreas Ziegler <andreas.ziegler@fau.de>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

+++ AKASHI Takahiro [28/11/16 18:18 +0900]:
>On Mon, Nov 28, 2016 at 08:59:40AM +0100, Andreas Ziegler wrote:
>> Hi Akashi,
>>
>> your patch "module: extend 'rodata=off' boot cmdline parameter to module
>> mappings" showed up in linux-next today, and I noticed a small error in it.
>>
>> The first modified #ifdef is fine, the second one, however, has a spelling
>> mistake in it: the CONFIG_ variable should be CONFIG_DEBUG_SET_MODULE_RONX
>> instead of CONFIG_SET_MODULE_RONX (note the missing DEBUG).
>
>Thank you for pointing this out.
>(I didn't notice it because DEBUG_RODATA is always on on arm64.)
>
>Rusty, Jessica, should I submit v4 to correct it?

Andreas, Akashi -

The typo has been fixed with Arnd's patch:

   http://lkml.kernel.org/r/20161128145931.3350661-1-arnd@arndb.de

Thanks for finding the issue!

Jessica
